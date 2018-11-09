/************************************************************
 Author:  lz-fzj
 Date：   2016-02-29
 Version: 1.0
 Description: 【联系人】-【好友标签】数据库访问类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "UserContactGroupModel.h"
#import "UserContactGroupModel.h"

#pragma mark - 【联系人】-【好友标签】数据库访问类
/**
 *  【联系人】-【好友标签】数据库访问类
 */
@interface UserContactGroupDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserContactGroupDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createUserTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateUserContactGroupTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

-(void)addDataWithUserContactGroupArray:(NSMutableArray *)userArray;

/**
 *  添加单条
 *
 */
-(void)addUserContactGroupModel:(UserContactGroupModel *)model;

#pragma mark - 删除数据
/**
 *  清空所有数据
 */
-(void)deleteAllData;

/**
 *  根据TagId删除好友标签
 *  @param tagId 标签id（主键）
 */
-(void)deleteByUCGId:(NSString * )ucgId;


#pragma mark - 修改数据


#pragma mark - 查询数据

/**
 *  获取所有标签
 */
-(NSMutableArray *)getUserContactGroups;

/**
 *  根据标签id获取标签数据
 *  @param tagid
 *  @return
 */
-(UserContactGroupModel *)getUserContactGroupByTagId:(NSString *)ucgid;

/**
 *  根据标签id查询标签成员相关信息
 *
 *  @param ucgid tagid
 *
 *  @return arr
 */
-(NSMutableArray *)getUserContactGroupWithUserInfoByTagId:(NSString *)ucgid;

@end
