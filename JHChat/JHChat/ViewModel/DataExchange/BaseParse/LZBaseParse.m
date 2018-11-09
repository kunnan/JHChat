//
//  LZBaseParse.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"
#import "LZBaseAppDelegate.h"

@implementation LZBaseParse

/**
 *  获取供有Delegate
 *
 *  @return AppDelegate
 */
- (AppDelegate *)appDelegate
{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    return appDelegate;
    return [LZBaseAppDelegate shareInstance].appDelegate;
}

/**
 *  向服务器端发送回执
 *
 *  @param msgType 消息类型
 *  @param msgid   消息ID
 */
-(void)sendReportToServerMsgType:(NSString *)msgType msgID:(NSString *)msgid{
    NSMutableArray *msgids = [[NSMutableArray alloc] init];
    [msgids addObject:msgid];
    
    /* 发送消息回执 */
    NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
    [getData setObject:msgType forKey:@"type"];
    [getData setObject:@"-1" forKey:@"badge"];
    [self.appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_Report moduleServer:Modules_Message getData:getData postData:msgids otherData:@{WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll}];
}

@end
