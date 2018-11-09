//
//  SelfAppDAL.h
//  LeadingCloud
//
//  Created by dfl on 17/4/14.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2017-04-14
 Version: 1.0
 Description: 自建应用数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "SelfAppModel.h"

@interface SelfAppDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(SelfAppDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createSelfAppTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateSelfAppTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

-(void)addDataWithSelfAppArray:(NSMutableArray *)selfAppArray;

/**
 *  插入单条数据
 *
 *  @param model SelfAppModel
 */
-(void)addSelfAppModel:(SelfAppModel *)model;

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
-(void)deleteSelfAppWithOrgid:(NSString*)orgid;

#pragma mark - 修改数据


#pragma mark - 查询数据

-(NSMutableArray *)getUserAllSelfApp;

/**
 *  根据id获取SelfAppModel
 *
 *  @param osappid 应用osappid
 *
 *  @return 应用信息
 */
-(SelfAppModel *)getSelfAppModelWithOsAppId:(NSString *)osappid;

@end
