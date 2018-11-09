//
//  MsgTempNotificationParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/3/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-12
 Version: 1.0
 Description: 临时通知解析处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgTempNotificationParse.h"
#import "MessageTempParse.h"
#import "OrgTempParse.h"
#import "UserTempParse.h"
#import "CooperationTempParse.h"
#import "UserTempParse.h"
#import "OrganizationTempParse.h"
#import "CloudDiskTempParse.h"
#import "FavoritesTempParse.h"
#import "MyTransactionTempParse.h"
#import "AppTempParse.h"
@interface MsgTempNotificationParse()<EventSyncPublisher>

@end

@implementation MsgTempNotificationParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MsgTempNotificationParse *)shareInstance{
    static MsgTempNotificationParse *instance = nil;
    if (instance == nil) {
        instance = [[MsgTempNotificationParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    NSString *mainModel = [[HandlerTypeUtil shareInstance] getMainModel:[dataDic objectForKey:@"handlertype"]];
    
    BOOL isSendReport = NO;
        
    /* 即时消息 */
    if([mainModel isEqualToString:Handler_Message]){
        isSendReport = [[MessageTempParse shareInstance] parse:dataDic];
    }
    /* 用户 */
    else if([mainModel isEqualToString:Handler_User]){
        isSendReport = [[UserTempParse shareInstance] parse:dataDic];
    }
    /* 组织机构 */
    else if( [mainModel isEqualToString:Handler_Organization] ){
        isSendReport = [[OrganizationTempParse shareInstance] parse:dataDic];
    }
    /* 协作 */
    else if( [mainModel isEqualToString:Handler_Cooperation] ){
        isSendReport = [[CooperationTempParse shareInstance] parse:dataDic];
    }
    /* 云盘 */
    else if ([mainModel isEqualToString:Handler_CloudDiskApp]) {
        
        isSendReport = [[CloudDiskTempParse shareInstance] parse:dataDic];
    }
    /* 收藏 */
    else if ([mainModel isEqualToString:Handler_favorites]) {
        
        isSendReport = [[FavoritesTempParse shareInstance] parse:dataDic];
        
    }
    else if ([mainModel isEqualToString:Handler_MyTransaction]){
        isSendReport = [[MyTransactionTempParse shareInstance] parse:dataDic];

    }
    /* 应用 */
    else if ([mainModel isEqualToString:Handler_App]){
        isSendReport = [[AppTempParse shareInstance] parse:dataDic];
    }    
//    /* 组织 */
//    else if([handlertype hasPrefix:@"lz.enter."]){
//        isSendReport = [[EnterTempParse shareInstance] parse:dataDic];
//    }
//    /* 组织信息 */
//    else if([handlertype hasPrefix:@"lz.orguser."]){
//        isSendReport = [[OrgTempParse shareInstance]parse:dataDic];
//    }
//    /* 账号设置通知 */
//    else if([handlertype hasPrefix:@"lz.user."]){
//        isSendReport = [[UserTempParse shareInstance]parse:dataDic];
//    }
//    /*协作动态通知*/
//    else if ([handlertype hasPrefix:@"lzcooperation.postmain."]){
//        isSendReport = [[CooperationTempParse shareInstance]parse:dataDic];
//    }
//    /*协作工作组*/
//    else if ([handlertype hasPrefix:@"lzcooperation.group."]){
////        isSendReport = [[CooperationTempParse shareInstance]parseGroup:dataDic];
//    }
    else {
        DDLogError(@"----------------收到未处理---临时通知:%@",dataDic);
    }
    
    return isSendReport;
}

@end
