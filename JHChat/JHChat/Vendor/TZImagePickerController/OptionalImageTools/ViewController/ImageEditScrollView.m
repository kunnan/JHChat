//
//  ImageEditScrollView.m
//  LeadingCloud
//
//  Created by SY on 2017/10/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "ImageEditScrollView.h"

@implementation ImageEditScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"开始点击屏幕");
    //做你想要的操作
    if (self.imageEditScrollViewDelegate && [self.imageEditScrollViewDelegate respondsToSelector:@selector(imageEditScrollViewTouchBegan:withEvent:)]) {
        [self.imageEditScrollViewDelegate imageEditScrollViewTouchBegan:touches withEvent:event];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"结束点击屏幕");
    //做你想要的操作
    if (self.imageEditScrollViewDelegate && [self.imageEditScrollViewDelegate respondsToSelector:@selector(imageEditScrollViewTouchEnded:withEvent:)]) {
        [self.imageEditScrollViewDelegate imageEditScrollViewTouchEnded:touches withEvent:event];
    }
}
-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    NSLog(@"点击移动");
    if (self.imageEditScrollViewDelegate && [self.imageEditScrollViewDelegate respondsToSelector:@selector(imageEditScrollViewTouchMove:withEvent:)]) {
        [self.imageEditScrollViewDelegate imageEditScrollViewTouchMove:touches withEvent:event];
    }
}
-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"点击取消");
    if (self.imageEditScrollViewDelegate && [self.imageEditScrollViewDelegate respondsToSelector:@selector(imageEditScrollViewTouchCancle:withEvent:)]) {
        [self.imageEditScrollViewDelegate imageEditScrollViewTouchCancle:touches withEvent:event];
    }
    
}
@end
