//
//  CoTaskPhaseDAL.m
//  LeadingCloud
//
//  Created by wang on 16/2/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoTaskPhaseDAL.h"


@implementation CoTaskPhaseDAL


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoTaskPhaseDAL *)shareInstance{
    
    static CoTaskPhaseDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoTaskPhaseDAL alloc] init];
    }
    return instance;
}

/**
 *  创建表
 */
-(void)createCoTaskPhaseIfNotExists{
    
    NSString *tableName = @"co_task_phase";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[phid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[tip] [varchar](50) NULL,"
                                         "[chief] [varchar](500) NULL,"
                                         "[datelimit] [date] NULL,"
                                         "[des] [varchar](500) NULL,"
                                         "[modelid] [varchar](50) NULL,"
                                         "[ruid] [varchar](50) NULL,"
                                         "[tid] [varchar](50) NULL,"
                                         "[state] [integer] NULL,"
                                         "[activecount] [integer] NULL,"
                                         "[type] [integer] NULL,"
                                         "[sort] [integer] NULL);",
                                         tableName]];
        
    }

}
/**
 *  升级数据库
 */
-(void)updateCoTaskPhaseTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)phaseArray{
    
    [[self getDbQuene:@"co_task_phase" FunctionName:@"addDataWithArray:(NSMutableArray *)phaseArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_task_phase(phid,tip,datelimit,chief,des,modelid,ruid,tid,state,sort,activecount,type)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        for (int i = 0; i< phaseArray.count;  i++) {
            CoTaskPhaseModel *pModel = [phaseArray objectAtIndex:i];
            
            NSString *phid = pModel.phid;
            NSString *tip = pModel.tip;
            NSDate *datelimit=pModel.datelimit;
            NSString *chief=pModel.chief;
            NSString *des=pModel.des;
            NSString *modelid=pModel.modelid;
            NSString *ruid=pModel.ruid;
            NSString *tid=pModel.tid;
            
            NSNumber *state=[NSNumber numberWithInteger:pModel.state];
            NSNumber *sort=[NSNumber numberWithInteger:pModel.sort];
            NSNumber *activecount=[NSNumber numberWithInteger:pModel.activecount];
            NSNumber *type=[NSNumber numberWithInteger:pModel.type];
            isOK = [db executeUpdate:sql,phid,tip,datelimit,chief,des,modelid,ruid,tid,state,sort,activecount,type];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
            *rollback = YES;
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_phase" Sql:sql Error:@"插入失败" Other:nil];

            return;
        }
        
    }];
}

/**
 *  添加单条数据
 */
-(void)addPhase:(CoTaskPhaseModel *)pModel{
    
    
    [[self getDbQuene:@"co_task_phase" FunctionName:@"addPhase:(CoTaskPhaseModel *)pModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
                
        NSString *phid = pModel.phid;
        NSString *tip = pModel.tip;
        NSDate *datelimit=pModel.datelimit;
        NSString *chief=pModel.chief;
        NSString *des=pModel.des;
        NSString *modelid=pModel.modelid;
        NSString *ruid=pModel.ruid;
        NSString *tid=pModel.tid;
        
        NSNumber *state=[NSNumber numberWithInteger:pModel.state];
        NSNumber *sort=[NSNumber numberWithInteger:pModel.sort];
        NSNumber *activecount=[NSNumber numberWithInteger:pModel.activecount];
        NSNumber *type=[NSNumber numberWithInteger:pModel.type];
        
        NSString *sql = @"INSERT OR REPLACE INTO co_task_phase(phid,tip,datelimit,chief,des,modelid,ruid,tid,state,sort,activecount,type)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,phid,tip,datelimit,chief,des,modelid,ruid,tid,state,sort,activecount,type];

        if (!isOK) {
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_phase" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];

}

#pragma mark - 删除数据

-(void)deletePhaseId:(NSString*)pid{
    
    [[self getDbQuene:@"co_task_phase" FunctionName:@"deletePhaseId:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task_phase where phid=?";
        isOK = [db executeUpdate:sql,pid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_phase" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

/**
 *  根据任务id删除所有检查点
 *
 *  @param
 */
-(void)deleteAllPhaseTaskId:(NSString*)tid{
    
    [[self getDbQuene:@"co_task_phase" FunctionName:@"deleteAllPhaseTaskId:(NSString*)tid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task_phase where tid=?";
        isOK = [db executeUpdate:sql,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_phase" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    

}



/**
 修改节点状态
 *  @param tid              任务ID
 *  @param phid             节点ID
 *  @param state            状态字段
 *  @param activecount      状态字段
 
 */
-(void)upDataTaskPhaseState:(NSInteger)state Activecount:(NSInteger)activecount TaskID:(NSString*)tid Phid:(NSString*)phid{
    
    NSNumber *stat=[NSNumber numberWithInteger:state];
    NSNumber *activecoun=[NSNumber numberWithInteger:activecount];

    [[self getDbQuene:@"co_task_phase" FunctionName:@"upDataTaskPhaseState:(NSInteger)state Activecount:(NSInteger)activecount TaskID:(NSString*)tid Phid:(NSString*)phid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task_phase set state=?,activecount=? Where tid=? AND phid=?";
        isOK = [db executeUpdate:sql,stat,activecoun,tid,phid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_phase" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

}

/**
 修改节点描述（name）
 *  @param tid              任务ID
 *  @param phid             节点ID
 *  @param des              状态描述
 
 */
-(void)upDataTaskPhaseDes:(NSString*)des TaskID:(NSString*)tid Phid:(NSString*)phid{
    
    
    [[self getDbQuene:@"co_task_phase" FunctionName:@"upDataTaskPhaseDes:(NSString*)des TaskID:(NSString*)tid Phid:(NSString*)phid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task_phase set des=? Where tid=? AND phid=?";
        isOK = [db executeUpdate:sql,des,tid,phid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_phase" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

}

/**
 修改节点提示（des 内容）
 *  @param tid              任务ID
 *  @param phid             节点ID
 *  @param des              状态提示
 
 */
-(void)upDataTaskPhaseTip:(NSString*)tip TaskID:(NSString*)tid Phid:(NSString*)phid{
    
    
    [[self getDbQuene:@"co_task_phase" FunctionName:@"upDataTaskPhaseTip:(NSString*)tip TaskID:(NSString*)tid Phid:(NSString*)phid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task_phase set tip=? Where tid=? AND phid=?";
        isOK = [db executeUpdate:sql,tip,tid,phid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_phase" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

}

/**
 修改节时间（时间）
 *  @param tid              任务ID
 *  @param phid             节点ID
 *  @param datelimit        节点时间
 
 */
-(void)upDataTaskPhaseDatelimit:(NSDate*)datelimit TaskID:(NSString*)tid Phid:(NSString*)phid{
    
    [[self getDbQuene:@"co_task_phase" FunctionName:@"upDataTaskPhaseDatelimit:(NSDate*)datelimit TaskID:(NSString*)tid Phid:(NSString*)phid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task_phase set datelimit=? Where tid=? AND phid=?";
        isOK = [db executeUpdate:sql,datelimit,tid,phid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_phase" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

}

/**
 修改节点管理员
 *  @param tid              任务ID
 *  @param phid             节点ID
 *  @param datelimit        管理员ID
 
 */
-(void)upDataTaskPhaseChief:(NSString*)chief TaskID:(NSString*)tid Phid:(NSString*)phid{
    
    [[self getDbQuene:@"co_task_phase" FunctionName:@"upDataTaskPhaseChief:(NSString*)chief TaskID:(NSString*)tid Phid:(NSString*)phid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task_phase set chief=? Where tid=? AND phid=?";
        isOK = [db executeUpdate:sql,chief,tid,phid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_phase" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

}


#pragma mark - 查询数据

-(CoTaskPhaseModel*)getDataTaskPhaseModelPid:(NSString*)pid{
    
    
   __block CoTaskPhaseModel *model=[[CoTaskPhaseModel alloc]init];
    
    [[self getDbQuene:@"co_task_phase" FunctionName:@"getDataTaskPhaseModelPid:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select (Select face From co_member Where cuid=a.chief  AND tid=a.tid limit 1)face,* From co_task_phase  a where pid=%@ ORDER BY sort",pid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            model=[self getModelFromFM:resultSet];
            
        }
        [resultSet close];
    }];
    
    return model;
}

/**
 我负责的任务
 *  @param tid      任务ID
 */
-(NSMutableArray*)getphaseTaskId:(NSString*)tid{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"co_task_phase" FunctionName:@"getphaseTaskId:(NSString*)tid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select (Select face From co_member Where uid=a.chief  AND tid=%@ limit 1)face,* From co_task_phase  a where tid=%@ ORDER BY sort",tid,tid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {

            CoTaskPhaseModel *model = nil; //[[CoTaskPhaseModel alloc]init];
            model=[self getModelFromFM:resultSet];
            [result addObject:model];
        }
        [resultSet close];
    }];
    
    return result;
}

#pragma mark 内部
// 数据库转模型
-(CoTaskPhaseModel*)getModelFromFM:(FMResultSet*)resultSet{
    
    NSString *face=[resultSet stringForColumn:@"face"];
    NSString *phid = [resultSet stringForColumn:@"phid"];
    NSString *tip = [resultSet stringForColumn:@"tip"];
    NSDate *datelimit=[resultSet dateForColumn:@"datelimit"];
    NSString *chief=[resultSet stringForColumn:@"chief"];
    NSString *des=[resultSet stringForColumn:@"des"];
    NSString *modelid=[resultSet stringForColumn:@"modelid"];
    NSString *ruid=[resultSet stringForColumn:@"ruid"];
    NSString *tid=[resultSet stringForColumn:@"tid"];
    
    NSInteger state=[resultSet intForColumn:@"state"];
    NSInteger sort=[resultSet intForColumn:@"sort"];
    NSInteger activecount=[resultSet intForColumn:@"activecount"];
    NSInteger type=[resultSet intForColumn:@"type"];
    
    CoTaskPhaseModel *model=[[CoTaskPhaseModel alloc]init];
    model.phid = phid;
    model.tip=tip;
    model.datelimit=datelimit;
    model.chief=chief;
    model.des=des;
    model.modelid=modelid;
    model.ruid=ruid;
    model.tid=tid;
    model.state=state;
    model.sort=sort;
    model.activecount=activecount;
    model.type=type;
    model.face=face;
    return model;
}
@end
