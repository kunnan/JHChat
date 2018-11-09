//
//  CooperationDocumentParse.m
//  LeadingCloud
//
//  Created by SY on 16/6/2.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooperationDocumentParse.h"
//文件
#import "ResFolderModel.h"
#import "ResModel.h"
#import "ResDAL.h"
#import "ResFolderDAL.h"
#import "LCProgressHUD.h"
#import "CooperationCommonModel.h"
#import "CoAppDAL.h"
#import "CooperationCouldRelationItem.h"
#import "CoTaskModel.h"
@interface CooperationDocumentParse()<EventSyncPublisher>
{
    NSString *folderRpid;
    NSString *parentid;
}
@end

@implementation CooperationDocumentParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationDocumentParse *)shareInstance{
    static CooperationDocumentParse *instance = nil;
    if (instance == nil) {
        instance = [[CooperationDocumentParse alloc] init];
    }
    return instance;
}
/**
 *  解析数据
 *
 *  @param dataDic
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    if ([route isEqualToString:WebApi_CloudCooperationTask_GetFile]) {
        [self parseFileList:dataDic withWebApi:WebApi_CloudCooperationTask_GetFile];
    }
    // 下级文件查看
    else if ([route isEqualToString:WebApi_CloudCooperationTask_GetNextResource]){
        
        [self parseNextFileList:dataDic];
    }
    // 添加文件夹
    else if ([route isEqualToString:WebApi_CloudCooperationTask_AddFolder]) {
        [self parseAddFolder:dataDic];
    }
    // 新增单个文件（发通知用）
    else if ([route isEqualToString:WebApi_CloudCooperationTask_UploadOneResource]){
        [self parseAddFile:dataDic];
    }
    // 文件夹重命名
    else if ([route isEqualToString:WebApi_CloudCooperationTask_UpdateFolderName]) {
        [self parseFolderName:dataDic];
    }
    // 文件重命名
    else if ([route isEqualToString:WebApi_CloudCooperationTask_ResourcesRename]) {
        [self parseFileName:dataDic];
    }
    // 删除文件夹
    else if ([route isEqualToString:WebApi_CloudCooperationTask_DelFolder]){
        [self parseDelFolder:dataDic];
    }
    // 删除文件
    else if ([route isEqualToString:WebApi_CloudCooperationTask_DelResources]){
        [self parseDelResource:dataDic];
    }
    // 批量删除
    else if ([route isEqualToString:WebApi_CloudCooperationTask_MixRemoveData]) {
        [self parseMixRemoveData:dataDic];
    }
    // 文件/文件夹的移动
    else if ([route isEqualToString:WebApi_CloudCooperationTask_MoveFile]){
        [self parseFileMove:dataDic];
    }
    
    // 获取文件信息
    else if ([route isEqualToString:WebApi_CloudCooperationtask_GetResourceInfo]){
        [self parseFileInfo:dataDic];
    }
    // 文件上传新版本成功之后调用
    else if ([route isEqualToString:WebApi_CloudCooperationTask_UpgradeResource]) {
        [self parseUpgradeRes:dataDic];
    }
    // 保存文件夹到云盘
    else if ([route isEqualToString:WebApi_CloudCooperationTask_CopyFolder]) {
        [self parseCopyFolder:dataDic];
    }
    // 文件上报时获取父任务列表
    else if ([route isEqualToString:WebApi_CloudCooperationTask_GetlistByTids]) {
        [self parseParendTaskList:dataDic];
    }
    // 文件下发全部
    else if ([route isEqualToString:WebApi_CloudCooperationTask_IssuedResourceToAll]) {
        [self parseIssuedAll:dataDic];
    }
   
    // 获取某个资源池下的文件夹
    else if ([route isEqualToString:WebApi_CloudCooperationTask_GetFolders]) {
        [self parseGetFolders:dataDic];
    }
    // 导入云盘文件
    else if ([route isEqualToString:WebApi_CloudCooperationTask_ImportNetResource]) {
        [self parseImportNetDisk:dataDic];
    }
    
    // 工作组文件解析
    // 一级文件
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroup_GetResource]){
        [self parseGroupFileList:dataDic withWebApi:WebApi_CloudCooperationWorkGroup_GetResource];
    }
    // 下级文件查看
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroup_GetNextPageRes]){
        [self praseNextFileList:dataDic];
        //        [self praseNextFileList:dataDic];
    }
    // 新增文件夹
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroup_AddFolder]) {
        [self parseGroupAddFolder:dataDic];
    }
    // 文件夹重命名
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroup_EditFolderName]) {
        [self parseEditeFolder:dataDic];
    }
    // 文件重命名
    else if ([route isEqualToString:WebApi_CloudCooperetionWorkGroup_EditResourceName]) {
        [self parseEditFile:dataDic];
    }
    // 删除文件夹
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroup_DelFolderContext]) {
        [self parseGroupDelFolder:dataDic];
    }
    // 删除文件
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroup_DelResource]) {
        [self parseGroupDelResource:dataDic];
    }
    // 混合删除（批量删除）
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroup_MixRemoveData]) {
        [self parseGroupMixRemoveData:dataDic];
    }
    // 文件夹的移动
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroup_Mobilefolder]) {
        [self parseFolderMove:dataDic];
    }
    // 获取文件夹信息
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroup_GetFolderInfo]) {
        
        [self parseGetFolderInfo:dataDic];
    }
    // 获取文件信息
    else if ([route isEqualToString:WebApi_CooperationBaseFile_GalleryResourceMainInfo]) {
        [self parseGetResourceInfo:dataDic];
    }
    // 文件上传
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroup_AddResourceForLogic]) {
        [self parseUploadFile:dataDic];
    }
    // 保存文件夹、文件到云盘
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroup_CopyFolderToNetDisk]) {
        [self parseCopyFolder:dataDic];
    }
    // 导入云盘文件
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroup_ImportNetDiskResource]) {
        [self parseImportNetDisk:dataDic];
    }
}
// 文件一级目录
-(void)parseFileList:(NSMutableDictionary *)dataDic withWebApi:(NSString*)api{
    
    NSMutableArray *folderAllArray = [[NSMutableArray alloc] init];
    NSMutableArray *fileAllArray = [[NSMutableArray alloc] init];
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    // 下拉刷新产生的数据
    NSDictionary *dataOtherDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *dataOther = [dataOtherDic lzNSStringForKey:@"CooFilePullDownRefresh"];
    // 一级文件夹
    NSArray *folderArray = [contextDic objectForKey:@"children"];
    // 一级文件目录
    NSArray *fileArray = [contextDic objectForKey:@"resourcemodels"];
    // 父文件夹
    ResFolderModel *rootFolder = [[ResFolderModel alloc] init];
    [rootFolder serializationWithDictionary:contextDic];
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    rootFolder.classid = classid;
    rootFolder.descript = description;
    
    // 把根文件夹加到数组
    [folderAllArray addObject:rootFolder];
    // 文件夹
    for (int i = 0; i < [folderArray count]; i++) {
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        NSDictionary *folderDic = folderArray[i];
        [folder serializationWithDictionary:folderDic];
        
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folder.classid = classid;
        folder.descript = description;
        folderRpid = folder.rpid;
        parentid = folder.parentid;
        [folderAllArray addObject:folder];
    }
    // 文件
    ResModel *file = nil;
    for (int i = 0; i < fileArray.count; i++) {
        file = [[ResModel alloc] init];
        NSDictionary *fileDic = fileArray[i];
        [file serializationWithDictionary:fileDic];
        file.descript = [fileDic objectForKey:@"description"];
        
        [fileAllArray addObject:file];
    
    }
    
    // 先删除本地一级数据
    [[ResFolderDAL shareInstance] deleteFolderWithPraentId:rootFolder.classid];
    // 得到一级文件夹包括根文件目录
    [[ResFolderDAL shareInstance] addDataWithArray:folderAllArray];
    
    // 先把一级文件删除
    if ([NSString isNullOrEmpty:dataOther] && !self.appDelegate.lzGlobalVariable.cooFileisNotDeleteLocalData) {
        [[ResDAL shareInstance] deleteAllResWithRpid:rootFolder.rpid withClassid:rootFolder.classid];
        self.appDelegate.lzGlobalVariable.cooFileisNotDeleteLocalData = NO;
    }
    // 得到一级文件目录
    [[ResDAL shareInstance] addDataWithArray:fileAllArray];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:folderAllArray forKey:@"folder"];
    [dic setObject:fileAllArray forKey:@"file"];
    [dic setObject:[NSNumber numberWithInteger:fileAllArray.count] forKey:@"fileNum"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_FileList, rootFolder);
    });
    
}
// 下级文件解析(应全部解析)
-(void)parseNextFileList:(NSMutableDictionary*)dataDic {
    
    NSMutableArray *folderAllArray = [[NSMutableArray alloc] init];
    NSMutableArray *fileAllArray = [[NSMutableArray alloc] init];
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext]; 
    // 下拉刷新产生的数据
    NSDictionary *dataOtherDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *dataOther = [dataOtherDic lzNSStringForKey:@"CooFilePullDownRefresh"];

    // 一级文件夹
    NSArray *folderArray = [contextDic objectForKey:@"children"];
    // 一级文件目录
    NSArray *fileArray = [contextDic objectForKey:@"resourcemodels"];
    // 父文件夹
    ResFolderModel *rootFolder = [[ResFolderModel alloc] init];
    [rootFolder serializationWithDictionary:contextDic];
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    rootFolder.classid = classid;
    rootFolder.descript = description;
    
    // 把根文件夹加到数组
    //[folderAllArray addObject:rootFolder];
    // 文件夹
    for (int i = 0; i < [folderArray count]; i++) {
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        NSDictionary *folderDic = folderArray[i];
        [folder serializationWithDictionary:folderDic];
        
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folder.classid = classid;
        folder.descript = description;
        folderRpid = folder.rpid;
        parentid = folder.parentid;
        [folderAllArray addObject:folder];
    }
    // 文件
    for (int i = 0; i < fileArray.count; i++) {
        ResModel *file = [[ResModel alloc] init];
        NSDictionary *fileDic = fileArray[i];
        [file serializationWithDictionary:fileDic];
        file.descript = [fileDic objectForKey:@"description"];
        
        [fileAllArray addObject:file];
        
    }
    // 先删除本地一级数据
    [[ResFolderDAL shareInstance] deleteFolderWithPraentId:rootFolder.classid];
    // 得到一级文件夹包括根文件目录
    [[ResFolderDAL shareInstance] addDataWithArray:folderAllArray];
    
    // 先删除文件
    if ([NSString isNullOrEmpty:dataOther] && !self.appDelegate.lzGlobalVariable.cooFileisNotDeleteLocalData) {
        [[ResDAL shareInstance] deleteAllResWithRpid:rootFolder.rpid withClassid:rootFolder.classid];
        self.appDelegate.lzGlobalVariable.cooFileisNotDeleteLocalData = NO;
    }
    
    // 得到一级文件目录
    [[ResDAL shareInstance] addDataWithArray:fileAllArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_FileList, rootFolder);
    });
}
// 添加文件夹
-(void)parseAddFolder:(NSMutableDictionary*)dataDic
{
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *dataGet = [dataDic objectForKey:WebApi_DataSend_Get];
    // 加资源池id
    NSString *rpid = [dataGet objectForKey:@"rpid"];
    ResFolderModel *folder = [[ResFolderModel alloc] init];
    [folder serializationWithDictionary:contextDic];
    folder.rpid = rpid;
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    folder.classid = classid;
    folder.descript = description;
    
    [[ResFolderDAL shareInstance] addDataWithResFolderModel:folder];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, folder);
    });
    
}
// 文件上传发通知用
-(void)parseAddFile:(NSMutableDictionary*)dataDic{
    
//    /* 在主线程中发送通知 */
//    dispatch_async(dispatch_get_main_queue(), ^{
//        /* 通知界面 */
//        __block CooperationDocumentParse *service = self;
//        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_AddOneFile, nil);
//    });
    
}
// 修改文件夹名
-(void)parseFolderName:(NSMutableDictionary*)dataDic
{
    NSMutableDictionary *contextDic  = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    ResFolderModel *resFolderModel = [[ResFolderModel alloc] init];
    [resFolderModel serializationWithDictionary:contextDic];
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    resFolderModel.classid = classid;
    resFolderModel.descript = description;
    
    // 更新数据库
    [[ResFolderDAL shareInstance] updataFolderName:resFolderModel.name andDescription:resFolderModel.descript withClassid:resFolderModel.classid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, resFolderModel);
    });
}
// 修改文件名
-(void)parseFileName:(NSMutableDictionary*)dataDic
{
    NSMutableDictionary *contextDic  = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    ResModel *resfileModel = [[ResModel alloc] init];
    [resfileModel serializationWithDictionary:contextDic];
    resfileModel.descript = [contextDic objectForKey:@"description"];
    /* 更新数据库 */
    [[ResDAL shareInstance] updateResFileName:resfileModel.name withRid:resfileModel.rid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, resfileModel);
    });
}
//删除文件夹
-(void)parseDelFolder:(NSMutableDictionary*)dataDic
{
    NSNumber *dataContext = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSDictionary *postData = [dataDic objectForKey:WebApi_DataSend_Post];
    
    NSInteger isSuccess = [dataContext integerValue];
    NSString *classid = [postData objectForKey:@"id"];
    if (isSuccess) {
        [[ResFolderDAL shareInstance] deleteFolderWithClassid:classid];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_DelFolder, classid);
    });
    
}
// 删除文件
-(void)parseDelResource:(NSMutableDictionary *)dataDic
{
    NSNumber *dataContext = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSInteger isSuccess = [dataContext integerValue];
    
    NSString *fileid = [dataDic objectForKey:WebApi_DataSend_Post];
    
    if (isSuccess) {
        [[ResDAL shareInstance] deleteResWithRid:fileid];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_DelFile, fileid);
    });
}
// 批量删除
-(void)parseMixRemoveData:(NSMutableDictionary*)dataDic {
    NSDictionary *postData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSString *folderidStr = [postData lzNSStringForKey:@"folderids"];
    NSString *fileidStr = [postData lzNSStringForKey:@"resourceids"];
    
    NSArray *folderidArray = [AppUtils StringTransformArray:folderidStr];
    NSArray *fileidArray = [AppUtils StringTransformArray:fileidStr];
    for (int i = 0; i < folderidArray.count; i++) {
        [[ResFolderDAL shareInstance] deleteFolderWithClassid:[folderidArray objectAtIndex:i]];
    }
    
    for ( int i = 0; i < fileidArray.count; i++) {
        [[ResDAL shareInstance] deleteResWithRid:[fileidArray objectAtIndex:i]];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_DelFile, nil);
//        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_DelFolder, nil);
    });
}
// 文件/文件夹的移动
-(void)parseFileMove:(NSMutableDictionary*)dataDic {
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    //NSDictionary *dataPost = [dataDic objectForKey:WebApi_DataSend_Post];
    
    
    //if ([[dataPost objectForKey:@"resourceids"] isEqualToString:@""]) {
        NSMutableArray *allRwsFolderArr = [[NSMutableArray alloc] init];
        NSMutableArray *folderModels = [contextDic objectForKey:@"foldermodels"];
        [self analyseMoveSource:folderModels withArray:allRwsFolderArr];
        // 更新移动过的文件
        [[ResFolderDAL shareInstance] addDataWithArray:allRwsFolderArr];
        
   //}
   // if ([[dataPost objectForKey:@"folderids"] isEqualToString:@""]) {
        ResModel *fileModel = [[ResModel alloc] init];
        NSMutableArray *resourceModels = [contextDic objectForKey:@"resourcemodels"];
        for (int i = 0; i < resourceModels.count; i ++) {
            
            NSDictionary *fileDic = [resourceModels objectAtIndex:i];
            
            [fileModel serializationWithDictionary:fileDic];
            fileModel.descript = [fileDic objectForKey:@"description"];
            
            [[ResDAL shareInstance] addDataWithModel:fileModel];
        }
        
    //}
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFileController_Success, nil);
    });
}

-(void)analyseMoveSource:(NSMutableArray *)contextArray withArray:(NSMutableArray *)allRwsFolderArr{
    
    for (int i = 0; i < contextArray.count; i++) {
        NSDictionary *folderDic = [contextArray objectAtIndex:i];
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        
        [folder serializationWithDictionary:folderDic];
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folder.classid = classid;
        folder.descript = description;
        folder.pinyin = [AppUtils transform:folder.name];
        [allRwsFolderArr addObject:folder];
        
        NSMutableArray *childArray = [folderDic objectForKey:@"children"];
        if (childArray != nil && [childArray count] > 0 ) {
            [self analyseMoveSource:childArray withArray:allRwsFolderArr];
        }
    }
}
// 获取文件信息
-(void)parseFileInfo:(NSMutableDictionary*)dataDic{
    
    NSMutableArray *contextDic = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSDictionary *dic = [contextDic objectAtIndex:0];
    ResModel *fileModel = [[ResModel alloc] init];
    [fileModel serializationWithDictionary:dic];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_GetResInfo, fileModel);
    });
}
// 文件升级版本
-(void)parseUpgradeRes:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    ResModel *file = [[ResModel alloc] init];
    [file serializationWithDictionary:contextDic];
    
    file.descript = [contextDic objectForKey:@"description"];
    
    // 更新数据库
    [[ResDAL shareInstance] UpdateUpgradeFileWithRid:file];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_UpgradeResource, file);
    });
}
// 文件夹保存到云盘
-(void)parseCopyFolder:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *contextDic = [dataDic objectForKey:WebApi_DataSend_Post];
    NSMutableDictionary *dataGet = [dataDic objectForKey:WebApi_DataSend_Get];
    
    NSString *saveToClassid = [dataGet objectForKey:@"folderid"];
    NSString *docId  =nil ;
    NSString *handlsTag = nil;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([[contextDic objectForKey:@"folderids"] isEqualToString:@""]) {
    
        docId = saveToClassid;
       handlsTag = @"file";
    }
    if ([[contextDic objectForKey:@"resourceids"] isEqualToString:@""]) {
      
        docId = [contextDic lzNSStringForKey:@"folderids"];
        handlsTag = @"folder";
    }
    [dic setValue:docId forKey:handlsTag];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFileController_Success, dic);
    });
    
}
// 上报
-(void)parseParendTaskList:(NSMutableDictionary*)dataDic {
    NSArray *dataArray = [dataDic lzNSArrayForKey:WebApi_DataContext];
    
    NSMutableArray *taskListArr = [[NSMutableArray alloc] init];
    for (int i =0 ; i< dataArray.count; i++) {
        NSDictionary *dic = [dataArray objectAtIndex:i];
        CoTaskModel *taskList = [[CoTaskModel alloc] init];
        [taskList serializationWithDictionary:dic];
        [taskListArr addObject:taskList];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_GetParentTaskList, taskListArr);
    });
}
-(void)parseIssuedAll:(NSMutableDictionary*)dataDic {
    NSNumber *data = [dataDic lzNSNumberForKey:WebApi_DataContext];
    if ([data boolValue]) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationDocumentParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_IsissueAllToChildTask, nil);
        });
    }
    
}

-(void)parseGetFolders:(NSMutableDictionary*)dataDic {
    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSMutableArray *allRwsFolderArr = [[NSMutableArray alloc] init];
    
    [self analyse:dic withArray:allRwsFolderArr];

    [[ResFolderDAL shareInstance] addDataWithArray:allRwsFolderArr];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Folder_GetFolders, allRwsFolderArr);
    });
}
-(void)analyse:(NSDictionary *)contextDic withArray:(NSMutableArray *)allRwsFolderArr{
    if([[contextDic allKeys] count]>0){
        
        ResFolderModel *resFolderModel = [[ResFolderModel alloc] init];
        [resFolderModel serializationWithDictionary:contextDic];
        folderRpid = resFolderModel.rpid;
        parentid = resFolderModel.parentid;
        NSString *classid = [contextDic objectForKey:@"id"];
        NSString *description = [contextDic objectForKey:@"description"];
        resFolderModel.classid = classid;
        resFolderModel.descript = description;
        //  文件排序用
        resFolderModel.pinyin = [AppUtils transform:resFolderModel.name];
        // 判断服务器返回的数据是否为空
        if( [contextDic objectForKey:@"rpid"] == [NSNull null]){
            NSString *rpid =[[LZUserDataManager readCurrentUserInfo] objectForKey:@"rpid"];
            resFolderModel.rpid = rpid;
        }
        
        [allRwsFolderArr addObject:resFolderModel];
        
        NSArray *childArray = [contextDic objectForKey:@"children"];
        if(childArray!=nil && [childArray count]>0){
            for(int i=0;i<childArray.count;i++){
                NSDictionary *dic = [childArray objectAtIndex:i];
                [self analyse:dic withArray:allRwsFolderArr];
            }
        }
    }
    
}
#pragma mark - 工作组文件解析
/*************************** 工作组文件 解析 ****************************************/
// 文件一级目录 一级一级的解析
-(void)parseGroupFileList:(NSMutableDictionary *)dataDic withWebApi:(NSString*)api{
    //  解析根目录 这样解析会再走一遍添加云盘文件到数据库？
    NSMutableArray *folderAllArray = [[NSMutableArray alloc] init];
    NSMutableArray *fileAllArray = [[NSMutableArray alloc] init];
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    // 下拉刷新产生的数据
    NSDictionary *dataOtherDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *dataOther = [dataOtherDic lzNSStringForKey:@"CooFilePullDownRefresh"];
    // 一级文件夹
    NSArray *folderArray = [contextDic objectForKey:@"children"];
    // 一级文件目录
    NSArray *fileArray = [contextDic objectForKey:@"resourcemodels"];
    // 父文件夹
    ResFolderModel *rootFolder = [[ResFolderModel alloc] init];
    [rootFolder serializationWithDictionary:contextDic];
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    rootFolder.classid = classid;
    rootFolder.descript = description;
    
    // 把根文件夹加到数组
    [folderAllArray addObject:rootFolder];
    // 文件夹
    for (int i = 0; i < [folderArray count]; i++) {
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        NSDictionary *folderDic = folderArray[i];
        [folder serializationWithDictionary:folderDic];
        
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folder.classid = classid;
        folder.descript = description;
        
        [folderAllArray addObject:folder];
    }
    // 文件
    for (int i = 0; i < fileArray.count; i++) {
        ResModel *file = [[ResModel alloc] init];
        NSDictionary *fileDic = fileArray[i];
        [file serializationWithDictionary:fileDic];
        file.descript = [fileDic objectForKey:@"description"];
        
        [fileAllArray addObject:file];
    }
    // 先删除本地一级数据
    [[ResFolderDAL shareInstance] deleteFolderWithPraentId:rootFolder.classid];
    // 得到一级文件夹包括根文件目录
    [[ResFolderDAL shareInstance] addDataWithArray:folderAllArray];
    
    // 先把一级文件删除
    if ([NSString isNullOrEmpty:dataOther] && !self.appDelegate.lzGlobalVariable.cooFileisNotDeleteLocalData) {
        [[ResDAL shareInstance] deleteAllResWithRpid:rootFolder.rpid withClassid:rootFolder.classid];
        self.appDelegate.lzGlobalVariable.cooFileisNotDeleteLocalData = NO;
    }
    // 得到一级文件目录
    [[ResDAL shareInstance] addDataWithArray:fileAllArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupFile_GetResource,rootFolder);
    });
}

/**
 *  下级文件解析
 */
-(void)praseNextFileList:(NSMutableDictionary *)dataDic {
    
    NSMutableArray *folderAllArray = [[NSMutableArray alloc] init];
    NSMutableArray *fileAllArray = [[NSMutableArray alloc] init];
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    // 下拉刷新产生的数据
    NSDictionary *dataOtherDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *dataOther = [dataOtherDic lzNSStringForKey:@"CooFilePullDownRefresh"];
    // 一级文件夹
    NSArray *folderArray = [contextDic objectForKey:@"children"];
    // 一级文件目录
    NSArray *fileArray = [contextDic objectForKey:@"resourcemodels"];
    // 父文件夹
    ResFolderModel *rootFolder = [[ResFolderModel alloc] init];
    [rootFolder serializationWithDictionary:contextDic];
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    rootFolder.classid = classid;
    rootFolder.descript = description;
    
    // 把根文件夹加到数组 已经在数组里面了为啥还要添加到库？
   // [folderAllArray addObject:rootFolder];
    // 文件夹
    for (int i = 0; i < [folderArray count]; i++) {
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        NSDictionary *folderDic = folderArray[i];
        [folder serializationWithDictionary:folderDic];
        
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folder.classid = classid;
        folder.descript = description;
        folderRpid = folder.rpid;
        parentid = folder.parentid;
        [folderAllArray addObject:folder];
    }
    // 文件
    for (int i = 0; i < fileArray.count; i++) {
        ResModel *file = [[ResModel alloc] init];
        NSDictionary *fileDic = fileArray[i];
        [file serializationWithDictionary:fileDic];
        file.descript = [fileDic objectForKey:@"description"];
        
        [fileAllArray addObject:file];
        
    }
    // 先删除本地一级数据
    [[ResFolderDAL shareInstance] deleteFolderWithPraentId:rootFolder.classid];
    // 得到一级文件夹包括根文件目录
    [[ResFolderDAL shareInstance] addDataWithArray:folderAllArray];
    
    // 先删除文件
    if ([NSString isNullOrEmpty:dataOther] && !self.appDelegate.lzGlobalVariable.cooFileisNotDeleteLocalData) {
         [[ResDAL shareInstance] deleteAllResWithRpid:rootFolder.rpid withClassid:rootFolder.classid];
        self.appDelegate.lzGlobalVariable.cooFileisNotDeleteLocalData = NO;
    }
   
    // 得到一级文件目录
    [[ResDAL shareInstance] addDataWithArray:fileAllArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupFile_GetResource, rootFolder);
    });
    
    
}
// 添加文件夹
-(void)parseGroupAddFolder:(NSMutableDictionary*)dataDic
{
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *dataGetDic = [dataDic objectForKey:WebApi_DataSend_Get];
    // 资源次id也要加上
    NSString *rpid = [dataGetDic objectForKey:@"rpid"];
    ResFolderModel *folder = [[ResFolderModel alloc] init];
    [folder serializationWithDictionary:contextDic];
    
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    folder.classid = classid;
    folder.descript = description;
    folder.rpid = rpid;
    [[ResFolderDAL shareInstance] addDataWithResFolderModel:folder];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 完成文件夹名字输入后 通知界面 */
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, folder);
    });
    
}
// 编辑文件夹 名称
-(void)parseEditeFolder:(NSMutableDictionary*)dataDic
{
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    ResFolderModel *resFolderModel = [[ResFolderModel alloc] init];
    [resFolderModel serializationWithDictionary:contextDic];
    NSString *classid = [contextDic objectForKey:@"id"];
    resFolderModel.classid = classid;
    // 更新数据库
    [[ResFolderDAL shareInstance] updataFolderNam:resFolderModel.name withClassid:resFolderModel.classid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, resFolderModel);
    });
}
// 编辑文件 名称
-(void)parseEditFile:(NSMutableDictionary*)dataDic
{
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    ResModel *resfileModel = [[ResModel alloc] init];
    [resfileModel serializationWithDictionary:contextDic];
    resfileModel.descript = [contextDic objectForKey:@"description"];
    
    /* 更新数据库 */
    [[ResDAL shareInstance] updateResFileName:resfileModel.name withRid:resfileModel.rid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, resfileModel);
    });
    
}
//删除文件夹
-(void)parseGroupDelFolder:(NSMutableDictionary*)dataDic
{
    NSNumber *dataContext = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSMutableDictionary *dataSend = [dataDic objectForKey:WebApi_DataSend_Post];
    NSInteger isSuccess = [dataContext integerValue];
    
    if (isSuccess) {
        NSString *classid = [dataSend objectForKey:@"id"];
        [[ResFolderDAL shareInstance] deleteFolderWithClassid:classid];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroup_DelFolder, nil);
    });
    
}
// 删除文件
-(void)parseGroupDelResource:(NSMutableDictionary *)dataDic
{
    NSNumber *dataContext = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSInteger isSuccess = [dataContext integerValue];
    NSString *fileRid = [dataDic objectForKey:WebApi_DataSend_Post];
    
    if (isSuccess) {
        [[ResDAL shareInstance] deleteResWithRid:fileRid];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroup_DelFile, nil);
    });
}
// 文件/文件夹批量删除
-(void)parseGroupMixRemoveData:(NSMutableDictionary*)dataDic {
    
    NSNumber *contextData = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSDictionary *dataPost = [dataDic objectForKey:WebApi_DataSend_Post];
    
    NSInteger isSuccess = [contextData integerValue];
    
    if (isSuccess) {
        NSString * folderidStr =[dataPost objectForKey:@"folderids"] ;
        NSMutableArray *folderidArr = [AppUtils StringTransformArray:folderidStr];
        for (int i = 0; i < [folderidArr count]; i++) {
            [[ResFolderDAL shareInstance] deleteFolderWithClassid:[folderidArr objectAtIndex:i]];
        }
        
        NSString *resIDStr = [dataPost objectForKey:@"resourceids"];
        NSMutableArray *resIdArr = [AppUtils StringTransformArray:resIDStr];
        for (int i = 0; i < [resIdArr count]; i++) {
            [[ResDAL shareInstance] deleteResWithRid:[resIdArr objectAtIndex:i]];
        }
       
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroup_DelFile, nil);
//        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroup_DelFolder, nil);
    });
    
}
// 文件/文件夹的移动
-(void)parseFolderMove:(NSMutableDictionary*)dataDic {
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    NSMutableArray *folderModels = [contextDic objectForKey:@"foldermodels"];
    if (folderModels.count != 0) {
        NSMutableArray *allRwsFolderArr = [[NSMutableArray alloc] init];
        [self analyseMoveGroupSource:folderModels withArray:allRwsFolderArr];
        // 更新移动过的文件
        [[ResFolderDAL shareInstance] addDataWithArray:allRwsFolderArr];
    }
   
    
    ResModel *fileModel = [[ResModel alloc] init];
    NSMutableArray *fileArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *resourceModels = [contextDic objectForKey:@"resourcemodels"];
    for (int i = 0; i < resourceModels.count; i ++) {
        
        NSDictionary *fileDic = [resourceModels objectAtIndex:i];
        
        [fileModel serializationWithDictionary:fileDic];
        fileModel.descript = [fileDic objectForKey:@"description"];
        
        [fileArr addObject:fileModel];
//        /* 通过文件的rid 修改数据库里面的classID */
        [[ResDAL shareInstance] addDataWithModel:fileModel];
    }
    
        
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFoleCpnroller_FileSuccess, nil);
    });
}

-(void)analyseMoveGroupSource:(NSMutableArray *)contextArray withArray:(NSMutableArray *)allRwsFolderArr{
    
    for (int i = 0; i < contextArray.count; i++) {
        NSDictionary *folderDic = [contextArray objectAtIndex:i];
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        
        [folder serializationWithDictionary:folderDic];
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folder.classid = classid;
        folder.descript = description;
        folder.pinyin = [AppUtils transform:folder.name];
        [allRwsFolderArr addObject:folder];
        
        NSMutableArray *childArray = [folderDic objectForKey:@"children"];
        if (childArray != nil && [childArray count] > 0 ) {
            [self analyseMoveSource:childArray withArray:allRwsFolderArr];
        }
    }
}
// 文件上传 发动态
-(void)parseUploadFile:(NSMutableDictionary*)dataDic {
    
       
    NSDictionary *dic = [dataDic objectForKey:WebApi_DataSend_Get];
    //    NSString *cid = [dic objectForKey:@"cooperationid"];
    NSString *rpid = [dic objectForKey:@"rpid"];
    
    NSString *rid = [dataDic objectForKey:WebApi_DataSend_Post];
    
    ResModel *resM = [[ResModel alloc] init];
    resM.rpid = rpid;
    resM.rid = rid;
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroup_UploadResource,resM);
    });
}
// 获取文件夹信息
-(void)parseGetFolderInfo:(NSMutableDictionary*)dataDic  {
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    ResFolderModel *resFolderModel = [[ResFolderModel alloc] init];
    [resFolderModel serializationWithDictionary:contextDic];
    NSString *classid = [contextDic objectForKey:@"id"];
    resFolderModel.classid = classid;
    //resFolderModel.operateauthority = 1;
    // 更新数据库
    //    [[ResFolderDAL shareInstance] updataFolderNam:resFolderModel.name withClassid:resFolderModel.classid];
    [[ResFolderDAL shareInstance] addDataWithResFolderModel:resFolderModel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroup_GetFolderInfo,resFolderModel);
    });
    
}
// 获取资源信息
-(void)parseGetResourceInfo:(NSMutableDictionary*)dataDic {
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    ResModel *file = [[ResModel alloc] init];
    
    [file serializationWithDictionary:contextDic];
    
    NSString *description = [contextDic objectForKey:@"description"];
    file.descript = description;
    //file.operateauthority = 1;
    /* 更新数据库 */
    [[ResDAL shareInstance] addDataWithModel:file];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroup_GetResourceInfo, file);
    });
}
-(void)parseImportNetDisk:(NSMutableDictionary*)dataDic {
    NSDictionary *dataContextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSMutableDictionary *sendData = [dataDic objectForKey:WebApi_DataSend_Other];
    NSArray *clienttempids = [sendData lzNSArrayForKey:@"clienttempid"];
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *resModelArr = [dataContextDic lzNSArrayForKey:@"resourcemodels"];
    
    for (int i =0 ; i < resModelArr.count; i++) {
        NSDictionary *resDic = [resModelArr objectAtIndex:i];
        ResModel *resM = [[ResModel alloc] init];
        [resM serializationWithDictionary:resDic];
        resM.uploadstatus = App_NetDisk_File_UploadSuccess;
        // 新上传的文件要标记下载状态 不然上传新的文件的时候下载不了
        resM.downloadstatus = App_NetDisk_File_NoDownload;
        resM.clienttempid = [clienttempids objectAtIndex:i];
        resM.descript = [resDic lzNSStringForKey:@"description"];
        [array addObject:resM];
    }
    
    [[ResDAL shareInstance] addDataWithArray:array];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:array forKey:@"newArr"];
    [dic setObject:clienttempids forKey:@"netrids"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationDocumentParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroup_ImportNetDiskResource,dic);
    });
}


/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic{
    
}

@end
