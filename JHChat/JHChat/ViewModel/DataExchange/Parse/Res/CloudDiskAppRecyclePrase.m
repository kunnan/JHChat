//
//  CloudDiskAppRecyclePrase.m
//  LeadingCloud
//
//  Created by SY on 16/1/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  sy
 Date：   2016-01-29
 Version: 1.0
 Description: 云盘->回收站
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "CloudDiskAppRecyclePrase.h"
#import "ResModel.h"
#import "ResDAL.h"
#import "ResFolderDAL.h"
#import "NSString+IsNullOrEmpty.h"
#import "EventBus.h"
#import "EventPublisher.h"
#import "ResRecycleModel.h" //回收站model
#import "ResRecycleDAL.h"
@interface CloudDiskAppRecyclePrase ()<EventSyncPublisher>

@end
@implementation CloudDiskAppRecyclePrase

/**
 *  获取单一实例
 */
+(CloudDiskAppRecyclePrase *)shareInstance {
    static CloudDiskAppRecyclePrase *instance = nil;
    if (instance == nil) {
        instance = [[CloudDiskAppRecyclePrase alloc] init];
    }
    return instance;
}

/**
 *  解析服务器传过来的数据
 */
-(void)parse:(NSMutableDictionary *)dataDic {
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    if ([route isEqualToString:WebApi_CloudDiskAppOrganization_RecycleList]) {
        [self praseRecycleList:dataDic];
    }
    /* 删除回收站文件 */
    else if ([route isEqualToString:WebApi_CloudDiskRecycle_Del]) {
        [self praseDelRecycle:dataDic];
    }
    /* 还原文件 */
    else if ([route isEqualToString:WebApi_CloudDiskRecycl_Reduction]) {
        [self praseRedution:dataDic];
    }
    /* 清空回收站 */
    else if ([route isEqualToString:WebApi_CloudDiskRecycle_DelAll]) {
        [self parseDelAll:dataDic];
    }
}

/**
 *  消息发送成功后，服务器返回已删除的数据
 */
-(void)praseRecycleList:(NSMutableDictionary*)dataDic {
    
    NSMutableArray *allRecycleArr = [[NSMutableArray alloc] init];
    NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *otherStr  =[dataOther lzNSStringForKey:@"condition"];
    
    /* 接收到服务器返回的数据*/
    NSArray *contextDic = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSDictionary *classidDic = [dataDic objectForKey:WebApi_DataSend_Post];
    
    //NSInteger alldataNum = [[contextDic objectForKey:@"Count"] integerValue];
    /* 保存资源信息 */
    //NSArray *fileListArr = [contextDic lzNSArrayForKey:@"List"];
    for (int i = 0 ; i < [contextDic count]; i++) {
        NSMutableDictionary *fileDic = [contextDic objectAtIndex:i];
        
        ResRecycleModel *recycleModel = [[ResRecycleModel alloc] init];
        [recycleModel serializationWithDictionary:fileDic];
        recycleModel.name = [fileDic objectForKey:@"showname"];
        recycleModel.classid = [classidDic objectForKey:@"classid"];

        [allRecycleArr addObject:recycleModel];
        
    }
    if (![otherStr isEqualToString:@"上拉"]) {
        /* 先删后加 */
        [[ResRecycleDAL shareInstance] deleAllRecycleFile:nil];
    }
    /* 把数据放到本地数据库 */
    [[ResRecycleDAL shareInstance] addRecycleDataWithArray:allRecycleArr];
    
    /* 发送的消息数据 */
    NSMutableDictionary *sendData = [dataDic objectForKey:WebApi_DataSend_Post];
    NSDictionary *sbDic = [sendData lzNSDictonaryForKey:@"sbpmodel"];
    
    NSInteger perTableViewCount = [((NSNumber*)[sbDic objectForKey:@"currentnumber"]) integerValue] ;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    /* 当前开始的数据 和 每次api返回的数据总和 */
    [dic setObject:[NSNumber numberWithInteger:perTableViewCount] forKeyedSubscript:@"pre"];
    [dic setObject:[NSNumber numberWithInteger:allRecycleArr.count] forKeyedSubscript:@"add"];
    //[dic setObject:[NSNumber numberWithInteger:alldataNum] forKey:@"allcount"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppRecyclePrase * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Recycle_NetDiskIndex_RecycleList, dic);
    });
}
/**
 *  删除回收站文件
 *
 *  @param dataDic 服务器返回的数据
 */
-(void)praseDelRecycle:(NSMutableDictionary*)dataDic {
    /* 获取要删除的文件的id*/
    NSMutableDictionary *contextData = [dataDic objectForKey:WebApi_DataSend_Post];
    NSString *recyid = [contextData objectForKey:@"recyid"];
    
    ResRecycleModel *recycle = [[ResRecycleModel alloc] init];
    recycle.recyid = recyid;
    
    /* 删除本地 */
    [[ResRecycleDAL shareInstance] deleRecycleFile:recycle.recyid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 发送通知  */
        __block CloudDiskAppRecyclePrase *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Recycle_NetDiskIndex_Del, recycle);
    });
}

/**
 *  还原回收站文件
 *
 *  @param dataDic 服务器返回的数据
 */
-(void)praseRedution:(NSMutableDictionary*) dataDic {
    
    NSNumber *contextData = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSMutableDictionary *dataSend = [dataDic objectForKey:WebApi_DataSend_Post];
    NSInteger isSuccess = [contextData integerValue];
    // 还原回收站里的文件后 要把该文件插入到文件数据库中
    if (isSuccess) {
        NSString *recyid = [dataSend objectForKey:@"recyid"];
        [[ResRecycleDAL shareInstance] deleRecycleFile:recyid];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppRecyclePrase *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Recycle_NetDiskIndex_Reduction ,dataSend);
    });
}
// 清空回收站
-(void)parseDelAll:(NSMutableDictionary*)dataDic {
    
    
    NSString *isClearAll = [dataDic lzNSStringForKey:WebApi_DataContext];
    if (isClearAll) {
        [[ResRecycleDAL shareInstance] deleAllRecycleFile:nil];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppRecyclePrase *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Recycle_NetDiskIndex_Del ,nil);
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
