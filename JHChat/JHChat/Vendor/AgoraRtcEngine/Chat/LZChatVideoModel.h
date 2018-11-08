//
//  LZChatVideoModel.h
//  OpenVideoCall
//
//  Created by wang on 17/4/10.
//  Copyright © 2017年 Agora. All rights reserved.
//

/************************************************************
 Author:  wzb
 Date：   2017-04-10
 Version: 1.0
 Description: 视频聊天通用类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

#import "LZVideoWaitingView.h"

#import "LZChatRoomView.h"

//聊天结束通知
static NSString * const Chat_End_Notice = @"chat_end_notice";
//聊天开始通知
static NSString * const Chat_Start_Notice = @"chat_start_notice";
//聊天网络状态通知
static NSString * const Chat_NetWorking_Notice = @"chat_netWorking_notice";


//聊天连接失败通知 60s
static NSString * const Chat_Fail_Notice = @"chat_fail_notice";

//聊天连接失败 //appid 失效
static NSString * const Chat_Link_Fail_Notice = @"chat_link_fail_notice";

//聊天接受通知（聊天未接通）
static NSString * const Chat_Accept_Notice = @"chat_accept_notice";
//聊天挂断通知 （聊天未接通）
static NSString * const Chat_Close_Notice = @"chat_close_notice";
/* 忙线中 */
static NSString * const Chat_Busy_Notice = @"chat_busy_notice";


//多人聊天

//聊天人数通知 （个人信息）
static NSString *const Chat_Number_Notice = @"chat_number_notice";

//已经加入的用户通知
static NSString *const Chat_Joined_Notice = @"chat_joined_notice";

//添加用户通知
static NSString *const Chat_Add_Notice = @"chat_add_notice";

//禁言用户通知
static NSString *const Chat_Ban_Notice = @"chat_ban_notice";
/* 用户离开通知 */
static NSString *const Chat_Group_Leave_Notice = @"chat_group_leave_notice";

/* 自己挂断通知 */
static NSString *const Chat_Group_End_Notice = @"chat_group_end_notice";

/* 呼叫超时 */
static NSString *const Chat_Group_Timeout_Notice = @"chat_group_timeout_notice";

/* 拒绝 */
static NSString *const Chat_Group_Refuse_Notice = @"chat_group_refuse_notice";

/* 完成结束 */
static NSString *const Chat_Group_Finish_Notice = @"chat_group_finish_notice";

/* 切换视频语音的通知 */
static NSString *const Chat_Group_Switch_Notice = @"chat_group_switch_notice";

/* 更新正在通话的人的数组 */
static NSString *const Chat_Group_Update_Notice = @"chat_group_update_notice";

/* 更新禁言列表 */
static NSString *const Chat_Group_BanList_Notice = @"chat_group_banlist_notice";

/* 点击接听按钮的通知 */
static NSString *const Chat_Group_Answer_Notice = @"chat_group_answer_notice";

/* 更新正在通话的人的数组 */
static NSString *const Chat_Group_Back_Notice = @"chat_back_chat_notice";

/* 关闭选人界面 */
static NSString *const Chat_Group_CloseVC_Notice = @"chat_closevc_notice";

//静音状态更新通知
static NSString * const Chat_Group_Muted_Notice = @"chat_muted_notice";

@interface LZChatVideoModel : NSObject
/* 多人会话的成员数组 */
@property (strong, nonatomic) NSMutableArray *userArry;

@property (copy, nonatomic, readonly)NSString *roomName ; //房间号

+(LZChatVideoModel *)shareInstance;



/**
 加入聊天等待View

 @return 返回视频是否同意View
 */
- (LZVideoWaitingView*)addChatWaitViewIsVideo:(BOOL)isVideo;



/**
 加入聊天等待View
 
 @return 返回视频是否同意View
 */
- (void)addChatWaitViewUserName:(NSString*)userName Face:(NSString*)face RoomName:(NSString*)roomName Other:(NSDictionary*)other IsVideo:(BOOL)isVideo;



 /**
  加入聊天View
  @param roomName 唯一标识
  @param isVideo  是否视频

  @return
  */

- (LZChatRoomView*)addChatRoomViewRoomName:(NSString*)roomName IsVideo:(BOOL)isVideo;



/**
 加入聊天View
 @param roomName 唯一标识
 @param isVideo  是否视频
 
 @return
 */

- (void)addChatRoomViewUserName:(NSString*)userName Face:(NSString*)face RoomName:(NSString*)roomName Other:(NSDictionary*)other IsVideo:(BOOL)isVideo;

/**
 加入群聊天View
 @param roomName 唯一标识
 @param isVideo  是否视频
 
 @return
 */

- (void)addChatGroupRoomViewRoomName:(NSString*)roomName UserInfoArr:(NSMutableArray*)userArr Other:(NSDictionary*)other IsVideo:(BOOL)isVideo;


/**
 加入群聊等待View
 
 @return 返回视频是否同意View
 */
- (void)addChatGroupWaitViewUserName:(NSString*)userName Uid:(NSString*)uid Face:(NSString*)face RoomName:(NSString*)roomName UserInfoArr:(NSMutableArray*)userArr Other:(NSDictionary*)other;

/**
 后面添加某人到多人聊天
 
 @param chatUsers
 */
- (void)addNewMemberToCall:(NSArray *)chatUsers;


//设置用户禁言
- (void)setUserBan:(BOOL)isBan;

/**
 //设置用户正在通话标识符
 */
- (void)setUserCalling;

/**
 //设置用户已经结束
 */
- (void)setUserCalled;

/**
 判断用户是否在通话
 
 @return yes 是 NO 否
 */
- (BOOL)isCalling;



/**
 关闭聊天框 譬如退出登录
 */
- (void)closeChatView;

- (void)closeGroupChatView;

- (void)showEnlargeWindow;

- (void)showSignalEnlargeWindow;
/* 得到真实正在通话的人数 */
- (NSMutableArray *)getRealCallArray;

//得到正在通话人员的静音状态
- (NSMutableArray*)getMuitCallArray;

/* 挂断视频通话插件 */
- (void)cancelVideoPlugin;

@end
