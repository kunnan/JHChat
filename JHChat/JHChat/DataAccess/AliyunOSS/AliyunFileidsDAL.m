//
//  AliyunFileidsDAL.m
//  LeadingCloud
//
//  Created by SY on 2017/7/14.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "AliyunFileidsDAL.h"
#import "AppDateUtil.h"
#import "AliyunOSS.h"
@implementation AliyunFileidsDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AliyunFileidsDAL *)shareInstance{
    static AliyunFileidsDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[AliyunFileidsDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createAliFileidsTableIfNotExists
{
    NSString *tableName = @"aliyun_fileids";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[fileid] [varchar](50) PRIMARY KEY NOT NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateAliFileidsTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 69:
            {
                [self AddColumnToTableIfNotExist:@"aliyun_fileids" columnName:@"[creatdate]" type:@"[date]"];
            }
                break;
                
            default:
                break;
        }
    }
}
#pragma mark - 添加数据

-(void)addAliFileids:(NSMutableArray*)fileids withDate:(NSDate*)creatDate{
    [[self getDbQuene:@"aliyun_fileids" FunctionName:@"addAliFileids:(NSMutableArray*)fileids withDate:(NSDate*)creatDate"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
 
        for (int i =0 ; i < fileids.count; i ++) {
            NSString *fileid = [fileids objectAtIndex:i];
            NSString *sql = @"INSERT OR REPLACE INTO aliyun_fileids(fileid,creatdate)"
            "VALUES (?,?)";
            
            isOK = [db executeUpdate:sql,fileid,creatDate];
            if (!isOK) {
                DDLogError(@"插入失败");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"aliyun_fileids" Sql:sql Error:@"插入失败" Other:nil];

                break;
            }
        }
    }];
    
    
}
#pragma mark - 删除数据
-(void)deleteFileidWithFileid:(NSString *) fileid{
    
    [[self getDbQuene:@"aliyun_fileids" FunctionName:@"deleteFileidWithFileid:(NSString *) fileid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from aliyun_fileids where fileid = ?";
        isOK = [db executeUpdate:sql,fileid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"aliyun_fileids" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}
-(void)deleteAllFileids{
    
    [[self getDbQuene:@"aliyun_fileids" FunctionName:@"deleteAllFileids"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from aliyun_fileids";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"aliyun_fileids" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}
#pragma mark - 查询数据
-(NSMutableArray*)getFileids {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"aliyun_fileids" FunctionName:@"getFileids"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From aliyun_fileids "];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[resultSet stringForColumn:@"fileid"]];
        }
        [resultSet close];
    }];
    
    return result;
}

-(NSDate*)getFileidsCreatdateWithFileid:(NSString*)fileid {
    
  __block  NSDate *result = [[NSDate alloc] init];
    
    [[self getDbQuene:@"aliyun_fileids" FunctionName:@"getFileidsCreatdateWithFileid:(NSString*)fileid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select creatdate From aliyun_fileids Where fileid = %@",fileid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            result = [resultSet dateForColumn:@"creatdate"];
        }
        [resultSet close];
    }];
    
    return result;
    
}
@end
