//
//  AppMenuDAL.h
//  LeadingCloud
//
//  Created by dfl on 17/4/14.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2017-04-14
 Version: 1.0
 Description: 应用菜单数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "AppMenuModel.h"


@interface AppMenuDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AppMenuDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createAppMenuTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateAppMenuTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

-(void)addDataWithAppMenuArray:(NSMutableArray *)appMenuArray;

/**
 *  插入单条数据
 *
 *  @param model AppMenuModel
 */
-(void)addAppMenuModel:(AppMenuModel *)model;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;

/**
 * 根据orgid删除数据
 *
 *  @param orgid
 */
-(void)deleteAppMenuWithOrgid:(NSString*)orgid;

#pragma mark - 修改数据


#pragma mark - 查询数据

-(NSMutableArray *)getUserAllAppMenu;

-(NSMutableArray *)getUserAllAppMenuDic;

@end
