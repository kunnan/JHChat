//
//  OrgUserApplyDAL.m
//  LeadingCloud
//
//  Created by dfl on 16/5/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-05-30
 Version: 1.0
 Description: 用户申请加入组织成员列表数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "OrgUserApplyDAL.h"

@implementation OrgUserApplyDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgUserApplyDAL *)shareInstance{
    static OrgUserApplyDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[OrgUserApplyDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createOrgUserApplyTableIfNotExists
{
    NSString *tableName = @"org_user_apply";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[ouaid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[uid] [varchar](50) NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "[applytime] [date] NULL,"
                                         "[position] [varchar](50) NULL,"
                                         "[oeid] [varchar](50) NULL,"
                                         "[name] [varchar](100) NULL,"
                                         "[entername] [varchar](100) NULL,"
                                         "[face] [varchar](50) NULL,"
                                         "[username] [varchar](50) NULL,"
                                         "[mobile] [varchar](50) NULL,"
                                         "[email] [varchar](50) NULL,"
                                         "[result] [integer] NULL,"
                                         "[actionusername] [varchar](50) NULL,"
                                         "[actionuid] [varchar](50) NULL,"
                                         "[actiontime] [date] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateOrgUserIntervateTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}

#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)orgArray{
    [[self getDbQuene:@"org_user_apply" FunctionName:@"addDataWithArray:(NSMutableArray *)orgArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK=YES;
        NSString *sqlString=@"INSERT OR REPLACE INTO org_user_apply(ouaid,uid,oid,applytime,position,oeid,name,entername,face,username,mobile,email,result,actionusername,actionuid,actiontime)"
        "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        for (int i=0;i<orgArray.count;i++){
            OrgUserApplyModel *model=(OrgUserApplyModel *)[orgArray objectAtIndex:i];
            NSString *ouaid=model.ouaid;
            NSString *uid=model.uid;
            NSString *oid=model.oid;
            NSDate   *applytime=model.applytime;
            NSString *position=model.position;
            NSString *oeid=model.oeid;
            NSString *name=model.name;
            NSString *entername=model.entername;
            NSString *face=model.face;
            NSString *username=model.username;
            NSString *mobile=model.mobile;
            NSString *email=model.email;
            NSNumber *result=[NSNumber numberWithInteger:model.result];
            NSString *actionusername=model.actionusername;
            NSString *actionuid=model.actionuid;
            NSDate   *actiontime=model.actiontime;
            
            isOK = [db executeUpdate:sqlString,ouaid,uid,oid,applytime,position,oeid,name,entername,face,username,mobile,email,result,actionusername,actionuid,actiontime];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_user_apply" Sql:sqlString Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}


/**
 *  插入单条数据
 *
 *  @param model OrgUserApplyModel
 */
-(void)addOrgUserApplyModel:(OrgUserApplyModel *)model{
    
    [[self getDbQuene:@"org_user_apply" FunctionName:@"addOrgUserApplyModel:(OrgUserApplyModel *)model"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *ouaid=model.ouaid;
        NSString *uid=model.uid;
        NSString *oid=model.oid;
        NSDate   *applytime=model.applytime;
        NSString *position=model.position;
        NSString *oeid=model.oeid;
        NSString *name=model.name;
        NSString *entername=model.entername;
        NSString *face=model.face;
        NSString *username=model.username;
        NSString *mobile=model.mobile;
        NSString *email=model.email;
        NSNumber *result=[NSNumber numberWithInteger:model.result];
        NSString *actionusername=model.actionusername;
        NSString *actionuid=model.actionuid;
        NSDate   *actiontime=model.actiontime;
        
        NSString *sqlString=@"INSERT OR REPLACE INTO org_user_apply(ouaid,uid,oid,applytime,position,oeid,name,entername,face,username,mobile,email,result,actionusername,actionuid,actiontime)"
        "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sqlString,ouaid,uid,oid,applytime,position,oeid,name,entername,face,username,mobile,email,result,actionusername,actionuid,actiontime];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_user_apply" Sql:sqlString Error:@"插入失败" Other:nil];
            *rollback = YES;
            return;
        }
    }];
}

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData{
    [[self getDbQuene:@"org_user_apply" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
        isOK = [db executeUpdate:@"DELETE FROM org_user_apply"];
		if (!isOK) {
			
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_user_apply" Sql:@"DELETE FROM org_user_apply" Error:@"删除失败" Other:nil];

		}
    }];
}
/**
 *  根据oid清空数据
 */
-(void)deleteAllDataByOid:(NSString *)oid{
    [[self getDbQuene:@"org_user_apply" FunctionName:@"deleteAllDataByOid:(NSString *)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK =NO;
        NSString *sqlString=@"DELETE FROM org_user_apply WHERE oid=?";
        isOK = [db executeUpdate:sqlString,oid];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_user_apply" Sql:sqlString Error:@"删除失败" Other:nil];
		}
    }];
}

/**
 *  根据ouaid清空数据
 */
-(void)deleteOrgUserApplyByOuaid:(NSString *)ouaid{
    [[self getDbQuene:@"org_user_apply" FunctionName:@"deleteOrgUserApplyByOuaid:(NSString *)ouaid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
		
        NSString *sqlString=@"DELETE FROM org_user_apply WHERE ouaid=?";
       isOK = [db executeUpdate:sqlString,ouaid];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_user_apply" Sql:sqlString Error:@"删除失败" Other:nil];

		}
    }];
}

#pragma mark - 修改数据




#pragma mark - 查询数据

/**
 *  获取新的员工数据
 *
 */
-(NSMutableArray *)getOrgUserApplyDataWithStartNum:(NSInteger)startNum End:(NSInteger)end{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"org_user_apply" FunctionName:@"getOrgUserApplyDataWithStartNum:(NSInteger)startNum End:(NSInteger)end"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From org_user_apply Order by applytime desc limit %ld,%ld",(long)startNum,(long)end];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            OrgUserApplyModel *orgUserApplyModel=[self convertResultSetToModel:resultSet];
            [result addObject:orgUserApplyModel];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  根据oid获取管理部门下申请成员列表的数据
 *
 */
-(NSMutableArray *)getOrgUserApplyDataWithByOid:(NSString *)oid StartNum:(NSInteger)startNum End:(NSInteger)end{
    NSMutableArray *result = [[NSMutableArray alloc] init];
	[[self getDbQuene:@"org_user_apply" FunctionName:@"getOrgUserApplyDataWithByOid:(NSString *)oid StartNum:(NSInteger)startNum End:(NSInteger)end"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From org_user_apply WHERE oid=%@ Order by applytime desc limit %ld,%ld",oid,(long)startNum,(long)end];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            OrgUserApplyModel *orgUserApplyModel=[self convertResultSetToModel:resultSet];
            [result addObject:orgUserApplyModel];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  根据oeid获取管理组织下申请成员列表的数据
 *
 */
-(NSMutableArray *)getOrgUserApplyDataWithByOeId:(NSString *)oeid StartNum:(NSInteger)startNum End:(NSInteger)end{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"org_user_apply" FunctionName:@"getOrgUserApplyDataWithByOeId:(NSString *)oeid StartNum:(NSInteger)startNum End:(NSInteger)end"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From org_user_apply WHERE oeid=%@ Order by applytime desc limit %ld,%ld",oeid,(long)startNum,(long)end];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            OrgUserApplyModel *orgUserApplyModel=[self convertResultSetToModel:resultSet];
            [result addObject:orgUserApplyModel];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  根据主键id获取好友信息
 *  @param ouaid 主键ID
 *  @return
 */
-(OrgUserApplyModel *)getOrgUserApplyByOuaId:(NSString *)ouaid{
    __block OrgUserApplyModel *model=nil;
    [[self getDbQuene:@"org_user_apply" FunctionName:@"getOrgUserApplyByOuaId:(NSString *)ouaid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString=@"SELECT * FROM org_user_apply WHERE ouaid=?";
        FMResultSet *resultSet=[db executeQuery:sqlString,ouaid];
        if([resultSet next]){
            model = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    return model;
    
}

#pragma mark - Private Function

/**
 *  将OrgUserIntervateModel转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return OrgUserApplyModel
 */
-(OrgUserApplyModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    OrgUserApplyModel *orgUserApplyModel=[[OrgUserApplyModel alloc]init];
    
    orgUserApplyModel.ouaid=[resultSet stringForColumn:@"ouaid"];
    orgUserApplyModel.uid=[resultSet stringForColumn:@"uid"];
    orgUserApplyModel.oid=[resultSet stringForColumn:@"oid"];
    orgUserApplyModel.applytime=[resultSet dateForColumn:@"applytime"];
    orgUserApplyModel.position=[resultSet stringForColumn:@"position"];
    orgUserApplyModel.oeid=[resultSet stringForColumn:@"oeid"];
    orgUserApplyModel.name=[resultSet stringForColumn:@"name"];
    orgUserApplyModel.entername=[resultSet stringForColumn:@"entername"];
    orgUserApplyModel.face=[resultSet stringForColumn:@"face"];
    orgUserApplyModel.username=[resultSet stringForColumn:@"username"];
    orgUserApplyModel.mobile=[resultSet stringForColumn:@"mobile"];
    orgUserApplyModel.email=[resultSet stringForColumn:@"email"];
    orgUserApplyModel.result=[resultSet intForColumn:@"result"];
    orgUserApplyModel.actionusername=[resultSet stringForColumn:@"actionusername"];
    orgUserApplyModel.actionuid=[resultSet stringForColumn:@"actionuid"];
    orgUserApplyModel.actiontime=[resultSet dateForColumn:@"actiontime"];

    return orgUserApplyModel;
}

@end
