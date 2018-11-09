//
//  ResRecycleDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 资源回收站数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ResRecycleDAL.h"
#import "ResRecycleModel.h"
@implementation ResRecycleDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResRecycleDAL *)shareInstance{
    static ResRecycleDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ResRecycleDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createResRecycleTableIfNotExists
{
    NSString *tableName = @"res_recycle";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[recyid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[classid] [varchar](50) NULL,"
                                         "[rpid] [varchar](50) NULL,"
                                         "[name] [varchar](200) NULL,"
                                         "[exptype] [varchar](50) NULL,"
                                         "[type] [integer] NULL,"
                                         "[createuser] [varchar](50) NULL,"
                                         "[createusername] [varchar](50) NULL,"
                                         "[folderpath] [varchar](500) NULL,"
                                         "[deletedate] [date] NULL,"
                                         "[availabledays] [integer] NULL,"
                                         "[json] [text] NULL,"
                                         "[partitiontype] [integer] NULL,"
                                         "[imageurl] [varchar](50) NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateResRecycleTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
//            case 2:
//                [self AddColumnToTableIfNotExist:@"res_recycle" columnName:@"imageurl" type:@"[varchar](50)"];
//                break;
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加回收站的数据
 */
-(void)addRecycleDataWithArray:(NSMutableArray*)recycleArray {
    
    
    [[self getDbQuene:@"res_recycle" FunctionName:@"addRecycleDataWithArray:(NSMutableArray*)recycleArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i  = 0; i < recycleArray.count; i++) {
            ResRecycleModel *recycleModel = [recycleArray objectAtIndex:i];
            
            NSString *recyid = recycleModel.recyid;
            NSString *rpid = recycleModel.rpid;
            NSString *name = recycleModel.name;
            NSString *exptype = recycleModel.exptype;
            NSNumber *type = [NSNumber numberWithInteger:recycleModel.type];
            NSString *createuser = recycleModel.createuser;
            NSString *createusername = recycleModel.createusername;
            NSString *folderpath = recycleModel.folderpath;
            NSDate *deletedate = recycleModel.deletedate;
            NSString *json = recycleModel.json;
            NSNumber *partitiontype = [NSNumber numberWithInteger:recycleModel.partitiontype];
            NSString *classid = recycleModel.classid;
            NSNumber *availabledays = [NSNumber numberWithInteger:recycleModel.availabledays];
            NSString *imageurl =  recycleModel.imageurl;
            
            NSString *sql = @"INSERT OR REPLACE INTO res_recycle(recyid,rpid,classid,name,exptype,type,createuser,createusername,folderpath,deletedate,availabledays,json,partitiontype,imageurl)" "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,recyid,rpid,classid,name,exptype,type,createuser,createusername,folderpath,deletedate,availabledays,json,partitiontype,imageurl];
            if (!isOK) {
                DDLogError(@"插入失败");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res_recycle" Sql:sql Error:@"插入失败" Other:nil];

                break;
            }
        }
    }];
}



#pragma mark - 删除数据

/**
 *  删除回收站文件
 *
 *  @param recyid 文件id 主键
 */
-(void) deleRecycleFile:(NSString *)recyid {
    
    [[self getDbQuene:@"res_recycle" FunctionName:@"deleRecycleFile:(NSString *)recyid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from res_recycle where recyid=?";
        isOK = [db executeUpdate:sql,recyid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res_recycle" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}
/**
 *  删除回收站文件
 *
 *  @param recyid 文件id 主键
 */
-(void) deleAllRecycleFile:(NSString *)recyid {
    
    [[self getDbQuene:@"res_recycle" FunctionName:@"deleAllRecycleFile:(NSString *)recyid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from res_recycle";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res_recycle" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}

#pragma mark - 修改数据

/**
 *  更新所有下的资源数量
 *  需要改动
 *  @param iscacheall 是否缓存完所有资源
 *  @param classid    文件夹ID
 */
-(void)updateIsCacheAllRecycle:(NSInteger)iscacheall withClassid:(NSString *)classid{
    
	[[self getDbQuene:@"res_recycle" FunctionName:@"updateIsCacheAllRecycle:(NSInteger)iscacheall withClassid:(NSString *)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update res_recycle set iscacheallres=?";
        isOK = [db executeUpdate:sql,[NSNumber numberWithInteger:iscacheall]];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res_recycle" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    
}

    
#pragma mark - 获取数据

/**
 *  获取此文件夹下的资源是否缓存完
 *
 *  @param classid 文件夹ID
 *
 *  @return 资源数量
 */
- (BOOL)checkIsCacheAllDataWithClassid:(NSString *)classid { // 这里要改
    __block NSInteger resCount = 0;
    
    [[self getDbQuene:@"res_recycle" FunctionName:@"checkIsCacheAllDataWithClassid:(NSString *)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select ifnull(iscacheallres,0) count From res_recycle Where classid='%@' Order by deletedate desc",classid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            resCount = [resultSet intForColumn:@"count"];
        }
        [resultSet close];
    }];
    
    return resCount>0 ? YES : NO;
}

/**
 *  获取资源列表 Order by name desc 
 *
 *  @param classid  文件夹ID
 *  @param start    起始条目
  *  @return 资源记录数组
 */
-(NSMutableArray * ) getRecycleDataWithClassid:(NSString *)classid startNum:(NSInteger)start queryCount:(NSInteger)count{
    
        NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"res_recycle" FunctionName:@"getRecycleDataWithClassid:(NSString *)classid startNum:(NSInteger)start queryCount:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From res_recycle "
                       "Order by deletedate desc limit %ld, %ld",start,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];

    
    return result;
    
    
}
/**
 *  获取所有数据
 */
-(NSMutableArray * ) getAllRecycleData{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"res_recycle" FunctionName:@"getAllRecycleData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From res_recycle Order by deletedate desc"];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
          [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    
    return result;
    
    
}
/**
 *  获取数据
 */
-(NSMutableArray * ) getRecycleData:(NSString *)recyid{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"res_recycle" FunctionName:@"getRecycleData:(NSString *)recyid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From res_recycle Where recyid = %@ Order by deletedate desc",recyid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];    
    
    return result;
}

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImChatLogModel
 */
-(ResRecycleModel *)convertResultSetToModel:(FMResultSet *)resultSet {
    NSString *recyid = [resultSet stringForColumn:@"recyid"];
    NSString *rpid = [resultSet stringForColumn:@"rpid"];
    NSString *classid = [resultSet stringForColumn:@"classid"];
    NSString *name = [resultSet stringForColumn:@"name"];
    NSString *exptype = [resultSet stringForColumn:@"exptype"];
    NSInteger type = [resultSet intForColumn: @"type"];
    NSString *createuser = [resultSet stringForColumn:@"createuser"];
    NSString *createusername = [resultSet stringForColumn:@"createusername"];
    NSString *folderpath = [resultSet stringForColumn:@"folderpath"];
    NSDate *deletedate = [resultSet dateForColumn:@"deletedate"];
    NSInteger availabledays = [resultSet intForColumn:@"availabledays"];
    NSString *json = [resultSet stringForColumn:@"json"];
    NSInteger partitiontype = [resultSet intForColumn:@"partitiontype"];
    NSString *imageurl = [resultSet stringForColumn:@"imageurl"];
    
    ResRecycleModel *recycleModel = [[ResRecycleModel alloc] init];
    recycleModel.recyid = recyid;
    recycleModel.classid = classid;
    recycleModel.rpid = rpid;
    recycleModel.name = name;
    recycleModel.exptype = exptype;
    recycleModel.type = type;
    recycleModel.createuser = createuser;
    recycleModel.createusername = createusername;
    recycleModel.folderpath = folderpath;
    recycleModel.deletedate = deletedate;
    recycleModel.json = json;
    recycleModel.partitiontype = partitiontype;
    recycleModel.availabledays = availabledays;
    recycleModel.imageurl = imageurl;

    return recycleModel;
    
}

@end
