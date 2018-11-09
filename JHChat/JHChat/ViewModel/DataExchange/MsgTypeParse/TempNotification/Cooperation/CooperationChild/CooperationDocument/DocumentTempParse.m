//
//  DocumentTempParse.m
//  LeadingCloud
//
//  Created by SY on 16/5/12.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-05-12
 Version: 1.0
 Description: 临时消息--协作--文件
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "DocumentTempParse.h"
#import "ResDAL.h"
#import "ResFolderDAL.h"
#import "NetDiskIndexViewModel.h"

@interface DocumentTempParse ()
{
    
    NetDiskIndexViewModel *fileViewModel;
}
@end
@implementation DocumentTempParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(DocumentTempParse *)shareInstance{
    static DocumentTempParse *instance = nil;
    if (instance == nil) {
        instance = [[DocumentTempParse alloc] init];
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
    fileViewModel = [[NetDiskIndexViewModel alloc] init];
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    
    /* 文件删除 */
    if([handlertype isEqualToString:Handler_Cooperation_Document_Resource_Delete]){
        isSendReport = [self deleteResParse:dataDic];
    }
    /* 新增资源 */
    else if ([handlertype isEqualToString:Handler_Cooperation_Document_Resource_Insert]){
        isSendReport = [self insertResParse:dataDic];
        
    }
    /* 资源修改 */
    else if ([handlertype isEqualToString:Handler_Cooperation_Document_Resource_Update]) {
        isSendReport = [self updataResParse:dataDic];
    }
    /* 资源移动 */
    else if ([handlertype isEqualToString:Handler_Cooperation_Document_Resource_Move]) {
        isSendReport  =[self moveResParse:dataDic];
    }
    /* 新增文件夹 */
    else if ([handlertype isEqualToString:Handler_Cooperation_Document_Folder_Insert]) {
        isSendReport = [self insertFolderParse:dataDic];
    }
    /* 删除文件夹 */
    else if ([handlertype isEqualToString:Handler_Cooperation_Document_Folder_Delete]) {
        isSendReport = [self deleteFolderParse:dataDic];
    }
    /* 文件夹修改 */
    else if ([handlertype isEqualToString:Handler_Cooperation_Document_Folder_Update]) {
        isSendReport = [self updataFolderParse:dataDic];
    }
    /* 文件夹移动 */
    else if ([handlertype isEqualToString:Handler_Cooperation_Document_Folder_Move]) {
        isSendReport  =[self moveFolderParse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}
// 删除
-(BOOL)deleteResParse:(NSMutableDictionary*)dataDic {
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
    
    ResModel *resModel = [[ResDAL shareInstance] getResModelWithResid:[body objectForKey:@"itemid"]];
    [[ResDAL shareInstance] deleteResWithRid:resModel.rid];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block DocumentTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Document_DelRes, resModel);
    });

    return YES;
}
// 添加资源
-(BOOL)insertResParse:(NSMutableDictionary*)dataDic {
    // 再获取文件信息
    NSDictionary *body = [dataDic objectForKey:@"body"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block DocumentTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Document_Notice_Resource, body);
    });

    // 先用工作组里面的
//    [fileViewModel getUploadRescourceInfo:[body objectForKey:@"itemid"]];
    
    return YES;
}
// 修改资源
-(BOOL)updataResParse:(NSMutableDictionary*)dataDic {
     NSDictionary *body = [dataDic objectForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block DocumentTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Document_Notice_Resource, body);
    });
    // 先用工作组里面的
//    [fileViewModel getUploadRescourceInfo:[body objectForKey:@"itemid"]];
    
    
    return YES;
}
// 资源移动
-(BOOL)moveResParse:(NSMutableDictionary*)dataDic {
    // 在获取文件信息
    NSDictionary *body = [dataDic objectForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block DocumentTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Document_Notice_Resource, body);
    });
//    [fileViewModel getUploadRescourceInfo:[body objectForKey:@"itemid"]];
    
    return YES;
}
// 删除文件夹
-(BOOL)deleteFolderParse:(NSMutableDictionary*)dataDic {
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
    ResFolderModel *folder = [[ResFolderDAL shareInstance] getFolderModelWithClassid:[body objectForKey:@"itemid"]];
    [[ResFolderDAL shareInstance] deleteFolderWithClassid:folder.classid];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block DocumentTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Document_DelFolder, folder);
    });
    return YES;
}
// 新建文件夹
-(BOOL)insertFolderParse:(NSMutableDictionary*)dataDic {
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
//    // 获取文件夹信息
//    [fileViewModel getFolderInfo:[body objectForKey:@"itemid"] partitiontype:[[body objectForKey:@"partitiontype"] integerValue] rpid:[body objectForKey:@"rpid"]];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block DocumentTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Document_Notice_Folder, body);
    });
    return YES;
}
// 修改文件夹
-(BOOL)updataFolderParse:(NSMutableDictionary*)dataDic {
    NSDictionary *body = [dataDic objectForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block DocumentTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Document_Notice_Folder, body);
    });
    // 获取文件夹信息
//    [fileViewModel getFolderInfo:[body objectForKey:@"itemid"] partitiontype:[[body objectForKey:@"partitiontype"] integerValue] rpid:[body objectForKey:@"rpid"]];
   
    return YES;
}
// 移动文件夹
-(BOOL)moveFolderParse:(NSMutableDictionary*)dataDic {
    NSDictionary *body = [dataDic objectForKey:@"body"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block DocumentTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Document_Notice_Folder, body);
    });
//    [fileViewModel getFolderInfo:[body objectForKey:@"itemid"] partitiontype:[[body objectForKey:@"partitiontype"] integerValue] rpid:[body objectForKey:@"rpid"]];
    
    
    return YES;
}
@end
