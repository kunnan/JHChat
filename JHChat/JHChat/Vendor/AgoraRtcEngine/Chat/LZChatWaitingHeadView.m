//
//  LZChatWaitingHeadView.m
//  OpenVideoCall
//
//  Created by wang on 17/4/10.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import "LZChatWaitingHeadView.h"
#import "UIImageView+Icon.h"
//#import "QINetReachabilityManager.h"
#import "AFNetworking.h"


@interface LZChatWaitingHeadView (){
    
    CGFloat Scal ; //间距缩小比例
}

//名字
@property (nonatomic,strong) UILabel *nameLabel;
//类型
@property (nonatomic,strong) UILabel *subjectLabel;
//提示文字
@property (nonatomic,strong) UILabel *promptLabel;


@end




@implementation LZChatWaitingHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        if([UIScreen mainScreen].bounds.size.height<=568){
            Scal = 0.5;
        }else{
            Scal =1;
        }
        self.backgroundColor = [UIColor whiteColor];
        
        self.iconImageView = [[UIImageView alloc]init];
        
        self.nameLabel = [[UILabel alloc]init];
        
        self.subjectLabel = [[UILabel alloc]init];
        
        self.promptLabel = [[UILabel alloc]init];
		
		self.backChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    
    return self;
}

- (void)setBackChatBtn:(UIButton *)backChatBtn{
	
	_backChatBtn = backChatBtn;
	[backChatBtn setImage:[UIImage imageNamed:@"icon_backmsg_default"] forState:UIControlStateNormal];
	
	
	backChatBtn.frame = CGRectMake(LZ_SCREEN_WIDTH - 50, 20, 36, 36);
	[self addSubview:backChatBtn];
	
	
}

- (void)setIconImageView:(UIImageView *)iconImageView{
    
    _iconImageView = iconImageView;
    
    
    iconImageView.frame = CGRectMake((self.frame.size.width-160)/2, 90*Scal, 160, 160);
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 80;
    [self addSubview:iconImageView];
    
    iconImageView.backgroundColor = [UIColor colorWithRed:90/255.0 green:112/255.0 blue:120/255.0 alpha:1];
}

- (void)setNameLabel:(UILabel *)nameLabel{
    
    _nameLabel = nameLabel;
    
    nameLabel.frame = CGRectMake(20, CGRectGetMaxY(_iconImageView.frame)+35*Scal, self.frame.size.width-40, 20);
    
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    nameLabel.textColor = [UIColor colorWithRed:90/255.0 green:112/255.0 blue:120/255.0 alpha:1];
    [self addSubview:nameLabel];
    nameLabel.text = @"";
    
}

- (void)setSubjectLabel:(UILabel *)subjectLabel{
    
    _subjectLabel = subjectLabel;
    
    subjectLabel.frame = CGRectMake(20, CGRectGetMaxY(_nameLabel.frame)+16*Scal, self.frame.size.width-40, 17);
    subjectLabel.textAlignment = NSTextAlignmentCenter;
    subjectLabel.font = [UIFont systemFontOfSize:17];
    subjectLabel.textColor = [UIColor colorWithRed:105/255.0 green:118/255.0 blue:125/255.0 alpha:1];
    
    [self addSubview:subjectLabel];
    
    subjectLabel.text = @"视频通话";
}


- (void)setPromptLabel:(UILabel *)promptLabel{
    
    _promptLabel = promptLabel;
    
    promptLabel.frame = CGRectMake(20, CGRectGetMaxY(_subjectLabel.frame)+36*Scal, self.frame.size.width-40, 14);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textColor = [UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1];
    
    [self addSubview:promptLabel];
    
    /* 判断网络 */
//    QINetReachabilityManager *manager = [QINetReachabilityManager sharedInstance];
//    QINetReachabilityStatus status = (QINetReachabilityStatus)[manager currentNetReachabilityStatus];
    // 1.初始化AFNetworkReachabilityManager，获取单例
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    if(netManager.isReachableViaWWAN){
        promptLabel.text = @"你正在使用手机流量";
    } else if (netManager.isReachableViaWiFi) {
        promptLabel.text = @"你正在使用WIFI网络";
    }



}

/**
 设置用户信息
 
 @param name 名字
 @param face 头像
 @param type 类型 1 视频 2 语音
 */
-(void)upDataUserName:(NSString*)name UserFace:(NSString*)face Type:(NSInteger)type{
    
    _nameLabel.text = name;
    
    if (type==1) {
        _subjectLabel.text = @"视频通话";
    } else if (type==2){
        _subjectLabel.text = @"语音通话";
    }
    
    [_iconImageView loadFaceIcon:face isChangeToCircle:true];
    
}

- (void)upChatTimeLength:(NSString*)length{
    
    _promptLabel.text = @"";

    _subjectLabel.text = length;
}

@end
