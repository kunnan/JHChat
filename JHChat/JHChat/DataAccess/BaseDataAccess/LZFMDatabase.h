//
//  LZFMDatabase.h
//  LeadingCloud
//
//  Created by wchMac on 15/11/30.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "AppUtils.h"
#import "CommonAddErrorDalMessageModel.h"

static NSString * const LeadingCloudMain_Dubugger_DBVersion = @"_Debugger_V75";  //升级时不再需要修改

@class FMDatabase,FMDatabaseQueue;
@interface LZFMDatabase : NSObject

@property(nonatomic,strong) NSString *instanceUserIDTag;
@property(nonatomic,strong) NSString *instanceGUIDTag;

@property(nonatomic,strong) FMDatabase *dbBase;
@property(nonatomic,strong) FMDatabaseQueue *dataBaseQueue;
@property(nonatomic,strong) NSString *dbPath;

- (instancetype)initWithType:(NSString *)type;

/**
 *  获取数据库路径
 *
 *  @return sqlite数据库绝对路径
 */
+ (NSString *) getDbPath:(NSString *)type;

/**
 *  获取是否加密
 */
+(BOOL) getIsEncryption;

/**
 *  获取非线程安全的FMDatabase
 *
 *  @return 返回FMDatabase
 */
- (FMDatabase *)getDbBase;

/**
 *  获取线程安全的操作队列
 *
 *  @return 返回FMDatabaseQueue
 */
- (FMDatabaseQueue *)getDbQuene;
- (FMDatabaseQueue *)getDbQuene:(NSString *)type FunctionName:(NSString*)fName;


#pragma mark - 公用方法

/**
 *  判断是否已经创建某表
 *
 *  @param tableName 表名称
 *
 *  @return 是否已创建
 */
- (BOOL)checkIsExistsTable:(NSString *)tableName;

/**
 *  判断在某表中是否存在某个字段
 *
 *  @param tableName 表名
 *  @param fieldName 字段名
 *
 *  @return 是否存在
 */
- (BOOL)checkIsExistsFieldInTable:(NSString *)tableName fieldName:(NSString *)fieldName;
/**
 *  添加字段
 */
-(void)AddColumnToTableIfNotExist:(NSString *)tableName columnName:(NSString*)columnname type:(NSString*)type;

/**
 *  删除字段
 */
-(void)dropColumnToTableIfNotExist:(NSString *)tableName columnName:(NSString *)columnname;

@end
