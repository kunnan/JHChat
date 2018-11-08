//
//  LZChatGroupToolView.m
//  LeadingCloud
//
//  Created by wang on 17/4/26.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZChatGroupToolView.h"


@interface LZChatGroupToolView (){
	
	NSInteger count;
	
}


//摄像头
@property (nonatomic,strong) UIButton *cameraBtn;
//扬声器
@property (nonatomic,strong) UIButton *speakerBtn;
//挂断
@property (nonatomic,strong) UIButton *cannelBtn;

//禁言
@property (nonatomic,strong) UIButton *banBtn;
//添加
@property (nonatomic,strong) UIButton *addBtn;
//回到聊天
@property (nonatomic,strong) UIButton *chatBtn;

@end


@implementation LZChatGroupToolView


- (instancetype)initWithFrame:(CGRect)frame isAdmins:(BOOL)isadmins{
    
    self = [super initWithFrame:frame];
    
    if (self) {
		if (isadmins) {
			count =4;
		}else{
			count = 3;

		}
        self.muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.speakerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		if(count!=3){
			self.banBtn = [UIButton buttonWithType:UIButtonTypeCustom];

		}
        self.cannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		self.chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    }
    return self;
}

- (void)setAddBtn:(UIButton *)addBtn{
	
	_addBtn = addBtn;
	addBtn.frame = CGRectMake(self.frame.size.width/3*0+(self.frame.size.width/3-60)/2, 100, 60, 60);
	
	[addBtn setTitle:@"邀请成员" forState:UIControlStateNormal];
	[addBtn setImage: [UIImage imageNamed:@"icon_adduser_default"] forState:UIControlStateNormal];
	
	[addBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 16, 0)];
	[addBtn setTitleEdgeInsets:UIEdgeInsetsMake(44, -44, 0, 0)];
	
	addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
	
	[addBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:102/255.0 blue:112/255.0 alpha:1] forState:UIControlStateNormal];
	[addBtn setTitleColor:[UIColor colorWithRed:23/255.0 green:179/255.0 blue:254/255.0 alpha:1] forState:UIControlStateSelected];
	[addBtn setTitleColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:153/255.0 alpha:1] forState:UIControlStateDisabled];
	[addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];

	[self addSubview:addBtn];
	
}

- (void)addClick:(UIButton*)btn{
	
	if (_delegate && [_delegate respondsToSelector:@selector(switchAdd:)]) {
		
		[_delegate switchAdd:btn.selected];
	}
}

- (void)setChatBtn:(UIButton *)chatBtn{
	chatBtn.frame = CGRectMake(self.frame.size.width-(self.frame.size.width/3-60)/2-60, 100, 60, 60);
	
	_chatBtn = chatBtn;
	[chatBtn setTitle:@"返回聊天" forState:UIControlStateNormal];
	[chatBtn setImage: [UIImage imageNamed:@"icon_backmsg_default"] forState:UIControlStateNormal];
	
	[chatBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 16, 0)];
	[chatBtn setTitleEdgeInsets:UIEdgeInsetsMake(44, -44, 0, 0)];
	
	chatBtn.titleLabel.font = [UIFont systemFontOfSize:13];
	
	[chatBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:102/255.0 blue:112/255.0 alpha:1] forState:UIControlStateNormal];
	[chatBtn setTitleColor:[UIColor colorWithRed:23/255.0 green:179/255.0 blue:254/255.0 alpha:1] forState:UIControlStateSelected];
	[chatBtn setTitleColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:153/255.0 alpha:1] forState:UIControlStateDisabled];
	[chatBtn addTarget:self action:@selector(chatClick:) forControlEvents:UIControlEventTouchUpInside];

	[self addSubview:chatBtn];
	
}
- (void)chatClick:(UIButton*)btn{
	
	if (_delegate && [_delegate respondsToSelector:@selector(switchChat:)]) {
		[_delegate switchChat:btn.selected];
		
	}
}

- (void)setBanBtn:(UIButton *)banBtn{
	
	_banBtn = banBtn;
	banBtn.frame = CGRectMake(self.frame.size.width/3*2+(self.frame.size.width/3-60)/2, 5, 60, 60);

	[banBtn setTitle:@"禁言" forState:UIControlStateNormal];
	[banBtn setImage: [UIImage imageNamed:@"icon_ban_default"] forState:UIControlStateNormal];
	[banBtn setImage: [UIImage imageNamed:@"icon_ban_gary"] forState:UIControlStateDisabled];

	[banBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 16, 0)];
	[banBtn setTitleEdgeInsets:UIEdgeInsetsMake(44, -44, 0, 0)];
	
	banBtn.titleLabel.font = [UIFont systemFontOfSize:13];
	
	[banBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:102/255.0 blue:112/255.0 alpha:1] forState:UIControlStateNormal];
	[banBtn setTitleColor:[UIColor colorWithRed:23/255.0 green:179/255.0 blue:254/255.0 alpha:1] forState:UIControlStateSelected];
	[banBtn setTitleColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:153/255.0 alpha:1] forState:UIControlStateDisabled];
	banBtn.enabled = NO;
	[banBtn addTarget:self action:@selector(banClick:) forControlEvents:UIControlEventTouchUpInside];

	[self addSubview:banBtn];
}

- (void)banClick:(UIButton*)btn{
	if (_delegate && [_delegate respondsToSelector:@selector(switchban:)]) {
		
		[_delegate switchban:btn.selected];
	}
}

- (void)setMuteBtn:(UIButton *)muteBtn{
    
    _muteBtn = muteBtn;
    
    muteBtn.frame = CGRectMake(self.frame.size.width/3*0+(self.frame.size.width/3-60)/2,5, 60, 60);
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
}

- (void)setCameraBtn:(UIButton *)cameraBtn{
    
    _cameraBtn = cameraBtn;
	
	if (count==3) {
		cameraBtn.frame = CGRectMake(self.frame.size.width/3*1+(self.frame.size.width/3-60)/2, 5, 60, 60);

	}else{
		
		CGFloat windth = self.frame.size.width-(self.frame.size.width/3-60)/2-60-(self.frame.size.width/3*0+(self.frame.size.width/3-60)/2+60);
	
		cameraBtn.frame = CGRectMake(CGRectGetMaxX(_muteBtn.frame)+(windth-120)/3, 5, 60, 60);

	}
	
    [cameraBtn setTitle:@"摄像头" forState:UIControlStateNormal];
    [self addSubview:cameraBtn];
    
    [cameraBtn setImage: [UIImage imageNamed:@"icon_videotape_default"] forState:UIControlStateNormal];
    [cameraBtn setImage: [UIImage imageNamed:@"icon_videotape_on"] forState:UIControlStateSelected];
    [cameraBtn setImage: [UIImage imageNamed:@"icon_videotape_gray"] forState:UIControlStateDisabled];
    
    [cameraBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 16, 0)];
    [cameraBtn setTitleEdgeInsets:UIEdgeInsetsMake(44, -44, 0, 0)];
    cameraBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [cameraBtn addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cameraBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:102/255.0 blue:112/255.0 alpha:1] forState:UIControlStateNormal];
    [cameraBtn setTitleColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:153/255.0 alpha:1] forState:UIControlStateDisabled];
    [cameraBtn setTitleColor:[UIColor colorWithRed:23/255.0 green:179/255.0 blue:254/255.0 alpha:1] forState:UIControlStateSelected];
    
    cameraBtn.enabled = NO;
}

- (void)setSpeakerBtn:(UIButton *)speakerBtn{
    
    _speakerBtn = speakerBtn;
    [speakerBtn setTitle:@"扬声器" forState:UIControlStateNormal];
	if (count==3) {
		
		speakerBtn.frame =CGRectMake(self.frame.size.width/3*2+(self.frame.size.width/3-60)/2, 5, 60, 60);

	}else{
		CGFloat windth = self.frame.size.width-(self.frame.size.width/3-60)/2-60-(self.frame.size.width/3*0+(self.frame.size.width/3-60)/2+60);

		speakerBtn.frame = CGRectMake(CGRectGetMaxX(_muteBtn.frame)+(windth-120)/3*2+60, 5, 60, 60);

	}
    [self addSubview:speakerBtn];
    
    [speakerBtn addTarget:self action:@selector(sepakerClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [speakerBtn setImage: [UIImage imageNamed:@"icon_sound_default"] forState:UIControlStateNormal];
    [speakerBtn setImage: [UIImage imageNamed:@"icon_sound_on"] forState:UIControlStateSelected];
    [speakerBtn setImage: [UIImage imageNamed:@"icon_sound_gray"] forState:UIControlStateDisabled];
    
    [speakerBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 16, 0)];
    [speakerBtn setTitleEdgeInsets:UIEdgeInsetsMake(44, -44, 0, 0)];
    speakerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [speakerBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:102/255.0 blue:112/255.0 alpha:1] forState:UIControlStateNormal];
    [speakerBtn setTitleColor:[UIColor colorWithRed:23/255.0 green:179/255.0 blue:254/255.0 alpha:1] forState:UIControlStateSelected];
	[speakerBtn setTitleColor:[UIColor colorWithRed:152/255.0 green:152/255.0 blue:153/255.0 alpha:1] forState:UIControlStateDisabled];

	speakerBtn.enabled = NO;

}

- (void)setCannelBtn:(UIButton *)cannelBtn{
    
    _cannelBtn = cannelBtn;
    cannelBtn.frame = CGRectMake(self.frame.size.width/2-30, 95, 60, 60);
    [cannelBtn setImage:[UIImage imageNamed:@"AV_red_normal"] forState:UIControlStateNormal];
    [cannelBtn setImage:[UIImage imageNamed:@"AV_red_pressed"] forState:UIControlStateHighlighted];
    
    [cannelBtn addTarget:self action:@selector(cannelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cannelBtn];
}



- (void)muteClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(switchMute:)]) {
        
        [_delegate switchMute:btn.selected];
    }
}

#pragma mark 切换摄像头
- (void)cameraClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(switchVideoAndVoice:)]) {
        [_delegate switchVideoAndVoice:btn.selected];
    }
}

#pragma 开启扬声器
- (void)sepakerClick:(UIButton*)btn{
    
    btn.selected = !btn.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(switchSpeaker:)]) {
        
        [_delegate switchSpeaker:btn.selected];
    }
}



#pragma 视频退出
- (void)cannelClick:(UIButton*)btn{
    
    btn.selected = !btn.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(cannel)]) {
        
        [_delegate cannel];
    }
}


/**
 
 更新状态
 @param state    状态 0 正在连接 1 链接成功
 
 */
- (void)upChatState:(NSInteger)state IsVideo:(BOOL)isVideo{
    
    
    if(state==1){
        _cameraBtn.enabled = YES;
		_banBtn.enabled = YES;
        _cameraBtn.selected =isVideo;
		_muteBtn.enabled = YES;
		_speakerBtn.enabled = YES;

    }else{
		
        _cameraBtn.enabled = NO;
        
    }
}
/**
 
 更新扬声器状态 （语音关闭，视频打开）
 
 */
- (void)upDataSpeaker:(BOOL)isSelect{
	
	_speakerBtn.selected = isSelect;
	
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
