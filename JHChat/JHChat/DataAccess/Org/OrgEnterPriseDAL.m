//
//  OrgEnterPriseDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 组织数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "OrgEnterPriseDAL.h"
#import "FMDatabaseQueue.h"

@implementation OrgEnterPriseDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgEnterPriseDAL *)shareInstance{
    static OrgEnterPriseDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[OrgEnterPriseDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createOrgEnterPriseTableIfNotExists
{
    NSString *tableName = @"org_enterprise";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[eid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[epid] [varchar](50) NULL,"
                                         "[ecode] [varchar](50) NULL,"
                                         "[name] [varchar](100) NULL,"
                                         "[shortname] [varchar](50) NULL,"
                                         "[description] [varchar](500) NULL,"
                                         "[province] [varchar](50) NULL,"
                                         "[city] [varchar](50) NULL,"
                                         "[county] [varchar](50) NULL,"
                                         "[createuser] [varchar](50) NULL,"
                                         "[createdate] [date] NULL,"
                                         "[detail_address] [varchar](100) NULL,"
                                         "[setup] [text] NULL,"
                                         "[reg_org_code] [varchar](50) NULL,"
                                         "[reg_ic_code] [varchar](50) NULL,"
                                         "[reg_type] [integer] NULL,"
                                         "[reg_date] [date] NULL,"
                                         "[reg_legal_person] [varchar](50) NULL,"
                                         "[reg_province] [varchar](50) NULL,"
                                         "[reg_city] [varchar](50) NULL,"
                                         "[reg_county] [varchar](50) NULL,"
                                         "[reg_detail_address] [varchar](50) NULL,"
                                         "[logo] [varchar](50) NULL,"
                                         "[isenteradmin] [integer] NULL,"
                                         "[reg_license] [varchar](500) NULL,"
                                         "[username] [varchar](50) NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateOrgEnterPriseTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 33:
                [self AddColumnToTableIfNotExist:@"org_enterprise" columnName:@"[isadmin]" type:@"[integer]"];
                break;
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithOrgEnterpriseArray:(NSMutableArray *)orgEnterPriseArr{
    
    [[self getDbQuene:@"org_enterprise" FunctionName:@"addDataWithOrgEnterpriseArray:(NSMutableArray *)orgEnterPriseArr"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO org_enterprise(eid,ecode,name,shortname,logo,isenteradmin,createdate,username,isadmin)"
		"VALUES (?,?,?,?,?,?,?,?,?)";
        for (int i = 0; i< orgEnterPriseArr.count;  i++) {
            OrgEnterPriseModel *orgEnterPriseModel = [orgEnterPriseArr objectAtIndex:i];
            
            NSString *eid = orgEnterPriseModel.eid;
            NSString *ecode = orgEnterPriseModel.ecode;
            NSString *name = orgEnterPriseModel.name;
            NSString *shortname = orgEnterPriseModel.shortname;
            NSDate *createdate = orgEnterPriseModel.createdate;
            NSString *username = orgEnterPriseModel.username;
            NSNumber *isenteradmin = [NSNumber numberWithInteger:orgEnterPriseModel.isenteradmin];
            NSNumber *isadmin=[NSNumber numberWithInteger:orgEnterPriseModel.isadmin];

            isOK = [db executeUpdate:sql,eid,ecode,name,shortname,orgEnterPriseModel.logo,isenteradmin,createdate,username,isadmin];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_enterprise" Sql:sql Error:@"插入失败" Other:nil];

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
	[[self getDbQuene:@"org_enterprise" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOk = NO;
        isOk =[db executeUpdate:@"DELETE FROM org_enterprise"];
		if (!isOk) {
			
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_enterprise" Sql:@"DELETE FROM org_enterprise" Error:@"删除失败" Other:nil];

		}
    }];
}

/**
 *  根据eid删除组织信息
 *  @param oId
 */
-(void)deleteOrgUserEntetpriseByEId:(NSString *)eId{
    [[self getDbQuene:@"org_enterprise" FunctionName:@"deleteOrgUserEntetpriseByEId:(NSString *)eId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOk = NO;

        NSString *sqlString=@"DELETE FROM org_enterprise WHERE eid=?";
       isOk = [db executeUpdate:sqlString,eId];
		
		if (!isOk) {
			
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_enterprise" Sql:@"DELETE FROM org_enterprise WHERE eid=" Error:@"删除失败" Other:nil];
			
		}
    }];
   
}

#pragma mark - 修改数据
/**
 *  更新组织的信息
 *  @param oeId        组织id
 *  @param name        名称
 *  @param shortName   简称
 *  @param description 描述
 */
-(void)updateEnterpriseWithOEId:(NSString * )oeId name:(NSString *)name shortName:(NSString *)shortName description:(NSString *)description{
	[[self getDbQuene:@"org_enterprise" FunctionName:@"updateEnterpriseWithOEId:(NSString * )oeId name:(NSString *)name shortName:(NSString *)shortName description:(NSString *)description"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOk = NO;
		
       NSString *sqlString=@"UPDATE org_enterprise SET name=? ,shortname=?,description=? WHERE eid=?";
        isOk = [db executeUpdate:sqlString,name,shortName,description,oeId];
		if (!isOk) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_enterprise" Sql:sqlString Error:@"更新失败" Other:nil];
		}
		
    }];
}

/**
 *  更改管理员身份
 */
-(void)updateEnterpriseWithOEId:(NSString *)oeId isenteradmin:(NSInteger)isenteradmin{
    
    [[self getDbQuene:@"org_enterprise" FunctionName:@"updateEnterpriseWithOEId:(NSString *)oeId isenteradmin:(NSInteger)isenteradmin"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOk = NO;

        NSString *sqlString=@"UPDATE org_enterprise SET isenteradmin=? WHERE eid=?";
       isOk = [db executeUpdate:sqlString,[NSNumber numberWithInteger:isenteradmin],oeId];
		if (!isOk) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_enterprise" Sql:sqlString Error:@"更新失败" Other:nil];
		}
    }];
}

-(void)updateEnterpriseWithOEId:(NSString *)oeId isadmin:(NSInteger)isadmin{
    
	[[self getDbQuene:@"org_enterprise" FunctionName:@"updateEnterpriseWithOEId:(NSString *)oeId isadmin:(NSInteger)isadmin"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOk = NO;

        NSString *sqlString=@"UPDATE org_enterprise SET isadmin=? WHERE eid=?";
       isOk = [db executeUpdate:sqlString,[NSNumber numberWithInteger:isadmin],oeId];
		if (!isOk) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_enterprise" Sql:sqlString Error:@"更新失败" Other:nil];
		}
    }];
}

/**
 *  更改组织logo
 */
-(void)updateEnterpriseWithOEIdByLogo:(NSString *)oeId Logo:(NSString *)logo{
    [[self getDbQuene:@"org_enterprise" FunctionName:@"updateEnterpriseWithOEIdByLogo:(NSString *)oeId Logo:(NSString *)logo"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOk = NO;

        NSString *sqlString=@"UPDATE org_enterprise SET logo=? WHERE eid=?";
       isOk = [db executeUpdate:sqlString,logo,oeId];
		if (!isOk) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_enterprise" Sql:sqlString Error:@"更新失败" Other:nil];
		}
    }];
}

#pragma mark - 查询数据
/**
 *  获取【我】所属的组织集合
 *  @return
 */
-(NSArray<OrgEnterPriseModel *> *)getOrgEnterPrises{
    __block NSArray<OrgEnterPriseModel *> *tmpArray=nil;
    [[self getDbQuene:@"org_enterprise" FunctionName:@"getOrgEnterPrises"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString=@"SELECT * FROM org_enterprise order by createdate";
        FMResultSet *resultSet=[db executeQuery:sqlString];
        tmpArray=[self convertFMResultSet2Model:resultSet];
        [resultSet close];
    }];
    return  tmpArray;
}

/**
 *  根据组织主键获取组织数据
 *  @param eId
 *  @return
 */
-(OrgEnterPriseModel *)getEnterpriseByEId:(NSString *)eId{
    __block NSArray<OrgEnterPriseModel *> *tmpArray=nil;
    [[self getDbQuene:@"org_enterprise" FunctionName:@"getEnterpriseByEId:(NSString *)eId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
       NSString *sqlString=@"SELECT * FROM org_enterprise WHERE eid=?";
        FMResultSet *resultSet=[db executeQuery:sqlString,eId];
        tmpArray=[self convertFMResultSet2Model:resultSet];
        [resultSet close];
    }];
    if(tmpArray!=nil && [tmpArray count]>0){
        return [tmpArray firstObject];
    }
    return nil;
}

/**
 *  根据组织主键获取组织名称
 *  @param eId
 *  @return
 */
-(NSString *)getEnterpriseShortNameByEId:(NSString *)eId{
    __block NSString *shortname=nil;
    [[self getDbQuene:@"org_enterprise" FunctionName:@"getEnterpriseShortNameByEId:(NSString *)eId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select shortname From org_enterprise Where eid=%@ ",eId];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            shortname=[resultSet stringForColumn:@"shortname"];
        }
        [resultSet close];
    }];
    return shortname;
    
}


#pragma mark 将查询的结果集转换为Model
/**
 * 将查询的结果集转换为Model
 *  @param resultSet
 *  @return
 */
-(NSArray<OrgEnterPriseModel *> *)convertFMResultSet2Model:(FMResultSet *)resultSet{
    NSMutableArray<OrgEnterPriseModel *> *tmpArray=[[NSMutableArray alloc]init];
    while (([resultSet next])) {
        OrgEnterPriseModel *model=[[OrgEnterPriseModel alloc]init];
        model.eid=[resultSet stringForColumn:@"eid"];
        model.epid=[resultSet stringForColumn:@"epid"];
        model.ecode=[resultSet stringForColumn:@"ecode"];
        model.name=[resultSet stringForColumn:@"name"];
        model.shortname=[resultSet stringForColumn:@"shortname"];
        model.descript=[resultSet stringForColumn:@"description"];
        model.province=[resultSet stringForColumn:@"province"];
        model.city=[resultSet stringForColumn:@"city"];
        model.county=[resultSet stringForColumn:@"county"];
        model.createuser=[resultSet stringForColumn:@"createuser"];
        model.createdate=[LZFormat String2Date:[resultSet stringForColumn:@"createdate"]];
        model.detailaddress=[resultSet stringForColumn:@"detail_address"];
        model.setup=[resultSet stringForColumn:@"setup"];
        model.regorgcode=[resultSet stringForColumn:@"reg_org_code"];
        model.regiccode=[resultSet stringForColumn:@"reg_ic_code"];
        model.regtype=[LZFormat Safe2Int32:[resultSet stringForColumn:@"reg_type"]];
        model.regdate=[LZFormat String2Date:[resultSet stringForColumn:@"reg_date"]];
        model.reglegalperson=[resultSet stringForColumn:@"reg_legal_person"];
        model.regprovince=[resultSet stringForColumn:@"reg_province"];
        model.regcity=[resultSet stringForColumn:@"reg_city"];
        model.regcounty=[resultSet stringForColumn:@"reg_county"];
        model.regdetailaddress=[resultSet stringForColumn:@"reg_detail_address"];
        model.reglicense=[resultSet stringForColumn:@"reg_license"];
        model.logo=[resultSet stringForColumn:@"logo"];
        model.isenteradmin=[LZFormat Safe2Int32:[resultSet stringForColumn:@"isenteradmin"]];
        model.username = [resultSet stringForColumn:@"username"];
        model.isadmin = [LZFormat Safe2Int32:[resultSet stringForColumn:@
                                              "isadmin"]];
        
        [tmpArray addObject:model];
    }
    
    return [tmpArray copy];
}
@end
