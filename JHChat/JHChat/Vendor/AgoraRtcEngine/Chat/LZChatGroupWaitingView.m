//
//  LZChatGroupWaitingView.m
//  LeadingCloud
//
//  Created by wang on 2017/7/20.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZChatGroupWaitingView.h"
#import "UIImageView+Icon.h"


@interface LZChatGroupWaitingView()<CAAnimationDelegate>{
	
	UIView *tapView;
	
	CGPoint loaction;
	
	BOOL isSmall;
}

@property (nonatomic,strong) UIButton *answerBtn;

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *promptLabel;

@property (nonatomic,strong)UILabel *memberLabel;

@property (nonatomic,strong)UIView *memberView;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic,strong) UIButton *backChatBtn;


@end

@implementation LZChatGroupWaitingView


- (instancetype)initWithFrame:(CGRect)frame{
	
	self = [super initWithFrame:frame];
	
	if (self) {
		isSmall = NO;

		self.backgroundColor = [UIColor whiteColor];
		
		
		self.iconImageView = [[UIImageView alloc]init];
		
		self.nameLabel = [[UILabel alloc]init];
		self.promptLabel = [[UILabel alloc]init];
		self.memberLabel = [[UILabel alloc]init];
		
		self.memberView = [[UIView alloc]init];
		

		self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		
		self.answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		
		loaction = CGPointMake(LZ_SCREEN_WIDTH - 60, LZ_SCREEN_HEIGHT - 80);
		
		self.backChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		

	}
	return self;
}

- (void)setBackChatBtn:(UIButton *)backChatBtn{
	
	_backChatBtn = backChatBtn;
	[backChatBtn setImage:[UIImage imageNamed:@"icon_backmsg_default"] forState:UIControlStateNormal];
	
	[backChatBtn addTarget:self action:@selector(backChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	backChatBtn.frame = CGRectMake(LZ_SCREEN_WIDTH - 50, 20, 36, 36);
	[self addSubview:backChatBtn];
	
}

- (void)setIconImageView:(UIImageView *)iconImageView{
	
	_iconImageView = iconImageView;
	
	iconImageView.frame =CGRectMake(0, 0, 130, 130);
	
	iconImageView.center = CGPointMake(self.frame.size.width/2, 80+80);
	
	[self addSubview:iconImageView];

}

- (void)setNameLabel:(UILabel *)nameLabel{
	
	_nameLabel = nameLabel;
	
	_nameLabel.frame = CGRectMake(0, CGRectGetMaxY(_iconImageView.frame)+20, self.frame.size.width, 20);
	
	_nameLabel.text = @"名称";
	nameLabel.textAlignment = NSTextAlignmentCenter;
	nameLabel.textColor = [UIColor blackColor];
	
	[self addSubview:nameLabel];
}

- (void)setPromptLabel:(UILabel *)promptLabel{
	
	
	_promptLabel = promptLabel;
	promptLabel.frame = CGRectMake(0, CGRectGetMaxY(_nameLabel.frame)+10, self.frame.size.width, 15);
	promptLabel.font= [UIFont systemFontOfSize:12];
	promptLabel.textColor = [UIColor blackColor];

	promptLabel.textAlignment = NSTextAlignmentCenter;
	
	promptLabel.text = @"邀请你进行语音聊天";
	[self addSubview:promptLabel];
}
- (void)setMemberLabel:(UILabel *)memberLabel{
	
	_memberLabel = memberLabel;
	memberLabel.frame = CGRectMake(0, CGRectGetMaxY(_promptLabel.frame)+80, self.frame.size.width, 15);
	memberLabel.font= [UIFont systemFontOfSize:12];
	memberLabel.textColor = [UIColor blackColor];
	
	memberLabel.textAlignment = NSTextAlignmentCenter;
	memberLabel.text = @"通话成员";
	[self addSubview:memberLabel];
}

- (void)setMemberView:(UIView *)memberView{
	
	_memberView = memberView;
	
	memberView.frame = CGRectMake(0, CGRectGetMaxY(_memberLabel.frame)+5, self.frame.size.width, 60);
	[self addSubview:memberView];
}

- (void)setCloseBtn:(UIButton *)closeBtn{
	
	_closeBtn = closeBtn;
	closeBtn.frame = CGRectMake((self.frame.size.width/2-80)/3*2, self.frame.size.height-85-10, 80, 85);
	
	[closeBtn setImage:[UIImage imageNamed:@"AV_red_normal"] forState:UIControlStateNormal];
	[closeBtn setImage:[UIImage imageNamed:@"AV_red_pressed"] forState:UIControlStateHighlighted];
	
	[closeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 20, 0)];
	closeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
	[self addSubview:closeBtn];
	
	[closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)closeBtnClick:(UIButton*)btn{
	
	if (_delegate && [_delegate respondsToSelector:@selector(groupWaitingClose)]) {
		
		[_delegate groupWaitingClose];
	}
	
}

- (void)setAnswerBtn:(UIButton *)answerBtn{
	
	_answerBtn = answerBtn;
	answerBtn.frame = CGRectMake(self.frame.size.width/2+(self.frame.size.width/2-80)/3, self.frame.size.height-85-10, 80, 85);

	[answerBtn setImage:[UIImage imageNamed:@"AV_audioaccept_normal"] forState:UIControlStateNormal];
	[answerBtn setImage:[UIImage imageNamed:@"AV_audioaccept_pressed"] forState:UIControlStateHighlighted];

	[answerBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 20, 0)];

	[self addSubview:answerBtn];
	
	[answerBtn addTarget:self action:@selector(answerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
}
- (void)answerBtnClick:(UIButton*)btn{
	
	if (_delegate && [_delegate respondsToSelector:@selector(groupWaitingAnswer)]) {
		
		[_delegate groupWaitingAnswer];
		
	}
}



- (void)setUpUserFace:(NSString*)faceid Name:(NSString*)name User:(NSArray*)userArray Uid:(NSString *)uid{
	
	[_iconImageView loadFaceIcon:faceid isChangeToCircle:true];
	
	_nameLabel.text = name;
	
	for (UIView *view  in _memberView.subviews) {
		[view removeFromSuperview];
	}
    NSMutableArray * userArr = [NSMutableArray array];
    for (NSDictionary *userDic in userArray) {
        if (![[userDic objectForKey:@"number"] isEqualToString:uid]) {
            [userArr addObject:userDic];
        }
    }
    
	NSInteger x = userArr.count%2;
	NSInteger y = userArr.count/2;
	
	CGFloat off_x = self.frame.size.width/2 - x *15 - y*35;
	for (int i=0 ; i<userArr.count; i++) {
		
		UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(off_x+i*35, 0, 30, 30)];
		
		NSDictionary *dict = [userArr objectAtIndex:i];
		[imgv loadFaceIcon:[dict lzNSStringForKey:@"face"] isChangeToCircle:NO];
		[_memberView addSubview:imgv];
		
	}
}


- (void)backChatBtnClick:(UIButton*)btn{
	
	if (_delegate && [_delegate respondsToSelector:@selector(backChatViewGroupController)]) {
		
		[_delegate backChatViewGroupController];
	}
	[self addVoiceSmallWindowAnimation];
}

- (void)addVoiceSmallWindowAnimation{
	
	isSmall = YES;
	UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:_iconImageView.frame];
	
	CGSize startSize = CGSizeMake(self.frame.size.width*0.5, self.frame.size.height- _iconImageView.center.y);
	
	CGFloat radius = sqrt(startSize.width * startSize.width + startSize.height * startSize.height);
	CGRect startRect = CGRectInset(_iconImageView.frame, -radius, -radius);
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
		rect.origin = _iconImageView.frame.origin;
		self.bounds = rect;
		rect.size = _iconImageView.frame.size;
		self.frame = rect;
		
		[UIView animateWithDuration:1.0 animations:^{
			self.center = loaction;
			self.transform = CGAffineTransformMakeScale(0.5, 0.5);
			
		} completion:^(BOOL finished) {
			
			[self addTapView];
		}];
	} else if ([anim isEqual:[self.shapeLayer animationForKey:@"showAnimation"]]) {
		self.layer.mask = nil;
		self.shapeLayer = nil;
		
	}
	
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
	[tapView removeFromSuperview];
	
	
	[UIView animateWithDuration:1 animations:^{
		
		self.center = _iconImageView.center;
		self.transform = CGAffineTransformIdentity;
		
	}completion:^(BOOL finished) {
		//				[self.smallVoiceView removeFromSuperview];
		self.bounds = [UIScreen mainScreen].bounds;
		
		self.frame = self.bounds;
		
		UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:_iconImageView.center radius:_iconImageView.frame.size.height startAngle:0 endAngle:2*M_PI clockwise:YES];
		
		// 2.获取动画缩放结束时的圆形
		CGSize endSize = CGSizeMake(self.frame.size.width * 0.5, self.frame.size.height - _iconImageView.center.y);
		
		CGFloat radius = sqrt(endSize.width*endSize.width+endSize.height*endSize.height);
		
		CGRect endRect = CGRectInset(_iconImageView.frame, -radius, -radius);
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

#pragma mark 拖动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	if (!isSmall) {
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
	
	loaction = CGPointMake(offsetX+orgin.x+40, offsetY+orgin.y+40);
	
	// 移动当前view
	self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
	//	loaction = self.center;
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
