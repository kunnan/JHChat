//
//  DataAccessMain.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 基础表维护
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "DataAccessMain.h"
#import "ImRecentDAL.h"
#import "ImGroupDAL.h"
#import "ImGroupUserDAL.h"
#import "ImChatLogDAL.h"
#import "UserDAL.h"
#import "UserContactDAL.h"
#import "UserContactGroupDAL.h"
#import "UserContactOfenCooperationDAL.h"
#import "UserIntervateDAL.h"
#import "OrgEnterPriseDAL.h"
#import "OrgDAL.h"
#import "OrgAdminDAL.h"
#import "OrgUserDAL.h"
#import "OrgUserIntervateDAL.h"
#import "OrgUserApplyDAL.h"
#import "ResDAL.h"
#import "ResRecycleDAL.h"
#import "ResFolderDAL.h"
#import "ResShareDAL.h" 
#import "ResShareItemDAL.h"
#import "PostDAL.h"
#import "PostPraiseDAL.h"
#import "CoGroupDAL.h"
#import "CoMemberDAL.h"
#import "CoProjectDAL.h"
#import "CoProjectStageDAL.h"
#import "CoProjectStageTaskDAL.h"
#import "CoTaskDAL.h"
#import "CoLayoutDAL.h"
#import "AppDAL.h"
#import "FavoritesDAL.h"
#import "ImMsgQueueDAL.h"
#import "TagDataDAL.h"
#import "CoTaskTransferDAL.h"
#import "CoTaskPhaseDAL.h"
#import "CoTaskRelatedDAL.h"
#import "PostPromptDAL.h"
#import "PostFileDAL.h"
#import "PostNotificationDAL.h"
#import "ResBagDAL.h"
#import "FavoriteTypeDAL.h"
#import "UserIntervateDAL.h"
#import "UserInfoDAL.h"
#import "ResFileiconDAL.h"
#import "ResHistoryVersionDAL.h"
#import "LZFMDatabase.h"
#import "CoAppDAL.h"
#import "CooOfNewTaskDAL.h"
#import "ErrorDAL.h"
#import "SystemInfoDAL.h"

#import "NSString+IsNullOrEmpty.h"
#import "CoManageDAL.h"
#import "CooOfNewMemberDAL.h"

#import "PostTemplateDAL.h"
#import "PostCooperationTypeDAL.h"

#import "ImMsgTemplateDAL.h"
#import "ImVersionTemplateDAL.h"
#import "CoRoleDAL.h"
#import "FilePathUtil.h"
#import "FavoriteTypeDAL.h"

#import "CoProjectMainGroupDAL.h"
#import "CoProjectsMainDAL.h"
#import "CoTransactionPostInfoDAL.h"
#import "CoTransactionTypeDAL.h"
#import "CoProjectsMainDAL.h"
#import "CoProjectMainModsDAL.h"

#import "AppBaseServerDAL.h"
#import "AppTempDAL.h"
#import "PostReplyTextDAL.h"

#import "LZFMDatabaseQueue.h"
#import "CoExtendTypeDAL.h"
#import "BusinessSessionRecentDAL.h"
#import "ServerCirclesDAL.h"
#import "SelfAppDAL.h"
#import "AppMenuDAL.h"

#import "AliyunGalleryFileDAL.h"
#import "AliyunRemotrlyServerDAL.h"
#import "AliyunRemotelyAccountDAL.h"
#import "AliyunFileidsDAL.h"
#import "LZFormat.h"
#import "SDWebImageManager.h"
#import "NetDiskOrgDAL.h"
#import "CommonTemplateTypeDAL.h"
#import "ImGroupCallDAL.h"
#import "SysApiVersionDAL.h"
#import "ImGroupRobotWeatherDAL.h"
#import "ImGroupRobotInfoDAL.h"
#import "ImMsgAppDAL.h"

@implementation DataAccessMain

/**
 *  创建或升级数据库
 */
-(BOOL)createOrUpdateDataTable{
    /* 数据库未创建时，进行创建 */
    if (![self checkIsCreatedDB]) {
        [self createDataTable:@""];
    }
    
    /* 判断数据库是否存在 */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[LZFMDatabase getDbPath:@""]]){
        return NO;
    }
    
    /* 判断是否需要升版 */
    BOOL isSucess = [self updateDataTable];
    if(!isSucess){
//        //删除原数据库，并备份
//        NSString *dbFileName = [NSString stringWithFormat:@"%@%@.db",@"LeadingCloudMain_BAK_",[LZFormat FormatNow2String]];
//        NSString *dbBakPath = [[FilePathUtil getDbDicPath] stringByAppendingFormat:@"%@",dbFileName];
//        [fileManager moveItemAtPath:[LZFMDatabase getDbPath] toPath:dbBakPath error:nil];

        /* 删除原数据库 */
        NSError *error = nil;
        [fileManager removeItemAtPath:[LZFMDatabase getDbPath:@""] error:&error];
//        [fileManager removeItemAtPath:[LZFMDatabase getDbPath:LeadingCloudError_Type] error:&error];
        
        /* 避免加密和非加密之间切换时出错 */
        [LZFMDatabaseQueue setInstanceToNil];
    }
    
    return isSucess;
}

/**
 *  创建数据库表
 */
-(void)createDataTable:(NSString *)type{
    
//    if([type isEqualToString:LeadingCloudError_Type]){
//        /* 复制数据库 */
//        NSString *dbVersion1 = @"";
//        if([LZFMDatabase getIsEncryption]){
//            dbVersion1 = [[NSBundle mainBundle]pathForResource:@"LeadingCloudError_PT_V1_Encry" ofType:@"db"];
//        } else {
//            dbVersion1 = [[NSBundle mainBundle]pathForResource:@"LeadingCloudError_PT_V1_Normal" ofType:@"db"];
//        }
//
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSError *error = nil;
//        [fileManager copyItemAtPath:dbVersion1 toPath:[LZFMDatabase getDbPath:LeadingCloudError_Type] error:&error];
//    } else {
        /* 复制数据库 */
        NSString *dbVersion1 = @"";
        if([LZFMDatabase getIsEncryption]){
            dbVersion1 = [[NSBundle mainBundle]pathForResource:@"LeadingCloudMain_PT_V1_Encry" ofType:@"db"];
        } else {
            dbVersion1 = [[NSBundle mainBundle]pathForResource:@"LeadingCloudMain_PT_V1_Normal" ofType:@"db"];
        }

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        [fileManager copyItemAtPath:dbVersion1 toPath:[LZFMDatabase getDbPath:@""] error:&error];
//    }
    
    
    /* 用户信息表 */
//    [[UserDAL shareInstance] createUserTableIfNotExists];
//    [[UserContactDAL shareInstance] createUserContactTableIfNotExists];
//    [[UserIntervateDAL shareInstance ] createUserContactTableIfNotExists];
//    [[UserContactGroupDAL shareInstance] createUserTableIfNotExists];
//    [[UserContactOfenCooperationDAL shareInstance] createUserContactOfenCooperationTableIfNotExists];
//    [[UserInfoDAL shareInstance]createUserInfoTableIfNotExists];
//    
//    /* 组织信息表 */
//    [[OrgEnterPriseDAL shareInstance] createOrgEnterPriseTableIfNotExists];
//    [[OrgDAL shareInstance] createOrgTableIfNotExists];
//    [[OrgAdminDAL shareInstance] createOrgAdminTableIfNotExists];
//    [[OrgUserDAL shareInstance] createOrgUserTableIfNotExists];
//    [[OrgUserIntervateDAL shareInstance] createOrgUserIntervateTableIfNotExists];
//    [[OrgUserApplyDAL shareInstance] createOrgUserApplyTableIfNotExists];
//    
//    /* 标签表 */
//    [[TagDataDAL shareInstance]createTagDataTableIfNotExists];
//    /* 资源表 */
//    [[ResDAL shareInstance] createResTableIfNotExists];
//    [[ResRecycleDAL shareInstance] createResRecycleTableIfNotExists];
//    [[ResFolderDAL shareInstance] createResFolderTableIfNotExists];
//    [[ResHistoryVersionDAL shareInstance] createResHistoryVersionTableIfNotExists];
//    /* 分享文件表 */
//    [[ResShareDAL shareInstance] createResShareFolderTableIfNotExists];
//    [[ResShareItemDAL shareInstance] createResShareItemTableIfNotExists];
//    /* 文件包里面的资源表 */
//    [[ResBagDAL shareInstance] createResBagTableIfNotExists];
//    /* 文件图像表 */
//    [[ResFileiconDAL shareInstance] createResFileiconTableIfNotExists];
//    
//    /* 动态表 */
//    [[PostDAL shareInstance] createPostTableIfNotExists];
//    [[PostPraiseDAL shareInstance] createPostPraiseTableIfNotExists];
//    [[PostPromptDAL shareInstance]createPostPromptTableIfNotExists];
//    [[PostFileDAL shareInstance]createPostFileTableIfNotExists];
//    [[PostNotificationDAL shareInstance]createPostNotificationTableIfNotExists];
//    [[PostTemplateDAL shareInstance]createPostTemplateTableIfNotExists];
//    [[PostCooperationTypeDAL shareInstance]createPostCooperationTypeTableIfNotExists];
//    /* 即时消息表 */
//    [[ImRecentDAL shareInstance] createImRecentTableIfNotExists];
//    [[ImGroupDAL shareInstance] createImGroupTableIfNotExists];
//    [[ImGroupUserDAL shareInstance] createImGroupUserTableIfNotExists];
//    [[ImChatLogDAL shareInstance] createImChatLogTableIfNotExists];
//    [[ImMsgQueueDAL shareInstance] createImMsgQueueTableIfNotExists];
//    [[ImMsgTemplateDAL shareInstance]createImMsgTemplateTableIfNotExists];
//    [[ImVersionTemplateDAL shareInstance] createImVersionTemplateTableIfNotExists];
//    
//    /* 协作表 */
//    [[CoGroupDAL shareInstance] createCoGroupTableIfNotExists];
//    [[CoMemberDAL shareInstance] createCoMemberTableIfNotExists];
//    [[CoProjectDAL shareInstance] createCoProjectTableIfNotExists];
//    [[CoProjectStageDAL shareInstance] createCoProjectStageTableIfNotExists];
//    [[CoProjectStageTaskDAL shareInstance] createCoProjectStageTaskTableIfNotExists];
//    [[CoTaskDAL shareInstance] createCoTaskTableIfNotExists];
//    [[CoTaskTransferDAL shareInstance]createCoTaskTransferIfNotExists];
//    [[CoTaskPhaseDAL shareInstance]createCoTaskPhaseIfNotExists];
//    [[CoTaskRelatedDAL shareInstance]createCoTaskRelatedIfNotExists];
//    [[CoLayoutDAL shareInstance] createCoLayoutTableIfNotExists];
//    [[CoManageDAL shareInstance] createCoManageTableIfNotExists];
//    [[CoRoleDAL shareInstance]createCoRoleTableIfNotExists];
//    /*新的协作表 */
//    [[CooOfNewTaskDAL shareInstance] createCooOfNewTaskTableIfNotExists];
//    [[CooOfNewMemberDAL shareInstance] createCooOfNewMemberTableIfNotExists];
//
//    /* 规则表 */
//
//    /* 应用管理表 */
//    [[AppDAL shareInstance] createAppTableIfNotExists];
//    /* 协作应用表 */
//    [[CoAppDAL shareInstance] createCooAppTableIfNotExists];
//    
//    /* 收藏管理 */
//    [[FavoritesDAL shareInstance] createFavoritesTableIfNotExists];
//    [[FavoriteTypeDAL shareInstance] createFavoriteTypeTableIfNotExists];
//    
//    /* 错误日志 */
//    [[ErrorDAL shareInstance]createErrorTableIfNotExists];
//    
//    /* 系统表 */
//    [[SystemInfoDAL shareInstance] createSystemInfoTableIfNotExists];
//    
//    /* 记录当前数据库版本 */
//    [self setCurrentDBVersion:1];
    
}

/**
 *  升级数据库
 */
-(BOOL)updateDataTable{
    
    /* 最新数据库版本 */
    int systemDbVersion = LeadingCloudMain_DBVersion;
    
    /* 当前数据库版本 */
    int currentDbVersion = [self getCurrentDBVersion];
   
    BOOL dbIsRight = YES;
    //对比版本号 判断是否升级
    if (currentDbVersion<systemDbVersion) {
        DDLogError(@"数据库进行升级!");
        //创建数据库表
        for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
            switch (i) {
                case 10:{
                    [[CoProjectMainGroupDAL shareInstance] creatProjectMainGroupTableIfNotExists];
                    
                    [[CoTransactionPostInfoDAL shareInstance]createCoTransactionPostInfoTableIfNotExists];
                    
                    break;
                }
                case 11: {
                    [[CoProjectsMainDAL shareInstance] creatProjectsMainTableIfNotExists];
                    break;
                }
                case 12: {
                    [[CoTransactionTypeDAL shareInstance]createCoTransactionTypeTableIfNotExists];
                    [[CoProjectMainModsDAL shareInstance] creatProjectMainModsTableIfNotExists];
                    break;
                }
                case 14: {
                    [[AppBaseServerDAL shareInstance]creatAppBaseServerTableIfNotExists];
                    break;
                }
                case 20: {
                    [[AppTempDAL shareInstance] createAppTempTableIfNotExists];
                    break;
                }
                case 40: {
                    [[PostReplyTextDAL shareInstance]createPostReplyTextTableIfNotExists];
                    break;
                }
                case 47: {
                    [[CoExtendTypeDAL shareInstance] createCoExtendTypeTableIfNotExists];
                    break;
                }
                case 48: {
                    [[ServerCirclesDAL shareInstance] createServerCirclesTableIfNotExists];
                    break;
                }
                case 51: {
                    [[SelfAppDAL shareInstance] createSelfAppTableIfNotExists];
                    [[AppMenuDAL shareInstance] createAppMenuTableIfNotExists];
                    break;
                }
                case 58: {
                    [[AliyunGalleryFileDAL shareInstance] createAliFileTableIfNotExists];
                    [[AliyunRemotrlyServerDAL shareInstance] createAliServerTableIfNotExists];
                    [[AliyunRemotelyAccountDAL shareInstance] createAliaccountTableIfNotExists];
                    break;
                }
                case 61: {
                    
                    [[AliyunFileidsDAL shareInstance] createAliFileidsTableIfNotExists];
                    break;
                }
                case 62: {
                    
                    [[NetDiskOrgDAL shareInstance] createNetDiskOrgTableIfNotExists];
                    break;
                }
				case 64: {
                    [[CommonTemplateTypeDAL shareInstance]createCommonTemplateTypeTableIfNotExists];
                    [[ImGroupCallDAL shareInstance] createImGroupCallTableIfNotExists];
					break;
				}
                case 71: {
                    [[SysApiVersionDAL shareInstance] createSysApiVersionTableIfNotExists];
                    break;
                }
                case 74: {
                    [[BusinessSessionRecentDAL shareInstance] createBusinessSessionRecentTableIfNotExists];
                    break;
                }
                case 78: {
//                    [[ErrorDAL shareInstance] createErrorTableIfNotExists];
//                    [self createDataTable:LeadingCloudError_Type];
                    break;
                }
                case 91: {
                    [[ImGroupRobotInfoDAL shareInstance] createImGroupRobotInfoTableIfNotExists];
                    [[ImGroupRobotWeatherDAL shareInstance] createImGroupRobotWeatherTableIfNotExists];
                    break;
                }
                case 93: {
                    [[ImMsgAppDAL shareInstance] createImMsgAppTableIfNotExists];
                    break;
                }
            }
        }
        
        //修改数据库表中的字段
//        [[UserDB shareInstance] updateUserTableDBVersion:dbVersion buildVersion:buildVersion];
        [[ImChatLogDAL shareInstance] updateImChatLogTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ResRecycleDAL shareInstance] updateResRecycleTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ResShareDAL shareInstance] updateResShareFolderTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ResShareItemDAL shareInstance] updateResShareItemTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ResDAL shareInstance] updateResTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ResFolderDAL shareInstance] updateResFolderTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ResFileiconDAL shareInstance] updateResFileiconTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ImGroupDAL shareInstance] updateImGroupTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ImGroupUserDAL shareInstance] updateImGroupUserTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[AppDAL shareInstance] updateAppTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[CoAppDAL shareInstance] updateCooAppTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[UserContactOfenCooperationDAL shareInstance] updateUserContactOfenCooperationTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[CoProjectDAL shareInstance]updateCoProjectTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[UserIntervateDAL shareInstance]updateUserIntervateTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];

        [[CoTaskDAL shareInstance]updateCoTaskTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        
        [[CoGroupDAL shareInstance]updateCoGroupTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        
        [[CooOfNewTaskDAL shareInstance] updateCooOfNewTaskTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[PostDAL shareInstance]updatePostTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[FavoritesDAL shareInstance] updateFavoritesTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[OrgEnterPriseDAL shareInstance] updateOrgEnterPriseTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[CooOfNewMemberDAL shareInstance] updateCooOfNewMemberTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ImRecentDAL shareInstance] updateImRecentTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[OrgUserIntervateDAL shareInstance]updateOrgUserIntervateTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ErrorDAL shareInstance]updateErrorTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ImMsgTemplateDAL shareInstance]updateImMsgTemplateTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ImVersionTemplateDAL shareInstance] updateImVersionTemplateTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        
        [[PostCooperationTypeDAL shareInstance]updatePostCooperationTypeTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[FavoriteTypeDAL shareInstance]updateFavoriteTypeTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[CoProjectMainGroupDAL shareInstance] updataCoProjectMainGroupTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[CoProjectsMainDAL shareInstance] updataCoProjectMainTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[CoProjectMainModsDAL shareInstance] updataCoProjectMainModsTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ServerCirclesDAL shareInstance]updateServerCirclesTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[SelfAppDAL shareInstance] updateSelfAppTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[AppMenuDAL shareInstance] updateAppMenuTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[UserDAL shareInstance] updateUserTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[ImGroupCallDAL shareInstance] updateImGroupCallTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[AliyunFileidsDAL shareInstance] updateAliFileidsTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[AliyunRemotrlyServerDAL shareInstance] updateAliyunTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[SysApiVersionDAL shareInstance] updateSysApiVersionTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[BusinessSessionRecentDAL shareInstance] updateBusinessSessionRecentTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[AppTempDAL shareInstance] updateAppTempTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        [[CoExtendTypeDAL shareInstance] updateCoExtendTypeTableCurrentDBVersion:currentDbVersion systemDbVersion:systemDbVersion];
        //删除数据库中的表
        for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
            switch (i) {
                case 47:{
                    //删除userPhoto表
//                    [[UserPhotoDB shareInstance] deleteUserPhotoTableIfExists];
                    /* 清除chatlog表中的两个字段 */
                    [[ImChatLogDAL shareInstance] updateHeightForRowAndtextMsgSizeToNull];
                    break;
                }
                case 48:{
                    /* 清空群组的数据 */
                    [[ImGroupDAL shareInstance] deleteGroupInfoImTypeIsTwo];
                    break;
                }
                case 58: {
                    [[ImChatLogDAL shareInstance] updateHeightForRowAndtextMsgSizeToNull];
                    break;
                }
                case 59:{
                    [LZUserDataManager saveLastestLoginDate:@""];
                    break;
                }
                case 60: {
                    [[ImGroupDAL shareInstance] deleteGroupAndGroupUserData];
                    break;
                }
                case 62: {
                    [LZUserDataManager saveLastestLoginDate:@""];
                    break;
                }
                case 63:{
                    /* 删除新的好友内存缓存 */
                    NSString *faceImgName = [NSString stringWithFormat:@"114278661537935360.jpg"];
                    SDWebImageManager *sharedSmallManager = [SDWebImageManager sharedManager:[FilePathUtil getMsgTemplateImageDicRelatePath]];
                    [sharedSmallManager.imageCache removeImageForKey:faceImgName];
                }
                case 68:{
                    [LZUserDataManager saveLastestLoginDate:@""];
                    break;
                }
                case 73:{
                    [[BusinessSessionRecentDAL shareInstance]dropTableBusinessSessionRecentAndBusinessSessionRecent1];
                    break;
                }
                case 74:{
                    [[BusinessSessionRecentDAL shareInstance]dropTableBusiness_Session_Recent];
                    break;
                }
                case 79: {
                    [LZUserDataManager saveLastestLoginDate:@""];
                    [[ImChatLogDAL shareInstance] updateHeightForRowAndtextMsgSizeToNull];
                    break;
                }
                case 81: {
                    [[ImChatLogDAL shareInstance] updateHeightForRowAndtextMsgSizeToNull];
                    break;
                }
                case 91: {
                    /* 将不显示的群组更新为临时状态 */
                    [[ImGroupDAL shareInstance] updateOtherGroupWithTempStatus];
                    break;
                }
//                default:
//                    break;
            }
        }

        /* 解析plist文件，判断表名和字段名是否存在 */
        NSString *plistPath =  [[NSBundle mainBundle] pathForResource:@"DBDALInfo" ofType:@"plist"];
        NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        /* 得到所有的表名 */
        for (NSString *tableName in [mutableDic allKeys]) {
            /* 判断表名没有创建成功 */
            if (![[[LZFMDatabase alloc] init] checkIsExistsTable:tableName]) {
                DDLogError(@"%@表没有创建成功！", tableName);
                dbIsRight = NO;
                break;
            } else {
                /* 表创建成功，接着判断字段有没有创建成功 */
                NSDictionary *obj = [mutableDic lzNSDictonaryForKey:tableName];
                /* 得到表中所有字段名 */
                for (NSString *fieldName in [obj allKeys]) {

                    NSString *descript = [obj lzNSStringForKey:fieldName];
                    if(![descript isEqualToString:@"1"]){
                        /* 判断是否不需要判断此版本(需要判断currentDbVersion之后的版本) */
                        NSInteger version = 0;
                        descript = [[descript stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                        if([descript rangeOfString:@"version:"].location != NSNotFound
                           && [descript rangeOfString:@"author:"].location != NSNotFound){
                            NSUInteger start = [descript rangeOfString:@"version:"].location+8;
                            descript = [descript substringFromIndex:start];
                            NSUInteger end = [descript rangeOfString:@"author:"].location;
                            descript = [descript substringToIndex:end];
                            version = [LZFormat Safe2Int32:descript];
                        }
                        if(version==0 || version<=currentDbVersion){
                            continue;
                        }
                        DDLogVerbose(@"需要判断，version:%ld---Table:%@字段:%@",version,tableName,fieldName);
                        
                        /* 判断表中的所有字段是否都创建成功 */
                        if (![[[LZFMDatabase alloc] init] checkIsExistsFieldInTable:tableName fieldName:fieldName]) {
                            DDLogError(@"%@表中的%@字段没有创建成功！", tableName, fieldName);
                            dbIsRight = NO;
                            break;
                        }

                    }
                }
            }
        }
        
        //升级数据库版本
        if(dbIsRight){
            [self setCurrentDBVersion:LeadingCloudMain_DBVersion];
        }
    } else {
       DDLogError(@"数据库进行升级!====no");
    }
    
    return dbIsRight;
}

/**
 *  判断是否创建了数据库
 */
-(BOOL)checkIsCreatedDB{
    
    BOOL isCreate = false;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![NSString isNullOrEmpty:[AppUtils GetCurrentUserID]]
        && [fm fileExistsAtPath:[LZFMDatabase getDbPath:@""]]) {
        isCreate = YES;
    }
    return isCreate;
}

/**
 *  记录当前数据库版本
 */
-(void)setCurrentDBVersion:(NSInteger)dbversion{
    SystemInfoModel *systemInfoModel = [[SystemInfoModel alloc] init];
    systemInfoModel.si_key = SystemInfo_DbVersion;
    systemInfoModel.si_value = [NSString stringWithFormat:@"%ld",(long)dbversion];
    [[SystemInfoDAL shareInstance] addDataWithSystemInfoModel:systemInfoModel];
}

/**
 *  获取当前数据库版本
 */
-(int)getCurrentDBVersion{
    int currentDbVersion = 1;
    SystemInfoModel *systemInfoModel = [[SystemInfoDAL shareInstance] getSystemInfoModelWithKey:SystemInfo_DbVersion];
    if(systemInfoModel==nil || [NSString isNullOrEmpty:systemInfoModel.si_value]){
        currentDbVersion = 1;
    }
    else {
        currentDbVersion = [systemInfoModel.si_value intValue];
    }
    return currentDbVersion;
}

@end
