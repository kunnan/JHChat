//
//  LZChatGroupView.m
//  LeadingCloud
//
//  Created by wang on 17/4/26.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZChatGroupView.h"
#import "LZChatGroupToolView.h"
#import "LZChatGroupSingleView.h"
#import "LZVideoSession.h"
#import "KeyCenter.h"
#import "AppUtils.h"
#import "LZChatVideoModel.h"
#import "ModuleServerUtil.h"
#import "AppDelegate.h"
#import "XHHTTPClient.h"
#import "LZVideoPoepleItem.h"
#define WEAKSELF typeof(self) __weak weakSelf = self;

@interface LZChatGroupView()<LZChatGroupToolDelegate,AgoraRtcEngineDelegate>{
   
    NSMutableArray *userArray;
    
    NSString *channelID;
    
    NSMutableArray *videoArray;
    
    UIView *chatView ; //聊天区、
    
    LZChatGroupToolView *toolView;
    
    UIView *tapView;
    
    NSString *logo;
    
    BOOL isSmaleView;
    
    CGPoint loaction;  //小球缩小的位置
	
	NSInteger _count; //秒数

    NSInteger tempCount; //点击切换视频和语音的时候临时时长
	
	BOOL isOpenSpeaker;
	BOOL isOpenMute ;   //是否打开静音
	
	BOOL isAdmins; //是否是发起者管理员

	BOOL isSmall; //是否是发起者管理员

}

@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;



//是否是视频
@property (nonatomic,assign) BOOL isVideo;

//展示View 未联通显示自己，联通显示对方
@property (nonatomic,strong) UIView *showView;

//小窗视频View
@property (nonatomic,strong) UIView *smallView;
//时间label
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *bigtimeLabel;

@property (nonatomic,strong) UILabel *nameLabel;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation LZChatGroupView

- (void)setIsBan:(BOOL)isBan{
	_isBan = isBan;
	dispatch_async(dispatch_get_main_queue(), ^{
		isOpenMute = isBan;
		[self.agoraKit muteLocalAudioStream:isBan];
		toolView.muteBtn.selected = isBan;
		
		if(!isAdmins){
		toolView.muteBtn.userInteractionEnabled = !isBan;
		}
		LZVideoSession *selfSession = [self videoSessionOfUid:_selfUid];
		selfSession.isMuted = isBan;
		[self updateInterfaceWithSessions:self.videoSessions];
	});
	
	

}

- (NSTimer*)timer{
	
	if (_timer==nil) {
		_count = 0;
        tempCount = 0;
		_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CaptchTimerFired:) userInfo:nil repeats:YES];
		
	}
	return _timer;
}

- (void)CaptchTimerFired:(NSTimer *)_timers{
	_count++;
	NSString *time = [self upChatTimmLength:_count];
	
	_timeLabel.text = time;
	
	_bigtimeLabel.text = [NSString stringWithFormat:@"通话时长：%@",time];
}
//得到时间格式
- (NSString *)upChatTimmLength:(NSInteger)length{
	NSString *time = nil;
	
	if (length<60) {
		time = [NSString stringWithFormat:@"00:%02ld",length];
		
	}else{
		
		if (length<3600) {
			time = [NSString stringWithFormat:@"%02ld:%02ld",length/60,length%60];
			
		}else{
			time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",length/(60*60),length%(60*60),length%60];
			
		}
		
	}
	return time;
}



- (UIView*)smallView{
	
    if (_smallView == nil) {
		
        _smallView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 100)];
        _smallView.backgroundColor = [UIColor whiteColor];
		_smallView.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_smallView.layer.borderWidth = 0.5;
		_smallView.layer.cornerRadius =5;
		_smallView.layer.masksToBounds = YES;
		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((80-36)/2, 20, 36, 36)];
		imageView.image = [UIImage imageNamed:@"list_sign_video_doing_blue"];
		[_smallView addSubview:imageView];
		[_smallView addSubview:self.timeLabel];
    }
    return _smallView;
}

- (UILabel*)timeLabel{
	
	if (_timeLabel == nil) {
		
		
		_timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 80, 20)];
		_timeLabel.textColor = LZColor_Button_TintColor;
		_timeLabel.font = [UIFont systemFontOfSize:13];
		_timeLabel.textAlignment = NSTextAlignmentCenter;
		_timeLabel.text = @"等待接听";
	}
	
	return _timeLabel;
}

- (UILabel*)bigtimeLabel{
	if (_bigtimeLabel == nil) {
		
		
		_bigtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, LZ_SCREEN_HEIGHT-180-20-35-10, LZ_SCREEN_WIDTH, 20)];
		_bigtimeLabel.textAlignment = NSTextAlignmentCenter;
		_bigtimeLabel.text = @"等待接听";

	}
	
	return _bigtimeLabel;
}

- (UILabel*)nameLabel{
	
	if (_nameLabel == nil) {
		
		_nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, LZ_SCREEN_HEIGHT-180-20-10-5, LZ_SCREEN_WIDTH-40, 20)];
		_nameLabel.font = [UIFont systemFontOfSize:13];
		_nameLabel.textAlignment = NSTextAlignmentCenter;
		_nameLabel.textColor = [UIColor colorWithRed:92/255.0 green:102/255.0 blue:112/255.0 alpha:1];

	}
	return _nameLabel;
}


- (UIView*)showView{
    
    if (_showView == nil) {
        
        _showView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _showView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_showView];
		[_showView addSubview:self.nameLabel];
		[_showView addSubview:self.bigtimeLabel];
    }
    return _showView;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        isSmaleView = NO;
        self.backgroundColor = [UIColor whiteColor];
        chatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZ_SCREEN_WIDTH, LZ_SCREEN_WIDTH)];
        [self.showView addSubview:chatView];
		videoArray = [NSMutableArray array];
        self.videoSessions = [NSMutableArray array];
        
        loaction = CGPointMake([UIScreen mainScreen].bounds.size.width-20-100, [UIScreen mainScreen].bounds.size.height-49-20-100);
		isOpenMute = false ;
		
    }
    return self;
}


/**
 更新
 
 @param userArr 用户信息
 */
- (void)addDataChatUserInfoArr:(NSArray*)userArr{
    
    DDLogVerbose(@"sdas----数组%@",userArr);

    //新加的，所有的都在动😯
//    [userArray addObjectsFromArray:userArr];
    userArray = [NSMutableArray arrayWithArray:userArr];
    [self upSelfInfoLast];
    DDLogVerbose(@"sdasdasdasdas----数组%@",userArray);
	dispatch_async(dispatch_get_main_queue(), ^{
		
		[self addChatPeopeleView];
		
		[self updateInterfaceWithSessions:self.videoSessions];
	});
	
	//问题 初始化后都是视频了😯
	//[self addChatHeaderView];



	
}

- (void)removeDataChatUserInfoUid:(NSInteger)suid {
    
    for (int i = 0 ; i<userArray.count ;i++){
        
        NSDictionary *info = [userArray objectAtIndex:i];
        NSNumber *uid = [info objectForKey:@"agorauid"];
        
        if ([uid integerValue]==suid) {
            [userArray removeObject:info];
            break;
        }
    }
    [self addChatPeopeleView];
    
}

//将自己置后
- (void)upSelfInfoLast{
    
    NSDictionary *selfDic ;
    for (int i = 0 ; i<userArray.count ;i++){
        
        NSDictionary *info = [userArray objectAtIndex:i];
        NSNumber *uid = [info objectForKey:@"agorauid"];
        NSString *number = [info objectForKey:@"uid"];
        
        if([number isEqualToString:[AppUtils GetCurrentUserID]]){
            
            selfDic = info;
            _selfUid = [uid integerValue];
        }
    }
    if (selfDic) {
        
        [userArray removeObject:selfDic];
        
        [userArray addObject:selfDic];
    }
}

/**
 更新聊天群
 
 @param channelName 房间号
 @param userArr     用户信息
 */
- (void)upChatChannel:(NSString*)channelName UserInfoArr:(NSMutableArray*)userArr Logo:(NSString*)ologo Other:(NSDictionary*)other{

    channelID = channelName;
    userArray = userArr;
    logo = ologo;
	_nameLabel.text = [other lzNSStringForKey:@"groupname"];
	
	
//    isAdmins =NO;

    NSInteger iscanspeechuid = [[other lzNSStringForKey:@"iscanspeechuid"]integerValue];


    NSInteger isinitiateuid = [[other lzNSStringForKey:@"isinitiateuid"]integerValue];

    if (iscanspeechuid==1 || isinitiateuid==1) {

        isAdmins = YES;
    }else{
        isAdmins =NO;
    }
    [self upSelfInfoLast];
    
    [self addChatPeopeleView];
    [self addChatToolView];
    [self addChatHeaderView];
    [self loadAgoraKit];


}

//MARK: - Agora Media SDK 调用SDK
- (void)loadAgoraKit {

	NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
	postDic[@"uid"] = [NSString stringWithFormat:@"%lu",_selfUid];
	postDic[@"channelname"] = channelID;
	postDic[@"expiremins"] = @"1000";

	
	NSString *server = [ModuleServerUtil GetServerWithModule:Modules_Default];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	WEAKSELF
	NSString *apiServer=[NSString stringWithFormat:@"%@/%@/%@",server,@"api/video/getconnectinfo/",appDelegate.lzservice.tokenId];
	[XHHTTPClient POSTPath:apiServer parameters:postDic jsonSuccessHandler:^(LZURLConnection *connection, id json) {
		
		NSDictionary *dic = [json objectForKey:@"DataContext"];
		
		if ([dic count]>1) {

			[weakSelf joinSucess:dic];

		}else{
			[self joinFail];

		}
		
	}failureHandler:^(LZURLConnection *connection, NSData *responseData, NSURLResponse *response, NSError *error) {
		
		[self joinFail];

	}];
}

- (void)joinSucess:(NSDictionary*)dic{
	
	NSString *channelkey = [dic lzNSStringForKey:@"channelkey"];
	NSString *appid = [dic lzNSStringForKey:@"appid"];
	
	self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:appid delegate:self];
	
	//			[self.agoraKit setEncryptionSecret:[KeyCenter Secret]];
	//			[self.agoraKit setEncryptionMode:@"aes-256-xts"];
	[self.agoraKit setChannelProfile:AgoraRtc_ChannelProfile_Communication];
	
	//			//此处不开，接受不到别人的视频
	[self.agoraKit enableVideo];
	
	
	//暂停发布本地视频流
	[self.agoraKit muteLocalVideoStream:YES];
	
	[self.agoraKit enableAudio];
	[self.agoraKit muteLocalAudioStream:NO];
	
	[self.agoraKit setDefaultAudioRouteToSpeakerphone:NO];
	
	//开始
	//[self.agoraKit startPreview];
	
	[self addLocalSession];
	int code = [self.agoraKit joinChannelByKey:channelkey channelName:channelID info:nil uid: _selfUid joinSuccess:nil];
	[self.agoraKit setEnableSpeakerphone:NO];
	
	if (_isBan) {
		//创建之前，设置时 self.agoraKit 无值
		[self.agoraKit muteLocalAudioStream:_isBan];
		isOpenMute = _isBan;
		toolView.muteBtn.userInteractionEnabled = !_isBan;
	}
	
	isOpenSpeaker = YES;
	
	if (code == 0) {
		[self setIdleTimerActive:NO];
	}
	
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine
	didOccurError:(AgoraRtcErrorCode)errorCode{
	
	NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
	postDic[@"uid"] = [NSString stringWithFormat:@"%lu",_selfUid];
	postDic[@"channelname"] = channelID;
	postDic[@"expiremins"] = @"1000";
	
	NSString *server = [ModuleServerUtil GetServerWithModule:Modules_Default];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	NSString *apiServer=[NSString stringWithFormat:@"%@/%@/%@",server,@"api/video/getconnectinfo/",appDelegate.lzservice.tokenId];
	[XHHTTPClient POSTPath:apiServer parameters:postDic jsonSuccessHandler:^(LZURLConnection *connection, id json) {
		
		NSDictionary *dic = [json objectForKey:@"DataContext"];
		
		if ([dic count]>1) {
			NSString *channelkey = [dic lzNSStringForKey:@"channelkey"];
			[engine renewChannelKey:channelkey];
			
		}
		
	}failureHandler:^(LZURLConnection *connection, NSData *responseData, NSURLResponse *response, NSError *error) {
		
		[self joinFail];
	}];

}

- (void)joinFail{
	
	if (_delegate && [_delegate respondsToSelector:@selector(chatGroupLinkFail)]) {
		
		[_delegate chatGroupLinkFail];
		
	}
	[self closeView];
}




- (void)setIdleTimerActive:(BOOL)active {
    //屏幕常量
    [UIApplication sharedApplication].idleTimerDisabled = !active;
}

#pragma mark 视频音频切换😯
// 多人切换视频语音
- (void)switchVideoAndVoice:(BOOL)isVideo{
	NSInteger intervalTime = _count - tempCount;
	NSLog(@"多人通话切换间隔%ld秒",(long)intervalTime);
	tempCount = _count;
	
	if (_delegate && [_delegate respondsToSelector:@selector(switchGroupVideoChat:)]) {
		NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",intervalTime], @"intervaltime", [NSNumber numberWithBool:!isVideo], @"isvideo", nil];
		[_delegate switchGroupVideoChat:message];
	}
	
	self.isVideo = isVideo;
	if (isVideo) {
		
		//视频分辨率
		[self.agoraKit muteLocalVideoStream:NO];
		[self.agoraKit startPreview];
		[self.agoraKit setVideoProfile:self.videoProfile swapWidthAndHeight:NO];
		[self addLocalSession];
		[self.agoraKit setLocalRenderMode:AgoraRtc_Render_Hidden];
		
	} else { 
		[self.agoraKit muteLocalVideoStream:YES];
		//	[self.agoraKit disableVideo];
		[self.agoraKit enableAudio];
		[self.agoraKit muteLocalAudioStream:NO];
		
	}
	[self.agoraKit muteLocalAudioStream:isOpenMute];

	//    LZVideoSession *session = [self fetchSessionOfUid:_selfUid];
	//    session.isVideoMuted = isVideo;
	// isVideo true 开启 flase 关闭
	[self setVideoMuted:!isVideo forUid:_selfUid];
	
	//是否停止发送本地视频 Yes: 暂停发送本地视频流No: 恢复发送本地视频流
//	[self.agoraKit muteLocalVideoStream:!isVideo];
	
	//禁用/启用本地视频功能。该方法用于只看不发的视频场景。该方法不需要本地有摄像头。 YES: 启用本地视频（默认）NO: 禁用本地视频
	//[self.agoraKit enableLocalVideo:isVideo];
	
	[self updateInterfaceWithSessions:self.videoSessions];

}


#pragma mark 回调

//远端首帧视频接收解码回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed {
    [self.agoraKit enableVideo];
    LZVideoSession *userSession = [self videoSessionOfUid:uid];
    userSession.isVideoMuted = NO;
    userSession.size = size;
    [self.agoraKit setupRemoteVideo:userSession.canvas];
    [self.agoraKit setRemoteRenderMode:uid mode:AgoraRtc_Render_Hidden];

    [self updateInterfaceWithSessions:self.videoSessions];

	
	
}
//本地首帧视频显示回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed {
    
    LZVideoSession *selfSession = [self videoSessionOfUid:_selfUid];
    selfSession.size = size;
    [self updateInterfaceWithSessions:self.videoSessions];

}

//用户离线回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
	
    
    NSInteger intervalTime = _count - tempCount;
	if (_delegate && [_delegate respondsToSelector:@selector(leaveGroupChat:)]) {
		NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",intervalTime],@"time", [NSNumber numberWithBool:_isVideo], @"isvideo",[NSNumber numberWithUnsignedInteger:uid],@"uid", nil];//[NSString stringWithFormat:@"%ld",uid]
		[_delegate leaveGroupChat:message];
		
	}
    // 多人的😯
    LZVideoSession *deleteSession;

    for (LZVideoSession *session in self.videoSessions) {
        
        if (session.uid == uid) {
            deleteSession = session;
            break;
        }
    }
    
    if (deleteSession) {
        
        for (int i =0 ;i<userArray.count;i++) {
            
            NSDictionary *dict = [userArray objectAtIndex:i];
            NSNumber *uid = [dict objectForKey:@"agorauid"];
            if ([uid integerValue] == deleteSession.uid) {
                
                [userArray removeObject:dict];
                break;
            }
        }
        
        [self.videoSessions removeObject:deleteSession];
        
    }
    
    [self removeDataChatUserInfoUid:uid];
    
#warning 处理 是否等待状态 ，视频是否关闭 ，人数不同
    [self addChatPeopeleView];
    [self updateInterfaceWithSessions:self.videoSessions];

}

//用户停止/重新发送视频回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid {
    
    //muted 视频可用 Yes: 该用户已暂停发送其视频流 No: 该用户已恢复发送其视频流
    //视频音频切换的时候使用的😯
    [self setVideoMuted:muted forUid:uid];
    [self updateInterfaceWithSessions:self.videoSessions];

    //更新页面
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didAudioMuted:(BOOL)muted byUid:(NSUInteger)uid{
	
	[self setMuted:muted forUid:uid];
	[self updateInterfaceWithSessions:self.videoSessions];
	if (_delegate && [_delegate respondsToSelector:@selector(userMuted:forUid:)]) {
		[_delegate userMuted:muted forUid:uid];
	}

}

- (void)upMuitViewState:(NSArray*)sessions{
	
	for (LZVideoSession *lzVideoSession in sessions) {
		
		for (LZChatGroupSingleView *singleView in videoArray) {
			
			if ([singleView.uid integerValue]==lzVideoSession.uid) {
				
				
				if (!lzVideoSession.isMuted) {
					//静音
					
				}else{
	
					
				}
				
				
			}
		}
	}
}




- (void)rtcEngine:(AgoraRtcEngineKit *)engine
  didVideoEnabled:(BOOL)enabled byUid:(NSUInteger)uid{
	
	if (enabled) {
		//开启视频
		[self.agoraKit enableVideo];
		
		[toolView upDataSpeaker:isOpenSpeaker];
		[self.agoraKit setEnableSpeakerphone:isOpenSpeaker];
		[self.agoraKit muteLocalAudioStream:isOpenMute];

	}else{
		//关闭视频
		[self.agoraKit muteLocalAudioStream:isOpenMute];

	}
	


	
	[self updateInterfaceWithSessions:self.videoSessions];
}


//本地用户网络质量回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine networkQuality:(NSUInteger)uid txQuality:(AgoraRtcQuality)txQuality rxQuality:(AgoraRtcQuality)rxQuality{
	
	
	if (_delegate && [_delegate respondsToSelector:@selector(netWoringQualityUp:Down:)]){
		
		[_delegate netWoringQualityUp:txQuality Down:rxQuality];
		
	}
	//txQuality 该用户的上行网络质量
	
	// rxQuality 该用户的下行网络质量。
}

#pragma mark 用户加入回调
//用户加入回调 (didJoinedOfUid)
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    
    LZVideoSession *selfSession = [self videoSessionOfUid:uid];
    selfSession.isVideoMuted = YES;
    [self updateInterfaceWithSessions:self.videoSessions];
    
    [toolView upChatState:1 IsVideo:_isVideo]; //用户交互开了？？？
	[toolView upDataSpeaker:isOpenSpeaker];
	[self.agoraKit setEnableSpeakerphone:isOpenSpeaker];
    self.timer;
    
    if (_delegate && [_delegate respondsToSelector:@selector(startGroupVideoChat)]) {
        
        [_delegate startGroupVideoChat];
    }
}


- (void)leaveChannel {
	
	if (isSmall) {
//
//		UIViewController *vc ;
//		[vc dismissViewControllerAnimated:NO completion:nil];
		
	}
	[_timer invalidate];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [AgoraRtcEngineKit destroy];
    });
	
    [self setIdleTimerActive:YES];
}

- (LZVideoSession *)videoSessionOfUid:(NSUInteger)uid {
    LZVideoSession *fetchedSession = [self fetchSessionOfUid:uid];
    if (fetchedSession) {
        return fetchedSession;
    } else {
        LZVideoSession *newSession = [[LZVideoSession alloc] initWithUid:uid];
        newSession.isVideoMuted = YES;
        [self.videoSessions addObject:newSession];
        //更新视图

        return newSession;
    }
}

- (LZVideoSession *)fetchSessionOfUid:(NSUInteger)uid {
    for (LZVideoSession *session in self.videoSessions) {
        if (session.uid == uid) {
            return session;
        }
    }
    return nil;
}
- (void)setVideoMuted:(BOOL)muted forUid:(NSUInteger)uid {
    LZVideoSession *fetchedSession = [self fetchSessionOfUid:uid];
    fetchedSession.isVideoMuted = muted;
}

-(void)setMuted:(BOOL)muted forUid:(NSUInteger)uid{
	LZVideoSession *fetchedSession = [self fetchSessionOfUid:uid];
	fetchedSession.isMuted = muted;

}

#pragma mark 本地的
- (void)addLocalSession {
    LZVideoSession *localSession =  [[LZVideoSession alloc] initWithUid:_selfUid];
    localSession.isVideoMuted = YES;
    BOOL isExist = false;
    for (LZVideoSession *local in self.videoSessions) {
        
        if (local.uid ==_selfUid) {
            isExist = true;
        }
    }
    if (isExist) {
        
    }else{
        [self.videoSessions insertObject:localSession atIndex:0];
        [self.agoraKit setupLocalVideo:localSession.canvas];

        //更新视图
    }
}


#pragma mark 布局处理

/**
 聊天视频区
 */
- (void)addChatPeopeleView{
    
	
	for (UIView *view in videoArray) {
		
		[view removeFromSuperview];
	}
	[videoArray removeAllObjects];
    CGFloat width = 0.0f;
    if (userArray.count <=4 ) {
        
        width = LZ_SCREEN_WIDTH/2.0;
        
        //田字格
    }else {
        //九宫格
        width = LZ_SCREEN_WIDTH/3.0;

    }
    
    for (int i = 0 ; i<userArray.count ;i++){
        
        NSDictionary *info = [userArray objectAtIndex:i];
        NSNumber *uid = [info objectForKey:@"agorauid"];
        NSString *face = [info objectForKey:@"face"];
        NSString *number = [info objectForKey:@"uid"];
		
        
        CGRect frame;
        if (userArray.count <=4 ) {
            //田字格
         frame = CGRectMake(i%2*width, i/2*width, width, width);
            
            if (i==2&&userArray.count==3) {
                
                frame.origin.x = width/2;
            }
        }else{
            //九宫格
            frame = CGRectMake(i%3*width, i/3*width, width, width);

        }
        
        LZChatGroupSingleView *singleView = [[LZChatGroupSingleView alloc]initWithFrame:frame];
        [singleView upDataIcon:face Uid:[uid stringValue] isSingle:i%2];
		
		if([number isEqualToString:[AppUtils GetCurrentUserID]]){
			
			_selfUid = [uid integerValue];
		
			UITapGestureRecognizer *tapSelfRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelfViewClick)];
			[singleView addGestureRecognizer:tapSelfRecognizer];			
		
		}
        [videoArray addObject:singleView];
		
	
        [chatView addSubview:singleView];
    }
  
}

-(void)tapSelfViewClick{
	
	if (self.isVideo) {
		[self.agoraKit switchCamera];
	}
}

- (void)updateInterfaceWithSessions:(NSArray *)sessions{
    
    for (LZVideoSession *lzVideoSession in sessions) {
       
        for (LZChatGroupSingleView *singleView in videoArray) {
            
            if ([singleView.uid integerValue]==lzVideoSession.uid) {
                
                [singleView endWaitingView];
                lzVideoSession.hostingView.frame = CGRectMake(0, 0, singleView.frame.size.width,  singleView.frame.size.width);
                
                if (!lzVideoSession.isVideoMuted) {
                    [singleView addSubview:lzVideoSession.hostingView];

                    //视频
                }else{
                    // 音频
                    [lzVideoSession.hostingView removeFromSuperview];
                }
				
				[singleView banSatae:lzVideoSession.isMuted];
				
            }
        }
    }
}
/**
 聊天工具区
 */
- (void)addChatToolView {

    toolView = [[LZChatGroupToolView alloc]initWithFrame:CGRectMake(0, LZ_SCREEN_HEIGHT-180, LZ_SCREEN_WIDTH, 180) isAdmins:isAdmins];
    toolView.delegate = self;
    
    [self.showView addSubview:toolView];
    
}


// 退出视频通话
- (void)cannel {

    [self leaveChannel];
    [self performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
//    [self removeFromSuperview];
    NSInteger intervalTime = _count - tempCount;
	
	if (_delegate && [_delegate respondsToSelector:@selector(endGroupVideoChat:)]) {
		
		NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",intervalTime],@"time", [NSNumber numberWithBool:_isVideo], @"isvideo", nil];
		[_delegate endGroupVideoChat:message];
	}
}

//开启扬声器
- (void)switchSpeaker:(BOOL)isSpeaker{
	isOpenSpeaker = isSpeaker;
    [self.agoraKit setEnableSpeakerphone:isSpeaker];
	
}

//静音
- (void)switchMute:(BOOL)mute{
	isOpenMute = mute;
	
    [self.agoraKit muteLocalAudioStream:isOpenMute];
	LZVideoSession *selfSession = [self videoSessionOfUid:_selfUid];
	selfSession.isMuted = mute;
	[self updateInterfaceWithSessions:self.videoSessions];

}
//禁言
- (void)switchban:(BOOL)ban{
	if (_delegate && [_delegate respondsToSelector:@selector(addBanMember)]) {
		isSmall = YES;
		[self shrinkBtnClick:nil];
		[_delegate addBanMember];
	}
	
}

//返回聊天
- (void)switchChat:(BOOL)chat{
	
	if (_delegate &&[_delegate respondsToSelector:@selector(groupbackChat:)]) {
		
		[self shrinkBtnClick:nil];
		[_delegate groupbackChat:nil];
	}
}

//添加成员
- (void)switchAdd:(BOOL)add{
	[self shrinkBtnClick:nil];
	
	if (_delegate && [_delegate respondsToSelector:@selector(addOtherMember)]) {
		isSmall = YES;

		[_delegate addOtherMember];
		
	}
}

- (void)closeView{
    [_timer invalidate];
    
    [self leaveChannel];	
	
    [self removeFromSuperview];
}

- (void)addChatHeaderView {
	

	

	
    UIButton *shrinkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[shrinkBtn setImage:[UIImage imageNamed:@"icon_back_default"] forState:UIControlStateNormal];

    shrinkBtn.frame = CGRectMake(20, 20, 36, 36);
    [self addSubview:shrinkBtn];
	
    [shrinkBtn addTarget:self action:@selector(shrinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];

	
}



- (void)banBtnClick:(UIButton*)btn{
	
    [self shrinkBtnClick:btn];
	if (_delegate && [_delegate respondsToSelector:@selector(addBanMember)]) {
		[_delegate addBanMember];
	}
}


-(void)shrinkBtnClick:(UIButton*)btn{
    //小窗点击😯  可能需要动画
	self.backgroundColor = [UIColor clearColor];

    //音频的小窗
    isSmaleView = YES;
    _showView.hidden = YES;
    
    self.frame = CGRectMake(LZ_SCREEN_WIDTH/2-40, 80, 80, 100);
    [self addSubview:self.smallView];
   
    [self addTapView];

    [UIView transitionWithView:self duration:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.frame = CGRectMake(loaction.x, loaction.y, 80, 100);

        
    } completion:^(BOOL finished) {
        
    }];
    
    
}


//添加点击手势
- (void)addTapView{
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showEnlargeWindow)];
    
    tapView = [[UIView alloc]initWithFrame:self.bounds];
    
    [tapView addGestureRecognizer:tap];
    
    [self addSubview:tapView];
}

- (void)showEnlargeWindow{
	isSmall = NO;

	self.backgroundColor = [UIColor whiteColor];
    isSmaleView = NO;
    [tapView removeFromSuperview];
    [self.smallView removeFromSuperview];
    _showView.hidden = NO;
    self.frame = CGRectMake(0, 0, LZ_SCREEN_WIDTH, LZ_SCREEN_HEIGHT);

    /* 关闭选人界面 */
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Group_CloseVC_Notice object:nil userInfo:nil];
}


#pragma mark 拖动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isSmaleView)    // 仅当取到touch的view是小窗口时，我们才响应触控，否则直接return
    {
        return;
    }
    
    
    // 拿到UITouch就能获取当前点
    UITouch *touch = [touches anyObject];
    // 获取当前点
    CGPoint curP = [touch locationInView:self];
    // 获取上一个点
    CGPoint preP = [touch previousLocationInView:self];
    // 获取手指x轴偏移量
    CGFloat offsetX = curP.x - preP.x;
    // 获取手指y轴偏移量
    CGFloat offsetY = curP.y - preP.y;
    
    CGPoint orgin = self.frame.origin;
    
    if (orgin.x+offsetX<20) {
        offsetX = 20-orgin.x;
        
    }
    
    if (orgin.x+offsetX>LZ_SCREEN_WIDTH-20-self.frame.size.width) {
        offsetX = LZ_SCREEN_WIDTH-20-self.frame.size.width-orgin.x;
        
    }
    
    if (orgin.y+offsetY<20) {
        offsetY = 20-orgin.y;
        
    }
    if (orgin.y+offsetY>LZ_SCREEN_HEIGHT-20-self.frame.size.height) {
        offsetY = LZ_SCREEN_HEIGHT-20-self.frame.size.height-orgin.y;
        
    }
    
    loaction = CGPointMake(offsetX+orgin.x, offsetY+orgin.y);
    
    // 移动当前view
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);    
    
}

@end
