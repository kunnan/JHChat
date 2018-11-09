//
//  CoProjectMainModsDAL.h
//  LeadingCloud
//
//  Created by dfl on 16/10/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   16/10/28
 Version: 1.0
 Description: 项目模块
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "CoProjectModsModel.h"

@interface CoProjectMainModsDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoProjectMainModsDAL *)shareInstance;
#pragma mark - 表结构操作
-(void)creatProjectMainModsTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updataCoProjectMainModsTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 批量添加项目模块
 
 @param array array
 */
-(void)addProjectMainModsWithArray:(NSMutableArray*)array;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;

/**
 *  根据项目id删除指定项目下的模块
 */
-(void)deleteProjectMainModsWithPrid:(NSString*)prid;

#pragma mark - 修改数据


#pragma mark - 查询数据

/**
 查询当前项目下模块
 
 @param prid   当前项目id
 
 @return 模块数组
 */
-(NSMutableArray*)getProjectMainModsWithPrid:(NSString*)prid;

@end
