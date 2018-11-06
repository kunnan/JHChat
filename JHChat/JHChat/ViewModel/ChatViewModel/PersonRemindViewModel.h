//
//  PersonRemindViewModel.h
//  LeadingCloud
//
//  Created by gjh on 2018/3/13.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "BaseViewModel.h"

@class XHMessage,ImChatLogModel;

@interface PersonRemindViewModel : BaseViewModel<EventSyncPublisher>

@property (nonatomic, assign) NSInteger contactType;  //聊天框类型

@property (nonatomic, assign) NSInteger sendToType;  //聊天框类型

/**
 获取个人提醒、企业提醒用的消息，最新消息在最上面
 */
- (NSMutableArray *)getMessageDataSource:(NSString *)dialogid startCount:(NSInteger)start queryCount:(NSInteger)count;

#pragma mark - 自动下载聊天记录

/**
 *  检测是否需要自动下载聊天记录
 */
-(void)checkIsNeedDownChatLog:(NSString *)dialogid;

/**
 *  发送回执
 */
-(void)sendReportToServer:(NSString *)dialogid;


#pragma mark - 刷新未读数字、发送回执   （供所有显示在消息页签的VC调用）

/**
 *  刷新未读数字
 */
-(void)refreshMsgUnReadCount:(NSString *)dialogid;

#pragma mark - 消息发送、接收通用方法

/**
 *  添加新的聊天记录
 *
 *  @param chatLogModel 聊天信息
 *
 *  @return XHMessage对象
 */
-(XHMessage *)addNewXHMessageWithImChatLogModel:(ImChatLogModel *)chatLogModel messages:(NSMutableArray *)messages;

@end
