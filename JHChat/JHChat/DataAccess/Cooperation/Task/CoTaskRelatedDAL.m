//
//  CoTaskRelatedDAL.m
//  LeadingCloud
//
//  Created by wang on 16/2/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoTaskRelatedDAL.h"

@implementation CoTaskRelatedDAL


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoTaskRelatedDAL *)shareInstance{
    static CoTaskRelatedDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoTaskRelatedDAL alloc] init];
    }
    return instance;
 
}


/**
 *  创建表
 */
-(void)createCoTaskRelatedIfNotExists{
   
    NSString *tableName = @"co_task_related";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[keyId] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[tid] [varchar](50) NULL,"
                                         "[relatedname] [varchar](300) NULL,"
                                         "[relatedid] [varchar](500) NULL,"
                                         "[coopType] [integer] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateCoTaskRelatedTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)relatedArray{
    
    [[self getDbQuene:@"co_task_related" FunctionName:@"addDataWithArray:(NSMutableArray *)relatedArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_task_related(keyId,tid,relatedname,relatedid,coopType)"
		"VALUES (?,?,?,?,?)";
        for (int i = 0; i< relatedArray.count;  i++) {
            CoTaskRelatedModel *rmodel=[relatedArray objectAtIndex:i];
            
            NSString *keyId=rmodel.keyId;
            NSString *tid=rmodel.tid;
            NSString *relatedname=rmodel.relatedname;
            NSString *relatedid=rmodel.relatedid;
            NSNumber *coopType=[NSNumber numberWithInteger:rmodel.coopType];

            isOK = [db executeUpdate:sql,keyId,tid,relatedname,relatedid,coopType];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_related" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];

}

/**
 *  添加单条数据
 */
-(void)addRelated:(CoTaskRelatedModel *)rmodel{
    [[self getDbQuene:@"co_task_related" FunctionName:@"addRelated:(CoTaskRelatedModel *)rmodel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
            NSString *keyId=rmodel.keyId;
            NSString *tid=rmodel.tid;
            NSString *relatedname=rmodel.relatedname;
            NSString *relatedid=rmodel.relatedid;
            NSNumber *coopType=[NSNumber numberWithInteger:rmodel.coopType];
            NSString *sql = @"INSERT OR REPLACE INTO co_task_related(keyId,tid,relatedname,relatedid,coopType)"
            "VALUES (?,?,?,?,?)";
            isOK = [db executeUpdate:sql,keyId,tid,relatedname,relatedid,coopType];
            
            if (!isOK) {
                DDLogError(@"插入失败");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_related" Sql:sql Error:@"插入失败" Other:nil];

            }
       
        if (!isOK) {
            *rollback = YES;
            return;
        }
        
    }];

}

#pragma mark - 删除数据

/**
 *  根据id删除关系数据
 *
 *  @param
 */
-(void)deleteRelatedId:(NSString*)rid{
    
    [[self getDbQuene:@"co_task_related" FunctionName:@"deleteRelatedId:(NSString*)rid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task_related where keyId=?";
        isOK = [db executeUpdate:sql,rid];
        
        if (!isOK) {
            DDLogError(@"更新失败 - updateMsgId");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_related" Sql:sql Error:@"删除失败" Other:nil];

        }
    }];

}

/**
 *  根据任务id，关联id删除关系数据
 *
 *  @param
 */
-(void)deleteRelatedTid:(NSString*)tid Relateid:(NSString*)relateid{
    
    [[self getDbQuene:@"co_task_related" FunctionName:@"deleteRelatedTid:(NSString*)tid Relateid:(NSString*)relateid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task_related where oid=? AND relatedid=?";
        isOK = [db executeUpdate:sql,tid,relateid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_related" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    

}

/**
 *  根据任务id删除关系数据
 *
 *  @param
 */
-(void)deleteAllTaskId:(NSString*)tid{
    
    [[self getDbQuene:@"co_task_related" FunctionName:@"deleteAllTaskId:(NSString*)tid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task_related where tid=?";
        isOK = [db executeUpdate:sql,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_related" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    

}

#pragma mark - 查询数据

-(CoTaskRelatedModel*)getDataTaskRelatedModelRid:(NSString*)rid{
    
    CoTaskRelatedModel *model=[[CoTaskRelatedModel alloc]init];
    
	[[self getDbQuene:@"co_task_related" FunctionName:@"getDataTaskRelatedModelRid:(NSString*)rid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_task_related Where keyId=%@",rid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            NSString *keyId = [resultSet stringForColumn:@"keyId"];
            NSString *tid = [resultSet stringForColumn:@"tid"];
            NSString *relatedname=[resultSet stringForColumn:@"relatedname"];
            NSString *relatedid=[resultSet stringForColumn:@"relatedid"];
            NSInteger coopType=[resultSet intForColumn:@"coopType"];
            
            model.keyId = keyId;
            model.tid=tid;
            model.relatedname=relatedname;
            model.relatedid=relatedid;
            model.coopType=coopType;
        }
        [resultSet close];
    }];
    
    return model;
}

/**
 得到任务关联的工作组
 *  @param tid      任务ID
 */
-(NSMutableArray*)getRelatedWorkGroupTaskId:(NSString*)tid{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"co_task_related" FunctionName:@"getRelatedWorkGroupTaskId:(NSString*)tid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_task_related Where tid=%@ AND coopType=1",tid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            NSString *keyId = [resultSet stringForColumn:@"keyId"];
            NSString *tid = [resultSet stringForColumn:@"tid"];
            NSString *relatedname=[resultSet stringForColumn:@"relatedname"];
            NSString *relatedid=[resultSet stringForColumn:@"relatedid"];
            NSInteger coopType=[resultSet intForColumn:@"coopType"];
            
            CoTaskRelatedModel *model=[[CoTaskRelatedModel alloc]init];
            model.keyId = keyId;
            model.tid=tid;
            model.relatedname=relatedname;
            model.relatedid=relatedid;
            model.coopType=coopType;
            [result addObject:model];
        }
        [resultSet close];
    }];
    
    return result;
    
}

/**
 得到任务关联的项目
 *  @param tid      任务ID
 */
-(NSMutableArray*)getRelatedProjectTaskId:(NSString*)tid{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"co_task_related" FunctionName:@"getRelatedProjectTaskId:(NSString*)tid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_task_related Where tid=%@ AND coopType=2",tid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            NSString *keyId = [resultSet stringForColumn:@"keyId"];
            NSString *tid = [resultSet stringForColumn:@"tid"];
            NSString *relatedname=[resultSet stringForColumn:@"relatedname"];
            NSString *relatedid=[resultSet stringForColumn:@"relatedid"];
            NSInteger coopType=[resultSet intForColumn:@"coopType"];
            
            CoTaskRelatedModel *model=[[CoTaskRelatedModel alloc]init];
            model.keyId = keyId;
            model.tid=tid;
            model.relatedname=relatedname;
            model.relatedid=relatedid;
            model.coopType=coopType;
            [result addObject:model];
        }
        [resultSet close];
    }];
    
    return result;
}
@end
