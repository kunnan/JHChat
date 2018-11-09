//
//  AppTempDAL.m
//  LeadingCloud
//
//  Created by wchMac on 2016/12/8.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "AppTempDAL.h"

@implementation AppTempDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AppTempDAL *)shareInstance{
    static AppTempDAL *instance = nil;
    
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[AppTempDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createAppTempTableIfNotExists
{
    NSString *tableName = @"app_temp";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[appid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[name] [varchar](20) NULL,"
                                         "[controller] [varchar](500) NULL,"
                                         "[logo] [varchar](100) NULL,"
                                         "[html5] [varchar](500) NULL,"
                                         "[valid] [varchar](50) NULL,"
                                         "[appcode] [varchar](100) NULL,"
                                         "[protogenesis] [integer] NULL,"
                                         "[purchase] [integer] NULL,"
                                         "[appserver] [text] NULL,"
                                         "[remindnumber] [integer] NULL,"
                                         "[sortid] [text] NULL,"
                                         "[appcolour] [varchar](150) NULL,"
                                         "[temptype] [varchar](50) NULL,"
                                         "[selecttype] [integer] NULL);",
                                         tableName]];
    }
}

/**
 *  升级数据库
 */
-(void)updateAppTempTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 77:{
                [self AddColumnToTableIfNotExist:@"app_temp" columnName:@"[version]" type:@"[text]"];
                break;
            }
        }
    }
}

#pragma mark - 添加数据

/**
 *  插入单条数据
 *
 *  @param model AppModel
 */
-(void)addAppModel:(AppModel *)model{
    [[self getDbQuene:@"app_temp" FunctionName:@"addAppModel:(AppModel *)model"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *appid=model.appid;
        NSString *controller=model.controller;
        NSString *html5=model.html5;
        NSString *logo=model.logo;
        NSString *name=model.name;
        NSNumber *protogenesis=[NSNumber numberWithInteger:model.protogenesis];
        NSNumber *purchase=[NSNumber numberWithInteger:model.purchase];
        NSString *valid=model.valid;
        NSString *appcode=model.appcode;
        NSString *appserver=model.appserver;
        NSNumber *remindnumber=[NSNumber numberWithInteger:model.remindnumber];
        NSString *sortid=model.sortid;
        NSNumber *selecttype=[NSNumber numberWithInteger:model.selecttype];
        NSString *appcolour=model.appcolour;
        NSString *temptype = model.temptype;
        NSString *version = model.version;
        
        NSString *sql = @"INSERT OR REPLACE INTO app_temp(appid,controller,html5,logo,name,protogenesis,purchase,valid,appcode,appserver,remindnumber,sortid,selecttype,appcolour,temptype,version)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,appid,controller,html5,logo,name,protogenesis,purchase,valid,appcode,appserver,remindnumber,sortid,selecttype,appcolour,temptype,version];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"app_temp" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}

#pragma mark - 删除数据



#pragma mark - 修改数据

/**
 *  修改状态值
 */
-(void)updateAppTempType{
    [[self getDbQuene:@"app_temp" FunctionName:@"updateAppTempType"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *sql = @"Update app_temp set temptype='0' ";
        isOK = [db executeUpdate:sql];
        if (!isOK) {
            DDLogError(@"修改失败");
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"app_temp" Sql:sql Error:@"插入失败" Other:nil];
            *rollback = YES;
            return;
        }
    }];
}

#pragma mark - 查询数据

/**
 *  根据AppCode获取AppModel
 *
 *  @param appcode 应用appCode
 *
 *  @return 应用信息
 */
-(AppModel *)getAppModelWithAppCode:(NSString *)appcode temptype:(NSString *)temptype{
    
    
    __block AppModel *appModel=nil;
    [[self getDbQuene:@"app_temp" FunctionName:@"getAppModelWithAppCode:(NSString *)appcode temptype:(NSString *)temptype"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From app_temp where LOWER(appcode)='%@' and temptype='%@'",[appcode lowercaseString],temptype];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            appModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return appModel;
}

#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImChatLogModel
 */
-(AppModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    NSString *appid=[resultSet stringForColumn:@"appid"];
    NSString *controller=[resultSet stringForColumn:@"controller"];
    NSString *html5=[resultSet stringForColumn:@"html5"];
    NSInteger protogenesis=[resultSet intForColumn:@"protogenesis"];
    NSInteger purchase=[resultSet intForColumn:@"purchase"];
    NSString *logo=[resultSet stringForColumn:@"logo"];
    NSString *name=[resultSet stringForColumn:@"name"];
    NSString *valid=[resultSet stringForColumn:@"valid"];
    NSString *appcode=[resultSet stringForColumn:@"appcode"];
    NSString *appserver=[resultSet stringForColumn:@"appserver"];
    NSInteger remindnumber=[resultSet intForColumn:@"remindnumber"];
    NSString *sortid=[resultSet stringForColumn:@"sortid"];
    NSInteger selecttype=[resultSet intForColumn:@"selecttype"];
    NSString *appcolour = [resultSet stringForColumn:@"appcolour"];
    NSString *version = [resultSet stringForColumn:@"version"];
    
    AppModel *appModel = [[AppModel alloc]init];
    appModel.appid=appid;
    appModel.controller=controller;
    appModel.html5=html5;
    appModel.protogenesis=protogenesis;
    appModel.purchase=purchase;
    appModel.logo=logo;
    appModel.name=name;
    appModel.valid=valid;
    appModel.appcode=appcode;
    appModel.appserver=appserver;
    appModel.remindnumber=remindnumber;
    appModel.sortid=sortid;
    appModel.selecttype=selecttype;
    appModel.appcolour = appcolour;
    appModel.version = version;
    
    return appModel;
}

@end
