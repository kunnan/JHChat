//
//  LZVideoWaveView.m
//  OpenVideoCall
//
//  Created by wang on 17/4/6.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import "LZChatWaitingWaveView.h"


@interface LZChatWaitingWaveView () {
    
    CAShapeLayer *shapeLayer;
    
    CAShapeLayer *shapeLayer1;

    CGFloat off_X;
    
}

@property (nonatomic,strong)CADisplayLink *timer;

@end

@implementation LZChatWaitingWaveView


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.lineHeight = 10 ;
        [self setBackgroundColor:[UIColor clearColor]];
        [self startWave];
    }
    return self;
}

- (void)setLineHeight:(CGFloat)lineHeight{
    
    _lineHeight = lineHeight;
}

- (void)startWave
{
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(waveAnimation)];
    self.timer.frameInterval =8;
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}


- (void)waveAnimation
{
    [shapeLayer removeFromSuperlayer];
    [shapeLayer1 removeFromSuperlayer];
    
    CGFloat waveHeight = _lineHeight;

    //第一条波纹路径
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGFloat orignOffY = 0.0;
    
    off_X +=1;
    CGFloat startOffY =  waveHeight * sinf(4* M_PI / self.bounds.size.width * 0+off_X);
    
    CGPathMoveToPoint(pathRef, NULL, 0,startOffY);
    for (CGFloat i = 0.f; i <= self.bounds.size.width; i++) {
        orignOffY = waveHeight * sinf(4* M_PI / self.bounds.size.width * i+off_X);
        CGPathAddLineToPoint(pathRef, NULL, i, orignOffY);
    }
   CGPathAddLineToPoint(pathRef, NULL, self.bounds.size.width, orignOffY);
       //CGPathCloseSubpath(pathRef);
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path=pathRef;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充颜色
    shapeLayer.strokeColor=[UIColor colorWithRed:156/255.0 green:203/255.0 blue:218/255.0 alpha:1].CGColor;//边框颜色
    [self.layer addSublayer:shapeLayer];

    //self.firstLayer.path = pathRef;
    CGPathRelease(pathRef);
    //第二条波纹路径
    CGMutablePathRef pathRef1 = CGPathCreateMutable();
    CGFloat startOffY1 = waveHeight ;
    CGFloat orignOffY1 = waveHeight * cosf(4* M_PI / self.bounds.size.width * 0+off_X);
    CGPathMoveToPoint(pathRef1, NULL, 0, startOffY1);
    for (CGFloat i = 0.f; i <= self.bounds.size.width; i++) {
        orignOffY1 = waveHeight * cosf(4* M_PI / self.bounds.size.width * i+off_X) ;
        CGPathAddLineToPoint(pathRef1, NULL, i, orignOffY1);
    }
    CGPathAddLineToPoint(pathRef1, NULL, self.bounds.size.width, orignOffY1);

    
    shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.path=pathRef1;
    shapeLayer1.fillColor=[UIColor clearColor].CGColor;//填充颜色
    shapeLayer1.strokeColor=[UIColor colorWithRed:195/255.0 green:230/255.0 blue:231/255.0 alpha:1].CGColor;//边框颜色
    [self.layer addSublayer:shapeLayer1];

  //  self.secondLayer.path = pathRef1;
    CGPathRelease(pathRef1);
    //动画
    
    
}

@end
