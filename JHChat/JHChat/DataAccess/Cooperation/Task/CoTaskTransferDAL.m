//
//  CoTaskTransferDAL.m
//  LeadingCloud
//
//  Created by wang on 16/2/24.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoTaskTransferDAL.h"

@implementation CoTaskTransferDAL


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoTaskTransferDAL *)shareInstance{
    static CoTaskTransferDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoTaskTransferDAL alloc] init];
    }
    return instance;
}

/**
 *  创建表
 */
-(void)createCoTaskTransferIfNotExists
{
    NSString *tableName = @"co_task_transfer";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[tid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[uid] [varchar](50) NULL,"
                                         "[cid] [varchar](50) NULL,"
                                         "[oid] [varchar](50) NULL);",
                                         tableName]];
        
    }
}

/**
 *  升级数据库
 */
-(void)updateCoTaskTransferTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
-(void)addDataWithArray:(NSMutableArray *)taskArray{
    
    [[self getDbQuene:@"co_task_transfer" FunctionName:@"addDataWithArray:(NSMutableArray *)taskArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *uid=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
        NSString *oid=[[[LZUserDataManager readCurrentUserInfo] objectForKey:@"notificaton"] objectForKey:@"selectoid"];
		NSString *sql = @"INSERT OR REPLACE INTO co_task_transfer(tid,uid,cid,oid)"
		"VALUES (?,?,?,?)";
		
        for (int i = 0; i< taskArray.count;  i++) {
            NSString *cid =[taskArray objectAtIndex:i];
			
            isOK = [db executeUpdate:sql,cid,uid,cid,oid];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
            *rollback = YES;
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_transfer" Sql:sql Error:@"插入失败" Other:nil];

            return;
        }
        
    }];

}

-(void)addTaskID:(NSString *)cid{
    
    [[self getDbQuene:@"co_task_transfer" FunctionName:@"addTaskID:(NSString *)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *uid=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
        NSString *oid=[[[LZUserDataManager readCurrentUserInfo] objectForKey:@"notificaton"] objectForKey:@"selectoid"];

        NSString *sql = @"INSERT OR REPLACE INTO co_task_transfer(tid,uid,cid,oid)"
        "VALUES (?,?,?,?)";
        isOK = [db executeUpdate:sql,cid,uid,cid,oid];

        if (!isOK) {
            DDLogError(@"插入失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_transfer" Sql:sql Error:@"插入失败" Other:nil];

        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    

}

/**
 *  根据oid删除关系数据
 *
 *  @param
 */
-(void)deleteTransferOid:(NSString*)oid{
    [[self getDbQuene:@"co_task_transfer" FunctionName:@"deleteTransferOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task_transfer where oid=?";
        isOK = [db executeUpdate:sql,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task_transfer" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

    
}

@end
