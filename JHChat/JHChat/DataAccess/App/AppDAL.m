//
//  AppDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 应用数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/


#import "AppDAL.h"

@implementation AppDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AppDAL *)shareInstance{
    static AppDAL *instance = nil;
    
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[AppDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createAppTableIfNotExists
{
    NSString *tableName = @"app";
    
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
                                         "[selecttype] [integer] NULL);",
                                         tableName]];
    }
}
/**
 *  升级数据库
 */
-(void)updateAppTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 18:{
                [self AddColumnToTableIfNotExist:@"app" columnName:@"[appcolour]" type:@"[varchar](150)"];
                break;
            }
            case 55:{
                [self AddColumnToTableIfNotExist:@"app" columnName:@"[orgid]" type:@"[varchar](50)"];
                [self AddColumnToTableIfNotExist:@"app" columnName:@"[nowappid]" type:@"[varchar](50)"];
                break;
            }
            case 58:{
                [self AddColumnToTableIfNotExist:@"app" columnName:@"[version]" type:@"[text]"];
                break;
            }
            case 92:{
                [self AddColumnToTableIfNotExist:@"app" columnName:@"[alias]" type:@"[text]"];
                break;
            }

        }
    }
}
#pragma mark - 添加数据

-(void)addDataWithAppArray:(NSMutableArray *)appArray{
	[[self getDbQuene:@"app" FunctionName:@"addDataWithAppArray:(NSMutableArray *)appArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO app(appid,controller,html5,logo,name,protogenesis,purchase,valid,appcode,appserver,remindnumber,sortid,selecttype,appcolour,orgid,nowappid,version,alias)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< appArray.count;  i++) {
            AppModel *appModel=[appArray objectAtIndex:i];
            
            NSString *appid=appModel.appid;
            NSString *controller=appModel.controller;
            NSString *html5=appModel.html5;
            NSString *logo=appModel.logo;
            NSString *name=appModel.name;
            NSNumber *protogenesis=[NSNumber numberWithInteger:appModel.protogenesis];
            NSNumber *purchase=[NSNumber numberWithInteger:appModel.purchase];
            NSString *valid=appModel.valid;
            NSString *appcode=appModel.appcode;
            NSString *appserver=appModel.appserver;
            NSNumber *remindnumber=[NSNumber numberWithInteger:appModel.remindnumber];
            NSString *sortid=appModel.sortid;
            NSNumber *selecttype=[NSNumber numberWithInteger:appModel.selecttype];
            NSString *appcolour=appModel.appcolour;
            NSString *orgid = appModel.orgid;
            NSString *nowappid = appModel.nowappid;
            NSString *version = appModel.version;
            NSString *alias = appModel.alias;
			
            isOK = [db executeUpdate:sql,appid,controller,html5,logo,name,protogenesis,purchase,valid,appcode,appserver,remindnumber,sortid,selecttype,appcolour,orgid,nowappid,version,alias];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"app" Sql:sql Error:@"插入失败" Other:nil];
            *rollback = YES;
            return;
        }
    }];

}

/**
 *  插入单条数据
 *
 *  @param model AppModel
 */
-(void)addAppModel:(AppModel *)model{
    [[self getDbQuene:@"app" FunctionName:@"addAppModel:(AppModel *)model"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
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
        NSString *orgid = model.orgid;
        NSString *nowappid = model.nowappid;
        NSString *version = model.version;
        NSString *alias = model.alias;
        
        NSString *sql = @"INSERT OR REPLACE INTO app(appid,controller,html5,logo,name,protogenesis,purchase,valid,appcode,appserver,remindnumber,sortid,selecttype,appcolour,orgid,nowappid,version,alias)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?";
        isOK = [db executeUpdate:sql,appid,controller,html5,logo,name,protogenesis,purchase,valid,appcode,appserver,remindnumber,sortid,selecttype,appcolour,orgid,nowappid,version,alias];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"app" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}

#pragma mark - 删除数据
/**
 *  清空所有数据
 */
-(void)deleteAllData{
    [[self getDbQuene:@"app" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;

        isOK =[db executeUpdate:@"DELETE FROM app"];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"app" Sql:@"DELETE FROM app" Error:@"插入失败" Other:nil];
			
			DDLogError(@"删除失败 - updateMsgId");
		}
    }];
}

/**
 * 根据orgid删除数据
 *
 *  @param orgid
 */
-(void)deleteAppWithOrgid:(NSString*)orgid{
    
    [[self getDbQuene:@"app" FunctionName:@"deleteAppWithOrgid:(NSString*)orgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from app where orgid=?";
        isOK = [db executeUpdate:sql,orgid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"app" Sql:sql Error:@"插入失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}



#pragma mark - 修改数据

/**
 *  修改排序id
 */
-(void)updateAppWithSortid:(NSString *)sortid appid:(NSString *)appid{
    [[self getDbQuene:@"app" FunctionName:@"updateAppWithSortid:(NSString *)sortid appid:(NSString *)appid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *sql = @"Update app set sortid=? Where appid=?";
        isOK = [db executeUpdate:sql,sortid,appid];
        if (!isOK) {
            DDLogError(@"修改失败");
        }
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}

/**
 *  修改提醒数字
 */
-(void)updateAppWithRemindNumber:(NSInteger )remindnumber appid:(NSString *)appid{
    [[self getDbQuene:@"app" FunctionName:@"updateAppWithRemindNumber:(NSInteger )remindnumber appid:(NSString *)appid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSNumber *remindnumbers = [NSNumber numberWithInteger:remindnumber];
        
        NSString *sql = @"Update app set remindnumber=? Where nowappid=?";
        isOK = [db executeUpdate:sql,remindnumbers,appid];
        if (!isOK) {
            DDLogError(@"修改失败");
        }
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}

#pragma mark - 查询数据

-(NSMutableArray *)getUserAllApp{
    __block AppModel *appModel=nil;
    NSMutableArray *result = [[NSMutableArray alloc] init];
	[[self getDbQuene:@"app" FunctionName:@"getUserAllApp"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From app where selecttype=1 order by cast(sortid as int)"];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            appModel = [self convertResultSetToModel:resultSet];
            [result addObject:appModel];
        }
        [resultSet close];
    }];
    
    return result;
}
-(NSMutableArray *)getUserAllApp1{
    __block AppModel *appModel=nil;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"app" FunctionName:@"getUserAllApp1"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From app where orgid=%@",[AppUtils GetCurrentOrgID]];
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
-(AppModel *)getAppModelWithAppCode:(NSString *)appcode{
    __block AppModel *appModel=nil;
    [[self getDbQuene:@"app" FunctionName:@"getAppModelWithAppCode:(NSString *)appcode"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From app where LOWER(appcode)='%@' and orgid=%@",[appcode lowercaseString],[AppUtils GetCurrentOrgID]];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            appModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return appModel;
}

/**
 *  根据appid获取AppModel
 *
 *  @param appid 应用appid
 *
 *  @return 应用信息
 */
-(AppModel *)getAppModelWithAppId:(NSString *)appid{
    __block AppModel *appModel=nil;
    [[self getDbQuene:@"app" FunctionName:@"getAppModelWithAppId:(NSString *)appid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From app where nowappid=%@ and orgid=%@",appid,[AppUtils GetCurrentOrgID]];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            appModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return appModel;
}

/**
 *  获取提醒数量
 *
 *  @return 数量
 */
-(NSInteger)getRemindNumber
{
    __block NSInteger noReadCount = 0;
    
    [[self getDbQuene:@"app" FunctionName:@"getRemindNumber"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
//        NSString *sql= [NSString stringWithFormat:@"select count(remindnumber,0) as remindnumber from app where orgid=%@",[AppUtils GetCurrentOrgID]];
//        FMResultSet *resultSet=[db executeQuery:sql];
//        while ([resultSet next]) {
//            NSInteger badge = [resultSet intForColumn:@"remindnumber"];
//            noReadCount = noReadCount + badge;
//        }
        
        NSString *sql= [NSString stringWithFormat:@"select sum(ifnull(remindnumber,0)) as remindnumber from app where orgid=%@",[AppUtils GetCurrentOrgID]];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            noReadCount = [resultSet intForColumn:@"remindnumber"];
        }
        [resultSet close];
    }];
    
    return noReadCount;
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
    NSString *orgid = [resultSet stringForColumn:@"orgid"];
    NSString *nowappid = [resultSet stringForColumn:@"nowappid"];
    NSString *version = [resultSet stringForColumn:@"version"];
    NSString *alias = [resultSet stringForColumn:@"alias"];
    
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
    appModel.orgid = orgid;
    appModel.nowappid = nowappid;
    appModel.version = version;
    appModel.alias = alias;
    
    return appModel;
}


@end
