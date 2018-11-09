//
//  ImMsgQueueDAL.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-11
 Version: 1.0
 Description: 消息队列数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ImMsgQueueDAL.h"
#import "ImMsgQueueModel.h"
#import "FMDatabaseQueue.h"
#import "AppDateUtil.h"

@implementation ImMsgQueueDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImMsgQueueDAL *)shareInstance{
    static ImMsgQueueDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ImMsgQueueDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImMsgQueueTableIfNotExists{
    NSString *tableName = @"im_msgqueue";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[mqid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[module] [varchar](50) NULL,"
                                         "[route] [varchar](200) NULL,"
                                         "[data] [text] NULL,"
                                         "[createdatetime] [date] NULL,"
                                         "[updatedatetime] [date] NULL,"
                                         "[status] [integer] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateImMsgQueueTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据

/**
 *  添加单条聊天记录
 */
-(void)addImMsgQueueModelModel:(ImMsgQueueModel *)imMsgQueueModel{
    
	[[self getDbQuene:@"im_msgqueue" FunctionName:@"addImMsgQueueModelModel:(ImMsgQueueModel *)imMsgQueueModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *mqid = imMsgQueueModel.mqid;
        NSString *module = imMsgQueueModel.module;
        NSString *route = imMsgQueueModel.route;
        NSString *data = imMsgQueueModel.data;
        NSDate *createdatetime = imMsgQueueModel.createdatetime;
        NSDate *updatedatetime = imMsgQueueModel.updatedatetime;
        NSNumber *status = [NSNumber numberWithInteger:imMsgQueueModel.status];
        
        NSString *sql = @"INSERT OR REPLACE INTO im_msgqueue(mqid,module,route,data,createdatetime,updatedatetime,status)"
                        "VALUES (?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,mqid,module,route,data,createdatetime,updatedatetime,status];
        if (!isOK) {
            DDLogError(@"插入失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_msgqueue" Sql:sql Error:@"插入失败" Other:nil];

        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    
}

#pragma mark - 删除数据

/**
 *  根据队列ID删除队列中的数据
 *
 *  @param msgid mqid
 */
-(void)deleteImMsgQueueWithMqid:(NSString *)mqid{
    
    [[self getDbQuene:@"im_msgqueue" FunctionName:@"deleteImMsgQueueWithMqid:(NSString *)mqid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_msgqueue where mqid=?";
        isOK = [db executeUpdate:sql,mqid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_msgqueue" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - deleteImMsgQueueWithMqid");
        }
    }];
    
}

/**
 *  根据类型删除队列中的数据
 *
 *  @param module module
 */
-(void)deleteImMsgQueueWithModule:(NSString *)module{
    
    [[self getDbQuene:@"im_msgqueue" FunctionName:@"deleteImMsgQueueWithModule:(NSString *)module"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_msgqueue where module=?";
        isOK = [db executeUpdate:sql,module];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_msgqueue" Sql:sql Error:@"删除失败" Other:nil];
            DDLogError(@"删除失败 - deleteImMsgQueueWithModule");
        }
    }];
    
}

/**
 *  根据类型删除队列中的数据
 *
 *  @param module module
 */
-(void)deleteImMsgQueueWithData:(NSString *)data{
    
    [[self getDbQuene:@"im_msgqueue" FunctionName:@"deleteImMsgQueueWithData:(NSString *)data"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_msgqueue where data=?";
        isOK = [db executeUpdate:sql,data];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_msgqueue" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - deleteImMsgQueueWithData");
        }
    }];
    
}

/**
 *  根据类型删除队列中的数据(被删除的消息)
 *
 *  @param module module
 */
-(void)deleteImMsgQueueDeletedMsgWithData:(NSString *)data {
    
    [[self getDbQuene:@"im_msgqueue" FunctionName:@"deleteImMsgQueueDeletedMsgWithData:(NSString *)data"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_msgqueue where data=? and route=?";
        isOK = [db executeUpdate:sql,data, WebApi_Message_DeleteMsg];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_msgqueue" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - deleteImMsgQueueWithData");
        }
    }];
    
}

#pragma mark - 修改数据

/**
 *  更改消息队列中的数据状态
 *
 *  @param mqid   队列ID
 *  @param status 发送状态
 */
-(void)updateStatusWithMqid:(NSString *)mqid status:(NSInteger)status{
    
    [[self getDbQuene:@"im_msgqueue" FunctionName:@"updateStatusWithMqid:(NSString *)mqid status:(NSInteger)status"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = @"update im_msgqueue set status=?,updatedatetime=? Where mqid=?";
        isOK = [db executeUpdate:sql,[NSNumber numberWithInteger:status],[AppDateUtil GetCurrentDate],mqid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_msgqueue" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateStatusWithMqid");
        }
    }];
    
}

/**
 *  更新所有消息的发送状态
 */
-(void)updateAllMsgStatus:(NSInteger)status{
    
    [[self getDbQuene:@"im_msgqueue" FunctionName:@"updateAllMsgStatus:(NSInteger)status"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = @"update im_msgqueue set status=?";
        isOK = [db executeUpdate:sql,[NSNumber numberWithInteger:status]];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_msgqueue" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateStatusWithMqid");
        }
    }];
    
}

#pragma mark - 查询数据

/**
 *  获取发送真正失败的消息
 *
 *  @param module 功能模块
 *
 *  @return 失败的消息
 */
-(NSMutableArray *)getMessageWithModule:(NSString *)module
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"im_msgqueue" FunctionName:@"getMessageWithModule:(NSString *)module"] inTransaction:^(FMDatabase *db, BOOL *rollback) {

        /* 获取所有失败的数据 */
        NSString *sql=[NSString stringWithFormat:@"Select mqid,module,route,data,createdatetime,updatedatetime,status From im_msgqueue "
                       " Where module='%@'"
                       " Order by createdatetime",module];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString *mqid = [resultSet stringForColumn:@"mqid"];
            NSString *module = [resultSet stringForColumn:@"module"];
            NSString *route = [resultSet stringForColumn:@"route"];
            NSString *data = [resultSet stringForColumn:@"data"];
            NSDate *createdatetime = [resultSet dateForColumn:@"createdatetime"];
            NSDate *updatedatetime = [resultSet dateForColumn:@"updatedatetime"];
            NSInteger status = [resultSet intForColumn:@"status"];
            
            ImMsgQueueModel *imMsgQueueModel = [[ImMsgQueueModel alloc] init];
            imMsgQueueModel.mqid = mqid;
            imMsgQueueModel.module = module;
            imMsgQueueModel.route = route;
            imMsgQueueModel.data = data;
            imMsgQueueModel.createdatetime = createdatetime;
            imMsgQueueModel.updatedatetime = updatedatetime;
            imMsgQueueModel.status = status;
            
            [result addObject:imMsgQueueModel];
        }
        [resultSet close];
        
//        /* 将状态更改为发送中，取出之后将更新时间改为当前时间 */
//        sql = @"update im_msgqueue set updatedatetime=? Where module=? ";
//        BOOL isOK = [db executeUpdate:sql,[AppDateUtil GetCurrentDate],module];
//        if (!isOK) {
//            DDLogError(@"更新失败 - updateStatusWithMqid");
//        }
        
    }];
    
    return result;
}

@end
