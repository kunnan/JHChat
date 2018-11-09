//
//  LZFMDatabase.m
//  LeadingCloud
//
//  Created by wchMac on 15/11/30.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "LZFMDatabaseQueue.h"
#import "FilePathUtil.h"
#import "LZUserDataManager.h"
#import "NSString+IsNullOrEmpty.h"

@implementation LZFMDatabase

- (instancetype)init
{
    return [self initWithType:@""];
}

- (instancetype)initWithType:(NSString *)type
{
    /* 判断是否含有数据库 */
    BOOL isCreate = false;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![NSString isNullOrEmpty:[AppUtils GetCurrentUserID]]
        && [fm fileExistsAtPath:[LZFMDatabase getDbPath:type]]) {
        isCreate = YES;
    }
    if(!isCreate){
        return nil;
    }
    
    _instanceUserIDTag = [AppUtils GetCurrentUserID];
    _instanceGUIDTag = [LZUserDataManager getDBGuidTag];
    
    self = [super init];
    if (self) {
        self.dbBase = [FMDatabase databaseWithPath: [LZFMDatabase getDbPath:type] ];
        self.dbBase.isEncryption = [LZFMDatabase getIsEncryption]; //是否加密
        self.dbPath = [LZFMDatabase getDbPath:type];
        self.dataBaseQueue = [LZFMDatabaseQueue shareInstance:[LZFMDatabase getDbPath:type] isEncryption:[LZFMDatabase getIsEncryption] type:type].dbQueue;
    }
    return self;
}

/**
 *  获取数据库路径
 *
 *  @return sqlite数据库绝对路径
 */
+ (NSString *) getDbPath:(NSString *)type {
    NSString *appendType = @"";
    #ifdef DEBUG
        appendType = LeadingCloudMain_Dubugger_DBVersion;
    #else
    #endif
    
    NSString *dbFileName = [NSString stringWithFormat:@"%@%@.db",@"LeadingCloudMain_PT3",appendType];
//    if([type isEqualToString:LeadingCloudError_Type]){
//        dbFileName = [NSString stringWithFormat:@"%@%@.db",@"LeadingCloudError_PT3",appendType];
//    }
    NSString *dbFilePath = [[FilePathUtil getDbDicPath] stringByAppendingFormat:@"%@",dbFileName];
    return dbFilePath;
}

/**
 *  获取是否加密
 */
+(BOOL) getIsEncryption {
    #ifdef DEBUG
        //debug模式不进行加密
        return NO;
    #else
        return YES;
    #endif
}

/**
 *  获取非线程安全的FMDatabase
 *
 *  @return 返回FMDatabase
 */
- (FMDatabase *)getDbBase {
    if (![self.dbBase open]){
        DDLogError(@"OPEN FAIL");
    }
    
    return self.dbBase;
}

/**
 *  获取线程安全的操作队列
 *
 *  @return 返回FMDatabaseQueue
 */
- (FMDatabaseQueue *)getDbQuene {
	return [self getDbQuene:@""FunctionName:@""];
}
- (FMDatabaseQueue *)getDbQuene:(NSString *)type FunctionName:(NSString*)fName {
//    NSString *dbPath = [LZFMDatabase getDbPath:type];
//    FMDatabaseQueue *dataBaseQueue = [LZFMDatabaseQueue shareInstance:dbPath isEncryption:[LZFMDatabase getIsEncryption] type:type].dbQueue;
//    //    dataBaseQueue.isEncryption = [self getIsEncryption]; //是否加密
//
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了数据库的操作\n tableName:%@\nFunctionName:%@",type,fName);
        }
    #else
    #endif
//
//    return dataBaseQueue;
    
    return self.dataBaseQueue;
}

#pragma mark - 公用方法

/**
 *  判断是否已经创建某表
 *
 *  @param tableName 表名称
 *
 *  @return 是否已创建
 */
- (BOOL)checkIsExistsTable:(NSString *)tableName{
    BOOL result = NO;
    
    if (![self.dbBase open]){
        NSLog(@"OPEN FAIL");
    }
    
    FMResultSet *resultSet = [self.dbBase executeQuery:@"SELECT COUNT(*)  as CNT FROM sqlite_master where type='table' and name= ? ", tableName];
    
    if ([resultSet next]) {
        int totalCount = [resultSet intForColumnIndex:0];
        if(totalCount >0 ){
            result = YES;
        }
    }
    
    [self.dbBase close];
    
    return result;
}
/**
 *  判断在某表中是否存在某个字段
 *
 *  @param tableName 表名
 *  @param fieldName 字段名
 *
 *  @return 是否存在
 */
- (BOOL)checkIsExistsFieldInTable:(NSString *)tableName fieldName:(NSString *)fieldName {
    BOOL result = NO;
    
    if (![self.dbBase open]){
        NSLog(@"OPEN FAIL");
    }   
    
    FMResultSet *resultSet = [self.dbBase executeQuery:@"select sql from sqlite_master where name= ? ",tableName];
    if ([resultSet next]) {
        NSString *SQL = [resultSet stringForColumn:@"sql"];
        
        if ([SQL rangeOfString:[NSString stringWithFormat:@"[%@]",fieldName]].location != NSNotFound) {
            result = YES;
        }
    }
    [self.dbBase close];
    
    return result;
}
/**
 *  添加字段
 */
-(void)AddColumnToTableIfNotExist:(NSString *)tableName columnName:(NSString*)columnname type:(NSString*)type{
	[[self getDbQuene:tableName FunctionName:@"AddColumnToTableIfNotExist:(NSString *)tableName columnName:(NSString*)columnname type:(NSString*)type"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = [NSString stringWithFormat:@"Alter Table %@ Add column %@ %@",tableName,columnname,type];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
            DDLogError(@"添加字段 - AddColumnToTableIfNotExist");
        }
    }];
}

/**
 *  删除字段
 */
-(void)dropColumnToTableIfNotExist:(NSString *)tableName columnName:(NSString *)columnname{
	[[self getDbQuene:tableName FunctionName:@"dropColumnToTableIfNotExist:(NSString *)tableName columnName:(NSString *)columnname"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = [NSString stringWithFormat:@"Alter Table %@ drop column %@",tableName,columnname];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
            DDLogError(@"添加字段 - AddColumnToTableIfNotExist");
        }
    }];
}

@end
