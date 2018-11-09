//
//  ImGroupDAL.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 分组数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "ImGroupUserModel.h"
#import "ContactRootSearchModel2.h"
#import "UIKit/UIKit.h"

@class ImGroupModel;
@interface ImGroupDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImGroupDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImGroupTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateImGroupTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithImGroupArray:(NSMutableArray *)imGroupArray;

/**
 *  批量数据
 */
-(BOOL)addImGroupModel:(ImGroupModel *)groupModel;

#pragma mark - 删除数据

/**
 *  清空所有群组及群组人员数据---（登录后删除旧数据）
 */
-(void)deleteAllShowGroup;

-(void)deleteAllShowGroupUser;

/**
 删除im_type为2的组群信息
 */
- (void)deleteGroupInfoImTypeIsTwo;
/**
 *  删除特定批次的群组及其人员数据---（登录后删除旧数据）
 */
-(void)deleteWithImGroupArray:(NSMutableArray *)imGroupArray;

/**
 *  删除群
 *
 *  @param igid 群ID
 */
-(BOOL)deleteGroupWithIgid:(NSString *)igid isDeleteImRecent:(BOOL)isdeleteimrecent;

/* 清空群聊数据和群成员数据 */
- (void)deleteGroupAndGroupUserData;

#pragma mark - 修改数据

/**
 *  更新群组名称
 *
 *  @param igid      群ID
 *  @param groupname 群名称
 *  @param isrename  是否为重命名
 */
-(void)updateGroupNameWithIgid:(NSString *)igid groupName:(NSString *)groupname isRename:(BOOL)isrename;

/**
 *  修改群管理员
 *
 *  @param uid  新管理员ID
 *  @param igid 群ID
 */
-(void)updateGroupCreateUser:(NSString *)uid groupid:(NSString *)igid;
/**
 *  修改群机器人
 *
 *  @param
 *  @param igid 群ID
 */
-(void)updateGroupGroupRobot:(NSString *)groupRobot groupid:(NSString *)igid;
/**
 *  添加群组人员加，添加数量
 */
-(void)updateGroupUserForAddCount:(NSInteger)newcount igid:(NSString *)igid;

/**
 *  减少群组人员加，减少的数量
 */
-(void)updateGroupUserForReduceCount:(NSInteger)reducecount igid:(NSString *)igid;

/**
 *  更新群组人员数量
 */
-(void)updateGroupUserCount:(NSInteger)usercount igid:(NSString *)igid;

/**
 *  打开、关闭群组
 */
-(void)updateGroupIsClosed:(NSInteger)isclosed igid:(NSString *)igid;

/**
 *  更新消息免打扰状态
 *
 *  @param igid 群ID
 *  @param role 状态
 */
-(void)updateDisturbRole:(NSString *)igid role:(NSInteger)role;

/**
 更新是否保存通讯录
 
 @param igid
 @param show
 */
- (void)updateIsSaveToAddress:(NSString *)igid show:(NSInteger)show;

/**
 更新其他群组为临时状态失败
 */
- (void)updateOtherGroupWithTempStatus;

/**
 *  更新新成员加入是否加载聊天记录
 *
 *  @param contactid 联系人id
 */
-(void)updateIsLoadMsg:(NSString *)igid state:(NSString *)isLoadMsg;

#pragma mark - 查询数据
/**
 *  获取所有的聊天群组
 *  @return
 */
-(NSArray<ImGroupModel *> *)getImGroups;

/**
 *  获取type为1的聊天群组
 *  @return
 */
-(NSArray<ImGroupModel *> *)getImGroupsTypeIsOne;

/**
 *  根据群组ID获取群组信息
 *
 *  @param igid 群组ID
 *
 *  @return 群信息Model
 */
-(ImGroupModel *)getImGroupWithIgid:(NSString *)igid;

/**
 *  根据工作组ID获取群组ID
 *
 *  @param gid 工作组ID
 *
 *  @return  群ID
 */
-(NSString *)getImGroupWithIgidFromWorkGroup:(NSString *)gid;

/**
 *  通过群组的ID获取每一个群组的成员ID
 *
 *  @param groupID 群组ID
 *
 *  @return 数组
 */
-(NSMutableArray<ImGroupUserModel *> *) getUserIDEveryGroup:(NSString *) groupID;
/**
 *  搜索群组
 *  @param seachText 搜索关键字
 *  @return
 */
-(NSMutableArray *)searchGroupWithSearchText:(NSString *)seachText;
/**
 *  搜索我的群组列表
 *  @param seachText 搜索关键字
 *  @return
 */
-(NSMutableArray<ImGroupModel *> *)searchGroupListBySearchText:(NSString *)seachText;

/**
 *  判断群组人员是否加载完
 */
-(BOOL)checkIsLoadAllUser:(NSString *)igid;

/**
 *  判断此群对于当前用户是否为免打扰
 *
 *  @param igid 群ID
 *
 *  @return 是否免打扰
 */
-(BOOL)checkCurrentUserIsDisturb:(NSString *)igid;

/**
 判断群聊是否保存到通讯录中
 
 @param igid
 @return
 */
- (BOOL)checkGroupIsSaveToAddress:(NSString *)igid;
/* 判断新成员加入是否需要加载消息 */
- (BOOL)checkIsLoadMsg:(NSString *)contactid;

@end
