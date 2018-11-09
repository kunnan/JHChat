//
//  AppDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 应用数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "AppModel.h"

@interface AppDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AppDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createAppTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateAppTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

-(void)addDataWithAppArray:(NSMutableArray *)appArray;

/**
 *  插入单条数据
 *
 *  @param model AppModel
 */
-(void)addAppModel:(AppModel *)model;

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
-(void)deleteAppWithOrgid:(NSString*)orgid;

#pragma mark - 修改数据

/**
 *  修改排序id
 */
-(void)updateAppWithSortid:(NSString *)sortid appid:(NSString *)appid;

/**
 *  修改提醒数字
 */
-(void)updateAppWithRemindNumber:(NSInteger )remindnumber appid:(NSString *)appid;

#pragma mark - 查询数据

/**
 *  获取所有应用
 *  @return
 */
-(NSMutableArray *)getUserAllApp;

-(NSMutableArray *)getUserAllApp1;

/**
 *  根据AppCode获取AppModel
 *
 *  @param appcode 应用appCode
 *
 *  @return 应用信息
 */
-(AppModel *)getAppModelWithAppCode:(NSString *)appcode;

/**
 *  根据appid获取AppModel
 *
 *  @param appid 应用appid
 *
 *  @return 应用信息
 */
-(AppModel *)getAppModelWithAppId:(NSString *)appid;


/**
 *  获取提醒数量
 *
 *  @return 数量
 */
-(NSInteger)getRemindNumber;

@end
