//
//  PostRemindTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-05-04
 Version: 1.0
 Description: 临时消息--协作--我的提醒
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "PostRemindTempParse.h"
#import "CooperationDynamicModel.h"

@implementation PostRemindTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostRemindTempParse *)shareInstance{
    static PostRemindTempParse *instance = nil;
    if (instance == nil) {
        instance = [[PostRemindTempParse alloc] init];
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
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    
    /* 接受邀请 */
    if([handlertype isEqualToString:Handler_Cooperation_PostRemind_Insert]){
        isSendReport = [self setPostRemindInsert:dataDic];
        
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}


- (BOOL)setPostRemindInsert:(NSMutableDictionary*)dataDic{
    

    __block PostRemindTempParse * service = self;
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_Message_Notification, nil);
    });

    
    return YES;
}

@end
