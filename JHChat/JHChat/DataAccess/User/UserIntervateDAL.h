/************************************************************
 Author:  lz-fzj
 Date：   2016-03-01
 Version: 1.0
 Description: 【联系人】-【新的好友】数据库操作类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "UserIntervateModel.h"

#pragma mark - 【联系人】-【新的好友】数据库操作类
/**
 *  【联系人】-【新的好友】数据库操作类
 */
@interface UserIntervateDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserIntervateDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createUserContactTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateUserIntervateTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)userArray;

/**
 *  插入单条数据
 *
 *  @param model UserIntervateModel
 */
-(void)addUserIntervateModel:(UserIntervateModel *)model;

#pragma mark - 删除数据
/**
 *  清空所有数据
 */
-(void)deleteAllData;

/**
 *  根据uiid删除信息
 *  @param uiid
 */
-(void)deleteUserIntervateByUiId:(NSString *)uiid;


#pragma mark - 修改数据
/**
 *  更新邀请的【result】字段值
 *  @param resultValue 新的值
 *  @param uiid         主键id
 */
-(void)updateIntervateResultValue:(NSInteger)resultValue uiid:(NSString *)uiid;


#pragma mark - 查询数据
/**
 *  查询所有数据
 *  @return
 */
-(NSArray<UserIntervateModel *> *)getAllData;


/**
 *  获取新的好友数据
 *
 */
-(NSMutableArray *)getUserIntervateDataWithStartNum:(NSInteger)startNum End:(NSInteger)end;

/**
 *  根据用户id获取好友信息
 *  @param friendid 被邀请人用户id
 *  @return
 */
-(UserIntervateModel *)getUserIntervateByFriendId:(NSString *)friendid;

@end
