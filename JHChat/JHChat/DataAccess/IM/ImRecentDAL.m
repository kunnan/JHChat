//
//  ImRecentDAL.m
//  LeadingCloud
//
//  Created by wchMac on 15/11/30.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 最近消息数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ImRecentDAL.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "ImRecentModel.h"
#import "AppDateUtil.h"
#import "LZFMDatabaseQueue.h"
#import "ImChatLogDAL.h"
#import "ImChatLogModel.h"
#import "ImGroupDAL.h"
#import "ImGroupModel.h"
#import "UserDAL.h"
#import "UserModel.h"
#import "MessageRootSearchModel.h"
#import "NSString+SerialToDic.h"
#import "MsgTemplateViewModel.h"
#import "OrgEnterPriseDAL.h"
#import "NSString+IsNullOrEmpty.h"
#import "ImGroupCallDAL.h"
#import "ImGroupCallModel.h"
#import "LZBaseAppDelegate.h"
#import "ImGroupRobotWeatherDAL.h"

#define instanceColumns @"irid,contactid,contactname,contacttype,ifnull(relatetype,0) as relatetype,face,lastdate,lastmsg,lastmsguser,lastmsgid,lastmsgusername,ifnull(badge,0) as badge,isdel,autodownloaddate,ifnull(isremindme,0) as isremindme,ifnull(isrecordmsgnorecallreceive,0) as isrecordmsgnorecallreceive,ifnull(isrecordmsg,0) as isrecordmsg,presynck,presynckdate,issettop,ifnull(isexistsgroup,1) as isexistsgroup,ifnull(showmode,0) as showmode,ifnull(parsetype,0) as parsetype,bkid,ifnull(stick,0) as stick, ifnull(isonedisturb,0) as isonedisturb"

@implementation ImRecentDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImRecentDAL *)shareInstance
{
    static ImRecentDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ImRecentDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImRecentTableIfNotExists
{
    NSString *tableName = @"im_recent";

    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                                                     "[irid] [varchar](50) PRIMARY KEY NOT NULL,"
                                                                     "[contactid] [varchar](50) NULL,"
                                                                     "[contactname] [varchar](100) NULL,"
                                                                     "[contacttype] [integer] NULL,"
                                                                     "[relatetype] [integer] NULL,"
                                                                     "[face] [varchar](50) NULL,"
                                                                     "[lastdate] [date] NULL,"
                                                                     "[lastmsg] [varchar](100) NULL,"
                                                                     "[badge] [integer] NULL,"
                                                                     "[isdel] [integer] NULL,"
                                                                     "[autodownloaddate] [date] NULL,"
                                                                     "[isremindme] [integer] NULL,"
                                                                     "[presynck] [varchar](50) NULL,"
                                                                     "[presynckdate] [date] NULL,"
                                                                     "[issettop] [integer] NULL,"
                                         "[isexistsgroup] [integer] NULL);",
                                         tableName]];

    }
}
/**
 *  升级数据库
 */
-(void)updateImRecentTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 15:{
                [self AddColumnToTableIfNotExist:@"im_recent" columnName:@"[lastmsguser]" type:@"[varchar](50)"];
                [self AddColumnToTableIfNotExist:@"im_recent" columnName:@"[lastmsgusername]" type:@"[varchar](100)"];
                break;
            }
            case 25:{
                [self AddColumnToTableIfNotExist:@"im_recent" columnName:@"[showmode]" type:@"[integer]"];
                break;
            }
            case 56:{
                [self AddColumnToTableIfNotExist:@"im_recent" columnName:@"[lastmsgid]" type:@"[varchar](50)"];
                break;
            }
            case 68:{
                [self AddColumnToTableIfNotExist:@"im_recent" columnName:@"[parsetype]" type:@"[integer]"];
                break;
            }
            case 71:{
                [self AddColumnToTableIfNotExist:@"im_recent" columnName:@"[isrecordmsg]" type:@"[integer]"];
                break;
            }
            case 72:{
                [self AddColumnToTableIfNotExist:@"im_recent" columnName:@"[isrecordmsgnorecallreceive]" type:@"[integer]"];
                break;
            }
            case 73:{
                [self AddColumnToTableIfNotExist:@"im_recent" columnName:@"[bkid]" type:@"[varchar](100)"];
                break;
            }
            case 82:{
                [self AddColumnToTableIfNotExist:@"im_recent" columnName:@"[stick]" type:@"[varchar](50)"];
                break;
            }
            case 84:{
                [self updateStickToZero];
                [LZUserDataManager saveLastestLoginDate:@""];
                break;
            }
            case 86:{
                [self AddColumnToTableIfNotExist:@"im_recent" columnName:@"[isonedisturb]" type:@"[varchar](50)"];
                break;
            }
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithImRecentArray:(NSMutableArray *)imRecentArray{

    [[self getDbQuene:@"im_recent" FunctionName:@"addDataWithImRecentArray:(NSMutableArray *)imRecentArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< imRecentArray.count;  i++) {
            ImRecentModel *recentModel = [imRecentArray objectAtIndex:i];
            
            NSString *irid = recentModel.irid;
            NSString *contactid = recentModel.contactid;
            NSString *contactname = recentModel.contactname;
            NSNumber *contacttype = [NSNumber numberWithInteger:recentModel.contacttype];
            NSNumber *relatetype = [NSNumber numberWithInteger:recentModel.relatetype];
            NSString *face = recentModel.face;
            NSDate *lastdate = recentModel.lastdate;
            NSString *lastmsg = recentModel.lastmsg;
            NSString *lastmsguser = recentModel.lastmsguser;
            NSString *lastmsgusername = recentModel.lastmsgusername;
            NSNumber *badge = [NSNumber numberWithInteger:recentModel.badge];
            NSNumber *isdel = [NSNumber numberWithInteger:recentModel.isdel];
            NSNumber *isremindme = [NSNumber numberWithInteger:recentModel.isremindme];
            NSString *presynck = recentModel.presynck;
            NSDate *presynckdate = recentModel.presynckdate;
            NSNumber *issettop = [NSNumber numberWithInteger:0];
            NSNumber *isexistsgroup = [NSNumber numberWithInteger:recentModel.isexistsgroup];
            NSNumber *showmode = [NSNumber numberWithInteger:recentModel.showmode];
            NSString *lastmsgid = recentModel.lastmsgid;
            NSNumber *parsetype = [NSNumber numberWithInteger:recentModel.parsetype];
            NSNumber *isrecordmsg = [NSNumber numberWithInteger:recentModel.isrecordmsg];
            NSNumber *isrecordmsgnorecallreceive = [NSNumber numberWithInteger:recentModel.isrecordmsgnorecallreceive];
            NSString *bkid = recentModel.bkid;
            NSString *stick = recentModel.stick;
            if([NSString isNullOrEmpty:stick]){
                stick = @"0";
            }
            NSString *isonedisturb = recentModel.isonedisturb;
            if([NSString isNullOrEmpty:isonedisturb]){
                isonedisturb = @"0";
            }
            
            BOOL isExists = NO;
            NSString *checkExistsSql = [NSString stringWithFormat:@"select count(0) count from im_recent Where contactid='%@'", contactid];
            FMResultSet *checkExistsResultSet=[db executeQuery:checkExistsSql];
            if ([checkExistsResultSet next]) {
                NSInteger count = [checkExistsResultSet intForColumn:@"count"];
                if(count>0){
                    isExists = YES;
                }
            }
            
            if(!isExists){
                NSString *sql = @"INSERT OR REPLACE INTO im_recent(irid,contactid,contactname,contacttype,relatetype,face,lastdate,lastmsg,lastmsguser,lastmsgusername,badge,isdel,isremindme,presynck,presynckdate,issettop,isexistsgroup,showmode,lastmsgid,parsetype,isrecordmsg,isrecordmsgnorecallreceive,bkid,stick,isonedisturb)"
                "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                isOK = [db executeUpdate:sql,irid,contactid,contactname,contacttype,relatetype,face,lastdate,lastmsg,lastmsguser,lastmsgusername,badge,isdel,isremindme,presynck,presynckdate,issettop,isexistsgroup,showmode,lastmsgid,parsetype,isrecordmsg,isrecordmsgnorecallreceive,bkid,stick,isonedisturb];
                if (!isOK) {
                    DDLogError(@"插入失败");
					[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"插入失败" Other:nil];

                    break;
                }
            } else {                
                NSString *sql = @"Update im_recent set irid=?,contactname=?,contacttype=?,relatetype=?,face=?,lastdate=?,lastmsg=?,lastmsguser=?,lastmsgusername=?,isdel=?,isexistsgroup=?,showmode=?,lastmsgid=?,parsetype=?,bkid=?,stick=?,isonedisturb=? where contactid=?";
                isOK = [db executeUpdate:sql,irid,contactname,contacttype,relatetype,face,lastdate,lastmsg,lastmsguser,lastmsgusername,isdel,isexistsgroup,showmode,lastmsgid,parsetype,bkid,stick,isonedisturb,contactid];
                if (!isOK) {
                    DDLogError(@"更新失败");
					[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"插入失败" Other:nil];

                    break;
                }
            }
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    
}

/**
 *  添加单条数据
 */
-(BOOL)addImRecentWithModel:(ImRecentModel *)recentModel isAddIfExists:(BOOL)isAddIfExists{
    __block BOOL isSaveSuccess = YES;
    [[self getDbQuene:@"im_recent" FunctionName:@"addImRecentWithModel:(ImRecentModel *)recentModel isAddIfExists:(BOOL)isAddIfExists"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *irid = recentModel.irid;
        NSString *contactid = recentModel.contactid;
        NSString *contactname = recentModel.contactname;
        NSNumber *contacttype = [NSNumber numberWithInteger:recentModel.contacttype];
        NSNumber *relatetype = [NSNumber numberWithInteger:recentModel.relatetype];
        NSString *face = recentModel.face;
        NSDate *lastdate = recentModel.lastdate;
        NSString *lastmsg = recentModel.lastmsg;
        NSString *lastmsgusername = recentModel.lastmsgusername;
        NSString *lastmsguser = recentModel.lastmsguser;
        NSNumber *badge = [NSNumber numberWithInteger:recentModel.badge];
        NSNumber *isdel = [NSNumber numberWithInteger:0];
        NSString *presynck = recentModel.presynck;
        NSDate *presynckdate = recentModel.presynckdate;
        NSNumber *issettop = [NSNumber numberWithInteger:0];
        NSNumber *isexistsgroup = [NSNumber numberWithInteger:recentModel.isexistsgroup];
        NSNumber *showmode = [NSNumber numberWithInteger:recentModel.showmode];
        NSString *lastmsgid = recentModel.lastmsgid;
        NSNumber *parsetype = [NSNumber numberWithInteger:recentModel.parsetype];
        NSNumber *isrecordmsgnorecallreceive = [NSNumber numberWithInteger:recentModel.isrecordmsgnorecallreceive];
        NSString *bkid = recentModel.bkid;
        NSString *stick = recentModel.stick;
        if([NSString isNullOrEmpty:stick]){
            stick = @"0";
        }
        NSString *isonedisturb = recentModel.isonedisturb;
        if([NSString isNullOrEmpty:isonedisturb]){
            isonedisturb = @"0";
        }
        /* 存在时不添加 */
        if(!isAddIfExists){
            __block NSInteger resCount = 0;
            NSString *checkSql=[NSString stringWithFormat:@"Select count(0) count From im_recent Where contactid='%@'",contactid];
            FMResultSet *resultSet=[db executeQuery:checkSql];
            if ([resultSet next]) {
                resCount = [resultSet intForColumn:@"count"];
            }
            if(resCount>0){
                return;
            }
        }
        
        NSString *sql = @"INSERT OR REPLACE INTO im_recent(irid,contactid,contactname,contacttype,relatetype,face,lastdate,lastmsg,lastmsguser,lastmsgusername,badge,isdel,presynck,presynckdate,issettop,isexistsgroup,showmode,lastmsgid,parsetype,isrecordmsgnorecallreceive,bkid,stick,isonedisturb)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,irid,contactid,contactname,contacttype,relatetype,face,lastdate,lastmsg,lastmsguser,lastmsgusername,badge,isdel,presynck,presynckdate,issettop,isexistsgroup,showmode,lastmsgid,parsetype,isrecordmsgnorecallreceive,bkid,stick,isonedisturb];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"插入失败" Other:nil];
            isSaveSuccess = NO;
            DDLogError(@"插入失败");
        }
    }];
    return isSaveSuccess;
}

#pragma mark - 删除数据

/**
 *  根据Contactid删除最近联系人记录
 *
 *  @param contactid contactid
 */
-(void)deleteImRecentModelWithContactid:(NSString *)contactid{
    
    [[self getDbQuene:@"im_recent" FunctionName:@"deleteImRecentModelWithContactid:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_recent where contactid=?";
        isOK = [db executeUpdate:sql,contactid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - deleteImRecentModelWithContactid");
        }
    }];
}
#pragma mark - 修改数据

/**
 *  更新最近联系人信息
 *
 *  @param dialogid 聊天框ID
 */
-(BOOL)updateLastMsgWithDialogid:(NSString *)dialogid{
    ImChatLogModel *imChatLogModel = [[ImChatLogDAL shareInstance] getLastChatLogModelWithDialogId:dialogid];
    __block BOOL isGetedContactName = YES;
    if(imChatLogModel!=nil){
        /* 判断ImRecent表中是否含有此Contactid */
        BOOL isExists = [self checkIsExistsRecentWithContactid:dialogid];
        
        NSDate *lastdate = imChatLogModel.showindexdate;
        NSString *lastmsg = @"";
        NSString *lastmsguser = @"";
        NSString *lastmsgusername = @"";
        NSInteger isrecordmsgnorecallreceive = 0;
        
        /* 若为群且非系统消息，则必须更新lastmsgusername */
        if((imChatLogModel.totype==Chat_ToType_One || imChatLogModel.totype==Chat_ToType_Two || imChatLogModel.totype==Chat_ToType_Five || imChatLogModel.totype==Chat_ToType_Six)
           && ![imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_SR] ){            
            lastmsguser = imChatLogModel.imClmBodyModel.from;
            
            UserModel *userModel = [[UserDAL shareInstance] getUserModelForNameAndFace:lastmsguser];
            if(userModel!=nil){
                lastmsgusername = userModel.username;
            } else {
                ImGroupRobotWeatherModel *groupWeatherModel = [[ImGroupRobotWeatherDAL shareInstance] getimGroupRobotWeatherModelWithRwid:lastmsguser];
                lastmsgusername = groupWeatherModel.name;
                if ([NSString isNullOrEmpty:lastmsgusername]) {
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate.lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_LoadUser moduleServer:Modules_Default getData:nil postData:lastmsguser otherData:@{WebApi_DataSend_Other_Operate:@"update_imrecent_lastusername"}];
                }
            }
        }
        
        /* 拍照、图片 */
        if([imChatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_Image_Download]){
            lastmsg = imChatLogModel.imClmBodyModel.content;
        }
        /* 文件 */
        else if([imChatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_File_Download]){
            lastmsg = imChatLogModel.imClmBodyModel.content;
        }
        /* 视频 */
        else if([imChatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_Micro_Video]){
            lastmsg = imChatLogModel.imClmBodyModel.content;
        }
        /* 语音 */
        else if([imChatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_Voice]){
            lastmsg = imChatLogModel.imClmBodyModel.content;
        }
        /* 语音通话 */
        else if([imChatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_VoiceCall]){
            lastmsg = imChatLogModel.imClmBodyModel.content;
        }
        /* 视频通话 */
        else if([imChatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_VideoCall]){
            lastmsg = imChatLogModel.imClmBodyModel.content;
        }
        /* 多人视频通话 */
        else if ([imChatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_Call_Main] ||
                 [imChatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_Call_Unanswer] ||
                 [imChatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_Call_Finish]){
            lastmsg = imChatLogModel.imClmBodyModel.content;
            lastmsguser = @"";
            lastmsgusername = @"";
        }
        /* 位置 */
        else if([imChatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_Geolocation]){
            lastmsg = imChatLogModel.imClmBodyModel.content;
        }
        /* url链接 */
        else if ([imChatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_UrlLink]) {
            lastmsg = imChatLogModel.imClmBodyModel.content;
        }
        /* 共享文件 */
        else if ([imChatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_LZTemplateMsg_CooperationShareFile]) {
            lastmsg = imChatLogModel.imClmBodyModel.content;
        }
        /* 名片 */
        else if([imChatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_Card]){
            lastmsg = imChatLogModel.imClmBodyModel.content;
        }
        else if ([imChatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_ChatLog]) {
            lastmsg = imChatLogModel.imClmBodyModel.content;
        }
        /* 系统消息 */
        else if( [imChatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_SR] ){
            lastmsg = imChatLogModel.imClmBodyModel.systemmsg;
            if([NSString isNullOrEmpty:lastmsg]){
                lastmsg = imChatLogModel.imClmBodyModel.content;
            }
            lastmsg = [lastmsg stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
        }
        else {
            lastmsg = imChatLogModel.imClmBodyModel.content;
        }
        
//        ImRecentModel *recentmodel = [self getRecentModelWithContactid:dialogid];
        /* 最后一条消息的isrecall为1的情况就是 */
        if (imChatLogModel.isrecall == 1) {
            lastmsguser = @"";
            lastmsgusername = @"";
            if ([imChatLogModel.imClmBodyModel.from isEqualToString:[AppUtils GetCurrentUserID]]) {
                lastmsg = @"你撤回了一条消息";
            } else {
                lastmsg = [NSString stringWithFormat:@"\"%@\"撤回了一条消息", imChatLogModel.imClmBodyModel.sendusername];
            }
        }
        /* 最后一条消息是没有被撤回的接收的回执消息 */
        if (imChatLogModel.isrecordstatus == 1 &&
            imChatLogModel.isrecall == 0 &&
            ![imChatLogModel.from isEqualToString:[AppUtils GetCurrentUserID]] &&
            ([imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_LZMsgNormal_Text] ||
             [imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_Image_Download] ||
             [imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_File_Download] ||
             [imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_Card] ||
             [imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_Voice] ||
             [imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_Geolocation] ||
             [imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_Micro_Video] ||
             [imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_UrlLink] ||
             [imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_ChatLog] ||
             [imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_LZTemplateMsg_CooperationShareFile])) {
            isrecordmsgnorecallreceive = 1;
        }
        
        /* 处理业务会话（特殊处理） */
        if(imChatLogModel.totype == Chat_ToType_Five){
            imChatLogModel.fromtype = Chat_FromType_Three;
            imChatLogModel.from = Chat_ContactType_Second_OutWardlBusiness;
        }
        if(imChatLogModel.totype == Chat_ToType_Six){
            imChatLogModel.fromtype = Chat_FromType_Three;
            imChatLogModel.from = Chat_ContactType_Second_InternalBusiness;
        }
        
        if(isExists){
            __block NSString *contactname = @"";
            /* 单人 */
            if(imChatLogModel.totype==Chat_ToType_Zero){
                UserModel *userModel = [[UserDAL shareInstance] getUserModelForNameAndFace:dialogid];
                if(userModel!=nil){
                    contactname = userModel.username;
                }
            }
            /* 群组 */
            else if(imChatLogModel.totype==Chat_ToType_One
                    || imChatLogModel.totype==Chat_FromType_Two
                    || imChatLogModel.totype==Chat_ToType_Four){
                ImGroupModel *groupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:imChatLogModel.to];
                if(groupModel!=nil){
                    contactname = groupModel.name;
                }
            }
            /* 应用 */
            if(imChatLogModel.fromtype == Chat_FromType_Three){
                ImMsgTemplateModel *imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:dialogid];
                /* 处理业务会话（特殊处理） */
                if(imMsgTemplateModel==nil){
                    imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:imChatLogModel.from];
                }
                contactname = imMsgTemplateModel.name;
            }
            /* 企业 */
            else if(imChatLogModel.fromtype == Chat_FromType_Four){
                OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseDAL shareInstance] getEnterpriseByEId:dialogid];
                contactname = orgEnterPriseModel.shortname;
            }
            /* 个人提醒 */
            else if(imChatLogModel.fromtype == Chat_FromType_Five){
                ImMsgTemplateModel *imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:dialogid];
                contactname = imMsgTemplateModel.name;
            }
            
            [[self getDbQuene:@"im_recent" FunctionName:@"updateLastMsgWithDialogid:(NSString *)dialogid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
                BOOL isOK = NO;
                
                /* 获取到contactname */
                NSString *sql=[NSString stringWithFormat:@"Select contactname From im_recent Where contactid='%@'",dialogid];
                
                if([NSString isNullOrEmpty:contactname]){
                    FMResultSet *resultSet=[db executeQuery:sql];
                    
                    if ([resultSet next]) {
                        contactname = [resultSet stringForColumn:@"contactname"];
                    }
                }
                if([NSString isNullOrEmpty:contactname]){
                    isGetedContactName = NO;
                }

                /* 进行更新 */
                if(isGetedContactName){
                    sql = @"update im_recent set contactname=?,lastdate=?,lastmsg=?,lastmsguser=?,lastmsgusername=?,isrecordmsgnorecallreceive=?,isdel=0,showmode=?,lastmsgid=? Where contactid=?";
                    isOK = [db executeUpdate:sql,contactname,lastdate,lastmsg,lastmsguser,lastmsgusername,[NSNumber numberWithInteger:isrecordmsgnorecallreceive],[NSNumber numberWithInteger:imChatLogModel.imClmBodyModel.sendmode],imChatLogModel.msgid,dialogid];
                } else {
                    sql = @"update im_recent set lastdate=?,lastmsg=?,lastmsguser=?,lastmsgusername=?,isrecordmsgnorecallreceive=?,isdel=0,showmode=?,lastmsgid=? Where contactid=?";
                    isOK = [db executeUpdate:sql,lastdate,lastmsg,lastmsguser,lastmsgusername,[NSNumber numberWithInteger:isrecordmsgnorecallreceive],[NSNumber numberWithInteger:imChatLogModel.imClmBodyModel.sendmode],imChatLogModel.msgid,dialogid];
                }
                
                if (!isOK) {
					[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

                    DDLogError(@"更新失败 - updateLastMsgWithDialogid");
                }
            }];
            
        }
        else {
            ImRecentModel *imRecentModel = [[ImRecentModel alloc] init];
            imRecentModel.irid = [LZUtils CreateGUID];
            imRecentModel.contactid = dialogid;
            imRecentModel.contacttype = imChatLogModel.totype;
            imRecentModel.showmode = imChatLogModel.imClmBodyModel.sendmode;
            imRecentModel.lastmsgid = imChatLogModel.msgid;
            imRecentModel.parsetype = imChatLogModel.imClmBodyModel.parsetype;
            imRecentModel.bkid = imChatLogModel.imClmBodyModel.bkid;

            /* 单人 */
            if(imChatLogModel.totype==Chat_ToType_Zero){
                UserModel *userModel = [[UserDAL shareInstance] getUserModelForNameAndFace:dialogid];
                if(userModel!=nil){
                    imRecentModel.contactname = userModel.username;
                    imRecentModel.face = userModel.face;
                } else {
                    isGetedContactName = NO;
                }
            }
            /* 群组 */
            else if(imChatLogModel.totype==Chat_ToType_One
                    || imChatLogModel.totype==Chat_FromType_Two
                    || imChatLogModel.totype==Chat_ToType_Four){
                ImGroupModel *groupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:imChatLogModel.to];
                imRecentModel.isexistsgroup = 1;
                if(groupModel!=nil){
                    imRecentModel.contactname = groupModel.name;
                    imRecentModel.face = groupModel.face;
                    imRecentModel.contacttype = groupModel.imtype;
                    imRecentModel.relatetype = groupModel.relatetype;
                } else {
                    isGetedContactName = NO;
                }
            }
            /* 应用 */
            if(imChatLogModel.fromtype == Chat_FromType_Three){
                ImMsgTemplateModel *imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:imRecentModel.contactid];
                /* 处理业务会话（特殊处理） */
                if(imMsgTemplateModel==nil){
                    imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:imChatLogModel.from];
                }
                if(imMsgTemplateModel.type == 1){
                    imRecentModel.contacttype = Chat_ContactType_Main_App_Three;
                }
                else if(imMsgTemplateModel.type == 2){
                    imRecentModel.contacttype = Chat_ContactType_Main_App_Four;
                }
                else if(imMsgTemplateModel.type == 3){
                    imRecentModel.contacttype = Chat_ContactType_Main_App_Five;
                }
                imRecentModel.contactname = imMsgTemplateModel.name;
                imRecentModel.face = imMsgTemplateModel.icon;
                imRecentModel.isexistsgroup = 1;
            }
            /* 企业 */
            else if(imChatLogModel.fromtype == Chat_FromType_Four){
                OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseDAL shareInstance] getEnterpriseByEId:imRecentModel.contactid];
                imRecentModel.contacttype = Chat_ContactType_Main_App_Six;
                imRecentModel.contactname = orgEnterPriseModel.shortname;
                imRecentModel.face = orgEnterPriseModel.logo;
                imRecentModel.isexistsgroup = 1;
            }
            /* 个人提醒 */
            else if(imChatLogModel.fromtype == Chat_FromType_Five){
                ImMsgTemplateModel *imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:imRecentModel.contactid];
                
                imRecentModel.contacttype = Chat_ContactType_Main_App_Six;
                imRecentModel.contactname = imMsgTemplateModel.name;
                imRecentModel.face = imMsgTemplateModel.icon;
                imRecentModel.isexistsgroup = 1;
            }
            
            imRecentModel.lastdate = lastdate;
            imRecentModel.lastmsg = lastmsg;
            imRecentModel.lastmsguser = lastmsguser;
            imRecentModel.lastmsgusername = lastmsgusername;
            imRecentModel.isrecordmsgnorecallreceive = isrecordmsgnorecallreceive;
            imRecentModel.badge = 0;
            imRecentModel.stick = @"0";
            imRecentModel.isonedisturb = @"0";
            
            /* 处理业务会话（特殊处理） */
            if(imChatLogModel.totype == Chat_ToType_Five
               || imChatLogModel.totype == Chat_ToType_Six){
                if(imChatLogModel.totype == Chat_ToType_Five){
                    if(imRecentModel.parsetype==0){
                        imRecentModel.contactid = Chat_ContactID_Five;
                    }
                    imRecentModel.contacttype = Chat_ContactType_Main_App_Seven;
                }
                if(imChatLogModel.totype == Chat_ToType_Six){
                    if(imRecentModel.parsetype==0){
                        imRecentModel.contactid = Chat_ContactID_Six;
                    }
                    imRecentModel.contacttype = Chat_ContactType_Main_App_Eight;
                }
            }
            
            [self addImRecentWithModel:imRecentModel isAddIfExists:NO];
        }
    }
    return isGetedContactName;
}

/**
 更新最近联系人

 @param dic
 */
- (void)updatelastMessageWithDic:(NSDictionary *)dic isOnlyOneMsg:(BOOL)isOnlyOneMsg {
    NSDate *lastdate = [LZFormat String2Date:[dic lzNSStringForKey:@"senddatetime"]];
    NSString *lastmsg = isOnlyOneMsg ? @"" : [dic lzNSStringForKey:@"content"];
    NSString *lastmsguser = [dic lzNSStringForKey:@"from"];
    NSString *lastmsgusername = [dic lzNSStringForKey:@"sendusername"];
    NSNumber *showmode = [dic lzNSNumberForKey:@"sendmode"];
    NSString *msgid = [dic lzNSStringForKey:@"msgid"];
    NSString *contactid = [NSString isNullOrEmpty:[dic lzNSStringForKey:@"container"]] ? [dic lzNSStringForKey:@"to"] : [dic lzNSStringForKey:@"container"];
    [[self getDbQuene:@"im_recent" FunctionName:@"updatelastMessageWithDic:(NSDictionary *)dic isOnlyOneMsg:(BOOL)isOnlyOneMsg"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_recent set lastdate=?,lastmsg=?,lastmsguser=?,lastmsgusername=?,isdel=0,showmode=?,lastmsgid=? Where contactid=?";
        isOK = [db executeUpdate:sql,lastdate,lastmsg,lastmsguser,lastmsgusername,showmode,msgid,contactid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updatelastMessageWithDic");
        }
    }];
}

/**
 *  向某个聊天框，追加未读数量
 *
 *  @param newcount  新未读数量
 *  @param contactid 联系人id
 */
-(void)updateBadgeForAddCount:(NSInteger)newcount contactid:(NSString *)contactid{
    [[self getDbQuene:@"im_recent" FunctionName:@"updateBadgeForAddCount:(NSInteger)newcount contactid:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;

        NSString *sql = [NSString stringWithFormat:@"Update im_recent Set badge=badge+%ld Where contactid='%@'",newcount,contactid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新数量 - updateBadgeForAddCount");
        }
    }];
}

/**
 *  新的好友，组织等数据
 *
 *  @param newcount  新未读数量
 *  @param contactid 联系人id
 */
-(void)updateBadgeForNews:(NSInteger)newcount model:(ImRecentModel *)recentModel{
    ImRecentModel *imRecentModel = [self getRecentModelWithContactid:recentModel.contactid];
    [[self getDbQuene:@"im_recent" FunctionName:@"updateBadgeForNews:(NSInteger)newcount model:(ImRecentModel *)recentModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
		NSString *sql;
        if(imRecentModel == nil){
            NSString *irid = recentModel.irid;
            NSString *contactid = recentModel.contactid;
            NSString *contactname = recentModel.contactname;
            NSNumber *contacttype = [NSNumber numberWithInteger:recentModel.contacttype];
            NSNumber *relatetype = [NSNumber numberWithInteger:recentModel.relatetype];
            NSDate *lastdate = recentModel.lastdate;
            NSString *lastmsg = recentModel.lastmsg;
            NSString *lastmsguser = recentModel.lastmsguser;
            NSString *lastmsgusername = recentModel.lastmsgusername;
            NSNumber *badge = [NSNumber numberWithInteger:recentModel.badge];
            NSNumber *isdel = [NSNumber numberWithInteger:0];
            NSNumber *issettop = [NSNumber numberWithInteger:0];
            NSNumber *showmode = [NSNumber numberWithInteger:recentModel.showmode];
            NSString *lastmsgid = recentModel.lastmsgid;
            NSNumber *parsetype = [NSNumber numberWithInteger:recentModel.parsetype];
            NSString *bkid = recentModel.bkid;
            NSString *stick = recentModel.stick;
            if([NSString isNullOrEmpty:stick]){
                stick = @"0";
            }
            NSString *isonedisturb = recentModel.isonedisturb;
            if([NSString isNullOrEmpty:isonedisturb]){
                isonedisturb = @"0";
            }
            sql = @"INSERT OR REPLACE INTO im_recent(irid,contactid,contactname,contacttype,relatetype,lastdate,lastmsg,lastmsguser,lastmsgusername,badge,isdel,issettop,showmode,lastmsgid,parsetype,bkid,stick,isonedisturb)"
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,irid,contactid,contactname,contacttype,relatetype,lastdate,lastmsg,lastmsguser,lastmsgusername,badge,isdel,issettop,showmode,lastmsgid,parsetype,bkid,stick,isonedisturb];
        }
        else {
           sql = [NSString stringWithFormat:@"update im_recent Set badge=badge+%ld,lastdate=?,lastmsg=?,lastmsguser=?,lastmsgusername=?,isdel=0,showmode=?,lastmsgid=?,parsetype=?,bkid=?,stick=?,isonedisturb=? Where contactid=?",newcount];
            NSNumber *showmode = [NSNumber numberWithInteger:recentModel.showmode];
            NSNumber *parseType = [NSNumber numberWithInteger:recentModel.parsetype];
            NSString *stick = recentModel.stick;
            if([NSString isNullOrEmpty:stick]){
                stick = @"0";
            }
            NSString *isonedisturb = recentModel.isonedisturb;
            if([NSString isNullOrEmpty:isonedisturb]){
                isonedisturb = @"0";
            }
            isOK = [db executeUpdate:sql,recentModel.lastdate,recentModel.lastmsg,recentModel.lastmsguser,recentModel.lastmsgusername,showmode,recentModel.lastmsgid,parseType,recentModel.bkid,stick,isonedisturb, recentModel.contactid];
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新数量 - updateBadgeForAddCount");
        }
    }];
}

/**
 *  更新是否有新的@消息
 *
 *  @param isRemind  是否提醒我
 *  @param contactid 联系人id
 */
-(void)updateIsRemindMe:(BOOL)isRemind contactid:(NSString *)contactid{
    [[self getDbQuene:@"im_recent" FunctionName:@"updateIsRemindMe:(BOOL)isRemind contactid:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSInteger isremindme = 0;
        /* 先拿到当前聊天的@消息的个数 */
        NSString *remindSql = [NSString stringWithFormat:@"select isremindme from im_recent Where contactid='%@'", contactid];
        FMResultSet *resultSet=[db executeQuery:remindSql];
        while ([resultSet next]) {
            isremindme = [resultSet intForColumn:@"isremindme"];
        }
        if (isRemind==YES) {
            isremindme += 1;
        } else {
            if (isremindme>0) {
                isremindme -= 1;
            }
        }
        
        NSString *sql = [NSString stringWithFormat:@"Update im_recent Set isremindme=%ld Where contactid='%@'",isremindme,contactid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新@状态 - updateIsRemindMe");
        }
    }];
}

/**
 更新是否有回执消息

 @param isRecordMsg
 @param contactid 
 */
- (void)updateIsRecordMsg:(BOOL)isRecordMsg contactid:(NSString *)contactid {
    [[self getDbQuene:@"im_recent" FunctionName:@"updateIsRecordMsg:(BOOL)isRecordMsg contactid:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSInteger isrecordmsg = 0;
        /* 先拿到当前聊天的回执消息的个数 */
        NSString *recordSql = [NSString stringWithFormat:@"select isrecordmsg from im_recent Where contactid='%@'", contactid];
        FMResultSet *resultSet=[db executeQuery:recordSql];
        while ([resultSet next]) {
            isrecordmsg = [resultSet intForColumn:@"isrecordmsg"];
        }
        if (isRecordMsg==YES) {
            isrecordmsg += 1;
        } else {
            if (isrecordmsg>0) {
                isrecordmsg -= 1;
            }
        }
        
        NSString *sql = [NSString stringWithFormat:@"update im_recent set isrecordmsg=%ld where contactid='%@'", isrecordmsg, contactid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新状态 - updateIsRecordMsg");
        }
    }];
}

/**
 *  将某聊天框，未读数量更改为0
 *
 *  @param contactid 联系人id
 */
-(BOOL)updateBadgeCountTo0ByContactid:(NSString *)contactid{
    __block BOOL isSaveSuccess = YES;
    [[self getDbQuene:@"im_recent" FunctionName:@"updateBadgeCountTo0ByContactid:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_recent Set badge=0,isremindme=0,isrecordmsg=0 Where contactid='%@'",contactid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
            isSaveSuccess = NO;
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新数量为0 - updateBadgeCountTo0ByContactid");
        } 
    }];
    return isSaveSuccess;
}

/**
 *  将某聊天框，未读数量减一
 *
 *  @param contactid 联系人id
 */
-(void)updateBadgeCountMinus1ByContactid:(NSString *)contactid{
    [[self getDbQuene:@"im_recent" FunctionName:@"updateBadgeCountMinus1ByContactid:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_recent Set badge=badge-1 Where contactid='%@'",contactid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新数量为0 - updateBadgeCountMinus1ByContactid");
        }
    }];
}

/**
 *  更新是否删除标识状态
 *
 *  @param contactid 联系人id
 */
-(void)updateIsDelContactid:(NSMutableArray *)contactidArr{
    if(contactidArr.count>0){
        [[self getDbQuene:@"im_recent" FunctionName:@"updateIsDelContactid:(NSMutableArray *)contactidArr"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            BOOL isOK = NO;
            
            for(NSString *contactid in contactidArr){
                NSString *sql = [NSString stringWithFormat:@"Update im_recent Set badge=0,isdel=1,stick=0 Where contactid='%@'",contactid];
                isOK = [db executeUpdate:sql];
            }
            
            if (!isOK) {
                DDLogError(@"更新是否删除标识状态 - updateIsDel");
            }
        }];
    }
}

/**
 *  更新联系人置顶
 *
 *  @param contactid 联系人id
 */
-(void)updateSetStick:(NSString *)recentid state:(NSString *)state {
    if(![NSString isNullOrEmpty:recentid]){
        [[self getDbQuene:@"im_recent" FunctionName:@"updateSetStick:(NSString *)recentid state:(NSString *)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            BOOL isOK = NO;
            
            NSString *newState = state;
            if([NSString isNullOrEmpty:newState]){
                newState = @"0";
            }
            
            NSString *sql = [NSString stringWithFormat:@"Update im_recent Set stick='%@' Where contactid='%@'",newState, recentid];
            isOK = [db executeUpdate:sql];
            
            if (!isOK) {
                DDLogError(@"更新联系人置顶 - updateSetStick");
            }
        }];
    }
}

/**
 *  更新联系人置顶
 *
 *  @param contactid 联系人id
 */
-(void)updateSetIsOneDisturb:(NSString *)recentid state:(NSString *)state {
    if(![NSString isNullOrEmpty:recentid]){
        [[self getDbQuene:@"im_recent" FunctionName:@"updateSetIsOneDisturb:(NSString *)recentid state:(NSString *)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            BOOL isOK = NO;
            
            NSString *newState = state;
            if([NSString isNullOrEmpty:newState]){
                newState = @"0";
            }
            
            NSString *sql = [NSString stringWithFormat:@"Update im_recent Set isonedisturb='%@' Where contactid='%@'",newState, recentid];
            isOK = [db executeUpdate:sql];
            
            if (!isOK) {
                DDLogError(@"更新联系人个人免打扰 - updateSetIsOneDisturb");
            }
        }];
    }
}

/**
 *  更新当前人是否在群组中
 */
-(void)updateIsExistsGroupWithIgid:(NSString *)contactid isexistsgroup:(NSInteger)isexistsgroup{
    [[self getDbQuene:@"im_recent" FunctionName:@"updateIsExistsGroupWithIgid:(NSString *)contactid isexistsgroup:(NSInteger)isexistsgroup"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = @"";
        /* 如果该人被清除群聊，置顶就取消 */
        if (isexistsgroup==0) {
            sql = [NSString stringWithFormat:@"Update im_recent Set isexistsgroup=%ld ,stick='0' Where contactid='%@'",(long)isexistsgroup,contactid];
        } else {
            sql = [NSString stringWithFormat:@"Update im_recent Set isexistsgroup=%ld Where contactid='%@'",(long)isexistsgroup,contactid];
        }
        
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新是否删除标识状态 - updateIsDel");
        }
    }];
}

/**
 *  更新最近联系人的Title和关联类型和头像
 *
 *  @param contactid 联系人
 */
-(void)updateContactNameAndRelattypeAndFace:(NSString *)contactid{

    NSString *contactName = @"";
    NSString *face = @"";
    NSInteger relatetype = 0;
    
    ImRecentModel *imRecentModel = [self getRecentModelWithContactid:contactid];
    if(imRecentModel == nil){
        return;
    }
    
    /* 单人 */
    if(imRecentModel.contacttype==Chat_ContactType_Main_One){
        UserModel *userModel = [[UserDAL shareInstance] getUserDataWithUid:contactid];
        if(userModel!=nil){
            contactName = userModel.username;
            face = userModel.face;
        }
    }
    /* 群组 */
    else if(imRecentModel.contacttype==Chat_ContactType_Main_ChatGroup || imRecentModel.contacttype==Chat_ContactType_Main_CoGroup){
        ImGroupModel *groupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:imRecentModel.contactid];
        if(groupModel!=nil){
            contactName = groupModel.name;
            face = groupModel.face;
            relatetype = groupModel.relatetype;
        }
    }
    
    [[self getDbQuene:@"im_recent" FunctionName:@"updateContactNameAndRelattypeAndFace:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = [NSString stringWithFormat:@"Update im_recent Set contactname='%@',relatetype='%ld',face='%@' Where contactid='%@'",contactName,relatetype,face,contactid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新最近联系人的Tile和头像 - updateContactNameAndRelattypeAndFace");
        }
    }];
    
}

/**
 *  更新Synck
 *
 */
-(void)updateSynck:(NSString *)contactid syncKey:(NSString *)synck syncKeyDate:(NSDate *)date{
    [[self getDbQuene:@"im_recent" FunctionName:@"updateSynck:(NSString *)contactid syncKey:(NSString *)synck syncKeyDate:(NSDate *)date"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = [NSString stringWithFormat:@"Update im_recent Set presynck=?,presynckdate=? Where contactid=?"];
        isOK = [db executeUpdate:sql,synck,date,contactid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新Synck - updateSynck");
        }
    }];
}

/**
 *  更新Synck
 *
 */
-(void)updateSynckToNil{
    [[self getDbQuene:@"im_recent" FunctionName:@"updateSynckToNil"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = [NSString stringWithFormat:@"Update im_recent Set presynck='',presynckdate=''"];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新Synck - updateSynckToNil");
        }
    }];
}


/**
 更新群信息最后发送人姓名
 */
-(void)updateAllLastMsgUsernam{
    
    /* 获取所有可更新的信息 */
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *currentUid = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    [[self getDbQuene:@"im_recent" FunctionName:@"updateAllLastMsgUsernam"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
//        Chat_ContactType_Second_NewAssociationInvite
        NSString *sql = [NSString stringWithFormat:@"select %@ from im_recent Where isdel=0 and contacttype in ('1','2') and ifnull(showmode,0)<>1 and ifnull(lastmsguser,'')<>'' and ifnull(lastmsguser,'')<>'%@' and contactid not in ('%@') ",instanceColumns,currentUid,[LZUserDataManager getCodeStr]];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            ImRecentModel *rmModel = [self convertResultSetToModel:resultSet];
            [result addObject:rmModel];
        }
    }];
    
    /* 逐条更新数据 */
    BOOL isNeedRefresh = NO;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for(int i=0;i<result.count;i++){
        ImRecentModel *rmModel = [result objectAtIndex:i];
        
        if(![NSString isNullOrEmpty:rmModel.lastmsguser] && ![rmModel.lastmsguser isEqualToString:currentUid]){
            UserModel *userModel = [[UserDAL shareInstance] getUserModelForNameAndFace:rmModel.lastmsguser];
            if(userModel!=nil){
                if(![userModel.username isEqualToString:rmModel.lastmsgusername]){
                    [self updateLastMsgUsernam:userModel.username userid:rmModel.lastmsguser];
                    isNeedRefresh = YES;
                }
            } else {
                [appDelegate.lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_LoadUser moduleServer:Modules_Default getData:nil postData:rmModel.lastmsguser otherData:@{WebApi_DataSend_Other_Operate:@"update_imrecent_lastusername"}];
            }
        }
    }
    if(isNeedRefresh){
        appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    }
}

/**
 更新最后发送人姓名
 */
-(void)updateLastMsgUsernam:(NSString *)username userid:(NSString *)userid{
    [[self getDbQuene:@"im_recent" FunctionName:@"updateLastMsgUsernam:(NSString *)username userid:(NSString *)userid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_recent Set lastmsgusername='%@' Where lastmsguser='%@'",username,userid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新最后发送人 - updateLastMsgUsernam");
        }
    }];
}

/* 根据对话框ID将最后一条消息的lastmsguser清空 */
- (void)updateLastMsgUserToNullByContactID:(NSString *)contactid {
    [[self getDbQuene:@"im_recent" FunctionName:@"updateLastMsgUserToNullByContactID:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_recent Set lastmsgusername='' , lastmsguser='' Where contactid='%@'",contactid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@" - updateLastMsgUserToNullByContactID");
        }
    }];
}
/* 撤回之后，根据msgid更新lastMsgid */
- (void)updateLastMsgIDWithMsgid:(NSString *)msgid ContactID:(NSString *)contactid {
    [[self getDbQuene:@"im_recent" FunctionName:@"updateLastMsgIDWithMsgid:(NSString *)msgid ContactID:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_recent Set lastmsgid='%@' Where contactid='%@'",msgid,contactid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新最后发送人 - updateLastMsgIDWithMsgid");
        }
    }];
}

/* 更新消息内容为空 */
- (void)updateMsgToNull:(NSString *)contactid {
    [[self getDbQuene:@"im_recent" FunctionName:@"updateMsgToNull:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_recent Set lastmsg='' Where contactid='%@'",contactid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新消息内容为空 - updateMsgToNull");
        }
    }];
}

/* stick字段值为NULL时，更新为0 */
- (void)updateStickToZero{
    [[self getDbQuene:@"im_recent" FunctionName:@"updateStickToZero"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_recent Set stick='0' Where stick is null"];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_recent" Sql:sql Error:@"更新失败" Other:nil];
            DDLogError(@"stick字段值为NULL时，更新为0 - updateStickToZero");
        }
    }];
}

#pragma mark - 查询数据

/**
 *  获取消息列表数量
 */
-(NSInteger)getImRecentMsgCount
{
    __block NSInteger resCount = 0;
    
    [[self getDbQuene:@"im_recent" FunctionName:@"getImRecentMsgCount"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select count(0) count From im_recent"];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            resCount = [resultSet intForColumn:@"count"];
        }
        [resultSet close];
    }];
    
    return resCount;
}

/**
 *  获取可显示的Contactids
 *
 *  @return 数组
 */
-(NSMutableArray *)getContactIDsArray
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"im_recent" FunctionName:@"getContactIDsArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select %@ from im_recent Where isdel=0 and ifnull(parsetype,0)=0 Order by lastdate desc",instanceColumns];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString *contactid = [resultSet stringForColumn:@"contactid"];
            [result addObject:contactid];
        }
        [resultSet close];
    }];
    
    return result;
}
/**
 *  获取不包含该人的组群
 *  @return
 */
-(NSArray<ImRecentModel *> *)getNoExistGroups{
    NSMutableArray<ImRecentModel *> *tmpDataArray = [[NSMutableArray alloc]init];
    [[self getDbQuene:@"im_recent" FunctionName:@"getNoExistGroups"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString = [NSString stringWithFormat:@"SELECT %@ FROM im_recent WHERE isexistsgroup = 0;",instanceColumns];
        FMResultSet *resultSet=[db executeQuery:sqlString];
        while ([resultSet next]) {
            ImRecentModel *imRecentModel=[self convertResultSetToModel:resultSet];
            [tmpDataArray addObject:imRecentModel];
        }
        [resultSet close];
    }];
    
    return tmpDataArray;
}
/**
 *  获取消息列表数据
 *
 *  @return 消息列表数组
 */
-(NSMutableArray *)getImRecentList:(NSString *)selectGUID
{
    __block BOOL isContinueGetData = YES;
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    if(![selectGUID isEqualToString:appDelegate.lzGlobalVariable.messageRootSelectGUID]){
        return nil;
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
//    NSString *currentUid = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];

    [[self getDbQuene:@"im_recent" FunctionName:@"getImRecentList:(NSString *)selectGUID"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        /* 删除重复数据 */
        NSString *sql = [NSString stringWithFormat:@"delete from im_recent where rowid not in ( select max(rowid) as rowid from im_recent group by contactid)"];
        [db executeUpdate:sql];
        
        //判断是否要终止
        if(![selectGUID isEqualToString:appDelegate.lzGlobalVariable.messageRootSelectGUID]){
            isContinueGetData = NO;
        }
        
        /* 查询出免打扰的群组 */
        NSMutableArray *disturnArr = [[NSMutableArray alloc] init];
        if(isContinueGetData){
            NSString *disturbSql = @"select distinct igid from im_group Where ifnull(disturb,0)=1";
            FMResultSet *disturbResultSet=[db executeQuery:disturbSql];
            while ([disturbResultSet next]) {
                NSString *igid = [disturbResultSet stringForColumn:@"igid"];
                [disturnArr addObject:igid];
            }
            [disturbResultSet close];
        }
        
        //判断是否要终止
        if(![selectGUID isEqualToString:appDelegate.lzGlobalVariable.messageRootSelectGUID]){
            isContinueGetData = NO;
        }
        
        /* 查询出最后一条未发送成功的消息 */
        NSMutableDictionary *lastFialDic = [[NSMutableDictionary alloc] init];
        if(isContinueGetData){
            NSString *lastFailedSql = @"Select b.dialogid,b.sendstatus,b.body From ("
                                        " select dialogid,max(showindexdate) showindexdate"
                                        " from Im_ChatLog "
                                        " group by dialogid having sendstatus<>3) a inner join Im_ChatLog b on a.dialogid = b.dialogid and a.showindexdate=b.showindexdate and b.sendstatus<>3";
            FMResultSet *lastFailedResultSet=[db executeQuery:lastFailedSql];
            while ([lastFailedResultSet next]) {
                NSString *dialogid = [lastFailedResultSet stringForColumn:@"dialogid"];
                NSInteger sendstatus = [lastFailedResultSet intForColumn:@"sendstatus"];
                NSString *body = [lastFailedResultSet stringForColumn:@"body"];
                NSString *content = [[body seriaToDic] lzNSStringForKey:@"content"];
                
                NSMutableDictionary *chatlogDic = [[NSMutableDictionary alloc] init];
                [chatlogDic setObject:[NSNumber numberWithInteger:sendstatus] forKey:@"sendstatus"];
                [chatlogDic setObject:content forKey:@"content"];
                [lastFialDic setObject:chatlogDic forKey:dialogid];
            }
            [lastFailedResultSet close];
        }
        
        //判断是否要终止
        if(![selectGUID isEqualToString:appDelegate.lzGlobalVariable.messageRootSelectGUID]){
            isContinueGetData = NO;
        }
        
        NSMutableArray *groupCallArr = [[NSMutableArray alloc] init];
        /* 查询出正在通话的群组id */
        if(isContinueGetData){
            NSString *groupCallSql = [NSString stringWithFormat:@"select groupid from im_group_call"];
            FMResultSet *resultSet=[db executeQuery:groupCallSql];
            while ([resultSet next]) {
                [groupCallArr addObject:[resultSet stringForColumn:@"groupid"]];
            }
            [resultSet close];
        }
        
        //判断是否要终止
        if(![selectGUID isEqualToString:appDelegate.lzGlobalVariable.messageRootSelectGUID]){
            isContinueGetData = NO;
        }
        
//        Chat_ContactType_Second_NewAssociationInvite
        /* 查询数据 */
        if(isContinueGetData){
            sql = [NSString stringWithFormat:@"select %@ from im_recent Where isdel=0 and ifnull(parsetype,0)=0 and ifnull(showmode,0)<>1 and contactid not in ('%@') Order by ifnull(stick,0) desc ,lastdate desc",instanceColumns,[LZUserDataManager getCodeStr]];
            FMResultSet *resultSet=[db executeQuery:sql];
            while ([resultSet next] && isContinueGetData) {

                //判断是否要终止
                if(![selectGUID isEqualToString:appDelegate.lzGlobalVariable.messageRootSelectGUID]){
                    isContinueGetData = NO;
                }
                
                ImRecentModel *rmModel = [self convertResultSetToModel:resultSet];
                rmModel.isdisturb = 0;
                rmModel.sendstatus = Chat_Msg_SendSuccess;
                
                /* 判断是否为免打扰 */
                if([disturnArr containsObject:rmModel.contactid]){
                    rmModel.isdisturb = 1;
                }
                
    //            if(rmModel.contacttype == Chat_ContactType_Main_ChatGroup || rmModel.contacttype == Chat_ContactType_Main_CoGroup){
    ////                NSString *sql= [NSString stringWithFormat:@"select count(0) count from im_group_user Where igid='%@' and uid='%@' and ifnull(disturb,0)=1",rmModel.contactid,currentUid];
    //                NSString *sql= [NSString stringWithFormat:@"select count(0) count from im_group Where igid='%@' and ifnull(disturb,0)=1",rmModel.contactid];
    //                FMResultSet *groupSet=[db executeQuery:sql];
    //                if ([groupSet next]) {
    //                    NSInteger count = [groupSet intForColumn:@"count"];
    //                    if(count>0){
    //                        rmModel.isdisturb = 1;
    //                    }
    //                }
    //            }
//                if(rmModel.contacttype == Chat_ContactType_Main_ChatGroup || rmModel.contacttype == Chat_ContactType_Main_CoGroup){
//                    /* 显示正在视频通话的标识 */
//                    ImGroupCallModel *imGroupCallModel = nil;
//                    NSString *sql = [NSString stringWithFormat:@"select * from im_group_call Where groupid='%@'", rmModel.contactid];
//                    FMResultSet *resultSet=[db executeQuery:sql];
//                    while ([resultSet next]) {
//                        imGroupCallModel = [[ImGroupCallDAL shareInstance] convertResultSetToModel:resultSet];
//                    }
//                    if (imGroupCallModel.usercout) {
//                        rmModel.isvideocalling = 1;
//                    } else {
//                        rmModel.isvideocalling = 0;
//                    }
//                }
                
                if([groupCallArr containsObject:rmModel.contactid]){
                    rmModel.isvideocalling = 1;
                } else {
                    rmModel.isvideocalling = 0;
                }
                
                /* 获取最后一条消息的发送状态 */
                if([[lastFialDic allKeys] containsObject:rmModel.contactid]){
                    NSMutableDictionary *chatlogDic = [lastFialDic lzNSMutableDictionaryForKey:rmModel.contactid];
                    NSInteger sendstatus = [[chatlogDic lzNSNumberForKey:@"sendstatus"] integerValue];
                    NSString *content = [chatlogDic lzNSStringForKey:@"content"];
                    rmModel.sendstatus = sendstatus;
                    rmModel.lastmsg = content;
                    rmModel.lastmsguser = @"";
                    rmModel.lastmsgusername = @"";
                }
                
    //            /* 为群组信息，且非当前用户发送，需要获取发送人的名称 */
    //            if((rmModel.contacttype == Chat_ContactType_Main_ChatGroup || rmModel.contacttype == Chat_ContactType_Main_CoGroup)
    //               && ![NSString isNullOrEmpty:rmModel.lastmsguser]
    //               && ![rmModel.lastmsguser isEqualToString:currentUid]){
    //                UserModel *userModel = [[UserDAL shareInstance] getUserModelForNameAndFace:rmModel.lastmsguser];
    //                if(userModel!=nil){
    //                    rmModel.lastmsgusername = userModel.username;
    //                } else {
    ////                    [self.appDelegate.lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_LoadUser moduleServer:Modules_Default getData:nil postData:chatLogModel.from otherData:@{WebApi_DataSend_Other_Operate:@"reloadchatview"}];
    //                }
    //            }
                
                
    //            NSString *loastChatLogSql=[NSString stringWithFormat:@"Select %@"
    //                           " From Im_ChatLog Where dialogid='%@' order by showindexdate desc limit 0,1", @"sendstatus,body", rmModel.contactid];
    //            FMResultSet *loastChatLogResultSet=[db executeQuery:loastChatLogSql];
    //            if ([loastChatLogResultSet next]) {
    //                NSInteger sendstatus = [loastChatLogResultSet intForColumn:@"sendstatus"];
    //                rmModel.sendstatus = sendstatus;
    //                if(sendstatus!=Chat_Msg_SendSuccess){
    //                    NSString *body = [loastChatLogResultSet stringForColumn:@"body"];
    //                    rmModel.lastmsg = [[body seriaToDic] lzNSStringForKey:@"content"];
    //                }
    //            }
                
                [result addObject:rmModel];
            }
            [resultSet close];
        }
    }];
    
    if(!isContinueGetData){
        return nil;
    }
    
    return result;
}

/**
 *  获取消息列表选择数据
 *
 *  @return 消息列表数组
 */
-(NSMutableArray *)getImRecentSelectList
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"im_recent" FunctionName:@"getImRecentSelectList"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select %@ from im_recent Where isdel=0 and ifnull(showmode,0)<>1 and contacttype in(0,1,2) and ifnull(parsetype,0)=0 Order by lastdate desc",instanceColumns];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            ImRecentModel *rmModel = [self convertResultSetToModel:resultSet];
            rmModel.isdisturb = 0;
            
            /* 获取群的总人数 */
            if(rmModel.contacttype == Chat_ContactType_Main_ChatGroup || rmModel.contacttype == Chat_ContactType_Main_CoGroup){
//                NSString *sql= [NSString stringWithFormat:@"select count(0) count from im_group_user Where igid='%@' ",rmModel.contactid];
                NSString *sql= [NSString stringWithFormat:@"select usercount count from im_group Where igid='%@' ",rmModel.contactid];
                FMResultSet *groupSet=[db executeQuery:sql];
                if ([groupSet next]) {
                    NSInteger count = [groupSet intForColumn:@"count"];
                    rmModel.usercount = count;
                }
                [groupSet close];
            }
            
            [result addObject:rmModel];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  获取未读消息总数量
 *
 *  @return 数量
 */
-(NSInteger)getImRecentNoReadMsgCount{
    return [self getImRecentNoReadMsgCountWithExceptDialog:nil];
}
-(NSInteger)getImRecentNoReadMsgCountWithExceptDialog:(NSArray *)dialogArr
{
    __block NSInteger noReadCount = 0;
    
//    NSString *currentUid = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    [[self getDbQuene:@"im_recent" FunctionName:@"getImRecentNoReadMsgCount"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sql= [NSString stringWithFormat:@"select %@ from im_recent Where isdel=0 and ifnull(showmode,0)<>1 and contactid not in ('%@') and ifnull(parsetype,0)=0",instanceColumns, [LZUserDataManager getCodeStr]];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSInteger badge = [resultSet intForColumn:@"badge"];
            /* 容错，以防出现负数 */
            if (badge < 0) {
                badge = 0;
            }
            
            // 得到该聊天是否是免打扰
            NSString *isoneDisturb = [resultSet stringForColumn:@"isonedisturb"];
            if ([isoneDisturb isEqualToString:@"1"]) {
                continue;
            }
            
            ImRecentModel *rmModel = [self convertResultSetToModel:resultSet];
            /* 判断是否为免打扰 */
            BOOL isDisturb = NO;
            if(rmModel.contacttype == Chat_ContactType_Main_ChatGroup || rmModel.contacttype == Chat_ContactType_Main_CoGroup){
//                NSString *sql= [NSString stringWithFormat:@"select count(0) count from im_group_user Where igid='%@' and uid='%@' and ifnull(disturb,0)=1",rmModel.contactid,currentUid];
                NSString *sql= [NSString stringWithFormat:@"select count(0) count from im_group Where igid='%@' and ifnull(disturb,0)=1",rmModel.contactid];
                FMResultSet *groupSet=[db executeQuery:sql];
                if ([groupSet next]) {
                    NSInteger count = [groupSet intForColumn:@"count"];
                    if(count>0){
                        isDisturb = YES;
                    }
                }
                [groupSet close];
            }
            
            //排除不计入的ContactID
            if(dialogArr!=nil && [dialogArr containsObject:rmModel.contactid]){
                continue;
            }
            
//            if(!isDisturb && rmModel.contacttype!=Chat_ContactType_Main_App_Seven && rmModel.contacttype!=Chat_ContactType_Main_App_Eight){
            if(!isDisturb){
                noReadCount = noReadCount + badge;
            }
        }
        [resultSet close];
    }];
    
    return noReadCount;
}

/**
 *  根据对话框ID获取未读消息总数量
 *
 *  @return 数量
 */
-(NSInteger)getImRecentNoReadMsgCountWithDialogID:(NSString *)dialogid
{
    __block NSInteger resCount = 0;
    [[self getDbQuene:@"im_recent" FunctionName:@"getImRecentNoReadMsgCountWithDialogID:(NSString *)dialogid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= [NSString stringWithFormat:@"select ifnull(badge,0) count from im_recent Where contactid='%@'",dialogid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            resCount = [resultSet intForColumn:@"count"];
        }
        [resultSet close];
    }];
    
    return resCount;
}

/**
 *  根据Contactid模糊查询获取Contactid
 *
 *  @param contactid 联系人ID
 *
 *  @return 数组
 */
-(NSMutableArray *)getImRecentContactidWithContactid:(NSString *)contactid
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"im_recent" FunctionName:@"getImRecentContactidWithContactid:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"SELECT contactid FROM im_recent WHERE contactid like '%@.%%' and parsetype=1 order by lastdate desc", contactid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString *contactids = [resultSet stringForColumn:@"contactid"];
            NSRange rang = [contactids rangeOfString:@"."];
            contactids = [contactids substringFromIndex:rang.length+rang.location];
            [result addObject:contactids];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  根据Contactid获取ImRecentModel
 *
 *  @param contactid 联系人ID
 *
 *  @return ImRecentModel
 */
-(ImRecentModel *)getRecentModelWithContactid:(NSString *)contactid
{
    __block ImRecentModel *recentModel = nil;
    
    [[self getDbQuene:@"im_recent" FunctionName:@"getRecentModelWithContactid:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select %@ from im_recent Where contactid='%@'",instanceColumns, contactid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            recentModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return recentModel;
}

/**
 *  根据Contactid获取ImRecentModel
 *
 *  @param contactid 联系人ID
 *  @param contactid 关联群组ID
 *  @return ImRecentModel
 */
-(ImRecentModel *)getRecentModelWithLikeContactid:(NSString *)contactid targetid:(NSString *)targetid
{
    __block ImRecentModel *recentModel = nil;
    
    [[self getDbQuene:@"im_recent" FunctionName:@"getRecentModelWithLikeContactid:(NSString *)contactid targetid:(NSString *)targetid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select * from im_recent Where contactid='%@.%@'", contactid,targetid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            recentModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return recentModel;
}

/**
 *  判断是否存在此最近联系人信息
 *
 *  @param contactid 联系ID
 *
 *  @return 是否存在
 */
-(BOOL)checkIsExistsRecentWithContactid:(NSString *)contactid{
    __block NSInteger resCount = 0;
    
    [[self getDbQuene:@"im_recent" FunctionName:@"checkIsExistsRecentWithContactid:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select count(0) count From im_recent Where contactid='%@'",contactid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            resCount = [resultSet intForColumn:@"count"];
        }
        [resultSet close];
    }];
    
    return resCount>0 ? YES : NO;
}

/**
 *  判断是否显示此最近联系人信息
 *
 *  @param contactid 联系ID
 *
 *  @return 是否存在
 */
-(BOOL)checkIsShowRecentWithContactid:(NSString *)contactid{
    __block NSInteger resCount = 0;
    
    [[self getDbQuene:@"im_recent" FunctionName:@"checkIsShowRecentWithContactid:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select count(0) count From im_recent Where contactid='%@' and isdel=0 ",contactid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            resCount = [resultSet intForColumn:@"count"];
        }
        [resultSet close];
    }];
    
    return resCount>0 ? YES : NO;
}

/**
 判断最近联系人是否置顶
 
 @param contactid
 @return
 */
- (BOOL)checkRecentModelIsStick:(NSString *)contactid {
    __block BOOL isStickToTop = NO;
    [[self getDbQuene:@"im_recent" FunctionName:@"checkRecentModelIsStick:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select count(0) count from im_recent Where contactid='%@' and stick!='0'",contactid];
        FMResultSet *resultSet = [db executeQuery:sql];
        if ([resultSet next]) {
            NSInteger count = [resultSet intForColumn:@"count"];
            if (count > 0) {
                isStickToTop = YES;
            }
        }
    }];
    return isStickToTop;
}

/**
 判断最近联系人是否免打扰
 
 @param contactid
 @return
 */
- (BOOL)checkRecentModelIsNoDisturb:(NSString *)contactid {
    __block BOOL isNoDisturb = NO;
    [[self getDbQuene:@"im_recent" FunctionName:@"checkRecentModelIsNoDisturb:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select count(0) count from im_recent Where contactid='%@' and isonedisturb!='0'",contactid];
        FMResultSet *resultSet = [db executeQuery:sql];
        if ([resultSet next]) {
            NSInteger count = [resultSet intForColumn:@"count"];
            if (count > 0) {
                isNoDisturb = YES;
            }
        }
    }];
    return isNoDisturb;
}

#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImRecentModel
 */
-(ImRecentModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    NSString *irid = [resultSet stringForColumn:@"irid"];
    NSString *contactid = [resultSet stringForColumn:@"contactid"];
    NSString *contactname = [resultSet stringForColumn:@"contactname"];
    NSInteger contacttype = [resultSet intForColumn:@"contacttype"];
    NSInteger relatetype = [resultSet intForColumn:@"relatetype"];
    NSString *face = [resultSet stringForColumn:@"face"];
    NSDate   *lastdate = [resultSet dateForColumn:@"lastdate"];
    NSString *lastmsg = [resultSet stringForColumn:@"lastmsg"];
    NSString *lastmsguser = [resultSet stringForColumn:@"lastmsguser"];
    NSString *lastmsgusername = [resultSet stringForColumn:@"lastmsgusername"];
    NSInteger badge = [resultSet intForColumn:@"badge"];
    NSInteger isdel = [resultSet intForColumn:@"isdel"];
    NSDate   *autodownloaddate = [resultSet dateForColumn:@"autodownloaddate"];
    NSInteger isremindme = [resultSet intForColumn:@"isremindme"];
    NSString *presynck = [resultSet stringForColumn:@"presynck"];
    NSDate   *presynckdate = [resultSet dateForColumn:@"presynckdate"];
    NSInteger issettop = [resultSet intForColumn:@"issettop"];
    NSInteger isexistsgroup = [resultSet intForColumn:@"isexistsgroup"];
    NSInteger showmode = [resultSet intForColumn:@"showmode"];
    NSString *lastmsgid = [resultSet stringForColumn:@"lastmsgid"];
    NSInteger parsetype = [resultSet intForColumn:@"parsetype"];
    NSInteger isrecordmsg = [resultSet intForColumn:@"isrecordmsg"];
    NSInteger isrecordmsgnorecallreceive = [resultSet intForColumn:@"isrecordmsgnorecallreceive"];
    NSString *bkid = [resultSet stringForColumn:@"bkid"];
    NSString *stick = [resultSet stringForColumn:@"stick"];
    NSString *isonedisturb = [resultSet stringForColumn:@"isonedisturb"];
    
    ImRecentModel *recentModel = [[ImRecentModel alloc] init];
    recentModel.irid = irid;
    recentModel.contactid = contactid;
    recentModel.contactname = contactname;
    recentModel.contacttype = contacttype ;
    recentModel.relatetype = relatetype;
    recentModel.face = face;
    recentModel.lastdate = lastdate;
    recentModel.lastmsg = lastmsg;
    recentModel.lastmsguser = lastmsguser;
    recentModel.lastmsgusername = lastmsgusername;
    recentModel.badge = badge;
    recentModel.isdel = isdel;
    recentModel.autodownloaddate = autodownloaddate;
    recentModel.isremindme = isremindme;
    recentModel.presynck = presynck;
    recentModel.presynckdate = presynckdate;
    recentModel.isexistsgroup = isexistsgroup;
    recentModel.issettop = issettop;
    recentModel.showmode = showmode;
    recentModel.lastmsgid = lastmsgid;
    recentModel.parsetype = parsetype;
    recentModel.isrecordmsg = isrecordmsg;
    recentModel.isrecordmsgnorecallreceive = isrecordmsgnorecallreceive;
    recentModel.bkid = bkid;
    recentModel.stick = stick;
    recentModel.isonedisturb = isonedisturb;
    
    return recentModel;
}


@end
