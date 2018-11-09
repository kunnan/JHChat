//
//  ErrorDAL.h
//  LeadingCloud
//
//  Created by dfl on 16/4/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-04-15
 Version: 1.0
 Description: 请求WebApi错误日志数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "ErrorModel.h"


@interface ErrorDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ErrorDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createErrorTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateErrorTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  根据model添加数据
 *
 */
-(void)addDataWithErrorModel:(ErrorModel *)errorModel;

/**
 *  根据model添加数据(自定义类型)
 */
-(void)addDataWithTitle:(NSString *)title data:(NSString *)data errortype:(NSInteger)errortype;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;

/**
 *  根据日志类型清空数据
 */
-(void)deleteDataWithErrorType:(NSInteger)errortype;

/**
 *  判断日志信息类型以及日志存储时间超过5天的数据，清空
 */
-(void)deleteDataWithErrorDateGTR5;

///**
// *  是否有超过5天的数据
// */
//-(BOOL)isDataWithErrorDateGTR5;

#pragma mark - 修改数据



#pragma mark - 查询数据

/**
 *  获取错误日志数据源
 *
 */
-(NSMutableArray *)getErrorDataWithUid:(NSString *)uid;


/**
 *  根据日志类型获取日志信息数据
 *
 */
-(NSMutableArray *)getErrorDataWithUid:(NSString *)uid ErrorType:(NSInteger )errortype;

/**
 *  获取错误日志数据详情
 *
 */
-(ErrorModel *)getErrorDataWithErrorid:(NSString *)errorid;

/**
 *  获取日志信息类型
 *
 */
-(NSMutableArray *)getErrorType;

@end

