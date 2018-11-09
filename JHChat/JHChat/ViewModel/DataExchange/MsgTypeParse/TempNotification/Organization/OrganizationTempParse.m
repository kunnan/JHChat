//
//  OrganizationTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/3.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-04-29
 Version: 1.0
 Description: 临时消息--组织机构
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "OrganizationTempParse.h"
#import "OrgTempParse.h"
#import "OrgUserTempParse.h"
#import "OrgAdminTempParse.h"

@implementation OrganizationTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrganizationTempParse *)shareInstance{
    static OrganizationTempParse *instance = nil;
    if (instance == nil) {
        instance = [[OrganizationTempParse alloc] init];
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
    
    /* 组织管理 */
    if([secondModel isEqualToString:Handler_Organization_Org]){
        isSendReport = [[OrgTempParse shareInstance] parse:dataDic];
    }
    /* 组织用户相关 */
    else if([secondModel isEqualToString:Handler_Organization_Orguser]){
        isSendReport = [[OrgUserTempParse shareInstance] parse:dataDic];
    }
    /* 管理员处理 */
    else if ([secondModel isEqualToString:Handler_Organization_Admin]){
        isSendReport = [[OrgAdminTempParse shareInstance] parse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

@end
