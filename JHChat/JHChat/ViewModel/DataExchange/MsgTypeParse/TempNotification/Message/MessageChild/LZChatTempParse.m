//
//  LZChatTempParse.m
//  LeadingCloud
//
//  Created by gjh on 2017/7/26.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZChatTempParse.h"
#import "LZChatVideoModel.h"
#import "UserDAL.h"
#import "UserModel.h"
#import "AppDateUtil.h"

@implementation LZChatTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+ (LZChatTempParse *)shareInstance{
    static LZChatTempParse *instance = nil;
    if (instance == nil) {
        instance = [[LZChatTempParse alloc] init];
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
    
    BOOL isSendReport = NO;
    NSString *sendDateTime = [dataDic lzNSStringForKey:@"senddatetime"];
    /* 当前时间 */
    NSString *currentDate = [AppDateUtil GetCurrentDateForString];
    /* 两个时间点相差秒数 */
    NSInteger intervalMinutes = [AppDateUtil IntervalSecondsForString:sendDateTime endDate:currentDate];
    /* 一分钟之内 */
    if (intervalMinutes <= 77) {
        
        NSString *handlertype = [dataDic lzNSStringForKey:@"handlertype"];
        
        if([handlertype hasSuffix:Handler_Message_LZChat_VoiceCall] ||
           [handlertype hasSuffix:Handler_Message_LZChat_VideoCall]){
            
            isSendReport = [self parseVideoOrVoiceCall:dataDic];
        }
        else {            
            DDLogError(@"----------------收到未处理---消息临时通知:%@",dataDic);
        }
    }
    
    return isSendReport;
}
/* 解析单人语音通话聊天消息临时通知 */
-(BOOL)parseVideoOrVoiceCall:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *bodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *handlertype = [dataDic lzNSStringForKey:@"handlertype"];
    UserModel *usermodel = [[UserDAL shareInstance] getUserDataWithUid:[dataDic lzNSStringForKey:@"from"]];
    /* 如果通话结束，设置变量为通话结束 */
    if (![[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Call_State_Calling] &&
        ![[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Call_State_Request] &&
        [[bodyDic lzNSStringForKey:@"callstatus"] integerValue] < 9) {
        self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusNone;
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 关闭等待页面 */
            [[LZChatVideoModel shareInstance] closeChatView];
            [[LZChatVideoModel shareInstance] setUserCalled];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 如果是音视频消息，在没有通话、并且通话状态为1，打开视频窗口 */
        if (self.appDelegate.lzGlobalVariable.msgCallStatus == MsgCallStatusNone
            && [[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Call_State_Request]) {            
            /* 关闭键盘 */
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            if ([handlertype isEqualToString:Handler_Message_LZChat_VoiceCall]) {
                
                [[LZChatVideoModel shareInstance] addChatWaitViewUserName:usermodel.username
                                                                     Face:usermodel.face
                                                                 RoomName:[bodyDic lzNSStringForKey:@"channelid"]
                                                                    Other:@{@"dialogid":[dataDic lzNSStringForKey:@"container"]}
                                                                  IsVideo:NO];
                /* 设置正在通话中状态 */
                self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVoice;
            } else if ([handlertype isEqualToString:Handler_Message_LZChat_VideoCall]) {
                
                [[LZChatVideoModel shareInstance] addChatWaitViewUserName:usermodel.username
                                                                     Face:usermodel.face
                                                                 RoomName:[bodyDic lzNSStringForKey:@"channelid"]
                                                                    Other:@{@"dialogid":[dataDic lzNSStringForKey:@"container"]}
                                                                  IsVideo:YES];
                /* 设置正在通话中状态 */
                self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVideo;
            }
        }
        /* 我在忙线中 */
        else if (self.appDelegate.lzGlobalVariable.msgCallStatus != MsgCallStatusNone
                 && [[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Call_State_Request]) {
            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                                  usermodel.username,@"username",
                                  [bodyDic lzNSStringForKey:@"channelid"],@"roomname",
                                  [dataDic lzNSStringForKey:@"container"],@"dialogid",
                                  handlertype, @"handlertype", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Busy_Notice object:nil userInfo:info];
        }
        
    });
    return YES;
}


@end
