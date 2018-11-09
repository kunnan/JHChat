//
//  SysApiVersionDAL.m
//  LeadingCloud
//
//  Created by wchMac on 2017/9/25.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2017-09-25
 Version: 1.0
 Description: 服务器WebApi数据版本
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "SysApiVersionDAL.h"
#import "AppDateUtil.h"

@implementation SysApiVersionDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(SysApiVersionDAL *)shareInstance{
    static SysApiVersionDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[SysApiVersionDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createSysApiVersionTableIfNotExists
{
    NSString *tableName = @"sys_api_version";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[code] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[type] [integer] NULL,"
                                         "[client_version] [varchar](200) NULL,"
                                         "[server_version] [varchar](200) NULL);",
                                         tableName]];
    }
}

/**
 *  升级数据库
 */
-(void)updateSysApiVersionTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 72:{
                [self AddColumnToTableIfNotExist:@"sys_api_version" columnName:@"[updatetime]" type:@"[date]"];
                break;
            }
        }
    }
}

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithSysApiVersionArray:(NSMutableArray *)versionArray{
    
    [[self getDbQuene:@"sys_api_version" FunctionName:@"addDataWithSysApiVersionArray:(NSMutableArray *)versionArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql;
        for (int i = 0; i< versionArray.count;  i++) {
            SysApiVersionModel *sysApiVersionModel = [versionArray objectAtIndex:i];
            
            NSString *code = sysApiVersionModel.code;
            NSNumber *type = [NSNumber numberWithInteger:sysApiVersionModel.type];
            NSString *serverVersion = sysApiVersionModel.server_version;
            NSString *clientVersion = @"";
            NSDate *updatetime = [[NSDate alloc] initWithTimeIntervalSince1970:1];
            
           sql=[NSString stringWithFormat:@"Select client_version,updatetime From sys_api_version Where code='%@'", code];
            FMResultSet *checkExistsResultSet=[db executeQuery:sql];
            if ([checkExistsResultSet next]) {
                clientVersion = [checkExistsResultSet stringForColumn:@"client_version"];
                updatetime = [checkExistsResultSet dateForColumn:@"updatetime"];
            }
            
            sql = @"INSERT OR REPLACE INTO sys_api_version(code,type,client_version,server_version,updatetime)"
            "VALUES (?,?,?,?,?)";
            isOK = [db executeUpdate:sql,code,type,clientVersion,serverVersion,updatetime];
            if (!isOK) {
                DDLogError(@"插入失败");
                break;
            }
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"sys_api_version" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}

#pragma mark - 删除数据

#pragma mark - 修改数据

/**
 *  更新是否删除标识状态
 *
 *  @param contactid 联系人id
 */
-(void)updateServerVersionToClientVersionWithCode:(NSString *)code{

    [[self getDbQuene:@"sys_api_version" FunctionName:@"updateServerVersionToClientVersionWithCode:(NSString *)code"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = [NSString stringWithFormat:@"Update sys_api_version Set client_version=server_version,server_version='', updatetime=? Where code='%@' and ifnull(server_version,'')<>''",code];
        isOK = [db executeUpdate:sql,[AppDateUtil GetCurrentDate]];

        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"sys_api_version" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新是否删除标识状态 - updateIsDel");
        }
    }];
}

#pragma mark - 查询数据

/**
 *  获取对象信息
 *
 *  @param key 主键值
 *
 *  @return Model
 */
-(SysApiVersionModel *)getSysApiVersionModelWithCode:(NSString *)code
{
    __block SysApiVersionModel *versionModel = nil;
    
    [[self getDbQuene:@"sys_api_version" FunctionName:@"getSysApiVersionModelWithCode:(NSString *)code"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select code,type,client_version,server_version,updatetime from sys_api_version Where code='%@'", code];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            versionModel = [[SysApiVersionModel alloc] init];
            
            NSString *code = [resultSet stringForColumn:@"code"];
            NSInteger type= [resultSet intForColumn:@"type"];
            NSString *client_version = [resultSet stringForColumn:@"client_version"];
            NSString *server_version = [resultSet stringForColumn:@"server_version"];
            NSDate *updatetime = [resultSet dateForColumn:@"updatetime"];
            
            versionModel.code = code;
            versionModel.type = type;
            versionModel.client_version = client_version;
            versionModel.server_version = server_version;
            versionModel.updatetime = updatetime;
        }
        [resultSet close];
    }];
    
    return versionModel;
}

/**
 *  获取所有数据
 */
-(NSMutableArray *)getAllSysApiVersion
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"sys_api_version" FunctionName:@"getAllSysApiVersion"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select code,type,client_version,server_version,updatetime from sys_api_version where ifnull(client_version,'')<>'' and ifnull(server_version,'')<>'' and client_version=server_version"];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            SysApiVersionModel *versionModel = [[SysApiVersionModel alloc] init];
            
            NSString *code = [resultSet stringForColumn:@"code"];
            NSInteger type= [resultSet intForColumn:@"type"];
            NSString *client_version = [resultSet stringForColumn:@"client_version"];
            NSString *server_version = [resultSet stringForColumn:@"server_version"];
            NSDate *updatetime = [resultSet dateForColumn:@"updatetime"];
            
            versionModel.code = code;
            versionModel.type = type;
            versionModel.client_version = client_version;
            versionModel.server_version = server_version;
            versionModel.updatetime = updatetime;
            
            [result addObject:versionModel];
        }
        [resultSet close];
        
        sql = [NSString stringWithFormat:@"update sys_api_version set server_version='' where ifnull(client_version,'')<>'' and ifnull(server_version,'')<>'' and client_version=server_version"];
        BOOL isOK = [db executeUpdate:sql];
        if (!isOK) {
            DDLogError(@"更新是否删除标识状态 - updateIsDel");
        }
    }];
    
    return result;
}


@end
