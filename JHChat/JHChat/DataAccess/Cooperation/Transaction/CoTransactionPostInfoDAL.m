//
//  CoTransactionPostInfoDAL.m
//  LeadingCloud
//
//  Created by wang on 16/10/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoTransactionPostInfoDAL.h"

@implementation CoTransactionPostInfoDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoTransactionPostInfoDAL *)shareInstance{
    
    static CoTransactionPostInfoDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoTransactionPostInfoDAL alloc] init];
    }
    return instance;
    

}

/**
 *  创建表
 */
-(void)createCoTransactionPostInfoTableIfNotExists{
    
    NSString *tableName = @"co_transaction_post";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-10-26日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[postid] [varchar](50) NULL,"
                                         "[name] [varchar](200) NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "constraint pk_t2 primary key (postid,oid));",
                                         tableName]];
        
    }

}
/**
 *  升级数据库
 */
-(void)updateCoTransactionPostInfoTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }

}

#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)postInfoArray Orgid:(NSString*)oid{
    
    [[self getDbQuene:@"co_transaction_post" FunctionName:@"addDataWithArray:(NSMutableArray *)postInfoArray Orgid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_transaction_post(postid,name,oid)"
		"VALUES (?,?,?)";
		
        for (int i = 0; i< postInfoArray.count;  i++) {
            CoTransactionPostInfoModel *cmodel =[postInfoArray objectAtIndex:i];
		
            isOK = [db executeUpdate:sql,cmodel.postid,cmodel.name,oid];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_transaction_post" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];

}

#pragma mark - 删除数据
/**
 *  根据企业id删除所有岗位信息
 *
 *  @param
 */
-(void)deleteAllPostInfoOid:(NSString*)oid{
    
    [[self getDbQuene:@"co_transaction_post" FunctionName:@"deleteAllPostInfoOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_transaction_post where oid=?";
        isOK = [db executeUpdate:sql,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_transaction_post" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

#pragma mark - 查询数据
/**
 得到所以岗位信息
 *  @param oid      企业ID
 */
-(NSMutableArray*)getPostInfoArrOId:(NSString*)oid{
    
    NSMutableArray *result = [NSMutableArray array];
    [[self getDbQuene:@"co_transaction_post" FunctionName:@"getPostInfoArrOId:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_transaction_post Where oid=%@",oid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            NSString *postid = [resultSet stringForColumn:@"postid"];
            NSString *name = [resultSet stringForColumn:@"name"];
            
            CoTransactionPostInfoModel *model=[[CoTransactionPostInfoModel alloc]init];
            model.name = name;
            model.postid=postid;
            [result addObject:model];
        }
        [resultSet close];
    }];
    
    return result;

}



@end
