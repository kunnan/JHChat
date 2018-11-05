//
//  LZVerticallyCenterTextView.m
//  LeadingCloud
//
//  Created by dfl on 16/5/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LZVerticallyCenterTextView.h"

@interface LZVerticallyCenterTextView()
@end

@implementation LZVerticallyCenterTextView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.textAlignment = NSTextAlignmentCenter;
        [self addObserver:self forKeyPath:@"contentSize" options:  (NSKeyValueObservingOptionNew) context:NULL];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder])
    {
        self.textAlignment = NSTextAlignmentCenter;
        [self addObserver:self forKeyPath:@"contentSize" options:  (NSKeyValueObservingOptionNew) context:NULL];
    }
    return self;

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        UITextView *tv = object;
        CGFloat deadSpace = ([tv bounds].size.height - [tv contentSize].height);
        CGFloat inset = MAX(0, deadSpace/2.0);
        tv.contentInset = UIEdgeInsetsMake(inset, tv.contentInset.left, inset, tv.contentInset.right);
    }
}
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentSize"];
}

-(void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    //Prevent zooming but not panning
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        gestureRecognizer.enabled = YES;
    }
    [super addGestureRecognizer:gestureRecognizer];
    return;
}

@end
