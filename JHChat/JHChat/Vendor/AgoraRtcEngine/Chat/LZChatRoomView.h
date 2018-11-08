//
//  LZChatRootView.h
//  OpenVideoCall
//
//  Created by wang on 17/4/5.
//  Copyright © 2017年 Agora. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2017-04-05
 Version: 1.0
 Description: 视频聊天View
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <UIKit/UIKit.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "LZChatToolView.h"
#import "LZVideoChatHeadView.h"


@protocol LZVideoChatDelegate <NSObject>

//结束通话 （通话连接断掉）
- (void)endVideoChat:(NSDictionary*)message;

//开始通话 (已经连接上了)
- (void)startVideoChat;

/* 切换视频通话语音通话 */
- (void)switchChatVideo:(NSDictionary *)message;

//网络状态
- (void)netWoringQualityUp:(NSInteger)up Down:(NSInteger)down;

- (void)chatLinkFail;

- (void)backChatController:(NSDictionary*)message;


@end



@interface LZChatRoomView : UIView<AgoraRtcEngineDelegate,LZChatToolDelegate,LZVideoChatHeaderDelegate,CAAnimationDelegate>

//房间名称唯一标识 （频道）
@property (copy, nonatomic) NSString *roomName;
//用户名
@property (copy, nonatomic) NSString *userName;
//头像
@property (copy, nonatomic) NSString *face;

//视频分辨率
@property (assign, nonatomic) AgoraRtcVideoProfile videoProfile;


@property (nonatomic,assign) id <LZVideoChatDelegate>delegate;

//是否是视频
@property (nonatomic,assign) BOOL isVideo;


- (void)upChatChannel:(NSString*)channelName UserName:(NSString*)userName Face:(NSString*)face;


//退出视频通话
- (void)closeView;


- (void)showEnlargeWindow;


@end
