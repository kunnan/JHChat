//
//  UIImage+GaussianBlur.h
//  LeadingCloud
//
//  Created by dfl on 16/12/12.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//高斯模糊  毛玻璃

#import <UIKit/UIKit.h>


@interface UIImage (GaussianBlur)


/**
 高斯模糊
 
 @param image 原图
 @param blur  模糊率
 
 @return 模糊后的图片
 */
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
