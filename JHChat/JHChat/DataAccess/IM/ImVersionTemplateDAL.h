//
//  ImVersionTemplateDAL.h
//  LeadingCloud
//
//  Created by wchMac on 16/8/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-08-16
 Version: 1.0
 Description: 消息模板版本表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "LZFMDatabase.h"
#import "ImVersionTemplateModel.h"

@interface ImVersionTemplateDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImVersionTemplateDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImVersionTemplateTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateImVersionTemplateTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithImVersionTemplateArray:(NSMutableArray *)imMsgTemplate;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllDataVersionTemplate;

#pragma mark - 修改数据



#pragma mark - 查询数据

/**
 *  根据tvid获取对应的模板信息
 */
-(ImVersionTemplateModel *)getImVersionTemplateModelWithTemplate:(NSInteger)tvid;

/**
 *  获取所有的模板信息
 */
-(NSArray<ImVersionTemplateModel *> *)getAllImVersionTemplateModel;

/**
 *  获取模板信息数量
 */
-(NSInteger)getImVersionTemplateCount;
@end
