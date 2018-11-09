//
//  SysApiVersionDAL.h
//  LeadingCloud
//
//  Created by wchMac on 2017/9/25.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2017-09-25
 Version: 1.0
 Description: 服务器WebApi数据版本
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "LZFMDatabase.h"
#import "SysApiVersionModel.h"

@interface SysApiVersionDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(SysApiVersionDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createSysApiVersionTableIfNotExists;

/**
 *  升级数据库
 */
-(void)updateSysApiVersionTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithSysApiVersionArray:(NSMutableArray *)versionArray;

#pragma mark - 删除数据

#pragma mark - 修改数据

/**
 *  更新是否删除标识状态
 *
 *  @param contactid 联系人id
 */
-(void)updateServerVersionToClientVersionWithCode:(NSString *)code;

#pragma mark - 查询数据

/**
 *  获取对象信息
 *
 *  @param key 主键值
 *
 *  @return Model
 */
-(SysApiVersionModel *)getSysApiVersionModelWithCode:(NSString *)code;

/**
 *  获取所有数据
 */
-(NSMutableArray *)getAllSysApiVersion;

@end
