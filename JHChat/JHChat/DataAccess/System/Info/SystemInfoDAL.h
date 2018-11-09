//
//  SystemInfoDAL.h
//  LeadingCloud
//
//  Created by wchMac on 16/4/29.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-04-29
 Version: 1.0
 Description: 记录软件信息
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "SystemInfoModel.h"

@interface SystemInfoDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(SystemInfoDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createSystemInfoTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateSystemInfoTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  根据model添加数据
 *
 */
-(void)addDataWithSystemInfoModel:(SystemInfoModel *)errorModel;

#pragma mark - 删除数据

#pragma mark - 修改数据

/**
 *  更新value信息
 *
 *  @param systemInfoModel 信息Model
 */
-(void)updateVauleWithModel:(SystemInfoModel *)systemInfoModel;

#pragma mark - 查询数据

/**
 *  获取对象信息
 *
 *  @param key 主键值
 *
 *  @return Model
 */
-(SystemInfoModel *)getSystemInfoModelWithKey:(NSString *)key;

@end
