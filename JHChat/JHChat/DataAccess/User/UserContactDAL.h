//
//  UserContactDAL.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/3.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 联系人数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "UserContactModel.h"

@interface UserContactDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserContactDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createUserContactTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateUserContactTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)userContactArray;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;

/**
 *  根据主键，删除记录
 *  @param ucId
 */
-(void)deleteUserContactByUCId:(NSString *)ucId;

/**
 *  根据用户ID，删除记录
 *  @param ctId
 */
-(void)deleteUserContactByCTId:(NSString *)ctId;


#pragma mark - 修改数据
/**
 *  更新联系人的【星标好友】标记
 *  @param isEspecially 是否是星标好友
 *  @param ucId 联系人id
 */
-(void)setContactEspeciallyValue:(Boolean) isEspecially ucId:(NSString *)ucId;

/**
 *  更新联系人的【星标好友】标记
 *  @param isEspecially 是否是星标好友
 *  @param ctId 好友id
 */
-(void)setContactEspeciallyValueByCtId:(Boolean) isEspecially ctId:(NSString *)ctId;


#pragma mark - 查询数据

/**
 *  根据用户id获取好友信息
 *  @param userId 用户id
 *  @return
 */
-(UserContactModel *)getUserContactByUId:(NSString *)userId;

/**
 *  获取好友(分组模式)
 */
-(NSMutableDictionary *)getFriendUserGroupModel;

@end
