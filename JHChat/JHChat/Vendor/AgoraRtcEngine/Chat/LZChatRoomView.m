//
//  LZChatRootView.m
//  OpenVideoCall
//
//  Created by wang on 17/4/5.
//  Copyright © 2017年 Agora. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2017-04-05
 Version: 1.0
 Description: 视频聊天View
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "LZChatVideoModel.h"


#import "LZChatRoomView.h"
#import "KeyCenter.h"
#import "LZVideoSession.h"
#import "LZChatWaitingWaveView.h"
#import "LZChatWaitingHeadView.h"
#import "LZChatViewHandle.h"
#import "UIImageView+Icon.h"
#import "XHHTTPClient.h"
#import "ModuleServerUtil.h"
#import "AppDelegate.h"
#define WEAKSELF typeof(self) __weak weakSelf = self;

@interface LZChatRoomView (){
    
    //是否小窗显示
    BOOL isBackGroup;
    
    //聊天底部工具View
    LZChatToolView *chatToolView ;
    
    //聊天顶部headerView
    LZVideoChatHeadView *chatVideoHeaderView;
    
    //点击手势View 处理小窗后的手势
    UIView *tapView;
    NSInteger _count; //秒数
    NSInteger tempCount; //点击切换视频和语音的时候临时时长
    
    BOOL isSmaleView; //是小窗😯
    
    
    CGPoint loaction;  //小球缩小的位置
	
	NSUInteger curUid;
	
	BOOL isShowSelf; //大图展示何人
	
	
	BOOL isVoice; //自己是音频还是语音
	
	BOOL isOpenSpeaker; //是否打开扬声器
	BOOL isOpenMute ;   //是否打开静音
	
	UIView *videoNameView;
	
	UILabel *videoNameLabel;
	UILabel *videoTimeLabel;
	
	
}

@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;

//展示View 未联通显示自己，联通显示对方 展示View
@property (nonatomic,strong) UIView *showView;

//小窗视频View
@property (nonatomic,strong) UIView *smallVideoView;

//小窗音频View
@property (nonatomic,strong) UIView *smallVoiceView;

//小窗时间Label
@property (nonatomic,strong) UILabel *smallTimeLabel;

//小窗View
@property (nonatomic,strong) UIView *selfView;



//视频View 数组
@property (strong, nonatomic) NSMutableArray<LZVideoSession*> *videoSessions;


@property (nonatomic,strong) LZChatWaitingWaveView *waveView;

@property (nonatomic,strong) LZChatWaitingHeadView *waitingHeaderView;

//白幕
@property (nonatomic,strong) UIView *whiteView;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;


//测试
@property (nonatomic,strong) UIView *voiceView;

@property (nonatomic,strong) UIView *videoView;

@end;


@implementation LZChatRoomView



#pragma mark 定时器
- (NSTimer*)timer{
    
    if (_timer==nil) {
        _count = 0;
        tempCount = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CaptchTimerFired:) userInfo:nil repeats:YES];
        
    }
    return _timer;
    
}

- (void)CaptchTimerFired:(NSTimer *)_timers
{
    _count++;
    NSString *time =  [self upChatTimmLength:_count];
    [self upChatTimeLength:time];
    [_waitingHeaderView upChatTimeLength:time];
   
    
    _smallTimeLabel.text =time;
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


/**
 波浪线
 */
- (LZChatWaitingWaveView*)waveView{
    
    if(_waveView==nil ){
        
        _waveView = [[LZChatWaitingWaveView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-200-20, self.frame.size.width, 20)];
        
    }
    return _waveView;
}

/**
 等待
 */
- (LZChatWaitingHeadView*)waitingHeaderView{
    
    if (_waitingHeaderView == nil) {
        
        _waitingHeaderView = [[LZChatWaitingHeadView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 400)];
		
		[_waitingHeaderView.backChatBtn addTarget:self action:@selector(backChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		
    }
    return _waitingHeaderView;
    
}

- (UIView*)smallVideoView{
    
    if (_smallVideoView == nil) {
        
        _smallVideoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/4, [UIScreen mainScreen].bounds.size.height/4)];
        _smallVideoView.backgroundColor = [UIColor clearColor];
        
    }
    return _smallVideoView;
}

- (UIView*)smallVoiceView{
    
    if (_smallVoiceView == nil) {
        
        _smallVoiceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _smallVoiceView.backgroundColor = [UIColor clearColor];
        
    }
    return _smallVoiceView;
}

- (UILabel*)smallTimeLabel{
    
    if (_smallTimeLabel==nil) {
        
        _smallTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 80, 30)];
        _smallTimeLabel.textColor = [UIColor whiteColor];
        _smallTimeLabel.textAlignment = NSTextAlignmentCenter;
        _smallTimeLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _smallTimeLabel;
    
}

- (UIView*)whiteView{
    
    if (_whiteView == nil) {
        
        _whiteView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
    
}

- (UIView*)videoView {
	
	if (_videoView==nil) {
		
		_videoView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
	}
	return _videoView;
}
- (UIView*)voiceView{
	
	if (_voiceView==nil) {
		
		_voiceView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
		_voiceView.backgroundColor = [UIColor whiteColor];
		
		[_voiceView addSubview:self.waitingHeaderView];
		[_voiceView addSubview:self.waveView];
	}
	return _voiceView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
		
		curUid = 0;
		isShowSelf = true; //默认展示对方
		
        self.videoSessions = [[NSMutableArray alloc] init];
        
        self.showView = [[UIView alloc]initWithFrame:self.bounds];
        
        [self.videoView addSubview:_showView];
		
		[self addSubview:self.voiceView];
		
		[self addSubview:self.videoView];
		
        chatVideoHeaderView = [[LZVideoChatHeadView alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, 64)];
        chatVideoHeaderView.delegate = self;
        [self.videoView addSubview:chatVideoHeaderView];
		
		
		videoNameView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-200-60, self.frame.size.width, 60)];
		videoNameView.backgroundColor = [UIColor clearColor];
		[self.videoView addSubview:videoNameView];
		
		videoNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width-20, 30)];
		videoNameLabel.textColor = [UIColor whiteColor];
		videoNameLabel.font = [UIFont boldSystemFontOfSize:30];
		[videoNameView addSubview:videoNameLabel];
		
		
		videoTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 43, self.frame.size.width-20, 17)];
		videoTimeLabel.font = [UIFont systemFontOfSize:17];
		videoTimeLabel.textColor = [UIColor whiteColor];
		[videoNameView addSubview:videoTimeLabel];
		
		
		chatToolView = [[LZChatToolView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-200, self.frame.size.width, 200)];
        chatToolView.delegate = self;
        [self.videoView  addSubview:chatToolView];
        
        isSmaleView = NO;
       
        loaction = CGPointMake([UIScreen mainScreen].bounds.size.width-20-80, [UIScreen mainScreen].bounds.size.height-49-20-80);
		isOpenMute = false;
		
        
    }
    return self;
}


/**
 更新文字信息
 
 @param userName 聊天用户名
 @param state    状态 0 正在连接 1 链接成功
 */
- (void)upChatUserName:(NSString *)userName State:(NSInteger)state{
	
	videoNameLabel.text = userName;
	
	if (state==0) {
		videoTimeLabel.text = @"等待对方接听...";
		
	}else{
		
		videoTimeLabel.text = @"";
		
	}
}
- (void)upChatTimeLength:(NSString*)length{
	
	videoTimeLabel.text = length;
	
	
}

- (void)upChatChannel:(NSString*)channelName UserName:(NSString*)userName Face:(NSString*)face{
    
    self.userName = userName;
    self.face = face;
    //加载SDK
    [self loadAgoraKit];
    
}

//MARK: - Agora Media SDK 调用SDK
- (void)loadAgoraKit {
	
	NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
	postDic[@"uid"] = @"0";
	postDic[@"channelname"] = _roomName;
	postDic[@"expiremins"] = @"1000";
	
	NSString *server = [ModuleServerUtil GetServerWithModule:Modules_Default];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	NSString *apiServer=[NSString stringWithFormat:@"%@/%@/%@",server,@"api/video/getconnectinfo/",appDelegate.lzservice.tokenId];
	
	
	WEAKSELF
	
	[XHHTTPClient POSTPath:apiServer parameters:postDic jsonSuccessHandler:^(LZURLConnection *connection, id json) {
		
		NSDictionary *dic = [json objectForKey:@"DataContext"];
		
		if ([dic count]>1) {
			
			[weakSelf joinSucess:dic];

		}else{
			
			//失败了呗
			[weakSelf joinFail];

		}
		
	} failureHandler:^(LZURLConnection *connection, NSData *responseData, NSURLResponse *response, NSError *error) {
		
		[weakSelf joinFail];

	}];
	
        
    if (_isVideo) {

        //设置头部按钮
        [self upChatUserName:self.userName State:0];
		
		self.videoView.hidden = NO;
		self.voiceView.hidden = YES;
		
    }else{
		
		self.videoView.hidden = YES;
		self.voiceView.hidden = NO;
		[self.voiceView addSubview:chatToolView];
        [self.waitingHeaderView upDataUserName:self.userName UserFace:self.face Type:2];

    }
	
}

- (void)joinSucess:(NSDictionary*)dic{
	NSString *appid = [dic lzNSStringForKey:@"appid"];
	NSString *channelkey = [dic lzNSStringForKey:@"channelkey"];
	self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:appid delegate:self];
	
	//			[self.agoraKit setEncryptionSecret:[KeyCenter Secret]];
	//			[self.agoraKit setEncryptionMode:@"aes-256-xts"];
	[self.agoraKit setChannelProfile:AgoraRtc_ChannelProfile_Communication];
	[self.agoraKit enableAudio];
	[self.agoraKit setDefaultAudioRouteToSpeakerphone:NO];
	
	//开启视频功能
	if (_isVideo) {
		isOpenSpeaker = YES;
		
		[self.agoraKit setEnableSpeakerphone:isOpenSpeaker];
		isVoice = NO;
		
		[self.agoraKit enableVideo];
		
		[self addLocalSession];
		
		//视频分辨率
		[self.agoraKit setVideoProfile:self.videoProfile swapWidthAndHeight:NO];
		//开始
		[self.agoraKit startPreview];
		
		[chatToolView upDataSpeaker:YES];
		
	}else{
		isOpenSpeaker = NO;
		
		isVoice = YES;
		//开启音频功能
		//[self.agoraKit muteLocalVideoStream:YES];
	}
	
	
	[self.agoraKit muteLocalAudioStream:NO];
	
	
	int code = [self.agoraKit joinChannelByKey:channelkey channelName:self.roomName info:nil uid:0 joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
		
		curUid = uid;
		
	}];
	
	
	
	if (code == 0) {
		[self setIdleTimerActive:NO];
	} else {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self alertString:[NSString stringWithFormat:@"Join channel failed: %d", code]];
		});
	}
	
}


#pragma mark 语音视频切换处理
// 双人切换视频语音
- (void)switchVideoAndVoice:(BOOL)isVideo{
	NSInteger intervalTime = _count - tempCount;
	NSLog(@"单人通话切换间隔%ld秒",(long)intervalTime);
	tempCount = _count;
	
	if (_delegate && [_delegate respondsToSelector:@selector(switchChatVideo:)]) {
		NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",intervalTime], @"intervaltime", [NSNumber numberWithBool:!isVideo], @"isvideo", nil];
		[_delegate switchChatVideo:message];
	}

	_isVideo = isVideo;
	if (isVideo) {
		isVoice = NO;
		[self.agoraKit enableVideo];
		[self addLocalSession];
		[self.agoraKit muteLocalVideoStream:NO];
		[chatToolView upDataSpeaker:isOpenSpeaker];
		[self.agoraKit setEnableSpeakerphone:isOpenSpeaker];
		
	}else{
		
		isVoice = YES;
		[self.agoraKit muteLocalVideoStream:YES];
		
		[self.agoraKit enableAudio];
		[self.agoraKit muteLocalAudioStream:NO];
		
	}
	[self setVideoMuted:!isVideo forUid:0];
	[self.agoraKit muteLocalAudioStream:isOpenMute];

	[self updateInterfaceWithSessions:self.videoSessions targetSize:_showView.frame.size];
}

//用户停止/重新发送视频回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid {
	
	
	//muted 视频可用
	//视频音频切换的时候使用的😯
	[self setVideoMuted:muted forUid:uid];
	
	if (uid !=0 && muted == NO) {
		
		[self alertString:@"对方开启了视频"];
	}else if (uid!=0 && muted){
		[self alertString:@"对方关闭了视频"];
		
	}
	
	// 停止视频发送 当前用户和远端都停止 就变成语音聊天啦
	
	[self updateInterfaceWithSessions:self.videoSessions targetSize:_showView.frame.size animation:YES];
	
	
}
- (void)rtcEngine:(AgoraRtcEngineKit *)engine
  didVideoEnabled:(BOOL)enabled byUid:(NSUInteger)uid{
	
	if (enabled) {
		//开启视频
		[self.agoraKit enableVideo];

		if (isVoice) {
			[self.agoraKit muteLocalVideoStream:YES];
			
			[self.agoraKit enableAudio];
			[self.agoraKit muteLocalAudioStream:NO];
			
		}else{
			[chatToolView upDataSpeaker:isOpenSpeaker];
			[self.agoraKit setEnableSpeakerphone:isOpenSpeaker];

			[self.agoraKit muteLocalVideoStream:NO];

			
		}
		[self.agoraKit muteLocalAudioStream:isOpenMute];

	}else{
		//关闭视频
	}
	
	//muted 视频可用
	//视频音频切换的时候使用的😯
	//[self setVideoMuted:!enabled forUid:uid];
	
	if (uid !=0 && !enabled == NO) {
		
		[self alertString:@"对方开启了视频"];
	}else if (uid!=0 && !enabled){
		[self alertString:@"对方关闭了视频"];
		
	}
	
	[self updateInterfaceWithSessions:self.videoSessions targetSize:_showView.frame.size animation:YES];
}



- (void)rtcEngine:(AgoraRtcEngineKit *)engine
	didOccurError:(AgoraRtcErrorCode)errorCode{
	
	NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
	postDic[@"uid"] = [NSString stringWithFormat:@"%lu",curUid];
	postDic[@"channelname"] = _roomName;
	postDic[@"expiremins"] = @"1000";
	
	NSString *server = [ModuleServerUtil GetServerWithModule:Modules_Default];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	NSString *apiServer=[NSString stringWithFormat:@"%@/%@/%@",server,@"api/video/getconnectinfo/",appDelegate.lzservice.tokenId];
	[XHHTTPClient POSTPath:apiServer parameters:postDic jsonSuccessHandler:^(LZURLConnection *connection, id json) {
		
		NSDictionary *dic = [json lzNSDictonaryForKey:@"DataContext"];
        NSDictionary *errorCode = [json lzNSDictonaryForKey:@"ErrorCode"];
        if([[errorCode lzNSNumberForKey:@"Code"] integerValue]==0){
            if ([dic count]>1) {
                NSString *channelkey = [dic lzNSStringForKey:@"channelkey"];
                [engine renewChannelKey:channelkey];
                
            }
        } else {
            [self joinFail];
        }
	}failureHandler:^(LZURLConnection *connection, NSData *responseData, NSURLResponse *response, NSError *error) {
		
		[self joinFail];
	}];
	


}

- (void)joinFail{
	
	if (_delegate && [_delegate respondsToSelector:@selector(chatLinkFail)]) {
		
		[_delegate chatLinkFail];
		
	}
	[self closeView];
}

- (void)setIdleTimerActive:(BOOL)active {
    //屏幕常量
    [UIApplication sharedApplication].idleTimerDisabled = !active;
}
- (void)alertString:(NSString *)string {
    if (!string.length) {
        return;
    }
}



#pragma mark 本地的
- (void)addLocalSession {
    LZVideoSession *localSession = [LZVideoSession localSession];
   
    BOOL isExist = false;
    for (LZVideoSession *local in self.videoSessions) {
        
        if (local.uid ==0) {
            isExist = true;
        }
    }
    if (isExist) {
        
    }else{
        [self.videoSessions insertObject:localSession atIndex:0];
        [self.agoraKit setupLocalVideo:localSession.canvas];
        [self updateInterfaceWithSessions:self.videoSessions targetSize:_showView.frame.size animation:YES];

    }
}


- (void)updateInterfaceWithSessions:(NSArray *)sessions targetSize:(CGSize)targetSize animation:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self updateInterfaceWithSessions:sessions targetSize:targetSize];
        }];
    } else {
        [self updateInterfaceWithSessions:sessions targetSize:targetSize];
    }
}



- (void)switchViewTapClick:(UITapGestureRecognizer*)tap{
	
	if (tap.view !=self.selfView) {
		[self addDidAppeatAnimation];
		return;
	}
	isShowSelf = !isShowSelf;
	[self updateInterfaceWithSessions:self.videoSessions targetSize:_showView.frame.size animation:NO];

}

#pragma mark 回调

//远端首帧视频接收解码回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed {
	

    _isVideo = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(startVideoChat)]) {
        
        [_delegate startVideoChat];
    }
    [self upChatUserName:self.userName State:1];
    
    LZVideoSession *userSession = [self videoSessionOfUid:uid];
    userSession.size = size;
    [self.agoraKit setupRemoteVideo:userSession.canvas];
}
//本地首帧视频显示回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed {
    if (self.videoSessions.count) {
        LZVideoSession *selfSession = self.videoSessions.firstObject;
        selfSession.size = size;
        [self updateInterfaceWithSessions:self.videoSessions targetSize:_showView.frame.size animation:NO];
    }
}

//用户离线回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
    LZVideoSession *deleteSession;
    
    if (!_isVideo) {
        
        [self closeView];

    }else{

        for (LZVideoSession *session in self.videoSessions) {
            if (session.uid == uid) {
                deleteSession = session;
            }
        }
        if (deleteSession) {
            
            if (isBackGroup) {
                [self quit:deleteSession];
                return;
            }
            [deleteSession.hostingView removeFromSuperview];
            [self.videoSessions removeObject:deleteSession];
            [self updateInterfaceWithSessions:self.videoSessions targetSize:_showView.frame.size animation:YES];
            
            [self closeView];
        }

    }
}

#pragma mark 用户加入回调
//用户加入回调 (didJoinedOfUid)
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    
    if (_delegate && [_delegate respondsToSelector:@selector(startVideoChat)]) {
        
        [_delegate startVideoChat];
    }
    //如果是音频，波浪线置一
    if (!_isVideo) {
        
        self.waveView.lineHeight=0.0;
        
    }
    [chatToolView upChatState:1 IsVideo:_isVideo];
    
    self.timer ;
	
}



//本地用户网络质量回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine networkQuality:(NSUInteger)uid txQuality:(AgoraRtcQuality)txQuality rxQuality:(AgoraRtcQuality)rxQuality{
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(netWoringQualityUp:Down:)]){
        
        [_delegate netWoringQualityUp:txQuality Down:rxQuality];
        
    }
    //txQuality 该用户的上行网络质量
    
    // rxQuality 该用户的下行网络质量。
}


- (LZVideoSession *)videoSessionOfUid:(NSUInteger)uid {
    LZVideoSession *fetchedSession = [self fetchSessionOfUid:uid];
    if (fetchedSession) {
        return fetchedSession;
    } else {
        LZVideoSession *newSession = [[LZVideoSession alloc] initWithUid:uid];
        [self.videoSessions addObject:newSession];
		
        [self updateInterfaceWithSessions:self.videoSessions targetSize:_showView.frame.size animation:YES];
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

- (void)leaveChannel {
	
	if(self.agoraKit){
		
//		[self.agoraKit setupLocalVideo:nil];
//		[self.agoraKit leaveChannel:nil];
//		[self.agoraKit stopPreview];
		
		for (LZVideoSession *session in self.videoSessions) {
			[session.hostingView removeFromSuperview];
		}
		[self.videoSessions removeAllObjects];
		
		[self setIdleTimerActive:YES];
		[AgoraRtcEngineKit destroy];
	}
	
}



#pragma mark 后台退出处理
- (void)quit:(LZVideoSession*)deleteSession{
    
    [self leaveChannel];
    [self removeFromSuperview];

    
}

#pragma mark LZChatToolDelegate 代理

//切换摄像头
- (void)changeCamera{
    [self.agoraKit switchCamera];
}

- (void)backChat{
	
	if (_delegate && [_delegate respondsToSelector:@selector(backChatController:)]) {
		
		[self switchSmallWindow];
		[_delegate backChatController:nil];
	}
}

- (void)backChatBtnClick:(UIButton*)btn{
	if (_delegate && [_delegate respondsToSelector:@selector(backChatController:)]) {
		[self switchSmallWindow];
		[_delegate backChatController:nil];
	}
}

#pragma mark 关闭View
- (void)closeView{
	[_timer invalidate];

    [self leaveChannel];
    
   [self removeFromSuperview];
}
//退出视频通话
- (void)cannel{
    
    [_timer invalidate];

    [self leaveChannel];
    
    [self removeFromSuperview];
    NSInteger intervalTime = _count - tempCount;
    
    if (_delegate && [_delegate respondsToSelector:@selector(endVideoChat:)]) {
        
        NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",intervalTime],@"intervaltime", [NSNumber numberWithBool:_isVideo], @"isvideo",[NSString stringWithFormat:@"%ld", _count], @"time",nil];
        [_delegate endVideoChat:message];
    }
    
    
}



//静音
- (void)switchMute:(BOOL)mute{
	
	isOpenMute =mute;
	
  [self.agoraKit muteLocalAudioStream:isOpenMute];
    
}

//开启扬声器
- (void)switchSpeaker:(BOOL)isSpeaker{
    
	isOpenSpeaker = isSpeaker;
   [self.agoraKit setEnableSpeakerphone:isOpenSpeaker];
	
	
    //  [self addDisAppearAnimation];
}

//小窗回到
- (void)switchSmallWindow{
    
    isSmaleView = YES;
    if (_isVideo) {
		
		[self addVideoSamallWindowAnimation];
		
    }else{
    
        [self addVoiceSmallWindowAnimation];
        
    }
        
        isBackGroup = YES;
}



#pragma mark 隐藏处理


//添加点击手势
- (void)addTapView{
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showEnlargeWindow)];
    
    tapView = [[UIView alloc]initWithFrame:self.bounds];
    
    [tapView addGestureRecognizer:tap];
    
    [self addSubview:tapView];
}


- (void)showEnlargeWindow{
    
    isSmaleView = NO;

    [tapView removeFromSuperview];
	
    isBackGroup = NO;

    if (_isVideo) {
		[self.smallVideoView removeFromSuperview];
		self.bounds = [UIScreen mainScreen].bounds;
		self.frame = self.bounds;
		self.layer.mask = nil;

        [self updateInterfaceWithSessions:self.videoSessions targetSize:_showView.frame.size animation:NO];
		
    }else{
		
		
		[UIView animateWithDuration:1 animations:^{
			
			self.center = self.waitingHeaderView.iconImageView.center;
			self.transform = CGAffineTransformIdentity;
			
		}completion:^(BOOL finished) {
			[self.smallVoiceView removeFromSuperview];
			self.bounds = [UIScreen mainScreen].bounds;
			
			self.frame = self.bounds;
			
			UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:self.waitingHeaderView.iconImageView.center radius:self.waitingHeaderView.iconImageView.frame.size.height startAngle:0 endAngle:2*M_PI clockwise:YES];

			// 2.获取动画缩放结束时的圆形
			CGSize endSize = CGSizeMake(self.frame.size.width * 0.5, self.frame.size.height - self.waitingHeaderView.iconImageView.center.y);
			
			CGFloat radius = sqrt(endSize.width*endSize.width+endSize.height*endSize.height);
			
			CGRect endRect = CGRectInset(self.waitingHeaderView.iconImageView.frame, -radius, -radius);
			UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
			CAShapeLayer *shapeLayer = self.shapeLayer;

			// 3.创建shapeLayer作为视图的遮罩
			shapeLayer.path = endPath.CGPath;

			CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
			pathAnimation.fromValue = (id)startPath.CGPath;
			pathAnimation.toValue = (id)endPath.CGPath;
			pathAnimation.duration = 0.5;
			pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			pathAnimation.delegate = self;
			pathAnimation.removedOnCompletion = NO;
			pathAnimation.fillMode = kCAFillModeForwards;
			
			[shapeLayer addAnimation:pathAnimation forKey:@"showAnimation"];
		}];
    }
	
	
	

}

#pragma mark 动画区

- (void)addDisAppearAnimation{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        chatVideoHeaderView.frame = CGRectMake(0, -84, self.frame.size.width, 64);
		videoNameView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 60);
        chatToolView.frame = CGRectMake(0, self.frame.size.height+60, self.frame.size.width, 180);
        
        self.selfView.frame = CGRectMake(self.frame.size.width/4*3-10, self.frame.size.height- self.frame.size.height/4-20, self.frame.size.width/4,  self.frame.size.height/4);


    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addDidAppeatAnimation)];
    
    [_showView addGestureRecognizer:tap];
}


- (void)addDidAppeatAnimation{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        chatVideoHeaderView.frame = CGRectMake(0, 20, self.frame.size.width, 64);
        chatToolView.frame = CGRectMake(0, self.frame.size.height-180, self.frame.size.width, 180);
		videoNameView.frame = CGRectMake(0, self.frame.size.height-200-60, self.frame.size.width, 60);

        self.selfView.frame = CGRectMake(self.frame.size.width/4*3-10, self.frame.size.height- self.frame.size.height/4-180, self.frame.size.width/4,  self.frame.size.height/4);

    }];
}


#pragma mark 语音小窗口动画

- (void)addVideoSamallWindowAnimation{
	
	//视频的小窗
	LZVideoSession *herSession = [_videoSessions lastObject];
	herSession.hostingView.frame = CGRectMake(0, 0, _showView.frame.size.width/4, _showView.frame.size.height/4);
	
	if (loaction.x+LZ_SCREEN_WIDTH/4>LZ_SCREEN_WIDTH-20) {
		loaction.x =LZ_SCREEN_WIDTH-20-LZ_SCREEN_WIDTH/4;
	}
	if (loaction.y+LZ_SCREEN_HEIGHT/4>LZ_SCREEN_HEIGHT-20) {
		loaction.y =LZ_SCREEN_HEIGHT-20-LZ_SCREEN_HEIGHT/4;
	}
	self.bounds = CGRectMake(0,0, LZ_SCREEN_WIDTH/4, LZ_SCREEN_HEIGHT/4);
	self.frame = CGRectMake(loaction.x,loaction.y, LZ_SCREEN_WIDTH/4, LZ_SCREEN_HEIGHT/4);
	
	
	[self.smallVideoView addSubview:herSession.hostingView];
	[self addSubview:self.smallVideoView];
	
	UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.bounds];
	CAShapeLayer* shape = [CAShapeLayer layer];
	shape.path = path.CGPath;
	self.layer.mask = shape;
	
	self.shapeLayer = shape;
	
	
	[self addTapView];
}

#pragma mark 语音缩小动画
- (void)addVoiceSmallWindowAnimation{
	
	UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:self.waitingHeaderView.iconImageView.frame];
	
	CGSize startSize = CGSizeMake(self.frame.size.width*0.5, self.frame.size.height- self.waitingHeaderView.iconImageView.center.y);
	
	CGFloat radius = sqrt(startSize.width * startSize.width + startSize.height * startSize.height);
	CGRect startRect = CGRectInset(self.waitingHeaderView.iconImageView.frame, -radius, -radius);
	UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:startRect];
	
	
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.path = endPath.CGPath;
	
	self.layer.mask = shapeLayer;
	self.shapeLayer = shapeLayer;
	
	// 添加动画
	CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
	pathAnimation.fromValue = (id)startPath.CGPath;
	pathAnimation.toValue = (id)endPath.CGPath;
	pathAnimation.duration = 0.5;
	pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	pathAnimation.delegate = self;
	pathAnimation.removedOnCompletion = NO;
	pathAnimation.fillMode = kCAFillModeForwards;
	
	[shapeLayer addAnimation:pathAnimation forKey:@"packupAnimation"];

}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	if ([anim isEqual:[self.shapeLayer animationForKey:@"packupAnimation"]]) {
		CGRect rect = self.frame;
		rect.origin = self.waitingHeaderView.iconImageView.frame.origin;
		self.bounds = rect;
		rect.size = self.waitingHeaderView.iconImageView.frame.size;
		self.frame = rect;
		
		[UIView animateWithDuration:1.0 animations:^{
			self.center = CGPointMake(LZ_SCREEN_WIDTH - 60, LZ_SCREEN_HEIGHT - 80);
			self.transform = CGAffineTransformMakeScale(0.5, 0.5);
			
		} completion:^(BOOL finished) {
			
			[self addTapView];
		}];
	} else if ([anim isEqual:[self.shapeLayer animationForKey:@"showAnimation"]]) {
		self.layer.mask = nil;
		self.shapeLayer = nil;
		
	}
	
}

#pragma mark 小窗时视频转音频
- (void)smallWindowVideoChangeVoice{
    
    [self.smallVideoView removeFromSuperview];
    
    for (UIView *view  in self.smallVoiceView.subviews) {
        
        [view removeFromSuperview];
    }
    //音频的小窗
	self.bounds = CGRectMake(0,0, 80, 80);
    self.frame = CGRectMake(loaction.x,loaction.y, 80, 80);

    CGRect frame = self.frame;
	
	self.videoView.hidden = YES;
	self.voiceView.hidden = NO;
	[self.voiceView addSubview:chatToolView];
	
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
	[iconImageView loadFaceIcon:_face isChangeToCircle:YES];
    [self.smallVoiceView addSubview:iconImageView];
    //[self.smallVoiceView addSubview:self.smallTimeLabel];
    [self addSubview:self.smallVoiceView];
	
	//原点，半径，开始位置，结束位置
	UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(40, 40) radius:40 startAngle:0 endAngle:2*M_PI clockwise:YES];
	CAShapeLayer* shape = [CAShapeLayer layer];
	shape.path = path.CGPath;
	self.layer.mask = shape;
	self.shapeLayer = shape;
    [self addTapView];

}

#pragma mark 小窗时视频转视频
- (void)smallWindowVoiceChangeVideo{
	
	self.transform = CGAffineTransformIdentity;

	self.voiceView.hidden = YES;
	self.videoView.hidden = NO;
	[self.videoView addSubview:chatToolView];
	
	// 1 frame   lzscreenwidth /4
	[self.smallVoiceView removeFromSuperview];

	//视频的小窗
	UIView *bigView = [[LZChatViewHandle shareInstance]getShowViewFromArray:_videoSessions Frame:CGRectMake(0, 0,  LZ_SCREEN_WIDTH/4,  LZ_SCREEN_HEIGHT/4)];
	if (loaction.x+LZ_SCREEN_WIDTH/4>LZ_SCREEN_WIDTH-20) {
		loaction.x =LZ_SCREEN_WIDTH-20-LZ_SCREEN_WIDTH/4;
	}
	if (loaction.y+LZ_SCREEN_HEIGHT/4>LZ_SCREEN_HEIGHT-20) {
		loaction.y =LZ_SCREEN_HEIGHT-20-LZ_SCREEN_HEIGHT/4;
	}
	self.bounds = CGRectMake(0,0, LZ_SCREEN_WIDTH/4, LZ_SCREEN_HEIGHT/4);

	//frame:{{180, 408}, {160, 160}} bound{{80, 45}, {160, 160}}
//	CGRect rect = self.frame;   //得到View 尺寸
//	rect.origin = self.waitingHeaderView.iconImageView.frame.origin; // 改变View 起始位置
//	self.bounds = rect;			//改变View 的bounds 但尺寸未变
//	rect.size = self.waitingHeaderView.iconImageView.frame.size;  // 得到尺寸显示
//	self.frame = rect;			//改变View frame  frame一直变，但bound.size 从未改变
	
	[self.smallVideoView addSubview:bigView];
	[self addSubview:self.smallVideoView];
	
	self.frame = CGRectMake(loaction.x,loaction.y, LZ_SCREEN_WIDTH/4, LZ_SCREEN_HEIGHT/4);

	
	UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, LZ_SCREEN_WIDTH/4, LZ_SCREEN_HEIGHT/4)];
	CAShapeLayer* shape = [CAShapeLayer layer];
	shape.path = path.CGPath;
	self.layer.mask = shape;
	self.shapeLayer = shape;
	//设置点击模板
	[self addTapView];

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

#pragma mark 视频语音显示处理
- (void)updateInterfaceWithSessions:(NSArray *)sessions targetSize:(CGSize)targetSize {
	if (!sessions.count) {
		return;
	}
		
	//视频View 布局
	_isVideo = true;
	
	if (![[LZChatViewHandle shareInstance]isShowVideoViewFromeArray:sessions]) {
		//是否是语音
		_isVideo = NO;
		//[self.agoraKit disableVideo];
		[self.agoraKit muteLocalVideoStream:YES];
		
		[chatToolView upDataSpeaker:isOpenSpeaker];
		[self.agoraKit setEnableSpeakerphone:isOpenSpeaker];
		[self.agoraKit enableAudio];
		[self.agoraKit muteLocalAudioStream:isOpenMute];
		
	}
	
	if (isBackGroup) { //后台时
		
		if(_isVideo){
			
			[self smallWindowVoiceChangeVideo];
		}else{
				//视频转语音
			[self smallWindowVideoChangeVoice];
		}
	}else{//前台
		
		
		if(_isVideo){
			//视频
			self.voiceView.hidden = YES;
			self.videoView.hidden =NO;
			[self.videoView addSubview:chatToolView];
			
			//聊天视频
			UIView *bigView =[[LZChatViewHandle shareInstance]getShowViewFromArray:sessions Frame:_showView.frame];
			
			//小视频
			self.selfView = [[LZChatViewHandle shareInstance]getSamleViewFromArray:sessions Frame: CGRectMake(_showView.frame.size.width/4*3-10, _showView.frame.size.height- _showView.frame.size.height/4-180, _showView.frame.size.width/4,  _showView.frame.size.height/4)];
			
			if (self.selfView && bigView) {
    
				if (isShowSelf) {
					//大图自己，小图对方
					UIView *otherView ;
					
					otherView = self.selfView;
					self.selfView = bigView;
					bigView =otherView;
					self.selfView.frame = CGRectMake(_showView.frame.size.width/4*3-10, _showView.frame.size.height- _showView.frame.size.height/4-180, _showView.frame.size.width/4,  _showView.frame.size.height/4);
					bigView.frame =_showView.frame;
					
				}else{
					//小图自己，大图对方
				}
			}
			[_showView addSubview:bigView];

			[_showView addSubview:self.selfView];

			UITapGestureRecognizer *switchViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchViewTapClick:)];
			//
			[self.selfView addGestureRecognizer:switchViewTap];
			
			[self addDisAppearAnimation];
		}else{
			//语音
			self.voiceView.hidden = NO;
			self.videoView.hidden =YES;
			chatToolView.frame = CGRectMake(0, LZ_SCREEN_HEIGHT-180, LZ_SCREEN_WIDTH, 180);
			[self.voiceView addSubview:chatToolView];
			self.waveView.lineHeight = 0;
			[self.waitingHeaderView upDataUserName:_userName UserFace:_face Type:2];

		}
		
		
	}
	
	
	
}


#pragma mark 视频语音收起处理 


@end
