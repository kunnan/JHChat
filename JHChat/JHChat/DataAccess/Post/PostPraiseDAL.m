//
//  PostPraiseDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 点赞数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "PostPraiseDAL.h"

@implementation PostPraiseDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostPraiseDAL *)shareInstance{
    static PostPraiseDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[PostPraiseDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostPraiseTableIfNotExists
{
    NSString *tableName = @"post_praise";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[ppid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[pid] [varchar](50) NULL,"
                                         "[uid] [varchar](50) NULL,"
                                         "[username] [varchar](200) NULL,"
                                         "[praisedate] [date] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updatePostPraiseTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据

#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)pArray{
    
    
	[[self getDbQuene:@"post_praise" FunctionName:@"addDataWithArray:(NSMutableArray *)pArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO post_praise(pid,ppid,praisedate,uid,username)"
		"VALUES (?,?,?,?,?)";
		
        for (int i = 0; i< pArray.count;  i++) {
            PostZanModel *pModel = [pArray objectAtIndex:i];
            
            NSString *pid = pModel.pid;
            NSString *ppid = pModel.ppid;
            NSDate *praisedate = pModel.praisedate;
            NSString *uid = pModel.uid;
            NSString *username=pModel.username;

            isOK = [db executeUpdate:sql,pid,ppid,praisedate,uid,username];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_praise" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];
    
}
-(void)addDataWithModel:(PostZanModel *)pModel{
    [[self getDbQuene:@"post_praise" FunctionName:@"addDataWithModel:(PostZanModel *)pModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
            NSString *pid = pModel.pid;
            NSString *ppid = pModel.ppid;
            NSDate *praisedate = pModel.praisedate;
            NSString *uid = pModel.uid;
            NSString *username=pModel.username;
            NSString *sql = @"INSERT OR REPLACE INTO post_praise(pid,ppid,praisedate,uid,username)"
            "VALUES (?,?,?,?,?)";
            isOK = [db executeUpdate:sql,pid,ppid,praisedate,uid,username];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }

        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_praise" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];
}
#pragma mark - 删除动态全部数据
/**
 *  删除动态全部数据
 */
-(void)delePostPID:(NSString *)pid{
    [[self getDbQuene:@"post_praise" FunctionName:@"delePostPID:(NSString *)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from post_praise where pid=?";
        isOK = [db executeUpdate:sql,pid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_praise" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}
#pragma mark - 删除数据
/**
 *  删除单条数据
 */
-(void)delePostPraiseID:(NSString *)ppid{
	[[self getDbQuene:@"post_praise" FunctionName:@"delePostPraiseID:(NSString *)ppid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from post_praise where ppid=?";
        isOK = [db executeUpdate:sql,ppid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_praise" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}

#pragma mark - 修改数据



#pragma mark - 查询数据

@end
