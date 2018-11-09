//
//  CloudDiskAppFileParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/14.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-14
 Version: 1.0
 Description: 云盘文件
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "CloudDiskAppFileParse.h"
#import "ResModel.h"
#import "ResDAL.h"
#import "ResFolderDAL.h"
#import "NSString+IsNullOrEmpty.h"
#import "EventBus.h"
#import "EventPublisher.h"
#import "ResBagDAL.h"
#import "ResHistoryVersionDAL.h"
#import "ResFolderModel.h"
#import "NetDiskIndexViewModel.h"

@interface CloudDiskAppFileParse()<EventSyncPublisher>
{
    BOOL isDeleteLocalData;
}


@end

@implementation CloudDiskAppFileParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CloudDiskAppFileParse *)shareInstance{
    static CloudDiskAppFileParse *instance = nil;
    if (instance == nil) {
        instance = [[CloudDiskAppFileParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    if([route isEqualToString:WebApi_CloudDiskFile_List]){
        [self parseFileList:dataDic];
    }
    /* 添加资源 */
    else if( [route isEqualToString:WebApi_CloudDiskFile_AddResource] ){
        [self parseAddResource:dataDic];
    }
    /* 保存至网盘 */
    else if( [route isEqualToString:WebApi_CloudDiskFile_SaveToCloudDisk]){
        [self parseSaveToCloudDisk:dataDic];
    }
    else if ([route isEqualToString:WebApi_CloudDiskFile_SaveToNetDiskNOVersion]) {
        [self parseSaveToDiskNoVersion:dataDic];
    }
    /* 文件的删除 */
    else if ([route isEqualToString:WebApi_CloudDiskFile_DelResource]){
        [self parseDelResource:dataDic];
    }
    /* 文件 重命名 */
    else if ([route isEqualToString:WebApi_CloudDiskFile_ReNameResource]
             || [route isEqualToString:WebApi_CloudDiskFile_EditResourceInfo]) {
        [self parseReNameRes:dataDic];
    }
    /* 文件 详情信息*/
    else if ([route isEqualToString:WebApi_CloudDiskFile_GetResourceDetails]) {
        [self parseResourceDetails:dataDic];
    }
    /* 文件夹 详情信息*/
    else if ([route isEqualToString:WebApi_CloudDiskFilDe_GetFolderDetails]) {
        [self parseFolderDetails:dataDic];
    }
    /* 文件 移动 */
    else if ([route isEqualToString:WebApi_CloudDiskFile_EditResourceFolder]) {
        [self parseFileMove:dataDic];
    }
    /* 文件历史版本 */
    else if ([route isEqualToString:WebApi_CloudDiskFile_Versionall]) {
        [self parseFileVersion:dataDic];
    }
    /* 文件的版本升级*/
    else if ([route isEqualToString:WebApi_CloudDiskFile_UpgradeResource]) {
        [self parseFileUpgrade:dataDic];
    }
    /* 覆盖此版本 */
    else if ([route isEqualToString:WebApi_CloudDiskFile_ReplaceResource]) {
        [self parseReplaceFile:dataDic];
    }
    /* 获取文件包里面的文件 */
    else if ([route isEqualToString:WebApi_CloudDiskFile_getBagInfo]) {
        [self parseBagDataSource:dataDic];
    }
    /* 获取文件包里面的文件 带版本的 */
    else if ([route isEqualToString:WebApi_ClouDiskFile_GetHaveVersionBag]) {
        [self parseBagDataSource:dataDic];
    }
    /* 混合下载 */
    else if ( [route isEqualToString:WebApi_CloudDiskFile_MixDownload] ){
        [self parseMixDownload:dataDic];
    }
    /* 获取文件信息 */
    else if ([route isEqualToString:WebApi_CloudDiskFile_GetResInfo]) {
        [self parseResourceInfo:dataDic];
    }
    /* 获取文件信息，版本 */
    else if( [route isEqualToString:WebApi_CloudDiskFile_GetResVersionInfo] ){
        [self parseResourceVersionInfo:dataDic];
    }
    /* 获取文件信息，资源项 */
    else if( [route isEqualToString:WebApi_CloudDiskFile_GetResInfoModelOrItem] ){
        [self parseResourceInfoModelOrItem:dataDic];
    }
    /* 获取文件信息，资源项，版本 */
    else if( [route isEqualToString:WebApi_CloudDiskFile_GetResVersionInfoModelOrItem] ){
        [self parseResourceVersionInfoModelOrItem:dataDic];
    }
    /* 根据expid获取文件信息 */
    else if ( [route isEqualToString:WebApi_CloudDiskFile_GetFileInfoWithExpid]) {
        [self parseGetFileinfo:dataDic];
    }
    /* 批量删除文件 */
    else if ([route isEqualToString:WebApi_CloudDisk_BatchDelete]) {
        [self parseBatchDelete:dataDic];
    }
    /* 文件替换  */
    else if ([route isEqualToString:WebApi_FileReplace_Replace]) {
        
        [self parseFileReplace:dataDic];
    }

}

/**
 *  消息发送成功后，服务器端返回的数据
 */
-(void)parseFileList:(NSMutableDictionary *)dataDic{
       
    NSMutableArray *allFileArr = [[NSMutableArray alloc] init];
    
    /* 接收到服务器返回的数据 */
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *dataPost = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    /* 保存资源信息 */
    NSArray *fileListArr = [contextDic objectForKey:@"List"];
    ResModel *resModel = nil;

    for(int i=0;i<fileListArr.count;i++){
        NSMutableDictionary *fileDic = [fileListArr objectAtIndex:i];
        NSMutableDictionary *favoriteDic = [fileDic lzNSMutableDictionaryForKey:@"resourcefavorite"];
        NSInteger isFavorite = [[favoriteDic objectForKey:@"isfavorite"] integerValue];
        
        resModel = [[ResModel alloc] init];
        [resModel serializationWithDictionary:fileDic];
        resModel.descript = [fileDic objectForKey:@"description"];
        
        resModel.isfavorite = isFavorite;
        resModel.favoritesDic = [NSMutableDictionary dictionaryWithDictionary:favoriteDic];
        [allFileArr addObject:resModel];
        
    }
    
    // 只让第一次进来把网盘存本地的全都删掉上拉加载的时候就不删了 一页只清一次
    // 获取云盘文件rpid
    if (self.appDelegate.lzGlobalVariable.isDeleteLocalData) {
        NSLog(@"删除云盘文件");
        [[ResDAL shareInstance] deleteAllResWithClassid:[dataPost lzNSStringForKey:@"classid"]];
        self.appDelegate.lzGlobalVariable.isDeleteLocalData = NO;
    }
    
    [[ResDAL shareInstance] addDataWithArray:allFileArr];
    
    /* 发送的消息数据 */
    NSMutableDictionary *sendData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Post];
    NSInteger preTableViewCount = ((NSNumber *)[sendData objectForKey:@"currentnumber"]).integerValue; //获取数据之前TableView中资源数量
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:preTableViewCount] forKey:@"pre"];
    [dic setObject:[NSNumber numberWithInteger:allFileArr.count] forKey:@"add"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppFileParse * service = self;
        
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex, dic);
        
        /* 选择文件 */
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_NetFileSelectController, dic);
    });
}

/**
 *  添加资源后，服务器端返回的数据
 */
-(void)parseAddResource:(NSMutableDictionary *)dataDic{
    /* 发送的数据 */
    NSMutableDictionary *sendData = [dataDic objectForKey:WebApi_DataSend_Post];
    
    NSString *clienttempid = [sendData objectForKey:@"clienttempid"];
    NSString *key = [sendData objectForKey:@"key"];
    NSString *expid = [sendData objectForKey:@"fileids"];
   
    
    /* 接收到服务器返回的数据 */
    NSDictionary *fileDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSMutableDictionary *favoriteDic = [fileDic objectForKey:@"resourcefavorite"];
    NSInteger isFavorite = [[favoriteDic objectForKey:@"isfavorite"] integerValue];
    
//     NSString *rpid = [fileDic objectForKey:@"rpid"];
    
    ResModel *resModel1 = [[ResModel alloc] init];
    [resModel1 serializationWithDictionary:fileDic];
    
    ResModel *resModel = [[ResDAL shareInstance] getResModelWithResid:@"" orClientTempId:clienttempid];
    /* 聊天文件保存至云盘 */
    if(resModel==nil){
        resModel = [[ResModel alloc] init];
        [resModel serializationWithDictionary:fileDic];
        resModel.ismain = 1;
        resModel.iscurrentversion = 1;
        
        [[ResDAL shareInstance] addDataWithModel:resModel];
    }
    /* 上传文件 */
    else {
        [resModel serializationWithDictionary:fileDic];
        resModel.descript = [fileDic objectForKey:@"description"];
        resModel.uploadstatus = App_NetDisk_File_UploadSuccess;
        // 新上传的文件要标记下载状态 不然上传新的文件的时候下载不了
        resModel.downloadstatus = App_NetDisk_File_NoDownload;
        resModel.versionid = resModel.rid;
        //resModel.rpid = rpid;
        resModel.ismain = 1;
        resModel.iscurrentversion = 1;
        resModel.expid = expid;
        resModel.clienttempid = clienttempid;
        resModel.isfavorite = isFavorite;
        resModel.favoritesDic = [NSMutableDictionary dictionaryWithDictionary:favoriteDic];
        resModel.operateauthority = 1;
        /* 修改客户端数据 */
        [[ResDAL shareInstance] UpdateResWithClientID:resModel];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppFileParse * service = self;
        
        NSDictionary *otherData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
//        NSString *controllerStr = [otherData lzNSStringForKey:@"controller"];
        NSString *otherOperate = [otherData lzNSStringForKey:WebApi_DataSend_Other_Operate];
        
        if(![NSString isNullOrEmpty:otherOperate]){
            EVENT_PUBLISH_WITHDATA(service, otherOperate, nil);
        }
        else {
            if ([[otherData lzNSStringForKey:@"uploadFromNet"] isEqualToString:@"1"]) {
                
                EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_AddResourceFromNetDisk, resModel);
            }
            else{
                /* 发送 */
                NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
                [eventData setObject:resModel forKey:@"res"];
                [eventData setObject:key forKey:@"key"];
                
                // 还要通知一下协作里面的文件上传的控制器
                //if ([controllerStr isEqualToString:FileHandleController_NetDisk]) {
                    EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_AddResource, eventData);
               // }
               // else if ([controllerStr isEqualToString:FileHandleController_CooperationTaskFile]) {
                //    EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_NetAddResource, eventData);
                //}
                //else if ([controllerStr isEqualToString:FileHandleController_CooperationWorkFile]) {
                //    EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_GroupFile_NetAddResource, eventData);
                //}
                //            /* 基础协作文件上传成功 */
                //            else {
                //                EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_UploadFileSuccess, eventData);
                //
                //            }


            }
            
        }
    });
}

/**
 *  保存至网盘
 */
-(void)parseSaveToCloudDisk:(NSMutableDictionary *)dataDic{
    /* 接收到服务器返回的数据 */
//    __block CloudDiskAppFileParse * service = self;
    NSDictionary *otherData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *otherOperate = [otherData lzNSStringForKey:WebApi_DataSend_Other_Operate];
    
    if(![NSString isNullOrEmpty:otherOperate]){
      
    }
}
-(void)parseSaveToDiskNoVersion:(NSMutableDictionary*)dataDic {
    
    
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppFileParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFileController_Success, nil);
    });
    
}
/**
 *  文件的删除
 */
-(void)parseDelResource:(NSMutableDictionary *)dataDic {
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *isDelMore = [dataOther lzNSStringForKey:@"ResDelMore"];
    
    ResModel *fileModel = [[ResModel alloc] init];
    NSString *fileRid = [contextDic lzNSStringForKey:@"rid"];
    fileModel.rid = fileRid;
    
    [[ResDAL shareInstance] deleteResWithRid:fileModel.rid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        /* 通知批量删除界面 */
        if ([isDelMore isEqualToString:@"Yes"]) {
           

        }else {
            /* 通知界面 */
            __block CloudDiskAppFileParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_DelFile, fileModel);
        }
        
        
    });
}
/**
 *  文件重命名
 */
-(void)parseReNameRes:(NSMutableDictionary *)dataDic {
    /* 接收到服务器返回的数据 */
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    //NSMutableDictionary *favoriteDic = [contextDic objectForKey:@"resourcefavorite"];
    
   // NSInteger isFavorite = [[favoriteDic objectForKey:@"isfavorite"] integerValue];
    
    ResModel *resfileModel = [[ResModel alloc] init];
    [resfileModel serializationWithDictionary:contextDic];
    resfileModel.descript = [contextDic lzNSStringForKey:@"description"];
   // resfileModel.isfavorite = isFavorite;
   // resfileModel.favoritesDic = [NSMutableDictionary dictionaryWithDictionary:favoriteDic];
    
    /* 更新数据库 */
    [[ResDAL shareInstance] addDataWithModel:resfileModel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CloudDiskAppFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, resfileModel);
    });
}
-(void)parseResourceDetails:(NSMutableDictionary*)dataDic {
    NSMutableDictionary *dataContext = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSDictionary *otherData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[otherData allKeys] containsObject:@"block"]) {
            SendApiSuccess getResInfoBlock = [otherData objectForKey:@"block"];
            getResInfoBlock(dataContext);
            return;
        }
    });
    
}
-(void)parseFolderDetails:(NSMutableDictionary*)dataDic {
    NSMutableDictionary *dataContext = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSDictionary *otherData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[otherData allKeys] containsObject:@"block"]) {
            SendApiSuccess getResInfoBlock = [otherData objectForKey:@"block"];
            getResInfoBlock(dataContext);
            return;
        }
    });
}

/**
 *  文件移动
 */
-(void)parseFileMove:(NSMutableDictionary *)dataDic {
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    ResModel *fileModel = [[ResModel alloc] init];
    NSArray *fileMArr = [contextDic lzNSArrayForKey:@"resourcemodels"];
    for (int i = 0; i < fileMArr.count; i ++) {
        NSDictionary *fileDic = [fileMArr objectAtIndex:i];
        
        [fileModel serializationWithDictionary:fileDic];
        fileModel.descript = [fileDic lzNSStringForKey:@"description"];
        
        /* 通过文件的rid 修改数据库里面的classID */
        [[ResDAL shareInstance] updateFileClassid:fileModel];
    }

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
          /* 通知界面 */
        __block CloudDiskAppFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFileController_Success, fileModel);
    });
}
/**
 *  获取文件历史版本
 */
-(void)parseFileVersion:(NSMutableDictionary *)dataDic {
    
    NSMutableArray *contextArray = [[NSMutableArray alloc] init];
    
    NSArray *array = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSDictionary *dataGet = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSString *rid = [dataGet lzNSStringForKey:@"rid"];
    
    for (int i = 0 ; i < [array count]; i++) {
        NSMutableDictionary *contextDic = [array objectAtIndex:i];
        
        ResModel *fileModel = [[ResModel alloc] init];
        /* 字典转model */
        [fileModel serializationWithDictionary:contextDic];
       
        NSString *updateData = [contextDic objectForKey:@"updatedate"];
        // 用数据库里面的
//        NSString *showsize = [contextDic objectForKey:@"showsize"];
       
        
        fileModel.createdate = [LZFormat String2Date:updateData];
//        fileModel.size = [showsize integerValue];
        
        [contextArray addObject:fileModel];
    }
   // 删除旧数据
    [[ResHistoryVersionDAL shareInstance] deleteHistoryVersionWithRid:rid];
    // 保存到数据库
    [[ResHistoryVersionDAL shareInstance] addDataWithArray:contextArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
         /* 通知界面 并把获取到的历史版本通知过去 */
        __block CloudDiskAppFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_FileVersion, contextArray);
    });
}
// 文件新版本
-(void)parseFileUpgrade:(NSMutableDictionary*)dataDic
{
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    NSMutableDictionary *favoriteDic = [contextDic objectForKey:@"resourcefavorite"];
    NSInteger isFavorite = [[favoriteDic objectForKey:@"isfavorite"] integerValue];

    
    ResModel *file = [[ResModel alloc] init];
    [file serializationWithDictionary:contextDic];
    file.isfavorite = isFavorite;
    file.favoritesDic = [NSMutableDictionary dictionaryWithDictionary:favoriteDic];
    file.descript = [contextDic lzNSStringForKey:@"description"];
    file.operateauthority = 1;
    // 更新数据库
    [[ResDAL shareInstance] UpdateUpgradeFileWithRid:file];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_UpgradeFile, file);
    });
 }
 // 覆盖此版本
-(void)parseReplaceFile:(NSMutableDictionary*)dataDic{
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    NSMutableDictionary *favoriteDic = [contextDic objectForKey:@"resourcefavorite"];
    NSInteger isFavorite = [[favoriteDic objectForKey:@"isfavorite"] integerValue];
    
    ResModel *file = [[ResModel alloc] init];
    [file serializationWithDictionary:contextDic];
    file.operateauthority = 1;
    file.isfavorite = isFavorite;
    file.favoritesDic = [NSMutableDictionary dictionaryWithDictionary:favoriteDic];
    file.descript = [contextDic objectForKey:@"description"];
    
    // 更新数据库
    [[ResDAL shareInstance] UpdateUpgradeFileWithRid:file];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_ReplaceFile, file);
    });
}
// 获取文件包里面的内容
-(void)parseBagDataSource:(NSMutableDictionary*)dataDic {
    
    NSMutableArray *contextArray = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSMutableArray *allResArray = [[NSMutableArray alloc] init];
     for (int i = 0; i < contextArray.count; i++) {
        ResModel *resModel = [[ResModel alloc] init];
        
        NSDictionary *resDic = [contextArray objectAtIndex:i];
        
        [resModel serializationWithDictionary:resDic];
        resModel.descript = [resDic objectForKey:@"description"];
         resModel.icon = [resDic objectForKey:@"icon"];
         resModel.iconurl = [resDic objectForKey:@"iconurl"];
         
         [allResArray addObject:resModel];
    }
    [[ResBagDAL shareInstance] deleteAllData];
    [[ResBagDAL shareInstance] addDataWithArray:allResArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_FileBagContext, allResArray);
    });
}
/**
 *  混合下载
 */
-(void)parseMixDownload:(NSMutableDictionary *)dataDic{
    NSString *context = [dataDic lzNSStringForKey:WebApi_DataContext];
    
    /* 去除换行 */
    context = [context stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_MixDownload, context);
    });
}
// 文件信息
- (void)parseResourceInfo:(NSMutableDictionary *)dataDic {
    NSArray *fileArray = [dataDic lzNSArrayForKey:WebApi_DataContext];
    ResModel *resModel = nil;
    for (int i = 0; i< fileArray.count; i++) {
        resModel = [[ResModel alloc] init];
        NSDictionary *fileDic = [fileArray objectAtIndex:i];
        [resModel serializationWithDictionary:fileDic];
        resModel.descript = [fileDic objectForKey:@"description"];
    }
    if (!(resModel.rid == nil)) {
        [[ResDAL shareInstance] addDataWithModel:resModel];
    }
    
    /* 回调处理 */
    NSMutableDictionary *otherData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
    if( [[otherData allKeys] containsObject:@"block"]){
        NetFileGetResInfo getResInfoBlock = [otherData objectForKey:@"block"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            getResInfoBlock(resModel);
        });
        return;
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskIndex_GetResourceInfo,resModel);
    });
}
// 文件信息，版本
-(void)parseResourceVersionInfo:(NSMutableDictionary *)dataDic {
    NSDictionary *fileDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    ResModel *resModel = [[ResModel alloc] init];
    [resModel serializationWithDictionary:fileDic];
//    if (!(resModel.rid == nil)) {
//        [[ResDAL shareInstance] addDataWithModel:resModel];
//    }
    
    /* 回调处理 */
    NSMutableDictionary *otherData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
    if( [[otherData allKeys] containsObject:@"block"]){
        NetFileGetResInfo getResInfoBlock = [otherData objectForKey:@"block"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            getResInfoBlock(resModel);
        });
        return;
    }
}
//文件信息，资源项
-(void)parseResourceInfoModelOrItem:(NSMutableDictionary *)dataDic {
    NSDictionary *fileDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    ResModel *resModel = [[ResModel alloc] init];
    [resModel serializationWithDictionary:fileDic];
    if (!(resModel.rid == nil)) {
        [[ResDAL shareInstance] addDataWithModel:resModel];
    }
    
    /* 回调处理 */
    NSMutableDictionary *otherData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
    if( [[otherData allKeys] containsObject:@"block"]){
        NetFileGetResInfo getResInfoBlock = [otherData objectForKey:@"block"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            getResInfoBlock(resModel);
        });
        return;
    }
}

//文件信息，资源项，版本
-(void)parseResourceVersionInfoModelOrItem:(NSMutableDictionary *)dataDic {
    NSDictionary *fileDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    ResModel *resModel = [[ResModel alloc] init];
    [resModel serializationWithDictionary:fileDic];
    if (!(resModel.rid == nil)) {
        [[ResDAL shareInstance] addDataWithModel:resModel];
    }
    
    /* 回调处理 */
    NSMutableDictionary *otherData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
    if( [[otherData allKeys] containsObject:@"block"]){
        NetFileGetResInfo getResInfoBlock = [otherData objectForKey:@"block"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            getResInfoBlock(resModel);
        });
        return;
    }
}
-(void)parseGetFileinfo:(NSMutableDictionary*)dataDic {
    
    NSDictionary *dataContext = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    ResModel *model = [[ResModel alloc] init];
    [model serializationWithDictionary:dataContext];
    model.exptype = [dataContext lzNSStringForKey:@"fileext"];
    model.expid = [dataContext lzNSStringForKey:@"fileid"];
    model.size = [[dataContext lzNSNumberForKey:@"filesize"] longLongValue];
    model.fileShowName = [NSString stringWithFormat:@"%@.%@",[dataContext lzNSStringForKey:@"filename"],model.exptype];
    model.name = [dataContext lzNSStringForKey:@"filename"];
    NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    if( [[dataOther allKeys] containsObject:@"block"]){
        NetFileGetResInfo getResInfoBlock = [dataOther objectForKey:@"block"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            getResInfoBlock(model);
        });
        return;
    }
}
// 批量删除
-(void)parseBatchDelete:(NSMutableDictionary*)dataDic {
    NSDictionary *postData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    NSString *folderidStr = [postData lzNSStringForKey:@"folderids"];
    NSArray * folderidArr = [AppUtils StringTransformArray:folderidStr];
    for (int i =0 ; i < folderidArr.count; i++) {
        [[ResFolderDAL shareInstance] deleteFolderWithClassid:[folderidArr objectAtIndex:i]];
    }
    
    NSString *fileidStr = [postData lzNSStringForKey:@"resourceids"];
    NSArray *fileidArr = [AppUtils StringTransformArray:fileidStr];
    for (int i = 0; i < fileidArr.count; i++) {
        [[ResDAL shareInstance] deleteResWithRid:[fileidArr objectAtIndex:i]];
    }
    __block CloudDiskAppFileParse *service2 = self;
    EVENT_PUBLISH_WITHDATA(service2, EventBus_App_Res_NetDiskIndex_DelMoreResoure, nil);
    
 }

-(void)parseFileReplace:(NSMutableDictionary*)dataDic {
    NSMutableDictionary *dic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSDictionary *postData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    
    if ([[postData allKeys] containsObject:@"successBlock"]) {
        FileReplaceBlock filerep = [postData objectForKey:@"successBlock"];
        filerep(dic);
    }
    
    
    
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
