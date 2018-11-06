//
//  PersonRemindViewModel.m
//  LeadingCloud
//
//  Created by gjh on 2018/3/13.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "PersonRemindViewModel.h"
#import "ImChatLogDAL.h"
#import "XHMessage.h"
#import "ImVersionTemplateModel.h"
#import "ImVersionTemplateDAL.h"
#import "NSString+IsNullOrEmpty.h"
#import "UserModel.h"
#import "UserDAL.h"
#import "ImRecentModel.h"
#import "ImRecentDAL.h"
#import "AppDateUtil.h"
#import "ImMsgQueueModel.h"
#import "ImMsgQueueDAL.h"

@implementation PersonRemindViewModel {
    NSString *currentUserID;
    /* 最后一条消息的时间 */
    NSDate *latestShowDate;
}


/**
 获取个人提醒、企业提醒用的消息，最新消息在最上面
 */
- (NSMutableArray *)getMessageDataSource:(NSString *)dialogid startCount:(NSInteger)start queryCount:(NSInteger)count {
    NSMutableArray *resultArray = [NSMutableArray array];
    
    /* 当前用户ID */
    currentUserID = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"];
    /* 从数据库中获取记录(反序，供新版个人提醒使用) */
    NSMutableArray *chatLogArray = [[[ImChatLogDAL alloc] init] getChatLogWithDialogidByASC:dialogid startNum:start queryCount:count];
    for (ImChatLogModel *imChatLogModel in chatLogArray) {
        XHMessage *message = [self convertChatLogModelToXHMessage:imChatLogModel];
        if (message == nil) {
            continue;
        }
        [resultArray addObject:message];
    }
    
    return resultArray;
}

/**
 *  将聊天记录转换为XHMessage对象
 *
 *  @param chatLogModel 聊天记录
 *
 *  @return XHMessage对象
 */
- (XHMessage *)convertChatLogModelToXHMessage:(ImChatLogModel *)chatLogModel {
    
    XHMessage *message = nil;
    BOOL isMsgTemplate = NO;
    
    isMsgTemplate = YES;
    
    /* 模板id */
    NSInteger templateid = chatLogModel.imClmBodyModel.bodyModel.templateid == 0 ? 35 : chatLogModel.imClmBodyModel.bodyModel.templateid;
    NSDictionary *customMsg = chatLogModel.imClmBodyModel.body;
    ImVersionTemplateModel *templateModel = [[ImVersionTemplateDAL shareInstance] getImVersionTemplateModelWithTemplate:templateid];
    /* 在这里处理一下，聊天页面接收不应该展示的模板消息，但是已经接收，兼容处理 */
    
    if (![NSString isNullOrEmpty:templateModel.templates]) {
        CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
        [model serialization:templateModel.templates];
        NSInteger templatetype = model.templatetype;
        if (templatetype != -1 && templateid != 0) {
            message = [[XHMessage alloc] initWithCustomMsg:customMsg customTemplateInfo:[templateModel convertModelToDictionary] sender:@"发送人" timestamp:chatLogModel.showindexdate];
        }
    }
    
    message.imChatLogModel = chatLogModel;
    message.sendStatus = chatLogModel.sendstatus;
    
    if( ![chatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_SR] ){
        if([chatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
            message.bubbleMessageType = XHBubbleMessageTypeSending;
            message.faceid = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"face"];
            
//            [self addReadStatusToMessage:message chatLogModel:chatLogModel];
        } else {
            message.bubbleMessageType = XHBubbleMessageTypeReceiving;
            message.faceid = @"";
            
            UserModel *userModel = [[UserDAL shareInstance] getUserModelForNameAndFace:chatLogModel.from];
            if(userModel!=nil){
                message.sender = userModel.username;
                message.faceid = userModel.face;
            } else {
                [self.appDelegate.lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_LoadUser moduleServer:Modules_Default getData:nil postData:chatLogModel.from otherData:@{WebApi_DataSend_Other_Operate:@"reloadchatview"}];
            }
        }
    }
    // 如果走的模板消息(faceid 设置为空),但是 handlertype 是这个的不重置 faceID
    if(isMsgTemplate && ![chatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_LZTemplateMsg_BSform]){
        message.faceid = @"";
    }
    if ([chatLogModel.handlertype hasPrefix:Handler_Message_LZChat_ConsultNotice]) {
        message.faceid = @"";
        message.bubbleMessageType = XHBubbleMessageTypeReceiving;
        message.messageMediaType = XHBubbleMessageMediaTypeConsultNotice;
    }
    //    message.faceid = @"21882619876630560";
    
    return message;
}

#pragma mark - 自动下载聊天记录

/**
 *  检测是否需要自动下载聊天记录
 */
-(void)checkIsNeedDownChatLog:(NSString *)dialogid{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* 根据对话框ID得到最近消息模型 */
        ImRecentModel *imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:dialogid];
        /* 聊天记录下载到的位置 */
        NSString *preSynck = imRecentModel.presynck;
        NSDate *preSynckDate = imRecentModel.presynckdate;
        
        
        NSMutableDictionary *syncDic = [LZUserDataManager readSynkInfo];
        NSString *synck = [syncDic lzNSStringForKey:[AppUtils GetCurrentUserID]];
        
        //消息、临时通知、持久通知
        NSString *msgSynk = @"";
        if(![NSString isNullOrEmpty:synck]){
            NSArray *array = [synck componentsSeparatedByString:@"_"];
            msgSynk = [array objectAtIndex:0];
        }
        
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setObject:[[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"] forKey:@"uid"];
        [postData setObject:dialogid forKey:@"container"];
        [postData setObject:[NSString stringWithFormat:@"%ld",(long)_contactType] forKey:@"fromtype"];
        [postData setObject:@"1" forKey:@"queryDirection"];
        //    /* 未下载过 */
        //    if([NSString isNullOrEmpty:preSynck] || [NSString isNullOrEmpty:msgSynk]){
        //        [postData setObject:@"" forKey:@"synckey"];
        //        /* 默认下载150条 */
        //        [postData setObject:@"150" forKey:@"datacount"];
        //    } else {
        //        [postData setObject:msgSynk forKey:@"synckeyend"];
        //        /* 根据presynck获取对应聊天记录的时间 */
        //        NSInteger days = [AppDateUtil IntervalDays:preSynckDate endDate:[AppDateUtil GetCurrentDate]];
        //        if(days<=7){
        //            [postData setObject:preSynck forKey:@"synckey"];
        //        } else {
        //            [postData setObject:@"150" forKey:@"datacount"];
        //        }
        //    }
        
        /* 未下载过 */
        if([NSString isNullOrEmpty:preSynck]){
            [postData setObject:@"" forKey:@"synckey"];
            /* 默认下载150条 */
            [postData setObject:@"150" forKey:@"datacount"];
        } else {
            /* 根据presynck获取对应聊天记录的时间 */
            NSInteger days = [AppDateUtil IntervalDays:preSynckDate endDate:[AppDateUtil GetCurrentDate]];
            if(days<=7){
                [postData setObject:preSynck forKey:@"synckeyend"];
                [postData setObject:msgSynk forKey:@"synckey"];// 最近一条消息
                [postData setObject:@"500" forKey:@"datacount"];
            } else {
                [postData setObject:msgSynk forKey:@"synckey"];
                [postData setObject:@"150" forKey:@"datacount"];
            }
        }
        
        [self.appDelegate.lzservice sendToServerForPost:WebApi_ChatLog
                                              routePath:WebApi_ChatLog_GetChatLogList
                                           moduleServer:Modules_Message
                                                getData:nil
                                               postData:postData
                                              otherData:@{WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll}];
    });
}

/**
 *  发送回执
 */
-(void)sendReportToServer:(NSString *)dialogid{
    NSInteger otherNoReadCount = [[ImRecentDAL shareInstance] getImRecentNoReadMsgCountWithExceptDialog:@[dialogid]];
    
    /* 发送消息回执 */
    NSMutableArray *msgids = [[ImChatLogDAL shareInstance] getRecvIsNoReadWithDialogId:dialogid];
    
    //业务会话时，需要把一级消息也发送出回执
    if(_sendToType == Chat_ToType_Five || _sendToType == Chat_ToType_Six ){
        NSMutableArray *msgidsForFirst = [[ImChatLogDAL shareInstance] getRecvIsNoReadWithDialogId:[NSString stringWithFormat:@"%ld",(long)_sendToType]];
        [msgids addObjectsFromArray:msgidsForFirst];
    }
    
    if(msgids.count>0){
        NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
        [getData setObject:@"1" forKey:@"msgqueue"];
        [getData setObject:@"2" forKey:@"type"];
        [getData setObject:[NSString stringWithFormat:@"%ld",(long)otherNoReadCount] forKey:@"badge"];
        for (int i=0; i<msgids.count; i++) {
            /* 记录到发送队列 */
            ImMsgQueueModel *imMsgQueueModel = [[ImMsgQueueModel alloc] init];
            imMsgQueueModel.mqid = [LZUtils CreateGUID];
            imMsgQueueModel.module = Modules_Message_Receipt;
            imMsgQueueModel.route = WebApi_Message_Send;
            imMsgQueueModel.data = [msgids objectAtIndex:i];
            imMsgQueueModel.createdatetime = [AppDateUtil GetCurrentDate];
            imMsgQueueModel.updatedatetime = [AppDateUtil GetCurrentDate];
            [[ImMsgQueueDAL shareInstance] addImMsgQueueModelModel:imMsgQueueModel];
        }
        /* 分组发送 */
        while (msgids.count>0) {
            NSInteger subCount = msgids.count>1000 ? 1000 : msgids.count;
            NSArray *sendMsgids = [msgids subarrayWithRange:NSMakeRange(0,subCount)];
            [msgids removeObjectsInRange:NSMakeRange(0,subCount)];
            [self.appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_Report moduleServer:Modules_Message getData:getData postData:sendMsgids otherData:@{WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll}];
        }
    }
}

#pragma mark - 刷新未读数字、发送回执   （供所有显示在消息页签的VC调用）

/**
 *  刷新未读数字
 */
-(void)refreshMsgUnReadCount:(NSString *)dialogid{
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        if( [[ImRecentDAL shareInstance] getImRecentNoReadMsgCountWithDialogID:dialogid]>0){
            /* 更新未读数量为0 */
            [[ImRecentDAL shareInstance] updateBadgeCountTo0ByContactid:dialogid];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshMessageRootVC:dialogid];
                
                /* 立刻刷新消息列表界面 */
                EVENT_PUBLISH_WITHDATA(self, EventBus_Chat_RefreshMessageRootVC_Now, nil);
                self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForChatVC = NO;
            });
        }
//    });
}


#pragma mark - 消息发送、接收通用方法

/**
 *  添加新的聊天记录
 *
 *  @param chatLogModel 聊天信息
 *
 *  @return XHMessage对象
 */
-(XHMessage *)addNewXHMessageWithImChatLogModel:(ImChatLogModel *)chatLogModel messages:(NSMutableArray *)messages{
    
    XHMessage *message = [self convertChatLogModelToXHMessage:chatLogModel];
    
    if(latestShowDate==nil && messages.count>0){
        XHMessage *xhMessage = [messages objectAtIndex:messages.count-1];
        latestShowDate = xhMessage.imChatLogModel.showindexdate;
    }
    
    message.isDisplayTimestamp = YES;
    /* 记录下最后一次的显示时间 */
    latestShowDate = chatLogModel.showindexdate;
    
    return message;
}

#pragma mark - 刷新消息列表
//刷新消息列表
-(void)refreshMessageRootVC:(NSString *)dialogid {
    self.appDelegate.lzGlobalVariable.chatDialogID = dialogid;
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForChatVC = YES;
}

@end
