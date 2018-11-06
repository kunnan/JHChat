//
//  ChatViewPlugin.m
//  LeadingCloud
//
//  Created by wchMac on 16/3/31.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-31
 Version: 1.0
 Description: 聊天框，对应JS插件
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ChatViewPlugin.h"
#import "ChatViewController.h"
#import "NSString+IsNullOrEmpty.h"
#import "ImGroupDAL.h"
#import "ImRecentDAL.h"
#import "ImGroupModel.h"
#import "MessageRootViewController.h"
#import "XHBaseNavigationController.h"
#import "WebViewController.h"
#import "ChatGroupUserListViewController.h"
#import "UserModel.h"
#import "AppDateUtil.h"
#import "UserDAL.h"
#import "LZChatVideoModel.h"
#import "ImGroupCallModel.h"
#import "ImGroupCallDAL.h"
#import "PageTabBarViewController.h"
#import "NSString+SerialToArray.h"
#import "NSDictionary+DicSerial.h"
#import "NSArray+ArraySerial.h"

@interface ChatViewPlugin ()<ContactSelectDelegate>
{
    JSNCRunParameter *tmpRunParameter;
    NSString *dialogId;
    NSInteger contactType;
    AppDelegate *appDelegate;
    
    NSString *timeout;
    NSString *iscallother;
}
@end

@implementation ChatViewPlugin

#pragma mark - 打开聊天框

/**
 *  打开聊天窗口
 *
 *  @param runParameter 运行时参数
 */
-(void)openChatView:(JSNCRunParameter *)runParameter{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    /* 如果实例再次发送了消息，把之前的插件消息记录清空掉，发送一个空的消息回去 */
    if(tmpRunParameter!=nil){
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_None resultData:nil isFinished:YES];
        [self sendRunResult:runResult];
    }
    tmpRunParameter=runParameter;
    
    /* 获取传递过来的参数 */
    NSDictionary *paraDic = runParameter.parameters;
    NSString *contactType = [paraDic lzNSStringForKey:@"contacttype"];
    contactType = [NSString isNullOrEmpty:contactType] ? [paraDic lzNSStringForKey:@"ContactType"] : contactType;
    NSString *dialogID = [paraDic lzNSStringForKey:@"dialogid"];
    dialogID = [NSString isNullOrEmpty:dialogID] ? [paraDic lzNSStringForKey:@"DialogID"] : dialogID;
    
    NSString *popTo = [paraDic lzNSStringForKey:@"PopTo"]; //返回至
    if( [NSString isNullOrEmpty:popTo] ){
        popTo = @"back";
    }
    
    /* 验证参数是否正确 */
    if([NSString isNullOrEmpty:contactType] || [NSString isNullOrEmpty:dialogID]){
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Error resultData:@"ContactType或DialogID不允许为空！" isFinished:YES];
        tmpRunParameter=nil;//将临时变量置空
        [self sendRunResult:runResult];
        return;
    }
    
    /* 创建聊天窗口，并打开 */
    ChatViewController *chatVC = [self createChatViewControllerContactType:contactType.integerValue DialogID:dialogID];
    chatVC.popToViewController = popTo;
    //          fzj     2016-03-20 改用通用的方法，这里会自动返回主线程调用
//    [self pushViewController:chatVC animated:YES];
    [self executeBlockInMainThread:^(UIViewController * _Nonnull controller) {
        if (contactType.integerValue == 2) {
            BOOL isExist = NO;
            for (UIViewController *control in controller.navigationController.viewControllers) {
                if ([control isKindOfClass:[ChatViewController class]]) {
                    ChatViewController *chat = (ChatViewController *)control;
                    if ([chat.dialogid isEqualToString:dialogID]) {
                        isExist = YES;
                        break;
                    }
                }
            }
            if (isExist) {
                ChatViewController *chatVc = [[ChatViewController alloc] init];
                chatVc.contactType = Chat_ContactType_Main_CoGroup;
                chatVc.dialogid = dialogID;
                chatVc.isNotShowOpenWorkGroupBtn = YES;
                chatVc.popToViewController = popTo;
                /* 调用重写的push导航的方法 */
                XHBaseNavigationController * navigat = (XHBaseNavigationController *)controller.navigationController;
                [navigat pushViewControllerr:chatVc animated:YES];
            }
            else {
                chatVC.isNotShowOpenWorkGroupBtn = YES;
                [appDelegate.lzGlobalVariable.messageRootVC pushChatViewControllerContactType:chatVC controller:controller];
            }
        } else {
            [appDelegate.lzGlobalVariable.messageRootVC pushChatViewControllerContactType:chatVC controller:controller];
        }
    }];
    
    
}
#pragma mark -- 获取聊天框未读数量
/**
 获取聊天框未读数量

 @param runParameter runParameter description
 */
-(void)getChatViewMsg:(JSNCRunParameter*)runParameter{
    /* 如果实例再次发送了消息，把之前的插件消息记录清空掉，发送一个空的消息回去 */
    if(tmpRunParameter!=nil){
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_None resultData:nil isFinished:YES];
        [self sendRunResult:runResult];
    }
    tmpRunParameter=runParameter;
    
    NSDictionary *paraDic = runParameter.parameters;
    NSArray *getInfoArr = [paraDic lzNSArrayForKey:@"getinfo"];
    NSString *type = [paraDic lzNSStringForKey:@"type"];
    NSDictionary *commonDic = [paraDic lzNSDictonaryForKey:@"common"];
    NSDictionary *cooperationDic = [paraDic lzNSDictonaryForKey:@"cooperation"];
    
    NSString *eventName = [paraDic lzNSStringForKey:@"eventname"];
    
    NSString *dialogid = [commonDic lzNSStringForKey:@"dialogid"];
    NSString *cid = [cooperationDic lzNSStringForKey:@"cid"];
    //获取未读数量
    if ([getInfoArr containsObject:@"unreadcount"] ) {
        
        if ([type isEqualToString:@"common"]) { // 普通聊天未读消息
            [self getMsgNoRead:dialogid eventName:eventName];
        }
        else if ([type isEqualToString:@"cooperation"]) { // 协作未读消息
            NSString *igid = [[ImGroupDAL shareInstance] getImGroupWithIgidFromWorkGroup:cid];
            if ([NSString isNullOrEmpty:igid]) {
                WEAKSELF
                WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
                    NSString *igid = [dataDic lzNSStringForKey:@"igid"];
                    /* 验证参数是否正确 */
                    if([NSString isNullOrEmpty:igid]){
                        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Error resultData:@"获取群组信息失败！" isFinished:YES];
                        tmpRunParameter=nil;//将临时变量置空
                        [weakSelf sendRunResult:runResult];
                        return;
                    }
                    
                    [self getMsgNoRead:igid eventName:eventName];
                };
                NSDictionary *otherData = @{@"opencooperationchatview":backBlock};
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"relateId"] = cid;
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.lzservice sendToServerForGet:WebApi_ImGroup routePath:WebApi_ImGroup_Info_Relateid moduleServer:Modules_Message getData:param otherData:otherData];
            }
            else {
                [self getMsgNoRead:igid eventName:eventName];
            }
        } else if ([type isEqualToString:@"all"]) { // 获取所有聊天未读消息
            [self getMsgNoRead:@"all" eventName:eventName];
        }
    }
}
-(void)getMsgNoRead:(NSString*)chatid eventName:(NSString*)eventName{
    
    if (![NSString isNullOrEmpty:chatid]) {
        NSInteger noReadMsg = 0;
        if([chatid isEqualToString:@"all"]){
            noReadMsg = [[ImRecentDAL shareInstance] getImRecentNoReadMsgCount];
        } else {
            noReadMsg = [[ImRecentDAL shareInstance] getImRecentNoReadMsgCountWithDialogID:chatid];
        }
        // 发送返回结果 runResultData (NSString)
        NSDictionary *resultDic = @{@"unreadcount":[NSString stringWithFormat:@"%ld",noReadMsg]};
        NSString *resultJson=[NSString string];
        resultJson = [resultJson dictionaryToJson:resultDic];
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Success resultData:resultJson isFinished:YES];
        tmpRunParameter=nil;//将临时变量置空
        [self sendRunResult:runResult];
        
        [self executeBlockInMainThread:^(UIViewController * _Nonnull controller) {
            if ([controller isKindOfClass:[PageTabBarViewController class]]) {
                PageTabBarViewController *pageTab = (PageTabBarViewController*)controller;
                [pageTab.refreshMsgDic setValue:eventName forKey:chatid];// 监听多个消息框
            } else if ([controller isKindOfClass:[WebViewController class]]) {
                WebViewController *webview = (WebViewController*)controller;
                [webview.refreshMsgDic setValue:eventName forKey:chatid];// 监听多个消息框
            }
        }];
    }

    
    
}
#pragma mark - 打开基础协作对应的聊天框

/**
 *  打开基础协作对应的聊天框
 *
 *  @param runParameter 运行时参数
 */
-(void)openCooperationChatView:(JSNCRunParameter *)runParameter{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    /* 如果实例再次发送了消息，把之前的插件消息记录清空掉，发送一个空的消息回去 */
    if(tmpRunParameter!=nil){
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_None resultData:nil isFinished:YES];
        [self sendRunResult:runResult];
    }
    tmpRunParameter=runParameter;
    
    /* 获取传递过来的参数 */
    NSDictionary *paraDic = runParameter.parameters;
    NSString *relateID = [paraDic lzNSStringForKey:@"cid"];
//    NSString *sendmode = [paraDic lzNSStringForKey:@"sendmode"];
    NSString *appcode = [paraDic lzNSStringForKey:@"appcode"];
    NSString *isShowSetting = [paraDic lzNSStringForKey:@"isshowsetting"];
    NSString *popTo = [paraDic lzNSStringForKey:@"PopTo"]; //返回至
    if( [NSString isNullOrEmpty:popTo] ){
        popTo = @"back";
    }
    
    /* 验证参数是否正确 */
    if([NSString isNullOrEmpty:relateID]){
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Error resultData:@"cid不允许为空！" isFinished:YES];
        tmpRunParameter=nil;//将临时变量置空
        [self sendRunResult:runResult]; 
        return;
    }
    
    NSString *igid = [[ImGroupDAL shareInstance] getImGroupWithIgidFromWorkGroup:relateID];
    if([NSString isNullOrEmpty:igid]){
        WEAKSELF
        WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
            NSString *igid = [dataDic lzNSStringForKey:@"igid"];
            
            /* 验证参数是否正确 */
            if([NSString isNullOrEmpty:igid]){
                JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Error resultData:@"获取群组信息失败！" isFinished:YES];
                tmpRunParameter=nil;//将临时变量置空
                [weakSelf sendRunResult:runResult];
                return;
            }
            
            /* 创建聊天窗口，并打开 */
            ChatViewController *chatVC = [weakSelf createChatViewControllerContactType:Chat_ContactType_Main_CoGroup DialogID:igid];
            chatVC.sendToType = 2;
            chatVC.appCode = appcode;
            chatVC.isShowSetting = isShowSetting;
            chatVC.popToViewController = popTo;
            
//            [weakSelf pushViewController:chatVC animated:YES];
//            [appDelegate.lzGlobalVariable.messageRootVC pushChatViewControllerContactType:chatVC controller:weakSelf];
            [weakSelf executeBlockInMainThread:^(UIViewController * _Nonnull controller) {
                BOOL isExist = NO;
                for (UIViewController *control in controller.navigationController.viewControllers) {
                    if ([control isKindOfClass:[ChatViewController class]]) {
                        ChatViewController *chat = (ChatViewController *)control;
                        if ([chat.dialogid isEqualToString:igid]) {
                            isExist = YES;
                            break;
                        }
                    }
                }
                if (isExist) {
                    ChatViewController *chatVc = [[ChatViewController alloc] init];
                    chatVc.contactType = Chat_ContactType_Main_CoGroup;
                    chatVc.dialogid = igid;
                    chatVc.isNotShowOpenWorkGroupBtn = YES;
                    chatVc.sendToType = 2;
                    chatVc.appCode = appcode;
                    chatVc.isShowSetting = isShowSetting;
                    chatVc.popToViewController = popTo;
                    /* 调用重写的push导航的方法 */
                    XHBaseNavigationController *navigat = (XHBaseNavigationController *)controller.navigationController;
                    [navigat pushViewControllerr:chatVc animated:YES];
                }
                else {
                    chatVC.isNotShowOpenWorkGroupBtn = YES;
                    [appDelegate.lzGlobalVariable.messageRootVC pushChatViewControllerContactType:chatVC controller:controller];
                }
            }];
        };
        NSDictionary *otherData = @{@"opencooperationchatview":backBlock};
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"relateId"] = relateID;
        
        [appDelegate.lzservice sendToServerForGet:WebApi_ImGroup routePath:WebApi_ImGroup_Info_Relateid moduleServer:Modules_Message getData:param otherData:otherData];
    }
    else {
        /* 创建聊天窗口，并打开 */
        ChatViewController *chatVC = [self createChatViewControllerContactType:Chat_ContactType_Main_CoGroup DialogID:igid];
//        chatVC.sendMode = sendmode.integerValue;
        chatVC.sendToType = 2;
        chatVC.appCode = appcode;
        chatVC.isShowSetting = isShowSetting;
        chatVC.popToViewController = popTo;
        
//        [self pushViewController:chatVC animated:YES];
//        [appDelegate.lzGlobalVariable.messageRootVC pushChatViewControllerContactType:chatVC controller:self];
        [self executeBlockInMainThread:^(UIViewController * _Nonnull controller) {
            BOOL isExist = NO;
            for (UIViewController *control in controller.navigationController.viewControllers) {
                if ([control isKindOfClass:[ChatViewController class]]) {
                    ChatViewController *chat = (ChatViewController *)control;
                    if ([chat.dialogid isEqualToString:igid]) {
                        isExist = YES;
                        break;
                    }
                }
            }
            if (isExist) {
                ChatViewController *chatVc = [[ChatViewController alloc] init];
                chatVc.contactType = Chat_ContactType_Main_CoGroup;
                chatVc.dialogid = igid;
                chatVc.isNotShowOpenWorkGroupBtn = YES;
                chatVc.sendToType = 2;
                chatVc.appCode = appcode;
                chatVc.isShowSetting = isShowSetting;
                chatVc.popToViewController = popTo;
                /* 调用重写的push导航的方法 */
                XHBaseNavigationController *navigat = (XHBaseNavigationController *)controller.navigationController;
                [navigat pushViewControllerr:chatVc animated:YES];
            }
            else {
                chatVC.isNotShowOpenWorkGroupBtn = YES;
                [appDelegate.lzGlobalVariable.messageRootVC pushChatViewControllerContactType:chatVC controller:controller];
            }
        }];
    }
    
}

#pragma mark - 清除超时人员
- (void)clearOutTimeUser:(JSNCRunParameter *)runParameter {
    NSDictionary *returnDic = [self getDialogIdAndContactType:runParameter];
    NSInteger contactType = [[returnDic lzNSNumberForKey:@"contacttype"] integerValue];
    NSString *dialogId = [returnDic lzNSStringForKey:@"dialogid"];
    
    /* 得到群组的信息 */
    ImGroupModel *toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:dialogId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ImGroupCallModel *groupCallModel = [[ImGroupCallDAL shareInstance] getimGroupCallModelWithGroupid:toGroupModel.igid];
        NSInteger callingCount = groupCallModel.usercout;
        NSLog(@"1---当前通话人数%ld", (long)callingCount);
//        if (callingCount) {
//            self.groupCallNum = callingCount;
//        }
        /* 进入聊天框，更新一下最新的正在聊天的人 */
        if (![NSString isNullOrEmpty:groupCallModel.chatusers]) {
            NSMutableArray *chatUsers = [groupCallModel.chatusers serialToArr];
            NSMutableArray *realChatUsers = [groupCallModel.realchatusers serialToArr];
            NSString *realChatUserStr = @"";
            for (NSNumber *uid in realChatUsers) {
                realChatUserStr = [realChatUserStr stringByAppendingString:[NSString stringWithFormat:@",%@,",[uid stringValue]]];
            }
            NSMutableArray *newChatUsers = [NSMutableArray array];
            NSString *currentAgorauID = @"";
            for (NSDictionary *userDic in chatUsers) {
                if ([realChatUserStr rangeOfString:[NSString stringWithFormat:@",%@,",[userDic[@"agorauid"] stringValue]]].location == NSNotFound) {
                    NSString *currentDate = [AppDateUtil GetCurrentDateForString];
                    /* 两个时间点相差秒数 */
                    NSInteger intervals = [AppDateUtil IntervalSecondsForString:userDic[@"jointime"] endDate:currentDate];
                    if (intervals < 60) {
                        [newChatUsers addObject:userDic];
                    }
                } else {
                    [newChatUsers addObject:userDic];
                }
                if ([userDic[@"uid"] isEqualToString:[AppUtils GetCurrentUserID]]) {
                    currentAgorauID = [userDic[@"agorauid"] stringValue];
                }
            }
            /* 前后数组人数有变化 */
            if (chatUsers.count > newChatUsers.count &&
                [groupCallModel.realchatusers rangeOfString:currentAgorauID].location == NSNotFound) {
                /* 得到最新正在通话的人员 */
                ChatViewController *chat = [self createChatViewControllerContactType:contactType DialogID:dialogId];
                [chat sendVideoCallForGroup:Chat_Group_Call_State_Clear userArr:newChatUsers channelid:groupCallModel.roomname other:nil];
            }
        }
        /* 先将超时人员清除，再成功 */
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Success resultData:nil isFinished:YES];
        tmpRunParameter=nil;//将临时变量置空
        [self sendRunResult:runResult];
    });
}

#pragma mark - 获得通话状态
- (void)getCallStatus:(JSNCRunParameter *)runParameter {
    NSDictionary *returnDic = [self getDialogIdAndContactType:runParameter];
//    NSInteger contactType = [[returnDic lzNSNumberForKey:@"contacttype"] integerValue];
    NSString *dialogId = [returnDic lzNSStringForKey:@"dialogid"];
    NSString *currentID = [AppUtils GetCurrentUserID];
    /* 判断自己是否在聊天 */
    ImGroupModel *toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:dialogId];
    ImGroupCallModel *groupCallModel = [[ImGroupCallDAL shareInstance] getimGroupCallModelWithGroupid:toGroupModel.igid];
    NSMutableDictionary *resultData = [NSMutableDictionary dictionary];
    /* 当前没有通话 */
    if (groupCallModel == nil) {
        [resultData setValue:@"4" forKey:@"status"];
    }
    /* 被邀请待接听 */
    else if (![groupCallModel.realchatusers containsString:currentID] &&
             [groupCallModel.chatusers containsString:currentID] &&
             appDelegate.lzGlobalVariable.msgCallStatus == MsgCallStatusNone){
        [resultData setValue:@"2" forKey:@"status"];
    }
    /* 正在通话中 */
    else if (appDelegate.lzGlobalVariable.msgCallStatus != MsgCallStatusNone){
        [resultData setValue:@"1" forKey:@"status"];
    }
    /* 自己没有在当前视频通话中 */
    else {
        [resultData setValue:@"3" forKey:@"status"];
    }
    
    JSNCRunResult *runResult = [JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Success resultData:[resultData dicSerial] isFinished:NO];
    tmpRunParameter=nil;//将临时变量置空
    [self sendRunResult:runResult];
}

#pragma mark - 打开语音通话（返回已选的人）
- (void)openChatRoom:(JSNCRunParameter *)runParameter {
    
    NSDictionary *returnDic = [self getDialogIdAndContactType:runParameter];
    NSInteger contactType = [[returnDic lzNSNumberForKey:@"contacttype"] integerValue];
    NSString *dialogId = [returnDic lzNSStringForKey:@"dialogid"];
    
    /* 获取传递过来的参数 */
    NSDictionary *paraDic = runParameter.parameters;
    iscallother = [[paraDic lzNSStringForKey:@"iscallother"] isEqualToString:@"0"] ? @"0" : @"1";
    timeout = [[paraDic lzNSStringForKey:@"timeout"] isEqualToString:@""] ? @"60" : @"";
    /* 更新iscallother */
    [[ImGroupCallDAL shareInstance] updateImGroupCallIsCallOtherWithGroupId:iscallother groupid:dialogId];
    ImGroupModel *toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:dialogId];
    /* 当前人不在群组中时，发送消息 */
    if(contactType != Chat_ContactType_Main_One && (toGroupModel==nil || toGroupModel.isclosed==1)){
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Error resultData:@"语音聊天发起失败" isFinished:YES];
        tmpRunParameter=nil;//将临时变量置空
        [self sendRunResult:runResult];
    }
    else if (appDelegate.lzGlobalVariable.msgCallStatus != MsgCallStatusNone) {
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_PluginNotRegist resultData:@"正在语音聊天，不能再次发起" isFinished:YES];
        tmpRunParameter=nil;//将临时变量置空
        [self sendRunResult:runResult];
    }
    //    else if (model.usercout > 0 && [model.chatusers rangeOfString:[AppUtils GetCurrentUserID]].location == NSNotFound) {
    //        [self isJoinGroupCallBtnClick];
    //    }
    else {
        ChatGroupUserListViewController *groupUserVC = [[ChatGroupUserListViewController alloc] init];
        groupUserVC.toGroupModel = toGroupModel;
        groupUserVC.mode = ChatGroupList_SelectGroupMember;
        groupUserVC.pageViewMode = ContactPageViewModeSelect;
        groupUserVC.selectDelegate = self;
        XHBaseNavigationController *navController=[[XHBaseNavigationController alloc]initWithRootViewController:groupUserVC];
        [self presentViewController:navController animated:YES];
    }
}

#pragma mark - 进入聊天室
- (void)enterChatRoom:(JSNCRunParameter *)runParameter {
    NSDictionary *returnDic = [self getDialogIdAndContactType:runParameter];
    NSInteger contactType = [[returnDic lzNSNumberForKey:@"contacttype"] integerValue];
    NSString *dialogId = [returnDic lzNSStringForKey:@"dialogid"];
    
    /* 判断自己是否在聊天 */
    ImGroupModel *toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:dialogId];
    ImGroupCallModel *groupCallModel = [[ImGroupCallDAL shareInstance] getimGroupCallModelWithGroupid:toGroupModel.igid];
    /* 如果自己没有在多人聊天中，呼叫我了就将等待页面弹出 */
    if (appDelegate.lzGlobalVariable.msgCallStatus == MsgCallStatusNone) {
        [[LZChatVideoModel shareInstance] setUserArry:[groupCallModel.chatusers serialToArr]];
        NSMutableArray *userArr = [groupCallModel.chatusers serialToArr];
        NSString *allUidStr = @"";
        for (NSDictionary *dic in userArr) {
            allUidStr = [allUidStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic lzNSStringForKey:@"uid"]]];
        }
        
        NSString *currentUserID = [AppUtils GetCurrentUserID];
        if ([allUidStr rangeOfString:currentUserID].location != NSNotFound) {
            dispatch_async(dispatch_get_main_queue(), ^{
                /* 设置正在通话中状态 */
                appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVoice;
                /* 关闭键盘 */
                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                [[LZChatVideoModel shareInstance] addChatGroupRoomViewRoomName:groupCallModel.roomname
                                                                   UserInfoArr:userArr
                                                                         Other:@{@"dialogid":dialogId,
                                                                                 @"contacttype":[NSNumber numberWithInteger:contactType],
                                                                                 @"groupname":toGroupModel.name,
                                                                                 @"iscanspeechuid":[toGroupModel.createuser isEqualToString:currentUserID] ?@"1":@"0",
                                                                                 @"isinitiateuid":@"0"
                                                                                 }
                                                                       IsVideo:NO];
                ChatViewController *chat = [self createChatViewControllerContactType:contactType DialogID:dialogId];
                /* 插件主动加入通话时，只给自己发送一个通知 */
                [chat sendVideoCallForGroup:Chat_Group_Call_State_Receive userArr:userArr channelid:groupCallModel.roomname other:nil];
            });
        } else {
            NSMutableArray *chatUsers = userArr;
            UserModel *mineModel = [[UserDAL shareInstance] getUserDataWithUid:currentUserID];
            /* 将自己也加到数组中 */
            [chatUsers addObject:@{@"uid":currentUserID, @"face":mineModel.face, @"agorauid":[NSNumber numberWithInteger:[LZUtils getRandomNumber]], @"jointime":[[AppDateUtil GetCurrentDateForString] stringByReplacingOccurrencesOfString:@" " withString:@"T"]}];
            
            /* 添加人 */
            [[LZChatVideoModel shareInstance] addNewMemberToCall:chatUsers];
            /* 设置正在通话中状态 */
            appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVoice;
            [[LZChatVideoModel shareInstance] addChatGroupRoomViewRoomName:groupCallModel.roomname
                                                               UserInfoArr:chatUsers
                                                                     Other:@{@"dialogid":dialogId,
                                                                             @"contacttype":[NSNumber numberWithInteger:contactType],
                                                                             @"groupname":toGroupModel.name,
                                                                             @"iscanspeechuid":[toGroupModel.createuser isEqualToString:currentUserID] ?@"1":@"0",
                                                                             @"isinitiateuid":@"0"
                                                                             }
                                                                   IsVideo:nil];
            ChatViewController *chat = [self createChatViewControllerContactType:contactType DialogID:dialogId];
            /* 给所有人发送消息加通知， */
            [chat sendVideoCallForGroup:Chat_Group_Call_State_Join userArr:chatUsers channelid:@"" other:nil];
            /* 主动加入通话时，只给自己发送一个通知 */
            [chat sendVideoCallForGroup:Chat_Group_Call_State_Receive userArr:chatUsers channelid:@"" other:nil];
        }
    } else {
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Error resultData:@"接听失败" isFinished:YES];
        tmpRunParameter=nil;//将临时变量置空
        [self sendRunResult:runResult];
    }
}
#pragma mark - 拒绝接听
- (void)refuseChatRoom:(JSNCRunParameter *)runParameter {
    NSDictionary *returnDic = [self getDialogIdAndContactType:runParameter];
    NSInteger contactType = [[returnDic lzNSNumberForKey:@"contacttype"] integerValue];
    NSString *dialogId = [returnDic lzNSStringForKey:@"dialogid"];
    
    ImGroupModel *toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:dialogId];
    ImGroupCallModel *groupCallModel = [[ImGroupCallDAL shareInstance] getimGroupCallModelWithGroupid:toGroupModel.igid];
    /* 进入聊天框，更新一下最新的正在聊天的人 */
    if (![NSString isNullOrEmpty:groupCallModel.chatusers]) {
        NSMutableArray *chatUsers = [groupCallModel.chatusers serialToArr];
        
        /* 拒接，就将自己从数组中删除，并发送消息(语音聊天未接听) */
        NSMutableArray *newUserArr = [NSMutableArray array];
        for (NSDictionary *dict in chatUsers) {
            if (![dict[@"uid"] isEqualToString:[AppUtils GetCurrentUserID]]) {
                [newUserArr addObject:dict];
            }
        }
        
        ChatViewController *chat = [self createChatViewControllerContactType:contactType DialogID:dialogId];
        [chat sendVideoCallForGroup:Chat_Group_Call_State_Refuse userArr:newUserArr channelid:groupCallModel.roomname other:nil];
        /* 插件拒绝通话时，只给自己发送一个通知 */
        [chat sendVideoCallForGroup:Chat_Group_Call_State_Receive userArr:newUserArr channelid:groupCallModel.roomname other:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
        });
    }
    /* 先将超时人员清除，再成功 */
    JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Success resultData:@"已拒接" isFinished:YES];
    tmpRunParameter=nil;//将临时变量置空
    [self sendRunResult:runResult];
    
}
#pragma mark - 挂断
- (void)hangUpChatRoom:(JSNCRunParameter *)runParameter {
//    NSDictionary *returnDic = [self getDialogIdAndContactType:runParameter];
//    NSInteger contactType = [[returnDic lzNSNumberForKey:@"contacttype"] integerValue];
//    NSString *dialogId = [returnDic lzNSStringForKey:@"dialogid"];
    
    [[LZChatVideoModel shareInstance] cancelVideoPlugin];
}

#pragma mark - 通过插件参数得到DialogIdAndContactType
- (NSDictionary *)getDialogIdAndContactType:(JSNCRunParameter *)runParameter {
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    /* 如果实例再次发送了消息，把之前的插件消息记录清空掉，发送一个空的消息回去 */
    if(tmpRunParameter!=nil){
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_None resultData:nil isFinished:YES];
        [self sendRunResult:runResult];
    }
    tmpRunParameter=runParameter;
    
    /* 获取传递过来的参数 */
    NSDictionary *paraDic = runParameter.parameters;
    NSString *type = [paraDic lzNSStringForKey:@"type"];
    
    dialogId = @"";
    contactType = 0;
    if ([type isEqualToString:@"2"]) {
        NSString *cid = [paraDic lzNSStringForKey:@"cid"];
        /* 验证参数是否正确 */
        if([NSString isNullOrEmpty:cid]){
            JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Error resultData:@"cid不允许为空！" isFinished:YES];
            tmpRunParameter=nil;//将临时变量置空
            [self sendRunResult:runResult];
            return nil;
        }
        dialogId = [[ImGroupDAL shareInstance] getImGroupWithIgidFromWorkGroup:cid];
        
        if ([NSString isNullOrEmpty:dialogId]) {
            WEAKSELF
            WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
                dialogId = [dataDic lzNSStringForKey:@"igid"];
                /* 验证参数是否正确 */
                if([NSString isNullOrEmpty:dialogId]){
                    JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Error resultData:@"获取群组信息失败！" isFinished:YES];
                    tmpRunParameter=nil;//将临时变量置空
                    [weakSelf sendRunResult:runResult];
                    return;
                }
            };
            NSDictionary *otherData = @{@"opencooperationchatview":backBlock};
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"relateId"] = cid;
            
            [appDelegate.lzservice sendToServerForGet:WebApi_ImGroup routePath:WebApi_ImGroup_Info_Relateid moduleServer:Modules_Message getData:param otherData:otherData];
        }
        contactType = Chat_ContactType_Main_CoGroup;
    } else {
        dialogId = [paraDic lzNSStringForKey:@"dialogid"];
        contactType = [[paraDic lzNSStringForKey:@"contacttype"] integerValue];
    }
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    [returnDic setValue:dialogId forKey:@"dialogid"];
    [returnDic setValue:[NSNumber numberWithInteger:contactType] forKey:@"contacttype"];
    return returnDic;
}

#pragma mark - 选择群成员进行视频通话代理方法
- (void)contactSelectOK:(UIViewController *)controller selectedUserModels:(NSMutableArray *)selectedUserModels otherInfo:(NSMutableDictionary *)otherInfo {
    if ([controller isKindOfClass:[ChatGroupUserListViewController class]] &&
        [[otherInfo objectForKey:@"info"] isEqualToString:@"selectMember"]) {
        if (selectedUserModels.count > 6) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请最多选择6人" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
            [alertView show];
            return;
        }
        /* 发起多人视频通话 */
        NSString *roomID = [LZUtils CreateGUID];
        NSMutableArray *selectArr = [NSMutableArray array];
        for (UserModel *userModel in selectedUserModels) {
            NSInteger uid = [LZUtils getRandomNumber];
            NSDictionary *userDic = @{@"uid":userModel.uid,
                                      @"face":userModel.face,
                                      @"agorauid":[NSNumber numberWithInteger:uid],
                                      @"jointime":[[AppDateUtil GetCurrentDateForString] stringByReplacingOccurrencesOfString:@" " withString:@"T"]};
            [selectArr addObject:userDic];
        }
        UserModel *mineModel = [[UserDAL shareInstance] getUserDataWithUid:[AppUtils GetCurrentUserID]];
        ImGroupModel *toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:dialogId];
        /* 将自己也加到数组中 */
        [selectArr addObject:@{@"uid":[AppUtils GetCurrentUserID],
                               @"face":mineModel.face,
                               @"agorauid":[NSNumber numberWithInteger:[LZUtils getRandomNumber]],
                               @"jointime":[[AppDateUtil GetCurrentDateForString] stringByReplacingOccurrencesOfString:@" " withString:@"T"]}];
        [self dismissViewControllerAnimated:YES];
        /* 设置正在通话中状态 */
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVoice;
        [[LZChatVideoModel shareInstance] addChatGroupRoomViewRoomName:roomID
                                                           UserInfoArr:selectArr
                                                                 Other:@{@"dialogid":dialogId,
                                                                         @"contacttype":[NSNumber numberWithInteger:contactType],
                                                                         @"groupname":toGroupModel.name,
                                                                         @"iscanspeechuid":[toGroupModel.createuser isEqualToString:[AppUtils GetCurrentUserID]] ?@"1":@"0",
                                                                         @"isinitiateuid":@"1"
                                                                         }
                                                               IsVideo:nil];
        /* 发送系统消息（xxx发起视频通话）*/
        ChatViewController *chat = [self createChatViewControllerContactType:contactType DialogID:dialogId];
        [chat sendVideoCallForGroup:Chat_Group_Call_State_Request userArr:selectArr channelid:roomID other:@{@"iscallother":iscallother, @"timeout":timeout}];
        
        /* 发起成功后，返回所选的人 */
        JSNCRunResult *runResult = [JSNCRunResult resultWithRunParameter:tmpRunParameter resultType:JSNCRunResultType_Success resultData:[@{@"chatusers":selectArr} dicSerial] isFinished:YES];
        tmpRunParameter=nil;//将临时变量置空
        [self sendRunResult:runResult];
    }
}

#pragma mark - Private Function

/**
 *  创建聊天窗口
 *
 *  @param contactType 0:单人,1:普通群,2:任务、工作组等群
 *  @param dialogID    聊天框ID
 *
 *  @return 聊天框
 */
-(ChatViewController *)createChatViewControllerContactType:(NSInteger)contactType DialogID:(NSString *)dialogID
{
    ChatViewController *chatViewController = nil;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate.lzSingleInstance.chatDialogDictionary objectForKey:dialogID] == nil)
    {
        chatViewController = [[ChatViewController alloc] init];
        chatViewController.contactType = contactType;
        chatViewController.dialogid = dialogID;
        [appDelegate.lzSingleInstance.chatDialogDictionary setObject:chatViewController forKey:dialogID];
    }
    else
    {
        chatViewController =[appDelegate.lzSingleInstance.chatDialogDictionary objectForKey:dialogID];
        [chatViewController loadInitChatLog:NO newBottomMsgs:nil];
    }
    
    /* 参数重置 */
    chatViewController.popToViewController = nil;
    chatViewController.chatViewDidAppearBlock = nil;
    chatViewController.sendToType = 0;
    chatViewController.appCode = nil;
    chatViewController.isShowSetting = nil;

    return chatViewController;
}


@end
