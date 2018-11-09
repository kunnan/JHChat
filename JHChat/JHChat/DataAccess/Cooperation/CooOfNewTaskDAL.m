//
//  CooOfNewTaskDAL.m
//  LeadingCloud
//
//  Created by SY on 16/3/24.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-03-24
 Version: 1.0
 Description: 新的协作
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "CooOfNewTaskDAL.h"
#import "CooOfNewModel.h"

@implementation CooOfNewTaskDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooOfNewTaskDAL *)shareInstance{
    static CooOfNewTaskDAL *instance = nil;
    
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CooOfNewTaskDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createCooOfNewTaskTableIfNotExists
{
    NSString *tableName = @"co_newcooperation";
    
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
                                         "[cooperationname] [varchar](100) NULL,"
                                         "[cooperationtype] [integer] NULL,"
                                         "[invitedemail] [varchar](200) NULL,"
                                         "[invitedface] [varchar](50) NULL,"
                                         "[invitedid] [varchar](50) NULL,"
                                         "[invitedname] [varchar](100) NULL,"
                                         "[invitedphone] [varchar](100) NULL,"
                                         "[inviteface] [varchar](50) NULL,"
                                         "[inviteid] [varchar](50) NULL,"
                                         "[invitename] [varchar](100) NULL,"
                                         "[invitetime] [date] NULL,"
                                         "[invitetype] [integer] NULL,"
                                         "[isvalid] [integer] NULL,"
                                         "[state] [integer] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateCooOfNewTaskTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
               case 4:
             {
                [self AddColumnToTableIfNotExist:@"co_newcooperation" columnName:@"[isagree]" type:@"[integer]"];
                break;
            }
                case 16:
            {
                [self AddColumnToTableIfNotExist:@"co_newcooperation" columnName:@"[actionresult]" type:@"[integer]"];
                [self AddColumnToTableIfNotExist:@"co_newcooperation" columnName:@"[deptname]" type:@"[varchar](100)"];
                [self AddColumnToTableIfNotExist:@"co_newcooperation" columnName:@"[did]" type:@"[varchar](50)"];
                [self AddColumnToTableIfNotExist:@"co_newcooperation" columnName:@"[oid]" type:@"[varchar](50)"];
                [self AddColumnToTableIfNotExist:@"co_newcooperation" columnName:@"[orgname]" type:@"[varchar](100)"];
                break;
            }
        }
    }
}
#pragma mark - 添加数据

-(void)addNewCooDataWithArray:(NSMutableArray *)newCooArray{
    
    [[self getDbQuene:@"co_newcooperation" FunctionName:@"addNewCooDataWithArray:(NSMutableArray *)newCooArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		
		NSString *sql = @"INSERT OR REPLACE INTO co_newcooperation(keyid,cid,cooperationname,cooperationtype,invitedemail,invitedface,invitedid,invitedname,invitedphone,inviteface,inviteid,invitename,invitetime,invitetype,isvalid,state,isagree,actionresult,deptname,did,oid,orgname)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< newCooArray.count;  i++) {
            CooOfNewModel *newModel=[newCooArray objectAtIndex:i];
            
            NSString *keyid = newModel.keyid;
            NSString *cid = newModel.cid;
            NSString *cooperationname = newModel.cooperationname;
            NSNumber *cooperationtype = [NSNumber numberWithInteger:newModel.cooperationtype];
            NSString *invitedemail = newModel.invitedemail;
            NSString *invitedface = newModel.invitedface;
            NSString *invitedid = newModel.invitedid;
            NSString *invitedname = newModel.invitedname;
            NSString *invitedphone = newModel.invitedphone;
            NSString *inviteface = newModel.inviteface;
            NSString *inviteid = newModel.inviteid;
            NSString *invitename = newModel.invitename;
            NSDate *invitetime = newModel.invitetime;
            NSNumber *invitetype = [NSNumber numberWithInteger:newModel.invitetype];
            NSNumber *isvalid = [NSNumber numberWithInteger:newModel.isvalid];
            NSNumber *state = [NSNumber numberWithInteger:newModel.state];
            NSNumber *isagree = [NSNumber numberWithInteger:newModel.isagree];
          
            NSNumber *actionresult = [NSNumber numberWithInteger:newModel.actionresult];
            NSString *deptname = newModel.deptname;
            NSString *did = newModel.did;
            NSString *oid = newModel.oid;
            NSString *orgname = newModel.orgname;
		
            isOK = [db executeUpdate:sql,keyid,cid,cooperationname,cooperationtype,invitedemail,invitedface,invitedid,invitedname,invitedphone,inviteface,inviteid,invitename,invitetime,invitetype,isvalid,state,isagree,actionresult,deptname,did,oid,orgname];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newcooperation" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}
#pragma mark - 删除数据
/**
 *  删除
 *
 *  @param cid 处理状态
 */
-(void)deleteCooOfNewDataWithState:(NSString*)state {
    
	[[self getDbQuene:@"co_newcooperation" FunctionName:@"deleteCooOfNewDataWithState:(NSString*)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_newcooperation Where state = ?";
        isOK = [db executeUpdate:sql,state];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newcooperation" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}
/**
 *  同意或拒绝成功之后从本地移除
 *
 *  @param 新的协作的主键id
 */
-(void)deleteHandleCooOfNewDataWithKeyId:(NSString*)kid {
    
    [[self getDbQuene:@"co_newcooperation" FunctionName:@"deleteHandleCooOfNewDataWithKeyId:(NSString*)kid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_newcooperation Where keyid = ?";
        isOK = [db executeUpdate:sql,kid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newcooperation" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}
/**
 *  删除协作邀请
 *
 *  @param 新的协作的主键id
 */
-(void)deleteCooOfNewDataWithcid:(NSString*)cid {
    
    [[self getDbQuene:@"co_newcooperation" FunctionName:@"deleteCooOfNewDataWithcid:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_newcooperation Where cid = ?";
        isOK = [db executeUpdate:sql,cid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newcooperation" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}
#pragma mark - 修改数据
-(void)updataNewCooWithKeyId:(NSString*)keyid state:(NSInteger)state {
    
    [[self getDbQuene:@"co_newcooperation" FunctionName:@"updataNewCooWithKeyId:(NSString*)keyid state:(NSInteger)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSNumber *stateC = [NSNumber numberWithInteger:state];
        
        NSString *sql = @"Update co_newcooperation set state=?  Where keyid=?";
        isOK = [db executeUpdate:sql,stateC,keyid];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newcooperation" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}
-(void)updataNewCooWithKeyId:(NSString*)keyid actionResult:(NSInteger)actionResult {
    
    [[self getDbQuene:@"co_newcooperation" FunctionName:@"updataNewCooWithKeyId:(NSString*)keyid actionResult:(NSInteger)actionResult"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSNumber *action = [NSNumber numberWithInteger:actionResult];
        
        NSString *sql = @"Update co_newcooperation set actionresult=?  Where keyid=?";
        isOK = [db executeUpdate:sql,action,keyid];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_newcooperation" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}
#pragma mark - 查询数据

-(NSMutableArray *)getAllInvite:(NSString*)keyid withState:(NSInteger)state{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"co_newcooperation" FunctionName:@"getAllInvite:(NSString*)keyid withState:(NSInteger)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_newcooperation Where state = %ld",state];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultTypeSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}

-(NSMutableArray *)getAllInvite:(NSString*)keyid withState:(NSInteger)state startNum:(NSInteger)start queryCount:(NSInteger)count{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"co_newcooperation" FunctionName:@"getAllInvite:(NSString*)keyid withState:(NSInteger)state startNum:(NSInteger)start queryCount:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_newcooperation Where state = %ld Order by invitetime desc limit %ld,%ld",state,start,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultTypeSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 获取特定的协作

 @param keyid 主键id

 @return CooOfNewModel
 */
-(CooOfNewModel *)getAllInvite:(NSString*)keyid{
    
    __block CooOfNewModel *cnModle = nil;
    [[self getDbQuene:@"co_newcooperation" FunctionName:@"-(CooOfNewModel *)getAllInvite:(NSString*)keyid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_newcooperation Where keyid = %@",keyid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            
           cnModle = [self convertResultTypeSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return cnModle;
}
/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return FavoriteTypeModel
 */
-(CooOfNewModel *)convertResultTypeSetToModel:(FMResultSet *)resultSet{
    
    NSString *keyid = [resultSet stringForColumn:@"keyid"];
    NSString *cid = [resultSet stringForColumn:@"cid"];
    NSString *cooperationname = [resultSet stringForColumn:@"cooperationname"];
    NSInteger cooperationtype = [resultSet intForColumn:@"cooperationtype"];
    NSString *invitedemail = [resultSet stringForColumn:@"invitedemail"];
    NSString *invitedface = [resultSet stringForColumn:@"invitedface"];
    NSString *invitedid = [resultSet stringForColumn:@"invitedid"];
    NSString *invitedname = [resultSet stringForColumn:@"invitedname"];
    NSString *invitedphone = [resultSet stringForColumn:@"invitedphone"];
    NSString *inviteface = [resultSet stringForColumn:@"inviteface"];
    NSString *inviteid = [resultSet stringForColumn:@"inviteid"];
    NSString *invitename = [resultSet stringForColumn:@"invitename"];
    NSDate *invitetime = [resultSet dateForColumn:@"invitetime"];
    NSInteger invitetype = [resultSet intForColumn:@"invitetype"];
    NSInteger isvalid = [resultSet intForColumn:@"isvalid"];
    NSInteger state = [resultSet intForColumn:@"state"];
    NSInteger isagree = [resultSet intForColumn:@"isagree"];
    
    NSInteger  actionresult = [resultSet intForColumn:@"actionresult"];
    NSString *deptname = [resultSet stringForColumn:@"deptname"];
    NSString *did = [resultSet stringForColumn:@"did"];
    NSString *oid =[resultSet stringForColumn:@"oid"];
    NSString *orgname = [resultSet stringForColumn:@"orgname"];
    
    CooOfNewModel *newcooModle = [[CooOfNewModel alloc] init];
    newcooModle.keyid = keyid;
    newcooModle.cid = cid;
    newcooModle.cooperationname = cooperationname;
    newcooModle.cooperationtype = cooperationtype;
    newcooModle.invitedemail = invitedemail;
    newcooModle.invitedface = invitedface;
    newcooModle.invitedphone = invitedphone;
    newcooModle.invitedid = invitedid;
    newcooModle.invitedname = invitedname;
    newcooModle.inviteface = inviteface;
    newcooModle.inviteid = inviteid;
    newcooModle.invitename = invitename;
    newcooModle.invitetime = invitetime;
    newcooModle.invitetype = invitetype;
    newcooModle.isvalid = isvalid;
    newcooModle.state = state;
    newcooModle.isagree = isagree;
    
    newcooModle.actionresult = actionresult;
    newcooModle.deptname = deptname;
    newcooModle.did = did;
    newcooModle.oid = oid;
    newcooModle.orgname = orgname;
    
    return newcooModle;
}

@end
