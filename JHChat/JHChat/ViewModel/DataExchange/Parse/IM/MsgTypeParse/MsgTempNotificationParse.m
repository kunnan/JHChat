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
#import "ImChatLogDAL.h"
#import "ImChatLogModel.h"
#import "NSDictionary+DicSerial.h"
#import "EventBus.h"
#import "EventPublisher.h"
#import "ImMsgQueueDAL.h"
#import "LZImageUtils.h"
#import "AppUtils.h"
#import "ChatViewController.h"
#import "ImRecentDAL.h"
#import "VoiceConverter.h"
#import "LZCloudFileTransferMain.h"
#import "ModuleServerUtil.h"
#import "NSDictionary+DicSerial.h"
#import "AppDateUtil.h"
#import "JSMessageSoundEffect.h"
#import "ImGroupModel.h"
#import "ImGroupDAL.h"
#import "ImGroupUserDAL.h"
#import "ImRecentDAL.h"
#import "ImRecentModel.h"
#import "UserDAL.h"
#import "UserModel.h"
#import "MsgMessageTypeParse.h"
#import "RecentParse.h"
#import "ImGroupParse.h"


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
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];

    /* 最近联系人 */
    if([handlertype hasPrefix:@"lzmsg.recent."]){
        [[RecentParse shareInstance] parseTempNotification:dataDic];
    }
    /* 群组 */
    else if([handlertype hasPrefix:@"lzmsg.group."]){
        [[ImGroupParse shareInstance] parseTempNotification:dataDic];
    }
}

@end
