//
//  LZChatWaitingHeadView.h
//  OpenVideoCall
//
//  Created by wang on 17/4/10.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZChatWaitingHeadView : UIView
//头像
@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UIButton *backChatBtn;

/**
 设置用户信息
 
 @param name 名字
 @param face 头像
 @param type 类型 1 视频 2 语音
 */
-(void)upDataUserName:(NSString*)name UserFace:(NSString*)face Type:(NSInteger)type;


- (void)upChatTimeLength:(NSString*)length;

@end
