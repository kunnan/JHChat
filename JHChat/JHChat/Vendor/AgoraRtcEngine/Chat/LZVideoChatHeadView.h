//
//  LZViedoChatHeadView.h
//  OpenVideoCall
//
//  Created by wang on 17/4/5.
//  Copyright © 2017年 Agora. All rights reserved.
//

/************************************************************
 Author:  wzb
 Date：   2017-04-05
 Version: 1.0
 Description: 视频聊天顶部View
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <UIKit/UIKit.h>


@protocol LZVideoChatHeaderDelegate <NSObject>

@optional

//切换摄像头
- (void)changeCamera;


- (void)backChat;


@end

@interface LZVideoChatHeadView : UIView

@property (nonatomic,assign) id <LZVideoChatHeaderDelegate>delegate;


/**
 更新文字信息

 @param userName 聊天用户名
 @param state    状态 0 正在连接 1 链接成功
 */
- (void)upChatUserName:(NSString*)userName State :(NSInteger)state;


- (void)upChatTimeLength:(NSString*)length;


@end
