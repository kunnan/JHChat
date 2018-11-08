//
//  AZMetaBallItem.m
//  AZMetaBall
//
//  Created by 阿曌 on 16/1/2.
//  Copyright © 2016年 阿曌. All rights reserved.
//
//贝塞尔曲线的

#import "AZMetaBallItem.h"
#import "PointUtils.h"

@implementation AZMetaBallItem

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if(self) {
        self.color = [UIColor colorWithRed:247/255.0 green:76/255.0 blue:49/255 alpha:1];
        self.view = [self duplicate:view];
        
        float w = view.frame.size.width/1.5;
        float h = view.frame.size.height/1.5;
        
        CGPoint point = [PointUtils getGlobalCenterPositionOf:view];
        
        self.centerCircle = [Circle initWithcenterPoint:point radius:MIN(w, h)/2 color:_color];
        self.touchCircle = [Circle initWithcenterPoint:point radius:MIN(w, h)/2 color:_color];
        
        self.maxDistance = kMax_Distance;
        
        if (MIN(w, h) > 50) {
            self.maxDistance = kMax_Distance * 2;
        }
    }
    return self;
}

// Duplicate UIView
- (UIView*)duplicate:(UIView*)view
{
    
    
//    CGRect frame = view.frame;
    
    
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    NSError *error=nil;
    UIView *views;
    @try {
        views =[NSKeyedUnarchiver unarchiveTopLevelObjectWithData:tempArchive error:&error];
        NSLog(@"%@",error);

    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        
    }
    return views;
}

@end
