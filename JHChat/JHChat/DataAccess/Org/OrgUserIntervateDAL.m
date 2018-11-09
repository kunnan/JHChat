//
//  OrgUserIntervateDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 组织邀请成员数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "OrgUserIntervateDAL.h"

@implementation OrgUserIntervateDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgUserIntervateDAL *)shareInstance{
    static OrgUserIntervateDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[OrgUserIntervateDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createOrgUserIntervateTableIfNotExists
{
    NSString *tableName = @"org_user_intervate";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[ouiid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[objid] [varchar](50) NULL,"
                                         "[objoeid] [varchar](50) NULL,"
                                         "[email] [varchar](50) NULL,"
                                         "[mobile] [varchar](50) NULL,"
                                         "[intervatedate] [date] NULL,"
                                         "[regtype] [integer] NULL,"
                                         "[objtype] [integer] NULL,"
                                         "[senduid] [varchar](20) NULL,"
                                         "[username] [varchar](50) NULL,"
                                         "[position] [varchar](50) NULL,"
                                         "[depname] [varchar](100) NULL,"
                                         "[entername] [varchar](100) NULL,"
                                         "[result] [integer] NULL,"
                                         "[logo] [varchar](200) NULL,"
                                         "[actiondate] [date] NULL,"
                                         "[uid] [varchar](50) NULL,"
                                         "[revokeuid] [varchar](50) NULL,"
                                         "[revokeusername] [text] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateOrgUserIntervateTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
//        switch (i) {
//            case 16:
//                [self AddColumnToTableIfNotExist:@"org_user_intervate" columnName:@"revokeuid" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"org_user_intervate" columnName:@"revokeusername" type:@"[text]"];
//                break;
//        }
    }
}
#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)orgArray{
    [[self getDbQuene:@"org_user_intervate" FunctionName:@"addDataWithArray:(NSMutableArray *)orgArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK=YES;
        NSString *sqlString=@"INSERT OR REPLACE INTO org_user_intervate(ouiid,objid,objoeid,email,mobile,intervatedate,regtype,objtype,senduid,username,position,depname,entername,result,logo,actiondate,uid,revokeuid,revokeusername)"
        "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        for (int i=0;i<orgArray.count;i++){
            OrgUserIntervateModel *model=(OrgUserIntervateModel *)[orgArray objectAtIndex:i];
            NSString *ouiid=model.ouiid;
            NSString *objid=model.objid;
            NSString *objoeid=model.objoeid;
            NSString *email=model.email;
            NSString *mobile=model.mobile;
            NSDate   *intervatedate=model.intervatedate;
            NSNumber *regtype=[NSNumber numberWithInteger:model.regtype];
            NSNumber *objtype=[NSNumber numberWithInteger:model.objtype];
            NSString *senduid=model.senduid;
            NSString *username=model.username;
            NSString *position=model.position;
            NSString *depname=model.depname;
            NSString *entername=model.entername;
            NSNumber *result=[NSNumber numberWithInteger:model.result];
            NSString *uid=model.uid;
            NSString *logo=model.logo;
            NSDate   *actiondate=model.actiondate;
            NSString *revokeuid=model.revokeuid;
            NSString *revokeusername=model.revokeusername;
            
            isOK = [db executeUpdate:sqlString,ouiid,objid,objoeid,email,mobile,intervatedate,regtype,objtype,senduid,username,position,depname,entername,result,logo,actiondate,uid,revokeuid,revokeusername];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_user" Sql:sqlString Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}


/**
 *  插入单条数据
 *
 *  @param model OrgUserIntervateModel
 */
-(void)addOrgUserIntervateModel:(OrgUserIntervateModel *)model{
    
    [[self getDbQuene:@"org_user_intervate" FunctionName:@"addOrgUserIntervateModel:(OrgUserIntervateModel *)model"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *ouiid=model.ouiid;
        NSString *objid=model.objid;
        NSString *objoeid=model.objoeid;
        NSString *email=model.email;
        NSString *mobile=model.mobile;
        NSDate   *intervatedate=model.intervatedate;
        NSNumber *regtype=[NSNumber numberWithInteger:model.regtype];
        NSNumber *objtype=[NSNumber numberWithInteger:model.objtype];
        NSString *senduid=model.senduid;
        NSString *username=model.username;
        NSString *position=model.position;
        NSString *depname=model.depname;
        NSString *entername=model.entername;
        NSNumber *result=[NSNumber numberWithInteger:model.result];
        NSString *uid=model.uid;
        NSString *logo=model.logo;
        NSDate   *actiondate=model.actiondate;
        NSString *revokeuid=model.revokeuid;
        NSString *revokeusername=model.revokeusername;
        
        NSString *sqlString=@"INSERT OR REPLACE INTO org_user_intervate(ouiid,objid,objoeid,email,mobile,intervatedate,regtype,objtype,senduid,username,position,depname,entername,result,logo,actiondate,uid,revokeuid,revokeusername)"
        "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sqlString,ouiid,objid,objoeid,email,mobile,intervatedate,regtype,objtype,senduid,username,position,depname,entername,result,logo,actiondate,uid,revokeuid,revokeusername];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_user" Sql:sqlString Error:@"插入失败" Other:nil];

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
    [[self getDbQuene:@"org_user_intervate" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
        isOK = [db executeUpdate:@"DELETE FROM org_user_intervate"];
		if (!isOK) {
			
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_user_intervate" Sql:@"DELETE FROM org_user_intervate" Error:@"删除失败" Other:nil];

		}
    }];
}

/**
 *  根据ouiid删除信息
 *  @param ouiid
 */
-(void)deleteOrgUserIntervateByOuiId:(NSString *)ouiid{
	[[self getDbQuene:@"org_user_intervate" FunctionName:@"deleteOrgUserIntervateByOuiId:(NSString *)ouiid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
        NSString *sqlString=@"DELETE FROM org_user_intervate WHERE ouiid=?";
        isOK = [db executeUpdate:sqlString,ouiid];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_user_intervate" Sql:sqlString Error:@"删除失败" Other:nil];

		}
    }];
	
    
}

#pragma mark - 修改数据



#pragma mark - 查询数据

/**
 *  获取新的组织全部数据
 *
 */
-(NSMutableArray *)getOrgUserIntervateDataWithUid:(NSString *)uid{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"org_user_intervate" FunctionName:@"getOrgUserIntervateDataWithUid:(NSString *)uid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From org_user_intervate Where uid=%@ Order by result asc",uid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            OrgUserIntervateModel *orgUserIntervateModel=[self convertResultSetToModel:resultSet];
            
            
            [result addObject:orgUserIntervateModel];
        }
        [resultSet close];
    }];
    
    return result;
}
/**
 *  获取新的组织数据
 *
 */
-(NSMutableArray *)getOrgUserIntervateDataWithUid:(NSString *)uid StartNum:(NSInteger)startNum End:(NSInteger)end{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"org_user_intervate" FunctionName:@"getOrgUserIntervateDataWithUid:(NSString *)uid StartNum:(NSInteger)startNum End:(NSInteger)end"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From org_user_intervate Where uid=%@ Order by intervatedate desc limit %ld,%ld",uid,(long)startNum,(long)end];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            OrgUserIntervateModel *orgUserIntervateModel=[self convertResultSetToModel:resultSet];
            [result addObject:orgUserIntervateModel];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  根据主键id获取组织数据
 *  @param ouiid 主键ID
 *  @return
 */
-(OrgUserIntervateModel *)getOrgUserIntervateByOuiId:(NSString *)ouiid{
    __block OrgUserIntervateModel *model=nil;
    [[self getDbQuene:@"org_user_intervate" FunctionName:@"getOrgUserIntervateByOuiId:(NSString *)ouiid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString=@"SELECT * FROM org_user_intervate WHERE ouiid=?";
        FMResultSet *resultSet=[db executeQuery:sqlString,ouiid];
        if([resultSet next]){
            model = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    return model;
    
}

/**
 *  根据组织id获取组织数据
 *  @param objoeid 组织ID
 *  @return
 */
-(OrgUserIntervateModel *)getOrgUserIntervateByObjOeid:(NSString *)objoeid{
    __block OrgUserIntervateModel *model=nil;
    [[self getDbQuene:@"org_user_intervate" FunctionName:@"getOrgUserIntervateByObjOeid:(NSString *)objoeid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString=@"SELECT * FROM org_user_intervate WHERE objoeid=?";
        FMResultSet *resultSet=[db executeQuery:sqlString,objoeid];
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
 *  @return OrgUserIntervateModel
 */
-(OrgUserIntervateModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    OrgUserIntervateModel *orgUserIntervateModel=[[OrgUserIntervateModel alloc]init];
    
    orgUserIntervateModel.ouiid=[resultSet stringForColumn:@"ouiid"];
    orgUserIntervateModel.objid=[resultSet stringForColumn:@"objid"];
    orgUserIntervateModel.objoeid=[resultSet stringForColumn:@"objoeid"];
    orgUserIntervateModel.email=[resultSet stringForColumn:@"email"];
    orgUserIntervateModel.intervatedate=[resultSet dateForColumn:@"intervatedate"];
    orgUserIntervateModel.regtype=[resultSet intForColumn:@"regtype"];
    orgUserIntervateModel.objtype=[resultSet intForColumn:@"objtype"];
    orgUserIntervateModel.senduid=[resultSet stringForColumn:@"senduid"];
    orgUserIntervateModel.username=[resultSet stringForColumn:@"username"];
    orgUserIntervateModel.position=[resultSet stringForColumn:@"position"];
    orgUserIntervateModel.entername=[resultSet stringForColumn:@"entername"];
    orgUserIntervateModel.depname=[resultSet stringForColumn:@"depname"];
    orgUserIntervateModel.result=[resultSet intForColumn:@"result"];
    orgUserIntervateModel.logo=[resultSet stringForColumn:@"logo"];
    orgUserIntervateModel.uid=[resultSet stringForColumn:@"uid"];
    orgUserIntervateModel.actiondate=[resultSet dateForColumn:@"actiondate"];
    orgUserIntervateModel.mobile=[resultSet stringForColumn:@"mobile"];
    orgUserIntervateModel.revokeuid=[resultSet stringForColumn:@"revokeuid"];
    orgUserIntervateModel.revokeusername=[resultSet stringForColumn:@"revokeusername"];
    return orgUserIntervateModel;
}

@end
