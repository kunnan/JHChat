//
//  ErrorDAL.m
//  LeadingCloud
//
//  Created by dfl on 16/4/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-04-15
 Version: 1.0
 Description: 请求WebApi错误日志数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ErrorDAL.h"
#import "DataAccessMain.h"
#import "AppDateUtil.h"

@implementation ErrorDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ErrorDAL *)shareInstance{
    static ErrorDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ErrorDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createErrorTableIfNotExists
{
    NSString *tableName = @"error";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[errorid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[erroruid] [varchar](50) NULL,"
                                         "[errortitle] [varchar](200) NULL,"
                                         "[errorclass] [varchar](500) NULL,"
                                         "[errormethod] [varchar](500) NULL,"
                                         "[errordata] [varchar](1000) NULL,"
                                         "[errordate] [date] NULL,"
                                         "[errortype] [integer] NULL);",
                                         tableName]];
    }
}
/**
 *  升级数据库
 */
-(void)updateErrorTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据
/**
 *  根据model添加数据
 */
-(void)addDataWithErrorModel:(ErrorModel *)errorModel{
    
    if(![LZUserDataManager readIsOpenRecordLog]){
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self getDbQuene:@"error" FunctionName:@"addDataWithErrorModel:(ErrorModel *)errorModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            BOOL isOK = YES;
            NSString *errorid=errorModel.errorid;
            NSString *erroruid=errorModel.erroruid;
            NSString *errortitle=errorModel.errortitle;
            NSString *errorclass=errorModel.errorclass;
            NSString *errormethod=errorModel.errormethod;
            NSString *errordata=errorModel.errordata;
            NSDate   *errordate=errorModel.errordate;
            NSNumber *errortype=[NSNumber numberWithInteger:errorModel.errortype];
            NSString *sql = @"INSERT OR REPLACE INTO error(errorid,erroruid,errortitle,errorclass,errormethod,errordata,errordate,errortype)"
            "VALUES (?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,errorid,erroruid,errortitle,errorclass,errormethod,errordata,errordate,errortype];
            if (!isOK) {
                DDLogError(@"插入失败");
            }

            if (!isOK) {
                [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"error" Sql:sql Error:@"插入失败" Other:nil];

                *rollback = YES;
                return;
            }
        }];
    });

}

/**
 *  根据model添加数据(自定义类型)
 */
-(void)addDataWithTitle:(NSString *)title data:(NSString *)data errortype:(NSInteger)errortype{
    if(![LZUserDataManager readIsOpenRecordLog]){
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self getDbQuene:@"error" FunctionName:@"addDataWithTitle:(NSString *)title data:(NSString *)data errortype:(NSInteger)errortype"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            BOOL isOK = YES;
            NSString *errorid = [LZUtils CreateGUID];
            NSString *erroruid = [AppUtils GetCurrentUserID];
            NSString *errortitle = title;
            NSString *errorclass = @"";
            NSString *errormethod = @"";
            NSString *errordata = data;
            NSDate   *errordate = [AppDateUtil GetCurrentDate];
            NSNumber *errortypeNum = [NSNumber numberWithInteger:errortype];
            NSString *sql = @"INSERT OR REPLACE INTO error(errorid,erroruid,errortitle,errorclass,errormethod,errordata,errordate,errortype)"
            "VALUES (?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,errorid,erroruid,errortitle,errorclass,errormethod,errordata,errordate,errortypeNum];
            if (!isOK) {
                DDLogError(@"插入失败");
            }

            if (!isOK) {
                [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"error" Sql:sql Error:@"插入失败" Other:nil];
                *rollback = YES;
                return;
            }
        }];
    });

}

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData{
    
    if(![LZUserDataManager readIsOpenRecordLog]){
        return;
    }
    
    [[self getDbQuene:@"error" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        isOK = [db executeUpdate:@"DELETE FROM error"];
        if(!isOK){

            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"error" Sql:@"DELETE FROM error" Error:@"删除失败" Other:nil];
        }
    }];

}

/**
 *  根据日志类型清空数据
 */
-(void)deleteDataWithErrorType:(NSInteger)errortype{
    
    if(![LZUserDataManager readIsOpenRecordLog]){
        return;
    }
    
    [[self getDbQuene:@"error" FunctionName:@"deleteDataWithErrorType:(NSInteger)errortype"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO ;
        NSString *sqlString=[NSString stringWithFormat:@"DELETE FROM error where errortype=%lu",errortype];
        isOK =[ db executeUpdate:sqlString];
        if (!isOK) {
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"error" Sql:sqlString Error:@"删除失败" Other:nil];

        }
//        [db executeUpdate:@"Vacuum error"];
    }];
    [[self getDbBase] executeUpdate:@"Vacuum error"];

}

/**
 *  判断日志信息类型以及日志存储时间超过5天的数据，清空
 */
-(void)deleteDataWithErrorDateGTR5{

    if(![LZUserDataManager readIsOpenRecordLog]){
        return;
    }
    
    __block BOOL isVacuumError = NO;
    [[self getDbQuene:@"error" FunctionName:@"deleteDataWithErrorDateGTR5"] inTransaction:^(FMDatabase *db, BOOL *rollback) {

        NSString *sqlString = [NSString stringWithFormat:@"Select count(0) count From error where julianday('now')-julianday(datetime(errordate, 'unixepoch','localtime'))>5"];
        FMResultSet *resultSet=[db executeQuery:sqlString];
        if ([resultSet next]) {
            NSInteger count = [resultSet intForColumn:@"count"];
            if(count>0){
                isVacuumError = YES;
            }
        }
        if(isVacuumError){
            BOOL isOK = NO;
            NSString *sqlString=[NSString stringWithFormat:@"DELETE FROM error where julianday('now')-julianday(datetime(errordate, 'unixepoch','localtime'))>5"];
            isOK = [ db executeUpdate:sqlString];
            if (!isOK) {
                [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"error" Sql:sqlString Error:@"删除失败" Other:nil];

            }
        }

    }];

    if(isVacuumError){
//        [[self getDbBase] executeUpdate:@"Vacuum error"];
    }

}

///**
// *  是否有超过5天的数据
// */
//-(BOOL)isDataWithErrorDateGTR5{
//    __block BOOL isVacuumError = NO;
//    [[self getDbQuene] inTransaction:^(FMDatabase *db, BOOL *rollback) {
//         NSString *sqlString = [NSString stringWithFormat:@"Select count(0) count From error where errortype<>1 and julianday('now')-julianday(datetime(errordate, 'unixepoch','localtime'))>5"];
//        FMResultSet *resultSet=[db executeQuery:sqlString];
//        if ([resultSet next]) {
//            NSInteger count = [resultSet intForColumn:@"count"];
//            if(count>0){
//                isVacuumError = YES;
//            }
//        }
//    }];
//    return isVacuumError;
//}

#pragma mark - 修改数据



#pragma mark - 查询数据

/**
 *  获取日志信息数据
 *
 */
-(NSMutableArray *)getErrorDataWithUid:(NSString *)uid{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"error" FunctionName:@"getErrorDataWithUid:(NSString *)uid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= [NSString stringWithFormat:@"Select * From error Where erroruid=%@ Order by errordate desc",uid];
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
 *  根据日志类型获取日志信息数据
 *
 */
-(NSMutableArray *)getErrorDataWithUid:(NSString *)uid ErrorType:(NSInteger )errortype{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"error" FunctionName:@"getErrorDataWithUid:(NSString *)uid ErrorType:(NSInteger )errortype"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= [NSString stringWithFormat:@"Select * From error Where erroruid=%@ AND errortype=%lu Order by errordate desc",uid,errortype];
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
 *  获取错误日志数据详情
 *
 */
-(ErrorModel *)getErrorDataWithErrorid:(NSString *)errorid{
    __block ErrorModel *errorModel=nil;
    [[self getDbQuene:@"error" FunctionName:@"getErrorDataWithErrorid:(NSString *)errorid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From error Where errorid='%@'",errorid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {

            errorModel=[self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];

    return errorModel;
    
}

/**
 *  获取日志信息类型
 *
 */
-(NSMutableArray *)getErrorType{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"error" FunctionName:@"getErrorType"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=@"select distinct errortype from error order by errortype asc";
        FMResultSet *resultSet=[db executeQuery:sql];
        // 注意while和if的区别 while循环 如果是if的话 只会得到一个元素
        while([resultSet next]) {
            ErrorModel *errorModel=[[ErrorModel alloc]init];
            errorModel.errortype=[resultSet intForColumn:@"errortype"];
            NSString *errortype=[NSString stringWithFormat:@"%lu",errorModel.errortype];
            [array addObject:errortype];
        }
        [resultSet close];
    }];
	
    
    return array;
}

#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ErrorModel
 */
-(ErrorModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    NSString *errorid = [resultSet stringForColumn:@"errorid"];
    NSString *erroruid = [resultSet stringForColumn:@"erroruid"];
    NSString *errortitle = [resultSet stringForColumn:@"errortitle"];
    NSString *errorclass = [resultSet stringForColumn:@"errorclass"];
    NSString *errormethod = [resultSet stringForColumn:@"errormethod"];
    NSString *errordata = [resultSet stringForColumn:@"errordata"];
    NSDate   *errordate = [resultSet dateForColumn:@"errordate"];
    NSInteger errortype= [resultSet intForColumn:@"errortype"];
    
    ErrorModel *errorModel = [[ErrorModel alloc] init];
    errorModel.errorid = errorid;
    errorModel.erroruid = erroruid;
    errorModel.errortitle = errortitle;
    errorModel.errorclass = errorclass;
    errorModel.errormethod = errormethod;
    errorModel.errordata = errordata;
    errorModel.errordate = errordate;
    errorModel.errortype = errortype;
    
    return errorModel;
}

@end

