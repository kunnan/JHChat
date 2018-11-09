//
//  StatusmsgPermanentParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/4/26.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-04-26
 Version: 1.0
 Description: 持久消息--即时消息--状态消息
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "StatusmsgPermanentParse.h"
#import "ImChatLogModel.h"
#import "ImRecentDAL.h"
#import "ImRecentModel.h"
#import "ImChatLogDAL.h"
#import "ErrorDAL.h"
#import "NSDictionary+DicSerial.h"
#import "NSString+SerialToArray.h"
#import "NSArray+ArraySerial.h"

@implementation StatusmsgPermanentParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(StatusmsgPermanentParse *)shareInstance{
    static StatusmsgPermanentParse *instance = nil;
    if (instance == nil) {
        instance = [[StatusmsgPermanentParse alloc] init];
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
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    
    /* 其它设备已读状态消息 */
    if( [handlertype isEqualToString:Handler_Message_StatusMsg_PerNoti_IsRead]){
        isSendReport = [self parseIsRead:dataDic];
    }
    /* 消息已读情况列表 */
    else if( [handlertype isEqualToString:Handler_Message_StatusMsg_PerNoti_ReadedList]){
        isSendReport = [self parseReadedList:dataDic];
    }
    /* 消息撤回通知 */
    else if ([handlertype isEqualToString:Handler_Message_StatusMsg_ReCallMsg]) {
        isSendReport = [self parseRecallMsg:dataDic];
    }
    /* 消息删除通知 */
    else if ([handlertype isEqualToString:Handler_Message_StatusMsg_DeleteMsg]) {
        isSendReport = [self parseDeleteMsg:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---持久消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}


/**
 *  其它设备已读状态消息(应该刷新)
 */
-(BOOL)parseIsRead:(NSMutableDictionary *)dataDic{
    NSString *contactid = [[dataDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"belongcontainer"];
    [[ImRecentDAL shareInstance] updateBadgeCountTo0ByContactid:contactid];
    [[ImChatLogDAL shareInstance] updateRecvIsReadWithDialogid:contactid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 如果处于后台，刷新提醒的数字 */
        if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive){
            [super startLocalNotification:nil alertBody:nil isUseSound:NO isRemindMe:NO];
        }
        
        /* 收到另一个客户端的已读消息,通知界面刷新(不应该刷新) */
//        self.appDelegate.lzGlobalVariable.chatDialogID = contactid;
//        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForPermanentNotice = YES;
        
        /* 刷新二级消息列表 */
        if([contactid hasPrefix:[NSString stringWithFormat:@"%ld.",Chat_ToType_Five]]
           || [contactid hasPrefix:[NSString stringWithFormat:@"%ld.",Chat_ToType_Six]]){
            
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                /* 通知聊天窗口 */
                __block StatusmsgPermanentParse * service = self;
                NSString *strToType = [[contactid componentsSeparatedByString:@"."] objectAtIndex:0];
                EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshSecondMsgVC, strToType );
            });
        }
        
    });
    
    return YES;
}

/**
 *  消息已读情况列表
 */
-(BOOL)parseReadedList:(NSMutableDictionary *)dataDic{
    /* 已读消息数组 */
    NSMutableArray *readedOneListArr = [[NSMutableArray alloc] init];
    NSMutableArray *readedGroupListArr = [[NSMutableArray alloc] init];
    
    NSString *dialogid = [[dataDic objectForKey:@"body"] objectForKey:@"belongcontainer"];
    NSString *msgid = [[dataDic objectForKey:@"body"] objectForKey:@"belongmsgid"];
    NSString *from = [dataDic objectForKey:@"from"];
    
    /* 单人 */
    if( [dialogid isEqualToString:from] ){
        ImChatLogModel *imChatLogModel = [[ImChatLogModel alloc] init];
        imChatLogModel.msgid = msgid;
        imChatLogModel.dialogid = dialogid;
        imChatLogModel.from = from;
        
        [readedOneListArr addObject:imChatLogModel];
    }
    /* 群聊 */
    else {
        ImChatLogModel *imChatLogModel = [[ImChatLogModel alloc] init];
        imChatLogModel.msgid = msgid;
        imChatLogModel.dialogid = dialogid;
        imChatLogModel.from = from;
        
        [readedGroupListArr addObject:imChatLogModel];
        
        /* 记录日志，跟踪20161213，收到已读，数量减一 */
        NSString *errorTitle = [NSString stringWithFormat:@"已读：msgid=%@,from=%@",msgid,from];
        [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[dataDic dicSerial] errortype:Error_Type_Three];
    }
    
    /* 更新已读消息，通知ViewController */
    [[ImChatLogDAL shareInstance] updateReadedListForOne:readedOneListArr];
    [[ImChatLogDAL shareInstance] updateReadedListForGroup:readedGroupListArr];
    /* 未打开聊天窗口时，不处理 */
    if( ![self checkIsOpenChatViewController] ){
        return YES;
    }
    
    /* 打开的聊天窗口，对话框ID */
    NSString *theDialogID = self.appDelegate.lzGlobalVariable.currentChatViewControllerDialogid;
    
    NSMutableArray *sendArray = [[NSMutableArray alloc] init];
    
    for (ImChatLogModel *imChatLogModel in readedOneListArr) {
        if([imChatLogModel.dialogid isEqualToString:theDialogID]){
            [sendArray addObject:imChatLogModel];
        }
    }
    
    if ( sendArray.count ==0 ){
        for (ImChatLogModel *imChatLogModel in readedGroupListArr) {
            if([imChatLogModel.dialogid isEqualToString:theDialogID]){
                [sendArray addObject:imChatLogModel];
            }
        }
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知聊天窗口 */
        __block StatusmsgPermanentParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RecvReadList, sendArray);
    });
        
    return YES;
}
/* 收到撤回消息的通知 */
- (BOOL)parseRecallMsg:(NSMutableDictionary *)dataDic {
    NSDictionary *bodyDic = [dataDic lzNSDictonaryForKey:@"body"];
    NSString *msgid = [bodyDic lzNSStringForKey:@"belongmsgid"];
    NSString *container = [bodyDic lzNSStringForKey:@"belongcontainer"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* 更改isrecall字段的值 */
        [[ImChatLogDAL shareInstance] updateIsReCall:1 withMsgId:msgid];
        /* cell的高度清0 */
        [[ImChatLogDAL shareInstance] updateHeightForRow:@"" withMsgId:msgid];
        ImRecentModel *imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:container];
        /* 最后一条消息时，lastmsguserid和lastmsgusername置空 */
        if([msgid isEqualToString:imRecentModel.lastmsgid]){
            /* 更新最近联系人 */
            [[ImRecentDAL shareInstance] updateLastMsgWithDialogid:container];//可以换一个
            [[ImRecentDAL shareInstance] updateLastMsgUserToNullByContactID:container];
        }
        ImChatLogModel *chatModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:@""];
        /* 如果该撤回的消息没有查看，角标需要减一,并且这条消息要是未读的消息才可以 */
        if( [[ImRecentDAL shareInstance] getImRecentNoReadMsgCountWithDialogID:container]>0 && chatModel.recvisread == 0){
            /* 更新未读数减一 */
            [[ImRecentDAL shareInstance] updateBadgeCountMinus1ByContactid:container];
            
            /* 如果撤销的消息有@内容或者是回执消息，修改一下库 */
            if (chatModel.isrecordstatus == 1) {
                [[ImRecentDAL shareInstance] updateIsRecordMsg:NO contactid:container];
            }
            // 兼容老版@功能
            if ([[chatModel.imClmBodyModel.body lzNSStringForKey:@"lzremindlist"] rangeOfString:chatModel.imClmBodyModel.belongto].location != NSNotFound) {
                [[ImRecentDAL shareInstance] updateIsRemindMe:NO contactid:container];
                
            }
            
            if ([[chatModel.imClmBodyModel.at arraySerial] containsString:chatModel.imClmBodyModel.belongto] || [[[chatModel.imClmBodyModel.at firstObject] lzNSNumberForKey:@"type"] isEqual:@2]) {
                [[ImRecentDAL shareInstance] updateIsRemindMe:NO contactid:container];
            }
            
            /* 在后台时，需要更新通知栏 */
            if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive){
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[ImRecentDAL shareInstance] getImRecentNoReadMsgCount]];
                
                if (LZ_IS_IOS10) {
                    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                    
                    /* - 获取未展示的通知 */
                    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
                        NSLog(@"%@",requests);
                        for (UNNotificationRequest *request in requests) {
                            NSString *identifier = request.identifier;
                            UNNotificationContent *content = request.content;
                            if ([[content.userInfo lzNSStringForKey:@"msgid"] isEqualToString:msgid]) {
                                /* - 移除还未展示的通知 */
                                [center removePendingNotificationRequestsWithIdentifiers: @[identifier]];
                                break;
                            }
                        }                        
                    }];
                    /* - 获取展示过的通知 */
                    [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) { 
                        NSLog(@"%@",notifications);
                        for (UNNotification *notif in notifications) {
                            NSString *identifier = notif.request.identifier;
                            UNNotificationContent *content = notif.request.content;
                            if ([[content.userInfo lzNSStringForKey:@"msgid"] isEqualToString:msgid]) {
                                /* - 移除已经展示过的通知 */
                                [center removeDeliveredNotificationsWithIdentifiers:@[identifier]];
                                break;
                            }
                        }
                    }];
                } else {
                    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
                    for (UILocalNotification *notification in notifications ) {
                        if( [[notification.userInfo lzNSStringForKey:@"msgid"] isEqualToString:msgid] ) {
                            [[UIApplication sharedApplication] cancelLocalNotification:notification];
                            break;
                        }
                    }
                }
            }
            /* 刷新消息页签 */
            self.appDelegate.lzGlobalVariable.chatDialogID = container;
            self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
            self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForPermanentNotice = YES;
        }
        
        
        if(chatModel.imClmBodyModel.parsetype!=0){
            NSInteger contactType = chatModel.totype == Chat_ToType_Five ? Chat_ContactType_Main_App_Seven : Chat_ContactType_Main_App_Eight;
            [[ImRecentDAL shareInstance] updateMsgToNull:[NSString stringWithFormat:@"%ld",contactType]];
        }
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block StatusmsgPermanentParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RecallMsg, nil);
            
            if(chatModel.imClmBodyModel.parsetype!=0){
                NSString *strToType = [NSString stringWithFormat:@"%ld",chatModel.totype];
                EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshSecondMsgVC, strToType );
            }
        });

    });
    
    return YES;
}
/* 收到删除消息的通知 */
- (BOOL)parseDeleteMsg:(NSMutableDictionary *)dataDic {
    /* 用来删除其他客户端的该消息 */
    NSDictionary *bodyDic = [dataDic lzNSDictonaryForKey:@"body"];
    
    /* 在其他客户端删除 */
    NSMutableArray *msgidArr = [bodyDic lzNSMutableArrayForKey:@"msgidlist"];
    NSString *container = [bodyDic lzNSStringForKey:@"container"];
    NSDictionary *premessage = [bodyDic lzNSMutableDictionaryForKey:@"premsg"];
    for (NSString *msgid in msgidArr) {
        /* 修改数据库中删除isdel记录 */
        [[ImChatLogDAL shareInstance] deleteMessageWithMsgid:msgid];

        /* 如果删的是最后一条消息，字典不为空，否则为空 */
        if (premessage.count == 0){
            ImChatLogModel *lastChatLogModel = [[ImChatLogDAL shareInstance] getLastChatLogModelWithDialogId:container];
            if (lastChatLogModel == nil) {
                [premessage setValue:@"" forKey:@"content"];
                [premessage setValue:container forKey:@"container"];
            }
            [[ImRecentDAL shareInstance] updatelastMessageWithDic:premessage isOnlyOneMsg:NO];
            
            if(lastChatLogModel.imClmBodyModel.parsetype!=0 && [lastChatLogModel.dialogid rangeOfString:@"."].location!=NSNotFound){
                NSString *firstDialogID = [[lastChatLogModel.dialogid componentsSeparatedByString:@"."] objectAtIndex:0];
                [[ImRecentDAL shareInstance] updateMsgToNull:firstDialogID];
                dispatch_async(dispatch_get_main_queue(), ^{
                    __block StatusmsgPermanentParse * service = self;
                    EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshSecondMsgVC, firstDialogID);
                });
            }
            
//            self.appDelegate.lzGlobalVariable.chatDialogID = container;
//            self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
            self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForPermanentNotice = YES;
        }
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知聊天窗口 */
        __block StatusmsgPermanentParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_DeleteMsg, bodyDic);
    });
    return YES;
}


@end
