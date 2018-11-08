//
//  LZChatToolView.h
//  OpenVideoCall
//
//  Created by wang on 17/4/1.
//  Copyright © 2017年 Agora. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2017-04-05
 Version: 1.0
 Description: 视频聊天底部工具View
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <UIKit/UIKit.h>

@protocol LZChatToolDelegate <NSObject>

@optional

//退出视频通话
- (void)cannel;

//切换视频语音
- (void)switchVideoAndVoice:(BOOL)isVideo;

//开启扬声器
- (void)switchSpeaker:(BOOL)isSpeaker;

//切换小窗
- (void)switchSmallWindow;

//静音
- (void)switchMute:(BOOL)mute;


@end

@interface LZChatToolView : UIView

@property (nonatomic,assign) id <LZChatToolDelegate>delegate;



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
