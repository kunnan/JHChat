//
//  UserInfoDAL.h
//  LeadingCloud
//
//  Created by dfl on 16/6/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-06-30
 Version: 1.0
 Description: 用户个人信息数据库操作类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "UserInfoModel.h"

@interface UserInfoDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserInfoDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createUserInfoTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateUserInfoTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  插入单条数据
 *
 *  @param model UserInfoModel
 */
-(void)addUserInfoModel:(UserInfoModel *)model;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;

#pragma mark - 修改数据



#pragma mark - 查询数据

-(UserInfoModel *)getUserDataWithUid:(NSString *)uid;

@end

