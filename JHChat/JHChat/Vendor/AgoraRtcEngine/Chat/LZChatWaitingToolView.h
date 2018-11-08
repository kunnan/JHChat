//
//  LZChatWaitingToolView.h
//  OpenVideoCall
//
//  Created by wang on 17/4/11.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LZVideoWaitingToolDelegate <NSObject>



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


@end

@interface LZChatWaitingToolView : UIView


- (instancetype)initWithFrame:(CGRect)frame IsVideo:(BOOL)isVideo;

@property (nonatomic ,assign) id <LZVideoWaitingToolDelegate>delegate ;


@end
