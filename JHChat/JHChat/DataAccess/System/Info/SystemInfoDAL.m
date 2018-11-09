//
//  SystemInfoDAL.m
//  LeadingCloud
//
//  Created by wchMac on 16/4/29.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-04-29
 Version: 1.0
 Description: 记录软件信息
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "SystemInfoDAL.h"

@implementation SystemInfoDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(SystemInfoDAL *)shareInstance{
    static SystemInfoDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[SystemInfoDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createSystemInfoTableIfNotExists
{
    NSString *tableName = @"systeminfo";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[si_key] [text] PRIMARY KEY NOT NULL,"
                                         "[si_value] [text] NULL);",
                                         tableName]];
    }
}
/**
 *  升级数据库
 */
-(void)updateSystemInfoTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据

/**
 *  根据model添加数据
 */
-(void)addDataWithSystemInfoModel:(SystemInfoModel *)systemInfoModel{
    
    [[self getDbQuene:@"systeminfo"FunctionName:@"addDataWithSystemInfoModel:(SystemInfoModel *)systemInfoModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *si_key = systemInfoModel.si_key;
        NSString *si_value = systemInfoModel.si_value;
        
        NSString *sql = @"INSERT OR REPLACE INTO systeminfo(si_key,si_value)"
                            "VALUES (?,?)";
        isOK = [db executeUpdate:sql,si_key,si_value];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"systeminfo" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}

#pragma mark - 删除数据

#pragma mark - 修改数据

/**
 *  更新value信息
 *
 *  @param systemInfoModel 信息Model
 */
-(void)updateVauleWithModel:(SystemInfoModel *)systemInfoModel{
    [[self getDbQuene:@"systeminfo" FunctionName:@"updateVauleWithModel:(SystemInfoModel *)systemInfoModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = [NSString stringWithFormat:@"Update systeminfo Set si_value='%@' Where si_key='%@'",systemInfoModel.si_value,systemInfoModel.si_key];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"systeminfo" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新value信息 - updateVauleWithModel");
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
-(SystemInfoModel *)getSystemInfoModelWithKey:(NSString *)key
{
    __block SystemInfoModel *infoModel = nil;
    
    [[self getDbQuene:@"systeminfo" FunctionName:@"getSystemInfoModelWithKey:(NSString *)key"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select si_key,si_value from systeminfo Where si_key='%@'", key];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            infoModel = [[SystemInfoModel alloc] init];
            
            NSString *si_key = [resultSet stringForColumn:@"si_key"];
            NSString *si_value = [resultSet stringForColumn:@"si_value"];
            
            infoModel.si_key = si_key;
            infoModel.si_value = si_value;
        }
        [resultSet close];
    }];
    
    return infoModel;
}



@end
