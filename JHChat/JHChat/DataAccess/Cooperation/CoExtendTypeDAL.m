//
//  CoExtendType.m
//  LeadingCloud
//
//  Created by gjh on 17/3/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "CoExtendTypeDAL.h"

@implementation CoExtendTypeDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoExtendTypeDAL *)shareInstance{
    static CoExtendTypeDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoExtendTypeDAL alloc] init];
    }
    return instance;
}

/**
 *  创建表
 */
-(void)createCoExtendTypeTableIfNotExists{
    
    NSString *tableName = @"co_extend_type";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-10-26日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[cetid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[code] [varchar](50) NULL,"
                                         "[name] [varchar](50) NULL,"
                                         "[aliasname] [varchar](50) NULL,"
                                         "[config] [varchar](50) NULL,"
                                         "[description] [varchar](50) NULL);",
                                         tableName]];
        
    }
    
}
/**
 *  升级数据库
 */
-(void)updateCoExtendTypeTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 83:{
                [self AddColumnToTableIfNotExist:@"co_extend_type" columnName:@"[appcode]" type:@"[varchar](50)"];
                break;
            }
        }
    }    
}


/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)dataArray{
    
    [[self getDbQuene:@"co_extend_type" FunctionName:@"addDataWithArray:(NSMutableArray *)dataArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_extend_type(cetid,code,name,aliasname,config,description,appcode)"
		"VALUES (?,?,?,?,?,?,?)";
		
        for (int i = 0; i< dataArray.count;  i++) {
            CoExtendTypeModel *dataModel = [dataArray objectAtIndex:i];
            
            NSString *cetid = dataModel.cetid;
            NSString *code = dataModel.code;
            NSString *name = dataModel.name;
            NSString *aliasname = dataModel.aliasname;
            NSString *config = dataModel.config;
            NSString *description = dataModel.des;
            NSString *appcode = dataModel.appcode;
			
            isOK = [db executeUpdate:sql,cetid,code,name,aliasname,config,description,appcode];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_extend_type" Sql:sql Error:@"插入失败" Other:nil];

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
    [[self getDbQuene:@"co_extend_type" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"DELETE FROM co_extend_type"];
    }];
}
#pragma mark - 查数据
- (CoExtendTypeModel *)getModelFromCode:(NSString*)code{
    
    CoExtendTypeModel *dataModel = [[CoExtendTypeModel alloc] init];
    
    [[self getDbQuene:@"co_extend_type" FunctionName:@"getModelFromCode:(NSString*)code"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_extend_type Where code = '%@'",code];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            dataModel.code = [resultSet stringForColumn:@"code"];
            dataModel.name = [resultSet stringForColumn:@"name"];
            dataModel.aliasname = [resultSet stringForColumn:@"aliasname"];
            dataModel.config = [resultSet stringForColumn:@"config"];
            dataModel.des = [resultSet stringForColumn:@"description"];
            dataModel.appcode = [resultSet stringForColumn:@"appcode"];
        }
        [resultSet close];
    }];
    
    return dataModel;   
    
}
@end
