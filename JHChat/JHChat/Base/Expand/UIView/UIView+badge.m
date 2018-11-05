//
//  UIView+badge.m
//  LeadingCloud
//
//  Created by dfl on 16/5/6.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "UIView+badge.h"

@implementation UIView (badge)


/**
 *  标记圆点
 */
-(void)badge{
    
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.width/2) radius:self.frame.size.width/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer* shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    self.layer.mask = shape;

}

@end
