//
//  MessageMsgParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/4/26.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-24
 Version: 1.0
 Description: 消息--即时消息
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MessageMsgParse.h"
#import "LZChatMsgParse.h"

@implementation MessageMsgParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MessageMsgParse *)shareInstance{
    static MessageMsgParse *instance = nil;
    if (instance == nil) {
        instance = [[MessageMsgParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析持久通知数据
 *
 *  @param dataDic 数据
 */
-(NSDictionary *)parse:(NSMutableDictionary *)dataDic{
    NSString *secondModel = [[HandlerTypeUtil shareInstance] getSecondModel:[dataDic objectForKey:@"handlertype"]];
    
    NSDictionary *result = [[NSDictionary alloc] init];
    
    /* 状态消息 */
    if( [secondModel isEqualToString:Handler_Message_LZChat] ){
        result = [[LZChatMsgParse shareInstance] parse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---消息类型:%@",dataDic);
    }
    
    return result;
}

@end
