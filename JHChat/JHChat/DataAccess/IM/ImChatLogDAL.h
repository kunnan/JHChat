//
//  ImChatLogDAL.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 聊天日志数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"

@class ImChatLogModel;
@interface ImChatLogDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImChatLogDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImChatLogTableIfNotExists;

/**
 *  升级数据库
 */
-(void)updateImChatLogTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithChatLogArray:(NSMutableArray *)imChatlogArray;

/**
 *  添加单条聊天记录
 */
-(BOOL)addChatLogModel:(ImChatLogModel *)imChatlogModel;

#pragma mark - 删除数据

/**
 *  根据Msgid删除聊天记录
 *
 *  @param msgid MsgID
 */
-(void)deleteImChatLogWithMsgid:(NSString *)msgid;

/**
 *  根据Msgid改变消息状态，删除聊天记录
 *
 *  @param msgid MsgID
 */
-(void)deleteMessageWithMsgid:(NSString *)msgid;

/**
 *  清空聊天记录
 *
 *  @param dialogid 对话框ID
 */
-(void)deleteImChatLogWithDialogid:(NSString *)dialogid;

/**
 *  清空所有聊天记录
 *
 */
-(void)deleteImChatLog;


#pragma mark - 修改数据

/**
 *  根据clientid更新msgid
 *
 *  @param msgId        消息ID
 *  @param clienttempid 客户端临时ID
 *  @param sendstatus   消息发送状态
 */
-(void)updateMsgId:(NSString *)msgid withClientTempid:(NSString *)clienttempid withSendstatus:(NSInteger)sendstatus;

/**
 *  更新文件下载状态
 *
 *  @param msgid      消息ID
 *  @param recvstatus 下载状态
 */
-(void)updateRecvStatusWithMsgId:(NSString *)msgid withRecvstatus:(NSInteger)recvstatus;

/**
 *  更新发送状态
 *
 *  @param clientTempId      消息ID
 *  @param recvstatus 下载状态
 */
-(void)updateSendStatusWithClientTempId:(NSString *)clientTempId withSendstatus:(NSInteger)sendstatus;

/**
 *  更新发送状态,将发送中的更改为失败
 */
-(void)updateSendingStatusToFail;

/**
 *  更新body字段值
 *
 *  @param body  body信息
 *  @param msgid MsgID
 */
-(void)updateBody:(NSString *)body withMsgId:(NSString *)msgid;

/**
 更新isrecall字段值
 
 @param isReCall
 @param msgid
 */
- (void)updateIsReCall:(NSInteger)isReCall withMsgId:(NSString *)msgid;

/**
 *  更新Cell的高度
 */
-(void)updateHeightForRow:(NSString *)heightforrow withMsgId:(NSString *)msgid;

/**
 *  清空heightforrow和textmsgsize两个字段的内容
 */
-(void)updateHeightForRowAndtextMsgSizeToNull;
/**
 *  更新Text类型消息的Size
 */
-(void)updateSizeForTextMsg:(NSString *)size withMsgId:(NSString *)msgid;

/**
 *  更新接收到的消息为已读
 */
-(void)updateRecvIsRead:(NSMutableArray *)msgidArray;

/**
 *  更新单人聊天对话框已读消息
 */
-(void)updateReadedListForOne:(NSMutableArray *)chatLogArray;

/**
 *  更新多人聊天对话框已读消息
 */
-(void)updateReadedListForGroup:(NSMutableArray *)chatLogArray;

/**
 *  根据Contactid更新接收到的消息为已读
 */
-(void)updateRecvIsReadWithDialogid:(NSString *)dialogid;

-(void)updateMsgSendDateTimeWithShowindexDate:(NSDate *)showindexDate
                                         body:(NSString *)body
                                        msgid:(NSString *)msgid
                               orClienttempid:(NSString *)clienttempid;

#pragma mark - 查询数据

/**
 *  获取聊天记录
 *
 *  @param dialogid 对话框ID
 *  @param start    起始条目
 *  @param count    需要获取的条目数量
 *
 *  @return 聊天记录数组
 */
-(NSMutableArray *)getChatLogWithDialogid:(NSString *)dialogid startNum:(NSInteger)start queryCount:(NSInteger)count;

/**
 *  获取聊天记录(反续)
 *
 *  @param dialogid 对话框ID
 *  @param start    起始条目
 *  @param count    需要获取的条目数量
 *
 *  @return 聊天记录数组
 */
-(NSMutableArray *)getChatLogWithDialogidByASC:(NSString *)dialogid startNum:(NSInteger)start queryCount:(NSInteger)count;

/**
 *  根据消息ID或客户端ID获取聊天记录
 *
 *  @param msgid        消息ID
 *  @param clienttempid 客户端ID
 *
 *  @return 聊天记录Model
 */
-(ImChatLogModel *)getChatLogModelWithMsgid:(NSString *)msgid orClienttempid:(NSString *)clienttempid;

/**
 *  根据DialogID获取最后一条聊天记录的Model
 *
 *  @param dialogid   对话框ID
 *
 *  @return 聊天记录Model
 */
-(ImChatLogModel *)getLastChatLogModelWithDialogId:(NSString *)dialogid;

/**
 *  根据DialogID获取最后一条聊天记录的Model
 *
 *  @param dialogid   对话框ID
 *
 *  @return 聊天记录Model
 */
-(ImChatLogModel *)getFirstChatLogModelWithDialogId:(NSString *)dialogid;

/**
 *  根据DialogID获取第一条未读消息
 */
-(ImChatLogModel *)getFirstUnreadChatLogModelWithDialogId:(NSString *)dialogid;

/**
 *  获取某条消息后面的消息数量
 */
-(NSInteger)getMsgCountWithChatLogModel:(ImChatLogModel *)chatlogModel;

/**
 *  根据文件类型获取聊天记录
 *
 *  @param dialogid 对话框ID
 *  @param handlertype 消息类型
 *
 *  @return 聊天记录数组
 */
-(NSMutableArray *)getChatLogWithDialogid:(NSString *)dialogid handlerType:(NSString *)handlertype;

/**
 *  获取对话框中某段时间之后的消息
 */
-(NSMutableArray *)getChatLogsWithDialogid:(NSString *)dialogid datetime:(NSDate *)datetime;

/**
 *  获取所有未读消息数组
 *
 *  @param dialogid 聊天框ID
 *
 *  @return 消息数组
 */
-(NSMutableArray *)getRecvIsNoReadWithDialogId:(NSString *)dialogid;

/**
 *  判断此类型的消息是否已读(避免重复添加好友等处理时，出现多条提醒的情况)
 *
 *  @param handlertype handlertype
 *  @param bkid        业务id
 *
 *  @return 是否存在
 */
-(BOOL)checkIsExistsSameUnreadMsg:(NSString *)handlertype bkid:(NSString *)bkid;

/**
 *  判断这个时间之前是否还有消息
 */
-(BOOL)checkIsEarlierMsgWithDialogID:(NSString *)dialogid datetime:(NSDate *)datetime msgid:(NSString *)msgid;

@end
