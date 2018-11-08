//
//  LZChatWaitingToolView.m
//  OpenVideoCall
//
//  Created by wang on 17/4/11.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import "LZChatWaitingToolView.h"


@interface LZChatWaitingToolView()

@property (nonatomic,strong) UIButton *voiceBtn;

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UIButton *answerBtn;
//是否是视频
@property (nonatomic,assign) BOOL isVideo;
@end


@implementation LZChatWaitingToolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame IsVideo:(BOOL)isVideo{
    
    self = [super initWithFrame:frame];
    self.isVideo = isVideo;
    if (self) {
        
        if (_isVideo){
            
           self.voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        }
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return self;
}

- (void)setIsVideo:(BOOL)isVideo{
    _isVideo = isVideo;
}

- (void)setVoiceBtn:(UIButton *)voiceBtn{
    
    _voiceBtn = voiceBtn;
    voiceBtn.frame = CGRectMake(self.frame.size.width/2-40, self.frame.size.height-60-10-80-30, 80, 60);
    [voiceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 18, 16, 0)];
    
    [voiceBtn setTitle:@"语音接听" forState:UIControlStateNormal];
    [voiceBtn setTitleColor:[UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1] forState:UIControlStateNormal];
    [voiceBtn setTitleEdgeInsets:UIEdgeInsetsMake(44, -36, 0, 0)];
    voiceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [voiceBtn setImage:[UIImage imageNamed:@"icon_changevoice_default"] forState:UIControlStateNormal];
    [self addSubview:voiceBtn];
    
    [voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)voiceBtnClick:(UIButton*)btn{
    
    if (_delegate && [_delegate respondsToSelector:@selector(waitingVoiceAnswer)]) {
        
        [_delegate waitingVoiceAnswer];
        
    }
}


- (void)setCloseBtn:(UIButton *)closeBtn{
    
    _closeBtn = closeBtn;
    closeBtn.frame = CGRectMake((self.frame.size.width/2-80)/3*2, self.frame.size.height-85-10, 80, 85);
    
    [closeBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [closeBtn setTitleEdgeInsets:UIEdgeInsetsMake(65, -60, 0, 0)];
    
    [closeBtn setTitleColor:[UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"AV_red_normal"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"AV_red_pressed"] forState:UIControlStateHighlighted];
    
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 20, 0)];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:closeBtn];
    
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];    
}

- (void)closeBtnClick:(UIButton*)btn{
    
    if (_delegate && [_delegate respondsToSelector:@selector(waitingClose)]) {
        
        [_delegate waitingClose];
        
    }
}

- (void)setAnswerBtn:(UIButton *)answerBtn{
    
    _answerBtn = answerBtn;
    answerBtn.frame = CGRectMake(self.frame.size.width/2+(self.frame.size.width/2-80)/3, self.frame.size.height-85-10, 80, 85);
    if (_isVideo) {
    
        [answerBtn setImage:[UIImage imageNamed:@"AV_videoaccept_normal"] forState:UIControlStateNormal];
        [answerBtn setImage:[UIImage imageNamed:@"AV_videoaccept_pressed"] forState:UIControlStateHighlighted];
    }else{
        [answerBtn setImage:[UIImage imageNamed:@"AV_audioaccept_normal"] forState:UIControlStateNormal];
        [answerBtn setImage:[UIImage imageNamed:@"AV_audioaccept_pressed"] forState:UIControlStateHighlighted];
    }

    [answerBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 20, 0)];
    answerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [answerBtn setTitle:@"接听" forState:UIControlStateNormal];
    [answerBtn setTitleEdgeInsets:UIEdgeInsetsMake(65, -60, 0, 0)];
    
    [answerBtn setTitleColor:[UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1] forState:UIControlStateNormal];
    [self addSubview:answerBtn];
    
    [answerBtn addTarget:self action:@selector(answerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)answerBtnClick:(UIButton*)btn{
    
    //要判断是什么吗
    if (_delegate && [_delegate respondsToSelector:@selector(waitingVideoAnswer:)]) {
        
        [_delegate waitingVideoAnswer:_isVideo];
        
    }
}


@end
