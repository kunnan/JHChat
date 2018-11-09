//
//  MsgPermanentNotificationParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/3/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-12
 Version: 1.0
 Description: 持久通知解析处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgPermanentNotificationParse.h"
#import "MessagePermanentParse.h"
#import "UserPermanentParse.h"
#import "OrganizationPermanentParse.h"

@interface MsgPermanentNotificationParse()<EventSyncPublisher>

@end

@implementation MsgPermanentNotificationParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MsgPermanentNotificationParse *)shareInstance{
    static MsgPermanentNotificationParse *instance = nil;
    if (instance == nil) {
        instance = [[MsgPermanentNotificationParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    NSString *secondModel = [[HandlerTypeUtil shareInstance] getMainModel:[dataDic objectForKey:@"handlertype"]];
    
    BOOL isSendReport = NO;
    
    /* 即时消息 */
    if([secondModel isEqualToString:Handler_Message]){
        isSendReport = [[MessagePermanentParse shareInstance] parse:dataDic];
    }
    /* 用户 */
    else if([secondModel isEqualToString:Handler_User]){
        isSendReport = [[UserPermanentParse shareInstance] parse:dataDic];
    }
    /* 组织 */
    else if ([secondModel isEqualToString:Handler_Organization]){
        isSendReport = [[OrganizationPermanentParse shareInstance]parse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---持久通知:%@",dataDic);
    }
    
    return isSendReport;
}

@end
