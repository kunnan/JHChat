//
//  LZBaseParse.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "NSString+IsNullOrEmpty.h"
#import "HandlerTypeUtil.h"

@interface LZBaseParse : NSObject

/**
 *  获取供有Delegate
 *
 *  @return AppDelegate
 */
- (AppDelegate *)appDelegate;

/**
 *  向服务器端发送回执
 *
 *  @param msgType 消息类型
 *  @param msgid   消息ID
 */
-(void)sendReportToServerMsgType:(NSString *)msgType msgID:(NSString *)msgid;

@end
