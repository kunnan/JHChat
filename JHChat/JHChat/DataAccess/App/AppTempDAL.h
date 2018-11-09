//
//  AppTempDAL.h
//  LeadingCloud
//
//  Created by wchMac on 2016/12/8.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
#import "AppModel.h"

@interface AppTempDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AppTempDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createAppTempTableIfNotExists;

-(void)updateAppTempTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据

/**
 *  插入单条数据
 *
 *  @param model AppModel
 */
-(void)addAppModel:(AppModel *)model;

#pragma mark - 删除数据



#pragma mark - 修改数据

/**
 *  修改状态值
 */
-(void)updateAppTempType;

#pragma mark - 查询数据

/**
 *  根据AppCode获取AppModel
 *
 *  @param appcode 应用appCode
 *
 *  @return 应用信息
 */
-(AppModel *)getAppModelWithAppCode:(NSString *)appcode temptype:(NSString *)temptype;

@end
