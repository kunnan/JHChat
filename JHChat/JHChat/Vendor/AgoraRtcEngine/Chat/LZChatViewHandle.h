//
//  LZChatVIewHandle.h
//  OpenVideoCall
//
//  Created by wang on 17/4/13.
//  Copyright © 2017年 Agora. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2017-04-13
 Version: 1.0
 Description: 聊天View处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LZChatViewHandle : NSObject

+(LZChatViewHandle *)shareInstance;


//得到显示View
- (UIView*)getShowViewFromArray:(NSArray*)sessions Frame:(CGRect)frame;

//得到小窗View
- (UIView*)getSamleViewFromArray:(NSArray*)sessions Frame:(CGRect)frame;


//得到多人聊天
- (UIView*)getMorePeopleViewFromArray:(NSArray*)sessions View:(UIView*)supView;



- (BOOL)isShowVoiceViewFromeArray:(NSArray*)sessions;


//是否是视频
- (BOOL)isShowVideoViewFromeArray:(NSArray*)sessions;

@end
