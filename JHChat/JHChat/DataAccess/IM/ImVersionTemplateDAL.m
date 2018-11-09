//
//  ImVersionTemplateDAL.m
//  LeadingCloud
//
//  Created by wchMac on 16/8/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-08-16
 Version: 1.0
 Description: 消息模板版本表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "ImVersionTemplateDAL.h"

#define instanceColumns @"tvid,templates,tmcode,version,replaceparams,linktemplate,linkreplaceparams"

@implementation ImVersionTemplateDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImVersionTemplateDAL *)shareInstance{
    static ImVersionTemplateDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ImVersionTemplateDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImVersionTemplateTableIfNotExists{
    NSString *tableName = @"im_versiontemplate";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[tvid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[templates] [text] NULL,"
                                         "[tmcode] [varchar](200) NULL,"
                                         "[version] [integer] NULL,"
                                         "[replaceparams] [text] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateImVersionTemplateTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 20:
                [self AddColumnToTableIfNotExist:@"im_versiontemplate" columnName:@"[linktemplate]" type:@"[text]"];
                break;
            case 54:
                [self AddColumnToTableIfNotExist:@"im_versiontemplate" columnName:@"[linkreplaceparams]" type:@"[varchar](200)"];
                break;
        }
    }
}

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithImVersionTemplateArray:(NSMutableArray *)imMsgTemplate{
    
    [[self getDbQuene:@"im_msgtemplate" FunctionName:@"addDataWithImVersionTemplateArray:(NSMutableArray *)imMsgTemplate"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< imMsgTemplate.count;  i++) {
            ImVersionTemplateModel *model = [imMsgTemplate objectAtIndex:i];
            
            NSString *tvid = model.tvid;
            NSString *templates = model.templates;
            NSString *tmcode = model.tmcode;
            NSNumber *version=[NSNumber numberWithInteger:model.version];
            NSString *replaceparams=model.replaceparams;
            NSString *linktemplate = model.linktemplate;
            NSString *linkreplaceparams = model.linkreplaceparams;
            
            NSString *sql = @"INSERT OR REPLACE INTO im_versiontemplate(tvid,tmcode,version,templates,replaceparams,linktemplate,linkreplaceparams)"
            "VALUES (?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,tvid,tmcode,version,templates,replaceparams,linktemplate,linkreplaceparams];
            
            if (!isOK) {
                DDLogError(@"更新失败");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_versiontemplate" Sql:sql Error:@"插入失败" Other:nil];

                break;
            }
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}


#pragma mark - 删除数据
/**
 *  清空所有数据
 */
-(void)deleteAllDataVersionTemplate{
    [[self getDbQuene:@"im_msgtemplate" FunctionName:@"deleteAllDataVersionTemplate"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"DELETE FROM im_versiontemplate"];
    }];
}

#pragma mark - 查询数据

/**
 *  根据tvid获取对应的模板信息
 */
-(ImVersionTemplateModel *)getImVersionTemplateModelWithTemplate:(NSInteger)tvid
{
    __block ImVersionTemplateModel *templateModel = nil;
    [[self getDbQuene:@"im_msgtemplate" FunctionName:@"getImVersionTemplateModelWithTemplate:(NSInteger)tvid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= [NSString stringWithFormat:@"select %@ from im_versiontemplate Where tvid=%ld",instanceColumns,tvid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            templateModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return templateModel;
}

/**
 *  获取所有的模板信息
 */
-(NSArray<ImVersionTemplateModel *> *)getAllImVersionTemplateModel {
    
    NSMutableArray<ImVersionTemplateModel *> *modelDataArr = [NSMutableArray array];
    [[self getDbQuene:@"im_msgtemplate" FunctionName:@"getAllImVersionTemplateModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= [NSString stringWithFormat:@"select %@ from im_versiontemplate",instanceColumns];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            ImVersionTemplateModel *templateModel = [self convertResultSetToModel:resultSet];
            [modelDataArr addObject:templateModel];
        }
        [resultSet close];
    }];
    
    return modelDataArr;
}

/**
 *  获取模板信息数量
 */
-(NSInteger)getImVersionTemplateCount
{
    __block NSInteger count = 0;
    [[self getDbQuene:@"im_msgtemplate" FunctionName:@"getImVersionTemplateCount"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= [NSString stringWithFormat:@"select count(0) as count from im_versiontemplate"];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            count = [resultSet intForColumn:@"count"];
        }
        [resultSet close];
    }];
    
    return count;
}

#pragma mark - Private Function

/**
 *  转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImVersionTemplateModel
 */
-(ImVersionTemplateModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    ImVersionTemplateModel *imVersionTemplateModel=[[ImVersionTemplateModel alloc]init];
    
    imVersionTemplateModel.tvid = [resultSet stringForColumn:@"tvid"];
    imVersionTemplateModel.tmcode = [resultSet stringForColumn:@"tmcode"];
    imVersionTemplateModel.version = [resultSet intForColumn:@"version"];
    imVersionTemplateModel.templates = [resultSet stringForColumn:@"templates"];
    imVersionTemplateModel.replaceparams = [resultSet stringForColumn:@"replaceparams"];
    imVersionTemplateModel.linktemplate = [resultSet stringForColumn:@"linktemplate"];
    imVersionTemplateModel.linkreplaceparams = [resultSet stringForColumn:@"linkreplaceparams"];
    return imVersionTemplateModel;
}

@end
