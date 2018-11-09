//
//  MsgBaseParse.h
//  LeadingCloud
//
//  Created by wchMac on 16/3/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"

@class ImRecentModel,ImChatLogModel;
@interface MsgBaseParse : LZBaseParse<EventSyncPublisher>

/**
 *  判断聊天框是否在主页面
 */
-(BOOL)checkIsOpenChatViewController;

/**
 *  判断指定的聊天框是否在主页面
 */
-(BOOL)checkIsOpenTheChatViewController:(ImChatLogModel *)imChatLogModel;

/**
 *  公用保存方法(新的组织，新的好友，新的员工、新的协作、协作动态)
 */
-(BOOL)commonSaveNewsInfo:(NSMutableDictionary *)dataDic recentModel:(ImRecentModel *)recentModel;

#pragma mark - 聊天记录保存完后，提醒

/**
 *  保存消息后的处理
 *
 *  @param imChatLogModel    聊天记录
 *  @param imRecentModel     最近聊天信息
 *  @param isChatMessage     是否为聊天消息
 */
-(void)afterSaveChatLog:(ImChatLogModel *)imChatLogModel imRecetnModel:(ImRecentModel *)imRecentModel isChatMessage:(BOOL)isChatMessage;

-(void)startLocalNotification:(NSMutableArray *)allMsgArr
                    alertBody:(NSString *)alertBody
                   isUseSound:(BOOL)isUseSound
                   isRemindMe:(BOOL)isRemindMe;

#pragma mark - 重新设置消息的接收时间，消息顺序乱的问题

/**
 *  重新设置接收消息的时间，若时间与本地间隔小于一分钟，则按本地时间
 */
-(NSDate *)resetChatLogShowindexDate:(NSDate *)showindexDate;

@end
