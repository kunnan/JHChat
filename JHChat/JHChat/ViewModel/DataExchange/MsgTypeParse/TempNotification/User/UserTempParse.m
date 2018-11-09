//
//  UserTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/4/29.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-04-29
 Version: 1.0
 Description: 临时消息--用户
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "UserTempParse.h"
#import "FriendTempParse.h"
#import "AccountTempParse.h"
#import "TagTempParser.h"
#import "BasicinfoTempParse.h"

@implementation UserTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserTempParse *)shareInstance{
    static UserTempParse *instance = nil;
    if (instance == nil) {
        instance = [[UserTempParse alloc] init];
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
    
    /* 好友 */    
    if([secondModel isEqualToString:Handler_User_Friend]){
        isSendReport = [[FriendTempParse alloc] parse:dataDic];
    }
    /* 账号(account) */
    else if([secondModel isEqualToString:Handler_User_Account]){
        isSendReport = [[AccountTempParse alloc]parse:dataDic];
    }
    /* 标签(tag) */
    else if([secondModel isEqualToString:Handler_User_Tag]){
        isSendReport = [[TagTempParser alloc]parse:dataDic];
    }
    /* 个人基本信息(basicinfo) */
    else if([secondModel isEqualToString:Handler_User_Basicinfo]){
        isSendReport = [[BasicinfoTempParse alloc]parse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

@end
