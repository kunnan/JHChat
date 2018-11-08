//
//  LZVideoSession.h
//  OpenVideoCall
//
//  Created by wang on 17/3/22.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface LZVideoSession : NSObject


@property (assign, nonatomic) NSUInteger uid;
@property (strong, nonatomic) UIView *hostingView;
//视频View 
@property (strong, nonatomic) AgoraRtcVideoCanvas *canvas;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) BOOL isVideoMuted;

//是否静音
@property (assign, nonatomic) BOOL isMuted;

- (instancetype)initWithUid:(NSUInteger)uid;

+ (instancetype)localSession;

@end
