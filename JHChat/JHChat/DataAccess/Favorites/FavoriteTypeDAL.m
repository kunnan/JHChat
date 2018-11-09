//
//  FavoriteTypeDAL.m
//  LeadingCloud
//
//  Created by dfl on 16/4/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-04-09
 Version: 1.0
 Description: 收藏类型数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "FavoriteTypeDAL.h"

@implementation FavoriteTypeDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(FavoriteTypeDAL *)shareInstance{
    static FavoriteTypeDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[FavoriteTypeDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createFavoriteTypeTableIfNotExists
{
    NSString *tableName = @"favorite_type";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[ftid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[name] [varchar](50) NULL,"
                                         "[webviewfun] [varchar](500) NULL,"
                                         "[iosviewfun] [varchar](500) NULL,"
                                         "[androidviewfun] [varchar](500) NULL,"
                                         "[web_image_directory] [varchar](500) NULL,"
                                         "[ios_image_directory] [varchar](500) NULL,"
                                         "[android_image_directory] [varchar](500) NULL);",
                                         tableName]];
        
    }
   
}
/**
 *  升级数据库
 */
-(void)updateFavoriteTypeTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 7:{
                [self AddColumnToTableIfNotExist:@"favorite_type" columnName:@"[trunjs]" type:@"[text]"];
                [self AddColumnToTableIfNotExist:@"favorite_type" columnName:@"[iostrun]" type:@"[text]"];
                [self AddColumnToTableIfNotExist:@"favorite_type" columnName:@"[androidtrun]" type:@"[text]"];
                [self AddColumnToTableIfNotExist:@"favorite_type" columnName:@"[code]" type:@"[text]"];
                [self AddColumnToTableIfNotExist:@"favorite_type" columnName:@"[trunmethod]" type:@"[varchar](50)"];
                break;
            }
                
            case 33:{
                [self AddColumnToTableIfNotExist:@"favorite_type" columnName:@"[appid]" type:@"[varchar](50)"];
                [self AddColumnToTableIfNotExist:@"favorite_type" columnName:@"[applogo]" type:@"[text]"];
                [self AddColumnToTableIfNotExist:@"favorite_type" columnName:@"[appcolor]" type:@"[text]"];
                break;
            }
            case 51:{
                [self AddColumnToTableIfNotExist:@"favorite_type" columnName:@"[appcode]" type:@"[text]"];
                break;
            }
            case 58:{
                [self AddColumnToTableIfNotExist:@"favorite_type" columnName:@"[state]" type:@"[integer]"];
                break;
            }
			case 64:{
				[self AddColumnToTableIfNotExist:@"favorite_type" columnName:@"[baselinkcode]" type:@"[varchar](50)"];

				break;
			}
        }
    }
}
#pragma mark - 添加数据

/**
 *  文件收藏类型
 *
 *  @param FavoriteTypeModel 收藏文件类型的model
 */
-(void)addDataWithFavoriteTypeModel:(NSMutableArray*)favoriteTypeFileArray{
    
    [[self getDbQuene:@"favorite_type" FunctionName:@"addDataWithFavoriteTypeModel:(NSMutableArray*)favoriteTypeFileArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        for (int i = 0; i < [favoriteTypeFileArray count]; i++) {
            FavoriteTypeModel *favoriteTypeModel = nil;
            favoriteTypeModel = [favoriteTypeFileArray objectAtIndex:i];
            NSString *ftid = favoriteTypeModel.ftid;
            NSString *name = favoriteTypeModel.name;
            NSString *webviewfun = favoriteTypeModel.webviewfun;
            NSString *iosviewfun = favoriteTypeModel.iosviewfun;
            NSString *androidviewfun = favoriteTypeModel.androidviewfun;
            NSString *webimagedirectory = favoriteTypeModel.web_image_directory;
            NSString *iosimagedirectory = favoriteTypeModel.ios_image_directory;
            NSString *androidimagedirectory = favoriteTypeModel.android_image_directory;
            NSString *trunjs = favoriteTypeModel.trunjs;
            NSString *iostrun = favoriteTypeModel.iostrun;
            NSString *androidtrun = favoriteTypeModel.androidtrun;
            NSString *code = favoriteTypeModel.code;
            NSString *trunmethod = favoriteTypeModel.trunmethod;
            NSString *appid = favoriteTypeModel.appid;
            NSString *applogo = favoriteTypeModel.applogo;
            NSString *appcolor = favoriteTypeModel.appcolor;
            NSString *appcode = favoriteTypeModel.appcode;
            NSNumber *state = [NSNumber numberWithInteger:favoriteTypeModel.state];
			NSString *baselinkcode = favoriteTypeModel.baselinkcode;
			
            NSString *sql = @"INSERT OR REPLACE INTO favorite_type(ftid,name,webviewfun,iosviewfun,androidviewfun,web_image_directory,ios_image_directory,android_image_directory,trunjs,iostrun,androidtrun,code,trunmethod,appid,applogo,appcolor,appcode,state,baselinkcode)"
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            
            isOK = [db executeUpdate:sql,ftid,name,webviewfun,iosviewfun,androidviewfun,webimagedirectory,iosimagedirectory,androidimagedirectory,trunjs,iostrun,androidtrun,code,trunmethod,appid,applogo,appcolor,appcode,state,baselinkcode];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
            
            if (!isOK) {
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"favorite_type" Sql:sql Error:@"插入失败" Other:nil];

                *rollback = YES;
                return;
            }
        }
    }];
}

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData{
    [[self getDbQuene:@"favorite_type" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"DELETE FROM favorite_type"];
    }];
}

#pragma mark - 修改数据



#pragma mark - 查询数据

/**
 *  从收藏类型表中查询
 *
 *  @return 目标数组
 */
-(NSMutableArray*)selectAllFavoriteType{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"favorite_type" FunctionName:@"selectAllFavoriteType"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= @"Select * From favorite_type Order by ftid asc";
        FMResultSet *resultSet=[db executeQuery:sql];
        // 注意while和if的区别 while循环 如果是if的话 只会得到一个元素
        while([resultSet next]) {
            
            [array addObject:[self convertResultSetToModel:resultSet]];
            
        }
        [resultSet close];
    }];
    
    return array;
}

/**
 *  从收藏类型表中查询
 *
 *  @return 目标数组
 */
-(NSMutableArray*)selectAllFavoriteTypeWithByState:(NSInteger) state{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"favorite_type" FunctionName:@"selectAllFavoriteTypeWithByState:(NSInteger) state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= @"Select * From favorite_type Where state=? Order by ftid asc";
        FMResultSet *resultSet=[db executeQuery:sql,[NSNumber numberWithInteger:state]];
        // 注意while和if的区别 while循环 如果是if的话 只会得到一个元素
        while([resultSet next]) {
            
            [array addObject:[self convertResultSetToModel:resultSet]];
            
        }
        [resultSet close];
    }];
    
    return array;
}

/**
 *  根据收藏code 得到模型
 *
 *  @param type 动态code
 *
 *  @return
 */
- (FavoriteTypeModel*)getFavoriteType:(NSString*)type{
    
    __block FavoriteTypeModel *tempModel;
    [[self getDbQuene:@"favorite_type" FunctionName:@"getFavoriteType:(NSString*)type"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM favorite_type WHERE code=?"];
        FMResultSet *resultSet=[db executeQuery:sql,type];
        while ([resultSet next]) {
            
            tempModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return tempModel;
    
}

/**
 *  根据收藏主键ID 得到Code
 *
 *  @param type 动态code
 *
 *  @return
 */
-(NSString *)getFavoriteCodeWithByFtid:(NSString *)ftid{
    __block NSString *code=nil;
    [[self getDbQuene:@"favorite_type" FunctionName:@"getFavoriteCodeWithByFtid:(NSString *)ftid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select code From favorite_type Where ftid=%@ ",ftid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            code=[resultSet stringForColumn:@"code"];
        }
        [resultSet close];
    }];
    return code;
}

/**
 *  根据收藏主键ID 得到模型
 *
 *  @param ftid
 *
 *  @return
 */
- (FavoriteTypeModel*)getFavoriteTypeWithByFtid:(NSString*)ftid{
    
    __block FavoriteTypeModel *tempModel;
    [[self getDbQuene:@"favorite_type" FunctionName:@"getFavoriteTypeWithByFtid:(NSString*)ftid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM favorite_type WHERE ftid=?"];
        FMResultSet *resultSet=[db executeQuery:sql,ftid];
        while ([resultSet next]) {
            
            tempModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return tempModel;
    
}

#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return FavoriteTypeModel
 */
-(FavoriteTypeModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    NSString *ftid = [resultSet stringForColumn:@"ftid"];
    NSString *name = [resultSet stringForColumn:@"name"];
    NSString *webviewfun = [resultSet stringForColumn:@"webviewfun"];
    NSString *iosviewfun = [resultSet stringForColumn:@"iosviewfun"];
    NSString *androidviewfun = [resultSet stringForColumn:@"androidviewfun"];
    NSString *webimagedirectory = [resultSet stringForColumn:@"web_image_directory"];
    NSString *iosimagedirectory = [resultSet stringForColumn:@"ios_image_directory"];
    NSString *androidimagedirectory = [resultSet stringForColumn:@"android_image_directory"];
    NSString *trunjs = [resultSet stringForColumn:@"trunjs"];
    NSString *iostrun = [resultSet stringForColumn:@"iostrun"];
    NSString *androidtrun = [resultSet stringForColumn:@"androidtrun"];
    NSString *code = [resultSet stringForColumn:@"code"];
    NSString *trunmethod = [resultSet stringForColumn:@"trunmethod"];
    NSString *appid = [resultSet stringForColumn:@"appid"];
    NSString *applogo = [resultSet stringForColumn:@"applogo"];
    NSString *appcolor = [resultSet stringForColumn:@"appcolor"];
    NSString *appcode = [resultSet stringForColumn:@"appcode"];
    NSInteger state = [resultSet intForColumn:@"state"];
	NSString *baselinkcode = [resultSet stringForColumn:@"baselinkcode"];
	
    FavoriteTypeModel *favoriteTypeModel = [[FavoriteTypeModel alloc] init];
    favoriteTypeModel.ftid = ftid;
    favoriteTypeModel.name = name;
    favoriteTypeModel.webviewfun = webviewfun;
    favoriteTypeModel.iosviewfun = iosviewfun;
    favoriteTypeModel.androidviewfun = androidviewfun;
    favoriteTypeModel.web_image_directory = webimagedirectory;
    favoriteTypeModel.ios_image_directory = iosimagedirectory;
    favoriteTypeModel.android_image_directory = androidimagedirectory;
    favoriteTypeModel.trunjs = trunjs;
    favoriteTypeModel.iostrun = iostrun;
    favoriteTypeModel.androidtrun = androidtrun;
    favoriteTypeModel.code = code;
    favoriteTypeModel.trunmethod = trunmethod;
    favoriteTypeModel.appid = appid;
    favoriteTypeModel.applogo = applogo;
    favoriteTypeModel.appcolor = appcolor;
    favoriteTypeModel.appcode = appcode;
    favoriteTypeModel.state = state;
	favoriteTypeModel.baselinkcode = baselinkcode;
    return favoriteTypeModel;
}

@end
