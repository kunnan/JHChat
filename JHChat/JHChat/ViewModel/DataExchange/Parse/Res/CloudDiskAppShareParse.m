//
//  CloudDiskAppShareParse.m
//  LeadingCloud
//
//  Created by SY on 16/2/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CloudDiskAppShareParse.h"
#import "EventBus.h"
#import "EventPublisher.h"
#import "ResShareModel.h"
#import "ResShareDAL.h"
#import "ResShareItemModel.h"
#import "ResShareItemDAL.h"
@interface CloudDiskAppShareParse ()<EventSyncPublisher>

@end

@implementation CloudDiskAppShareParse

/**
 *  获取单一实例
 */
+(CloudDiskAppShareParse *)shareInstance {
    static CloudDiskAppShareParse *instance = nil;
    if (instance == nil) {
        instance = [[CloudDiskAppShareParse alloc] init];
    }
    return instance;
}

/**
 *  解析服务器传过来的数据
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic objectForKey:WebApi_Route];
    /* 文件分享列表 */
    if ([route isEqualToString:WebApi_CloudDiskAppOrganization_ShareList]) {
        [self praseShareList:dataDic];
    }
    /* 文件分享功能 */
    else if ([route isEqualToString:WebApi_CloudDiskShare_Share]){
        [self praseShareFile:dataDic];
    }
    /* 取消分享 */
    else if ([route isEqualToString:WebApi_CloudDiskShare_CancleShare]){
        [self praseCancelShare:dataDic];
    }
    /* 分享文件model信息(无密码) */
    else if ([route isEqualToString:WebApi_CloudDiskShare_GetShareModelInfo]){
        [self parseShareModelInfo:dataDic];
    }
    /* 分享文件model信息(密码)*/
    else if ([route isEqualToString:WebApi_CloudDiskShare_GetSharePawModelInfo]) {
        [self parseShareModelInfo:dataDic];
    }
    /* 获取分享文件夹model的信息 */
    else if ([route isEqualToString:WebApi_CloudDiskShare_GetShareFolderInfo]) {
        [self parseGetShareFolderInfo:dataDic];
    }
    else if ([route isEqualToString:WebApi_ResShareModel_GetShareModelInfo]
             || [route isEqualToString:WebApi_ResShareModel_GetSharePawModelInfo]) {
        
        [self parseGetShareModelInfo:dataDic];
    }
    /* 保存到网盘 */
    else if ([route isEqualToString:WebApi_CloudDiskShare_MoveToCloudDisk]) {
        [self parseSaveToNet:dataDic];
    }
}
/* 文件分享列表 */
-(void)praseShareList:(NSMutableDictionary*)dataDic{
    
    NSMutableArray *allShareArr = [[NSMutableArray alloc] init];
    /* 接收到服务器返回的数据*/
    NSArray *contexArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
    /* 保存资源信息 */
    //NSArray *fileListArr = [contextDic objectForKey:@"List"];
    for (int i = 0 ; i < [contexArr count]; i++) {
        NSMutableDictionary *fileDic = [contexArr objectAtIndex:i];
        
        ResShareModel *shareModel = [[ResShareModel alloc] init];
        [shareModel serializationWithDictionary:fileDic];
        shareModel.sharelink = [fileDic lzNSStringForKey:@"link"];
        [allShareArr addObject:shareModel];
    }
    
    NSDictionary *otherData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    // 不是下拉的情况才删库
    if ([otherData allKeys].count == 0 || ![[otherData lzNSStringForKey:@"isPullUp"] isEqualToString:@"1"]) {
        // 入库之前先全部删除
        [[ResShareDAL shareInstance] deleteAllShareFile];
    }
    /* 把数据放到本地数据库 */
    [[ResShareDAL shareInstance] addShareDataWithArray:allShareArr];
    
    /* 发送的消息数据 */
    NSMutableDictionary *sendData = [dataDic objectForKey:WebApi_DataSend_Post];
    NSDictionary *sbDic = [sendData lzNSDictonaryForKey:@"sbpmodel"];
    NSInteger perTableViewCount = ((NSNumber *)[sbDic objectForKey:@"currentnumber"]).integerValue;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    /* 当前开始的数据 和 每次api返回的数据总和 */
    [dic setObject:[NSNumber numberWithInteger:perTableViewCount] forKey:@"pre"];
    [dic setObject:[NSNumber numberWithInteger:allShareArr.count] forKey:@"add"];
//    [dic setObject:[NSNumber numberWithInteger:alldataNum] forKey:@"allcount"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppShareParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskIndex_ResShare, dic);
    });
 }
/* 文件分享 */
-(void)praseShareFile:(NSMutableDictionary*)dataDic{
    
    NSMutableDictionary *contextData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
   
    ResShareModel *shareModel = [[ResShareModel alloc] init];
    
    [shareModel serializationWithDictionary:contextData];
    shareModel.sharelink = [contextData objectForKey:@"link"];
    [[ResShareDAL shareInstance] addShareDataWithModel:shareModel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppShareParse * service = self;
        // 把model传过去 好用里面的链接
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskShare_Share, shareModel);
    });
}
/* 取消分享 */
-(void)praseCancelShare:(NSMutableDictionary*)dataDic {
    
        // 得到要取消分享的id
    NSMutableDictionary *dataGet = [dataDic objectForKey:WebApi_DataSend_Get];
    NSString *shareid = [dataGet objectForKey:@"shareid"];
       //更新库
    [[ResShareDAL shareInstance] deleteCancelShareFile:shareid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppShareParse * service = self;
        // 把model传过去 好用里面的链接
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskShare_CancelShare, shareid);
    });
}
// 获取分享过后的文件model
-(void)parseShareModelInfo:(NSMutableDictionary*)dataDic {
    NSMutableArray *shareItemArray = [NSMutableArray array];
    
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    // 无密码
    NSMutableDictionary *shareModelDic = nil;
    if ([[contextDic lzNSStringForKey:@"status"] isEqualToString:@"2"]) {
        // 分享文件的信息 （缺少密码）
        NSMutableDictionary *contentDic = [contextDic lzNSMutableDictionaryForKey:@"content"];
        // 分享文件的items
        NSArray *itemArray = [contentDic lzNSArrayForKey:@"childitems"];
        
        for (int i = 0; i < itemArray.count; i++) {
            NSDictionary *itemDic = [itemArray objectAtIndex:i];
            
            ResShareItemModel *shareItemModel = [[ResShareItemModel alloc] init];
            [shareItemModel serializationWithDictionary:itemDic];
            [shareItemArray addObject:shareItemModel];
        }
        
        ResShareModel *shareModel = [[ResShareModel alloc] init];
        [shareModel serializationWithDictionary:contentDic];
        
        shareModel.sharelink = [contentDic objectForKey:@"link"];
        [[ResShareDAL shareInstance] addShareDataWithModel:shareModel];
        // 入库之前先全部删除 
        [[ResShareItemDAL shareInstance] deleteAllShareFile];
        [[ResShareItemDAL shareInstance] addShareItemsWithArray:shareItemArray];
        
        shareModelDic = [[NSMutableDictionary alloc] init];
        
        [shareModelDic setObject:shareItemArray forKey:@"shareitemarray"];
        [shareModelDic setObject:shareModel forKey:@"sharemodel"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CloudDiskAppShareParse * service = self;
            // 把model传过去 好用里面的链接
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskShare_ShareModelInfo, shareModelDic);
        });
    }
    else if ([[contextDic lzNSStringForKey:@"status"] isEqualToString:@"1"]) {
        // 让其输入密码 密码错误也是1
        NSString *status = [contextDic lzNSStringForKey:@"status"];
        // 分享文件的信息 如果为空就是密码输入错误
        NSMutableDictionary *contentDic = [contextDic lzNSMutableDictionaryForKey:@"content"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:status forKey:@"status"];
        [dic setObject:contentDic forKey:@"content"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CloudDiskAppShareParse * service = self;
            // 把model传过去 好用里面的链接
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskShare_InputPassword, dic);
        });
    }
    else if ([[contextDic lzNSStringForKey:@"status"] isEqualToString:@"0"]) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CloudDiskAppShareParse * service = self;
            // 把model传过去 好用里面的链接
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskShare_ShareNotExist, nil);
        });
    }
}
-(void)parseGetShareFolderInfo:(NSMutableDictionary*)dataDic {
    
    NSMutableArray *dataContextArray = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    for (int i = 0; i < dataContextArray.count; i++) {
        NSDictionary *shareitemDic = [dataContextArray objectAtIndex:i];
        ResShareItemModel *itemModel = [[ResShareItemModel alloc] init];
        [itemModel serializationWithDictionary:shareitemDic];
        [itemArray addObject:itemModel];
    }
    [[ResShareItemDAL shareInstance] addShareItemsWithArray:itemArray];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppShareParse * service = self;
        // 把model传过去 好用里面的链接
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskShare_GetShareItemInfo, itemArray);
    });
}
-(void)parseGetShareModelInfo:(NSMutableDictionary*)dataDic {
    NSDictionary *dataCon = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSString *rpid = [dataCon lzNSStringForKey:@"rpid"];
    ResShareModel *resModel = [[ResShareModel alloc] init];
    
    NSDictionary *shareDic = [dataCon lzNSDictonaryForKey:@"content"];
    [resModel serializationWithDictionary:shareDic];
    resModel.rpid = rpid;
    
    NSMutableArray *allshareItemArr = [[NSMutableArray alloc] init];
    NSArray *shareItemArr  =[shareDic lzNSArrayForKey:@"childitems"];
    for ( int i = 0; i < shareItemArr.count; i++) {
        NSDictionary *shareItemDic = [shareItemArr objectAtIndex:i];
        ResShareItemModel *itemModel = [[ResShareItemModel alloc] init];
        [itemModel serializationWithDictionary:shareItemDic];
        [allshareItemArr addObject:itemModel];
    }
    
    NSMutableDictionary *dic  = [[NSMutableDictionary alloc] init];
    [dic setValue:resModel forKey:@"sharemodel"];
    [dic setValue:allshareItemArr forKey:@"itemarray"];
    
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppShareParse * service = self;
        // 把model传过去 好用里面的链接
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskShare_GetShareModelInfo, dic);
    });
}
-(void)parseSaveToNet:(NSMutableDictionary*)dataDic {

    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    NSArray *itemArr = [dic lzNSArrayForKey:@"childitems"];
    ResShareItemModel *itemModel = [[ResShareItemModel alloc] init];
    NSDictionary * itemDic = nil;
    for (int i = 0; i < itemArr.count; i++) {
       itemDic = [itemArr objectAtIndex:i];
        [itemModel serializationWithDictionary:itemDic];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppShareParse * service = self;
        // 把model传过去 好用里面的链接
        EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFileController_Success, itemModel);
    });
}

#pragma mark -
#pragma mark - 解析数据(服务器返回的ErrorCode非0)

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic{
    
}

@end
