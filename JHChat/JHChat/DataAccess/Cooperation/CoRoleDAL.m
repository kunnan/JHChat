//
//  CoRoleDAL.m
//  LeadingCloud
//
//  Created by wang on 16/8/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoRoleDAL.h"

@implementation CoRoleDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoRoleDAL *)shareInstance{
    static CoRoleDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoRoleDAL alloc] init];
    }
    return instance;
}

/**
 *  创建表
 */
-(void)createCoRoleTableIfNotExists
{
    NSString *tableName = @"co_role";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-08-30日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[rid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[cid] [varchar](50) NULL,"
                                         "[uid][varchar](50) NULL);",
                                         tableName]];
        
    }
}


/**
 *  升级数据库
 */
-(void)updateCoRoleTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSArray *)mArray Cid:(NSString*)cid{
    
    [[self getDbQuene:@"co_role" FunctionName:@"addDataWithArray:(NSArray *)mArray Cid:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_role(rid,cid,uid)"
		"VALUES (?,?,?)";
		
        for (int i = 0; i< mArray.count;  i++) {
            NSString *rid = [LZUtils CreateGUID] ;
            NSString *uid = [mArray objectAtIndex:i];

            isOK = [db executeUpdate:sql,rid,cid,uid];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
            *rollback = YES;
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_role" Sql:sql Error:@"插入失败" Other:nil];

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
-(void)deleteCoRoleCid:(NSString *)cid{
    
    [[self getDbQuene:@"co_role" FunctionName:@"deleteCoRoleCid:(NSString *)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_role where cid=? ";
        
        isOK = [db executeUpdate:sql,cid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_role" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

- (NSMutableArray*)getRoleUidFromCid:(NSString*)cid{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"co_role" FunctionName:@"getRoleUidFromCid:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_role Where cid = %@",cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[resultSet stringForColumn:@"uid"]];
        }
        [resultSet close];
    }];
    
    return result;

    
}
@end
