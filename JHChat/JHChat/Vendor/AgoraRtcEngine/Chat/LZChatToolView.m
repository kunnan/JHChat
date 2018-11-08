//
//  LZChatToolView.m
//  OpenVideoCall
//
//  Created by wang on 17/4/1.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import "LZChatToolView.h"

@interface LZChatToolView ()

//静音
@property (nonatomic,strong)UIButton *muteBtn;
//摄像头
@property (nonatomic,strong) UIButton *cameraBtn;
//扬声器
@property (nonatomic,strong) UIButton *speakerBtn;
//收起
@property (nonatomic,strong) UIButton *smallBtn;
//挂断
@property (nonatomic,strong) UIButton *cannelBtn;


@end

@implementation LZChatToolView


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.speakerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.smallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return self;
}

- (void)setMuteBtn:(UIButton *)muteBtn{
    
    _muteBtn = muteBtn;
    
    muteBtn.frame = CGRectMake(self.frame.size.width/4*0+(self.frame.size.width/4-60)/2, 5, 60, 60);
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
    cameraBtn.frame = CGRectMake(self.frame.size.width/4*1+(self.frame.size.width/4-60)/2, 5, 60, 60);

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
    speakerBtn.frame = CGRectMake(self.frame.size.width/4*2+(self.frame.size.width/4-60)/2, 5, 60, 60);
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

- (void)setSmallBtn:(UIButton *)smallBtn{
    _smallBtn = smallBtn;
    smallBtn.frame = CGRectMake(self.frame.size.width/4*3+(self.frame.size.width/4-60)/2, 5, 60, 60);
    [smallBtn setTitle:@"收起" forState:UIControlStateNormal];
   // [smallBtn setImage:[UIImage imageNamed:@"AV_scale"] forState:UIControlStateNormal];
    [self addSubview:smallBtn];
    
    [smallBtn addTarget:self action:@selector(smallBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [smallBtn setImage: [UIImage imageNamed:@"icon_zoomin_default"] forState:UIControlStateNormal];
    
    [smallBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 16, 0)];
    [smallBtn setTitleEdgeInsets:UIEdgeInsetsMake(44, -44, 0, 0)];
    smallBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [smallBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:102/255.0 blue:112/255.0 alpha:1] forState:UIControlStateNormal];

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

#pragma mark 切换小窗
- (void)smallBtnClick:(UIButton*)btn{
    
    if (_delegate && [_delegate respondsToSelector:@selector(switchSmallWindow)]) {
        
        [_delegate switchSmallWindow];
    }
}

/**
 
 更新状态
 @param state    状态 0 正在连接 1 链接成功
 
 */
- (void)upChatState:(NSInteger)state IsVideo:(BOOL)isVideo{
    
    
    if(state==1){
        _cameraBtn.enabled = YES;
		_muteBtn.enabled = YES;
		_speakerBtn.enabled = YES;
        _cameraBtn.selected =isVideo;

    }else{
        _cameraBtn.enabled = NO;
		_muteBtn.enabled = NO;
		_speakerBtn.enabled = NO;
		
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
