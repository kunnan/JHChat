//
//  ImRecentDAL.h
//  LeadingCloud
//
//  Created by wchMac on 15/11/30.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 最近消息数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"

@class ImRecentModel;
@interface ImRecentDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImRecentDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImRecentTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateImRecentTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithImRecentArray:(NSMutableArray *)imRecentArray;

/**
 *  添加单条数据
 */
-(BOOL)addImRecentWithModel:(ImRecentModel *)recentModel isAddIfExists:(BOOL)isAddIfExists;

#pragma mark - 删除数据

/**
 *  根据Contactid删除最近联系人记录
 *
 *  @param contactid contactid
 */
-(void)deleteImRecentModelWithContactid:(NSString *)contactid;

#pragma mark - 修改数据

/**
 *  更新最近联系人信息
 *
 *  @param dialogid 聊天框ID
 */
-(BOOL)updateLastMsgWithDialogid:(NSString *)dialogid;

/**
 更新最近联系人
 
 @param dic
 */
- (void)updatelastMessageWithDic:(NSDictionary *)dic isOnlyOneMsg:(BOOL)isOnlyOneMsg;
/**
 *  向某个聊天框，追加未读数量
 *
 *  @param newcount  新未读数量
 *  @param contactid 联系人id
 */
-(void)updateBadgeForAddCount:(NSInteger)newcount contactid:(NSString *)contactid;

/**
 *  新的好友，组织等数据
 *
 *  @param newcount  新未读数量
 *  @param contactid 联系人id
 */
-(void)updateBadgeForNews:(NSInteger)newcount model:(ImRecentModel *)recentModel;

/**
 *  更新是否有新的@消息
 *
 *  @param isRemind  是否提醒我
 *  @param contactid 联系人id
 */
-(void)updateIsRemindMe:(BOOL)isRemind contactid:(NSString *)contactid;

/**
 更新是否有回执消息
 
 @param isRecordMsg
 @param contactid
 */
- (void)updateIsRecordMsg:(BOOL)isRecordMsg contactid:(NSString *)contactid;

/**
 *  将某聊天框，未读数量更改为0
 *
 *  @param contactid 联系人id
 */
-(BOOL)updateBadgeCountTo0ByContactid:(NSString *)contactid;

/**
 *  将某聊天框，未读数量减一
 *
 *  @param contactid 联系人id
 */
-(void)updateBadgeCountMinus1ByContactid:(NSString *)contactid;

/**
 *  更新是否删除标识状态
 *
 *  @param contactid 联系人id
 */
-(void)updateIsDelContactid:(NSMutableArray *)contactidArr;

/**
 *  更新联系人置顶
 *
 *  @param contactid 联系人id
 */
-(void)updateSetStick:(NSString *)recentid state:(NSString *)state;

/**
 *  更新联系人置顶
 *
 *  @param contactid 联系人id
 */
-(void)updateSetIsOneDisturb:(NSString *)recentid state:(NSString *)state;

/**
 *  更新当前人是否在群组中
 */
-(void)updateIsExistsGroupWithIgid:(NSString *)contactid isexistsgroup:(NSInteger)isexistsgroup;

/**
 *  更新最近联系人的Tile和头像
 *
 *  @param contactid 联系人
 */
-(void)updateContactNameAndRelattypeAndFace:(NSString *)contactid;

/**
 *  更新Synck
 *
 */
-(void)updateSynck:(NSString *)contactid syncKey:(NSString *)synck syncKeyDate:(NSDate *)date;

/**
 *  更新Synck
 *
 */
-(void)updateSynckToNil;

/**
 更新群信息最后发送人姓名
 */
-(void)updateAllLastMsgUsernam;

/**
 更新最后发送人姓名
 */
-(void)updateLastMsgUsernam:(NSString *)username userid:(NSString *)userid;

/* 根据对话框ID将最后一条消息的lastmsguser清空 */
- (void)updateLastMsgUserToNullByContactID:(NSString *)contactid;

/* 撤回之后，根据msgid更新lastMsgid */
- (void)updateLastMsgIDWithMsgid:(NSString *)msgid ContactID:(NSString *)contactid;

/* 更新消息内容为空 */
- (void)updateMsgToNull:(NSString *)contactid;

#pragma mark - 查询数据

/**
 *  获取消息列表数量
 */
-(NSInteger)getImRecentMsgCount;
/**
 *  获取可显示的Contactids
 *
 *  @return 数组
 */
-(NSMutableArray *)getContactIDsArray;
/**
 *  获取不包含该人的组群
 *  @return
 */
-(NSArray<ImRecentModel *> *)getNoExistGroups;
/**
 *  获取消息列表数据
 *
 *  @return 消息列表数组
 */
-(NSMutableArray *)getImRecentList:(NSString *)selectGUID;

/**
 *  获取消息列表选择数据
 *
 *  @return 消息列表数组
 */
-(NSMutableArray *)getImRecentSelectList;

/**
 *  获取未读消息总数量
 *
 *  @return 数量
 */
-(NSInteger)getImRecentNoReadMsgCount;
-(NSInteger)getImRecentNoReadMsgCountWithExceptDialog:(NSArray *)dialogArr;

/**
 *  根据Contactid模糊查询获取Contactid
 *
 *  @param contactid 联系人ID
 *
 *  @return 数组
 */
-(NSMutableArray *)getImRecentContactidWithContactid:(NSString *)contactid;

/**
 *  根据Contactid获取ImRecentModel
 *
 *  @param contactid 联系人ID
 *
 *  @return ImRecentModel
 */
-(ImRecentModel *)getRecentModelWithContactid:(NSString *)contactid;

/**
 *  根据Contactid获取ImRecentModel
 *
 *  @param contactid 联系人ID
 *  @param contactid 关联群组ID
 *  @return ImRecentModel
 */
-(ImRecentModel *)getRecentModelWithLikeContactid:(NSString *)contactid targetid:(NSString *)targetid;

/**
 *  根据对话框ID获取未读消息总数量
 *
 *  @return 数量
 */
-(NSInteger)getImRecentNoReadMsgCountWithDialogID:(NSString *)dialogid;

/**
 *  判断是否存在此最近联系人信息
 *
 *  @param contactid 联系ID
 *
 *  @return 是否存在
 */
-(BOOL)checkIsExistsRecentWithContactid:(NSString *)contactid;

/**
 *  判断是否显示此最近联系人信息
 *
 *  @param contactid 联系ID
 *
 *  @return 是否存在
 */
-(BOOL)checkIsShowRecentWithContactid:(NSString *)contactid;

/**
 判断最近联系人是否置顶
 
 @param contactid
 @return
 */
- (BOOL)checkRecentModelIsStick:(NSString *)contactid;

/**
 判断最近联系人是否免打扰
 
 @param contactid
 @return
 */
- (BOOL)checkRecentModelIsNoDisturb:(NSString *)contactid;

@end
