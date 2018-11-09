//
//  ImGroupRobotInfoDAL.m
//  LeadingCloud
//
//  Created by gjh on 2018/9/3.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "ImGroupRobotInfoDAL.h"

//#define instanceColumns @"igrid,riid,igid,bussinessid,name,icon,createuser,createtime"
#define instanceColumns @"riid,appid,appcode,name,icon,intro,preview,iscustomsettint,templatecode,messageapi"

@implementation ImGroupRobotInfoDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImGroupRobotInfoDAL *)shareInstance{
    static ImGroupRobotInfoDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ImGroupRobotInfoDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImGroupRobotInfoTableIfNotExists{
    NSString *tableName = @"im_group_robot_info";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[riid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[appid] [varchar](50) NULL,"
                                         "[appcode] [varchar](50) NULL,"
                                         "[name] [varchar](50) NULL,"
                                         "[icon] [varchar](50) NULL,"
                                         "[intro] [varchar](50) NULL,"
                                         "[preview] [varchar](50) NULL,"
                                         "[iscustomsettint] [integer] NULL,"
                                         "[templatecode] [text] NULL,"
                                         "[messageapi] [varchar](50) NULL);",
                                         tableName]];
        
    }
}

/**
 *  升级数据库
 */
-(void)updateImGroupRobotInfoTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
//            case 90:{
//                [self AddColumnToTableIfNotExist:@"im_group" columnName:@"[groupresource]" type:@"[text]"];
//                break;
//            }
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithImGroupRobotInfoArray:(NSMutableArray *)imGroupRobotInfoArray{
    
    [[self getDbQuene:@"im_group_robot_info" FunctionName:@"addDataWithImGroupRobotInfoArray:(NSMutableArray *)imGroupRobotInfoArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< imGroupRobotInfoArray.count;  i++) {
            ImGroupRobotInfoModel *groupRobotInfoModel = [imGroupRobotInfoArray objectAtIndex:i];
            
            NSString *riid = groupRobotInfoModel.riid;
            NSString *appid = groupRobotInfoModel.appid;
            NSString *appcode = groupRobotInfoModel.appcode;
            NSString *name = groupRobotInfoModel.name;
            NSString *icon = groupRobotInfoModel.icon;
            NSString *intro = groupRobotInfoModel.intro;
            NSNumber *iscustomsettint = [NSNumber numberWithInteger:groupRobotInfoModel.iscustomsettint];
            NSString *preview = groupRobotInfoModel.preview;
            NSString *templatecode = groupRobotInfoModel.templatecode;
            NSString *messageapi = groupRobotInfoModel.messageapi;
            
            NSString *sql = @"INSERT OR REPLACE INTO im_group_robot_info(riid,appid,appcode,name,icon,intro,preview,iscustomsettint,templatecode,messageapi)"
            "VALUES (?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,riid,appid,appcode,name,icon,intro,preview,iscustomsettint,templatecode,messageapi];
            if (!isOK) {
                DDLogError(@"插入失败");
                [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_robot_info" Sql:sql Error:@"插入失败" Other:nil];
                
                break;
            }
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    
}

/**
 *  单个数据
 */
-(void)addImGroupRobotInfoModel:(ImGroupRobotInfoModel *)groupRobotInfoModel{
    
    [[self getDbQuene:@"im_group_robot_info" FunctionName:@"addImGroupRobotInfoModel:(ImGroupRobotInfoModel *)groupRobotInfoModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *riid = groupRobotInfoModel.riid;
        NSString *appid = groupRobotInfoModel.appid;
        NSString *appcode = groupRobotInfoModel.appcode;
        NSString *name = groupRobotInfoModel.name;
        NSString *icon = groupRobotInfoModel.icon;
        NSString *intro = groupRobotInfoModel.intro;
        NSNumber *iscustomsettint = [NSNumber numberWithInteger:groupRobotInfoModel.iscustomsettint];
        NSString *preview = groupRobotInfoModel.preview;
        NSString *templatecode = groupRobotInfoModel.templatecode;
        NSString *messageapi = groupRobotInfoModel.messageapi;
        
        NSString *sql = @"INSERT OR REPLACE INTO im_group_robot_info(riid,appid,appcode,name,icon,intro,preview,iscustomsettint,templatecode,messageapi)"
        "VALUES (?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,riid,appid,appcode,name,icon,intro,preview,iscustomsettint,templatecode,messageapi];
        if (!isOK) {
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_robot_info" Sql:sql Error:@"插入失败" Other:nil];
            
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    
}

#pragma make - 获取
/**
 *  ImGroupRobotInfoModel
 *
 *  @param 
 *
 *  @return ImGroupRobotInfoModel
 */
-(NSMutableArray<ImGroupRobotInfoModel *> *)getimGroupRobotInfoModelArr
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"im_group_robot_info" FunctionName:@"getimGroupRobotInfoModelArr"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"select %@ from im_group_robot_info",instanceColumns];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}
- (ImGroupRobotInfoModel *)getimGroupRobotInfoModelByRiid:(NSString *)riid {
    __block ImGroupRobotInfoModel *imGroupRobotInfoModel = nil;
    
    [[self getDbQuene:@"im_group_robot_info" FunctionName:@"getimGroupRobotInfoModelByRiid:(NSString *)riid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select %@ from im_group_robot_info Where riid='%@'",instanceColumns, riid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            imGroupRobotInfoModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return imGroupRobotInfoModel;
}

#pragma mark - 删除
/* 删除对应的数据 */
- (void)deleteImGroupRobotInfoModel {
    [[self getDbQuene:@"im_group_robot_info" FunctionName:@"deleteImGroupRobotInfoModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_group_robot_info";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_robot_info" Sql:sql Error:@"删除失败" Other:nil];
            
            DDLogError(@"删除失败 - deleteImGroupRobotInfoModel");
        }
    }];
}
#pragma mark 将查询结果集转换为Model对象

/**
 *  将查询结果集转换为Model对象
 *  @param resultSet
 *  @return
 */
-(ImGroupRobotInfoModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    ImGroupRobotInfoModel *model=[[ImGroupRobotInfoModel alloc]init];
    
    model.riid=[resultSet stringForColumn:@"riid"];
    model.appid=[resultSet stringForColumn:@"appid"];
    model.appcode=[resultSet stringForColumn:@"appcode"];
    model.name=[resultSet stringForColumn:@"name"];
    model.icon=[resultSet stringForColumn:@"icon"];
    model.intro=[resultSet stringForColumn:@"intro"];
    model.iscustomsettint=[LZFormat Safe2Int32:[resultSet stringForColumn:@"iscustomsettint"]];
    model.preview=[resultSet stringForColumn:@"preview"];
    model.templatecode=[resultSet stringForColumn:@"templatecode"];
    model.messageapi=[resultSet stringForColumn:@"messageapi"];
    
    return model;
}
@end
