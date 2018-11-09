//
//  AppBaseServerDAL.h
//  LeadingCloud
//
//  Created by dfl on 16/11/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-11-16
 Version: 1.0
 Description: 基础服务器配置数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "AppBaseServerModel.h"

@interface AppBaseServerDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AppBaseServerDAL *)shareInstance;

#pragma mark - 表结构操作
-(void)creatAppBaseServerTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updataAppBaseServerTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 批量添加服务器配置
 
 @param array array
 */
-(void)addAppBaseServerWithArray:(NSMutableArray*)array;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;

#pragma mark - 修改数据


#pragma mark - 查询数据

/**
 根据servergroup获取对应的Model
 */
-(AppBaseServerModel *)getAppBaseServerModelWithServerGroup:(NSString *)servergroup;

/**
 获取所有的AppBaseServerModel
 */
-(NSMutableArray *)getAllAppBaseServerModel;

@end
