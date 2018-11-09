//
//  ImGroupRobotWeatherDAL.m
//  LeadingCloud
//
//  Created by gjh on 2018/9/3.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "ImGroupRobotWeatherDAL.h"

#define instanceColumns @"rwid,name,icon,isopentime,pushtime,province,city,ispushmessage,igid,igrid,riid,addtime"

@implementation ImGroupRobotWeatherDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImGroupRobotWeatherDAL *)shareInstance{
    static ImGroupRobotWeatherDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ImGroupRobotWeatherDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImGroupRobotWeatherTableIfNotExists{
    NSString *tableName = @"im_group_robot_weather";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[rwid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[name] [varchar](50) NULL,"
                                         "[icon] [varchar](50) NULL,"
                                         "[isopentime] [integer] NULL,"
                                         "[pushtime] [date] NULL,"
                                         "[province] [varchar](50) NULL,"
                                         "[city] [varchar](50) NULL,"
                                         "[ispushmessage] [integer] NULL,"
                                         "[igid] [varchar](50) NULL,"
                                         "[igrid] [varchar](50) NULL,"
                                         "[riid] [varchar](50) NULL,"
                                         "[addtime] [date] NULL);",
                                         tableName]];
        
    }
}

/**
 *  升级数据库
 */
-(void)updateImGroupRobotWeatherTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
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
-(void)addDataWithImGroupRobotWeatherArray:(NSMutableArray *)imGroupRobotWeatherArray{
    
    [[self getDbQuene:@"im_group_robot_weather" FunctionName:@"addDataWithImGroupRobotWeatherArray:(NSMutableArray *)imGroupRobotWeatherArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< imGroupRobotWeatherArray.count;  i++) {
            ImGroupRobotWeatherModel *groupRobotWeatherModel = [imGroupRobotWeatherArray objectAtIndex:i];
            NSString *rwid = groupRobotWeatherModel.rwid;
            NSString *name = groupRobotWeatherModel.name;
            NSString *icon = groupRobotWeatherModel.icon;
            NSNumber *isopentime = [NSNumber numberWithInteger:groupRobotWeatherModel.isopentime];
            NSDate *pushtime = groupRobotWeatherModel.pushtime;
            NSString *province = groupRobotWeatherModel.province;
            NSString *city = groupRobotWeatherModel.city;
            NSNumber *ispushmessage = [NSNumber numberWithInteger:groupRobotWeatherModel.ispushmessage];
            NSString *igid = groupRobotWeatherModel.igid;
            NSString *igrid = groupRobotWeatherModel.igrid;
            NSString *riid = groupRobotWeatherModel.riid;
            NSDate *addtime = groupRobotWeatherModel.addtime;
            
            
            NSString *sql = @"INSERT OR REPLACE INTO im_group_robot_weather(rwid,name,icon,isopentime,pushtime,province,city,ispushmessage,igid,igrid,riid,addtime)"
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,rwid,name,icon,isopentime,pushtime,province,city,ispushmessage,igid,igrid,riid,addtime];
            if (!isOK) {
                DDLogError(@"插入失败");
                [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_robot_weather" Sql:sql Error:@"插入失败" Other:nil];
                
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
-(void)addImGroupRobotWeatherModel:(ImGroupRobotWeatherModel *)groupRobotWeatherModel{
    
    [[self getDbQuene:@"im_group_robot_weather" FunctionName:@"addImGroupRobotWeatherModel:(ImGroupRobotWeatherModel *)groupRobotWeatherModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *rwid = groupRobotWeatherModel.rwid;
        NSString *name = groupRobotWeatherModel.name;
        NSString *icon = groupRobotWeatherModel.icon;
        NSNumber *isopentime = [NSNumber numberWithInteger:groupRobotWeatherModel.isopentime];
        NSDate *pushtime = groupRobotWeatherModel.pushtime;
        NSString *province = groupRobotWeatherModel.province;
        NSString *city = groupRobotWeatherModel.city;
        NSNumber *ispushmessage = [NSNumber numberWithInteger:groupRobotWeatherModel.ispushmessage];
        NSString *igid = groupRobotWeatherModel.igid;
        NSString *igrid = groupRobotWeatherModel.igrid;
        NSString *riid = groupRobotWeatherModel.riid;
        NSDate *addtime = groupRobotWeatherModel.addtime;
        
        NSString *sql = @"INSERT OR REPLACE INTO im_group_robot_weather(rwid,name,icon,isopentime,pushtime,province,city,ispushmessage,igid,igrid,riid,addtime)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,rwid,name,icon,isopentime,pushtime,province,city,ispushmessage,igid,igrid,riid,addtime];
        if (!isOK) {
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_robot_weather" Sql:sql Error:@"插入失败" Other:nil];
            
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
 *  根据riid获取ImGroupRobotWeatherModel
 *
 *  @param riid
 *
 *  @return ImGroupRobotWeatherModel
 */
- (ImGroupRobotWeatherModel *)getimGroupRobotWeatherModelWithRiid:(NSString *)riid
{
    __block ImGroupRobotWeatherModel *imGroupRobotWeatherModel = nil;
    
    [[self getDbQuene:@"im_group_robot_weather" FunctionName:@"getimGroupRobotWeatherModelWithRiid:(NSString *)riid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select %@ from im_group_robot_weather Where riid='%@'",instanceColumns, riid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            imGroupRobotWeatherModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return imGroupRobotWeatherModel;
}

/**
 *  根据rwid获取ImGroupRobotWeatherModel
 *
 *  @param rwid
 *
 *  @return ImGroupRobotWeatherModel
 */
- (ImGroupRobotWeatherModel *)getimGroupRobotWeatherModelWithRwid:(NSString *)rwid
{
    __block ImGroupRobotWeatherModel *imGroupRobotWeatherModel = nil;
    
    [[self getDbQuene:@"im_group_robot_weather" FunctionName:@"getimGroupRobotWeatherModelWithRiid:(NSString *)riid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select %@ from im_group_robot_weather Where rwid='%@'",instanceColumns, rwid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            imGroupRobotWeatherModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return imGroupRobotWeatherModel;
}

- (NSMutableArray <ImGroupRobotWeatherModel *>*)getimGroupRobotWeatherModelWithIgid:(NSString *)igid
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"im_group_robot_weather" FunctionName:@"getimGroupRobotWeatherModelWithIgid:(NSString *)igid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"select %@ from im_group_robot_weather Where igid='%@'",instanceColumns, igid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}

#pragma mark - 删除
/* 根据rwid删除对应的数据 */
- (void)deleteImGroupRobotWeatherModelWithRwId:(NSString *)rwid {
    [[self getDbQuene:@"im_group_robot_weather" FunctionName:@"deleteImGroupRobotWeatherModelWithRwId:(NSString *)rwid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_group_robot_weather where rwid=?";
        isOK = [db executeUpdate:sql,rwid];
        
        if (!isOK) {
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_robot_weather" Sql:sql Error:@"删除失败" Other:nil];
            
            DDLogError(@"删除失败 - deleteImGroupRobotWeatherModelWithRwId");
        }
    }];
}
#pragma mark 将查询结果集转换为Model对象

/**
 *  将查询结果集转换为Model对象
 *  @param resultSet
 *  @return
 */
-(ImGroupRobotWeatherModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    ImGroupRobotWeatherModel *model=[[ImGroupRobotWeatherModel alloc]init];

    model.rwid=[resultSet stringForColumn:@"rwid"];
    model.name=[resultSet stringForColumn:@"name"];
    model.icon=[resultSet stringForColumn:@"icon"];
    model.isopentime=[LZFormat Safe2Int32:[resultSet stringForColumn:@"isopentime"]];
    model.pushtime=[resultSet dateForColumn:@"pushtime"];
    model.province=[resultSet stringForColumn:@"province"];
    model.city=[resultSet stringForColumn:@"city"];
    model.ispushmessage=[LZFormat Safe2Int32:[resultSet stringForColumn:@"ispushmessage"]];
    model.igid=[resultSet stringForColumn:@"igid"];
    model.igrid=[resultSet stringForColumn:@"igrid"];
    model.riid=[resultSet stringForColumn:@"riid"];
    model.addtime=[resultSet dateForColumn:@"addtime"];
    
    return model;
}


@end
