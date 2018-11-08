//
//  LZViedoChatHeadView.m
//  OpenVideoCall
//
//  Created by wang on 17/4/5.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import "LZVideoChatHeadView.h"


@interface LZVideoChatHeadView (){
    NSInteger times;
} 


@property (nonatomic,strong) UIButton *cameraBtn;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UIButton *backChatBtn;

@end


@implementation LZVideoChatHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //名字
//        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width-80, 30)];
        //状态
//        self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 44, [UIScreen mainScreen].bounds.size.width-80, 20)];
        //摄像头切换
		self.backChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        
    }
    return self;
}
- (void)setBackChatBtn:(UIButton *)backChatBtn{
	
	_backChatBtn = backChatBtn;
	[backChatBtn setImage:[UIImage imageNamed:@"icon_onebackmsg_select"] forState:UIControlStateNormal];
	
	
	backChatBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50-40-15, 5, 36, 36);
	[self addSubview:backChatBtn];
	
	[backChatBtn addTarget:self action:@selector(backChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];

	
}


- (void)setNameLabel:(UILabel *)nameLabel{
    
    _nameLabel = nameLabel;
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:nameLabel];
    
}

- (void)setStateLabel:(UILabel *)stateLabel{
    
    _stateLabel = stateLabel;
    stateLabel.textColor = [UIColor whiteColor];
    stateLabel.font = [UIFont systemFontOfSize:17];
    
    [self addSubview:stateLabel];
}

- (void)setCameraBtn:(UIButton *)cameraBtn{
    
    _cameraBtn = cameraBtn;
    cameraBtn.frame = CGRectMake(LZ_SCREEN_WIDTH - 50-5, 5, 36, 36);
    [cameraBtn setImage:[UIImage imageNamed:@"icon_change_default"] forState:UIControlStateNormal];
    [self addSubview:cameraBtn];
    
    [cameraBtn addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark 切换摄像头
- (void)cameraClick:(UIButton*)btn{
    
    if (_delegate && [_delegate respondsToSelector:@selector(changeCamera)]) {
        [_delegate changeCamera];
    }
}

- (void)backChatBtnClick:(UIButton*)btn{
	
	if (_delegate && [_delegate respondsToSelector:@selector(backChat)]) {
		[_delegate backChat];
	}
	
}

/**
 更新文字信息
 
 @param userName 聊天用户名
 @param state    状态 0 正在连接 1 链接成功
 */
- (void)upChatUserName:(NSString *)userName State:(NSInteger)state{
    
    _nameLabel.text = userName;
    
    if (state==0) {
        _stateLabel.text = @"等待对方接听...";

    }else{
        times = 0;

        _stateLabel.text = @"";

    }
}

#pragma mark 计时器

- (void)upChatTimeLength:(NSString*)length{
    
    _stateLabel.text = length;


}


@end
