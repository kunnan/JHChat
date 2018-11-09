//
//  MsgBaseParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/3/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "MsgBaseParse.h"
#import "ChatViewController.h"
#import "ImRecentModel.h"
#import "ImRecentDAL.h"
#import "NSDictionary+DicSerial.h"
#import "ImChatLogDAL.h"
#import "UserDAL.h"
#import "ImGroupUserDAL.h"
#import "AppDateUtil.h"
#import "ImGroupModel.h"
#import "ImGroupDAL.h"
#import "JSMessageSoundEffect.h"
#import "CooperationDynamicMessageListViewController.h"
#import "CooperationOfNewTaskViewController.h"
#import "NewsFriendViewController.h"
#import "NewsEnterpriseViewController.h"
#import "NewsEmployeeViewController.h"
#import "UserViewModel.h"
#import "CooperationNewMemberViewController.h"
#import "MsgTemplateViewModel.h"
#import "ErrorDAL.h"
#import "WebViewController.h"
#import "NSString+SerialToArray.h"

@implementation MsgBaseParse

/**
 *  判断聊天框是否在主页面
 */
-(BOOL)checkIsOpenChatViewController{
    UIViewController *currentVC = [self.appDelegate.lzGlobalVariable getCurrentViewController];
    
    if([currentVC isKindOfClass:[ChatViewController class]] ){
        return YES;
    }
    
    return NO;
}

/**
 *  判断指定的聊天框是否在主页面
 */
-(BOOL)checkIsOpenTheChatViewController:(ImChatLogModel *)imChatLogModel{
    NSString *dialogid = imChatLogModel.dialogid;
    NSInteger fromtype = imChatLogModel.fromtype;
    NSString *msgid = imChatLogModel.msgid;    
    
    UIViewController *currentVC = [self.appDelegate.lzGlobalVariable getCurrentViewController];
    
    if([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive){
        return NO;
    }
    
    /* 处理业务会话（特殊处理） */
    if(imChatLogModel.totype == Chat_ToType_Five || imChatLogModel.totype == Chat_ToType_Six){
        //二级消息
        if(imChatLogModel.imClmBodyModel.parsetype==1){
            UIViewController *currentVC = [self.appDelegate.lzGlobalVariable getCurrentViewController];
            if([currentVC isKindOfClass:[ChatViewController class]]
               && [self.appDelegate.lzGlobalVariable.currentChatViewControllerDialogid isEqualToString:dialogid] ){
                return YES;
            }
            return NO;
        } else {
            if([self.appDelegate.lzGlobalVariable.currentChatViewControllerDialogid isEqualToString:dialogid] ){
                return YES;
            }
            
            dialogid = [NSString stringWithFormat:@"%ld.%@",imChatLogModel.imClmBodyModel.totype,imChatLogModel.imClmBodyModel.to];
            UIViewController *currentVC = [self.appDelegate.lzGlobalVariable getCurrentViewController];
            if([currentVC isKindOfClass:[ChatViewController class]]
               && [self.appDelegate.lzGlobalVariable.currentChatViewControllerDialogid isEqualToString:dialogid] ){
                return YES;
            }
            return NO;
        }
    }

    /* 系统 */
    if(fromtype == Chat_FromType_Three ){
        
        ImMsgTemplateModel *imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:dialogid];
        
        if(imMsgTemplateModel.type==Chat_MsgTemplate_Two){
            /* 加载本地ViewController */
            if(imMsgTemplateModel.templateModel.templatetype == 1){
                NSString *formname = imMsgTemplateModel.templateModel.platModel.formname;
                if(![NSString isNullOrEmpty:formname] && [currentVC isKindOfClass:NSClassFromString(formname)])
                {
                    return YES;
                }
                else {
                }
            }
            /* 加载WebViewController */
            else if(imMsgTemplateModel.templateModel.templatetype == 2){
                if([currentVC isKindOfClass:[WebViewController class]]
                   && [self.appDelegate.lzGlobalVariable.currentNewWebViewControllerCode isEqualToString:dialogid] ){
                    /* 打开着时，直接发送回执 */
                    NSInteger otherNoReadCount = [[ImRecentDAL shareInstance] getImRecentNoReadMsgCount];
                    NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
                    [getData setObject:@"2" forKey:@"type"];
                    [getData setObject:[NSString stringWithFormat:@"%ld",(long)otherNoReadCount] forKey:@"badge"];
                    [self.appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_Report moduleServer:Modules_Message getData:getData postData:@[msgid] otherData:@{WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll}];
                    
                    return YES;
                }
            }
        }
        else if(imMsgTemplateModel.type==Chat_MsgTemplate_Three){
            if([currentVC isKindOfClass:[ChatViewController class]]
               && [self.appDelegate.lzGlobalVariable.currentChatViewControllerDialogid isEqualToString:dialogid] ){
                return YES;
            }
        }
    }
    /* 组织 */
    else if(fromtype == Chat_FromType_Four ){
        if([currentVC isKindOfClass:[ChatViewController class]]
           && [self.appDelegate.lzGlobalVariable.currentChatViewControllerDialogid isEqualToString:dialogid] ){
            return YES;
        }
    }
    /* 个人提醒 */
    else if(fromtype == Chat_FromType_Five ){
        if([currentVC isKindOfClass:[ChatViewController class]]
           && [self.appDelegate.lzGlobalVariable.currentChatViewControllerDialogid isEqualToString:dialogid] ){
            return YES;
        }
    }
    /* 聊天框 */
    else {
        if([currentVC isKindOfClass:[ChatViewController class]]
           && [self.appDelegate.lzGlobalVariable.currentChatViewControllerDialogid isEqualToString:dialogid] ){
            return YES;
        }
    }
    
    return NO;
}

/**
 *  公用保存方法(新的组织，新的好友，新的员工、新的协作、协作动态，及其它模板消息)
 */
-(BOOL)commonSaveNewsInfo:(NSMutableDictionary *)dataDic recentModel:(ImRecentModel *)recentModel{
   
    /* 记录日志，跟踪20161213，收到已读，数量减一 */
    NSString *errorTitle = [NSString stringWithFormat:@"9：dialogId=%@",[dataDic lzNSStringForKey:@"container"]];
    [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[dataDic dicSerial] errortype:Error_Type_Four];
    
    /* 判断是否已显示未读的相同邀请 */
    NSString *bkid = [dataDic lzNSStringForKey:@"bkid"];
    NSString *handlertype = [dataDic lzNSStringForKey:@"handlertype"];
    NSString *dialogid = [dataDic lzNSStringForKey:@"container"];
//    NSInteger theToType = ((NSNumber *)[dataDic objectForKey:@"totype"]).integerValue;
    
//    /* 处理业务会话（特殊处理） */
//    if(theToType == Chat_ToType_Five
//       || theToType == Chat_ToType_Six){
//        //业务会话不处理bkid
//    } else
    if(![NSString isNullOrEmpty:bkid]
       && [[ImRecentDAL shareInstance] checkIsShowRecentWithContactid:dialogid]
       && [[ImChatLogDAL shareInstance] checkIsExistsSameUnreadMsg:handlertype bkid:bkid]){
        return YES;
    }
  
    /* 计入ChatLog表 */
    ImChatLogModel *imChatLogModel = [[ImChatLogModel alloc] init];

    NSDate *showindexdate = nil;
    if([dataDic objectForKey:@"senddatetime"] != [NSNull null]){
        showindexdate = [LZFormat String2Date:[dataDic objectForKey:@"senddatetime"]];
        showindexdate = [self resetChatLogShowindexDate:showindexdate];
    }
    
    imChatLogModel.msgid = [dataDic objectForKey:@"msgid"];
    imChatLogModel.dialogid = dialogid;
    imChatLogModel.fromtype = ((NSNumber *)[dataDic objectForKey:@"fromtype"]).integerValue;
    imChatLogModel.from = [dataDic objectForKey:@"from"];
    imChatLogModel.totype = ((NSNumber *)[dataDic objectForKey:@"totype"]).integerValue;
    imChatLogModel.to = [dataDic objectForKey:@"to"];
    imChatLogModel.body = [dataDic dicSerial];
    imChatLogModel.showindexdate = showindexdate;
    imChatLogModel.handlertype = [dataDic objectForKey:@"handlertype"];
    imChatLogModel.islastmsg = [dataDic lzNSStringForKey:@"islastmsg"];
    imChatLogModel.islastmsgornotice = [dataDic lzNSStringForKey:@"islastmsgornotice"];
    if(imChatLogModel.imClmBodyModel.status==1){
        imChatLogModel.recvisread = 1;
    } else {
        imChatLogModel.recvisread = 0;
    }
    imChatLogModel.sendstatus = Chat_Msg_SendSuccess;
    imChatLogModel.recvstatus = 0;
    imChatLogModel.isrecordstatus = [dataDic lzNSNumberForKey:@"isrecordstatus"].integerValue;
    BOOL isSaveSuccess = [[ImChatLogDAL shareInstance] addChatLogModel:imChatLogModel];
    if(LeadingCloud_MsgParseSerial && !isSaveSuccess){
        DDLogVerbose(@"commonSaveNewsInfo:保存消息数据到ChatLog表中失败。[消息解析失败]");
        return NO;
    }
    
    /* 更新最近联系人 */
    recentModel.irid = [LZUtils CreateGUID];
    recentModel.contactid = imChatLogModel.dialogid;
    recentModel.lastdate = [LZFormat String2Date:[dataDic objectForKey:@"senddatetime"]];
    recentModel.lastmsg = [dataDic objectForKey:@"content"];
    recentModel.isdel = 0;
    recentModel.showmode = imChatLogModel.imClmBodyModel.sendmode;
    recentModel.contacttype = imChatLogModel.fromtype;
    recentModel.parsetype = imChatLogModel.imClmBodyModel.parsetype;
    recentModel.bkid = bkid;
    
    /* 应用 */
    if(imChatLogModel.fromtype == Chat_FromType_Three){
        ImMsgTemplateModel *imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:recentModel.contactid];
        if(imMsgTemplateModel.type == 1){
            recentModel.contacttype = Chat_ContactType_Main_App_Three;
        }
        else if(imMsgTemplateModel.type == 2){
            recentModel.contacttype = Chat_ContactType_Main_App_Four;
        }
        else if(imMsgTemplateModel.type == 3){
            recentModel.contacttype = Chat_ContactType_Main_App_Five;
        }
    }
    /* 企业 */
    else if(imChatLogModel.fromtype == Chat_FromType_Four){
        recentModel.contacttype = Chat_ContactType_Main_App_Six;
    }
    /* 个人提醒 */
    else if(imChatLogModel.fromtype == Chat_FromType_Five){
        recentModel.contacttype = Chat_ContactType_Main_App_Six;
    }
    
//    /* 处理业务会话（特殊处理） */
//    if(imChatLogModel.totype == Chat_ToType_Five
//       || imChatLogModel.totype == Chat_ToType_Six){
//        if(imChatLogModel.totype == Chat_ToType_Five){
//            recentModel.contactid = Chat_ContactID_Five;
//            recentModel.contacttype = Chat_ContactType_Main_App_Seven;
//        }
//        if(imChatLogModel.totype == Chat_ToType_Six){
//            recentModel.contactid = Chat_ContactID_Six;
//            recentModel.contacttype = Chat_ContactType_Main_App_Eight;
//        }
//        [self afterSaveChatLog:imChatLogModel imRecetnModel:recentModel isChatMessage:YES];
//        return;
//    }
    
    recentModel.relatetype = 0;
    if(![self checkIsOpenTheChatViewController:imChatLogModel] ){
        recentModel.badge = 1;
    }
    else {
        recentModel.badge = 0;
    }
    /* 其它设备已读 */
    if(imChatLogModel.imClmBodyModel.status==1){
        recentModel.badge = 0;
        [[ImRecentDAL shareInstance] updateBadgeCountTo0ByContactid:recentModel.contactid];
        [[ImChatLogDAL shareInstance] updateRecvIsReadWithDialogid:recentModel.contactid];
    }
    
    
    [[ImRecentDAL shareInstance] updateBadgeForNews:recentModel.badge model:recentModel];

    [self afterSaveChatLog:imChatLogModel imRecetnModel:recentModel isChatMessage:NO];
    return YES;
}


#pragma mark - 聊天记录保存完后，提醒

/**
 *  保存消息后的处理
 *
 *  @param imChatLogModel    聊天记录
 *  @param imRecentModel     最近聊天信息
 *  @param isChatMessage     是否为聊天消息
 */
-(void)afterSaveChatLog:(ImChatLogModel *)imChatLogModel imRecetnModel:(ImRecentModel *)imRecentModel isChatMessage:(BOOL)isChatMessage{
    
    NSString *currentUserID = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    NSString *dialogId = imChatLogModel.dialogid;
    
    
    BOOL isRemindMe = NO;
    BOOL isUseTheSound = NO;
    BOOL isRecordMsg = NO;
    
    /* 聊天消息 */
    if(isChatMessage){
        /* 更新最近联系人的lastdate和lastmsg字段 */
        BOOL isGetedContactName = [[ImRecentDAL shareInstance] updateLastMsgWithDialogid:dialogId];

        /* 未在此聊天界面，判断是否有人@自己 */
        if( [imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_LZMsgNormal_Text]){
            // 兼容老版@功能
            NSString *lzremindlist = [NSString stringWithFormat:@"%@,",imChatLogModel.imClmBodyModel.bodyModel.lzremindlist];
            if([lzremindlist rangeOfString:[NSString stringWithFormat:@"%@,",currentUserID]].location != NSNotFound){
                isRemindMe = YES;
            }
            if ([imChatLogModel.at containsString:currentUserID] || [[[[imChatLogModel.at serialToArr] firstObject] lzNSNumberForKey:@"type"] isEqual:@2]) {
                isRemindMe = YES;
            }
        }
        /* 只要是回执消息 */
        if (imChatLogModel.isrecordstatus == 1) {
            isRecordMsg = YES;
        }
        
        /* 需要发送webapi获取当前人，或群的信息 */
        if(!isGetedContactName){
            if(imChatLogModel.totype == Chat_ToType_One
               ||imChatLogModel.totype == Chat_ToType_Two ){
//                NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
//                [getData setObject:imChatLogModel.dialogid forKey:@"groupid"];
                NSDictionary *otherData = @{WebApi_DataSend_Other_Operate:@"update_imrecent"};
//                [self.appDelegate.lzservice sendToServerForGet:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfo moduleServer:Modules_Message getData:getData otherData:otherData];
                
                NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
                [postData setObject:imChatLogModel.dialogid forKey:@"groupid"];
                [postData setObject:[NSNumber numberWithInteger:200] forKey:@"pagesize"];
                [self.appDelegate.lzservice sendToServerForPost:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfoByPages moduleServer:Modules_Message getData:nil postData:postData otherData:otherData];
            }
            else {
                [self.appDelegate.lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_LoadUser moduleServer:Modules_Default getData:nil postData:imChatLogModel.dialogid otherData:@{WebApi_DataSend_Other_Operate:@"update_imrecent"}];
            }
        }
        
        /* 更新消息未读数量，判断是否使用声音 */
        if( [imChatLogModel.from isEqualToString:currentUserID] || imChatLogModel.imClmBodyModel.status==1 ){
            [[ImRecentDAL shareInstance] updateBadgeCountTo0ByContactid:dialogId];
            [[ImChatLogDAL shareInstance] updateRecvIsReadWithDialogid:dialogId];
        }
        else
        {
            /* 未在此聊天界面，更新未查看数量 */
            if(![self checkIsOpenTheChatViewController:imChatLogModel]){
                
                /* 记录日志，跟踪20161213，收到已读，数量减一 */
                NSString *errorTitle = [NSString stringWithFormat:@"10：dialogId=%@",dialogId];
                [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[[imChatLogModel convertModelToDictionary] dicSerial] errortype:Error_Type_Four];
                
                if(imChatLogModel.isrecall != 1){
                    [[ImRecentDAL shareInstance] updateBadgeForAddCount:1 contactid:dialogId];
                }
                /* 更新@信息 */
                if(isRemindMe){
                    [[ImRecentDAL shareInstance] updateIsRemindMe:YES contactid:dialogId];
                }
                /* 更新回执消息信息 */
                if (isRecordMsg) {
                    [[ImRecentDAL shareInstance] updateIsRecordMsg:YES contactid:dialogId];
                }
                
                if( imChatLogModel.totype == Chat_ToType_One || imChatLogModel.totype == Chat_ToType_Two )
                {
                    if(isRemindMe){
                        isUseTheSound = YES;
                    } else {
                        isUseTheSound = ![[ImGroupDAL shareInstance] checkCurrentUserIsDisturb:imChatLogModel.dialogid];
                    }
                }
                else {
                    isUseTheSound = YES;
                }
                
                if(imChatLogModel.isrecall == 1){
                    isUseTheSound = NO;
                }
                if ([imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_VideoCall] ||
                    [imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_VoiceCall] ||
                    [imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Call_Main] ||
                    [imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Call_Finish] ||
                    [imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Call_Unanswer]) {
                    isUseTheSound = NO;
                }
            }
        }
    }
    /* 新的组织，新的好友，新的员工、新的协作、协作动态 消息 */
    else {
        /* 未打开对应的页面 */
        if(![self checkIsOpenTheChatViewController:imChatLogModel] ){
            isUseTheSound = YES;
        }
        if ([imChatLogModel.handlertype isEqualToString:Handler_Cooperation_PostRemind_Count]) {
            // 兼容老版@功能
            if ([imChatLogModel.imClmBodyModel.bodyModel.lzremindlist containsString:currentUserID]) {
                [[ImRecentDAL shareInstance] updateIsRemindMe:YES contactid:dialogId];
            }
            if ([imChatLogModel.at containsString:currentUserID] || [[[[imChatLogModel.at serialToArr] firstObject] lzNSNumberForKey:@"type"] isEqual:@2]) {
                [[ImRecentDAL shareInstance] updateIsRemindMe:YES contactid:dialogId];
            }
        }
    }

    /* 处理业务会话（特殊处理），若为一级消息，则不再进行声音和界面的展示 */
    if((imChatLogModel.totype == Chat_ToType_Five || imChatLogModel.totype == Chat_ToType_Six)
       && imChatLogModel.imClmBodyModel.parsetype==0){
        return;
    }
    /* PC端登录，手机端静音，在前台的时候 */
    if (self.appDelegate.lzGlobalVariable.pcLoginInStatus == PCLoginInStatusInLineNoNotice) {
        isUseTheSound = NO;
    }
    // 如果个人聊天设置免打扰
    ImRecentModel *recentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:dialogId];
    if ([recentModel.isonedisturb isEqualToString:@"1"]) {
        isUseTheSound = NO;
    }
    /* 处理业务会话（特殊处理），若为二级消息，则判断是否是设置免打扰 */
    if ((imChatLogModel.totype == Chat_ToType_Five || imChatLogModel.totype == Chat_ToType_Six)
        && imChatLogModel.imClmBodyModel.parsetype==1) {
        recentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:[[dialogId componentsSeparatedByString:@"."] firstObject]];
        if ([recentModel.isonedisturb isEqualToString:@"1"]) {
            isUseTheSound = NO;
        }
    }
    /* 如果消息中有@本人，还是需要声音提醒 */
    // 兼容老版@功能
    if ([imChatLogModel.imClmBodyModel.bodyModel.lzremindlist containsString:currentUserID]) {
        isUseTheSound = YES;
    }
    if ([imChatLogModel.at containsString:currentUserID] || [[[[imChatLogModel.at serialToArr] firstObject] lzNSNumberForKey:@"type"] isEqual:@2]) {
        isUseTheSound = YES;
    }
    
    /* 是否需要刷新消息页签，同时收到50条消息时，只有收到最后一条才需要刷新 */
    BOOL isNeedShowToUser = NO;
    if([[LZFormat Null2String:imChatLogModel.islastmsg] isEqualToString:@"1"]){
        isNeedShowToUser = YES;
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MsgBaseParse * service = self;
        
        if(isNeedShowToUser){
            /* 处理业务会话（特殊处理） */
            if(imChatLogModel.totype == Chat_ToType_Five || imChatLogModel.totype == Chat_ToType_Six){
                //刷新一级消息
                self.appDelegate.lzGlobalVariable.chatDialogID = [NSString stringWithFormat:@"%@.%@",dialogId,imChatLogModel.to];
                self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
//                //刷新二级消息
//                [self.appDelegate.lzGlobalVariable setSeconMsgListRefresh:YES secondChatDialogID:dialogId];
                NSString *strToType = [NSString stringWithFormat:@"%ld",imChatLogModel.totype];
                EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshSecondMsgVC, strToType );
                
                
            } else {
//                self.appDelegate.lzGlobalVariable.chatDialogID = dialogId;
//                self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
            }
            if(isUseTheSound && imChatLogModel.imClmBodyModel.sendmode!=1){
                /* 播放消息声音提醒 */
                [self useTheSound];
            }
        }
        
        NSMutableArray *allMsgArr = [[NSMutableArray alloc] init];
        [allMsgArr addObject:imChatLogModel];
        
        /* 若在后台，且非本人发送的消息，则需要发送本地通知 */
        if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive
            && ![imChatLogModel.from isEqualToString:currentUserID]
            && imChatLogModel.imClmBodyModel.status!=1
            && imChatLogModel.imClmBodyModel.sendmode!=1
            && [[LZUserDataManager getCodeStr] rangeOfString:imChatLogModel.dialogid].location == NSNotFound){ //判断是否处于前台页面
            
            /* 若在后台，判断 imrecent 表中 isonedisturb，为真不发送本地通知 */
            // 兼容老版@功能
            if ([recentModel.isonedisturb isEqualToString:@"1"] && ![imChatLogModel.imClmBodyModel.bodyModel.lzremindlist containsString:currentUserID]) {
                return;
            }
            if ([recentModel.isonedisturb isEqualToString:@"1"] && ![imChatLogModel.at containsString:currentUserID] && ![[[[imChatLogModel.at serialToArr] firstObject] lzNSNumberForKey:@"type"] isEqual:@2]) {
                return;
            }
            NSDate  *datenow = [AppDateUtil GetCurrentDate];
            NSString *strPreDate = [LZUserDataManager readTheDateForSound];
            long interval = 2;
            if(![strPreDate isEqualToString:@""]){
                NSDate *datePre = [LZFormat String2Date:strPreDate];
                interval = (long)[datenow timeIntervalSince1970] - (long)[datePre timeIntervalSince1970];
            }

            BOOL isUseNotificationSound = NO;
            if(interval>=2){
                //判断播放的时间间隔
                [LZUserDataManager saveTheDateForSound:[LZFormat Date2String:datenow]];  //保存下此次收到消息的时间
                isUseNotificationSound = YES;
            }
            
            NSString *alertBody = @"";
            if(!isChatMessage && imRecentModel!=nil){
                alertBody = [NSString stringWithFormat:@"%@:%@",imRecentModel.contactname,imRecentModel.lastmsg];
            }
            [self startLocalNotification:allMsgArr alertBody:alertBody isUseSound:isUseNotificationSound isRemindMe:isRemindMe];
        }
        else {
            /* 通知聊天窗口(我的好友，新的企业等窗口) */
            EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RecvNewMsg, allMsgArr);
        }
        
    });
}

-(void)startLocalNotification:(NSMutableArray *)allMsgArr
                    alertBody:(NSString *)alertBody
                   isUseSound:(BOOL)isUseSound
                   isRemindMe:(BOOL)isRemindMe{
    int notificationType;
    if (!LZ_IS_IOS8) {
        notificationType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }else{
        notificationType = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    }
    if(notificationType==0 ){ //关闭了通知功能
        return;
    }
    
    NSString *title = @"";
    NSString *message = @"";
    NSDictionary *infoDic = nil;
    BOOL isCallSound = NO;
    if(allMsgArr && allMsgArr.count!=0){
        ImChatLogModel *lastChatLogModel = [allMsgArr objectAtIndex:allMsgArr.count-1];
        
        /* 拍照、图片 */
        if([lastChatLogModel.handlertype hasSuffix:Handler_Message_LZChat_Image_Download]){
            message = lastChatLogModel.imClmBodyModel.content;
        }
        /* 文件 */
        else if([lastChatLogModel.handlertype hasSuffix:Handler_Message_LZChat_File_Download]){
            message = lastChatLogModel.imClmBodyModel.content;
        }
        // url链接
        else if ([lastChatLogModel.handlertype hasSuffix:Handler_Message_LZChat_UrlLink]) {
            message = lastChatLogModel.imClmBodyModel.content;
        }
        // 合并转发消息
        else if ([lastChatLogModel.handlertype hasSuffix:Handler_Message_LZChat_ChatLog]) {
            message = lastChatLogModel.imClmBodyModel.content;
        }
        // 共享文件
        else if ([lastChatLogModel.handlertype hasSuffix:Handler_Message_LZChat_LZTemplateMsg_CooperationShareFile]) {
            message = lastChatLogModel.imClmBodyModel.content;
        }
        /* 视频 */
        else if([lastChatLogModel.handlertype hasSuffix:Handler_Message_LZChat_Micro_Video]){
            message = lastChatLogModel.imClmBodyModel.content;
        }
        /* 语音 */
        else if([lastChatLogModel.handlertype hasSuffix:Handler_Message_LZChat_Voice]){
            message = lastChatLogModel.imClmBodyModel.content;
        }
        /* 语音通话 */
        else if([lastChatLogModel.handlertype hasSuffix:Handler_Message_LZChat_VoiceCall]){
            message = lastChatLogModel.imClmBodyModel.content;
            if ([lastChatLogModel.imClmBodyModel.bodyModel.callstatus isEqualToString:Chat_Call_State_Request]) {
                isCallSound = YES;
            }
        }
        /* 视频通话 */
        else if([lastChatLogModel.handlertype hasSuffix:Handler_Message_LZChat_VideoCall]){
            message = lastChatLogModel.imClmBodyModel.content;
            if ([lastChatLogModel.imClmBodyModel.bodyModel.callstatus isEqualToString:Chat_Call_State_Request]) {
                isCallSound = YES;
            }
        }
        /* 多人视频通话 */
        else if ([lastChatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_Call_Main]){
            message = lastChatLogModel.imClmBodyModel.content;
            isCallSound = YES;
        }
        else if ([lastChatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_Call_Finish]) {
            message = lastChatLogModel.imClmBodyModel.content;
        }
        /* 位置 */
        else if([lastChatLogModel.handlertype hasSuffix:Handler_Message_LZChat_Geolocation]){
            message = lastChatLogModel.imClmBodyModel.content;
        }
        /* 文本 */
        else {
            message = lastChatLogModel.imClmBodyModel.content;
        }
        
        NSString *fromUserName = @"";
        
        UserModel *theUserModel = [[UserDAL shareInstance] getUserDataWithUid:lastChatLogModel.from];
        /* 从网络同步请求此人信息 */
        if(theUserModel==nil){
            theUserModel = [[[UserViewModel alloc] init] getUserInfoAsynMode:lastChatLogModel.from];
        }
        if(theUserModel!=nil){
            fromUserName = theUserModel.username;
        }
        
        /* 单人 */
        if(lastChatLogModel.totype == Chat_ToType_Zero){
            title = fromUserName;
        }
        else {
            NSString *groupName = @"";
            ImGroupModel *groupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:lastChatLogModel.to];
            /* 从网络同步请求群信息 */
            if(groupModel == nil){
                groupModel = [[[UserViewModel alloc] init]  getImGroupInfoAsynMode:lastChatLogModel.to];
            }
            if(groupModel!=nil){
                groupName = groupModel.name;
            }
            
            title = [NSString stringWithFormat:@"%@(%@)",fromUserName,groupName];
        }
        
        if(!isRemindMe){
            BOOL isdisturb = YES;
            if( lastChatLogModel.totype == Chat_ToType_One || lastChatLogModel.totype == Chat_ToType_Two )
            {
                isdisturb = ![[ImGroupDAL shareInstance] checkCurrentUserIsDisturb:lastChatLogModel.dialogid];
            }
            
            if(!isdisturb){
                return;
            }
        }
        
        /* 点击通知栏，添加信息 */
        NSString *cType = @"" ;
        if(lastChatLogModel.fromtype == Chat_FromType_Zero
           || lastChatLogModel.fromtype == Chat_FromType_One
           || lastChatLogModel.fromtype == Chat_FromType_Two ){
            cType = [NSString stringWithFormat:@"%ld",lastChatLogModel.totype];
        }
        infoDic = [NSDictionary dictionaryWithObjectsAndKeys:cType,@"ctype",lastChatLogModel.dialogid,@"container",lastChatLogModel.msgid, @"msgid",nil];
    }
    
    /* 收到的消息的时间 */
    ImChatLogModel *imChatLogModel = [allMsgArr lastObject];
    NSString *sendDateTime = imChatLogModel.imClmBodyModel.senddatetime;
    /* 当前时间 */
    NSString *currentDate = [AppDateUtil GetCurrentDateForString];
    /* 两个时间点相差分钟数 */
    NSInteger intervalMinutes = [AppDateUtil IntervalMinutesForString:sendDateTime endDate:currentDate];
    
    /* iOS10下发送本地通知 */
    if (LZ_IS_IOS10) {
        // 1.创建通知内容
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        /* PC端登录，手机端静音，在后台的时候，(如果为5分钟之前的消息，则不进行通知栏提醒，只是显示数量) */
        if (self.appDelegate.lzGlobalVariable.pcLoginInStatus != PCLoginInStatusInLineNoNotice) {
            if (intervalMinutes <= 5) {
                if(isUseSound){
                    if (isCallSound) {
                        content.sound = [UNNotificationSound soundNamed:@"call.caf"];
                    } else {
                        if([LZUserDataManager readIsOpenSoundVoice]){
                            content.sound = [UNNotificationSound defaultSound];
                        }
                    }
                }
                if([NSString isNullOrEmpty:alertBody]){
                    if(![NSString isNullOrEmpty:title] && ![NSString isNullOrEmpty:message]){
                        content.body = [NSString stringWithFormat:@"--%@:%@",title,message];
                    }
                }
                else {
                    content.body = [NSString stringWithFormat:@"--%@",alertBody];
                }
            }
        }
        
        content.badge = [NSNumber numberWithInteger:[[ImRecentDAL shareInstance] getImRecentNoReadMsgCount]];
        content.userInfo = infoDic;
        
        /* 未读数量为0时，需要特殊处理 */
        if(content.badge.integerValue==0){
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }

        // 4.触发模式
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.1 repeats:NO];
        
        // 5.设置UNNotificationRequest
        NSString *requestIdentifer = [LZUtils CreateGUID];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
        
        // 6.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        }];
        
//        if([NSString isNullOrEmpty:alertBody]){
//            if(![NSString isNullOrEmpty:title] && ![NSString isNullOrEmpty:message]){
//                alertBody = [NSString stringWithFormat:@"--%@:%@",title,message];
//            }
//        }
//        else {
//            alertBody = [NSString stringWithFormat:@"--%@",alertBody];
//        }
//        //创建本地通知
//        [self requestLocationNotification:alertBody userInfo:infoDic soundName:nil badge:[NSNumber numberWithInteger:[[ImRecentDAL shareInstance] getImRecentNoReadMsgCount]]];
    }
    /* 不是iOS10下发送本地通知 */
    else {
        /* 组织本地通知 */
        UILocalNotification *localnotifi = [[UILocalNotification alloc] init];
        /* PC端登录，手机端静音，在后台的时候，(如果为5分钟之前的消息，则不进行通知栏提醒，只是显示数量) */
        if (self.appDelegate.lzGlobalVariable.pcLoginInStatus != PCLoginInStatusInLineNoNotice) {
            if (intervalMinutes <= 5) {
                if(isUseSound){
                    if (isCallSound) {
                        localnotifi.soundName = @"call.caf";
                    } else {
                        if([LZUserDataManager readIsOpenSoundVoice]){
                            localnotifi.soundName = UILocalNotificationDefaultSoundName;
                        }
                    }
                }
                if([NSString isNullOrEmpty:alertBody]){
                    if(![NSString isNullOrEmpty:title] && ![NSString isNullOrEmpty:message]){
//                        localnotifi.alertBody = [NSString stringWithFormat:@"%@:%@",title,message];
                        localnotifi.alertBody = [NSString stringWithFormat:@"--%@:%@",title,message];
                    }
                }
                else {
//                    localnotifi.alertBody = alertBody;
                    localnotifi.alertBody = [NSString stringWithFormat:@"--%@",alertBody];
                }
            }
        }
        
        localnotifi.applicationIconBadgeNumber = [[ImRecentDAL shareInstance] getImRecentNoReadMsgCount];
        localnotifi.userInfo = infoDic;
        /* 调度通知 */
        [[UIApplication sharedApplication] scheduleLocalNotification:localnotifi];
        
        /* 未读数量为0时，需要特殊处理 */
        if(localnotifi.applicationIconBadgeNumber==0){
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
    }
}

-(void)useTheSound
{
    /* 处于前台 */
    if( [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
        NSDate  *datenow = [AppDateUtil GetCurrentDate];
        NSString *strPreDate = [LZUserDataManager readTheDateForSound];
        long interval = 2;
        if(![strPreDate isEqualToString:@""]){
            NSDate *datePre = [LZFormat String2Date:strPreDate];
            interval = (long)[datenow timeIntervalSince1970] - (long)[datePre timeIntervalSince1970];
        }
        if(interval>=2){
            //判断播放的时间间隔
            [LZUserDataManager saveTheDateForSound:[LZFormat Date2String:datenow]];  //保存下此次收到消息的时间
            [JSMessageSoundEffect playMessageReceivedSound];
        }
    }
}

#pragma mark - 重新设置消息的接收时间，消息顺序乱的问题

/**
 *  重新设置接收消息的时间，若时间与本地间隔小于一分钟，则按本地时间
 */
-(NSDate *)resetChatLogShowindexDate:(NSDate *)showindexDate{
    
    NSInteger intervalSeconds = [AppDateUtil IntervalSeconds:showindexDate endDate:[AppDateUtil GetCurrentDate]];
    
    DDLogVerbose(@"消息时间间隔为:%ld秒",labs(intervalSeconds));
    if(labs(intervalSeconds)<60){
        return [AppDateUtil GetCurrentDate];
    }
    return showindexDate;
}

/**
 测试iOS10上面的本地通知
 */
-(void)requestLocationNotification:(NSString *)alertBody userInfo:(NSDictionary *)userInfo soundName:(NSString *)soundName badge:(NSNumber *)badge {
    // 1.创建通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//    content.title = @"郭健豪测试通知标题";
//    content.subtitle = @"测试通知副标题";
    content.body = alertBody;
    
    content.badge = badge;
    // 2.设置通知附件内容
    /*NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"coop_setting_more_app_banner" ofType:@"png"];
    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if (error) {
        NSLog(@"attachment error %@", error);
    }
    content.attachments = @[att];*/
    content.userInfo = userInfo;
    /* 从通知进入app显示的图片 */
    content.launchImageName = @"icon_certification_status1@2x";
    // 2.设置声音
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    // 3.设置创建一个 category
    /* 添加选择目录 */
//    UNTextInputNotificationAction *textAction = [UNTextInputNotificationAction actionWithIdentifier:@"my_text" title:@"文字回复" options:UNNotificationActionOptionForeground textInputButtonTitle:@"输入" textInputPlaceholder:@"默认文字"];
    UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"my_action" title:@"取消" options:UNNotificationActionOptionDestructive];
    UNNotificationAction *action_1 = [UNNotificationAction actionWithIdentifier:@"my_action_1" title:@"进入应用" options:UNNotificationActionOptionForeground];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"my_category" actions:@[action_1,action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    NSSet *setting = [NSSet setWithObjects:category, nil];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:setting];
    content.categoryIdentifier = @"my_category";
    // 4.触发模式
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
    
    // 5.设置UNNotificationRequest
    NSString *requestIdentifer = @"TestRequest";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    
    // 6.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

//NSString *newMsgID = @"223271487828533249";
//newMsgID = @"223316165256945664";
//
//NSString *a = @"{\"isdel\" : 0,\"msgid\" : \"{msgid}\",\"heightforrow\" : \"\",\"dialogid\" : \"222279142777692160\",\"totype\" : 1,\"sendstatus\" : 3,\"fromtype\" : 0,\"textmsgsize\" : \"\",\"body\" : \"{body}\",\"isrecall\" : 0,\"clienttempid\" : \"\",\"to\" : \"222279142777692160\",\"handlertype\" : \"message.lzchat.lzmsgnormal.text\",\"from\" : \"161290315250929664\",\"recvstatus\" : 0,\"recvisread\" : 0,\"islastmsg\" : \"1\",\"isrecordstatus\" : 0}";
//
//a = [a stringByReplacingOccurrencesOfString:@"{msgid}" withString:newMsgID];
//
//ImChatLogModel *newImChatLogModel = [[ImChatLogModel alloc] init];
//[newImChatLogModel serialization:a];
//
//newImChatLogModel.body = @"{\"container\":\"222279142777692160\",\"isdel\" : 0,\"belongmsg\" : {\"isrecordstatus\" : 0,\"uid\" : \"161290315250929664\",\"msgid\" : \"223271487828533248\",\"container\" : \"222279142777692160\"},\"status\" : 0,\"msgid\" : \"{msgid}\",\"clienttype\" : 0,\"msgtype\" : 2,\"content\" : \"1234567890\",\"belongto\" : \"160939694555533312\",\"totype\" : 1,\"senddatetime\" : \"2017-09-08T10:41:09\",\"parsetype\" : 0,\"self\" : 0,\"isrecall\" : 0,\"fromtype\" : 0,\"body\" : {},\"to\" : \"222279142777692160\",\"handlertype\" : \"message.lzchat.lzmsgnormal.text\",\"from\" : \"161290315250929664\",\"readstatus\" : \"{}\",\"sendusername\" : \"王三\",\"sendmode\" : 0,\"isrecordstatus\" : 0,\"islastmsg\" : \"1\",\"senduserface\" : \"161290315775225856\"}";
//newImChatLogModel.body = [newImChatLogModel.body stringByReplacingOccurrencesOfString:@"{msgid}" withString:newMsgID];
//
//NSMutableArray *allMsgArr = [[NSMutableArray alloc] init];
//[allMsgArr addObject:newImChatLogModel];
//
//__block MessageRootViewController * service = self;
//EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RecvNewMsg, allMsgArr);

@end
