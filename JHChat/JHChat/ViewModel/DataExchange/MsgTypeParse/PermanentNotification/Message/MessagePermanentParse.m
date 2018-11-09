//
//  MessagePermanentParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/4/26.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-24
 Version: 1.0
 Description: 持久消息--即时消息
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MessagePermanentParse.h"
#import "StatusmsgPermanentParse.h"
#import "GroupPermanentParse.h"
#import "LZChatPermanentParse.h"
#import "RecentPermanentParse.h"
#import "BusinessPermanentParse.h"

@implementation MessagePermanentParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MessagePermanentParse *)shareInstance{
    static MessagePermanentParse *instance = nil;
    if (instance == nil) {
        instance = [[MessagePermanentParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析持久通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    NSString *secondModel = [[HandlerTypeUtil shareInstance] getSecondModel:[dataDic objectForKey:@"handlertype"]];
    
    BOOL isSendReport = NO;
    
    /* 最近联系人 */
    if([secondModel isEqualToString:Handler_Message_Recent]){
        isSendReport = [[RecentPermanentParse shareInstance] parse:dataDic];
    }
    /* 状态消息 */
    else if( [secondModel isEqualToString:Handler_Message_StatusMsg] ){
        isSendReport = [[StatusmsgPermanentParse shareInstance] parse:dataDic];
    }
    /* 群组通知 */
    else if([secondModel isEqualToString:Handler_Message_Group]){
        isSendReport = [[GroupPermanentParse shareInstance] parse:dataDic];
    }
    /* 群多人消息持久通知 */
    else  if([secondModel isEqualToString:Handler_Message_LZChat]){
        isSendReport = [[LZChatPermanentParse shareInstance] parse:dataDic];
    }
    /* 审批类型消息状态通知 */
    else if ([secondModel isEqualToString:Handler_Message_BusinessMessage]) {
        isSendReport = [[BusinessPermanentParse shareInstance] parse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---持久消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

@end
