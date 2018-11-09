//
//  CoAppDAL.m
//  LeadingCloud
//
//  Created by SY on 16/3/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-03-23
 Version: 1.0
 Description: 应用数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "CoAppDAL.h"
#import "CooAppModel.h"
@implementation CoAppDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoAppDAL *)shareInstance{
    static CoAppDAL *instance = nil;
    
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoAppDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createCooAppTableIfNotExists
{
    NSString *tableName = @"co_app";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[cooAppid] [varchar](100) PRIMARY KEY NOT NULL,"
                                         "[cid] [varchar](100)  NULL,"
                                         "[appid] [varchar](50) NULL,"
                                         "[name] [varchar](20) NULL,"
                                         "[controller] [varchar](500) NULL,"
                                         "[logo] [varchar](100) NULL,"
                                         "[html5] [varchar](500) NULL,"
                                         "[valid] [varchar](50) NULL,"
                                         "[protogenesis] [integer] NULL,"
                                         "[sortIndex] [integer] NULL,"
                                         "[type] [varchar](20) NULL,"
                                         "[isDidLoad] [integer] NULL,"
                                         "[purchase] [integer] NULL,"
                                         "[appcode] [varchar](100) NULL,"
                                         "[appserver] [text] NULL,"
                                         "[remindnumber] [integer] NULL,"
                                         "[isShowApp] [integer] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateCooAppTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
            case 24:{
                
                [self AddColumnToTableIfNotExist:@"co_app" columnName:@"[coappcolour]" type:@"[varchar](50)"];
                break;
            }
//            case 4:{
//                [self AddColumnToTableIfNotExist:@"co_app" columnName:@"appcode" type:@"[varchar](100)"];
//                [self AddColumnToTableIfNotExist:@"co_app" columnName:@"appserver" type:@"[text]"];
//                [self AddColumnToTableIfNotExist:@"co_app" columnName:@"remindnumber" type:@"[integer]"];
//                break;
//            }
//            case 30:{
//                [self AddColumnToTableIfNotExist:@"co_app" columnName:@"isShowApp" type:@"[integer]"];
//                break;
//            }
        }
    }
}
#pragma mark - 添加数据

-(void)addCooDataWithAppArray:(NSMutableArray *)appArray{
    [[self getDbQuene:@"co_app" FunctionName:@"addCooDataWithAppArray:(NSMutableArray *)appArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_app(cooAppid,cid,appid,controller,html5,logo,name,protogenesis,type,sortIndex,purchase,valid,appcode,appserver,remindnumber,isShowApp,coappcolour)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< appArray.count;  i++) {
            CooAppModel *appModel=[appArray objectAtIndex:i];
            
            NSString *appid=appModel.appid;
            NSString *controller=appModel.controller;
            NSString *html5=appModel.html5;
            NSString *logo=appModel.logo;
            NSString *name=appModel.name;
            NSNumber *protogenesis=[NSNumber numberWithInteger:appModel.protogenesis];
            NSNumber *purchase=[NSNumber numberWithInteger:appModel.purchase];
            NSString *valid=appModel.valid;
            NSString *type = appModel.type;
            NSString *cid = appModel.cid;
            NSNumber *index = [NSNumber numberWithInteger:appModel.index];
            NSString *cooappid = appModel.cooAppid;
            NSString *appcode = appModel.mainappcode;
            NSString *coappcolour = appModel.coappcolour;

            NSString *appserver = appModel.appserver;
            NSNumber *remindnumber = [NSNumber numberWithInteger:appModel.remindnumber];
            NSNumber *isShowApp = [NSNumber numberWithInteger:appModel.isShowApp];

            isOK = [db executeUpdate:sql,cooappid,cid,appid,controller,html5,logo,name,protogenesis,type,index,purchase,valid,appcode,appserver,remindnumber,isShowApp,coappcolour];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
            *rollback = YES;
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_app" Sql:sql Error:@"插入失败" Other:nil];

            return;
        }
    }];
    
}
#pragma mark - 删除数据
/**
 *  删除应用（用于保持最新的数据）
 *
 *  @param cid 协作id
 */
-(void)deleteAppDataWithCid:(NSString*)cid {
    
    [[self getDbQuene:@"co_app" FunctionName:@"deleteAppDataWithCid:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_app where cid=?";
        isOK = [db executeUpdate:sql,cid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_app" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];

    
}
// 移除协作区单个应用
-(void)deleteAppDataWithCid:(NSString*)cid appid:(NSString*)appid{
    
    [[self getDbQuene:@"co_app" FunctionName:@"deleteAppDataWithCid:(NSString*)cid appid:(NSString*)appid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_app where cid=? AND appid = ? ";
        isOK = [db executeUpdate:sql,cid,appid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_app" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
    
    
}

#pragma mark - 修改数据
/**
 *  标记已经载入的工具
 *
 *  @param laodTag 0 or 1
 *  @param cid     协作id
 */
-(void)isDidLoad:(NSInteger)laodTag cid:(NSString*)cid{
    
    [[self getDbQuene:@"co_app" FunctionName:@"isDidLoad:(NSInteger)laodTag cid:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_app set isDidLoad =? Where cid=?";
        isOK = [db executeUpdate:sql,laodTag];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_app" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

    
}
#pragma mark - 查询数据

-(NSMutableArray *)getUserAllApp:(NSString*)cid {
    __block CooAppModel *appModel=nil;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_app" FunctionName:@"getUserAllApp:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_app where cid = %@ ",cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
           appModel = [self convertResultSetToModel:resultSet];
           [result addObject:appModel];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  根据AppCode获取AppModel
 *
 *  @param appcode 应用appCode
 *
 *  @return 应用信息
 */
-(CooAppModel *)getAppModelWithAppCode:(NSString *)appcode{
    __block CooAppModel *appModel=nil;
    [[self getDbQuene:@"co_app" FunctionName:@"getAppModelWithAppCode:(NSString *)appcode"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_app where LOWER(appcode)='%@' ",[appcode lowercaseString]];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            appModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return appModel;
}
-(CooAppModel *)getAppModelWithAppCid:(NSString *)cid appid:(NSString*)appid{
    __block CooAppModel *appModel=nil;
    [[self getDbQuene:@"co_app" FunctionName:@"getAppModelWithAppCid:(NSString *)cid appid:(NSString*)appid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_app where appid='%@' AND cid = '%@'",appid,cid];
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
-(CooAppModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    NSString *cooappid = [resultSet stringForColumn:@"cooAppid"];
    NSString *cid = [resultSet stringForColumn:@"cid"];
    NSString *appid=[resultSet stringForColumn:@"appid"];
    NSString *controller=[resultSet stringForColumn:@"controller"];
    NSString *html5=[resultSet stringForColumn:@"html5"];
    NSInteger protogenesis=[resultSet intForColumn:@"protogenesis"];
    NSInteger purchase=[resultSet intForColumn:@"purchase"];
    NSString *logo=[resultSet stringForColumn:@"logo"];
    NSString *name=[resultSet stringForColumn:@"name"];
    NSString *valid=[resultSet stringForColumn:@"valid"];
    NSString *type = [resultSet stringForColumn:@"type"];
    NSString *appcode = [resultSet stringForColumn:@"appcode"];
    NSString *appserver = [resultSet stringForColumn:@"appserver"];
    NSInteger remindnumber=[resultSet intForColumn:@"remindnumber"];
    NSInteger isShowApp = [resultSet intForColumn:@"isShowApp"];
    NSString *coappcolour = [resultSet stringForColumn:@"coappcolour"];
    
    CooAppModel *appModel = [[CooAppModel alloc]init];
    appModel.appid=appid;
    appModel.controller=controller;
    appModel.html5=html5;
    appModel.protogenesis=protogenesis;
    appModel.purchase=purchase;
    appModel.logo=logo;
    appModel.name=name;
    appModel.valid=valid;
    appModel.type = type;
    appModel.cooAppid = cooappid;
    appModel.cid = cid;
    appModel.mainappcode = appcode;
    appModel.appserver = appserver;
    appModel.remindnumber = remindnumber;
    appModel.isShowApp = isShowApp;
    appModel.coappcolour = coappcolour;
    return appModel;
}

@end
