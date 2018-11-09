//
//  CloudDiskDocumentTempParse.m
//  LeadingCloud
//
//  Created by SY on 16/5/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-05-18
 Version: 1.0
 Description: 临时消息--云盘-我的文件
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "CloudDiskDocumentTempParse.h"
#import "NetDiskIndexViewModel.h"
#import "ResModel.h"
#import "ResFolderDAL.h"
#import "ResDAL.h"
@interface CloudDiskDocumentTempParse ()
{
    NetDiskIndexViewModel *netDiskViewModel;
}
@end
@implementation CloudDiskDocumentTempParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CloudDiskDocumentTempParse *)shareInstance{
    static CloudDiskDocumentTempParse *instance = nil;
    if (instance == nil) {
        instance = [[CloudDiskDocumentTempParse alloc] init];
    }
    return instance;
}
#pragma mark - 解析临时通知数据
/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    netDiskViewModel = [[NetDiskIndexViewModel alloc] init];
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    /* 删除 */
    if ([handlertype isEqualToString:Handler_CloudDiskApp_Normal_Delete]) {
        isSendReport = [self deleteDocumentParse:dataDic];
    }
    /* 新增 */
    else if ([handlertype isEqualToString:Handler_CloudDiskApp_Normal_Add]) {
        isSendReport = [self addDocumentParse:dataDic];
    }
    /* 更新 */
    else if ([handlertype isEqualToString:Handler_CloudDiskApp_Normal_Update]) {
        isSendReport = [self UpdateDocumentParse:dataDic];
    }
    /* 重命名*/
    else if ([handlertype isEqualToString:Handler_CloudDiskApp_Normal_UpdateName]) {
        isSendReport = [self UpdateNameDocumentParse:dataDic];
    }
    /* 移动 */
    else if ([handlertype isEqualToString:Handler_CloudDiskApp_Normal_Move]) {
         isSendReport = [self MoveDocumentParse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

// 删除
-(BOOL)deleteDocumentParse:(NSMutableDictionary*)dataDic
{
    NSDictionary *body = [dataDic objectForKey:@"body"];
    
    for (NSString *key in body) {
        // 文件夹
        if ([key isEqualToString:@"folderid"]) {
            [[ResFolderDAL shareInstance] deleteFolderWithClassid:[body objectForKey:key]];
        }
        // 文件
        if ([key isEqualToString:@"resourceid"]) {
            [[ResDAL shareInstance] deleteResWithRid:[body objectForKey:key]];
        }
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskDocumentTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CloudDisk_Notice_DeleteDoc, body);
    });
    return YES;
}
// 新增
- (BOOL)addDocumentParse:(NSMutableDictionary*)dataDic {
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
    NSString *add = nil;
    NSString *resID = nil;
    for (NSString *key in body) {
        if ([key isEqualToString:@"folderids"]) {
            add = EventBus_App_NetDiskIndex_Notice_AddFolder;
            resID = [body lzNSStringForKey:@"folderids"];
//            [netDiskViewModel getCloudDiskDocumentInfo:[body objectForKey:key]];
        }
        else if ([key isEqualToString:@"resourceids"]) {
            add = EventBus_App_NetDiskIndex_Notice_AddRes;
            resID = [body lzNSStringForKey:@"resourceids"];
//            [netDiskViewModel getCloudDiskResourceInfoWithRid:[body objectForKey:key] successBlock:nil];
        }
    }
//     /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskDocumentTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, add, resID);
    });
    
    return YES;
}
// 文件版本
- (BOOL)UpdateDocumentParse:(NSMutableDictionary*)dataDic {
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
    // 获取升级后的文件信息
//    [netDiskViewModel getCloudDiskResourceInfoWithRid:[body objectForKey:@"resourceid"] successBlock:nil];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskDocumentTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskIndex_Notice_AddRes, [body objectForKey:@"resourceid"]);
    });
    return YES;
}
// 重命名
- (BOOL)UpdateNameDocumentParse:(NSMutableDictionary*)dataDic {
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
    for (NSString *key in body) {
        // 文件夹
        if ([key isEqualToString:@"folderid"]) {
            [[ResFolderDAL shareInstance] updataFolderNam:[body objectForKey:@"name"] withClassid:[body lzNSStringForKey:key]];
        }
        // 文件
        if ([key isEqualToString:@"resourceid"]) {
            [[ResDAL shareInstance] updateResFileName:[body objectForKey:@"name"] withRid:[body lzNSStringForKey:key]];
        }

    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
         __block CloudDiskDocumentTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CloudDisk_Notice_updateName, body);
    });
    return YES;
}
// 移动
- (BOOL)MoveDocumentParse:(NSMutableDictionary*)dataDic {
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
    // 文件夹
    if ([[body objectForKey:@"newresourceids"] isEqualToString:@""]) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CloudDiskDocumentTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskIndex_Notice_AddFolder, [body objectForKey:@"newfolderids"]);
        });
    }
    // 文件
    if ([[body objectForKey:@"newfolderids"] isEqualToString:@""]) {
        ResModel *resModel = [[ResModel alloc] init];
        resModel.classid = [body objectForKey:@"newparentid"];
        resModel.rid = [body objectForKey:@"newresourceids"];
        [[ResDAL shareInstance] updateFileClassid:resModel];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CloudDiskDocumentTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_CloudDisk_Notice_Move, body);
        });
        
    }
    
    
    return YES;
}

@end
