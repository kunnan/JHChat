//
//  CooOfNewMemberDAL.m
//  LeadingCloud
//
//  Created by SY on 16/6/8.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooOfNewMemberDAL.h"
#import "CooNewMemberApplyModel.h"
@implementation CooOfNewMemberDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooOfNewMemberDAL *)shareInstance{
    static CooOfNewMemberDAL *instance = nil;
    
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CooOfNewMemberDAL alloc] init];
    }
    return instance;
}
#pragma mark - 表结构操作
/**
 *  创建表
 */
-(void)createCooOfNewMemberTableIfNotExists
{
    NSString *tableName = @"co_newmember";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[keyid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[cid] [varchar](50)  NULL,"
                                         "[applyface] [varchar](100) NULL,"
                                         "[cooperationtype] [integer] NULL,"
                                         "[applyname] [varchar](200) NULL,"
                                         "[cname] [varchar](100) NULL,"
                                         "[applyid] [varchar](50) NULL,"
                                         "[departname] [varchar](100) NULL,"
                                         "[orgname] [varchar](50) NULL,"
                                         "[applytime] [date] NULL,"
                                         "[state] [integer] NULL);",
                                         tableName]];
    }
}
/**
 *  升级数据库
 */
-(void)updateCooOfNewMemberTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
          
            case 4: {
                [self AddColumnToTableIfNotExist:@"co_newmember" columnName:@"[cmalid]" type:@"[varchar](50)"];
                [self AddColumnToTableIfNotExist:@"co_newmember" columnName:@"[result]" type:@"[integer]"];
                break;
            }
            case 16: {
                 [self AddColumnToTableIfNotExist:@"co_newmember" columnName:@"[actionresult]" type:@"[integer]"];
                break;
            }
        }
    }
}
#pragma mark - 添加数据
-(void)addCooMember:(NSMutableArray*)applyModelArray{
	[[self getDbQuene:@"co_newmember" FunctionName:@"addCooMember:(NSMutableArray*)applyModelArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_newmember(keyid,cid,applyface,cooperationtype,applyname,cname,applyid,departname,orgname,applytime,state,cmalid,result,actionresult)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< applyModelArray.count;  i++) {
            CooNewMemberApplyModel *applyModel=[applyModelArray objectAtIndex:i];
            NSString *keyid = applyModel.keyid;
            NSString *cid = applyModel.cid;
            NSString *applyface = applyModel.applyface;
            NSNumber *cooperationtype = [NSNumber numberWithInteger:applyModel.cooperationtype];
            NSString *applyname = applyModel.applyname;
            NSString *cname = applyModel.cname;
            NSString *applyid = applyModel.applyid;
            NSString *departname = applyModel.departname;
            NSString *orgname = applyModel.orgname;
            NSDate *applytime = applyModel.applytime;
            NSNumber *state = [NSNumber numberWithInteger:applyModel.state];
            NSString *cmalid = applyModel.cmalid;
            NSNumber *result = [NSNumber numberWithInteger:applyModel.result];
            NSNumber *actionresult = [NSNumber numberWithInteger:applyModel.actionresult];
			
            isOK = [db executeUpdate:sql,keyid,cid,applyface,cooperationtype,applyname,cname,applyid,departname,orgname,applytime,state,cmalid,result,actionresult];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
            *rollback = YES;
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newmember" Sql:sql Error:@"更新失败" Other:nil];

            return;
        }
    }];
}
#pragma mark - 删除数据
-(void)deleteAllDataWithState:(NSString*)state {
    
    [[self getDbQuene:@"co_newmember" FunctionName:@"deleteAllDataWithState:(NSString*)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_newmember Where state =?";
        isOK = [db executeUpdate:sql,state];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newmember" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}
-(void)deleteDidHandleSourceWithCid:(NSString*)cid applyid:(NSString*)applyid {
    [[self getDbQuene:@"co_newmember" FunctionName:@"deleteDidHandleSourceWithCid:(NSString*)cid applyid:(NSString*)applyid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_newmember Where cid =? AND applyid = ?";
        isOK = [db executeUpdate:sql,cid,applyid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newmember" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}
-(void)deleteApplySourceWithCid:(NSString*)cid {
    [[self getDbQuene:@"co_newmember" FunctionName:@"deleteApplySourceWithCid:(NSString*)cid "] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_newmember Where cid =? ";
        isOK = [db executeUpdate:sql,cid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newmember" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}
-(void)deleteApplyLogSourceWithCmalid:(NSString*)cmalid {
    [[self getDbQuene:@"co_newmember" FunctionName:@"deleteApplyLogSourceWithCmalid:(NSString*)cmalid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_newmember Where cmalid =? ";
        isOK = [db executeUpdate:sql,cmalid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newmember" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}
#pragma mark - 修改数据
-(void)updataNewApplyWithUid:(NSString*)uid cid:(NSString*)cid  state:(NSInteger)state{
    [[self getDbQuene:@"co_newmember" FunctionName:@"updataNewApplyWithUid:(NSString*)uid cid:(NSString*)cid  state:(NSInteger)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSNumber *stateC = [NSNumber numberWithInteger:state];
        
        NSString *sql = @"Update co_newmember set state=?  Where applyid =? AND cid = ?";
        isOK = [db executeUpdate:sql,stateC,uid,cid];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newmember" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];

}
-(void)updataNewApplyActionResultWithKeyid:(NSString*)keyid  actionresult:(NSInteger)action{
    [[self getDbQuene:@"co_newmember" FunctionName:@"updataNewApplyActionResultWithKeyid:(NSString*)keyid  actionresult:(NSInteger)action"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSNumber *stateC = [NSNumber numberWithInteger:action];
        
        NSString *sql = @"Update co_newmember set actionresult=?  Where keyid = ?";
        isOK = [db executeUpdate:sql,stateC,keyid];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newmember" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    
}
#pragma mark - 查询数据
-(NSMutableArray*)selectLogDataWithState:(NSInteger)state startNum:(NSInteger)start queryCount:(NSInteger)count {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"co_newmember" FunctionName:@"selectLogDataWithState:(NSInteger)state startNum:(NSInteger)start queryCount:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_newmember Where state = %ld Order by applytime desc limit %ld,%ld",state,start,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultTypeSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;

}
-(NSMutableArray*)selectAllDataWithState:(NSInteger)state {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
	[[self getDbQuene:@"co_newmember" FunctionName:@"selectAllDataWithState:(NSInteger)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_newmember Where state = %ld ",(long)state];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultTypeSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
    
}
-(CooNewMemberApplyModel*)selectApplyModelWithApplyId:(NSString*)applyid cid:(NSString*)cid {
    
    __block CooNewMemberApplyModel *cnApplyModel = nil;
    [[self getDbQuene:@"co_newmember" FunctionName:@"selectApplyModelWithApplyId:(NSString*)applyid cid:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_newmember Where applyid = %@ AND cid = %@ ",applyid,cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            
            cnApplyModel = [self convertResultTypeSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return cnApplyModel;
    
}
-(CooNewMemberApplyModel*)selectApplyModelWithKeyid:(NSString*)keyid{
    
    __block CooNewMemberApplyModel *cnApplyModel = nil;
    [[self getDbQuene:@"co_newmember" FunctionName:@"selectApplyModelWithKeyid:(NSString*)keyid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_newmember Where keyid = %@ ",keyid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            
            cnApplyModel = [self convertResultTypeSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return cnApplyModel;
    
}
// 查询用
-(CooNewMemberApplyModel*)convertResultTypeSetToModel:(FMResultSet*)resultSet {
    
    NSString *keyid = [resultSet stringForColumn:@"keyid"];
    NSString *cid = [resultSet stringForColumn:@"cid"];
    NSString *applyface = [resultSet stringForColumn:@"applyface"];
    NSInteger cooperationtype = [resultSet intForColumn:@"cooperationtype"];
    NSString *applyname = [resultSet stringForColumn:@"applyname"];
    NSString *cname = [resultSet stringForColumn:@"cname"];
    NSString *applyid = [resultSet stringForColumn:@"applyid"];
    NSString *departname = [resultSet stringForColumn:@"departname"];
    NSString *orgname = [resultSet stringForColumn:@"orgname"];
    NSDate *applytime =[resultSet dateForColumn:@"applytime"];
    NSInteger state = [resultSet intForColumn:@"state"];
    NSString *cmalid = [resultSet stringForColumn:@"cmalid"];

    NSInteger actionresult = [resultSet intForColumn:@"actionresult"];
    
    CooNewMemberApplyModel *applyModel= [[CooNewMemberApplyModel alloc] init];
    
    applyModel.keyid = keyid;
    applyModel.cid = cid;
    applyModel.applyface = applyface;
    applyModel.cooperationtype = cooperationtype;
    applyModel.applyname = applyname;
    applyModel.cname = cname;
    applyModel.applyid = applyid;
    applyModel.departname = departname;
    applyModel.orgname = orgname;
    applyModel.applytime = applytime;
    applyModel.state = state;
    applyModel.cmalid = cmalid;
    applyModel.actionresult = actionresult;
    return applyModel;
    
    
}
@end
