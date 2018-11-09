//
//  OrgUserDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 组织人员数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "OrgUserDAL.h"

@implementation OrgUserDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgUserDAL *)shareInstance{
    static OrgUserDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[OrgUserDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createOrgUserTableIfNotExists
{
    NSString *tableName = @"org_user";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[ouid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "[uid] [varchar](50) NULL,"
                                         "[applytime] [date] NULL,"
                                         "[jointime] [date] NULL,"
                                         "[state] [integer] NULL,"
                                         "[position] [varchar](50) NULL,"
                                         "[oeid] [varchar](50) NULL,"
                                         "[faceid] [varchar](50) NULL,"
                                         "[jiancheng] [varchar](50) NULL,"
                                         "[quancheng] [varchar](50) NULL,"
                                         "[username] [varchar](50) NULL"
                                         ");",
                                         tableName]];
    }
}
/**
 *  升级数据库
 */
-(void)updateOrgUserTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据
/**
 *  批量添加数据
 *  @param dataArray
 */
-(void)addDataWithOrgUserArray:(NSMutableArray *)dataArray{
    [[self getDbQuene:@"org_user" FunctionName:@"addDataWithOrgUserArray:(NSMutableArray *)dataArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK=YES;
		NSString *sqlString=@"INSERT OR REPLACE INTO org_user(ouid,oid,uid,applytime,jointime,state,position,oeid,faceid,jiancheng,quancheng,username)"
		" VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i=0;i<dataArray.count;i++){
            OrgUserModel *model=[dataArray objectAtIndex:i];

            isOK=[db executeUpdate:sqlString,model.ouid,model.oid,model.uid,model.applytime,model.jointime,model.state,model.position,model.oeid,model.faceid,model.jiancheng,model.quancheng,model.username];
            if(isOK==false){
                DDLogError(@"OrgUser插入数据失败");
            }
        }
        if(isOK==false) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"org_user" Sql:sqlString Error:@"插入失败" Other:nil];
		
            *rollback=YES;
        }
    }];
}


#pragma mark - 删除数据


#pragma mark - 修改数据



#pragma mark - 查询数据


@end
