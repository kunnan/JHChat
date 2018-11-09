//
//  CloudDiskAppFolderParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/13.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-13
 Version: 1.0
 Description: 云盘文件夹
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "CloudDiskAppFolderParse.h"
#import "ResFolderDAL.h"
#import "ResDAL.h"
#import "ResFolderModel.h"
#import "ResModel.h"
#import "LZUserDataManager.h"
#import "NetDiskIndexViewModel.h"
#import "NetDiskOrgModel.h"
#import "NetDiskOrgDAL.h"
#import "FavoritesDAL.h"
@interface CloudDiskAppFolderParse ()
{
    NSString *folderRpid;
    NSString *parentid;
}
@end

@implementation CloudDiskAppFolderParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CloudDiskAppFolderParse *)shareInstance{
    static CloudDiskAppFolderParse *instance = nil;
    if (instance == nil) {
        instance = [[CloudDiskAppFolderParse alloc] init];
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
    
    /* 获取云盘文件夹 */
    if([route isEqualToString:WebApi_CloudDiskFolder_GetFolder] || [route isEqualToString:WebApi_CloudDiskAppOrganization_GetFolderOnepartitionType]){
        [self parseGetFolder:dataDic];
    }
    /* 新建文件夹 */
    else if( [route isEqualToString:WebApi_CloudDiskFolder_AddFolder]){
        [self parseAddFolder:dataDic];
    }
    /* 重命名文件夹 */
    else if ([route isEqualToString:WebApi_CloudDiskFolder_EditFolder]
             || [route isEqualToString:WebApi_CloudDiskFolder_EditFolderInfo]) {
        [self praseReNameFolder:dataDic];
    }
    /* 删除文件夹 */
    else if ([route isEqualToString:WebApi_CloudDiskFolder_DelFolder]) {
        [self praseDelFolder:dataDic];
    }
    /* 移动文件夹 */
    else if ([route isEqualToString:WebApi_CloudDiskFile_EditResourceFolder]) {
        [self praseFolderMove:dataDic];
    }
    /* 获取文件夹信息 */
    else if ([route isEqualToString:WebApi_CloudDiskFolder_GetFolderInfo]) {
        [self parseFolderInfo:dataDic];
    }
    
    /* 获取组织云盘企业区model */
    else if ([route isEqualToString:WebApi_CloudDiskAppOrganization_OrganizationModel]) {
        [self parseOrgModel:dataDic];
    }
    /* 获取云盘文件的容量大小 */
    else if ([route isEqualToString:WebApi_CloudDiskApp_Size]) {
        [self parseCloudSize:dataDic];
    }
    /* 获取企业和个人云盘大小 */
    else if ([route isEqualToString:WebApi_CloudDiskAppOrganization_NormalList] || [route isEqualToString:WebApi_CloudDiskAppOrganization_Organization]) {
        [self parseOrgNormalList:dataDic];
    }
}

/**
 *  消息发送成功后，服务器端返回的数据
 */
-(void)parseGetFolder:(NSMutableDictionary *)dataDic{
    
    /* 接收到服务器返回的数据 */
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSMutableArray *allRwsFolderArr = [[NSMutableArray alloc] init];
    [self analyse:contextDic withArray:allRwsFolderArr];
    
    // 先删本地
    NSString *rpid =[[LZUserDataManager readCurrentUserInfo] objectForKey:@"rpid"];
    [[ResFolderDAL shareInstance] deleteAllFolderWithRpid:rpid];
       // 添加最新的
    [[ResFolderDAL shareInstance] addDataWithArray:allRwsFolderArr];
    
//    /* 判断是否最后一个WebApi */
//    __block CloudDiskAppFolderParse * service = self;
//    NSMutableDictionary *dic = [dataDic objectForKey:WebApi_DataSend_Get];
//    if(dic!=nil){
//        if([[dic allKeys] containsObject:@"lastwebapi"] && [[dic objectForKey:@"lastwebapi"] isEqualToString:@"1"]){
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//                [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//                [data setObject:LZConnection_Login_NetWorkStatus_RecvFinish forKey:@"status"];
//                
//                EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//            });
//        }
//    }
    NSString *otherStr = [dataOther lzNSStringForKey:@"isPullDown"];
    if ([otherStr isEqualToString:@"1"]) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            // 发送通知 获取rpid
            __block CloudDiskAppFolderParse * service2 = self;
            EVENT_PUBLISH_WITHDATA(service2, EventBus_App_ResFolder_PullDownFolder, nil);
        });
    }
    else if ([otherStr isEqualToString:@"getdata"]) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            // 发送通知 获取rpid
            __block CloudDiskAppFolderParse * service2 = self;
            EVENT_PUBLISH_WITHDATA(service2, EventBus_App_Res_NetDiskIndex_getFolderData, nil);
        });

    }
    else if ([[dataOther allKeys] containsObject:@"block"]) {
        GetNetFolder getFolder = [dataOther objectForKey:@"block"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
             getFolder(allRwsFolderArr);
        });
    }
    else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            // 发送通知 获取rpid
            __block CloudDiskAppFolderParse * service2 = self;
            EVENT_PUBLISH_WITHDATA(service2, EventBus_App_NetDiskOrganization_GetAllFolderWithRpid, nil);
        });
    }
    
//    /* 在主线程中发送通知 */
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // 发送通知 获取rpid
//        __block CloudDiskAppFolderParse * service2 = self;
//        EVENT_PUBLISH_WITHDATA(service2, EventBus_App_Res_NetDiskIndex_GetFolderRpid, folderRpid);
//    });
    
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

/**
 *  新建文件夹
 */
-(void)parseAddFolder:(NSMutableDictionary *)dataDic{
    
    /* 接收到服务器返回的数据 */
    //    NSString *context  = [dataDic lzNSStringForKey:WebApi_DataContext];
    //    NSData *data = [context dataUsingEncoding:NSUTF8StringEncoding];
    //    NSError *error = nil;
    //    NSDictionary *contextDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //    DDLogVerbose(@"----------%@",context);
    
    /* 解析数据 */
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    ResFolderModel *resFolderModel = [[ResFolderModel alloc] init];
    [resFolderModel serializationWithDictionary:contextDic];
    
    NSString *classid = [contextDic lzNSStringForKey:@"id"];
    NSString *description = [contextDic lzNSStringForKey:@"description"];
    resFolderModel.classid = classid;
    resFolderModel.descript = description;
    resFolderModel.pinyin = [AppUtils transform:resFolderModel.name];
   
    [[ResFolderDAL shareInstance] addDataWithResFolderModel:resFolderModel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 如果成功的话就把解析过的值传到 EventBus_LZOneFieldValueEdit_Success 页面*/
        __block CloudDiskAppFolderParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, resFolderModel);
    });
}
/**
 *  重命名文件夹
 */
-(void) praseReNameFolder:(NSMutableDictionary *)dataDic {
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    ResFolderModel *resFolderModel = [[ResFolderModel alloc] init];
    [resFolderModel serializationWithDictionary:contextDic];
    
    NSString *classid = [contextDic lzNSStringForKey:@"id"];
    NSString *description = [contextDic lzNSStringForKey:@"description"];
    resFolderModel.classid = classid;
    resFolderModel.descript = description;
    resFolderModel.pinyin = [AppUtils transform:resFolderModel.name];
    
    [[ResFolderDAL shareInstance] addDataWithResFolderModel:resFolderModel];
//    [[ResFolderDAL shareInstance] updataFolderNam:resFolderModel.name withClassid:resFolderModel.classid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CloudDiskAppFolderParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, resFolderModel);
    });
}

/**
 *  删除文件夹
 */
-(void)praseDelFolder:(NSMutableDictionary *)dataDic
{
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSDictionary *dataother = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *isFolderDelMore = [dataother lzNSStringForKey:@"FolderDelMore"];
    
    ResFolderModel *folderModel = [[ResFolderModel alloc] init];
    NSString *classid = [contextDic lzNSStringForKey:@"id"];
    folderModel.classid = classid;
    
    [[ResFolderDAL shareInstance] deleteFolderWithClassid:folderModel.classid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知批量删除界面 */
        if ([isFolderDelMore isEqualToString:@"Yes"]) {
            
        }
        else {
            /* 通知界面 */
            __block CloudDiskAppFolderParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_DelFolder, folderModel);
        }
    });
}
/**
 *  文件夹得移动 返回过来的是全部文件夹 要全部解析掉才能得到移动的文件夹
 */
-(void) praseFolderMove:(NSMutableDictionary *)dataDic
{
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSMutableArray *allRwsFolderArr = [[NSMutableArray alloc] init];
    // 包含根文件夹
    NSMutableArray *allFolderArr = [contextDic lzNSMutableArrayForKey:@"foldermodels"];
    
    [self analyseMoveSource:allFolderArr withArray:allRwsFolderArr];
//
    [[ResFolderDAL shareInstance] addDataWithArray:allRwsFolderArr];
    
    NSArray *resArray = [contextDic lzNSArrayForKey:@"resourcemodels"];
    NSMutableArray *allResArray = [[NSMutableArray alloc] init];
    for (int i =0; i < resArray.count; i++) {
        ResModel *resM = [[ResModel alloc] init];
        NSDictionary *resDic = [resArray objectAtIndex:i];
        [resM serializationWithDictionary:resDic];
        resM.descript = [resDic lzNSStringForKey:@"description"];
        [allResArray addObject:resM];
    }
    [[ResDAL shareInstance] addDataWithArray:allResArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CloudDiskAppFolderParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFileController_Success, nil);
    });
}
-(void)analyseMoveSource:(NSMutableArray *)contextArray withArray:(NSMutableArray *)allRwsFolderArr{
   
    for (int i = 0; i < contextArray.count; i++) {
        NSDictionary *folderDic = [contextArray objectAtIndex:i];
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        
        [folder serializationWithDictionary:folderDic];
        NSString *classid = [folderDic lzNSStringForKey:@"id"];
        NSString *description = [folderDic lzNSStringForKey:@"description"];
        folder.classid = classid;
        folder.descript = description;
        
        [allRwsFolderArr addObject:folder];
        
        NSMutableArray *childArray = [folderDic objectForKey:@"children"];
        if (childArray != nil && [childArray count] > 0 ) {
            [self analyseMoveSource:childArray withArray:allRwsFolderArr];
        }
    }
}
// 获取文件夹信息（文件夹移动、新增通知用)55454980525554720
- (void)parseFolderInfo:(NSMutableDictionary*)dataDic {
    NSArray *contextData = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSMutableArray *folderArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < contextData.count; i++) {
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        NSDictionary *folderDic = [contextData objectAtIndex:i];
        [folder serializationWithDictionary:folderDic];
        folder.classid = [folderDic lzNSStringForKey:@"id"];
        folder.descript = [folderDic lzNSStringForKey:@"description"];
        [folderArray addObject:folder];
    }
     [[ResFolderDAL shareInstance] addDataWithArray:folderArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppFolderParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskIndex_GetFolderInfo, nil);
    });
}


-(void)parseCloudSize:(NSMutableDictionary*)dataDic {
    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSMutableDictionary *sizeDic = [[NSMutableDictionary alloc] init];
    [sizeDic setValue:[dic lzNSStringForKey:@"bindid"] forKey:@"rpid"];
    [sizeDic setValue:[dic lzNSStringForKey:@"showspacesize_current"] forKey:@"cursize"];
    [sizeDic setValue:[dic lzNSStringForKey:@"showspacesize_max"] forKey:@"maxsize"];
    [sizeDic setValue:[dic lzNSStringForKey:@"spacesize_percentage"] forKey:@"per"];
    
    [LZUserDataManager saveNetSizeInfo:sizeDic];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppFolderParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskApp_Size, sizeDic);
    });
}

-(void)parseOrgModel:(NSMutableDictionary*)dataDic {
    NSArray *dataContextArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSMutableArray *orgArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < dataContextArr.count; i++) {
        
        NSDictionary *orgDic = [dataContextArr objectAtIndex:i];
        NetDiskOrgModel *orgModel = nil;
        NSInteger showindex = 0;
        // 对企也和个人的处理
        for (NSString *rpidKey in orgDic.allKeys) {
            if ([rpidKey isEqualToString:@"orgrpid"]) {
                showindex = 0;
                orgModel = [self getOrgModelWithDic:orgDic showIndex:showindex type:1];
                [orgArr addObject:orgModel];
            }
            else if ([rpidKey isEqualToString:@"userrpid"]) {
                showindex = 1;
                orgModel = [self getOrgModelWithDic:orgDic showIndex:showindex type:2];
                [orgArr addObject:orgModel];
            }
        }
        // 对组织数据处理
        NSArray *groupArr  = [orgDic lzNSArrayForKey:@"groups"];
        for (int j = 0; j < groupArr.count; j++) {
            showindex = 2+j;
            NSDictionary *groupDic = [groupArr objectAtIndex:j];
            orgModel = [self getOrgChildWithDic:groupDic type:3 showindx:showindex orgid:[orgDic lzNSStringForKey:@"orgid"]];
             [orgArr addObject:orgModel];
        }
    }
    
    [[NetDiskOrgDAL shareInstance] deleteAllData];
    [[NetDiskOrgDAL shareInstance] addDataWithArray:orgArr];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskAppFolderParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskOrganization_OrganizationModel, nil);
    });
}
-(NetDiskOrgModel*)getOrgModelWithDic:(NSDictionary*)orgDic showIndex:(NSInteger)showindex type:(NSInteger)type{
    
    NetDiskOrgModel *orgModel = [[NetDiskOrgModel alloc] init];
    orgModel.groupid = [orgDic lzNSStringForKey:@"orgid"];
    orgModel.logo = [orgDic lzNSStringForKey:@"orglogo"];
    orgModel.orgid = [orgDic lzNSStringForKey:@"orgid"];
    orgModel.name = [orgDic lzNSStringForKey:@"orgname"];
    if (type == 1) {
        orgModel.rpid = [orgDic lzNSStringForKey:@"orgrpid"];
    }
    else if (type == 2) {
        orgModel.rpid = [orgDic lzNSStringForKey:@"userrpid"];

    }
    orgModel.type = type;
    orgModel.showindex = showindex;
    
    return orgModel;
}
-(NetDiskOrgModel*)getOrgChildWithDic:(NSDictionary*)groupDic type:(NSInteger)type showindx:(NSInteger)showindex orgid:(NSString*)orgid{
    NetDiskOrgModel *orgModel = [[NetDiskOrgModel alloc] init];
    orgModel.groupid = [groupDic lzNSStringForKey:@"groupid"];
    orgModel.logo = [groupDic lzNSStringForKey:@"grouplogo"];
    orgModel.orgid = orgid;
    orgModel.name = [groupDic lzNSStringForKey:@"groupname"];
    orgModel.rpid = [groupDic lzNSStringForKey:@"grouprpid"];
    orgModel.type = type;
    orgModel.showindex = showindex;
    return orgModel;
}
-(void)parseOrgNormalList:(NSMutableDictionary*)dataDic {
    NSDictionary *datacontext = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *dataPost = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
  
    BOOL isSearch = NO;
    if ([[dataOther allKeys] containsObject:@"issearch"]) {
         isSearch = [[dataOther lzNSNumberForKey:@"issearch"] boolValue];
        
    }
    
    // 组织根
    NSString *classid = [dataPost lzNSStringForKey:@"folderid"];
    NSString *rpid = [dataPost lzNSStringForKey:@"rpid"];
    NSString *rootparentid = @"-";
    
    
    NSArray *folderArray = [datacontext lzNSArrayForKey:@"folders"];
    NSArray *fileArray = [datacontext lzNSArrayForKey:@"resources"];
    
    NSMutableArray *folderAllArray = [[NSMutableArray alloc] init];
    NSMutableArray *fileAllArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < folderArray.count; i++) {
         ResFolderModel *folder = [[ResFolderModel alloc] init];
         NSDictionary *folderDic = folderArray[i];
        [folder serializationWithDictionary:folderDic];
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folder.classid = classid;
        folder.descript = description;
//        classid = folder.parentid;
        folder.pinyin = [AppUtils transform:folder.name];
        [folderAllArray addObject:folder];
    }
    NSMutableArray *allCollection = [[NSMutableArray alloc] init];
    for (int i = 0; i < fileArray.count; i++) {
        ResModel *file = [[ResModel alloc] init];
        NSDictionary *fileDic = fileArray[i];
        NSMutableDictionary *favoriteDic = [fileDic lzNSMutableDictionaryForKey:@"resourcefavorite"];
        NSInteger isFavorite = [[favoriteDic objectForKey:@"isfavorite"] integerValue];
        [file serializationWithDictionary:fileDic];
        file.descript = [fileDic objectForKey:@"description"];
        file.isfavorite = isFavorite;
        file.favoritesDic = [NSMutableDictionary dictionaryWithDictionary:favoriteDic];
         [fileAllArray addObject:file];
        classid = file.classid;
        
        if (isFavorite) {
            FavoritesModel *collectionModel = [[FavoritesModel alloc] init];
            [collectionModel serializationWithDictionary:favoriteDic];
            collectionModel.descript = [favoriteDic objectForKey:@"description"];
            collectionModel.size = file.size;
            collectionModel.favoriteid= file.rid;
            collectionModel.exptype = file.exptype;
            [allCollection addObject:collectionModel];
        }
    }
    if (self.appDelegate.lzGlobalVariable.isGetOrgNetDiskRootFolder && !isSearch) {
        // 组织根id 只第一页走
        ResFolderModel *rootFolderModel = [[ResFolderModel alloc] init];
        rootFolderModel.classid = classid;
        rootFolderModel.parentid = rootparentid;
        rootFolderModel.rpid = rpid;
        rootFolderModel.name = @"全部文件";
        [folderAllArray addObject:rootFolderModel];
    }
    if (!isSearch) {
        // 添加到数据库
        [[FavoritesDAL shareInstance] addDataWithFavoriteArray:allCollection];
        // 先删除本地一级数据
        //[[ResFolderDAL shareInstance] deleteFolderWithPraentId:classid];
        //[[ResFolderDAL shareInstance] addDataWithArray:folderAllArray];
        
        
        if (self.appDelegate.lzGlobalVariable.isDeleteLocalData) {
            NSLog(@"删除云盘文件classid%@",classid);
            [[ResDAL shareInstance] deleteAllResWithClassid:classid];
            self.appDelegate.lzGlobalVariable.isDeleteLocalData = NO;
        }
        [[ResDAL shareInstance] addDataWithArray:fileAllArray];
    }
    
    
    NSDictionary * curDic = [dataPost lzNSDictonaryForKey:@"querysbqmodel"];
    NSInteger preTableViewCount = ((NSNumber *)[curDic objectForKey:@"currentnumber"]).integerValue;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:preTableViewCount] forKey:@"pre"];
    [dic setObject:[NSNumber numberWithInteger:fileAllArray.count] forKey:@"add"];
    
    if (isSearch) {
          /* 在主线程中发送通知 */
          dispatch_async(dispatch_get_main_queue(), ^{
              __block CloudDiskAppFolderParse * service = self;
              
              EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskOrganization_OrganizationNormalList_SearchResult, (@{@"folderArr":folderAllArray,@"fileArr":fileAllArray}));
          });

    }
    else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CloudDiskAppFolderParse * service = self;
            
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskOrganization_OrganizationNormalList, dic);
        });

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
