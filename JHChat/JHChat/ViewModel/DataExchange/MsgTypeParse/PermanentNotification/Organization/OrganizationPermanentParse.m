//
//  OrganizationPermanentParse.m
//  LeadingCloud
//
//  Created by dfl on 16/8/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-08-25
 Version: 1.0
 Description: 持久消息--组织
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "OrganizationPermanentParse.h"
#import "OrgPermanentParse.h"

@implementation OrganizationPermanentParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrganizationPermanentParse *)shareInstance{
    static OrganizationPermanentParse *instance = nil;
    if (instance == nil) {
        instance = [[OrganizationPermanentParse alloc] init];
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
    if( [secondModel isEqualToString:Handler_Organization_Org] ){
        isSendReport = [[OrgPermanentParse shareInstance] parse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---持久消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

@end
