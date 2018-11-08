//
//  LZChatGroupSingleView.h
//  LeadingCloud
//
//  Created by wang on 17/4/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZChatGroupSingleView : UIView


@property (nonatomic,strong)NSString *uid;

//封面头像
@property (nonatomic,strong)UIImageView *coverImageView;

@property (nonatomic,strong) UIImageView *banView;

- (void)upDataIcon:(NSString*)face Uid:(NSString*)uid isSingle:(NSInteger)isSingle;


- (void)endWaitingView;

- (void)banSatae:(BOOL)isMuit;


@end
