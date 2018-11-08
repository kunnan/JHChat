//
//  LZChatGroupToolView.h
//  LeadingCloud
//
//  Created by wang on 17/4/26.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LZChatGroupToolDelegate <NSObject>

//退出视频通话
- (void)cannel;

//切换视频语音
- (void)switchVideoAndVoice:(BOOL)isVideo;

//开启扬声器
- (void)switchSpeaker:(BOOL)isSpeaker;

//静音
- (void)switchMute:(BOOL)mute;

//禁言
- (void)switchban:(BOOL)ban;

//返回聊天
- (void)switchChat:(BOOL)chat;

//添加成员
- (void)switchAdd:(BOOL)add;

@end

@interface LZChatGroupToolView : UIView

- (instancetype)initWithFrame:(CGRect)frame isAdmins:(BOOL)isadmins;
//静音
@property (nonatomic,strong)UIButton *muteBtn;

@property (nonatomic,assign) id<LZChatGroupToolDelegate>delegate;


/**
 
 更新状态
 @param state    状态 0 正在连接 1 链接成功
 
 */
- (void)upChatState:(NSInteger)state IsVideo:(BOOL)isVideo;

/**
 
 更新扬声器状态 （语音关闭，视频打开）
 
 */
- (void)upDataSpeaker:(BOOL)isSelect;
@end
