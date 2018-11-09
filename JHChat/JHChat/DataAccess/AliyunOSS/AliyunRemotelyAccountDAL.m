//
//  AliyunRemotelyAccountDAL.m
//  LeadingCloud
//
//  Created by SY on 2017/6/29.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "AliyunRemotelyAccountDAL.h"
#import "RemotelyAccountModel.h"
#import "AppDelegate.h"
#import "LZBaseAppDelegate.h"
#import "AliyunOSS.h"
@implementation AliyunRemotelyAccountDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AliyunRemotelyAccountDAL *)shareInstance{
    static AliyunRemotelyAccountDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[AliyunRemotelyAccountDAL alloc] init];
    }
    return instance;
}
#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createAliaccountTableIfNotExists
{
    NSString *tableName = @"aliyun_account";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[accesskey] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[accesskeysecret] [varchar](50) NULL,"
                                         "[securitytoken] [varchar](500) NULL,"
                                         "[expiration] [date] NULL,"
                                         "[fileids] [varchar](200) NULL);",
                                         tableName]];
        
    }
}
-(void)addAliAccountModel:(RemotelyAccountModel*)accountModel {
    [[self getDbQuene:@"aliyun_account" FunctionName:@"addAliAccountModel:(RemotelyAccountModel*)accountModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *accesskey = accountModel.accesskey;
        NSString *accesskeysecret = accountModel.accesskeysecret;
        NSString *securitytoken = accountModel.securitytoken;
        NSDate *expiration = accountModel.expiration;
        NSString *fileids = [AppUtils arrayTransformString:(NSMutableArray*)accountModel.fileids];
        
        NSString *sql = @"INSERT OR REPLACE INTO aliyun_account(accesskey,accesskeysecret,securitytoken,expiration,fileids)"
        "VALUES (?,?,?,?,?)";
        isOK = [db executeUpdate:sql,accesskey,accesskeysecret,securitytoken,expiration,fileids];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"aliyun_account" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    appDelegate.lzGlobalVariable.aliyunAccountModel = nil;
    
    [AliyunOSS setInstanceToNil];
}
-(void)deleteAccount{
    
    [[self getDbQuene:@"aliyun_account" FunctionName:@"deleteAccount"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from aliyun_account";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"aliyun_account" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    appDelegate.lzGlobalVariable.aliyunAccountModel = nil;
    
    //[AliyunOSS setInstanceToNil];
}
#pragma mark - 查询数据

/**
 查询相应服务器model
 
 @param rfstype oss：阿里云  lzy:理正云
 @return
 */
-(RemotelyAccountModel*)getAccountModel {
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    __block RemotelyAccountModel *serverModel = appDelegate.lzGlobalVariable.aliyunAccountModel;

    if(!serverModel){
        [[self getDbQuene:@"aliyun_account" FunctionName:@"getAccountModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql=[NSString stringWithFormat:@"Select accesskey,accesskeysecret,securitytoken,expiration,fileids from aliyun_account"];
            FMResultSet *resultSet=[db executeQuery:sql];
            if ([resultSet next]) {
                
                serverModel = [self convertResultSetToModel:resultSet];
                
            }
            [resultSet close];
            appDelegate.lzGlobalVariable.aliyunAccountModel = serverModel;
        }];
    }
    return serverModel;
}
-(RemotelyAccountModel *)convertResultSetToModel:(FMResultSet *)resultSet
{
    NSString *accesskey = [resultSet stringForColumn:@"accesskey"];
    NSString *accesskeysecret = [resultSet stringForColumn:@"accesskeysecret"];
    NSString *securitytoken = [resultSet stringForColumn:@"securitytoken"];
    NSDate *expiration = [resultSet dateForColumn:@"expiration"];
    NSString *fileids = [resultSet stringForColumn:@"fileids"];
   
    RemotelyAccountModel *resModel = [[RemotelyAccountModel alloc] init];
    resModel.accesskey = accesskey;
    resModel.accesskeysecret = accesskeysecret;
    resModel.securitytoken = securitytoken;
    resModel.expiration = expiration;
    resModel.fileids = [AppUtils StringTransformArray:fileids];
    
    return resModel;
    
}

@end
