//
//  LZChatVoiceView.h
//  LeadingCloud
//
//  Created by wang on 2018/3/2.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LZChatVoiceDelegate <NSObject>

//结束通话 （通话连接断掉）
- (void)endChatVoiceChat:(NSDictionary*)message;


//开始通话 (已经连接上了)
- (void)startVoiceChat;

//用户离开回调
- (void)leaveChatVoiceChat:(NSDictionary*)message;



//网络状态
- (void)netWoringQualityUp:(NSInteger)up Down:(NSInteger)down;

- (void)chatGroupLinkFail;

- (void)addOtherMember;

@end

@interface LZChatVoiceView : UIView
/**
 更新聊天群
 
 @param channelName 房间号
 @param userArr     用户信息
 */
- (void)upChatChannel:(NSString*)channelName UserInfoArr:(NSMutableArray*)userArr Other:(NSDictionary*)other;

@property (assign, nonatomic) id<LZChatVoiceDelegate>delegate;
/* 实时正在通话的人数组（包括自己） */
@property (nonatomic,strong) NSMutableArray *voiceSessions;

@end
