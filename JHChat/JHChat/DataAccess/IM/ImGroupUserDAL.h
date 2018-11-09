//
//  ImGroupUserDAL.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 分组成员数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "ImGroupUserModel.h"

@interface ImGroupUserDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImGroupUserDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImGroupUserTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateImGroupUserTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(BOOL)addDataWithImGroupUserArray:(NSMutableArray *)imGroupUserArray;

#pragma mark - 删除数据

/**
 *  删除群成员
 *
 *  @param igid 群ID
 *  @param uid  用户ID
 */
-(void)deleteGroupUserWithIgid:(NSString *)igid uid:(NSString *)uid;

/**
 *  批量删除群成员
 *
 *  @param igid 群ID
 *  @param uid  用户ID数组
 */
-(void)deleteGroupUserWithIgid:(NSString *)igid uidArr:(NSMutableArray *)uidArr;

#pragma mark - 修改数据

///**
// *  更新消息免打扰状态
// *
// *  @param igid 群ID
// *  @param role 状态
// */
//-(void)updateDisturbRole:(NSString *)igid role:(NSString *)role;

#pragma mark - 查询数据

/**
 *  获取群组下面的所有人员
 *
 *  @param igid 群组ID
 *
 *  @return 所有人员信息
 */
-(NSMutableArray *)getGroupUsersWithIgid:(NSString *)igid withNum:(NSInteger)num;

/**
 *  获取群组下面的所有人员ID
 *
 *  @param igid 群组ID
 *
 *  @return 所有人员ID
 */
-(NSMutableArray *)getGroupUserIDsWithIgid:(NSString *)igid;

/**
 *  获取群组下的人员数量
 *
 *  @param igid 群组ID
 *
 *  @return 人员数量
 */
-(NSInteger)getGroupUserCountWithIgid:(NSString *)igid;

/**
 *  获取群成员列表数据源
 *
 *  @param igid 群组ID
 *  @param hideUid 不需显示的人员ID
 *
 *  @return 字典
 */
-(NSMutableDictionary*)getGroupUsersListForAllWithIgid:(NSString *)igid hideUid:(NSString *)hideUid;

/**
 *  获取群成员列表数据源 - 未下载完
 *
 *  @param igid 群组ID
 *  @param conditon 条件
 *
 *  @return 字典
 */
-(NSMutableArray *)getGroupUsersListForNotGetAllWithIgid:(NSString *)igid conditon:(NSString *)condition;

/**
 *  根据Uid获取用户信息
 *
 *  @param uid UID
 *
 *  @return 用户信息
 */
-(ImGroupUserModel *)getGroupUserModelWithUid:(NSString *)uid;

///**
// *  判断此群对于当前用户是否为免打扰
// *
// *  @param igid 群ID
// *
// *  @return 是否免打扰
// */
//-(BOOL)checkCurrentUserIsDisturb:(NSString *)igid;

@end
