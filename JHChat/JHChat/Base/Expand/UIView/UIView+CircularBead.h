//
//  UIView+CircularBead.h
//  LeadingCloud
//
//  Created by gjh on 16/11/7.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  gjh
 Date：   2016-11-7
 Version: 1.0
 Description: 使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import <UIKit/UIKit.h>

@interface UIView (CircularBead)


- (void)dr_cornerWithRadius:(CGFloat)radius backgroundColor:(UIColor *)bgColor;

- (void)dr_topCornerWithRadius:(CGFloat)radius backgroundColor:(UIColor *)bgColor;

- (void)dr_bottomCornerWithRadius:(CGFloat)radius backgroundColor:(UIColor *)bgColor;
/**
 *  @brief             圆角化视图并对圆角部分进行描边
 *
 *  @param radius      圆角的半径
 *  @param bgColor     父视图的背景色
 *  @param borderColor 描边的颜色
 */
- (void)dr_cornerWithRadius:(CGFloat)radius backgroundColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor;

- (void)removeDRCorner;

- (BOOL)hasDRCornered;

@end
