//
//  MessageParse.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/30.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-30
 Version: 1.0
 Description: 接收、发送消息
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MessageParse.h"
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
#import "MsgPermanentNotificationParse.h"
#import "MsgTempNotificationParse.h"
#import "ErrorDAL.h"
#import "NSDictionary+DicSerial.h"

@interface MessageParse()<EventSyncPublisher>

@end

@implementation MessageParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MessageParse *)shareInstance{
    static MessageParse *instance = nil;
    if (instance == nil) {
        instance = [[MessageParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    if([route isEqualToString:WebApi_Message_Send]){
        [self parseSend:dataDic];
    }
    else if([route isEqualToString:WebApi_Message_Get]){
        /* 在子线程中解析 */
        dispatch_async(self.appDelegate.lzGlobalVariable.msgQueue, ^{
            [self parseGet:dataDic];
        });
    }
    /* 回执成功之后的处理 */
    else if( [route isEqualToString:WebApi_Message_Report]){
        [self parseReport:dataDic];
    }
    /* 删除消息成功 */
    else if([route isEqualToString:WebApi_Message_DeleteMsg]) {
        [self parseDeleteMsg:dataDic];
    }
    /* 撤回消息成功 */
    else if([route isEqualToString:WebApi_Message_RecallMsg]) {
        [self parseRecallMsg:dataDic];
    }
    /* 通话时长保存 */
    else if ([route isEqualToString:WebApi_Message_SaveVideoMsg]) {
        [self parseSaveVideoMsg:dataDic];
    }
    /* 修改是否通知手机端的属性 */
    else if ([route isEqualToString:WebApi_Message_UpdatePushState]) {
        [self parseUpdatePushState:dataDic];
    }
    /* 取消PC的登录 */
    else if ([route isEqualToString:WebApi_Connect_KickOutPC]) {
        [self parseKickOutPC:dataDic];
    }
}

/**
 *  消息发送成功后，服务器端返回的数据
 */
-(void)parseSend:(NSMutableDictionary *)dataDic{
    /* 判断DataContext的正确性 */
    if(![[dataDic objectForKey:WebApi_DataContext] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    /* 发送的消息数据 */
    NSMutableDictionary *sendData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Post];
    /* 接收到服务器返回的消息ID */
    NSMutableDictionary *backInfo  = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSString *sendmsgid = [backInfo objectForKey:@"msgid"];
    NSString *secondmsgid = [backInfo lzNSStringForKey:@"secondmsgid"];
    NSString *clienttempid = [sendData objectForKey:@"clienttempid"];
    
    if(![NSString isNullOrEmpty:secondmsgid]){
        sendmsgid = secondmsgid;
    }
    
    /* 更新msgid和消息的发送状态 */
    [[ImChatLogDAL shareInstance] updateMsgId:sendmsgid withClientTempid:clienttempid withSendstatus:Chat_Msg_SendSuccess];
    
    /* 删除发送队列表中的数据 */
    [[ImMsgQueueDAL shareInstance] deleteImMsgQueueWithMqid:clienttempid];
    
    /* 通知界面进行更新 */
    ImChatLogModel *imChatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:sendmsgid orClienttempid:clienttempid];
    imChatLogModel.sendstatus = Chat_Msg_SendSuccess;
    
    /* 消息发送成功后如果isdel是1的状态(这就说明这条消息是在发送过程中删除的)，就是再次发送删除的API */
    if (imChatLogModel.isdel == 1) {
        /* 重新调用删除的api进行删除 */
        NSMutableArray *msgidArr = [NSMutableArray arrayWithObject:imChatLogModel.msgid];
        NSDictionary *dic = @{@"container":imChatLogModel.dialogid};
        [self.appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_DeleteMsg moduleServer:Modules_Message getData:dic postData:msgidArr otherData:nil];
        /* 再调用撤回api */
        [self.appDelegate.lzservice sendToServerForGet:WebApi_Message routePath:WebApi_Message_RecallMsg moduleServer:Modules_Message getData:@{@"synckey":imChatLogModel.msgid} otherData:nil];        
    }
    /* 将最近联系人表中的lastmsgid更新 */
    [[ImRecentDAL shareInstance] updateLastMsgIDWithMsgid:sendmsgid ContactID:imChatLogModel.dialogid];
    
    /* 需要处理一级消息的状态 */
    clienttempid = [clienttempid stringByAppendingString:@"_First"];
    if(![NSString isNullOrEmpty:secondmsgid]){
        NSString *firstMsgID = [backInfo lzNSStringForKey:@"msgid"];
        
        /* 更新msgid和消息的发送状态 */
        [[ImChatLogDAL shareInstance] updateMsgId:firstMsgID withClientTempid:clienttempid withSendstatus:Chat_Msg_SendSuccess];
        
        /* 通知界面进行更新 */
        ImChatLogModel *imChatLogModelFirst = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:firstMsgID orClienttempid:clienttempid];
        imChatLogModelFirst.sendstatus = Chat_Msg_SendSuccess;
        
        /* 消息发送成功后如果isdel是1的状态(这就说明这条消息是在发送过程中删除的)，就是再次发送删除的API */
        if (imChatLogModelFirst.isdel == 1) {
            /* 重新调用删除的api进行删除 */
            NSMutableArray *msgidArr = [NSMutableArray arrayWithObject:imChatLogModelFirst.msgid];
            NSDictionary *dic = @{@"container":imChatLogModelFirst.dialogid};
            [self.appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_DeleteMsg moduleServer:Modules_Message getData:dic postData:msgidArr otherData:nil];
            /* 再调用撤回api */
            [self.appDelegate.lzservice sendToServerForGet:WebApi_Message routePath:WebApi_Message_RecallMsg moduleServer:Modules_Message getData:@{@"synckey":imChatLogModelFirst.msgid} otherData:nil];
        }
        /* 将最近联系人表中的lastmsgid更新 */
        [[ImRecentDAL shareInstance] updateLastMsgIDWithMsgid:firstMsgID ContactID:imChatLogModelFirst.dialogid];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 刷新聊天窗口 */
        __block MessageParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_UpdateSendStatus, imChatLogModel);
        
        /* 刷新消息页签 */
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForChatVC = YES;
        
        //刷新二级消息
        if(![NSString isNullOrEmpty:secondmsgid]){
            NSString *strToType = [NSString stringWithFormat:@"%ld",imChatLogModel.totype];
            EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshSecondMsgVC, strToType );
        }
    });
}

/**
 *  解析获取到新消息
 */
-(BOOL)parseGet:(NSMutableDictionary *)dataDic{
    BOOL parseResult = YES;
    
    NSMutableArray *dataArrayOri  = [[dataDic lzNSMutableDictionaryForKey:WebApi_DataContext] objectForKey:@"msglist"];
    
    if (dataArrayOri.count>10) {
        NSMutableArray *resultArr = [NSMutableArray array];
        
        NSMutableDictionary *sendTimeMsgDic = [NSMutableDictionary dictionary];
        for (NSDictionary *tmpMsg in dataArrayOri) {
            [sendTimeMsgDic setObject:tmpMsg forKey:[tmpMsg lzNSStringForKey:@"senddatetime"]];
        }
        NSArray *array = [[sendTimeMsgDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *sendTimeSort in array) {
            [resultArr addObject:[sendTimeMsgDic objectForKey:sendTimeSort]];
        }
        
        dataArrayOri = [NSMutableArray arrayWithArray:resultArr];
    }
    /* 发送通知给webviewcontroller */
    if(dataArrayOri.count>0){
        dispatch_async(dispatch_get_main_queue(), ^{
            __block MessageParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_GetMsgForWebView, dataArrayOri);
        });
    }
    
    NSMutableArray *dataArray = [dataArrayOri mutableCopy];
    /* 给最后一条消息添加上标识 */
    if(dataArrayOri.count>0){
        for(int i=(int)dataArrayOri.count-1; i>=0; i--){
            NSMutableDictionary *dataDicForMsg = [NSMutableDictionary dictionaryWithDictionary:[dataArrayOri objectAtIndex:i]];
            NSNumber *numMsgType = [dataDicForMsg objectForKey:@"msgtype"];
            NSInteger msgtype = numMsgType.integerValue;
//            NSNumber *numParseType = [dataDicForMsg objectForKey:@"parsetype"];
//            NSInteger parsetype  = numParseType.integerValue;
            if(msgtype==2){
                [dataDicForMsg setObject:@"1" forKey:@"islastmsg"];
                [dataArray replaceObjectAtIndex:i withObject:dataDicForMsg];
                break;
            }
        }
        for(int i=(int)dataArrayOri.count-1; i>=0; i--){
            NSMutableDictionary *dataDicForMsg = [NSMutableDictionary dictionaryWithDictionary:[dataArrayOri objectAtIndex:i]];
            NSNumber *numMsgType = [dataDicForMsg objectForKey:@"msgtype"];
            NSInteger msgtype = numMsgType.integerValue;
            
            /* 给最后一条持久通知添加上标志 */
            if (msgtype==2 || msgtype==3) {
                [dataDicForMsg setObject:@"1" forKey:@"islastmsgornotice"];
                [dataArray replaceObjectAtIndex:i withObject:dataDicForMsg];
                break;
            }
        }
    }
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForPermanentNotice = NO;
    for(int i=0;i<dataArray.count;i++){
        NSMutableDictionary *newDataDic = [NSMutableDictionary dictionaryWithDictionary:[dataArray objectAtIndex:i]];

        NSNumber *numMsgType = [newDataDic objectForKey:@"msgtype"];
        NSInteger msgtype = numMsgType.integerValue;
        
//        /* 0:只给消息发送   1:只给其它应用发送  2:同时给消息和其它应用发送 */
//        NSNumber *sendMode = [newDataDic lzNSNumberForKey:@"sendmode"];
//        if(sendMode.integerValue==1){
//            continue;
//        }
        
        /* 消息，不需要发回执 */
        NSString *handlertype = [newDataDic objectForKey:@"handlertype"];
        if([handlertype isEqualToString:Handler_Message_LZChat_LZMsgNormal_Text]
           || [handlertype isEqualToString:Handler_Message_LZChat_Image_Download]
           || [handlertype isEqualToString:Handler_Message_LZChat_File_Download]
           || [handlertype isEqualToString:Handler_Message_LZChat_Card]
           || [handlertype isEqualToString:Handler_Message_LZChat_UrlLink]
           || [handlertype isEqualToString:Handler_Message_LZChat_ChatLog]
           || [handlertype isEqualToString:Handler_Message_LZChat_LZTemplateMsg_CooperationShareFile]
           || [handlertype isEqualToString:Handler_Message_LZChat_Voice]
           || [handlertype isEqualToString:Handler_Message_LZChat_VoiceCall]
           || [handlertype isEqualToString:Handler_Message_LZChat_VideoCall]
           || [handlertype isEqualToString:Handler_Message_LZChat_Call_Finish]
           || [handlertype isEqualToString:Handler_Message_LZChat_Call_Unanswer]
           || [handlertype isEqualToString:Handler_Message_LZChat_Call_Main]
           || [handlertype isEqualToString:Handler_Message_LZChat_Micro_Video]
           || [handlertype isEqualToString:Handler_Message_LZChat_Geolocation]){
            /* 记录日志，跟踪20161213，收到已读，数量减一 */
            NSString *errorTitle = [NSString stringWithFormat:@"1：dialogId=%@",[newDataDic lzNSStringForKey:@"container"]];
            [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[newDataDic dicSerial] errortype:Error_Type_Four];
            
        }       
        
        /* 是否需要发送回执 */
        BOOL isSendReport = NO;
        
        /* 临时通知 */
        if(msgtype==1){
            isSendReport = [[MsgTempNotificationParse shareInstance] parse:newDataDic];
        }
        /* 消息 */
        else if(msgtype==2){
            //序列解析时，ImChatLog中已存在此消息时，则不再处理
            if(LeadingCloud_MsgParseSerial){
                NSString *msgid = [newDataDic lzNSStringForKey:@"msgid"];
                if(![NSString isNullOrEmpty:msgid]){
                    if([[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:@""]!=nil){
                        continue;
                    }
                }
            }
            BOOL msgParseResult = [[MsgMessageTypeParse shareInstance] parse:newDataDic];
            //序列解析时，判断解析结果
            if(LeadingCloud_MsgParseSerial){
                if(!msgParseResult){
                    parseResult = NO;
                    break;
                }
            }
        }
        /* 持久化通知 */
        else if(msgtype==3){
            isSendReport = [[MsgPermanentNotificationParse shareInstance] parse:newDataDic];
        }
        
        /* 在最后一条通知或者消息的时候再刷新消息页签 */
        if (self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForPermanentNotice || [[newDataDic lzNSStringForKey:@"islastmsgornotice"] isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
            });
            self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForPermanentNotice = NO;
        }
        
        /* 消息回执处理 */
        NSString *msgid = [newDataDic objectForKey:@"msgid"];
        if( msgtype!=2 ){
            if(isSendReport){
                [self sendReportToServerMsgType:[NSString stringWithFormat:@"%ld",(long)msgtype] msgID:msgid];
            }
            else {
                DDLogError(@"---------未发送消息回执-------------%@",msgid);
            }
        }
        
    }
    return parseResult;
}


/**
 *  消息回执发送成功后，解析数据
 */
-(void)parseReport:(NSMutableDictionary *)dataDic{
    /* 发送的消息数据 */
    NSMutableArray *sendData = [dataDic objectForKey:WebApi_DataSend_Post];
    NSMutableDictionary *getData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Get];
    
    NSString *msgqueue = [getData lzNSStringForKey:@"msgqueue"];
    if([msgqueue isEqualToString:@"1"]){

        NSNumber *result  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        if(result.integerValue==1){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[ImChatLogDAL shareInstance] updateRecvIsRead:sendData];
            });
        }
        
        /* 回执成功之后把队列中的msgid删除 */
        NSArray *post = [dataDic lzNSArrayForKey:WebApi_DataSend_Post];
        for (NSString *msgid in post) {
            /* 根据msgid删除ImMsgQueue */
            [[ImMsgQueueDAL shareInstance] deleteImMsgQueueWithData:msgid];
        }
    }
}

/**
 删除消息成功后解析
 */
- (void)parseDeleteMsg:(NSMutableDictionary *)dataDic {
    NSDictionary *errorDic = [dataDic lzNSMutableDictionaryForKey:WebApi_ErrorCode];
    if ([[errorDic lzNSStringForKey:@"Code"] isEqualToString:@"0"]) {
        /* 删除成功，删除对列中数据 */
        NSMutableArray *msgidArr = [dataDic lzNSMutableArrayForKey:WebApi_DataSend_Post];
        NSDictionary *dialogDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
        for (NSString *msgid in msgidArr) {
            [[ImMsgQueueDAL shareInstance] deleteImMsgQueueDeletedMsgWithData:[NSString stringWithFormat:@"%@,%@", msgid, [dialogDic lzNSStringForKey:@"container"]]];
        }
    }
}

/**
 撤回消息成功后解析
 */
- (void)parseRecallMsg:(NSMutableDictionary *)dataDic {
    NSNumber *result = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *msgid = [[dataDic lzNSDictonaryForKey:WebApi_DataSend_Get] lzNSStringForKey:@"synckey"];

    if (result.integerValue == 1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /* 更改isrecall字段的值 */
            [[ImChatLogDAL shareInstance] updateIsReCall:1 withMsgId:msgid];
            /* cell的高度清0 */
            [[ImChatLogDAL shareInstance] updateHeightForRow:@"" withMsgId:msgid];
            /* 拿到这条消息的chatmodel */
            ImChatLogModel *chatModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:@""];
            ImRecentModel *recentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:chatModel.dialogid];
            /* 判断这条消息是不是最后一条消息 */
            if ([recentModel.lastmsgid isEqualToString:msgid]) {
                /* 更新最近联系人 */
                [[ImRecentDAL shareInstance] updateLastMsgWithDialogid:chatModel.dialogid];//可以换一个
                /* 清空表中的用户名两个字段 */
                [[ImRecentDAL shareInstance] updateLastMsgUserToNullByContactID:chatModel.dialogid];
            }
            
            if(chatModel.imClmBodyModel.parsetype!=0){
                NSInteger contactType = chatModel.totype == Chat_ToType_Five ? Chat_ContactType_Main_App_Seven : Chat_ContactType_Main_App_Eight;
                [[ImRecentDAL shareInstance] updateMsgToNull:[NSString stringWithFormat:@"%ld",contactType]];
            }
            
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block MessageParse * service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RecallMsg, nil);
                
                if(chatModel.imClmBodyModel.parsetype!=0){
                    NSString *strToType = [NSString stringWithFormat:@"%ld",chatModel.totype];
                    EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshSecondMsgVC, strToType );
                }
            });
        });
    }
}

/**
 保存视频通话时长

 @param dataDic
 */
- (void)parseSaveVideoMsg:(NSMutableDictionary *)dataDic {
    NSString *result = [dataDic lzNSStringForKey:WebApi_DataContext];
    if (result) {
        NSLog(@"保存视频通话时长成功");
    }
}

/**
 修改是否通知手机端的属性

 @param dataDic
 */
- (void)parseUpdatePushState:(NSMutableDictionary *)dataDic {
    NSNumber *result = [dataDic lzNSNumberForKey:WebApi_DataContext];
    if (result.integerValue == 1) {
        NSLog(@"修改成功");
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block MessageParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_UpdatePushState, nil);
        });
    }
}

/**
 PC端退出登录

 @param dataDic
 */
- (void)parseKickOutPC:(NSMutableDictionary *)dataDic {
    NSNumber *result = [dataDic lzNSNumberForKey:WebApi_DataContext];
    if (result.integerValue == 1) {
        NSLog(@"PC端退出登录");
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block MessageParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_KickOutPC, nil);
        });
    }
}

#pragma mark -
#pragma mark - 解析数据(服务器返回的ErrorCode非0)

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic{
    
}


@end
