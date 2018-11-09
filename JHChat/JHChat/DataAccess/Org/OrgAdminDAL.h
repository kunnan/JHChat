//
//  OrgAdminDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 管理员数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "OrgAdminModel.h"

@interface OrgAdminDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgAdminDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createOrgAdminTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateOrgAdminTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据
/**
 *  批量添加数据
 *  @param orgAdminArr
 */
-(void)addDataWithOrgAdminArray:(NSArray *)orgAdminArr;


#pragma mark - 删除数据



#pragma mark - 修改数据



#pragma mark - 查询数据



@end
