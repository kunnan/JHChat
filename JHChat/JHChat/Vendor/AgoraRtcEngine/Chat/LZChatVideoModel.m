//
//  LZChatVideoModel.m
//  OpenVideoCall
//
//  Created by wang on 17/4/10.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import "LZChatVideoModel.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "LZChatGroupView.h"
#import "KeyCenter.h"
#import "LZChatGroupWaitingView.h"
#import "AppUtils.h"
#import "LZToast.h"
#import "JSMessageSoundEffect.h"
#import "LZVideoSession.h"
#import "AppDelegate.h"

@interface LZChatVideoModel ()<LZVideoWaitingViewDelegate,LZVideoChatDelegate,LZChatGroupWaitingDelegate,LZGroupChatDelegate>{
    
    LZVideoWaitingView *waitView ;
    
    LZChatRoomView *chatView;
    
    LZChatGroupView *groupView;
	
	LZChatGroupWaitingView *groupWaitView;
    
    NSString *_userName; //用户名
    
    NSString *_face ;//头像;
    
//    NSString *_roomName ; //房间号
    
    NSDictionary *_other;  //其他信息
    
    NSInteger _count; //秒数
	
//	NSArray *_userArry;

}
@property (strong, nonatomic) NSTimer *timer;

@property (copy, nonatomic, readwrite)NSString *roomName ; //房间号

@end;

@implementation LZChatVideoModel


+(LZChatVideoModel *)shareInstance{
    
    static LZChatVideoModel *instance = nil;
    if (instance == nil) {
        instance = [[LZChatVideoModel alloc] init];
    }
    return instance;
}

/**
 加入聊天等待View
 
 @return 返回视频是否同意View
 */
- (LZVideoWaitingView*)addChatWaitViewIsVideo:(BOOL)isVideo{
    
    
    waitView = [[LZVideoWaitingView alloc]initWithFrame:[UIScreen mainScreen].bounds IsVideo:isVideo];
    
    waitView.delegate = self;
    [waitView upUserName:_userName Face:_face RoomName:_roomName];
    //添加到Window 上
    [[UIApplication sharedApplication].keyWindow addSubview:waitView];
    return waitView;
}



/**
 聊天等待View
 
 @return 返回视频是否同意View
 */
- (void)addChatWaitViewUserName:(NSString*)userName Face:(NSString*)face RoomName:(NSString*)roomName Other:(NSDictionary*)other IsVideo:(BOOL)isVideo{
    
    /* 播放等待接听的声音 */
    [[JSMessageSoundEffect shareInstance] playVideoCallSound];
    [self upDataUserName:userName Face:face RoomName:roomName Other:other];

    [self addChatWaitViewIsVideo:isVideo];
    
}

- (void)upDataUserName:(NSString*)userName Face:(NSString*)face RoomName:(NSString*)roomName Other:(NSDictionary*)other{
    
    _userName = userName;
    _face = face;
    _roomName = roomName;
    _other = other;
}


#pragma LZVideoWaitingViewDelegate
/**
 挂断
 */
- (void)waitingClose{
    [[JSMessageSoundEffect shareInstance] stopVideoCallSound];
    
    [self addCloseNotification];
    //删除View
    [waitView removeFromSuperview];
    
    //发送拒绝通知
}

/**
 语音接听
 */
- (void)waitingVideoAnswer:(BOOL)isVideo{
    
    /* 播放等待接听的声音 */
    [[JSMessageSoundEffect shareInstance] stopVideoCallSound];
    [self addAcceptNotification];
    [self addChatRoomViewRoomName:_roomName IsVideo:isVideo];
    [waitView removeFromSuperview];
}

/**
 语音接听
 */
- (void)waitingVoiceAnswer{
    [[JSMessageSoundEffect shareInstance] stopVideoCallSound];
    [self addAcceptNotification];

    [self addChatRoomViewRoomName:_roomName IsVideo:NO];
    [waitView removeFromSuperview];

}


#pragma mark LZChatGroupWaitingDelegate 群组
/**
 群组挂断（拒绝）
 */
- (void)groupWaitingClose{
    [[JSMessageSoundEffect shareInstance] stopVideoCallSound];
	
    [self refuseGroupNotification];
	//删除View
	[groupWaitView removeFromSuperview];
	
}


/**
 群组语音接听
 */
- (void)groupWaitingAnswer{
    [[JSMessageSoundEffect shareInstance] stopVideoCallSound];
	
    [self addGroupUserNotification];
	
	[self addChatGroupRoomViewRoomName:_roomName UserInfoArr:_userArry Other:_other IsVideo:NO];
    /* 接听之后，也会开启计时器，但是要关掉 */
    [_timer invalidate];
	
	[groupWaitView removeFromSuperview];
}



/**
 加入聊天View
 
 @return 返回视频View
 */

- (LZChatRoomView*)addChatRoomViewRoomName:(NSString*)roomName IsVideo:(BOOL)isVideo{
    
    chatView = [[LZChatRoomView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    chatView.delegate = self;
    chatView.isVideo = isVideo;
    chatView.roomName = roomName;
    chatView.videoProfile = AgoraRtc_VideoProfile_720P;
    [chatView upChatChannel:roomName UserName:_userName Face:_face];
	
	[[UIApplication sharedApplication].keyWindow addSubview:chatView];

   // [[[UIApplication sharedApplication].windows lastObject] addSubview:chatView];
    [[chatView superview]bringSubviewToFront:chatView];
   // [[[UIApplication sharedApplication].keyWindow superview] bringSubviewToFront:chatView];
    return chatView;

}

/**
 发起聊天View
 @param roomName 唯一标识
 @param isVideo  是否视频
 
 @return
 */

- (void)addChatRoomViewUserName:(NSString*)userName Face:(NSString*)face RoomName:(NSString*)roomName Other:(NSDictionary*)other IsVideo:(BOOL)isVideo{
    
    /* 播放等待接听的声音 */
    [[JSMessageSoundEffect shareInstance] playVideoCallSound];
    [self upDataUserName:userName Face:face RoomName:roomName Other:other];

    [self addChatRoomViewRoomName:roomName IsVideo:isVideo];
    _count =60;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(overTimerFired:) userInfo:nil repeats:YES];
    
}


/**
 呼叫群聊天View
 @param roomName 唯一标识
 @param isVideo  是否视频
 
 @return
 */

- (void)addChatGroupRoomViewRoomName:(NSString*)roomName UserInfoArr:(NSMutableArray*)userArr Other:(NSDictionary*)other IsVideo:(BOOL)isVideo{
    
    /* 播放等待接听的声音 */
    [[JSMessageSoundEffect shareInstance] playVideoCallSound];
	_roomName  = roomName;
	_other = other;
	_userArry = userArr;
    
    _count = 70;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(overTimerFiredGroup:) userInfo:nil repeats:YES];
	
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"108742247792259072",@"face",@"108742247729336320",@"number",@"1",@"uid", nil];
//    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"171783568031100928",@"face",@"171783567309672448",@"number",@"2",@"uid", nil];
//    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"163808895867695104",@"face",@"163808895016243200",@"number",@"3",@"uid", nil];

    NSMutableArray *info = [NSMutableArray arrayWithArray:userArr];

    groupView = [[LZChatGroupView alloc]initWithFrame:[UIScreen mainScreen].bounds];
	groupView.delegate = self;
	
    [groupView upChatChannel:roomName UserInfoArr:info Logo:@"" Other:other];
    
    [[UIApplication sharedApplication].keyWindow addSubview:groupView];
    
//    [[[UIApplication sharedApplication].windows lastObject] addSubview:groupView];
//    [[groupView superview]bringSubviewToFront:groupView];
//    _count =60;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(overTimerFired:) userInfo:nil repeats:YES];
}

/**
 加入群聊等待View
 qun
 @return 返回视频是否同意View
 */
- (void)addChatGroupWaitViewUserName:(NSString*)userName Uid:(NSString*)uid Face:(NSString*)face RoomName:(NSString*)roomName UserInfoArr:(NSMutableArray *)userArr Other:(NSDictionary*)other{
    
    /* 播放等待接听的声音 */
    [[JSMessageSoundEffect shareInstance] playVideoCallSound];
    
    _count =60;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(overTimerFiredGroup:) userInfo:nil repeats:YES];
	
	_roomName  = roomName;
	_other = other;
	
	_userArry = userArr;
	
	groupWaitView = [[LZChatGroupWaitingView alloc]initWithFrame:[UIScreen mainScreen].bounds];
	
	groupWaitView.delegate = self;
	
    [groupWaitView setUpUserFace:face Name:userName User:userArr Uid:uid];
	
	//添加到Window 上
	[[UIApplication sharedApplication].keyWindow addSubview:groupWaitView];
}

/**
 后面添加某人到多人聊天

 @param chatUsers
 */
- (void)addNewMemberToCall:(NSArray *)chatUsers{
    _userArry = [NSMutableArray arrayWithArray:chatUsers];
	
//	dispatch_sync(dispatch_get_main_queue(), ^{

		[groupView addDataChatUserInfoArr:chatUsers];

//	});
}

//设置用户禁言
- (void)setUserBan:(BOOL)isBan{
	
	groupView.isBan = isBan;
	
}

- (void)overTimerFired:(NSTimer *)_timers
{
    if (_count !=0 ) {
        _count -=1;

    }else{
        NSLog(@"连接超时.......");
        
        [self addFailNotification];
        [_timers invalidate];
        [chatView closeView];
    }
}

- (void)overTimerFiredGroup:(NSTimer *)_timers
{
    if (_count !=0 ) {
        _count -=1;
        
    }else{
        NSLog(@"呼叫超时.......");
        /* 这是接通之后的界面 */
        [groupView closeView];
        [self groupTimeOutNotice];
        [_timers invalidate];
    }
}


#pragma 单聊

- (void)startVideoChat{
    
    [_timer invalidate];
    
    [[JSMessageSoundEffect shareInstance] stopVideoCallSound];
    [self setUserCalling];
    
    [self addAnswerNotification];

}

//结束通话 （通话连接断掉）
- (void)endVideoChat:(NSDictionary*)message{
    
    [_timer invalidate];
    [self setUserCalled];
    [[JSMessageSoundEffect shareInstance] stopVideoCallSound];
    
    [self addAnswerEndNotification:message];
    
}

//网络状态
- (void)netWoringQualityUp:(NSInteger)up Down:(NSInteger)down{
    
    [self addNetWorkingNotificationUp:up Down:down];    
}

- (void)chatLinkFail{
	[self addLinkFailNotification];
}

#pragma mark 群组代理
- (void)chatGroupLinkFail{
	[self addLinkFailNotification];
}
//结束通话 （通话连接断掉）

//开始群组视频通话 (已经连接上了) 不用，这个方法是某个人接听之后，对方收到通知

- (void)startGroupVideoChat{
    /* 计时器关闭 */
    [_timer invalidate];
    /* 停止等待接听的声音 */
    [[JSMessageSoundEffect shareInstance] stopVideoCallSound];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVoice;
    /* 接听了之后real数组就变化了 */
    NSMutableArray *realChats = [self getRealCallArray];
    NSDictionary *info = @{@"userarray":_userArry, @"roomname":_roomName, @"dialogid":_other[@"dialogid"], @"contacttype":_other[@"contacttype"],@"realchatusers":realChats};
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Update_Notice object:nil userInfo:info];
    
    [realChats removeObject:[NSNumber numberWithUnsignedInteger:groupView.selfUid]];
    NSDictionary *infoBanList = @{@"userarray":_userArry, @"roomname":_roomName, @"dialogid":_other[@"dialogid"], @"contacttype":_other[@"contacttype"],@"realchatusers":realChats};
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_BanList_Notice object:nil userInfo:infoBanList];
    
}

//结束通话 （通话连接断掉）自己挂断，自己收到通知
- (void)endGroupVideoChat:(NSDictionary*)message{
    [_timer invalidate];
    
    /* 停止等待接听的声音 */
    [[JSMessageSoundEffect shareInstance] stopVideoCallSound];
    
    NSMutableArray *newUserArr = [NSMutableArray array];
    for (NSDictionary *dict in _userArry) {
        if (![dict[@"uid"] isEqualToString:[AppUtils GetCurrentUserID]]) {
            [newUserArr addObject:dict];
        }
    }
    _userArry = newUserArr;
    
    /* 结束整个通话 */
    if (groupView.videoSessions.count == 1) {
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              // usermodel.username,@"username",
                              _roomName,@"roomname",
                              _other[@"dialogid"],@"dialogid",
                              _other[@"contacttype"],@"contacttype",
                              _userArry,@"userarray",
                              [NSString stringWithFormat:@"%lu",(unsigned long)groupView.videoSessions.count], @"realcount", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Finish_Notice object:nil userInfo:info];
    }
    /* 只是自己挂断 */
    else {
        NSDictionary *info = @{@"userarray":_userArry, @"roomname":_roomName, @"dialogid":_other[@"dialogid"], @"contacttype":_other[@"contacttype"], @"time":message[@"time"], @"isvideo":message[@"isvideo"]};
        [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_End_Notice object:nil userInfo:info];
    }
    /* 关闭选人界面 */
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_CloseVC_Notice object:nil userInfo:nil];
//    _roomName = @"";
}

/* 多人视频切换语音视频 */
- (void)switchGroupVideoChat:(NSDictionary *)message {
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:message];
    [info setObject:_other[@"dialogid"] forKey:@"dialogid"];
    [info setObject:_roomName forKey:@"roomname"];
    [info setObject:@"360P" forKey:@"quality"];
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Switch_Notice object:nil userInfo:info];
}

// 有其他用户离开回调
- (void)leaveGroupChat:(NSDictionary*)message{
    /* 接听了之后real数组就变化了 */
    NSMutableArray *realChats = [self getRealCallArray];
    NSNumber *offUid = [message lzNSNumberForKey:@"uid"];
    if ([realChats containsObject:offUid]) {
        [realChats removeObject:offUid];
    }
//    for (NSDictionary *tmpUserArray in _userArry) {
//        if ([[tmpUserArray lzNSNumberForKey:@"agorauid"] isEqualToNumber:offUid]) {
//            [_userArry removeObject:tmpUserArray];
//            break;
//        }
//    }
    NSDictionary *info = @{@"userarray":_userArry, @"roomname":_roomName, @"dialogid":_other[@"dialogid"], @"contacttype":_other[@"contacttype"],@"realchatusers":realChats};
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Update_Notice object:nil userInfo:info];
    
    [realChats removeObject:[NSNumber numberWithUnsignedInteger:groupView.selfUid]];
    NSDictionary *infoBanList = @{@"userarray":_userArry, @"roomname":_roomName, @"dialogid":_other[@"dialogid"], @"contacttype":_other[@"contacttype"],@"realchatusers":realChats};
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_BanList_Notice object:nil userInfo:infoBanList];
//    NSMutableArray *newUserArr = [NSMutableArray array];
//    NSString *uid = [message lzNSStringForKey:@"uid"];
//    for (NSDictionary *dict in _userArry) {
//        NSNumber *agorauid = dict[@"agorauid"];
//        if (![[agorauid stringValue] isEqualToString:uid]) {
//            [newUserArr addObject:dict];
//        }
//    }
//    _userArry = newUserArr;
//    if (_userArry.count == 1) {
//        [LZToast showWithText:@"其他人已退出，通话结束"];
////        self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusNone;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            /* 关闭等待页面 */
//            [[LZChatVideoModel shareInstance] closeGroupChatView];
//            /* 发送结束通话的消息 */
//            NSDictionary *info = @{@"userarray":_userArry, @"roomname":_roomName, @"dialogid":_other[@"dialogid"], @"contacttype":_other[@"contacttype"], @"time":message[@"time"], @"isvideo":message[@"isvideo"]};
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Finish_Notice object:nil userInfo:info];
//        });
//    }
}

- (void)groupbackChat:(NSDictionary*)message{
	
	[[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Back_Notice object:nil userInfo:_other];

}

- (void)backChatController:(NSDictionary *)message{
	
	[[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Back_Notice object:nil userInfo:_other];

}

- (void)backChatViewController{
	[[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Back_Notice object:nil userInfo:_other];
}

- (void)backChatViewGroupController{
	[[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Back_Notice object:nil userInfo:_other];

}
/* 呼叫超时通知 */
- (void)groupTimeOutNotice {
    /* 有人未接听，将该人的信息从数组中删除，并且关闭该人的等待接听界面，并发送消息(语音聊天未接听) */
    NSMutableArray *newUserArr = [NSMutableArray array];
    for (NSDictionary *dict in _userArry) {
        if (![dict[@"uid"] isEqualToString:[AppUtils GetCurrentUserID]]) {
            [newUserArr addObject:dict];
        }
    }
    _userArry = newUserArr;
    NSDictionary *info = @{@"userarray":_userArry, @"roomname":_roomName, @"dialogid":_other[@"dialogid"], @"contacttype":_other[@"contacttype"]};
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Timeout_Notice object:nil userInfo:info];
//    _roomName = @"";
}
/* 拒接 */
- (void)refuseGroupNotification {
    [_timer invalidate];
    /* 拒接，就将自己从数组中删除，并发送消息(语音聊天未接听) */
    NSMutableArray *newUserArr = [NSMutableArray array];
    for (NSDictionary *dict in _userArry) {
        if (![dict[@"uid"] isEqualToString:[AppUtils GetCurrentUserID]]) {
            [newUserArr addObject:dict];
        }
    }
    _userArry = newUserArr;
    NSDictionary *info = @{@"userarray":_userArry, @"roomname":_roomName, @"dialogid":_other[@"dialogid"], @"contacttype":_other[@"contacttype"]};
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Refuse_Notice object:nil userInfo:info];
//    _roomName = @"";
}

/* 接听，接听方通知 */
- (void)addGroupUserNotification {
    [_timer invalidate];
    /*  */
    NSMutableArray *realChats = [self getRealCallArray];
    NSDictionary *info = @{@"userarray":_userArry, @"roomname":_roomName, @"dialogid":_other[@"dialogid"], @"contacttype":_other[@"contacttype"],@"realchatusers":realChats};
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Answer_Notice object:nil userInfo:info];
}
/* 改变正在通话的群成员数组 */
- (void)setUserArry:(NSMutableArray *)userArry {
    _userArry = userArry;
    [groupView addDataChatUserInfoArr:_userArry];
}

- (void)addOtherMember {
    NSDictionary *postDic = @{@"userarray":_userArry, @"roomname":_roomName, @"dialogid":_other[@"dialogid"], @"contacttype":_other[@"contacttype"]};
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Add_Notice object:nil userInfo:postDic];
}

- (void)addBanMember{
    NSArray *realChatArr = [self getRealCallArray];
    // 获取除了自己真正通话的人
    NSString *realChatStr = [realChatArr componentsJoinedByString:@","];
    NSMutableArray *newUserArr = [NSMutableArray array];
    for (NSDictionary *tmpDic in _userArry) {
        if ([realChatStr containsString:[[tmpDic lzNSNumberForKey:@"agorauid"] stringValue]] &&
            ![[tmpDic lzNSStringForKey:@"uid"] isEqualToString:[AppUtils GetCurrentUserID]]) {
            [newUserArr addObject:tmpDic];
        }
    }
	NSDictionary *postDic = @{@"userarray":newUserArr, @"roomname":_roomName, @"dialogid":_other[@"dialogid"], @"contacttype":_other[@"contacttype"]};
	[[NSNotificationCenter defaultCenter] postNotificationName:Chat_Ban_Notice object:nil userInfo:postDic];
}

/**
 //设置用户正在通话标识符
 */
- (void)setUserCalling{
    
    //设置用户正在通话标识符
	[LZUserDataManager saveIsVodioChating:true];
    
}

/**
 //设置用户已经结束
 */
- (void)setUserCalled{
    [_timer invalidate];
	
    //设置用户正在通话标识符
	[LZUserDataManager saveIsVodioChating:false];
}


/**
 判断用户是否在通话

 @return yes 是 NO 否
 */
- (BOOL)isCalling{
	
	return [LZUserDataManager isVodioChating];

}


#pragma mark 通知

//1.接听（通了）
- (void)addAnswerNotification{
    /* 停止等待接听的声音 */
    [[JSMessageSoundEffect shareInstance] stopVideoCallSound];
    //用户id
    //房间号
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_userName,@"username",_roomName,@"roomname",_other[@"dialogid"],@"dialogid", nil];

    [[NSNotificationCenter defaultCenter]postNotificationName:Chat_Start_Notice object:nil userInfo:info];
}

//2.通话结束 （当time 等于0时 未接通）
- (void)addAnswerEndNotification:(NSDictionary*)message{
    
    //时间
    //用户id
    //房间号
    NSString *time = [NSString stringWithFormat:@"%@",[message lzNSStringForKey:@"time"]];
    NSString *intervaltime = [NSString stringWithFormat:@"%@",[message lzNSStringForKey:@"intervaltime"]];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_userName,@"username",_roomName,@"roomname",time,@"time",intervaltime,@"intervaltime",_other[@"dialogid"],@"dialogid", message[@"isvideo"],@"isvideo", nil];

    [[NSNotificationCenter defaultCenter]postNotificationName:Chat_End_Notice object:nil userInfo:info];
//    _roomName = @"";
}
//3.通话失败(超时)
- (void)addFailNotification{
    //用户id
    //房间号
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_userName,@"username",_roomName,@"roomname",_other[@"dialogid"],@"dialogid", nil];

    [[NSNotificationCenter defaultCenter]postNotificationName:Chat_Fail_Notice object:nil userInfo:info];
//    _roomName = @"";
}
/* 链接失败 */
- (void)addLinkFailNotification{
	
	//用户id
	//房间号
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_userName,@"username",_roomName,@"roomname",_other[@"dialogid"],@"dialogid", nil];
	
	[[NSNotificationCenter defaultCenter]postNotificationName:Chat_Link_Fail_Notice object:nil userInfo:info];
//    _roomName = @"";
}

//4.通话网络状态
- (void)addNetWorkingNotificationUp:(NSInteger)up Down:(NSInteger)down{
    
    //网络状态
    //用户id
    //房间号
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_userName,@"username",_roomName,@"roomname",[NSString stringWithFormat:@"%ld",up],@"up",[NSString stringWithFormat:@"%ld",down],@"down",_other[@"dialogid"],@"dialogid", nil];

    [[NSNotificationCenter defaultCenter]postNotificationName:Chat_NetWorking_Notice object:nil userInfo:info];

}

//用户静音状态
- (void)userMuted:(BOOL)muted forUid:(NSInteger)uid{
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_roomName,@"roomname",[NSString stringWithFormat:@"%d",muted],@"muted",[NSString stringWithFormat:@"%ld",uid],@"uid",_other[@"dialogid"],@"dialogid",_other[@"contacttype"],@"contacttype", nil];
	[[NSNotificationCenter defaultCenter]postNotificationName:Chat_Group_Muted_Notice object:nil userInfo:info];

}


//5.聊天接受通知（此时聊天未接通）
- (void)addAcceptNotification{
    
    //用户id
    //房间号
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_userName,@"username",_roomName,@"roomname",_other[@"dialogid"],@"dialogid", nil];

    [[NSNotificationCenter defaultCenter]postNotificationName:Chat_Accept_Notice object:nil userInfo:info];
    
}
//6.聊天挂断通知 （此时聊天未接通），也就是拒绝喽
- (void)addCloseNotification{
    
    //用户id
    //房间号
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_userName,@"username",_roomName,@"roomname",_other[@"dialogid"],@"dialogid", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:Chat_Close_Notice object:nil userInfo:info];
//    _roomName = @"";
}
/* 单人的这个通知也是用群组的那个通知发送的 */
- (void)switchChatVideo:(NSDictionary *)message {
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:message];
    [info setObject:_other[@"dialogid"] forKey:@"dialogid"];
    [info setObject:_roomName forKey:@"roomname"];
    [info setObject:@"720P" forKey:@"quality"];
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_Switch_Notice object:nil userInfo:info];
}


/**
 关闭单人聊天视图
 */
- (void)closeChatView{
  
    if (waitView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitView removeFromSuperview];
        });
    }
    if (chatView) {
        [chatView closeView];
    }
    /* 停止等待接听的声音 */
    [[JSMessageSoundEffect shareInstance] stopVideoCallSound];
//    _roomName = @"";
}

/**
 关闭群视频视图
 */
- (void)closeGroupChatView {
    [_timer invalidate];
    if (groupWaitView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [groupWaitView removeFromSuperview];
        });
    }
    if (groupView) {
        [groupView closeView];
    }
    /* 停止等待接听的声音 */
    [[JSMessageSoundEffect shareInstance] stopVideoCallSound];
//    _roomName = @"";
}

/**
 放大群组视频聊天框
 */
- (void)showEnlargeWindow {
    [groupView showEnlargeWindow];
}

/**
 放大单人视频聊天框
 */
- (void)showSignalEnlargeWindow {
    [chatView showEnlargeWindow];
}

/* 得到真实正在通话的人数 */
- (NSMutableArray *)getRealCallArray {
    NSMutableArray *realChatUids = [NSMutableArray array];
    for (LZVideoSession *session in groupView.videoSessions) {
        [realChatUids addObject:[NSNumber numberWithUnsignedInteger:session.uid]];
    }
//    realChatUids = [groupView.videoSessions valueForKeyPath:@"uid"];
    return realChatUids;
}

//得到正在通话人员的静音状态
- (NSMutableArray*)getMuitCallArray {
	
	NSMutableArray *realChatUids = [NSMutableArray array];
	for (LZVideoSession *session in groupView.videoSessions) {
		
		if(session.uid !=groupView.selfUid){
		
			NSMutableDictionary *dic = [NSMutableDictionary dictionary];
			[dic setObject:[NSNumber numberWithUnsignedInteger:session.uid] forKey:@"uid"];
			[dic setObject:[NSNumber numberWithBool:session.isMuted] forKey:@"state"];
			[realChatUids addObject:dic];

			
		}
	}
	return realChatUids;
}

/* 挂断视频通话插件 */
- (void)cancelVideoPlugin {
    if (groupView) {
        [groupView cannel];
    } else {
        [chatView cannel];
    }
}

@end
