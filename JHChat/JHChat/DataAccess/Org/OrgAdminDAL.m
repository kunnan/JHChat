//
//  OrgAdminDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 管理员数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "OrgAdminDAL.h"
#import "NSString+IsNullOrEmpty.h"

#define ORGADMINTABLENAME @"org_admin"

@implementation OrgAdminDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgAdminDAL *)shareInstance{
    static OrgAdminDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[OrgAdminDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createOrgAdminTableIfNotExists
{
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:ORGADMINTABLENAME]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[oaid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "[uid] [varchar](50) NULL,"
                                         "[oeid] [varchar](50) NULL);",
                                         ORGADMINTABLENAME]];
    }
}
/**
 *  升级数据库
 */
-(void)updateOrgAdminTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据
/**
 *  批量添加数据
 *  @param orgAdminArr
 */
-(void)addDataWithOrgAdminArray:(NSArray *)orgAdminArr{
    if([orgAdminArr count]==0) return;
    [[self getDbQuene:@"org_admin" FunctionName:@"addDataWithOrgAdminArray:(NSArray *)orgAdminArr"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOk=YES;
		NSString *sqlString;
        for (int i=0;i<orgAdminArr.count;i++){
            OrgAdminModel *model=[orgAdminArr objectAtIndex:i];
            
            sqlString=@"INSERT OR REPLACE INTO %@(oaid,oid,uid,oeid) VALUES(?,?,?,?)";
            sqlString=[NSString stringWithFormat:sqlString,ORGADMINTABLENAME];
            isOk=[db executeUpdate:sqlString,model.oaid,model.oid,model.uid,model.oeid ];
            if(!isOk){
                DDLogError(@"插入失败");
            }
        }
        //插入失败，回退
        if(!isOk){
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:ORGADMINTABLENAME Sql:sqlString Error:@"插入失败" Other:nil];

            *rollback=YES;
            return ;
        }
    }];
}


#pragma mark - 删除数据



#pragma mark - 修改数据



#pragma mark - 查询数据


@end
