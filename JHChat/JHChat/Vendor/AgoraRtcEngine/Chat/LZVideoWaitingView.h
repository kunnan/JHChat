//
//  LZVideoWaitingView.h
//  OpenVideoCall
//
//  Created by wang on 17/4/6.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZChatWaitingToolView.h"
@protocol LZVideoWaitingViewDelegate <NSObject>



/**
 挂断
 */
- (void)waitingClose;


/**
 接听
 */
- (void)waitingVideoAnswer:(BOOL)isVideo;


/**
 语音接听
 */
- (void)waitingVoiceAnswer;

- (void)backChatViewController;



@end


@interface LZVideoWaitingView : UIView

- (instancetype)initWithFrame:(CGRect)frame IsVideo:(BOOL)isVideo;

@property (nonatomic ,assign) id <LZVideoWaitingViewDelegate>delegate ;


@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *face;
@property (nonatomic,strong)NSString *roomName;


- (void)upUserName:(NSString*)userName Face:(NSString*)face RoomName:(NSString*)roomName;


@end
