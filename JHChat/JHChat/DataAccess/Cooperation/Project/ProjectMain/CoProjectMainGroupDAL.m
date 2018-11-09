//
//  CoProjectMainGroupDAL.m
//  LeadingCloud
//
//  Created by SY on 16/10/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   16/10/17
 Version: 1.0
 Description: 项目分组
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "CoProjectMainGroupDAL.h"
#import "CoProjectGroupModel.h"
@implementation CoProjectMainGroupDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoProjectMainGroupDAL *)shareInstance {
    static CoProjectMainGroupDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoProjectMainGroupDAL alloc] init];
    }
    return instance;
}
#pragma mark - 表结构操作
-(void)creatProjectMainGroupTableIfNotExists {
    
    NSString *tableName = @"co_projectmain_customgroup";
    
    /* 判断是否创建了此表 */
    if (![super checkIsExistsTable:tableName]) {
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:@"Create Table If Not Exists %@("
                                                                    "[pgid] [varchar](150) PRIMARY KEY NOT NULL,"
                                                                    "[uid] [varchar](100) NULL,"
                                                                    "[name] [varchar](100) NULL,"
                                                                    "[sort] [integer] NULL,"
                                                                    "[istop] [integer] NULL,"
                                                                    "[orgid] [varchar](100) NULL,"
                                                                    "[sortable] [integer] NULL,"
                                                                    "[state] [integer] NULL,"
                                                                    "[prcount] [integer] NULL);",
                                                                    tableName]];
    }
}

/**
 *  升级数据库
 */
-(void)updataCoProjectMainGroupTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    
    for (int i = currentDbVersion; i<=systemDbVersion; i++) {
        switch (i) {
//            case 10:{
//                
//                [self AddColumnToTableIfNotExist:@"co_projectmain_customgroup" columnName:@"[prcount]" type:@"[integer]"];
//            }
        }
    }
}
#pragma mark 添加数据

/**
 批量添加项目分组

 @param array array
 */
-(void)addProjectMainWithArray:(NSMutableArray*)array {
    [[self getDbQuene:@"co_projectmain_customgroup" FunctionName:@"addProjectMainWithArray:(NSMutableArray*)array"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		
		NSString *sql = @"INSERT OR REPLACE INTO co_projectmain_customgroup(pgid,uid,name,sort,istop,orgid,sortable,state,prcount)"
		"VALUES (?,?,?,?,?,?,?,?,?)";
		
        for (CoProjectGroupModel *pgModel in array) {
            NSString *pgid = pgModel.pgid;
            NSString *uid = pgModel.uid;
            NSString *name = pgModel.name;
            NSNumber *sort = [NSNumber numberWithInteger:pgModel.sort];
            NSNumber *istop = [NSNumber numberWithInteger:pgModel.istop];
            NSNumber *sortable = [NSNumber numberWithInteger:pgModel.sortable];
            NSString *orgid = pgModel.orgid;
            NSNumber *state = [NSNumber numberWithInteger:pgModel.state];
            NSNumber *prcount = [NSNumber numberWithInteger:pgModel.prcount];
		
            isOK = [db executeUpdate:sql,pgid,uid,name,sort,istop,orgid,sortable,state,prcount];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
            *rollback = YES;
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectmain_customgroup" Sql:sql Error:@"插入失败" Other:nil];

            return ;
        }
    }];
}

/**
 添加单个分组

 @param pgModel 分组model
 */
-(void)addProjectGroupWithModel:(CoProjectGroupModel*)pgModel {
	[[self getDbQuene:@"co_projectmain_customgroup" FunctionName:@"addProjectGroupWithModel:(CoProjectGroupModel*)pgModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
            NSString *pgid = pgModel.pgid;
            NSString *uid = pgModel.uid;
            NSString *name = pgModel.name;
            NSNumber *sort = [NSNumber numberWithInteger:pgModel.sort];
            NSNumber *istop = [NSNumber numberWithInteger:pgModel.istop];
            NSNumber *sortable = [NSNumber numberWithInteger:pgModel.sortable];
            NSString *orgid = pgModel.orgid;
            NSNumber *state = [NSNumber numberWithInteger:pgModel.state];
            NSNumber *prcount = [NSNumber numberWithInteger:pgModel.prcount];
            
            NSString *sql = @"INSERT OR REPLACE INTO co_projectmain_customgroup(pgid,uid,name,sort,istop,orgid,sortable,state,prcount)"
            "VALUES (?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,pgid,uid,name,sort,istop,orgid,sortable,state,prcount];
            
            if (!isOK) {
                DDLogError(@"插入失败");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectmain_customgroup" Sql:sql Error:@"插入失败" Other:nil];

            }
        if (!isOK) {
            *rollback = YES;
            return ;
        }
    }];
    
    
}
#pragma mark 删除数据

/**
 删除某条分组

 @param pgid 分组主键id
 */
-(void)deleteCustomGroupWithPgid:(NSString*)pgid {
    
    [[self getDbQuene:@"co_projectmain_customgroup" FunctionName:@"deleteCustomGroupWithPgid:(NSString*)pgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_projectmain_customgroup where pgid=?";
        isOK = [db executeUpdate:sql,pgid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectmain_customgroup" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];

}

/**
 删除某个组织下的所有分组

 @param uid   当前用户id
 @param orgid 当前企业id
 @param state 项目状态
 */
-(void)deleteAllGroupWithUid:(NSString*)uid orgid:(NSString*)orgid state:(NSInteger)state {
    [[self getDbQuene:@"co_projectmain_customgroup" FunctionName:@"deleteAllGroupWithUid:(NSString*)uid orgid:(NSString*)orgid state:(NSInteger)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *state2 = [NSString stringWithFormat:@"%ld",state];
        NSString *sql = @"delete from co_projectmain_customgroup where uid=? AND orgid = ? AND state = ?";
        isOK = [db executeUpdate:sql,uid,orgid,state2];
        
        if (!isOK) {
            DDLogError(@"删除失败 - updateMsgId");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectmain_customgroup" Sql:sql Error:@"删除失败" Other:nil];

        }
    }];

    
}
#pragma mark 修改数据

/**
 分组重命名

 @param newName 新名字
 @param pgid    主键id
 */
-(void)updateGroupNameWithNewName:(NSString*)newName pgid:(NSString*)pgid {
    [[self getDbQuene:@"co_projectmain_customgroup" FunctionName:@"updateGroupNameWithNewName:(NSString*)newName pgid:(NSString*)pgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *sql = @"Update co_projectmain_customgroup set name = ? Where pgid = ?";
        isOK = [db executeUpdate:sql,newName,pgid];
        if (!isOK) {
            DDLogError(@"修改失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectmain_customgroup" Sql:sql Error:@"更新失败" Other:nil];

        }
       
    }];
}

/**
 更新排序下标

 @param pgid    组件id
 @param newSort 新的排序下标
 */
-(void)updateGroupSortWithPgid:(NSString*)pgid sort:(NSInteger)newSort {
    [[self getDbQuene:@"co_projectmain_customgroup" FunctionName:@"updateGroupSortWithPgid:(NSString*)pgid sort:(NSInteger)newSort"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *sort = [NSString stringWithFormat:@"%ld",newSort];
        
        NSString *sql = @"Update co_projectmain_customgroup set sort = ? Where pgid = ?";
        isOK = [db executeUpdate:sql,sort,pgid];
        if (!isOK) {
            DDLogError(@"修改失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectmain_customgroup" Sql:sql Error:@"更新失败" Other:nil];

        }
        
    }];

}

/**
 更新分组下的项目数量

 @param prcount 项目数量
 @param pgid    分组id
 */
-(void)updateGroupPrcountWithPrcount:(NSString*)prcount pgid:(NSString*)pgid {
    [[self getDbQuene:@"co_projectmain_customgroup" FunctionName:@"updateGroupPrcountWithPrcount:(NSString*)prcount pgid:(NSString*)pgid "] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *sql = @"Update co_projectmain_customgroup set prcount = ? Where pgid = ?";
        isOK = [db executeUpdate:sql,prcount,pgid];
        if (!isOK) {
            DDLogError(@"修改失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectmain_customgroup" Sql:sql Error:@"更新失败" Other:nil];

        }
        
    }];
}
#pragma mark 查询数据

/**
   查询当前分组

 @param uid   当前用户id
 @param orgid 当前组织id
 @param state 当前状态

 @return 分组数组
 */
-(NSMutableArray*)getCustomGroupWithUid:(NSString*)uid orgid:(NSString*)orgid state:(NSInteger)state {
    NSMutableArray *result = [[NSMutableArray alloc] init];
	[[self getDbQuene:@"co_projectmain_customgroup" FunctionName:@"getCustomGroupWithUid:(NSString*)uid orgid:(NSString*)orgid state:(NSInteger)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sql = [NSString stringWithFormat:@"Select * From co_projectmain_customgroup Where uid = '%@' and orgid = '%@' and state = '%ld' Order by sort asc",uid,orgid,state];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    return result;
    
}

/**
 查询单个分组Model

 @param pgid 分组主键id

 @return 分组model
 */
-(CoProjectGroupModel*)getGroupModelWithPgid:(NSString*)pgid {
    
    __block CoProjectGroupModel *pgModel = nil;
    [[self getDbQuene:@"co_projectmain_customgroup" FunctionName:@"getGroupModelWithPgid:(NSString*)pgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sql = [NSString stringWithFormat:@"Select * From co_projectmain_customgroup Where pgid = '%@'",pgid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            pgModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    return pgModel;
    
}

#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImChatLogModel
 */
-(CoProjectGroupModel *)convertResultSetToModel:(FMResultSet *)resultSet {
    
    CoProjectGroupModel *pgModel = [[CoProjectGroupModel alloc] init];
    pgModel.pgid = [resultSet stringForColumn:@"pgid"];
    pgModel.uid = [resultSet stringForColumn:@"uid"];
    pgModel.name = [resultSet stringForColumn:@"name"];
    pgModel.sort = [resultSet intForColumn:@"sort"];
    pgModel.istop  = [resultSet intForColumn:@"istop"];
    pgModel.orgid = [resultSet stringForColumn:@"orgid"];
    pgModel.sortable = [resultSet intForColumn:@"sortable"];
    pgModel.state = [resultSet intForColumn:@"state"];
    pgModel.prcount = [resultSet intForColumn:@"prcount"];
    
    return pgModel;
}
@end
