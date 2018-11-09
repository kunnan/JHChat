//
//  UserDAL.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 用户数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "UserModel.h"
#import "ContactRootSearchModel2.h"
#import "UIKit/UIKit.h"

@interface UserDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createUserTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateUserTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

-(void)addDataWithUserArray:(NSMutableArray *)userArray;

/**
 *  插入单条数据
 *
 *  @param model UserModel
 */
-(void)addUserModel:(UserModel *)userModel;

#pragma mark - 删除数据



#pragma mark - 修改数据

-(void)updateUserWithUid:(UserModel *)userModel;
/** 修改昵称 */
-(void)updateUserWithUid:(UserModel *)userModel userName:(NSString *)username;
/** 修改性别 */
-(void)updateUserWithUid:(UserModel *)userModel userSex:(NSInteger)gender;
/** 修改地区 */
-(void)updateUserWithUid:(UserModel *)userModel province:(NSString *)province city:(NSString *)city county:(NSString *)county;
/** 修改生日 */
-(void)updateUserWithUid:(UserModel *)userModel userBirthday:(NSDate *)birthday;
/** 修改头像 */
-(void)updateUserWithUid:(UserModel *)userModel userFace:(NSString *)face;
/** 修改办公电话 */
-(void)updateUserWithUid:(UserModel *)userModel officecall:(NSString *)officecall;
/** 修改详细地址 */
-(void)updateUserWithUid:(UserModel *)userModel address:(NSString *)address;

/**
 *  更改所有表中的用户信息
 */
-(void)updateAllTableUserInfo:(UserModel *)userModel;


#pragma mark - 查询数据

/**
 *  获取我的资料数据
 *
 */
-(UserModel *)getUserDataWithUid:(NSString *)uid;

/**
 *  用户用户姓名和头像ID
 *
 *  @param uid 用户ID
 *
 *  @return 用户信息
 */
-(UserModel *)getUserModelForNameAndFace:(NSString *)uid;

/**
 *  得到所有联系人的手机号
 *
 *  @return 用户模型
 */
-(NSMutableArray<UserModel *> *)getUserMobileOfAll;

#pragma mark - 转换
/**
 *  搜索【我的好友】
 *  @param searchText 过滤条件
 *  @return 搜索结果
 */
-(NSMutableArray *)searchFriendList:(NSString *)searchText;

/**
 *  搜索【我的好友】
 *  @param searchText 过滤条件
 *  @return 搜索结果
 */
-(NSMutableArray *)searchFriendListForContactFriend:(NSString *)searchText;

/**
 *  将数据库结果集转换为Model
 *  @param resultSet
 *  @return
 */
-(UserModel *)convertResultSet2Model:(FMResultSet *)resultSet;

@end
