//
//  FavoriteTypeDAL.h
//  LeadingCloud
//
//  Created by dfl on 16/4/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-04-09
 Version: 1.0
 Description: 收藏类型数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "FavoriteTypeModel.h"

@interface FavoriteTypeDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(FavoriteTypeDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createFavoriteTypeTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateFavoriteTypeTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  文件收藏类型
 *
 *  @param FavoriteTypeModel 收藏文件类型的model
 */
-(void)addDataWithFavoriteTypeModel:(NSMutableArray*)favoriteTypeFileArray;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;

#pragma mark - 修改数据



#pragma mark - 查询数据

/**
 *  从收藏类型表中查询
 *
 *  @return 目标数组
 */
-(NSMutableArray*)selectAllFavoriteType;
/**
 *  从收藏类型表中查询  根据state
 *
 *  @return 目标数组
 */
-(NSMutableArray*)selectAllFavoriteTypeWithByState:(NSInteger)state;

/**
 *  根据收藏code 得到模型
 *
 *  @param type 动态code
 *
 *  @return
 */
- (FavoriteTypeModel*)getFavoriteType:(NSString*)type;

/**
 *  根据收藏主键ID 得到Code
 *
 *  @param type 动态code
 *
 *  @return
 */
-(NSString *)getFavoriteCodeWithByFtid:(NSString *)ftid;

/**
 *  根据收藏主键ID 得到模型
 *
 *  @param ftid
 *
 *  @return
 */
- (FavoriteTypeModel*)getFavoriteTypeWithByFtid:(NSString*)ftid;

@end
