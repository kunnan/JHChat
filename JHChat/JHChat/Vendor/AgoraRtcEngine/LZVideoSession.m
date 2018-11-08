//
//  LZVideoSession.m
//  OpenVideoCall
//
//  Created by wang on 17/3/22.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import "LZVideoSession.h"
#import "LZVideoView.h"

@implementation LZVideoSession

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithUid:(NSUInteger)uid {
    if (self = [super init]) {
        self.uid = uid;
        
        self.hostingView = [[LZVideoView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        self.canvas = [[AgoraRtcVideoCanvas alloc] init];
        self.canvas.uid = uid;
        self.canvas.view = self.hostingView;
        self.canvas.renderMode = AgoraRtc_Render_Fit;
    }
    return self;
}

- (void)setIsVideoMuted:(BOOL)isVideoMuted {
    _isVideoMuted = isVideoMuted;
    ((LZVideoView *)self.hostingView).isVideoMuted = isVideoMuted;
}

- (void)setIsMuted:(BOOL)isMuted{
	_isMuted = isMuted;
}

+ (instancetype)localSession {
    return [[LZVideoSession alloc] initWithUid:0];
}

@end
