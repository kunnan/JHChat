//
//  LZChatGroupWaitingView.h
//  LeadingCloud
//
//  Created by wang on 2017/7/20.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LZChatGroupWaitingDelegate <NSObject>

/**
 挂断
 */
- (void)groupWaitingClose;


/**
 语音接听
 */
- (void)groupWaitingAnswer;

- (void)backChatViewGroupController;


@end

@interface LZChatGroupWaitingView : UIView

@property (nonatomic,assign)id<LZChatGroupWaitingDelegate>delegate;


- (void)setUpUserFace:(NSString*)faceid Name:(NSString*)name User:(NSArray*)userArray Uid:(NSString *)uid;


@end
