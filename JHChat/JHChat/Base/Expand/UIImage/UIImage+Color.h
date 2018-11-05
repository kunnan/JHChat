//
//  UIImage+Color.h
//  LeadingCloud
//
//  Created by gjh on 16/8/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
//改变图片颜色
- (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor size:(CGSize)size;
+ (UIImage*)setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect;


+ (UIImage*) replaceColor:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance;

//resizing Stuff...
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
