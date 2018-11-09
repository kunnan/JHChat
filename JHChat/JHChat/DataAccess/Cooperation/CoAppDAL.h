//
//  CoAppDAL.h
//  LeadingCloud
//
//  Created by SY on 16/3/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-03-23
 Version: 1.0
 Description: 应用数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
@class CooAppModel;
@interface CoAppDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoAppDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createCooAppTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCooAppTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

-(void)addCooDataWithAppArray:(NSMutableArray *)appArray;

#pragma mark - 删除数据
/**
 *  删除应用
 *
 *  @param cid 协作id
 */
-(void)deleteAppDataWithCid:(NSString*)cid;

// 移除协作区单个应用
-(void)deleteAppDataWithCid:(NSString*)cid appid:(NSString*)appid;


#pragma mark - 修改数据
/**
 *  标记已经载入的工具
 *
 *  @param laodTag 0 or 1
 *  @param cid     协作id
 */
-(void)isDidLoad:(NSInteger)laodTag cid:(NSString*)cid;


#pragma mark - 查询数据

/**
 *  获取应用
 *  @return
 */
-(NSMutableArray *)getUserAllApp:(NSString*)cid;

/**
 *  根据AppCode获取CooAppModel
 *
 *  @param appcode 应用appCode
 *
 *  @return 应用信息
 */
-(CooAppModel *)getAppModelWithAppCode:(NSString *)appcode;
-(CooAppModel *)getAppModelWithAppCid:(NSString *)cid appid:(NSString*)appid;

@end
