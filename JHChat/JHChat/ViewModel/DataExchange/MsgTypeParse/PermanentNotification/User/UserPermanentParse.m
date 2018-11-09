//
//  UserPermanentParse.m
//  LeadingCloud
//
//  Created by dfl on 16/5/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-05-16
 Version: 1.0
 Description: 持久消息--用户
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "UserPermanentParse.h"
#import "BasicinfoPermanentParse.h"

@implementation UserPermanentParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserPermanentParse *)shareInstance{
    static UserPermanentParse *instance = nil;
    if (instance == nil) {
        instance = [[UserPermanentParse alloc] init];
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
    
    /* 状态消息 */
    if( [secondModel isEqualToString:Handler_User_Basicinfo] ){
        isSendReport = [[BasicinfoPermanentParse shareInstance] parse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---持久消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

@end
