//
//  MsgPermanentNotificationParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/3/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-12
 Version: 1.0
 Description: 持久通知解析处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgPermanentNotificationParse.h"
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


@interface MsgPermanentNotificationParse()<EventSyncPublisher>

@end

@implementation MsgPermanentNotificationParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MsgPermanentNotificationParse *)shareInstance{
    static MsgPermanentNotificationParse *instance = nil;
    if (instance == nil) {
        instance = [[MsgPermanentNotificationParse alloc] init];
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
    
    /* 另一个客户端已读消息 */
    if( [handlertype isEqualToString:Handler_PerNoti_IsRead]){
        [self parseIsRead:dataDic];
    }
    /* 已读消息处理 */
    else if( [handlertype isEqualToString:Handler_PerNoti_ReadedList]){
        [self parseReadedList:dataDic];
    }
}

#pragma mark - 解析对方已读消息数据

/**
 *  解析另一个客户端已读消息
 */
-(void)parseIsRead:(NSMutableDictionary *)dataDic{
    NSString *contactid = [[dataDic objectForKey:@"body"] objectForKey:@"belongcontainer"];
    [[ImRecentDAL shareInstance] updateBadgeCountTo0ByContactid:contactid];
    
    /* 收到另一个客户端的已读消息,通知界面刷新 */
    __block MsgPermanentNotificationParse * service = self;
    EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshMessageRootVC, nil);
}

/**
 *  解析已读消息
 */
-(void)parseReadedList:(NSMutableDictionary *)dataDic{
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
    }
    
    /* 更新已读消息，通知ViewController */
    [[ImChatLogDAL shareInstance] updateReadedListForOne:readedOneListArr];
    [[ImChatLogDAL shareInstance] updateReadedListForGroup:readedGroupListArr];
    
    /* 未打开聊天窗口时，不处理 */
    if( ![self checkIsOpenChatViewController] ){
        return;
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
    
    /* 通知聊天窗口 */
    __block MsgPermanentNotificationParse * service = self;
    EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RecvReadList, sendArray);
}

@end
