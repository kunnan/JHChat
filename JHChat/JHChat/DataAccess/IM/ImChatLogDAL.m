//
//  ImChatLogDAL.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 聊天日志数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ImChatLogDAL.h"
#import "FMDatabaseQueue.h"
#import "ImChatLogModel.h"
#import "FMResultSet.h"
#import "NSDictionary+DicSerial.h"

#define instanceColumns @"msgid,clienttempid,dialogid,fromtype,[from],totype,[to],body,showindexdate,handlertype,ifnull(isrecall,0) as isrecall,ifnull(isrecordstatus,0) as isrecordstatus,recvisread,isdel,sendstatus,recvstatus,ifnull(heightforrow,0) as heightforrow,ifnull(textmsgsize,'') as textmsgsize"

@implementation ImChatLogDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImChatLogDAL *)shareInstance{
    static ImChatLogDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ImChatLogDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImChatLogTableIfNotExists{
    NSString *tableName = @"im_chatlog";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                                                     "[msgid] [varchar](50) PRIMARY KEY NOT NULL,"
                                                                     "[clienttempid] [varchar](50) NULL,"
                                                                     "[dialogid] [varchar](50) NULL,"
                                                                     "[fromtype] [integer] NULL,"
                                                                     "[from] [varchar](100) NULL,"
                                                                     "[totype] [integer] NULL,"
                                                                     "[to] [varchar](100) NULL,"
                                                                     "[body] [text] NULL,"
                                                                     "[showindexdate] [date] NULL,"
                                                                     "[handlertype] [varchar](50) NULL,"
                                                                     "[recvisread] [integer] NULL,"
                                                                     "[isdel] [integer] NULL,"
                                                                     "[sendstatus] [integer] NULL,"
                                                                     "[recvstatus] [integer] NULL,"
                                         "[heightforrow] [varchar](50) NULL);",
                                         tableName]];
        
    }
}

/**
 *  升级数据库
 */
-(void)updateImChatLogTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 16:
                [self AddColumnToTableIfNotExist:@"im_chatlog" columnName:@"[textmsgsize]" type:@"[varchar](100)"];
                break;
            case 56:
                [self AddColumnToTableIfNotExist:@"im_chatlog" columnName:@"[isrecall]" type:@"[integer]"];
                break;
            case 66:
                [self AddColumnToTableIfNotExist:@"im_chatlog" columnName:@"[isrecordstatus]" type:@"[integer]"];
        }
    }
}

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithChatLogArray:(NSMutableArray *)imChatlogArray{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"addDataWithChatLogArray:(NSMutableArray *)imChatlogArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< imChatlogArray.count;  i++) {
            ImChatLogModel *imChatlogModel = [imChatlogArray objectAtIndex:i];
            
            NSString *msgid = imChatlogModel.msgid;
            NSString *clienttempid = imChatlogModel.clienttempid;
            NSString *dialogid = imChatlogModel.dialogid;
            NSNumber *fromtype = [NSNumber numberWithInteger:imChatlogModel.fromtype];
            NSString *from = imChatlogModel.from;
            NSNumber *totype = [NSNumber numberWithInteger:imChatlogModel.totype];
            NSString *to = imChatlogModel.to;
            NSString *body = imChatlogModel.body;
            NSDate *showindexdate = imChatlogModel.showindexdate;
            NSString *handlertype = imChatlogModel.handlertype;
            NSNumber *recvisread = [NSNumber numberWithInteger:imChatlogModel.recvisread];
            NSNumber *sendstatus = [NSNumber numberWithInteger:imChatlogModel.sendstatus];
            NSNumber *recvstatus = [NSNumber numberWithInteger:imChatlogModel.recvstatus];
            NSNumber *isdel = [NSNumber numberWithInteger:imChatlogModel.isdel];
            NSNumber *isrecall = [NSNumber numberWithInteger:imChatlogModel.isrecall];
            NSNumber *isrecordstatus = [NSNumber numberWithInteger:imChatlogModel.isrecordstatus];
            
            NSString *sql = @"INSERT OR REPLACE INTO im_chatlog(msgid,clienttempid,dialogid,fromtype,[from],totype,[to],body,showindexdate,handlertype,recvisread,sendstatus,recvstatus,isdel,isrecall,isrecordstatus)"
                            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,msgid,clienttempid,dialogid,fromtype,from,totype,to,body,showindexdate,handlertype,recvisread,sendstatus,recvstatus,isdel,isrecall,isrecordstatus];
            if (!isOK) {
                DDLogError(@"插入失败");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"插入失败" Other:nil];

                break;
            }
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    
}

/**
 *  添加单条聊天记录
 */
-(BOOL)addChatLogModel:(ImChatLogModel *)imChatlogModel{
    __block BOOL isSaveSuccess = YES;
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"addChatLogModel:(ImChatLogModel *)imChatlogModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;

        NSString *msgid = imChatlogModel.msgid;
        NSString *clienttempid = imChatlogModel.clienttempid;
        NSString *dialogid = imChatlogModel.dialogid;
        NSNumber *fromtype = [NSNumber numberWithInteger:imChatlogModel.fromtype];
        NSString *from = imChatlogModel.from;
        NSNumber *totype = [NSNumber numberWithInteger:imChatlogModel.totype];
        NSString *to = imChatlogModel.to;
        NSString *body = imChatlogModel.body;
        NSDate *showindexdate = imChatlogModel.showindexdate;
        NSString *handlertype = imChatlogModel.handlertype;
        NSNumber *recvisread = [NSNumber numberWithInteger:imChatlogModel.recvisread];
        NSNumber *sendstatus = [NSNumber numberWithInteger:imChatlogModel.sendstatus];
        NSNumber *recvstatus = [NSNumber numberWithInteger:imChatlogModel.recvstatus];
        NSNumber *isdel = [NSNumber numberWithInteger:imChatlogModel.isdel];
        NSNumber *isrecall = [NSNumber numberWithInteger:imChatlogModel.isrecall];
        NSNumber *isrecordstatus = [NSNumber numberWithInteger:imChatlogModel.isrecordstatus];

        NSString *sql = @"INSERT OR REPLACE INTO im_chatlog(msgid,clienttempid,dialogid,fromtype,[from],totype,[to],body,showindexdate,handlertype,recvisread,sendstatus,recvstatus,isdel,isrecall,isrecordstatus)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,msgid,clienttempid,dialogid,fromtype,from,totype,to,body,showindexdate,handlertype,recvisread,sendstatus,recvstatus,isdel,isrecall,isrecordstatus];
        if (!isOK) {
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"插入失败" Other:nil];

            DDLogError(@"插入失败");
        }

        if (!isOK) {
            *rollback = YES;
            isSaveSuccess = NO;
            return;
        }
    }];
    return isSaveSuccess;
}

#pragma mark - 删除数据

/**
 *  根据Msgid删除聊天记录
 *
 *  @param msgid MsgID
 */
-(void)deleteImChatLogWithMsgid:(NSString *)msgid{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"deleteImChatLogWithMsgid:(NSString *)msgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
            NSString *sql = @"delete from im_chatlog where msgid=?";
            isOK = [db executeUpdate:sql,msgid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    
}

/**
 *  根据Msgid改变消息状态，删除聊天记录
 *
 *  @param msgid MsgID
 */
-(void)deleteMessageWithMsgid:(NSString *)msgid{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"deleteMessageWithMsgid:(NSString *)msgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"Update im_chatlog set isdel=1 where msgid=?";
        isOK = [db executeUpdate:sql,msgid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    
}

/**
 *  清空聊天记录
 *
 *  @param dialogid 对话框ID
 */
-(void)deleteImChatLogWithDialogid:(NSString *)dialogid{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"deleteImChatLogWithDialogid:(NSString *)dialogid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"Update im_chatlog set isdel=1 where dialogid=?";
        isOK = [db executeUpdate:sql,dialogid];
        
        if(isOK){
            sql = [NSString stringWithFormat:@"Update im_recent Set lastmsg='' Where contactid='%@'",dialogid];
            isOK = [db executeUpdate:sql];
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"清空聊天记录 - deleteImChatLogWithDialogid");
        }
    }];
    
}

/**
 *  清空所有聊天记录
 *
 */
-(void)deleteImChatLog{
    [[self getDbQuene:@"im_chatlog" FunctionName:@"deleteImChatLog"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
       isOK = [db executeUpdate:@"DELETE FROM im_chatlog"];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:@"DELETE FROM im_chatlog" Error:@"删除失败" Other:nil];
		}
    }];
}


#pragma mark - 修改数据

/**
 *  根据clientid更新msgid
 *
 *  @param msgId        消息ID
 *  @param clienttempid 客户端临时ID
 *  @param sendstatus   消息发送状态
 */
-(void)updateMsgId:(NSString *)msgid withClientTempid:(NSString *)clienttempid withSendstatus:(NSInteger)sendstatus{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"updateMsgId:(NSString *)msgid withClientTempid:(NSString *)clienttempid withSendstatus:(NSInteger)sendstatus"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
		NSString *sql;
        if(sendstatus!=0){
            sql = @"update im_chatlog set msgid=?,sendstatus=? Where clienttempid=?";
            isOK = [db executeUpdate:sql,msgid,[NSNumber numberWithInteger:sendstatus],clienttempid];
        } else {
            sql = @"update im_chatlog set msgid=? Where clienttempid=?";
            isOK = [db executeUpdate:sql,msgid,clienttempid];
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    
}

/**
 *  更新文件下载状态
 *
 *  @param msgid      消息ID
 *  @param recvstatus 下载状态
 */
-(void)updateRecvStatusWithMsgId:(NSString *)msgid withRecvstatus:(NSInteger)recvstatus{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"updateRecvStatusWithMsgId:(NSString *)msgid withRecvstatus:(NSInteger)recvstatus"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_chatlog set recvstatus=? Where msgid=?";
        isOK = [db executeUpdate:sql,[NSNumber numberWithInteger:recvstatus],msgid];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateRecvStatusWithMsgId");
        }
    }];
}

/**
 *  更新发送状态
 *
 *  @param clientTempId      消息ID
 *  @param recvstatus 下载状态
 */
-(void)updateSendStatusWithClientTempId:(NSString *)clientTempId withSendstatus:(NSInteger)sendstatus{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"updateSendStatusWithClientTempId:(NSString *)clientTempId withSendstatus:(NSInteger)sendstatus"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_chatlog set sendstatus=? Where clienttempid=?";
        isOK = [db executeUpdate:sql,[NSNumber numberWithInteger:sendstatus],clientTempId];
        if (!isOK) {
            DDLogError(@"更新发送状态 - updateSendStatusWithMsgId");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
}

/**
 *  更新发送状态,将发送中的更改为失败
 */
-(void)updateSendingStatusToFail{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"updateSendingStatusToFail"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_chatlog set sendstatus=2 Where sendstatus=1";
        isOK = [db executeUpdate:sql];
        if (!isOK) {
            DDLogError(@"更新发送状态 - updateSendingStatusToFail");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
}

/**
 *  更新body字段值
 *
 *  @param body  body信息
 *  @param msgid MsgID
 */
-(void)updateBody:(NSString *)body withMsgId:(NSString *)msgid{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"updateBody:(NSString *)body withMsgId:(NSString *)msgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_chatlog set body=? Where msgid=?";
        isOK = [db executeUpdate:sql,body,msgid];
        
        if (!isOK) {
            DDLogError(@"更新失败 - updateMsgId");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
}

/**
 更新isrecall字段值

 @param isReCall
 @param msgid
 */
- (void)updateIsReCall:(NSInteger)isReCall withMsgId:(NSString *)msgid {
    [[self getDbQuene:@"im_chatlog" FunctionName:@"updateIsReCall:(NSInteger)isReCall withMsgId:(NSString *)msgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_chatlog set isrecall=? Where msgid=?";
        isOK = [db executeUpdate:sql, [NSNumber numberWithInteger:isReCall], msgid];
        
        if (!isOK) {
            DDLogError(@"更新失败 - updateMsgId");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
}

/**
 *  更新Cell的高度
 */
-(void)updateHeightForRow:(NSString *)heightforrow withMsgId:(NSString *)msgid{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"updateHeightForRow:(NSString *)heightforrow withMsgId:(NSString *)msgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_chatlog set heightforrow=? Where msgid=?";
        isOK = [db executeUpdate:sql,heightforrow,msgid];
        
        if (!isOK) {
            DDLogError(@"更新失败 - updateHeightForRow");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
    
}

/**
 *  清空heightforrow和textmsgsize两个字段的内容
 */
-(void)updateHeightForRowAndtextMsgSizeToNull{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"updateHeightForRowAndtextMsgSizeToNull"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_chatlog set heightforrow='' ,textmsgsize=''";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
            DDLogError(@"更新失败 - updateHeightForRow");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
}

/**
 *  更新Text类型消息的Size
 */
-(void)updateSizeForTextMsg:(NSString *)size withMsgId:(NSString *)msgid{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"updateSizeForTextMsg:(NSString *)size withMsgId:(NSString *)msgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_chatlog set textmsgsize=? Where msgid=?";
        isOK = [db executeUpdate:sql,size,msgid];
        
        if (!isOK) {
            DDLogError(@"更新失败 - updateHeightForRow");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
    
}

/**
 *  更新接收到的消息为已读
 */
-(void)updateRecvIsRead:(NSMutableArray *)msgidArray{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"updateRecvIsRead:(NSMutableArray *)msgidArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< msgidArray.count;  i++) {
            NSString *msgid = [msgidArray objectAtIndex:i];
            
           NSString *sql = @"update im_chatlog set recvisread=1 Where msgid=?";
            isOK = [db executeUpdate:sql,msgid];
            if (!isOK) {
                DDLogError(@"更新recvisread失败");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

                break;
            }
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}

/**
 *  根据Contactid更新接收到的消息为已读
 */
-(void)updateRecvIsReadWithDialogid:(NSString *)dialogid{
    
    [[self getDbQuene:@"im_chatlog" FunctionName:@"updateRecvIsReadWithDialogid:(NSString *)dialogid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_chatlog set recvisread=1 Where dialogid=?";
        isOK = [db executeUpdate:sql,dialogid];
        
        if (!isOK) {
            DDLogError(@"更新失败 - updateRecvIsReadWithDialogid");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
}


/**
 *  更新单人聊天对话框已读消息
 */
-(void)updateReadedListForOne:(NSMutableArray *)chatLogArray{
    [[self getDbQuene:@"im_chatlog" FunctionName:@"updateReadedListForOne:(NSMutableArray *)chatLogArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< chatLogArray.count;  i++) {
            ImChatLogModel *imChatLogModel = [chatLogArray objectAtIndex:i];
            
            /* 先查询出原记录 */
            ImChatLogModel *dbModel = nil;
            NSString *sql=[NSString stringWithFormat:@"Select %@"
                           " From Im_ChatLog Where msgid='%@' ",instanceColumns,imChatLogModel.msgid];
            FMResultSet *resultSet=[db executeQuery:sql];
            if ([resultSet next]) {
                dbModel =[self convertResultSetToModel:resultSet];
            }
            
            /* 修改数据信息 */
            ImChatLogBodyModel *bodyModel = dbModel.imClmBodyModel;
            
            ImChatLogBodyReadStatusModel *readStatusModel = bodyModel.readstatusModel;
            readStatusModel.unreadcount = 0;
            readStatusModel.unreaduserlist = [[NSMutableDictionary alloc] init];
             NSMutableDictionary *readDic = [[NSMutableDictionary alloc] init];
            [readDic setObject:imChatLogModel.dialogid forKey:imChatLogModel.from];
            readStatusModel.readuserlist = readDic;
            
            bodyModel.readstatus = [[readStatusModel convertModelToDictionary] dicSerial];
            
            /* 更新bodyModel */
            sql = @"update im_chatlog set body=? Where msgid=?";
            isOK = [db executeUpdate:sql,[[bodyModel convertModelToDictionary] dicSerial],imChatLogModel.msgid];
            
            if (!isOK) {
                DDLogError(@"更新失败 - updateMsgId");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

            }
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}

/**
 *  更新多人聊天对话框已读消息
 */
-(void)updateReadedListForGroup:(NSMutableArray *)chatLogArray{
    [[self getDbQuene:@"Im_ChatLog" FunctionName:@"updateReadedListForGroup:(NSMutableArray *)chatLogArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< chatLogArray.count;  i++) {
            ImChatLogModel *imChatLogModel = [chatLogArray objectAtIndex:i];
            
            /* 先查询出原记录 */
            ImChatLogModel *dbModel = nil;
            NSString *sql=[NSString stringWithFormat:@"Select %@"
                           " From Im_ChatLog Where msgid='%@' ",instanceColumns,imChatLogModel.msgid];
            FMResultSet *resultSet=[db executeQuery:sql];
            if ([resultSet next]) {
                dbModel =[self convertResultSetToModel:resultSet];
            }
            
            /* 修改数据信息 */
            ImChatLogBodyModel *bodyModel = dbModel.imClmBodyModel;
            
            ImChatLogBodyReadStatusModel *readStatusModel = bodyModel.readstatusModel;
            readStatusModel.unreadcount = (readStatusModel.unreadcount - 1) >=0 ? (readStatusModel.unreadcount-1) : 0;
            
            if([readStatusModel.unreaduserlist allKeys].count==0 && [readStatusModel.unreaduserlist allKeys].count==0){
                DDLogVerbose(@"本地未记录具体人员id");
            }else {
                NSMutableDictionary *unreadDic = [[NSMutableDictionary alloc] initWithDictionary:readStatusModel.unreaduserlist];
                NSMutableDictionary *readDic = [[NSMutableDictionary alloc] initWithDictionary:readStatusModel.readuserlist];
                
                [unreadDic removeObjectForKey:imChatLogModel.from];
                [readDic setObject:imChatLogModel.dialogid forKey:imChatLogModel.from];
                
                readStatusModel.unreaduserlist = unreadDic;
                readStatusModel.readuserlist = readDic;
            }
            
            bodyModel.readstatus = [[readStatusModel convertModelToDictionary] dicSerial];
            
            /* 更新bodyModel */
            sql = @"update im_chatlog set body=? Where msgid=?";
            isOK = [db executeUpdate:sql,[[bodyModel convertModelToDictionary] dicSerial],imChatLogModel.msgid];
            
            if (!isOK) {
                DDLogError(@"更新失败 - updateMsgId");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

            }
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}

/**
 *  更新消息发送时间
 */
-(void)updateMsgSendDateTimeWithShowindexDate:(NSDate *)showindexDate
                                         body:(NSString *)body
                                        msgid:(NSString *)msgid
                               orClienttempid:(NSString *)clienttempid{
    
	[[self getDbQuene:@"Im_ChatLog" FunctionName:@"updateMsgSendDateTimeWithShowindexDate:(NSDate *)showindexDatebody:(NSString *)body msgid:(NSString *)msgid orClienttempid:(NSString *)clienttempid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_chatlog set showindexdate=?,body=? Where  msgid=? or clienttempid=? ";
        isOK = [db executeUpdate:sql,showindexDate,body,msgid,clienttempid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_chatlog" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateRecvIsReadWithDialogid");
        }
    }];
}

#pragma mark - 查询数据

/**
 *  获取聊天记录
 *
 *  @param dialogid 对话框ID
 *  @param start    起始条目
 *  @param count    需要获取的条目数量
 *
 *  @return 聊天记录数组
 */
-(NSMutableArray *)getChatLogWithDialogid:(NSString *)dialogid startNum:(NSInteger)start queryCount:(NSInteger)count
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"Im_ChatLog" FunctionName:@"getChatLogWithDialogid:(NSString *)dialogid startNum:(NSInteger)start queryCount:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@"
                                                 " From ("
                                                     " Select * From Im_ChatLog Where dialogid='%@'  and ifnull(isdel,0)=0 order by showindexdate desc limit %ld,%ld"
                                                     " ) tempTable"
                                                 " Order by showindexdate",instanceColumns,dialogid,start,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  获取聊天记录(反序，供新版个人提醒使用)
 *
 *  @param dialogid 对话框ID
 *  @param start    起始条目
 *  @param count    需要获取的条目数量
 *
 *  @return 聊天记录数组
 */
-(NSMutableArray *)getChatLogWithDialogidByASC:(NSString *)dialogid startNum:(NSInteger)start queryCount:(NSInteger)count
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"Im_ChatLog" FunctionName:@"getChatLogWithDialogidByASC:(NSString *)dialogid startNum:(NSInteger)start queryCount:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@"
                       " From ("
                       " Select * From Im_ChatLog Where dialogid='%@'  and ifnull(isdel,0)=0 order by showindexdate desc limit %ld,%ld"
                       " ) tempTable"
                       " Order by showindexdate desc",instanceColumns,dialogid,start,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  根据消息ID或客户端ID获取聊天记录
 *
 *  @param msgid        消息ID
 *  @param clienttempid 客户端ID
 *
 *  @return 聊天记录Model
 */
-(ImChatLogModel *)getChatLogModelWithMsgid:(NSString *)msgid orClienttempid:(NSString *)clienttempid
{
    __block ImChatLogModel *chatLogModel = nil;
    
    [[self getDbQuene:@"Im_ChatLog" FunctionName:@"getChatLogModelWithMsgid:(NSString *)msgid orClienttempid:(NSString *)clienttempid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@"
                                            " From Im_ChatLog Where msgid='%@' or clienttempid='%@' ",instanceColumns,msgid,clienttempid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            chatLogModel =[self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return chatLogModel;
}

/**
 *  根据DialogID获取最后一条聊天记录的Model
 *
 *  @param dialogid   对话框ID
 *
 *  @return 聊天记录Model
 */
-(ImChatLogModel *)getLastChatLogModelWithDialogId:(NSString *)dialogid
{
    __block ImChatLogModel *chatLogModel = nil;
    
    [[self getDbQuene:@"Im_ChatLog" FunctionName:@"getLastChatLogModelWithDialogId:(NSString *)dialogid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@"
                       " From Im_ChatLog Where dialogid='%@' and isdel=0 order by showindexdate desc limit 0,1", instanceColumns, dialogid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            chatLogModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return chatLogModel;
}

/**
 *  根据DialogID获取最后一条聊天记录的Model
 *
 *  @param dialogid   对话框ID
 *
 *  @return 聊天记录Model
 */
-(ImChatLogModel *)getFirstChatLogModelWithDialogId:(NSString *)dialogid
{
    __block ImChatLogModel *chatLogModel = nil;
    
    [[self getDbQuene:@"Im_ChatLog" FunctionName:@"getFirstChatLogModelWithDialogId:(NSString *)dialogid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@"
                       " From Im_ChatLog Where dialogid='%@' and isdel=0 order by showindexdate asc limit 0,1", instanceColumns, dialogid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            chatLogModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return chatLogModel;
}

/**
 *  根据DialogID获取第一条未读消息
 */
-(ImChatLogModel *)getFirstUnreadChatLogModelWithDialogId:(NSString *)dialogid
{
    __block ImChatLogModel *chatLogModel = nil;
    
    [[self getDbQuene:@"Im_ChatLog" FunctionName:@"getFirstUnreadChatLogModelWithDialogId:(NSString *)dialogid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@"
                       " From Im_ChatLog Where dialogid='%@' and ifnull(recvisread,0)=0 and ifnull(isdel,0)=0  order by showindexdate asc limit 0,1", instanceColumns, dialogid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            chatLogModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return chatLogModel;
}

/**
 *  获取某条消息后面的消息数量
 */
-(NSInteger)getMsgCountWithChatLogModel:(ImChatLogModel *)chatlogModel{

    __block NSInteger count = 0;
    
    if(chatlogModel!=nil){
        [[self getDbQuene:@"Im_ChatLog" FunctionName:@"getMsgCountWithChatLogModel:(ImChatLogModel *)chatlogModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql=[NSString stringWithFormat:@"Select count(0) as count From Im_ChatLog Where dialogid='%@' and ifnull(isdel,0)=0 and showindexdate>? ", chatlogModel.dialogid];

            NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:chatlogModel.showindexdate, nil];
            FMResultSet *checkExistsResultSet=[db executeQuery:sql withArgumentsInArray:array];
            if ([checkExistsResultSet next]) {
                count = [checkExistsResultSet intForColumn:@"count"];
                count ++;
            }
            [checkExistsResultSet close];
        }];
    }

    return count;
}

/**
 *  根据文件类型获取聊天记录
 *
 *  @param dialogid 对话框ID
 *  @param handlertype 消息类型
 *
 *  @return 聊天记录数组
 */
-(NSMutableArray *)getChatLogWithDialogid:(NSString *)dialogid handlerType:(NSString *)handlertype
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"Im_ChatLog" FunctionName:@"getChatLogWithDialogid:(NSString *)dialogid handlerType:(NSString *)handlertype"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@"
                       " From ("
                       " Select * From Im_ChatLog Where dialogid='%@' and handlertype in (%@) and ifnull(isdel,0)=0 and ifnull(isrecall,0)=0 order by showindexdate desc"
                       " ) tempTable"
                       " Order by showindexdate",instanceColumns,dialogid,handlertype];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  获取对话框中某段时间之后的消息
 */
-(NSMutableArray *)getChatLogsWithDialogid:(NSString *)dialogid datetime:(NSDate *)datetime
{
    NSString *strDateTime = [LZFormat Date2String:datetime format:nil];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"Im_ChatLog" FunctionName:@"getChatLogsWithDialogid:(NSString *)dialogid datetime:(NSDate *)datetime"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@ From im_chatlog where dialogid='%@' and ifnull(isdel,0)=0 and datetime(showindexdate, 'unixepoch','localtime')>'%@' "
                       " Order by showindexdate",instanceColumns,dialogid,strDateTime];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  获取所有未读消息数组
 *
 *  @param dialogid 聊天框ID
 *
 *  @return 消息数组
 */
-(NSMutableArray *)getRecvIsNoReadWithDialogId:(NSString *)dialogid
{
    NSMutableArray *msgids = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"Im_ChatLog" FunctionName:@"getRecvIsNoReadWithDialogId:(NSString *)dialogid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select msgid From Im_ChatLog Where dialogid='%@' and ifnull(recvisread,0)=0 and ifnull(isdel,0)=0 ", dialogid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString *msgid = [resultSet stringForColumn:@"msgid"];
            [msgids addObject:msgid];
        }
        [resultSet close];
    }];
    
    return msgids;
}


/**
 *  判断此类型的消息是否已读(避免重复添加好友等处理时，出现多条提醒的情况)
 *
 *  @param handlertype handlertype
 *  @param bkid        业务id
 *
 *  @return 是否存在
 */
-(BOOL)checkIsExistsSameUnreadMsg:(NSString *)handlertype bkid:(NSString *)bkid{
    
    /* 找出此类型的所有未读消息 */
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"Im_ChatLog" FunctionName:@"checkIsExistsSameUnreadMsg:(NSString *)handlertype bkid:(NSString *)bkid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@ From Im_ChatLog Where handlertype='%@' and ifnull(recvisread,0)=0 and ifnull(isdel,0)=0 ", instanceColumns, handlertype];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    /* 判断是否存在相同的业务数据 */
    BOOL isExists = NO;
    for (ImChatLogModel *imChatLogModel in result) {
        NSString *bkidMsg = imChatLogModel.imClmBodyModel.bkid;
        if([bkid isEqualToString:bkidMsg]){
            isExists = YES;
            break;
        }
    }
    
    return isExists;
}

/**
 *  判断这个时间之前是否还有消息
 */
-(BOOL)checkIsEarlierMsgWithDialogID:(NSString *)dialogid datetime:(NSDate *)datetime msgid:(NSString *)msgid
{
    __block NSInteger count = 0;
    NSString *strDateTime = [LZFormat Date2String:datetime format:nil];
    [[self getDbQuene:@"Im_ChatLog" FunctionName:@"checkIsEarlierMsgWithDialogID:(NSString *)dialogid datetime:(NSDate *)datetime msgid:(NSString *)msgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select count(0) as count From im_chatlog where dialogid='%@' and ifnull(isdel,0)=0 and msgid<>'%@' and datetime(showindexdate, 'unixepoch','localtime')<'%@' "
                       " Order by showindexdate",dialogid,msgid,strDateTime];
        
        FMResultSet *checkExistsResultSet=[db executeQuery:sql];
        if ([checkExistsResultSet next]) {
            count = [checkExistsResultSet intForColumn:@"count"];
        }
        [checkExistsResultSet close];
    }];
    
    return count>0;
}

#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImChatLogModel
 */
-(ImChatLogModel *)convertResultSetToModel:(FMResultSet *)resultSet{
 
    NSString *msgid = [resultSet stringForColumn:@"msgid"];
    NSString *clienttempid = [resultSet stringForColumn:@"clienttempid"];
    NSString *dialogid = [resultSet stringForColumn:@"dialogid"];
    NSInteger fromtype = [resultSet intForColumn:@"fromtype"];
    NSString *from = [resultSet stringForColumn:@"from"];
    NSInteger totype = [resultSet intForColumn:@"totype"];
    NSString *to = [resultSet stringForColumn:@"to"];
    NSString *body = [resultSet stringForColumn:@"body"];
    NSDate *showindexdate = [resultSet dateForColumn:@"showindexdate"];
    NSString *handlertype = [resultSet stringForColumn:@"handlertype"];
    NSInteger recvisread = [resultSet intForColumn:@"recvisread"];
    NSInteger sendstatus = [resultSet intForColumn:@"sendstatus"];
    NSInteger recvstatus = [resultSet intForColumn:@"recvstatus"];
    NSString *heightforrow = [resultSet stringForColumn:@"heightforrow"];
    NSString *textmsgsize = [resultSet stringForColumn:@"textmsgsize"];
    NSInteger isrecall = [resultSet intForColumn:@"isrecall"];
    NSInteger isdel = [resultSet intForColumn:@"isdel"];
    NSInteger isrecordstatus = [resultSet intForColumn:@"isrecordstatus"];
    
    ImChatLogModel *chatLogModel = [[ImChatLogModel alloc] init];
    chatLogModel.msgid = msgid;
    chatLogModel.clienttempid = clienttempid;
    chatLogModel.dialogid = dialogid;
    chatLogModel.fromtype = fromtype;
    chatLogModel.from = from;
    chatLogModel.totype = totype;
    chatLogModel.to  = to;
    chatLogModel.body = body;
    chatLogModel.showindexdate = showindexdate;
    chatLogModel.handlertype = handlertype;
    chatLogModel.recvisread = recvisread;
    chatLogModel.sendstatus = sendstatus;
    chatLogModel.recvstatus = recvstatus;
    chatLogModel.heightforrow = heightforrow;
    chatLogModel.textmsgsize = textmsgsize;
    chatLogModel.isrecall = isrecall;
    chatLogModel.isdel = isdel;
    chatLogModel.isrecordstatus = isrecordstatus;
    
    return chatLogModel;
}

@end
