//
//  ChatViewPlugin.h
//  LeadingCloud
//
//  Created by wchMac on 16/3/31.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-31
 Version: 1.0
 Description: 聊天框，对应JS插件
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "JSNCPlugin.h"

@interface ChatViewPlugin : JSNCPlugin

#pragma mark - 打开聊天框

/**
 *  打开聊天窗口
 *
 *  @param runParameter 运行时参数
 */
-(void)openChatView:(JSNCRunParameter *)runParameter;

@end
