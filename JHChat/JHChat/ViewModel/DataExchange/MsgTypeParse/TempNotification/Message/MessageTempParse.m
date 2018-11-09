//
//  MessageTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/4/26.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-24
 Version: 1.0
 Description: 临时消息--即时消息
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MessageTempParse.h"
#import "RecentTempParse.h"
#import "GroupTempParse.h"
#import "LZChatTempParse.h"
#import "PCLoginTempParse.h"
#import "BusinessTempParse.h"

@implementation MessageTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MessageTempParse *)shareInstance{
    static MessageTempParse *instance = nil;
    if (instance == nil) {
        instance = [[MessageTempParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    NSString *secondModel = [[HandlerTypeUtil shareInstance] getSecondModel:[dataDic objectForKey:@"handlertype"]];
    
    BOOL isSendReport = NO;
    
    /* 最近联系人 */
    if([secondModel isEqualToString:Handler_Message_Recent]){
        isSendReport = [[RecentTempParse shareInstance] parse:dataDic];
    }
    /* 群组通知 */
    else if([secondModel isEqualToString:Handler_Message_Group]){
        isSendReport = [[GroupTempParse shareInstance] parse:dataDic];
    }
    /* 消息临时通知 */
    else  if([secondModel isEqualToString:Handler_Message_LZChat]){
        isSendReport = [[LZChatTempParse shareInstance] parse:dataDic];
    }
    else if ([secondModel isEqualToString:Handler_Message_StatusMsg]) {
        isSendReport = [[PCLoginTempParse shareInstance] parse:dataDic];
    }
    /* 审批类型消息状态通知 */
    else if ([secondModel isEqualToString:Handler_Message_BusinessMessage]) {
        isSendReport = [[BusinessTempParse shareInstance] parse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

@end
