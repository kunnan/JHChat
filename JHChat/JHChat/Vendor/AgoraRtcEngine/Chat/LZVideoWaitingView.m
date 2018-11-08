//
//  LZVideoWaitingView.m
//  OpenVideoCall
//
//  Created by wang on 17/4/6.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import "LZVideoWaitingView.h"
#import "LZChatWaitingWaveView.h"
#import "LZChatWaitingHeadView.h"
#import "LZChatToolView.h"


@interface LZVideoWaitingView ()<LZVideoWaitingToolDelegate,CAAnimationDelegate>{
    LZChatWaitingHeadView *headView;
	
	
	UIView *tapView;
	
    NSInteger type;
	
	CGPoint loaction;
	
	BOOL isSmall;
	
	
    
}
@property (nonatomic, strong) CAShapeLayer *shapeLayer;


@property (nonatomic,strong) UIButton *replyBtn;

@property (nonatomic,strong) UIButton *voiceBtn;

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UIButton *answerBtn;

@end




@implementation LZVideoWaitingView


- (instancetype)initWithFrame:(CGRect)frame IsVideo:(BOOL)isVideo{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
		isSmall = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        headView = [[LZChatWaitingHeadView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 400)];
		[headView.backChatBtn addTarget:self action:@selector(backChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		
//		headView.backChatBtn.hidden = YES;
        [self addSubview:headView];
        
        if (isVideo) {
            
            type = 1;
            [headView upDataUserName:@"明城" UserFace:nil Type:1];
        }else{
            type = 2;
            [headView upDataUserName:@"明城" UserFace:nil Type:2];

        }

        LZChatWaitingWaveView *waveView = [[LZChatWaitingWaveView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-200-20, self.frame.size.width, 20)];
        [self addSubview:waveView];
        
        
//        LZChatToolView *chatToolView = [[LZChatToolView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-200, self.frame.size.width, 200)];
//        
//        [self addSubview:chatToolView];
        
        LZChatWaitingToolView *  chatToolView = [[LZChatWaitingToolView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-200, self.frame.size.width, 200) IsVideo:isVideo];
        chatToolView.delegate = self;
        [self addSubview:chatToolView];
		
		loaction = CGPointMake(LZ_SCREEN_WIDTH - 60, LZ_SCREEN_HEIGHT - 80);

    }
    
    return self;
}


/**
 挂断
 */
- (void)waitingClose{
    
    if(_delegate && [_delegate respondsToSelector:@selector(waitingClose)]){
        
        [_delegate waitingClose];
    }
}


/**
 接听
 */
- (void)waitingVideoAnswer:(BOOL)isVideo{
    if(_delegate && [_delegate respondsToSelector:@selector(waitingVideoAnswer:)]){
        
        [_delegate waitingVideoAnswer:isVideo];
    }
}


/**
 语音接听
 */
- (void)waitingVoiceAnswer{
    
    if(_delegate && [_delegate respondsToSelector:@selector(waitingVoiceAnswer)]){
        
        [_delegate waitingVoiceAnswer];
    }

}


- (void)backChatBtnClick:(UIButton*)btn{
	
	if (_delegate && [_delegate respondsToSelector:@selector(backChatViewController)]) {

		[_delegate backChatViewController];
	}
	[self addVoiceSmallWindowAnimation];
}

- (void)addVoiceSmallWindowAnimation{
	
	isSmall = YES;
	UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:headView.iconImageView.frame];
	
	CGSize startSize = CGSizeMake(self.frame.size.width*0.5, self.frame.size.height- headView.iconImageView.center.y);
	
	CGFloat radius = sqrt(startSize.width * startSize.width + startSize.height * startSize.height);
	CGRect startRect = CGRectInset(headView.iconImageView.frame, -radius, -radius);
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
		rect.origin = headView.iconImageView.frame.origin;
		self.bounds = rect;
		rect.size = headView.iconImageView.frame.size;
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
				
			self.center = headView.iconImageView.center;
			self.transform = CGAffineTransformIdentity;
				
		}completion:^(BOOL finished) {
//				[self.smallVoiceView removeFromSuperview];
				self.bounds = [UIScreen mainScreen].bounds;
				
				self.frame = self.bounds;
				
				UIBezierPath *startPath = [UIBezierPath bezierPathWithArcCenter:headView.iconImageView.center radius:headView.iconImageView.frame.size.height startAngle:0 endAngle:2*M_PI clockwise:YES];
				
				// 2.获取动画缩放结束时的圆形
				CGSize endSize = CGSizeMake(self.frame.size.width * 0.5, self.frame.size.height - headView.iconImageView.center.y);
				
				CGFloat radius = sqrt(endSize.width*endSize.width+endSize.height*endSize.height);
				
				CGRect endRect = CGRectInset(headView.iconImageView.frame, -radius, -radius);
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

- (void)upUserName:(NSString*)userName Face:(NSString*)face RoomName:(NSString*)roomName{
    
    [headView upDataUserName:userName UserFace:face Type:type];
    
    self.face = face;
    self.userName = userName;
    self.roomName = roomName;
    
}
@end
