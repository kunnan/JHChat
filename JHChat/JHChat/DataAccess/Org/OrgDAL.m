//
//  OrgDAL.m
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

#import "OrgDAL.h"
#import "FMDataBaseQueue.h"

@implementation OrgDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgDAL *)shareInstance{
    static OrgDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[OrgDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createOrgTableIfNotExists
{
    NSString *tableName = @"org";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[oid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[opid] [varchar](50) NULL,"
                                         "[name] [varchar](100) NULL,"
                                         "[shortname] [varchar](50) NULL,"
                                         "[code] [varchar](50) NULL,"
                                         "[createuser] [varchar](50) NULL,"
                                         "[createdate] [date] NULL,"
                                         "[description] [varchar](500) NULL,"
                                         "[state] [integer] NULL,"
                                         "[type] [integer] NULL,"
                                         "[sort] [integer] NULL,"
                                         "[oeid] [varchar](50) NULL,"
                                         "[opath] [text] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateOrgTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithOrgArray:(NSMutableArray *)allOrgArr{
    [[self getDbQuene:@"org" FunctionName:@"addDataWithOrgArray:(NSMutableArray *)allOrgArr"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO org(oid,opid,name,shortname,code,createuser,createdate,description,state,type,sort,oeid,opath)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        for (int i = 0; i< allOrgArr.count;  i++) {
            OrgModel *orgModel = [allOrgArr objectAtIndex:i];
            
            NSString *oid = orgModel.oid;
            NSString *opid = orgModel.opid;
            NSString *name = orgModel.name;
            NSString *shortname = orgModel.shortname;
            NSString *code = orgModel.code;
            NSString *createuser = orgModel.createuser;
            NSDate *createdate = orgModel.createdate;
            NSString *description = orgModel.description;
            NSNumber *state = [NSNumber numberWithInteger:orgModel.state];
            NSNumber *type = [NSNumber numberWithInteger:orgModel.type];
            NSNumber *sort = [NSNumber numberWithInteger:orgModel.sort];
            NSString *oeid = orgModel.oeid;
            NSString *opath = orgModel.opath;
		
            isOK = [db executeUpdate:sql,oid,opid,name,shortname,code,createuser,createdate,description,state,type,sort,oeid,opath];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}

#pragma mark - 删除数据

#pragma mark - 修改数据

#pragma mark - 查询数据

@end
