//
//  NetDiskOrgDAL.m
//  LeadingCloud
//
//  Created by SY on 2017/7/21.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "NetDiskOrgDAL.h"
#import "NetDiskOrgModel.h"
#import "NSObject+JsonSerial.h"
#import "NSString+SerialToDic.h"
@implementation NetDiskOrgDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(NetDiskOrgDAL *)shareInstance{
    static NetDiskOrgDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[NetDiskOrgDAL alloc] init];
    }
    return instance;
}
#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createNetDiskOrgTableIfNotExists
{
    NSString *tableName = @"res_netdiskorg";
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[rpid] [varchar](100) PRIMARY KEY NOT NULL,"
                                         "[logo] [varchar](50) NULL,"
                                         "[name] [varchar](50) NULL,"
                                         "[groupid] [varchar](50) NULL,"
                                         "[orgid] [varchar](50) NULL,"
                                         "[showindex] [integer] NULL,"
                                         "[type] [integer] NULL);",
                                         tableName]];
        
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)orgArray{
    
    [[self getDbQuene:@"res_netdiskorg" FunctionName:@"addDataWithArray:(NSMutableArray *)orgArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO res_netdiskorg(rpid,logo,name,groupid,orgid,showindex,type)"
		"VALUES (?,?,?,?,?,?,?)";
		
        for (int i = 0; i< orgArray.count;  i++) {
            NetDiskOrgModel *resModel = [orgArray objectAtIndex:i];
            NSString *groupid = resModel.groupid;
            NSString *logo = resModel.logo;
            NSString *name = resModel.name;
            NSString *rpid = resModel.rpid;
            NSString *orgid = resModel.orgid;
            NSNumber *showindex = [NSNumber numberWithInteger:resModel.showindex];
            NSNumber *type = [NSNumber numberWithInteger:resModel.type];
			
            isOK = [db executeUpdate:sql,rpid,logo,name,groupid,orgid,showindex,type];
            if (!isOK) {
                DDLogError(@"插入失败");
                break;
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res_netdiskorg" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}
#pragma mark - 删除数据
/**
 *  删除数据库中所有对象
 */
-(void)deleteAllData {
    
    [[self getDbQuene:@"res_netdiskorg" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from res_netdiskorg";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res_netdiskorg" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}

#pragma mark - 查询数据

/**
 获取企业

 @return 企业model
 */
-(NSMutableArray *)getNetOrgModels
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"res_netdiskorg" FunctionName:@"getNetOrgModels"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From res_netdiskorg where type = 1"];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;

}

/**
 获取企业分区下的数据

 @param orgid 企业id
 @return 企业model
 */
-(NSMutableArray *)getNetOrgChildDataWithOrgid:(NSString*)orgid
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"res_netdiskorg" FunctionName:@"getNetOrgChildDataWithOrgid:(NSString*)orgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From res_netdiskorg where orgid = %@ Order by showindex asc",orgid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
    
}
-(NetDiskOrgModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    NSString *groupid = [resultSet stringForColumn:@"groupid"];
    NSString *logo = [resultSet stringForColumn:@"logo"];
    NSString *name = [resultSet stringForColumn:@"name"];
    NSString *rpid = [resultSet stringForColumn:@"rpid"];
    NSString *orgid = [resultSet stringForColumn:@"orgid"];
    NSInteger showindex =[resultSet intForColumn:@"showindex"];
    NSInteger type = [resultSet intForColumn:@"type"];
   
    NetDiskOrgModel *resModel = [[NetDiskOrgModel alloc] init];
    resModel.groupid = groupid;
    resModel.logo = logo;
    resModel.name = name;
    resModel.rpid = rpid;
    resModel.orgid = orgid;
    resModel.showindex = showindex;
    resModel.type = type;
  
    
    return resModel;
}
@end
