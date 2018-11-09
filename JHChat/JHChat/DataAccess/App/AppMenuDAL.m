//
//  AppMenuDAL.m
//  LeadingCloud
//
//  Created by dfl on 17/4/14.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "AppMenuDAL.h"
#import "NSObject+JsonSerial.h"
#import "NSDictionary+DicSerial.h"
#import "ErrorDAL.h"

@implementation AppMenuDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AppMenuDAL *)shareInstance{
    static AppMenuDAL *instance = nil;
    
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[AppMenuDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createAppMenuTableIfNotExists
{
    NSString *tableName = @"app_menu";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[appmenuid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[color] [varchar](100) NULL,"
                                         "[name] [text] NULL,"
                                         "[logo] [text] NULL,"
                                         "[type] [integer] NULL);",
                                         tableName]];
    }
}
/**
 *  升级数据库
 */
-(void)updateAppMenuTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 55:{
                [self AddColumnToTableIfNotExist:@"app_menu" columnName:@"[orgid]" type:@"[varchar](50)"];
                [self AddColumnToTableIfNotExist:@"app_menu" columnName:@"[nowid]" type:@"[varchar](50)"];
                break;
            }
        }
    }
}

#pragma mark - 添加数据

-(void)addDataWithAppMenuArray:(NSMutableArray *)appMenuArray{
	[[self getDbQuene:@"app_menu" FunctionName:@"addDataWithAppMenuArray:(NSMutableArray *)appMenuArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO app_menu(appmenuid,color,logo,name,type,orgid,nowid)"
		"VALUES (?,?,?,?,?,?,?)";
		
        for (int i = 0; i< appMenuArray.count;  i++) {
            AppMenuModel *appMenuModel=[appMenuArray objectAtIndex:i];
//            AppMenuModel *appMenuModel = [[AppMenuModel alloc]init];
//            [appMenuModel serializationWithDictionary:dic];
//            appMenuModel.appmenuid = [dic lzNSStringForKey:@"id"];
            NSString *appmenuid=appMenuModel.appmenuid;
            NSString *color=appMenuModel.color;
            NSString *logo=appMenuModel.logo;
            NSString *name=appMenuModel.name;
            NSNumber *type=[NSNumber numberWithInteger:appMenuModel.type];
            NSString *orgid = appMenuModel.orgid;
            NSString *nowid = appMenuModel.nowid;
			
            isOK = [db executeUpdate:sql,appmenuid,color,logo,name,type,orgid,nowid];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"app_menu" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}

/**
 *  插入单条数据
 *
 *  @param model AppMenuModel
 */
-(void)addAppMenuModel:(AppMenuModel *)model{
    [[self getDbQuene:@"app_menu" FunctionName:@"addAppMenuModel:(AppMenuModel *)model"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *appmenuid=model.appmenuid;
        NSString *color=model.color;
        NSString *logo=model.logo;
        NSString *name=model.name;
        NSNumber *type=[NSNumber numberWithInteger:model.type];
        NSString *orgid = model.orgid;
        NSString *nowid = model.nowid;
        
        NSString *sql = @"INSERT OR REPLACE INTO app_menu(appmenuid,color,logo,name,type,orgid,nowid)"
        "VALUES (?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,appmenuid,color,logo,name,type,orgid,nowid];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        if (!isOK) {
            *rollback = YES;
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"app_menu" Sql:sql Error:@"插入失败" Other:nil];

            return;
        }
    }];
}

#pragma mark - 删除数据
/**
 *  清空所有数据
 */
-(void)deleteAllData{
    [[self getDbQuene:@"app_menu" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;

        isOK = [db executeUpdate:@"DELETE FROM app_menu"];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"app_menu" Sql:@"DELETE FROM app_menu" Error:@"删除失败" Other:nil];
			
			DDLogError(@"删除失败 - updateMsgId");
		}
    }];
}

/**
 * 根据orgid删除数据
 *
 *  @param orgid
 */
-(void)deleteAppMenuWithOrgid:(NSString*)orgid{
    
    [[self getDbQuene:@"app_menu" FunctionName:@"deleteAppMenuWithOrgid:(NSString*)orgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from app_menu where orgid=?";
        isOK = [db executeUpdate:sql,orgid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"app_menu" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}

#pragma mark - 查询数据

-(NSMutableArray *)getUserAllAppMenu{
    __block AppMenuModel *appMenuModel=nil;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    /* 判断是否含有重复的应用 */
    NSMutableArray *appIDArr = [[NSMutableArray alloc] init];
    __block BOOL isError = NO;
    
    [[self getDbQuene:@"app_menu" FunctionName:@"getUserAllAppMenu"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From app_menu where orgid=? and nowid!=3"];
        FMResultSet *resultSet=[db executeQuery:sql,[AppUtils GetCurrentOrgID]];
        while ([resultSet next]) {
            
            appMenuModel = [self convertResultSetToModel:resultSet];
            
            if([appIDArr containsObject:appMenuModel.nowid]){
                isError = YES;
            } else {
                [appIDArr addObject:appMenuModel.nowid];
                [result addObject:appMenuModel];
            }
        }
        [resultSet close];
    }];
    
    if(isError){
        [[ErrorDAL shareInstance] addDataWithTitle:@"应用，存在重复的应用数据" data:[AppUtils GetCurrentOrgID] errortype:Error_Type_Eleven];
    }
    
    return result;
}

-(NSMutableArray *)getUserAllAppMenuDic{
    __block AppMenuModel *appMenuModel=nil;
    __block NSMutableDictionary *dic = nil;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"app_menu" FunctionName:@"getUserAllAppMenuDic"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From app_menu"];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            appMenuModel = [self convertResultSetToModel:resultSet];
            dic = [appMenuModel convertModelToDictionary];
            [dic setObject:appMenuModel.appmenuid forKey:@"id"];
            [dic removeObjectForKey:@"appmenuid"];
            [result addObject:dic];
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
 *  @return AppMenuModel
 */
-(AppMenuModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    NSString *appmenuid=[resultSet stringForColumn:@"appmenuid"];
    NSString *color=[resultSet stringForColumn:@"color"];
    NSString *logo=[resultSet stringForColumn:@"logo"];
    NSString *name=[resultSet stringForColumn:@"name"];
    NSInteger type=[resultSet intForColumn:@"type"];
    NSString *orgid = [resultSet stringForColumn:@"orgid"];
    NSString *nowid = [resultSet stringForColumn:@"nowid"];
    
    AppMenuModel *appMenuModel = [[AppMenuModel alloc]init];
    appMenuModel.appmenuid=appmenuid;
    appMenuModel.color=color;
    appMenuModel.logo=logo;
    appMenuModel.name=name;
    appMenuModel.type=type;
    appMenuModel.orgid = orgid;
    appMenuModel.nowid = nowid;

    return appMenuModel;
}

@end
