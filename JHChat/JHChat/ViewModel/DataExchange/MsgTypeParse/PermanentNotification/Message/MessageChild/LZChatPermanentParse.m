//
//  LZChatPermanentParse.m
//  LeadingCloud
//
//  Created by gjh on 2017/8/3.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZChatPermanentParse.h"
#import "AppUtils.h"
#import "UserModel.h"
#import "UserDAL.h"
#import "LZChatVideoModel.h"
#import "AppDateUtil.h"
#import "ImGroupCallDAL.h"
#import "ImGroupCallModel.h"
#import "NSArray+ArraySerial.h"
#import "NSString+SerialToArray.h"
#import "ImGroupModel.h"
#import "ImGroupDAL.h"

@implementation LZChatPermanentParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+ (LZChatPermanentParse *)shareInstance {
    static LZChatPermanentParse *instance = nil;
    if (instance == nil) {
        instance = [[LZChatPermanentParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析持久通知数据

/**
 *  解析持久通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    if ([[dataDic lzNSNumberForKey:@"self"] integerValue] == 3) {
        return NO;
    }
    
    NSString *handlertype = [dataDic lzNSStringForKey:@"handlertype"];
    NSString *callStatus = [[dataDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"callstatus"];
    
    BOOL isSendReport = NO;
    /* 如果当前聊天室为空或者聊天室和当前聊天室一样 */
//    if ([NSString isNullOrEmpty:[[LZChatVideoModel shareInstance] roomName]] ||
//        [[[LZChatVideoModel shareInstance] roomName] isEqualToString:[[dataDic lzNSMutableDictionaryForKey:@"body"] lzNSStringForKey:@"channelid"]]) {
        NSString *sendDateTime = [dataDic lzNSStringForKey:@"senddatetime"];
        /* 当前时间 */
        NSString *currentDate = [AppDateUtil GetCurrentDateForString];
        /* 两个时间点相差秒数 */
        NSInteger intervalMinutes = [AppDateUtil IntervalSecondsForString:sendDateTime endDate:currentDate];
        /* 一分钟之内 */
        if (intervalMinutes <= 77) {
            if ([handlertype isEqualToString:Handler_Message_LZChat_Call_Receive]) {
                isSendReport = [self parseGroupReceiveCall:dataDic];
            }
            else if([callStatus isEqualToString:Chat_Group_Call_State_Request]){
                isSendReport = [self parseGroupMainCall:dataDic];
            }
            else if ([callStatus isEqualToString:Chat_Group_Call_State_Timeout]) {
                isSendReport = [self parseGroupUnanswerCall:dataDic];
            }
            else if ([callStatus isEqualToString:Chat_Group_Call_State_End]) {
                isSendReport = [self parseGroupFinishCall:dataDic];
            }
            else if ([handlertype isEqualToString:Handler_Message_LZChat_Call_Speech]) {
                isSendReport = [self parseGroupSpeech:dataDic];
            }
            else {
                isSendReport = [self parseGroupNoticeCall:dataDic];
                DDLogError(@"----------------收到处理---群持久通知:%@",dataDic);
            }
        }
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        if ([callStatus isEqualToString:Chat_Group_Call_State_End]) {
            /* 通话结束之后，清除该条记录 */
            [[ImGroupCallDAL shareInstance] deleteImGroupCallModelWithGroupId:[dataDic lzNSStringForKey:@"container"]];
            [userInfo setObject:@0 forKey:@"userscount"];
        } else if ([callStatus isEqualToString:Chat_Group_Call_State_Request]) {
            ImGroupCallModel *groupCallModel = [[ImGroupCallModel alloc] init];
            groupCallModel.groupid = [dataDic lzNSStringForKey:@"container"];
            groupCallModel.status = callStatus;
            groupCallModel.chatusers = [[dataDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"chatusers"];
            groupCallModel.usercout = [[[dataDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"chatusers"] serialToArr].count;
            groupCallModel.starttime = [LZFormat String2Date:[dataDic lzNSStringForKey:@"senddatetime"]];
            groupCallModel.roomname = [[dataDic lzNSMutableDictionaryForKey:@"body"] lzNSStringForKey:@"channelid"];
            groupCallModel.iscallother = [[dataDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"iscallother"];
            groupCallModel.initiateuid = [dataDic lzNSStringForKey:@"from"];
            [[ImGroupCallDAL shareInstance] addImGroupCallModel:groupCallModel];
            [userInfo setObject:[NSNumber numberWithInteger:groupCallModel.usercout] forKey:@"userscount"];
        } else if ([callStatus isEqualToString:Chat_Group_Call_State_Update]) {
            ImGroupCallModel *groupCallModel = [[ImGroupCallModel alloc] init];
            groupCallModel.groupid = [dataDic lzNSStringForKey:@"container"];
            groupCallModel.realchatusers = [[dataDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"realchatusers"];
            groupCallModel.realusercount = [[[dataDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"realchatusers"] serialToArr].count;
            [[ImGroupCallDAL shareInstance] updateImGroupCallRealChatWithGroupId:groupCallModel];
        } else {
            if(![callStatus isEqualToString:Chat_Group_Call_State_Receive] && ![callStatus isEqualToString:Chat_Group_Call_State_Speech] && ![callStatus isEqualToString:@""]) {
                ImGroupCallModel *groupCallModel = [[ImGroupCallModel alloc] init];
                groupCallModel.groupid = [dataDic lzNSStringForKey:@"container"];
                groupCallModel.status = callStatus;
                groupCallModel.chatusers = [[dataDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"chatusers"];
                groupCallModel.usercout = [[[dataDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"chatusers"] serialToArr].count;
                groupCallModel.updatetime = [LZFormat String2Date:[dataDic lzNSStringForKey:@"senddatetime"]];
                [[ImGroupCallDAL shareInstance] updateImGroupCallModelWithGroupId:groupCallModel];
                [userInfo setObject:[NSNumber numberWithInteger:groupCallModel.usercout] forKey:@"userscount"];
            }
        }
        self.appDelegate.lzGlobalVariable.chatDialogID = [dataDic lzNSStringForKey:@"container"];
//        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForPermanentNotice = YES;
        if (userInfo.count != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeCallUserMember" object:nil userInfo:userInfo];
        }
//    }
    
    return isSendReport;
}

- (BOOL)parseGroupMainCall:(NSMutableDictionary *)dataDic {
    NSMutableDictionary *bodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
    /* 更新iscallother */
    ImGroupModel *imGroupModel = [[ImGroupDAL shareInstance]getImGroupWithIgid:[dataDic lzNSStringForKey:@"container"]];
    [[ImGroupCallDAL shareInstance] updateImGroupCallIsCallOtherWithGroupId:[bodyDic lzNSStringForKey:@"iscallother"]
                                                                    groupid:[dataDic lzNSStringForKey:@"container"]];
    NSMutableArray *userArr = [[bodyDic lzNSStringForKey:@"chatusers"] serialToArr];
    NSString *allUidStr = @"";
    for (NSDictionary *dic in userArr) {
        allUidStr = [allUidStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic lzNSStringForKey:@"uid"]]];
    }
    if ([allUidStr rangeOfString:[AppUtils GetCurrentUserID]].location != NSNotFound) {
        UserModel *usermodel = [[UserDAL shareInstance] getUserDataWithUid:[dataDic lzNSStringForKey:@"from"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.appDelegate.lzGlobalVariable.msgCallStatus == MsgCallStatusNone) {
                /* 设置正在通话中状态 */
//                self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVoice;
                /* 关闭键盘 */
                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                
                if (![[bodyDic lzNSStringForKey:@"iscallother"] isEqualToString:@"0"]) {
                    [[LZChatVideoModel shareInstance] addChatGroupWaitViewUserName:usermodel.username
                                                                               Uid:[dataDic lzNSStringForKey:@"from"]
                                                                              Face:usermodel.face
                                                                          RoomName:[bodyDic lzNSStringForKey:@"channelid"]
                                                                       UserInfoArr:userArr
                                                                             Other:@{@"dialogid":[dataDic lzNSStringForKey:@"container"],
                                                                                     @"contacttype":dataDic[@"totype"],
                                                                                     @"groupname":imGroupModel.name,
                                                                                     @"iscanspeechuid":[imGroupModel.createuser isEqualToString:[AppUtils GetCurrentUserID]] ?@"1":@"0",
                                                                                     @"isinitiateuid":@"0"
                                                                                     }];
                }
            }
        });
    }
    
    return YES;
}

- (BOOL)parseGroupFinishCall:(NSMutableDictionary *)dataDic {
    /* 关闭等待页面 */
    [[LZChatVideoModel shareInstance] closeGroupChatView];
    self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusNone;
    NSMutableDictionary *bodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
    UserModel *usermodel = [[UserDAL shareInstance] getUserDataWithUid:[dataDic lzNSStringForKey:@"from"]];
    if ([[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Group_Call_State_Hangup] ||
        [[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Group_Call_State_Refuse] ||
        [[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Group_Call_State_Timeout]) {
        if ([NSString isNullOrEmpty:[bodyDic lzNSStringForKey:@"chatusers"]]) {
            NSMutableArray *userArry = [[LZChatVideoModel shareInstance] userArry];
            NSMutableArray *tmpArr = [NSMutableArray array];
            for (NSDictionary *tmpDic in userArry) {
                if (![[tmpDic lzNSStringForKey:@"uid"] isEqualToString:[dataDic lzNSStringForKey:@"from"]]) {
                    [tmpArr addObject:tmpDic];
                }
            }
            [[LZChatVideoModel shareInstance] setUserArry:tmpArr];
        } else {
            [[LZChatVideoModel shareInstance] setUserArry:[[bodyDic lzNSStringForKey:@"chatusers"] serialToArr]];
        }
    }
    
    /* 通话成员人数为1 */
    if ([[LZChatVideoModel shareInstance] getRealCallArray].count == 1 && [[[bodyDic lzNSStringForKey:@"chatusers"] serialToArr] count] == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 发送结束通话的消息 */
            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                                  usermodel.username,@"username",
                                  [bodyDic lzNSStringForKey:@"channelid"],@"roomname",
                                  [dataDic lzNSStringForKey:@"container"],@"dialogid",
                                  dataDic[@"totype"],@"contacttype",
                                  [[bodyDic lzNSStringForKey:@"chatusers"] serialToArr],@"userarray", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Finish_Notice object:nil userInfo:info];
            
            /* 关闭选人界面 */
            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_CloseVC_Notice object:nil userInfo:nil];
            NSDictionary *param = @{@"groupid":[dataDic lzNSStringForKey:@"container"], @"callstatus":@"4"};
            NSString *postdatas=[NSString string];
            //字典转字符串
            postdatas=[postdatas dictionaryToJson:param];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __block LZChatPermanentParse * service = self;
                NSDictionary *dicPass = @{@"eventname":@"LCM_ChatVideo_CallStatus_Changed",
                                          @"data":postdatas};
                EVENT_PUBLISH_WITHDATA(service, EventBus_JSNoticeWebView, dicPass);
            });
        });
    }
    
    return YES;
}

- (BOOL)parseGroupReceiveCall:(NSMutableDictionary *)dataDic {
    /* 如果主动加入，就在另一端不让他另一端加入；如果接听或者拒接，就关闭等待页面，也在另一端不让他加入 */
    
    /* 关闭等待页面 */
//    [[LZChatVideoModel shareInstance] closeGroupChatView];
    
    return YES;
}

- (BOOL)parseGroupSpeech:(NSMutableDictionary *)dataDic {
    /*{
     callstatus = "10.5";
     channelid = "144B6FA6-0B03-43D7-8A97-136A1D45DFDF";
     isall = 0;
     type = 1;
     uid = 220096608658788352;
     }*/
    
    NSDictionary *bodyDic = [dataDic lzNSDictonaryForKey:@"body"];
    NSString *currentUid = [AppUtils GetCurrentUserID];
    if ([[bodyDic lzNSStringForKey:@"type"] isEqualToString:@"1"]) {
        if ([[bodyDic lzNSStringForKey:@"isall"] isEqualToString:@"1"] ||
            ([[bodyDic lzNSStringForKey:@"isall"] isEqualToString:@"0"] && [[bodyDic lzNSStringForKey:@"uid"] isEqualToString:currentUid])) {
            
            [[LZChatVideoModel shareInstance] setUserBan:YES];
        }
    } else if ([[bodyDic lzNSStringForKey:@"type"] isEqualToString:@"2"]) {
        
        if ([[bodyDic lzNSStringForKey:@"isall"] isEqualToString:@"1"] ||
            ([[bodyDic lzNSStringForKey:@"isall"] isEqualToString:@"0"] && [[bodyDic lzNSStringForKey:@"uid"] isEqualToString:currentUid])) {
            
            [[LZChatVideoModel shareInstance] setUserBan:NO];
        }
    }  
    return YES;
}

- (BOOL)parseGroupUnanswerCall:(NSMutableDictionary *)dataDic {
    
    [self parseGroupNoticeCall:dataDic];
    
    return YES;
}

- (BOOL)parseGroupNoticeCall:(NSMutableDictionary *)dataDic {
    NSMutableDictionary *bodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
    UserModel *usermodel = [[UserDAL shareInstance] getUserDataWithUid:[dataDic lzNSStringForKey:@"from"]];
    
    ImGroupModel *imGroupModel = [[ImGroupDAL shareInstance]getImGroupWithIgid:[dataDic lzNSStringForKey:@"container"]];
    /* 如果对方发的通知状态是下这三种，就要将我的数组维护一下 */
    if ([[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Group_Call_State_Hangup] ||
        [[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Group_Call_State_Refuse] ||
        [[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Group_Call_State_Timeout] ||
        [[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Group_Call_State_Clear]) {
        // 如果传过来的chatusers是空的，
        if ([NSString isNullOrEmpty:[bodyDic lzNSStringForKey:@"chatusers"]]) {
            NSMutableArray *userArry = [[LZChatVideoModel shareInstance] userArry];
            NSMutableArray *tmpArr = [NSMutableArray array];
            for (NSDictionary *tmpDic in userArry) {
                if (![[tmpDic lzNSStringForKey:@"uid"] isEqualToString:[dataDic lzNSStringForKey:@"from"]]) {
                    [tmpArr addObject:tmpDic];
                }
            }
            [[LZChatVideoModel shareInstance] setUserArry:tmpArr];
        } else {
            [[LZChatVideoModel shareInstance] setUserArry:[[bodyDic lzNSStringForKey:@"chatusers"] serialToArr]];
        }
    }
    /* 邀请某人，接到这个通知的人就更改人员数组 */
    if ([[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Group_Call_State_Invite]) {
        /* 如果自己没有在多人聊天中，呼叫我了就将等待页面弹出 */
        if (self.appDelegate.lzGlobalVariable.msgCallStatus == MsgCallStatusNone) {
            [[LZChatVideoModel shareInstance] setUserArry:[[bodyDic lzNSStringForKey:@"chatusers"] serialToArr]];
            NSMutableArray *userArr = [[bodyDic lzNSStringForKey:@"chatusers"] serialToArr];
            NSString *allUidStr = @"";
            for (NSDictionary *dic in userArr) {
                allUidStr = [allUidStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[dic lzNSStringForKey:@"uid"]]];
            }
            if ([allUidStr rangeOfString:[AppUtils GetCurrentUserID]].location != NSNotFound) {
                UserModel *usermodel = [[UserDAL shareInstance] getUserDataWithUid:[dataDic lzNSStringForKey:@"from"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.appDelegate.lzGlobalVariable.msgCallStatus == MsgCallStatusNone) {
                        /* 设置正在通话中状态 */
//                        self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVoice;
                        /* 关闭键盘 */
                        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                        ImGroupCallModel *callModel = [[ImGroupCallDAL shareInstance] getimGroupCallModelWithGroupid:[dataDic lzNSStringForKey:@"container"]];
                        if (![[bodyDic lzNSStringForKey:@"iscallother"] isEqualToString:@"0"] &&
                            ![callModel.iscallother isEqualToString:@"0"]) {
                            [[LZChatVideoModel shareInstance] addChatGroupWaitViewUserName:usermodel.username
                                                                                       Uid:[dataDic lzNSStringForKey:@"from"]
                                                                                      Face:usermodel.face
                                                                                  RoomName:[bodyDic lzNSStringForKey:@"channelid"]
                                                                               UserInfoArr:userArr
                                                                                     Other:@{@"dialogid":[dataDic lzNSStringForKey:@"container"],
                                                                                             @"contacttype":dataDic[@"totype"],
                                                                                             @"groupname":imGroupModel.name,
                                                                                             @"iscanspeechuid":[imGroupModel.createuser isEqualToString:[AppUtils GetCurrentUserID]] ?@"1":@"0",
                                                                                             @"isinitiateuid":@"0"
                                                                                             }];
                        }
                    }
                });
            }
        }
        /* 如果我在其中，就将视图修改 */
        else {
            /* 添加人 */
            [[LZChatVideoModel shareInstance] addNewMemberToCall:[[bodyDic lzNSStringForKey:@"chatusers"] serialToArr]];
        }
    }
    if ([[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Group_Call_State_Join]) {
        if (self.appDelegate.lzGlobalVariable.msgCallStatus != MsgCallStatusNone) {
            [[LZChatVideoModel shareInstance] addNewMemberToCall:[[bodyDic lzNSStringForKey:@"chatusers"] serialToArr]];
        }
    }
    if ([[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Group_Call_State_Update]) {
        
    }
    /* 通话成员人数为1 */
    if ([[LZChatVideoModel shareInstance] getRealCallArray].count == 1 && [[bodyDic lzNSStringForKey:@"chatusers"] serialToArr].count == 1) {
//        [[bodyDic lzNSStringForKey:@"callstatus"] isEqualToString:Chat_Group_Call_State_Refuse]
        self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusNone;
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 关闭等待页面 */
            [[LZChatVideoModel shareInstance] closeGroupChatView];
            /* 发送结束通话的消息 */
            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                                  usermodel.username,@"username",
                                  [bodyDic lzNSStringForKey:@"channelid"],@"roomname",
                                  [dataDic lzNSStringForKey:@"container"],@"dialogid",
                                  dataDic[@"totype"],@"contacttype",
                                  [[bodyDic lzNSStringForKey:@"chatusers"] serialToArr],@"userarray",
                                  [NSString stringWithFormat:@"%lu",(unsigned long)[[LZChatVideoModel shareInstance] getRealCallArray].count], @"realcount",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Finish_Notice object:nil userInfo:info];
            
            /* 关闭选人界面 */
            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_CloseVC_Notice object:nil userInfo:nil];
        });
    }
    
    return YES;
}
@end
