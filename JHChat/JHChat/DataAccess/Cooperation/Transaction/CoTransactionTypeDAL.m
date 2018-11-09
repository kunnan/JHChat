//
//  CoTransactionTypeDAL.m
//  LeadingCloud
//
//  Created by wang on 16/10/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoTransactionTypeDAL.h"

@implementation CoTransactionTypeDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoTransactionTypeDAL *)shareInstance{
    
    static CoTransactionTypeDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoTransactionTypeDAL alloc] init];
    }
    return instance;

}

/**
 *  创建表
 */
-(void)createCoTransactionTypeTableIfNotExists{
    NSString *tableName = @"co_transaction_type";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-10-28日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[ttid] [varchar](50) NULL,"
                                         "[name] [varchar](200) NULL,"
                                         "[descript] [text] NULL,"
                                         "[handler] [text] NULL,"
                                         "[appid] [varchar](50) NULL,"
                                         "[toolid] [varchar](50) NULL,"
                                         "[isshowcommontool] [integer] NULL);",
                                         tableName]];
        
    }

}
/**
 *  升级数据库
 */
-(void)updateCoTransactionTypeTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    
}

#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)typeArr{
    
    [[self getDbQuene:@"co_transaction_type" FunctionName:@"addDataWithArray:(NSMutableArray *)typeArr"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_transaction_type(ttid,name,descript,handler,appid,toolid,isshowcommontool)"
		"VALUES (?,?,?,?,?,?,?)";
		
        for (int i = 0; i< typeArr.count;  i++) {
            CoTransactionTypeModel *tModel = [typeArr objectAtIndex:i];
            
            NSString *ttid = tModel.ttid;
            NSString *name = tModel.name;
            NSString *descript = tModel.descript;
            NSString *handler = tModel.handler;
            NSString *appid = tModel.appid;
            NSString *toolid = tModel.toolid;
            NSNumber *isshowcommontool = [NSNumber numberWithInteger:tModel.isshowcommontool];

            isOK = [db executeUpdate:sql,ttid,name,descript,handler,appid,toolid,isshowcommontool];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_transaction_type" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];

}

#pragma mark - 删除数据
/**
 *  删除所有的类型
 *
 *  @param
 */
-(void)deleteAllModel{
    [[self getDbQuene:@"co_transaction_type" FunctionName:@"deleteAllModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_transaction_type ";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_transaction_type" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}


#pragma mark - 查询数据

/**
 *  根据ttid获取对应的模板信息
 */
-(CoTransactionTypeModel *)getTransactionModelTtid:(NSString *)ttid
{
    
    __block CoTransactionTypeModel *typeModel = nil;
    
    [[self getDbQuene:@"co_transaction_type" FunctionName:@"getTransactionModelTtid:(NSString *)ttid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM co_transaction_type WHERE ttid=?"];
        FMResultSet *resultSet=[db executeQuery:sql,ttid];
        if ([resultSet next]) {

            typeModel = [[CoTransactionTypeModel alloc]init];
            
            NSString *ttid = [resultSet stringForColumn:@"ttid"];
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *descript = [resultSet stringForColumn:@"descript"];
            NSString *handler = [resultSet stringForColumn:@"handler"];
            NSString *appid = [resultSet stringForColumn:@"appid"];
            NSString *toolid = [resultSet stringForColumn:@"toolid"];
            NSInteger isshowcommontool = [resultSet intForColumn:@"isshowcommontool"];
            
            typeModel.ttid = ttid;
            typeModel.name = name;
            typeModel.descript = descript;
            typeModel.handler = handler;
            typeModel.appid = appid;
            typeModel.toolid = toolid;
            typeModel.isshowcommontool = isshowcommontool;
        }
        [resultSet close];
    }];
    
    return typeModel;
}

@end
