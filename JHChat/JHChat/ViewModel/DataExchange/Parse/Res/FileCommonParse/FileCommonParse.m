//
//  FileCommonParse.m
//  LeadingCloud
//
//  Created by SY on 16/8/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "FileCommonParse.h"
#import "ResFolderDAL.h"
#import "ResDAL.h"
#import "ResFolderModel.h"
#import "ResModel.h"
#import "SysApiVersionDAL.h"

@implementation FileCommonParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(FileCommonParse *)shareInstance{
    static FileCommonParse *instance = nil;
    if (instance == nil) {
        instance = [[FileCommonParse alloc] init];
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
    /* 创建资源池 */
    if ([route isEqualToString:WebApi_FileCommon_CreatePool]) {
        [self parsePoolData:dataDic];
    }
    /* 得到文件夹列表 */
    else if ([route isEqualToString:WebApi_FileCommon_GetFolderList]) {
        [self parseGetFolderList:dataDic];
    }
    /* 下级文件夹列表 */
    else if ([route isEqualToString:WebApi_FileCommon_GetNextFolderList]) {
        [self parseGetNextFolderList:dataDic];
    }
    /* 获取指定目录下的文件 */
    else if ([route isEqualToString:WebApi_FileCommom_GetfolderAndResource]) {
        [self parseGetFolderAndRes:dataDic];
    }
    /* 新建文件夹 */
    else if ([route isEqualToString:WebApi_FileCommon_AddFolder]) {
        [self parseAddFolder:dataDic];
    }
    /* 文件夹重命名 */
    else if ([route isEqualToString:webApi_FileCommon_EditFolder]) {
        [self parseEditFolder:dataDic];
    }
    /* 文件重命名 */
    else if ([route isEqualToString:WebApi_FileCommon_ReNameResource]) {
        [self parseEditFolder:dataDic];
    }
    /* 文件列表  */
    else if ( [route isEqualToString:WebApi_FileCommon_GetDataList]) {
        [self parsegetFileList:dataDic];
    }
    /* 上传文件 */
    else if ([route isEqualToString:WebApi_FileCommon_AddResource]) {
        [self parseAddRes:dataDic];
    }
    /* 文件、文件夹删除 */
    else if ([route isEqualToString:WebApi_FileCommon_DelBatchDelete]) {
        [self parseDelete:dataDic];
    }
    /*升级版本 */
    else if ([route isEqualToString:WebApi_FileCommon_UpgradeRes]) {
        [self parseUpgradeRes:dataDic];
    }
    /*替换版本*/
    else if ([route isEqualToString:WebApi_FileCommon_ReplaceRes]) {
        [self parseReplaceRes:dataDic];
    }
    /* 移动资源 */
    else if ([route isEqualToString:WebApi_FileCommon_MoveResourceFodler]) {
        [self parseMoveResFolder:dataDic];
    }
    
    else if ([route isEqualToString:WebApi_FileUploadJSNC_ReplaceUpload]) {
        [self parseFileReplace:dataDic];
    }
    /* 文件上传限制的文档类型 */
    else if ([route isEqualToString:WebApi_FileUploadExp_LimitUpload]) {
        [self parseFileUploadLimitExp:dataDic];
    }
    /* 获取文件夹指定节点 */
    else if ([route isEqualToString:WebApi_FileCommon_GetFolderOne]) {
        [self parseGetFolderOne:dataDic];
    }
    /* 拷贝资源 */
    else if ([route isEqualToString:WebApi_FileCommon_copyResource]) {
        
        [self parseRes:dataDic];
    }
    
    
    
    
}
// 创建资源池
-(void)parsePoolData:(NSMutableDictionary*)dataDic {
    
    
    
    
}
// 获取文件夹列表
-(void)parseGetFolderList:(NSMutableDictionary*)dataDic {
    /* 接收到服务器返回的数据 */
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSMutableArray *allRwsFolderArr = [[NSMutableArray alloc] init];
    [self analyse:contextDic withArray:allRwsFolderArr];
    
    // 先删本地
    [[ResFolderDAL shareInstance] deleteAllFolderWithRpid:[contextDic lzNSStringForKey:@"rpid"]];
    // 添加最新的
    [[ResFolderDAL shareInstance] addDataWithArray:allRwsFolderArr];
   
    if ([[dataOther lzNSStringForKey:@"ispulldown"] isEqualToString:@"1"]) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 通知界面 */
            __block FileCommonParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_ResFolder_PullDownFolder, allRwsFolderArr);
        });
    }
    else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 通知界面 */
            __block FileCommonParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_GetFolderList, allRwsFolderArr);
        });
    }
}
-(void)analyse:(NSDictionary *)contextDic withArray:(NSMutableArray *)allRwsFolderArr{
    if([[contextDic allKeys] count]>0){
        
        ResFolderModel *resFolderModel = [[ResFolderModel alloc] init];
        [resFolderModel serializationWithDictionary:contextDic];
        
        NSString *classid = [contextDic objectForKey:@"id"];
        NSString *description = [contextDic objectForKey:@"description"];
        resFolderModel.classid = classid;
        resFolderModel.descript = description;
        resFolderModel.pinyin = [AppUtils transform:resFolderModel.name];
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
// 新建文件夹
-(void)parseAddFolder:(NSMutableDictionary*)dataDic {
    
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    ResFolderModel *resFolderModel = [[ResFolderModel alloc] init];
    [resFolderModel serializationWithDictionary:contextDic];
    
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    resFolderModel.classid = classid;
    resFolderModel.descript = description;
    
    [[ResFolderDAL shareInstance] addDataWithResFolderModel:resFolderModel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 如果成功的话就把解析过的值传到 EventBus_LZOneFieldValueEdit_Success 页面*/
        __block FileCommonParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, resFolderModel);
    });

    
    
}
// 文件夹重命名
-(void)parseEditFolder:(NSMutableDictionary*)dataDic {
    NSMutableDictionary *datacontext = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSDictionary *dataPostDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    NSString *name = [datacontext lzNSStringForKey:@"name"];
    
    NSString *folderid = [dataPostDic lzNSStringForKey:@"folderid"];
    NSString *rid = [dataPostDic lzNSStringForKey:@"rid"];
    if ([NSString isNullOrEmpty:rid]) {
          NSString *classid = [datacontext lzNSStringForKey:@"id"];
        [[ResFolderDAL shareInstance] updataFolderNam:name withClassid:classid];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block FileCommonParse * service = self;
           EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, classid);
        });

    }
    else if ([NSString isNullOrEmpty:folderid]) {
        NSString *rid = [datacontext lzNSStringForKey:@"rid"];
       [[ResDAL shareInstance] updateResFileName:name withRid:rid];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 通知界面 */
            __block FileCommonParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, rid);
        });

    }
 
}
// 获取子文件夹列表
-(void)parseGetNextFolderList:(NSMutableDictionary*)dataDic {
    
    
    
}
// 获取指定目录下的文件 
-(void)parseGetFolderAndRes:(NSMutableDictionary*)dataDic {
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSMutableArray *folderArray = [[NSMutableArray alloc] init];
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    [self analyse:contextDic withArray:folderArray];
    // 先删本地
    [[ResFolderDAL shareInstance] deleteAllFolderWithRpid:[contextDic lzNSStringForKey:@"rpid"]];
    [[ResFolderDAL shareInstance] addDataWithArray:folderArray];
    
    /* 解析子文件资源 */
    NSArray *childFileArr = [contextDic lzNSArrayForKey:@"resourcemodels"];
    
    for (int i = 0; i < childFileArr.count; i++) {
        
        NSDictionary *fileDic = [childFileArr objectAtIndex:i];
        
        ResModel *fileModel = [[ResModel alloc] init];
        [fileModel serializationWithDictionary:fileDic];
        [fileArray addObject:fileModel];
    }
    
    // 只让第一次进来把网盘存本地的全都删掉上拉加载的时候就不删了 一页只清一次
    if (self.appDelegate.lzGlobalVariable.isDeleteLocalData) {
        [[ResDAL shareInstance] deleteAllResWithClassid:[contextDic lzNSStringForKey:@"id"]];
        self.appDelegate.lzGlobalVariable.isDeleteLocalData = NO;
    }
    [[ResDAL shareInstance] addDataWithArray:fileArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block FileCommonParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CommonFile_GetFolderAndRes, nil);
    });
    
}
// 获取文件列表
-(void)parsegetFileList:(NSMutableDictionary*)dataDic {
    
    NSMutableArray *allFileArr = [[NSMutableArray alloc] init];
    
    /* 接收到服务器返回的数据 */
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *dataPost = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    
     NSArray *fileListArr = [contextDic objectForKey:@"List"];
    ResModel *resModel = nil;
    
    for(int i=0;i<fileListArr.count;i++){
        
        NSMutableDictionary *fileDic = [fileListArr objectAtIndex:i];
        NSMutableDictionary *favoriteDic = [fileDic objectForKey:@"resourcefavorite"];
        NSInteger isFavorite = [[favoriteDic objectForKey:@"isfavorite"] integerValue];
        
        resModel = [[ResModel alloc] init];
        [resModel serializationWithDictionary:fileDic];
        resModel.descript = [fileDic objectForKey:@"description"];
        
        resModel.isfavorite = isFavorite;
        resModel.favoritesDic = [NSMutableDictionary dictionaryWithDictionary:favoriteDic];
        [allFileArr addObject:resModel];

        
    }
    // 只让第一次进来把网盘存本地的全都删掉上拉加载的时候就不删了 一页只清一次 如果是下拉就删不了了
    if (self.appDelegate.lzGlobalVariable.isDeleteLocalData) {
        [[ResDAL shareInstance] deleteAllResWithClassid:[dataPost lzNSStringForKey:@"classid"]];
        self.appDelegate.lzGlobalVariable.isDeleteLocalData = NO;
    }
    
    if ([[dataOther lzNSStringForKey:@"pullDown"] isEqualToString:@"1"]) {
        [[ResDAL shareInstance] deleteAllResWithClassid:[dataPost lzNSStringForKey:@"classid"]];
    }
 
    [[ResDAL shareInstance] addDataWithArray:allFileArr];
    /* 发送的消息数据 */
    NSMutableDictionary *sendData = [dataDic objectForKey:WebApi_DataSend_Post];
    NSInteger preTableViewCount = ((NSNumber *)[sendData objectForKey:@"currentnumber"]).integerValue; //获取数据之前TableView中资源数量
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:preTableViewCount] forKey:@"pre"];
    [dic setObject:[NSNumber numberWithInteger:allFileArr.count] forKey:@"add"];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        __block FileCommonParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex, dic);
    });
}
// 上传资源
-(void)parseAddRes:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *dataContext = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableDictionary *dataPost = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Post];
    
    NSString *clienttempid = [dataPost objectForKey:@"clienttempid"];
    NSString *key = [dataPost objectForKey:@"key"];
 

    NSMutableDictionary *favoriteDic = [dataContext lzNSMutableDictionaryForKey:@"resourcefavorite"];
    
    ResModel *resModel = [[ResModel alloc] init];
    [resModel serializationWithDictionary:dataContext];
    resModel.favoritesDic = favoriteDic;
    resModel.descript = [dataContext lzNSStringForKey:@"description"];
    resModel.uploadstatus = App_NetDisk_File_UploadSuccess;
    resModel.downloadstatus = App_NetDisk_File_NoDownload;
    resModel.clienttempid = clienttempid;
    
    /* 修改客户端数据 */
    [[ResDAL shareInstance] UpdateResWithClientID:resModel];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FileCommonParse * service = self;
        
        NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
        [eventData setObject:key forKey:@"key"];
        [eventData setObject:resModel forKey:@"res"];
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_AddResource, eventData);

    });
}
// 删除
-(void)parseDelete:(NSMutableDictionary*)dataDic {
    
    BOOL isSendFolderEventBus = NO;
    BOOL IsSendFileEventBus = NO;
    
    NSDictionary *postData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSDictionary *otherData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *mixDel = [otherData lzNSStringForKey:@"mixDel"];
    BOOL isMix = [mixDel boolValue];
    
    NSString *folderidStr = [postData lzNSStringForKey:@"folderids"];
    NSArray *folderidArray = [AppUtils StringTransformArray:folderidStr];
    for (int i = 0; i < folderidArray.count; i++) {
        [[ResFolderDAL shareInstance] deleteFolderWithClassid:[folderidArray objectAtIndex:i]];
        isSendFolderEventBus = YES;
    }
    
    NSString *fileisStr = [postData lzNSStringForKey:@"resourceids"];
    NSArray *fileidArray  = [AppUtils StringTransformArray:fileisStr];
    for (int i = 0; i < fileidArray.count; i++) {
        [[ResDAL shareInstance] deleteResWithRid:[fileidArray objectAtIndex:i]];
        IsSendFileEventBus = YES;
    }
    if (isMix) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block FileCommonParse *service = self;
             EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_DelMoreResoure, nil);
            
        });

    }
    else {
        if (isSendFolderEventBus) {
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block FileCommonParse *service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_DelFolder, nil);
                // EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_DelMoreResoure, nil);
                
            });
        }
        if (IsSendFileEventBus) {
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block FileCommonParse *service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_DelFile, nil);
                //EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_DelMoreResoure, nil);
            });
        }
    }
}
/* 文件升级版本 */
-(void)parseUpgradeRes:(NSMutableDictionary*)dataDic {
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    ResModel *file = [[ResModel alloc] init];
    [file serializationWithDictionary:contextDic];
    
    file.descript = [contextDic objectForKey:@"description"];
    
    // 更新数据库
    [[ResDAL shareInstance] UpdateUpgradeFileWithRid:file];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FileCommonParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_UpgradeFile, file);
    });

    
}
// 替换版本
-(void)parseReplaceRes:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    ResModel *file = [[ResModel alloc] init];
    [file serializationWithDictionary:contextDic];
    file.descript = [contextDic objectForKey:@"description"];
    
    // 更新数据库
    [[ResDAL shareInstance] UpdateUpgradeFileWithRid:file];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FileCommonParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_ReplaceFile, file);
    });
}
// 移动
-(void)parseMoveResFolder:(NSMutableDictionary*)dataDic {

    NSMutableDictionary *dataContext = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSArray *folderArray = [dataContext lzNSArrayForKey:@"foldermodels"];
    NSArray *fileArray = [dataContext lzNSArrayForKey:@"resourcemodels"];
    
    ResModel *fileModel =[[ResModel alloc] init];
    ResFolderModel *folderModel = [[ResFolderModel alloc] init];
    BOOL isSendFolderEventBus = NO;
    BOOL isSendFileEventBus = NO;
    for (int i = 0; i < [folderArray count]; i++) {
        NSDictionary *folderDic = [folderArray objectAtIndex:i];
        [folderModel serializationWithDictionary:folderDic];
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folderModel.classid = classid;
        folderModel.descript = description;

        [[ResFolderDAL shareInstance] addDataWithResFolderModel:folderModel];
        
        isSendFolderEventBus = YES;
    }
    
    for (int i = 0; i < [fileArray count]; i++) {
        NSDictionary *fileDic = [fileArray objectAtIndex:i];
        
        [fileModel serializationWithDictionary:fileDic];
        fileModel.descript = [fileDic objectForKey:@"description"];
        
        /* 通过文件的rid 修改数据库里面的classID */
        [[ResDAL shareInstance] addDataWithModel:fileModel];
        isSendFileEventBus = YES;
    }
    
    if (isSendFolderEventBus) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 通知界面 */
            __block FileCommonParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFileController_Success, nil);
        });
    }
    if (isSendFileEventBus) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 通知界面 */
            __block FileCommonParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFileController_Success, fileModel);
        });
    }
   
}
-(void)parseFileReplace:(NSMutableDictionary*)dataDic {
    
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block FileCommonParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ReplaceFile_Success, nil);
    });
    
}

-(void)parseFileUploadLimitExp:(NSMutableDictionary*)dataDic {
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSString *unallowFileType = [contextDic lzNSStringForKey:@"filetype_unallow"];
    
    [LZUserDataManager saveUnallowUpLoadFileType:unallowFileType];
    
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_fileserver_uploadfileexp_S10];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block FileCommonParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_FileUploadExp_LimitUploadExp, contextDic);
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
    });

}
-(void)parseGetFolderOne:(NSMutableDictionary*)dataDic{
    
    NSDictionary *dataContext = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSMutableArray *folderArray = [[NSMutableArray alloc] init];
     [self analyse:dataContext withArray:folderArray];
    
    
    // 先删本地
    [[ResFolderDAL shareInstance] deleteAllFolderWithRpid:[dataContext lzNSStringForKey:@"rpid"]];
    // 添加最新的
    [[ResFolderDAL shareInstance] addDataWithArray:folderArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block FileCommonParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_GetFolderList, folderArray);
    });

    
    
}
-(void)parseRes:(NSMutableDictionary*)dataDic {
    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSArray *folderModels = [dic lzNSArrayForKey:@"foldermodels"];
    NSArray *resourcemodels = [dic lzNSArrayForKey:@"resourcemodels"];
    
    NSMutableArray *arrayFolder = [NSMutableArray array];
    NSMutableArray *arrayFile  = [NSMutableArray array];
    for (int i = 0; i < folderModels.count; i++) {
        NSDictionary *folderDic = [folderModels objectAtIndex:i];
        ResFolderModel *folderM = [[ResFolderModel alloc] init];
        [folderM serializationWithDictionary:folderDic];
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folderM.classid = classid;
        folderM.descript = description;
        folderM.pinyin = folderM.name;
        [[ResFolderDAL shareInstance] addDataWithResFolderModel:folderM];
        [arrayFolder addObject:folderM];
    }
    
    for (int i = 0; i < resourcemodels.count; i++) {
        NSDictionary *resDic = [resourcemodels objectAtIndex:i];
        ResModel *resM = [[ResModel alloc] init];
        [resM serializationWithDictionary:resDic];
        resM.descript = [resDic objectForKey:@"description"];
        [[ResDAL shareInstance] addDataWithModel:resM];
        [arrayFile addObject:resM];
    }
    NSMutableDictionary *dicAll = [[NSMutableDictionary alloc] init];
    [dicAll setObject:arrayFolder forKey:@"folderarr"];
    [dicAll setObject:arrayFile forKey:@"filearr"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FileCommonParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFileController_Success, dicAll);
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
