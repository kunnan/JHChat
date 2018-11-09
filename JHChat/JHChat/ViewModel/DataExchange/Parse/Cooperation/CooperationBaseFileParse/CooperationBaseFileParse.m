//
//  CooperationBaseFileParse.m
//  LeadingCloud
//
//  Created by SY on 16/12/27.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooperationBaseFileParse.h"
#import "ResFolderModel.h"
#import "ResModel.h"
#import "AppUtils.h"
#import "ResFolderDAL.h"
#import "ResDAL.h"
#import "NetDiskIndexViewModel.h"
#import "ResourceQuoteFolderOrgModel.h"
#import "UserModel.h"
#import "ResShareModel.h"
#import "ResShareItemModel.h"
@implementation CooperationBaseFileParse

+(CooperationBaseFileParse *)shareInstance{
    static CooperationBaseFileParse *instance = nil;
    if (instance == nil) {
        instance = [[CooperationBaseFileParse alloc] init];
    }
    return instance;
}
#pragma mark  解析数据
-(void)parse:(NSMutableDictionary *)dataDic{
    
    NSString *route = [dataDic objectForKey:WebApi_Route];
    /* 获取资源 */
    if ([route isEqualToString:WebApi_CooperationBaseFile_GetResource]) {
        [self parseGetresource:dataDic];
        
    }
    /* 获取文件夹 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_GetFolder]) {
        [self parseGetFolder:dataDic];
    }
    /*通过classid获取相应的目录<##>*/
    else if ([route isEqualToString:WebApi_CooperationBaseFile_GetFolderByClassid]) {
        [self parseGetFolder:dataDic];
    }
    /* 新增资源 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_CreateResourceNewResource]) {
        [self parseCreatResource:dataDic];
    }
    /* 获取权限 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_MyAuthority]
             ||[route isEqualToString:WebApi_CooperationBaseFile_Authority_MyAuthority_Expend] ) {
        [self parseAuthorityData:dataDic];
    }
    /* 获取当前权限设置的状态 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_FileAuthority]
             || [route isEqualToString:WebApi_CooperationBaseFile_Authority_FileAuthority_Expend]) {
        [self parseCurrentFileAuthority:dataDic];
    }
    else if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_asecooperationfileauthority]) {
        [self parseCurrentFileAuthority2:dataDic];
    }
    /* 设置文件权限 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_SettingsAuthority]
             || [route isEqualToString:WebApi_CooperationBaseFile_Authority_SettingsAuthority_Expend]) {
        [self parseSettingSuthority:dataDic];
    }
    else if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_Member]) {
        [self parseAuthorityMember:dataDic];
    }
    /* 根据基础协作id获取当前登陆人的权限*/
    else if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_MyAuthorityModel]
             || [route isEqualToString:WebApi_CooperationBaseFile_Authority_MyAuthorityModel_Expend]) {
        [self parseGetMyAuthorityModel:dataDic routhPath:route];
    }
    else if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_FileFolderAuthority]
             || [route isEqualToString:WebApi_CooperationBaseFile_Authority_FileFolderAuthority_Expend]) {
        [self parseCurrentFolderAuthority:dataDic];
    }
    else if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_GetMyAdminAuthorityModel]
             ||[route isEqualToString:WebApi_CooperationBaseFile_Authority_GetMyOperateAuthorityModel]
             || [route isEqualToString:WebApi_CooperationBaseFile_Authority_GetMyAdminAuthorityModel_Expend]
             || [route isEqualToString:WebApi_CooperationBaseFile_Authority_GetMyOperateAuthorityModel_Expend]) {
        [self parseGetMyAuthorityModel:dataDic routhPath:route];
    }
    /* 获取基础协作权限(文件夹权限)<##> */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_CooperationAuthorityForFolder]
             ||[route isEqualToString:WebApi_CooperationBaseFile_Authority_CooperationAuthorityForFolder_Expend]) {
        
        [self parseAuthorityForFolder:dataDic];
    }
    /* 设置基础协作权限(文件夹权限设置)<##> */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_SettingsAuthorityForFolder]
             ||[route isEqualToString:WebApi_CooperationBaseFile_Authority_SettingsAuthorityForFolder_Expend]) {
        [self parseSettingsAuthorityForFolder:dataDic];
    }
    /* 新建文件夹 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_AddFolder]) {
        [self parseAddFolder:dataDic];
    }
    /* 删除文件夹 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_DelFolderContext]) {
        [self parseDelFolder:dataDic];
    }
    /* 文件夹重命名 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_EditFolderName]
             ||[route isEqualToString:WebApi_CooperationBaseFile_EditFolderInfo] ) {
        [self parseEditFolderName:dataDic];
    }
    /* 删除资源 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_DelResourced]) {
        [self parseDelResm:dataDic];
    }
    /* 资源重命名 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_EditResourceName]
             || [route isEqualToString:WebApi_CooperationBaseFile_EditResourceInfo]) {
        [self parseEditResName:dataDic];
    }
    /* 资源详情 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_GetResourceDetails] ) {
        [self parseResDetail:dataDic];
    }
    /* 文件夹详情 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_GetFolderDetails] ) {
        [self parseFolderDetail:dataDic];
    }
    /* 保存到云盘 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_CopyToNetDisk]) {
        [self parseCopyToNet:dataDic];
    }
    /* 批量删除 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_MixRemoveDara]) {
        [self parseMixDel:dataDic];
    }
    /* 移动文件 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_MoveFile]) {
        [self parseMoveFile:dataDic];
    }
    /* 从云盘导入文件 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_ImportNetDiskResource]) {
        [self parseImportNetDiskRes:dataDic];
    }
    else if ([route isEqualToString:WebApi_CooperationBaseFile_AddResourceForMoreLogic]) {
        [self parseLogic:dataDic];
    }
    
    else if ([route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_GetModelForRpid]) {
        [self parseGetFolderShareModel:dataDic];
    }
    else if ([route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_GetShareList]) {
        [self parseShareList:dataDic];
    }
    /* 被企业引用的 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_GetOrgModel]
             || [route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_WhoQuote]) {
        [self parseOrgModel:dataDic];
    }
    
    /* 共享文档私密性设置 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_UpdateModel]) {
        [self parseUpdataModel:dataDic];
    }
    else if ([route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_EditSharePaw]) {
        [self parseEditSharePaw:dataDic];
    }
    /* 取消共享 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_DeleteModel]) {
        [self parseCancleShare:(dataDic)];
    }
    /*删除分享项<##> */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_DelShareItem]) {
        [self parseDelShareItem:dataDic];
    }
    /*添加分享项<##> */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_AddShareItem]) {
        [self parseAddShareItem:dataDic];
    }
    
    /* 获取引用的文件夹 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_Getmodel]
             || [route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_GetOldSharemodel]) {
        [self parseQuoteFolder:dataDic];
    }
    /* 查看引用的文件<##> */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_ShareItemList]) {
        [self parseQouteShareItemList:dataDic];
    }
    /* 输入共享码时 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_GetSharedType]
             ||[route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_IsEffectiveShare] ) {
        [self parseQuoteFolderGetSharedType:dataDic];
    }
    /* 共享自己的文件夹 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_AddShareFolderModel]
             || [route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_AddShareModel]) {
    
        [self parseShareFolderAddFodler:dataDic];
    }
    /* 在文件夹列表中取消共享 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_DeleShareFolderInFolderList]
             ||[route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_CancelShareOld] ) {
        [self parseDeleShareFolderInList:dataDic];
    }
    else if ([route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_AddQuoteShareFolderModel]
             || [route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_AddResQuote]) {
        [self parseAddQuoteShare:dataDic];
    }
    /* 删除引用共享文档 */
    else if ([route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_DeleteQuoteFolder]
             || [route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_DeleteModel]) {
        [self parseDeleteQuoteFolder:dataDic];
    }
    else if ([route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_GetNoRpidShare]) {
        [self parseGetNoRpidShare:dataDic];
    }
    else if ( [route isEqualToString:WebApi_CooperationBaseFile_UpgradeResourceforNew]) {
        [self parseCooFileUpgrade:dataDic];
    }
    else if ([route isEqualToString:WebApi_CooperationBaseFile_ReplaceResourceForNew]) {
        [self parseCoofileReplace:dataDic];
    }
    else if ([route isEqualToString:WebApi_Resource_Folder_GetFOlderOne]) {
        [self parseFolderOne:dataDic];
    }
    
}
/* 协作文件 整体权限 */
-(void)parseAuthorityData:(NSMutableDictionary*)dataDic {
    NSMutableDictionary *dataContext = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableDictionary *dataother = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
    self.appDelegate.lzGlobalVariable.cooFileAuthorityDic = dataContext;
    if( [[dataother allKeys] containsObject:@"successblock"]){
        SendApiSuccess getResInfoBlock = [dataother objectForKey:@"successblock"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            getResInfoBlock(dataContext);
        });
        return;
    }
    
    
}
-(void)parseCurrentFileAuthority:(NSMutableDictionary*)dataDic {
    NSMutableDictionary *datacontent = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_Authority_FileAuthority, datacontent);
    });
    
}
-(void)parseCurrentFileAuthority2:(NSMutableDictionary*)dataDic {
    NSMutableDictionary *dataContent = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableDictionary *dataother = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
    
    //NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if( [[dataother allKeys] containsObject:@"successblock"]){
        SendApiSuccess getResInfoBlock = [dataother objectForKey:@"successblock"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            getResInfoBlock(dataContent);
        });
    }
}
-(void)parseCurrentFolderAuthority:(NSMutableDictionary*)dataDic {
    
//    NSMutableDictionary *dataContext = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
//    NSMutableDictionary *dataother = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
    
    
}
-(void)parseGetMyAuthorityModel:(NSMutableDictionary*)dataDic routhPath:(NSString*)routhPath{
    NSMutableDictionary *dataContent = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableDictionary *dataother = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
    NSString *cid = [dataContent lzNSStringForKey:@"cid"];
    NSInteger fileauthority = (NSInteger)[[dataContent lzNSNumberForKey:@"fileauthority"] longValue];
    NSInteger myauthoritytype = (NSInteger)[[dataContent lzNSNumberForKey:@"myauthoritytype"] longValue];
    NSString *uid = [dataContent lzNSStringForKey:@"uid"];
    NSArray *customizeuserauthority = [dataContent lzNSArrayForKey:@"customizeuserauthority"];
    
    NSDictionary *Folder = nil;
    NSMutableArray *array = [[NSMutableArray alloc] init];
//    NSMutableDictionary *alldataDic = [[NSMutableDictionary alloc] init];
    
    // 第一页用到的数据
    NSMutableArray *rootFolderArr = [[NSMutableArray alloc] init];
    if (myauthoritytype != 5) {
        
        for ( int i = 0; i < customizeuserauthority.count; i++) {
            NSDictionary *cusDic  = customizeuserauthority[i];
            Folder = [cusDic lzNSDictonaryForKey:@"folder"];
             [self analyse:Folder withArray:array];
            //组织首页数据
            ResFolderModel *rootModel = [[ResFolderModel alloc] init];
            [rootModel serializationWithDictionary:Folder];
            rootModel.classid = [Folder lzNSStringForKey:@"id"];
            [rootFolderArr addObject:rootModel];
        }
        // 组织跟model并存本地 自定义情况下是不对的
        if (fileauthority != 4) {
            ResFolderModel *rootfolderModel = [[ResFolderModel alloc] init];
            rootfolderModel.classid = [Folder lzNSStringForKey:@"parentid"];
            rootfolderModel.parentid = @"-";
            rootfolderModel.rpid = [dataContent lzNSStringForKey:@"rpid"];
            [array addObject:rootfolderModel];
        }
    }
    else {
        Folder = [dataContent lzNSDictonaryForKey:@"rootfolder"];
        
        [self analyse:Folder withArray:array];
        // 组织首页数据
        NSArray *child =[Folder lzNSArrayForKey:@"children"];//拿到第一层数据
        for ( int i = 0; i < child.count; i++) {
            NSDictionary *folderDci  =  child[i];
            ResFolderModel *rootModel = [[ResFolderModel alloc] init];
            [rootModel serializationWithDictionary:folderDci];
            rootModel.classid = [folderDci lzNSStringForKey:@"id"];
            [rootFolderArr addObject:rootModel];
        }
        
    }
    
    // 先删本地 根页面只存一次 
    if ((myauthoritytype != 5 && fileauthority == 4 && !self.appDelegate.lzGlobalVariable.isNextFolderData) && (![routhPath isEqualToString:WebApi_CooperationBaseFile_Authority_GetMyAdminAuthorityModel]|| ![routhPath isEqualToString:WebApi_CooperationBaseFile_Authority_GetMyAdminAuthorityModel_Expend])) {
        [[ResFolderDAL shareInstance] deleteAllFolderWithRpid:[dataContent lzNSStringForKey:@"rpid"]];
        [[ResFolderDAL shareInstance] addDataWithArray:array];
    }
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:array forKey:@"folderarray"];
    [dic setValue:cid forKey:@"cid"];
    [dic setValue:[NSNumber numberWithInteger:fileauthority] forKey:@"fileauthority"];
    [dic setValue:[NSNumber numberWithInteger:myauthoritytype] forKey:@"myauthoritytype"];
    [dic setValue:uid forKey:@"uid"];
    [dic setValue:rootFolderArr forKey:@"rootfolderArr"];
    /* 通知界面 */
    __block CooperationBaseFileParse *service = self;
    if( [[dataother allKeys] containsObject:@"successblock"]){
        SendApiSuccess getResInfoBlock = [dataother objectForKey:@"successblock"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            getResInfoBlock(dic);
            // 只在首页不是管理员且是自定义文件夹下气作用
            if (myauthoritytype != 5 && fileauthority == 4 && !self.appDelegate.lzGlobalVariable.isNextFolderData) {
                EVENT_PUBLISH_WITHDATA(service,  EventBus_CooperationBaseFile_Authority_GetMyFolderModel, rootFolderArr);
            }
            else {
                 //EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_DelFolder, dic);// 刷新本地文件夹用到
            }
        });
        return;
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if ([routhPath isEqualToString:WebApi_CooperationBaseFile_Authority_GetMyAdminAuthorityModel] || [routhPath isEqualToString:WebApi_CooperationBaseFile_Authority_GetMyAdminAuthorityModel_Expend]) {
            EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_Authority_MyAuthorityModel, rootFolderArr);
        }
        else {
             //EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_DelFolder, dic);// 刷新本地文件夹用到
        }
       
    });
    
}
-(void)parseGetMyAdminAuthorityModel:(NSMutableDictionary*)dataDic {
    
    
    
    
}
-(void)parseAuthorityForFolder:(NSMutableDictionary*)dataDic {
    NSDictionary *dataContext = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *userauthorityDic = [dataContext lzNSDictonaryForKey:@"userauthority"];
    
    NSString *cid = [dataContext lzNSStringForKey:@"cid"];
    NSString *folderid = [dataContext lzNSStringForKey:@"folderid"];
    
    NSArray *adminArr = [userauthorityDic lzNSArrayForKey:@"admin"];
    NSArray *operateArr = [userauthorityDic lzNSArrayForKey:@"operate"];
    NSArray *noneArr = [userauthorityDic lzNSArrayForKey:@"none"];
    
    NSMutableArray *adminAllArr = [NSMutableArray array];
    for ( int i = 0; i < adminArr.count; i++) {
        NSDictionary *userModelDic = [adminArr objectAtIndex:i];
        UserModel *userModel = [[UserModel alloc] init];
        [userModel serializationWithDictionary:userModelDic];
        [adminAllArr addObject:userModel];
    }
    
    NSMutableArray *operateAllArr = [NSMutableArray array];
    for ( int i = 0; i < operateArr.count; i++) {
        NSDictionary *userModelDic = [operateArr objectAtIndex:i];
        UserModel *userModel = [[UserModel alloc] init];
        [userModel serializationWithDictionary:userModelDic];
        [operateAllArr addObject:userModel];
    }
    
    NSMutableArray *noneAllArr = [NSMutableArray array];
    for ( int i = 0; i < noneArr.count; i++) {
        NSDictionary *userModelDic = [noneArr objectAtIndex:i];
        UserModel *userModel = [[UserModel alloc] init];
        [userModel serializationWithDictionary:userModelDic];
        [noneAllArr addObject:userModel];
    }
    

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:adminAllArr forKey:@"admin"];
    [dic setValue:operateAllArr forKey:@"operate"];
    [dic setValue:noneAllArr forKey:@"none"];
    [dic setValue:cid forKey:@"cid"];
    [dic setValue:folderid forKey:@"folderid"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_Authority_AuthorityForFolder, dic);
    });
}
-(void)parseSettingsAuthorityForFolder:(NSMutableDictionary*)dic {
   
    NSDictionary *dataPost = [dic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSDictionary *userauthority = [dataPost lzNSDictonaryForKey:@"userauthority"];
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    
    for (NSString *key in userauthority.allKeys) {
        NSArray *userArr = [userauthority lzNSArrayForKey:key];
        NSMutableArray *array = [NSMutableArray array];
        for ( int i = 0; i < userArr.count; i++) {
            NSDictionary *userDic = [userArr objectAtIndex:i];
            UserModel *userM = [[UserModel alloc] init];
            [userM serializationWithDictionary:userDic];
            [array addObject:userM];
        }
        [mutDic setValue:array forKey:key];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_Authority_SettingsAuthorityForFolder, mutDic);
    });
}
-(void)parseSettingSuthority:(NSMutableDictionary*)dataDic {
    
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_Authority_SettingsAuthority, nil);
    });
}
-(void)parseAuthorityMember:(NSMutableDictionary*)dataDic {
    
    
    
}
-(void)parseCreatResource:(NSMutableDictionary*)dataDic {
    
     NSMutableDictionary *sendData = [dataDic objectForKey:WebApi_DataSend_Post];
    NSMutableDictionary *dateOther = [dataDic objectForKey:WebApi_DataSend_Other];
    
    NSDictionary *resDic = [sendData lzNSDictonaryForKey:@"resource"];
    NSString *clienttempid = [resDic lzNSStringForKey:@"clienttempid"];
    NSString *key = [resDic objectForKey:@"key"];
    
    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    ResModel *resModel = [[ResModel alloc] init];
    [resModel serializationWithDictionary:dic];
    resModel.descript = [dic objectForKey:@"description"];
    resModel.uploadstatus = App_NetDisk_File_UploadSuccess;
    resModel.downloadstatus = App_NetDisk_File_NoDownload;
    resModel.clienttempid = clienttempid;
    /* 修改客户端数据 */
    [[ResDAL shareInstance] UpdateResWithClientID:resModel];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
        [eventData setObject:resModel forKey:@"res"];
        
        
        NSString *eeventBus = [dateOther lzNSStringForKey:WebApi_DataSend_Other_Operate];
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        if (![NSString isNullOrEmpty:eeventBus]) {
            EVENT_PUBLISH_WITHDATA(service,eeventBus, eventData);
        }
        else {
            [eventData setObject:key forKey:@"key"];
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_AddResource, eventData);
        }
    });
    
    
}
//-(void)parseGetFodlerByClassid:(NSMutableDictionary*)dataDic {
//    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
//
//
//
//}
-(void)parseGetFolder:(NSMutableDictionary*)dataDic {
    NSLog(@"基础协作文件得到了文件夹");
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
     NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    
    ResFolderModel *resFolderRootModel = [[ResFolderModel alloc] init];
    [resFolderRootModel serializationWithDictionary:contextDic];
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    resFolderRootModel.classid = classid;
    resFolderRootModel.descript = description;

    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self analyse:contextDic withArray:array];
    
    if (self.appDelegate.lzGlobalVariable.cooFolderisAddData) {
        // 先删本地
        [[ResFolderDAL shareInstance] deleteAllFolderWithRpid:[contextDic lzNSStringForKey:@"rpid"]];
        // 添加最新的 二级页面会把以前的都覆盖掉
        [[ResFolderDAL shareInstance] addDataWithArray:array];
        self.appDelegate.lzGlobalVariable.cooFolderisAddData = NO;
    }
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:array forKey:@"folder"];
    /* 在主线程中发送通知 */
    if ([[dataOther allKeys] containsObject:@"block"]) {
        GetNetFolder getFolder = [dataOther objectForKey:@"block"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            getFolder(array);
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 通知界面 */
            __block CooperationBaseFileParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_GetFolder, array);
        });
        
    }
    
}
-(void)parseGetresource:(NSMutableDictionary*)dataDic {
    NSLog(@"基础协作文件得到了文件");
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];

    NSDictionary *postData  = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSString *rpid = [postData lzNSStringForKey:@"rpid"];
    NSString *classid = [postData lzNSStringForKey:@"folderid"];
    
    NSArray *folderArray = [contextDic lzNSArrayForKey:@"folders"];
    NSMutableArray *allFolderArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < folderArray.count; i++) {
        NSDictionary *folderDic = [folderArray objectAtIndex:i];
        ResFolderModel *folderModel = [[ResFolderModel alloc] init];
        [folderModel serializationWithDictionary:folderDic];
        folderModel.classid = [folderDic lzNSStringForKey:@"id"];
        folderModel.descript = [folderDic lzNSStringForKey:@"description"];
        [allFolderArr addObject:folderModel];
    }
    [[ResFolderDAL shareInstance] deleteFolderWithPraentId:classid];
    [[ResFolderDAL shareInstance] addDataWithArray:allFolderArr];
    
    // 解析资源
    NSArray *fileArray = [contextDic lzNSArrayForKey:@"resources"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < fileArray.count; i++) {
        NSDictionary *fileDic = [fileArray objectAtIndex:i];
        ResModel *resModel = [[ResModel alloc] init];
        [resModel serializationWithDictionary:fileDic];
        resModel.descript = [fileDic objectForKey:@"description"];
        [array addObject:resModel];
    }
    if (!self.appDelegate.lzGlobalVariable.cooFileisNotDeleteLocalData) {
        [[ResDAL shareInstance] deleteAllResWithRpid:rpid withClassid:classid];
        self.appDelegate.lzGlobalVariable.cooFileisNotDeleteLocalData = NO;
    }
    
    [[ResDAL shareInstance] addDataWithArray:array];
    
    NSMutableDictionary *allData = [[NSMutableDictionary alloc] init];
    //[allData setObject:allRwsFolderArr forKey:@"folder"];
    [allData setObject:array forKey:@"file"];
    
    NSDictionary *dataPost = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSDictionary *dic1 = [dataPost lzNSDictonaryForKey:@"querysbqmodel"];
    //NSDictionary *dic2 = [dic1 lzNSDictonaryForKey:@"currentnumber"];
     id currentnumber = [dic1 objectForKey:@"currentnumber"];
    [allData setValue:currentnumber forKey:@"pre"];   // 要修改开始数量
    [allData setValue:[NSNumber numberWithInteger:array.count] forKey:@"add"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_GetResource, allData);
    });
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

-(void)parseAddFolder:(NSMutableDictionary *) datadic {

    NSDictionary *contextDic = [datadic lzNSDictonaryForKey:WebApi_DataContext];
    
    ResFolderModel *folderM = [[ResFolderModel alloc] init];
    [folderM  serializationWithDictionary:contextDic];
    folderM.classid = [contextDic lzNSStringForKey:@"id"];
    folderM.descript = [contextDic lzNSStringForKey:@"description"];
    folderM.pinyin = [AppUtils transform:folderM.name];
    folderM.operateauthority = 1;
    
    [[ResFolderDAL shareInstance] addDataWithResFolderModel:folderM];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, folderM);
    });
    
}
-(void )parseDelFolder:(NSMutableDictionary*)dataDic {

    NSDictionary *postData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSDictionary *folderDic = [postData lzNSDictonaryForKey:@"foldermodel"];
    NSString *classid = [folderDic lzNSStringForKey:@"id"];
    
    [[ResFolderDAL shareInstance]deleteFolderWithClassid:classid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_DelFolder, classid);
    });
}
-(void)parseEditFolderName:(NSMutableDictionary*)dataDic {
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    ResFolderModel *foldeM = [[ResFolderModel alloc] init];
    [foldeM serializationWithDictionary:contextDic];
    foldeM.classid = [contextDic lzNSStringForKey:@"id"];
    foldeM.descript = [contextDic lzNSStringForKey:@"description"];
    foldeM.pinyin = [AppUtils transform:foldeM.name];
    foldeM.operateauthority = 1;
    
    [[ResFolderDAL shareInstance] addDataWithResFolderModel:foldeM];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, foldeM);
    });

}
-(void)parseDelResm:(NSMutableDictionary *)dataDic {
    NSDictionary *postData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    [[ResDAL shareInstance]deleteResWithRid:[postData lzNSStringForKey:@"rid"]];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_DelFile, postData);
    });
    
}
-(void)parseEditResName:(NSMutableDictionary*)dataDic {
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *postData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSDictionary *galderModel = [postData lzNSDictonaryForKey:@"galdermodel"];
    ResModel *model = [[ResModel alloc] init];
    [model serializationWithDictionary:contextDic];
    model.descript = [contextDic lzNSStringForKey:@"description"];
    model.operateauthority = 1;
    if ([NSString isNullOrEmpty:model.classid]) {
        model.classid = [postData lzNSStringForKey:@"folderid"];
    }
    if ([NSString isNullOrEmpty:model.rpid]) {
        model.rpid = [postData lzNSStringForKey:@"rpid"];
    }
    if ([NSString isNullOrEmpty:model.descript]) {
        model.descript = [galderModel lzNSStringForKey:@"description"];
    }
    if ([NSString isNullOrEmpty:model.exptype]) {
        model.exptype = [galderModel lzNSStringForKey:@"exptype"];
    }
    
    [[ResDAL shareInstance] addDataWithModel:model];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, model);
    });
    
}
-(void)parseResDetail:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *dataContext = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSDictionary *otherData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[otherData allKeys] containsObject:@"block"]) {
            SendApiSuccess getResInfoBlock = [otherData objectForKey:@"block"];
            getResInfoBlock(dataContext);
            return;
        }
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_FileDetails_Success, nil);
    });
    
}
-(void)parseFolderDetail:(NSMutableDictionary*)dataDic {
    NSMutableDictionary *dataContext = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSDictionary *otherData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    
    
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[otherData allKeys] containsObject:@"block"]) {
            SendApiSuccess getResInfoBlock = [otherData objectForKey:@"block"];
            getResInfoBlock(dataContext);
            return;
        }
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_FileDetails_Success, nil);
    });
}
-(void)parseCopyToNet:(NSMutableDictionary*)dataDic {
    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    NSMutableDictionary *dataDi = [[NSMutableDictionary alloc] init];
    if ([[dic lzNSStringForKey:@"folderids"] isEqualToString:@""]) {
        [dataDi setValue:[dic lzNSStringForKey:@"resourceids"] forKey:@"file"];
    }
    if ([[dic lzNSStringForKey:@"resourceids"] isEqualToString:@""]) {
         [dataDi setValue:[dic lzNSStringForKey:@"folder"] forKey:@"folder"];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFileController_Success, dataDi);
    });
}
-(void)parseMixDel:(NSMutableDictionary*)dataDic {
    NSDictionary *postData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSDictionary *apiopermodelDic = [postData lzNSDictonaryForKey:@"apiopermodel"];
    NSString *folderids = [apiopermodelDic lzNSStringForKey:@"folderids"];
    NSString *rids = [apiopermodelDic lzNSStringForKey:@"resourceids"];
    /* 字符串转数组 */
    NSMutableArray * folderidArray=[NSMutableArray arrayWithArray:[folderids componentsSeparatedByString:@","]];
    NSMutableArray * ridsArr = [NSMutableArray arrayWithArray:[rids componentsSeparatedByString:@","]];
    
    for (int i = 0; i < folderidArray.count; i++) {
        [[ResFolderDAL shareInstance] deleteFolderWithClassid:[folderidArray objectAtIndex:i]];
    }
    for (int i =0; i < ridsArr.count; i++) {
        [[ResDAL shareInstance] deleteResWithRid:[ridsArr objectAtIndex:i]];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_MixDeleteData, nil);
    });
    
}
-(void)parseMoveFile:(NSMutableDictionary*)dataDic {
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *dataPost = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSString *folderid = [dataPost lzNSStringForKey:@"folderids"];
    NSString *fileid  =[dataPost lzNSStringForKey:@"resourceids"];
    
    NSMutableArray *folderArray = [contextDic lzNSMutableArrayForKey:@"foldermodels"];
    NSMutableArray *allFolderArr = [[NSMutableArray alloc] init];
    [self analyseMoveSource:folderArray withArray:allFolderArr];
    // 更新移动过的文件
    [[ResFolderDAL shareInstance] addDataWithArray:allFolderArr];
    
    NSArray *resArray  =[contextDic lzNSArrayForKey:@"resourcemodels"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i< resArray.count; i++) {
        ResModel *resModel = [[ResModel alloc]init];
        NSDictionary *resDic = [resArray objectAtIndex:i];
        [resModel serializationWithDictionary:resDic];
        resModel.descript = [resDic lzNSStringForKey:@"description"];
        resModel.operateauthority = 1;
        [array addObject:resModel];
    }
    [[ResDAL shareInstance] addDataWithArray:array];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:folderid forKey:@"folderid"];
    [dic setValue:fileid forKey:@"fileid"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFileController_Success, dic);
    });
    
}
-(void)parseImportNetDiskRes:(NSMutableDictionary*)dataDic {
    NSDictionary *dataContextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSMutableDictionary *sendData = [dataDic objectForKey:WebApi_DataSend_Post];
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
        resM.operateauthority = 1;
        [array addObject:resM];
    }
    
    [[ResDAL shareInstance] addDataWithArray:array];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:array forKey:@"newArr"];
    [dic setObject:clienttempids forKey:@"clienttempids"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_ImportNetDiskResource, dic);
    });
}
-(void)parseLogic:(NSMutableDictionary*)dataDic{
    
    
    
}
-(void)parseGetFolderShareModel:(NSMutableDictionary*)dataDic {
    NSArray *dataContentArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSMutableArray *folderShareArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataContentArr.count; i++) {
        NSDictionary *shareFolderDic = [dataContentArr objectAtIndex:i];
        ResourceShareFolderModel *shareFolder = [[ResourceShareFolderModel alloc] init];
        [shareFolder serializationWithDictionary:shareFolderDic];
        [folderShareArr addObject:shareFolder];
    }
        
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_ShareFolder_GetShareFolderModel, folderShareArr);
    });
}
-(void)parseShareList:(NSMutableDictionary*)dataDic {
    NSMutableArray *dataContextArr = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSMutableArray *shareModelArr = [[NSMutableArray alloc] init];
    for ( int i = 0; i < dataContextArr.count; i++) {
        NSDictionary *shareDic = [dataContextArr objectAtIndex:i];
        ResShareModel *shareModel = [[ResShareModel alloc] init];
        [shareModel serializationWithDictionary:shareDic];
        shareModel.sharelink = [shareDic objectForKey:@"link"];
//        if (![NSString isNullOrEmpty:shareModel.customname]) {
//            shareModel.name = shareModel.customname;
//        }
        [shareModelArr addObject:shareModel];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_ShareFolder_GetShareList, shareModelArr);
    });
}

-(void)parseOrgModel:(NSMutableDictionary*)dataDic{
    NSArray *contentArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSString *route = [dataDic lzNSStringForKey:WebApi_Route];
    NSMutableArray *quoteFolderOrgs = [NSMutableArray array];
    if ([route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_GetOrgModel]) {
        for (int i = 0; i < contentArr.count; i++) {
            NSDictionary *quoteModelDic = [contentArr objectAtIndex:i];
            ResourceQuoteFolderOrgModel *orgModel = [[ResourceQuoteFolderOrgModel alloc] init];
            [orgModel serializationWithDictionary:quoteModelDic];
            
            /* 获取引用的models */
            NSMutableArray *quoteFolders = [NSMutableArray array];
            NSArray *quoteModels = [quoteModelDic lzNSArrayForKey:@"quotemodels"];
            for (int j = 0; j < quoteModels.count; j++) {
                NSDictionary *quoteDic = [quoteModels objectAtIndex:j];
                //orgModel.quoteFolderDic = quoteDic;
                /* 得到被引用的文件夹 */
                ResourceQuoteFolderModel *quoteFolder = [[ResourceQuoteFolderModel alloc] init];
                [quoteFolder serializationWithDictionary:quoteDic];
                quoteFolder.rsfDataDic = [quoteDic lzNSDictonaryForKey:@"rsfdata"];
                
                [quoteFolders addObject:quoteFolder];
            }
            orgModel.quoteFolderArray = quoteFolders;
            
            [quoteFolderOrgs addObject:orgModel];
        }
        

    }
    else {
        for (int i = 0; i < contentArr.count; i++) {
            NSDictionary *quoteModelDic = [contentArr objectAtIndex:i];
            ResourceQuoteFolderOrgModel *orgModel = [[ResourceQuoteFolderOrgModel alloc] init];
            [orgModel serializationWithDictionary:quoteModelDic];
            orgModel.orgname = [quoteModelDic lzNSStringForKey:@"oname"];
            /* 获取引用的models */
            NSMutableArray *quoteFolders = [NSMutableArray array];
            NSArray *quoteModels = [quoteModelDic lzNSArrayForKey:@"ResourceQuoteModel"];
            for (int j = 0; j < quoteModels.count; j++) {
                NSDictionary *quoteDic = [quoteModels objectAtIndex:j];
                //orgModel.quoteFolderDic = quoteDic;
                /* 得到被引用的文件夹 */
                ResourceQuoteFolderModel *quoteFolder = [[ResourceQuoteFolderModel alloc] init];
                [quoteFolder serializationWithDictionary:quoteDic];
                quoteFolder.rsfDataDic = [quoteDic lzNSDictonaryForKey:@"rsfdata"];
                
                [quoteFolders addObject:quoteFolder];
            }
            orgModel.quoteFolderArray = quoteFolders;
            
            [quoteFolderOrgs addObject:orgModel];
        }
    }


    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_ShareFolder_GetQouteShareFolderOrg, quoteFolderOrgs);
    });
    
}

-(void)parseUpdataModel:(NSMutableDictionary*)dataDic {
    
    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    ResourceShareFolderModel *shareModel = [[ResourceShareFolderModel alloc] init];
    [shareModel serializationWithDictionary:dic];
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_ShareFolder_SettingUpdataFolder, shareModel);
    });
}
-(void)parseEditSharePaw:(NSMutableDictionary*)dataDic {
    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    ResShareModel *shareModel = [[ResShareModel alloc] init];
    [shareModel serializationWithDictionary:dic];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_ShareFolder_SettingUpdataFolder, shareModel);
    });
}
-(void)parseCancleShare:(NSMutableDictionary*)dataDic {
    NSInteger isSuccess = [[dataDic lzNSNumberForKey:WebApi_DataContext] integerValue];
    NSDictionary *otherData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    ResourceShareFolderModel *shareModel = nil;
    if ([[otherData allKeys] containsObject:@"sharemodel"]) {
        shareModel = [otherData objectForKey:@"sharemodel"];
    }
    
    if (isSuccess) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 通知界面 */
            __block CooperationBaseFileParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_ShareFolder_CancleShareFolder, shareModel);
        });
    }
}
-(void)parseDelShareItem:(NSMutableDictionary*)dataDic {
    
    NSInteger dataContext = [[dataDic lzNSNumberForKey:WebApi_DataContext] integerValue];
    NSDictionary *dataGet = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSString *shiid = [dataGet lzNSStringForKey:@"shiid"];
    
    if (dataContext) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 通知界面 */
            __block CooperationBaseFileParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_ShareFolder_DeleteShareItem, shiid);
        });
    }    
}
-(void)parseAddShareItem:(NSMutableDictionary*)dataDic {
    
    NSInteger dataContext = [[dataDic lzNSNumberForKey:WebApi_DataContext] integerValue];
    if (dataContext) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 通知界面 */
            __block CooperationBaseFileParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_ShareFolder_AddShareItem, nil);
        });
    }   
}
-(void)parseQuoteFolder:(NSMutableDictionary*)dataDic {
    NSArray *array = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSMutableArray *qouteFolderArray = [NSMutableArray array];
    for (int i =0 ; i < array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        ResourceQuoteFolderModel *qouteFolder  = [[ResourceQuoteFolderModel alloc] init];
        [qouteFolder serializationWithDictionary:dic];
        qouteFolder.rsfDataDic = [dic lzNSDictonaryForKey:@"rsfdata"];
        [qouteFolderArray addObject:qouteFolder];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_QuoteShareFolder_GetQuoteFolder, qouteFolderArray);
    });
}

-(void)parseQouteShareItemList:(NSMutableDictionary*)dataDic {
    
    NSArray *dataArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSMutableArray *shareItemArr = [NSMutableArray array];
    for ( int i = 0; i < dataArr.count; i++) {
        NSDictionary *shareDic = [dataArr objectAtIndex:i];
        ResShareItemModel *shareItem = [[ResShareItemModel alloc] init];
        [shareItem serializationWithDictionary:shareDic];
        [shareItemArr addObject:shareItem];
    }
    
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_QuoteShareFolder_GetShareItemList, shareItemArr);
    });
    
}
-(void)parseQuoteFolderGetSharedType:(NSMutableDictionary*)dataDic {
    NSString *route = [dataDic lzNSStringForKey:WebApi_Route];
    NSMutableDictionary *dic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSDictionary *errorcode = [dataDic lzNSDictonaryForKey:WebApi_ErrorCode];
    NSDictionary *getData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    id data  = nil;
    if ([route isEqualToString:WebApi_CooperationBaseFile_QuoteFolder_GetSharedType]) {
       ResourceShareFolderModel * shareFolder = [[ResourceShareFolderModel alloc] init];
        [shareFolder serializationWithDictionary:dic];
        data = shareFolder;
    }
    else {
        [dic setValue:[errorcode lzNSStringForKey:@"Code"] forKey:@"Code"];
        [dic setValue:[errorcode lzNSStringForKey:@"Message"] forKey:@"Message"];
        [dic setValue:[getData lzNSStringForKey:@"rpid"] forKey:@"rpid"];
        [dic setValue:[getData lzNSStringForKey:@"rsid"] forKey:@"rsid"];
        data = dic;
    }
    
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_QuoteShareFolder_GetSharedType, data);
    });
}
-(void)parseShareFolderAddFodler:(NSMutableDictionary*)dataDic {
    
    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSString *route = [dataDic lzNSStringForKey:WebApi_Route];
   // NSString *customname = [dic lzNSStringForKey:@"customname"];
    
    ResShareModel *shareModel = [[ResShareModel alloc] init];
    [shareModel serializationWithDictionary:dic];
     shareModel.sharelink = [dic objectForKey:@"link"];
//    if (![NSString isNullOrEmpty:customname]) {
//        shareModel.name = customname;
//    }
    id data = shareModel;
    if ([route isEqualToString:WebApi_CooperationBaseFile_ShareFolder_AddShareModel]) {
        ResourceShareFolderModel *shareModel2 = [[ResourceShareFolderModel alloc] init];
         [shareModel2 serializationWithDictionary:dic];
        [[ResFolderDAL shareInstance] updataIsShare:1 withClassid:shareModel2.folderid];
        [[ResFolderDAL shareInstance] updataIcon:shareModel2.icon withClassid:shareModel2.folderid];
        data = shareModel2;
    }
   
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_ShareFolder_AddFolderForShare, data);
    });
}
-(void)parseDeleShareFolderInList:(NSMutableDictionary*)dataDic {
    
    NSInteger isSuccess = [[dataDic lzNSNumberForKey:WebApi_DataContext] integerValue];
    NSDictionary *getdata = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    if (isSuccess) {
    
        [[ResFolderDAL shareInstance] updataIsShare:0 withClassid:[getdata lzNSStringForKey:@"folderid"]];
        //[[ResFolderDAL shareInstance] updataIcon:shareModel.icon withClassid:shareModel.folderid];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 通知界面 */
            __block CooperationBaseFileParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_ShareFolder_CancleShareFolder, getdata);
        });
    }
    
}
-(void)parseAddQuoteShare:(NSMutableDictionary *)dataDic {
    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    ResourceQuoteFolderModel *quoteFolderModel = [[ResourceQuoteFolderModel alloc] init];
    [quoteFolderModel serializationWithDictionary:dic];
    quoteFolderModel.rsfDataDic = [dic lzNSMutableDictionaryForKey:@"rsfdata"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_QuoteShareFolder_AddQuoteFodlerShare, quoteFolderModel);
    });
    
}
-(void)parseDeleteQuoteFolder:(NSMutableDictionary*)dataDic {
    NSInteger isSuccess = [[dataDic lzNSNumberForKey:WebApi_DataContext] integerValue];
    NSDictionary *getdata = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    
     if (isSuccess) {
   
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             /* 通知界面 */
             __block CooperationBaseFileParse *service = self;
             EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_QuoteShareFolder_DeleteQuoteShareFolder, getdata);
         });
         
     }
}
-(void)parseGetNoRpidShare:(NSMutableDictionary*)dataDic {
    NSArray *shareArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSDictionary *dataPost = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    NSMutableArray *allSharemodelArr = [NSMutableArray array];
    
    for ( int i = 0; i < shareArr.count; i++) {
        NSDictionary *shareDic = shareArr[i];
        ResShareModel *shareModel = [[ResShareModel alloc] init];
        [shareModel serializationWithDictionary:shareDic];
        [allSharemodelArr addObject:shareModel];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary  alloc] init];
    [dic setValue:allSharemodelArr forKey:@"sharearray"];
    [dic setValue:[dataPost lzNSStringForKey:@"wherecondition"] forKey:@"search"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationBaseFileParse *service = self;
        
        EVENT_PUBLISH_WITHDATA(service, EventBus_CooperationBaseFile_QuoteShareFolder_GetNORpidShare, dic);
    });
}
-(void)parseCooFileUpgrade:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    ResModel *file = [[ResModel alloc] init];
    [file serializationWithDictionary:contextDic];
    
    file.descript = [contextDic objectForKey:@"description"];
    
    // 更新数据库
    [[ResDAL shareInstance] UpdateUpgradeFileWithRid:file];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_UpgradeFile, file);
    });
}
-(void)parseCoofileReplace:(NSMutableDictionary*)dataDic {
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    ResModel *file = [[ResModel alloc] init];
    [file serializationWithDictionary:contextDic];
    
    file.descript = [contextDic objectForKey:@"description"];
    
    // 更新数据库
    [[ResDAL shareInstance] UpdateUpgradeFileWithRid:file];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_ReplaceFile, file);
    });
    
}
-(void)parseFolderOne:(NSMutableDictionary*)dataDic {
    
    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    [[ResFolderDAL shareInstance] updataIcon:[dic lzNSStringForKey:@"icon"] withClassid:[dic lzNSStringForKey:@"id"]];
    [[ResFolderDAL shareInstance] updataIsShare:0 withClassid:[dic lzNSStringForKey:@"id"]];
    
    ResFolderModel *folderModel = [[ResFolderModel alloc] init];
    [folderModel serializationWithDictionary:dic];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationBaseFileParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Resource_Folder_GetFolderOne, folderModel);
    });
    
}
-(void)analyseMoveSource:(NSMutableArray *)contextArray withArray:(NSMutableArray *)allRwsFolderArr{
    
    for (int i = 0; i < contextArray.count; i++) {
        NSDictionary *folderDic = [contextArray objectAtIndex:i];
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        
        [folder serializationWithDictionary:folderDic];
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folder.operateauthority = 1;
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
