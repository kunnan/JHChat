//
//  UIImage+Rotation.h
//  LeadingCloud
//
//  Created by lz on 16/3/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-03-17
 Version: 1.0
 Description: 【Image扩展方法】-【image旋转类】
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <UIKit/UIKit.h>

@interface UIImage (Rotation)

/**
 *  UIImage自定义旋转
 *
 *  @param image       图片
 *  @param orientation 旋转方向
 *
 */
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

//- (void)imageAnimation:(UIButton *)image;
//
//- (void)counterclockwiseAnimation:(UIButton *)image;

+ (UIImage *)fixOrientation:(UIImage *)image;

@end
