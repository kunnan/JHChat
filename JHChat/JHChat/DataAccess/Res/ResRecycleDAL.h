//
//  ResRecycleDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 资源回收站数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"

@interface ResRecycleDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResRecycleDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createResRecycleTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateResRecycleTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加已删除的数据
 */

-(void)addRecycleDataWithArray:(NSMutableArray*)recycleArray;

#pragma mark - 删除数据

/**
 *  删除回收站文件
 *
 *  @param recyid 文件id 主键
 */
-(void) deleRecycleFile:(NSString *)recyid;
/**
 *  删除回收站文件
 *
 *  @param recyid 文件id 主键
 */
-(void) deleAllRecycleFile:(NSString *)recyid;

#pragma mark - 修改数据

/**
 *  更新所有下的资源数量
 *
 *  @param iscacheall 是否缓存完所有资源
 *  @param classid    文件夹ID
 */
-(void)updateIsCacheAllRecycle:(NSInteger)iscacheall withClassid:(NSString *)classid;

#pragma mark - 查询数据

/**
 *  获取此文件夹下的资源是否缓存完
 */
- (BOOL)checkIsCacheAllDataWithClassid:(NSString *)classid;

/**
 *  获取资源列表
 *
 *  @param classid  文件夹ID
 *  @param start    起始条目
 *  @return 资源记录数组
 */
-(NSMutableArray * ) getRecycleDataWithClassid:(NSString *)classid startNum:(NSInteger)start queryCount:(NSInteger)count;

/**
 *  获取所有数据
 */
-(NSMutableArray * ) getAllRecycleData;

/**
 *  获取数据
 */
-(NSMutableArray * ) getRecycleData:(NSString *)recyid;

@end
