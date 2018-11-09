//
//  AppBaseServerDAL.m
//  LeadingCloud
//
//  Created by dfl on 16/11/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-11-16
 Version: 1.0
 Description: 基础服务器配置数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "AppBaseServerDAL.h"

@implementation AppBaseServerDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AppBaseServerDAL *)shareInstance {
    static AppBaseServerDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[AppBaseServerDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作
-(void)creatAppBaseServerTableIfNotExists {
    
    NSString *tableName = @"app_base_server";
    
    /* 判断是否创建了此表 */
    if (![super checkIsExistsTable:tableName]) {
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:@"Create Table If Not Exists %@("
                                         "[serverid] [varchar](150) PRIMARY KEY NOT NULL,"
                                         "[appid] [varchar](100) NULL,"
                                         "[httpwebapihost] [text] NULL,"
                                         "[httpwebapiport] [text] NULL,"
                                         "[httphtmlhost] [text] NULL,"
                                         "[httphtmlport] [text] NULL,"
                                         "[httpswebapihost] [text] NULL,"
                                         "[httpswebapiport] [text] NULL,"
                                         "[httpshtmlhost] [text] NULL,"
                                         "[httpshtmlport] [text] NULL,"
                                         "[sso] [text] NULL,"
                                         "[servergroup] [text] NULL);",
                                         tableName]];
    }
}

/**
 *  升级数据库
 */
-(void)updataAppBaseServerTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    
    for (int i = currentDbVersion; i<=systemDbVersion; i++) {
        switch (i) {
            
        }
    }
}

#pragma mark - 添加数据

/**
 批量添加服务器配置
 
 @param array array
 */
-(void)addAppBaseServerWithArray:(NSMutableArray*)array {
    [[self getDbQuene:@"app_base_server" FunctionName:@"addAppBaseServerWithArray:(NSMutableArray*)array"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO app_base_server(serverid,appid,httpwebapihost,httpwebapiport,httphtmlhost,httphtmlport,httpswebapihost,httpswebapiport,httpshtmlhost,httpshtmlport,sso,servergroup)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (AppBaseServerModel *appBaseSerModel in array) {
            NSString *serverid = appBaseSerModel.serverid;
            NSString *appid = appBaseSerModel.appid;
            NSString *httpwebapihost = appBaseSerModel.httpwebapihost;
            NSString *httpwebapiport = appBaseSerModel.httpwebapiport;
            NSString *httphtmlhost = appBaseSerModel.httphtmlhost;
            NSString *httphtmlport = appBaseSerModel.httphtmlport;
            NSString *httpswebapihost = appBaseSerModel.httpswebapihost;
            NSString *httpswebapiport = appBaseSerModel.httpswebapiport;
            NSString *httpshtmlhost = appBaseSerModel.httpshtmlhost;
            NSString *httpshtmlport = appBaseSerModel.httpshtmlport;
            NSString *sso = appBaseSerModel.sso;
            NSString *servergroup = appBaseSerModel.servergroup;
			
            isOK = [db executeUpdate:sql,serverid,appid,httpwebapihost,httpwebapiport,httphtmlhost,httphtmlport,httpswebapihost,httpswebapiport,httpshtmlhost,httpshtmlport,sso,servergroup];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"app_base_server" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return ;
        }
    }];
}

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData{
    [[self getDbQuene:@"app_base_server"FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;

       isOK = [db executeUpdate:@"DELETE FROM app_base_server"];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"app_base_server" Sql:@"DELETE FROM app_base_server" Error:@"删除失败" Other:nil];
			
			DDLogError(@"删除失败 - updateMsgId");
		}
    }];
}

#pragma mark - 修改数据


#pragma mark - 查询数据


/**
 根据servergroup获取对应的Model
 */
-(AppBaseServerModel *)getAppBaseServerModelWithServerGroup:(NSString *)servergroup{
    __block AppBaseServerModel *appBaseModel=nil;
    [[self getDbQuene:@"app_base_server" FunctionName:@"getAppBaseServerModelWithServerGroup:(NSString *)servergroup"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From app_base_server where lower(servergroup)=lower('%@') ",servergroup];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            appBaseModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return appBaseModel;
}

/**
 获取所有的AppBaseServerModel
 */
-(NSMutableArray *)getAllAppBaseServerModel{
    __block AppBaseServerModel *appBaseModel=nil;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"app_base_server" FunctionName:@"getAllAppBaseServerModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From app_base_server"];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            appBaseModel = [self convertResultSetToModel:resultSet];
            [result addObject:appBaseModel];
        }
        [resultSet close];
    }];
    
    return result;
}


#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return AppBaseServerModel
 */
-(AppBaseServerModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    

    AppBaseServerModel *appBaseSerModel = [[AppBaseServerModel alloc]init];
    appBaseSerModel.serverid = [resultSet stringForColumn:@"serverid"];
    appBaseSerModel.appid = [resultSet stringForColumn:@"appid"];
    appBaseSerModel.httpwebapihost = [resultSet stringForColumn:@"httpwebapihost"];
    appBaseSerModel.httpwebapiport = [resultSet stringForColumn:@"httpwebapiport"];
    appBaseSerModel.httphtmlhost = [resultSet stringForColumn:@"httphtmlhost"];
    appBaseSerModel.httphtmlport = [resultSet stringForColumn:@"httphtmlport"];
    appBaseSerModel.httpswebapihost = [resultSet stringForColumn:@"httpswebapihost"];
    appBaseSerModel.httpswebapiport = [resultSet stringForColumn:@"httpswebapiport"];
    appBaseSerModel.httpshtmlhost = [resultSet stringForColumn:@"httpshtmlhost"];
    appBaseSerModel.httpshtmlport = [resultSet stringForColumn:@"httpshtmlport"];
    appBaseSerModel.sso = [resultSet stringForColumn:@"sso"];
    appBaseSerModel.servergroup = [resultSet stringForColumn:@"servergroup"];
    
    return appBaseSerModel;
}
@end
