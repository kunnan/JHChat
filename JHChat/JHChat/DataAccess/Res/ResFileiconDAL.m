//
//  ResFileiconDAL.m
//  LeadingCloud
//
//  Created by gjh on 16/9/1.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  gjh
 Date：   2016-09-01
 Version: 1.0
 Description: 资源文件图片相关
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "ResFileiconDAL.h"

@implementation ResFileiconDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResFileiconDAL *)shareInstance {
    static ResFileiconDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ResFileiconDAL alloc] init];
    }
    return instance;
}
#pragma mark - 表结构操作
/**
 *  创建表
 */
- (void)createResFileiconTableIfNotExists {
    
    NSString *tableName = @"res_fileicon";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[iconid] [varchar](50)  NULL,"
                                         "[iconext] [varchar](50) NULL);",
                                         tableName]];
        
    }
}

/**
 *  升级数据库
 */
- (void)updateResFileiconTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion {
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 71:{
                [self AddColumnToTableIfNotExist:@"res_fileicon" columnName:@"[addtime]" type:@"[date]"];
                break;
            }
        }
    }
}

#pragma mark -- 获取数据
/**
 *  根据文件扩展名查询图像iconID
 */
- (ResFileiconModel *)getFileiconIDByFileEXT:(NSString *)fileExt {
    
    __block ResFileiconModel *resFileiconModel = nil;
    
    [[self getDbQuene:@"res_fileicon" FunctionName:@"getFileiconIDByFileEXT:(NSString *)fileExt"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From res_fileicon Where iconext='%@'", fileExt];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            resFileiconModel = [self converResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return resFileiconModel;
}

#pragma mark -- 插入数据
/**
 *  给表中插入一条数据
 */
- (void)addDataWithResFileIconModel:(ResFileiconModel *)resFileIconModel {
    
    [[self getDbQuene:@"res_fileicon" FunctionName:@"addDataWithResFileIconModel:(ResFileiconModel *)resFileIconModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
            
        NSString *sql = @"INSERT OR REPLACE INTO res_fileicon(iconext,iconid,addtime)" "VALUES (?,?,?)";
        isOK = [db executeUpdate:sql,resFileIconModel.iconext, resFileIconModel.iconid, resFileIconModel.addtime];
        if (!isOK) {
            DDLogError(@"插入失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res_fileicon" Sql:sql Error:@"插入失败" Other:nil];

        } else {
            DDLogVerbose(@"res_fileicon数据插入成功");
        }
    }];
}

# pragma mark - 更新数据

/**
 更新数据

 @param resFileIconModel
 */
- (void)updateDataWithResFileIconModel:(ResFileiconModel *)resFileIconModel {
    [[self getDbQuene:@"res_fileicon" FunctionName:@"updateDataWithResFileIconModel:(ResFileiconModel *)resFileIconModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update res_fileicon set addtime=?,iconid=? Where iconext=?";
        isOK = [db executeUpdate:sql,resFileIconModel.addtime,resFileIconModel.iconid,resFileIconModel.iconext];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res_fileicon" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateGroupCreateUser");
        }
    }];
}

- (ResFileiconModel *)converResultSetToModel:(FMResultSet *)resultSet {
    NSString *iconext = [resultSet stringForColumn:@"iconext"];
    NSString *iconid = [resultSet stringForColumn:@"iconid"];
    NSDate *addtime = [resultSet dateForColumn:@"addtime"];
    
    ResFileiconModel *resFileiconModel = [[ResFileiconModel alloc] init];
    resFileiconModel.iconid = iconid;
    resFileiconModel.iconext = iconext;
    resFileiconModel.addtime = addtime;
    return resFileiconModel;
}

@end
