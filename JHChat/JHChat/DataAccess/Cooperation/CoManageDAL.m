//
//  CoManageDAL.m
//  LeadingCloud
//
//  Created by wang on 16/6/1.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoManageDAL.h"

@implementation CoManageDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoManageDAL *)shareInstance{
    static CoManageDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoManageDAL alloc] init];
    }
    return instance;
}

/**
 *  创建表
 */
-(void)createCoManageTableIfNotExists
{
    NSString *tableName = @"co_manage";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[cid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "[type][varchar](50) NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateCoMemberTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)mArray{
    
    [[self getDbQuene:@"co_manage" FunctionName:@"addDataWithArray:(NSMutableArray *)mArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_manage(cid,oid,type)"
		"VALUES (?,?,?)";
		
        for (int i = 0; i< mArray.count;  i++) {
            CoManageModel *mModel = [mArray objectAtIndex:i];
            NSString *cid = mModel.cid;
            NSString *oid = mModel.oid;
            NSString *type = mModel.type;
			
            isOK = [db executeUpdate:sql,cid,oid,type];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
            *rollback = YES;
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_manage" Sql:sql Error:@"插入失败" Other:nil];
            return;
        }
    }];
}

#pragma mark - 删除数据

/**
 *  根据oid删除
 *
 *  @param
 */
-(void)deleteMangeOid:(NSString *)oid type:(NSString*)type{
    
    [[self getDbQuene:@"co_manage" FunctionName:@"deleteMangeOid:(NSString *)oid type:(NSString*)type"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_manage where oid=? AND type=?";
        
        isOK = [db executeUpdate:sql,oid,type];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_manage" Sql:sql Error:@"删除失败" Other:nil];
            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

    
}

@end
