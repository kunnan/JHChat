//
//  FavoritesDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 收藏数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "FavoritesModel.h"

@interface FavoritesDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(FavoritesDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createFavoritesTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateFavoritesTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据
/**
 *  文件收藏
 *
 *  @param favoriteFileModel 收藏文件的model
 */
-(void)addDataWithFavoriteModel:(FavoritesModel*)favoriteFileModel;

/**
 *  文件收藏列表
 *
 *  @param favoriteFileModel 收藏文件的model
 */
-(void)addDataWithFavoriteArray:(NSMutableArray*)favoriteFileArray;
#pragma mark - 删除数据
/**
 *  取消收藏
 *
 *  @param collectionId 收藏id
 */
-(void)deleteDidCollectionFile:(NSString*)collectionId;
/**
 * 删除指定类型
 *
 *  @param collectionId 收藏类型
 */
-(void)deleteResCollectionFile:(NSString*)favoritestype;
/**
 *  删除所有数据 是本地数据与web端保持一致
 */
-(void)deleteAllDidCollectionFile;

-(void)deleAllFavoritesWithByType:(NSInteger)type;
#pragma mark - 修改数据



#pragma mark - 查询数据
/**
 *  从收藏表中查询目标id(是文件的rid,用于展示已收藏的文件)
 *
 *  @return 目标id数组
 */
-(NSMutableArray*)selectAllObjectId:(NSString*)favoritetype;
/**
 *  通过收藏文件的objectid查询到该文件的日期
 *
 *  @param fileRid 文件的rid
 *
 *  @return 日期
 */
-(FavoritesModel*)getcollectionDate:(NSString*)fileRid;

/**
 *  从收藏表中查询目标id(是文件的rid)
 *  startNum 数组开始数
 *  count 总个数
 *  state 类型
 *  type 收藏类型
 *  @return 目标id数组
 */
-(NSMutableArray*)selectAllStartNum:(NSInteger)startNum Count:(NSInteger)count state:(NSInteger)state type:(NSString *)type;

/**
 *  从收藏表中查询目标id(是文件的rid)(类型查找)
 *
 *  @return 目标id数组
 */
-(NSMutableArray*)selectTypeAllStartNum:(NSInteger)startNum Count:(NSInteger)count Type:(NSString *)type;

/**
 *  搜索收藏信息
 *
 *  @param searchText 搜索文本
 *
 *  @return 搜索结果
 */
-(NSMutableArray *)getFavoriteForSearch:(NSString *)searchText StartNum:(NSInteger)startNum Count:(NSInteger)count;

/**
 *  搜索收藏信息(类型)
 *
 *  @param searchText 搜索文本
 *
 *  @return 搜索结果
 */
-(NSMutableArray *)getFavoriteForSearch:(NSString *)searchText StartNum:(NSInteger)startNum Count:(NSInteger)count Type:(NSString *)type;

/**
 *  搜索收藏信息(类型)
 *
 *  @param searchText 搜索文本
 *
 *  @return 搜索结果
 */
-(NSMutableArray *)getFavoriteForSearch:(NSString *)searchText StartNum:(NSInteger)startNum Count:(NSInteger)count Type:(NSString *)type state:(NSInteger)state;

@end
