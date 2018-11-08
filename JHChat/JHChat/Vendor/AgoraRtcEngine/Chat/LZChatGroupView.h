//
//  LZChatGroupView.h
//  LeadingCloud
//
//  Created by wang on 17/4/26.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>


@protocol LZGroupChatDelegate <NSObject>

//结束通话 （通话连接断掉）
- (void)endGroupVideoChat:(NSDictionary*)message;

/* 切换语音视频 */
- (void)switchGroupVideoChat:(NSDictionary *)message;

//开始通话 (已经连接上了)
- (void)startGroupVideoChat;

//用户离开回调
- (void)leaveGroupChat:(NSDictionary*)message;

- (void)groupbackChat:(NSDictionary*)meassage;


//网络状态
- (void)netWoringQualityUp:(NSInteger)up Down:(NSInteger)down;

//用户静音状态
- (void)userMuted:(BOOL)muted forUid:(NSInteger)uid;

- (void)chatGroupLinkFail;

- (void)addOtherMember;

//添加禁止成员
- (void)addBanMember;

@end

@interface LZChatGroupView : UIView

//自己的uid
@property (nonatomic,assign) NSUInteger selfUid;

//视频分辨率
@property (assign, nonatomic) AgoraRtcVideoProfile videoProfile;

@property (assign, nonatomic) id<LZGroupChatDelegate>delegate;
/* 实时正在通话的人数组（包括自己） */
@property (nonatomic,strong) NSMutableArray *videoSessions;

//是否禁止语音
@property (assign, nonatomic) BOOL isBan;

/**
 更新聊天群
 @param channelName 房间号
 @param userArr     用户信息
 */
- (void)upChatChannel:(NSString*)channelName UserInfoArr:(NSMutableArray*)userArr Logo:(NSString*)logo Other:(NSDictionary*)other;

- (void)closeView;


/**
 更新

 @param userArr 用户信息
 */
- (void)addDataChatUserInfoArr:(NSArray*)userArr;

/**
 放大视频聊天界面
 */
- (void)showEnlargeWindow;

// 退出视频通话
- (void)cannel;

@end
