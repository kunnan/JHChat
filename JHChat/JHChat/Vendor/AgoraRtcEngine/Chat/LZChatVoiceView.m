//
//  LZChatVoiceView.m
//  LeadingCloud
//
//  Created by wang on 2018/3/2.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "LZChatVoiceView.h"
#import "AppUtils.h"
#import "ModuleServerUtil.h"
#import "AppDelegate.h"
#import "XHHTTPClient.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "LZChatVoiceItem.h"
#import "LZChatGroupSingleView.h"

#define WEAKSELF typeof(self) __weak weakSelf = self;

static NSString *kCollectionViewcellIdentifier = @"GroupMemberCollectionViewCellID";

@interface LZChatVoiceView()<AgoraRtcEngineDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
	NSMutableArray *userArray;
	
	NSString *channelID;
	
	NSInteger _selfUid;
	
	UICollectionView *mainCollectionView;
	
	UIView *toolView;
	
	NSInteger _count; //秒数

	
}

@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;

@property (strong, nonatomic) UIButton *speakBtn;

@property (strong, nonatomic) UIButton *muteBtn;

@property (strong, nonatomic) UIButton *closeBtn;

@property (strong, nonatomic) UIButton *addBtn;

@property (strong, nonatomic) UIButton *smallBtn;

@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic,strong) UILabel *bigtimeLabel;

@property (nonatomic,strong) UILabel *nameLabel;

@end

@implementation LZChatVoiceView

- (UILabel*)bigtimeLabel{
	if (_bigtimeLabel == nil) {
		
		
		_bigtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-220-35, LZ_SCREEN_WIDTH, 20)];
		_bigtimeLabel.textAlignment = NSTextAlignmentCenter;
		_bigtimeLabel.text = @"等待接听";
		
	}
	
	return _bigtimeLabel;
}

- (UILabel*)nameLabel{
	
	if (_nameLabel == nil) {
		
		_nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.frame.size.height-220, LZ_SCREEN_WIDTH-40, 20)];
		_nameLabel.font = [UIFont systemFontOfSize:13];
		_nameLabel.textAlignment = NSTextAlignmentCenter;
		_nameLabel.textColor = [UIColor colorWithRed:92/255.0 green:102/255.0 blue:112/255.0 alpha:1];
		_nameLabel.text = @"哈哈";
	}
	return _nameLabel;
}

- (NSTimer*)timer{
	
	if (_timer==nil) {
		_count = 0;
		_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CaptchTimerFired:) userInfo:nil repeats:YES];
		
	}
	return _timer;
}

- (void)CaptchTimerFired:(NSTimer *)_timers{
	_count++;

}

-(void)setSpeakBtn:(UIButton *)speakBtn{
	
	_speakBtn = speakBtn;
	[toolView addSubview:speakBtn];
	
	[speakBtn setTitle:@"扬声器" forState:UIControlStateNormal];
	speakBtn.frame = CGRectMake(self.frame.size.width/4*2.5+(self.frame.size.width/4-60)/2, 5, 60, 60);
	
	[speakBtn addTarget:self action:@selector(sepakerClick:) forControlEvents:UIControlEventTouchUpInside];
	
	[speakBtn setImage: [UIImage imageNamed:@"icon_sound_default"] forState:UIControlStateNormal];
	[speakBtn setImage: [UIImage imageNamed:@"icon_sound_on"] forState:UIControlStateSelected];
	[speakBtn setImage: [UIImage imageNamed:@"icon_sound_gray"] forState:UIControlStateDisabled];
	
	[speakBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 16, 0)];
	[speakBtn setTitleEdgeInsets:UIEdgeInsetsMake(44, -44, 0, 0)];
	speakBtn.titleLabel.font = [UIFont systemFontOfSize:13];
	
	[speakBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:102/255.0 blue:112/255.0 alpha:1] forState:UIControlStateNormal];
	[speakBtn setTitleColor:[UIColor colorWithRed:23/255.0 green:179/255.0 blue:254/255.0 alpha:1] forState:UIControlStateSelected];
	[speakBtn setTitleColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:153/255.0 alpha:1] forState:UIControlStateDisabled];
	
	speakBtn.enabled = NO;
	
}

- (void)sepakerClick:(UIButton*)btn{
	
	[self switchSpeaker:btn.selected];
}

- (void)setMuteBtn:(UIButton *)muteBtn{
	
	_muteBtn = muteBtn;
	
	muteBtn.frame = CGRectMake(self.frame.size.width/4*0.5+(self.frame.size.width/4-60)/2, 5, 60, 60);
	[muteBtn setTitle:@"静音" forState:UIControlStateNormal];
	[muteBtn setImage: [UIImage imageNamed:@"icon_record_default"] forState:UIControlStateNormal];
	[muteBtn setImage: [UIImage imageNamed:@"icon_record_on"] forState:UIControlStateSelected];
	[muteBtn setImage: [UIImage imageNamed:@"icon_record_gray"] forState:UIControlStateDisabled];
	
	[muteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 16, 0)];
	[muteBtn setTitleEdgeInsets:UIEdgeInsetsMake(44, -44, 0, 0)];
	
	muteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
	[muteBtn addTarget:self action:@selector(muteClick:) forControlEvents:UIControlEventTouchUpInside];
	
	[muteBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:102/255.0 blue:112/255.0 alpha:1] forState:UIControlStateNormal];
	[muteBtn setTitleColor:[UIColor colorWithRed:23/255.0 green:179/255.0 blue:254/255.0 alpha:1] forState:UIControlStateSelected];
	[muteBtn setTitleColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:153/255.0 alpha:1] forState:UIControlStateDisabled];
	
	muteBtn.enabled = NO;
	
	[self addSubview:muteBtn];
	[toolView addSubview:muteBtn];
}

- (void)muteClick:(UIButton*)btn{
	
	[self switchMute:btn.selected];
}

- (void)setCloseBtn:(UIButton *)closeBtn{
	
	_closeBtn = closeBtn;
	closeBtn.frame = CGRectMake(self.frame.size.width/2-30, 95, 60, 60);
	[closeBtn setImage:[UIImage imageNamed:@"AV_red_normal"] forState:UIControlStateNormal];
	[closeBtn setImage:[UIImage imageNamed:@"AV_red_pressed"] forState:UIControlStateHighlighted];
	
	[closeBtn addTarget:self action:@selector(cannelClick:) forControlEvents:UIControlEventTouchUpInside];
	[toolView addSubview:closeBtn];
	
}

- (void)cannelClick:(UIButton*)btn{
	
	[self leaveChannel];
	[self removeFromSuperview];
	
	if (_delegate && [_delegate respondsToSelector:@selector(endChatVoiceChat:)]) {
		
		NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",_count],@"time", [NSNumber numberWithBool:NO], @"isvideo", nil];
		[_delegate endChatVoiceChat:message];
	}
	
}

- (void)setAddBtn:(UIButton *)addBtn{
	
	_addBtn = addBtn;
	
	[addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];

	[toolView addSubview:addBtn];
	
}
#pragma 添加成员
- (void)addBtnClick:(UIButton*)btn{
	
	[self hideBtnClick:nil];

	if (_delegate && [_delegate respondsToSelector:@selector(addOtherMember)]) {
		
		[_delegate addOtherMember];
		
	}
}

- (void)setSmallBtn:(UIButton *)smallBtn{
	
	_smallBtn = smallBtn;
	[smallBtn addTarget:self action:@selector(hideBtnClick:) forControlEvents:UIControlEventTouchUpInside];

	[toolView addSubview:smallBtn];
	
}
#pragma 小窗
- (void)hideBtnClick:(UIButton*)btn{
	
}

- (void)setSmallView{
	
}

- (void)setBigView{
	
}

- (instancetype)init{
	
	self = [super init];
	
	if (self) {
	
		[self initial];
	}
	return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
	
	self = [super initWithFrame:frame];
	if (self) {
		[self initial];

	}
	return self;
}

- (void)initial{
	
	self.backgroundColor = [UIColor whiteColor];
	
	mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 88, LZ_SCREEN_WIDTH, LZ_SCREEN_WIDTH) collectionViewLayout:[self flowLayout]];
	mainCollectionView.showsVerticalScrollIndicator = NO ;
	[mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewcellIdentifier];
	mainCollectionView.backgroundColor = [UIColor clearColor];
	mainCollectionView.delegate = self;
	mainCollectionView.dataSource = self;
	
	[self addSubview:mainCollectionView];
	
	
	toolView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-200, LZ_SCREEN_WIDTH, 200)];
	toolView.backgroundColor = [UIColor whiteColor];
	[self addSubview:toolView];
	
	self.speakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	
	self.muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	
	self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[self addSubview:self.nameLabel];
	
	[self addSubview:self.bigtimeLabel];
//	self.nameLabel = [[UILabel alloc]init];
//
//	self.bigtimeLabel = [[UILabel alloc]init];
	
}
- (UICollectionViewFlowLayout *) flowLayout{
	
	
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	
	flowLayout.itemSize = CGSizeMake(LZ_SCREEN_WIDTH/3.0, LZ_SCREEN_WIDTH/3.0);
//
//	CGFloat off_x = (LZ_SCREEN_WIDTH+space-(space+itemWidth)*_num)/2;
//	// 3.设置cell之间的水平间距
	flowLayout.minimumInteritemSpacing = 0;
//	// 4.设置cell之间的垂直间距
	flowLayout.minimumLineSpacing = 0;
//
	flowLayout.sectionInset = UIEdgeInsetsMake(flowLayout.minimumLineSpacing, 0, 0, 0);
//
	return flowLayout;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	
	return userArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewcellIdentifier forIndexPath:indexPath];
	if (cell==nil) {
		cell = [[UICollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, LZ_SCREEN_WIDTH/3.0, LZ_SCREEN_WIDTH/3.0)];
		cell.userInteractionEnabled = YES;
	}
	LZChatGroupSingleView *logeView = [[LZChatGroupSingleView alloc]initWithFrame:CGRectMake(0, 0, LZ_SCREEN_WIDTH/3.0, LZ_SCREEN_WIDTH/3.0)];
	
	LZChatVoiceItem *item  = [userArray objectAtIndex:indexPath.row];
	[logeView upDataIcon:item.face Uid:item.userid isSingle:indexPath.row];
	
	if (item.islinking) {
		[logeView endWaitingView];
	}
	
	[cell addSubview:logeView];
	
	cell.backgroundColor = [UIColor redColor];

	return cell;
}
/**
 更新聊天群
 
 @param channelName 房间号
 @param userArr     用户信息
 */
- (void)upChatChannel:(NSString*)channelName UserInfoArr:(NSMutableArray*)userArr Other:(NSDictionary*)other{
	
	channelID = channelName;
	userArray = [NSMutableArray array];
	[self upSelfInfoLast:userArr];

	[mainCollectionView reloadData];
	
}


//将自己置后
- (void)upSelfInfoLast:(NSMutableArray*)userArr{
	
	NSDictionary *selfDic ;
	for (int i = 0 ; i<userArr.count ;i++){
		
		NSDictionary *info = [userArr objectAtIndex:i];
		NSNumber *uid = [info objectForKey:@"agorauid"];
		NSString *number = [info objectForKey:@"uid"];
		
		if([number isEqualToString:[AppUtils GetCurrentUserID]]){
			
			selfDic = info;
			_selfUid = [uid integerValue];
		}
	}
	if (selfDic) {
		
		[userArr removeObject:selfDic];
		
		[userArr addObject:selfDic];
	}
	
	
	for (NSDictionary *subDic in userArr) {
		NSNumber *uid = [subDic objectForKey:@"agorauid"];
		NSString *number = [subDic objectForKey:@"uid"];
		NSString *face = [subDic objectForKey:@"face"];

		LZChatVoiceItem *item = [[LZChatVoiceItem alloc]init];
		item.uid = [uid intValue];
		item.userid = number;
		item.face = face;
		[userArray addObject:item];
		
	}
	
	
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
- (void)joinFail{
	
	if (_delegate && [_delegate respondsToSelector:@selector(chatGroupLinkFail)]) {
		
		[_delegate chatGroupLinkFail];
		
	}
	[self closeView];
	
}

- (void)closeView{
	[_timer invalidate];
	
	[self leaveChannel];
	
	[self removeFromSuperview];
}

- (void)joinSucess:(NSDictionary*)dic{
	
	NSString *channelkey = [dic lzNSStringForKey:@"channelkey"];
	NSString *appid = [dic lzNSStringForKey:@"appid"];
	
	self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:appid delegate:self];
	
	//			[self.agoraKit setEncryptionSecret:[KeyCenter Secret]];
	//			[self.agoraKit setEncryptionMode:@"aes-256-xts"];
	[self.agoraKit setChannelProfile:AgoraRtc_ChannelProfile_Communication];
	
	
	[self.agoraKit enableAudio];
	[self.agoraKit muteLocalAudioStream:NO];
	
	
	[self.agoraKit setDefaultAudioRouteToSpeakerphone:NO];
	
	//开始
	//[self.agoraKit startPreview];
	
	int code = [self.agoraKit joinChannelByKey:channelkey channelName:channelID info:nil uid: _selfUid joinSuccess:nil];
	[self.agoraKit setEnableSpeakerphone:NO];
	
	if (code == 0) {
		[self setIdleTimerActive:NO];
	}
}
//用户离线回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {

	for (int i = 0 ; i<userArray.count ;i++){
		
		LZChatVoiceItem *item  = [userArray objectAtIndex:i];
		
		if (item.uid == uid) {
			[userArray removeObject:item];
			break;
		}
	}
	[mainCollectionView reloadData];
	
}
//本地用户网络质量回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine networkQuality:(NSUInteger)uid txQuality:(AgoraRtcQuality)txQuality rxQuality:(AgoraRtcQuality)rxQuality{
	
	if (_delegate && [_delegate respondsToSelector:@selector(netWoringQualityUp:Down:)]) {
		
		[_delegate netWoringQualityUp:txQuality Down:rxQuality];

	}
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
	
	for (int i = 0 ; i<userArray.count ;i++){
		
		LZChatVoiceItem *item  = [userArray objectAtIndex:i];
		
		if (item.uid == uid) {
			item.islinking = YES;
		}
	}
	[mainCollectionView reloadData];

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

- (void)leaveChannel {
	
	
	[AgoraRtcEngineKit destroy];
	
	[self setIdleTimerActive:YES];
}
- (void)setIdleTimerActive:(BOOL)active {
	//屏幕常量
	[UIApplication sharedApplication].idleTimerDisabled = !active;
}

//开启扬声器
- (void)switchSpeaker:(BOOL)isSpeaker{
	[self.agoraKit setEnableSpeakerphone:isSpeaker];
	
}

//静音
- (void)switchMute:(BOOL)mute{
	[self.agoraKit muteLocalAudioStream:mute];
	
}

@end
