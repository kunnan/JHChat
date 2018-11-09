//
//  OrgDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 组织数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "OrgModel.h"

@interface OrgDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createOrgTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateOrgTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithOrgArray:(NSMutableArray *)allOrgArr;

#pragma mark - 删除数据



#pragma mark - 修改数据



#pragma mark - 查询数据

@end
