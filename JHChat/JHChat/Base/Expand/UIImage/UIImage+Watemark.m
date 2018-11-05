//
//  UIImage+Watemark.m
//  LeadingCloud
//
//  Created by gjh on 2017/11/28.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "UIImage+Watemark.h"
#import "GPUImage.h"

@implementation UIImage (Watemark)

/**
 * 加文字随意
 @param logoImage 需要加文字的图片
 @param watemarkText 文字描述
 @returns 加好文字的图片
 */
+ (UIImage *)addWatemarkTextAfteriOS7_WithLogoImage:(UIImage *)logoImage
                                   watemarkTextDate:(NSString *)watemarkTextDate
                                   watemarkTextWeather:(NSString *)watemarkTextWeather
                                   watemarkTextLocation:(NSString *)watemarkTextLocation {
    int w = logoImage.size.width;
    int h = logoImage.size.height;
    UIGraphicsBeginImageContext(logoImage.size);
    [[UIColor whiteColor] set];
    [logoImage drawInRect:CGRectMake(0, 0, w, h)];
    UIFont *font = [UIFont systemFontOfSize:30.0];
    
    CGSize dateSize = [watemarkTextDate sizeWithMaxSize:CGSizeMake(300, 30) font:font];
    CGSize weatherSize = [watemarkTextWeather sizeWithMaxSize:CGSizeMake(100, 30) font:font];
    CGSize locationSize = [watemarkTextLocation sizeWithMaxSize:CGSizeMake(500, 30) font:font];
    
    [watemarkTextDate drawInRect:CGRectMake(30, h - 100.0, dateSize.width, dateSize.height)
              withAttributes:@{NSFontAttributeName: font,
                               NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [watemarkTextWeather drawInRect:CGRectMake(30, h - 60.0, weatherSize.width, weatherSize.height)
              withAttributes:@{NSFontAttributeName: font,
                               NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [watemarkTextLocation drawInRect:CGRectMake(30+weatherSize.width, h - 60.0, locationSize.width, locationSize.height)
              withAttributes:@{NSFontAttributeName: font,
                               NSForegroundColorAttributeName: [UIColor whiteColor]}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 * 加图片水印
 @param logoImage 需要加水印的logo图片
 @param watemarkImage 水印图片
 @returns 加好水印的图片
 */
+ (UIImage *)addWatemarkImageWithLogoImage:(UIImage *)logoImage
                             watemarkImage:(UIImage *)watemarkImage
//                             logoImageRect:(CGRect)logoImageRect
                         watemarkImageRect:(CGRect)watemarkImageRect {
    // 创建一个graphics context来画我们的东西
    UIGraphicsBeginImageContext(logoImage.size);
    // graphics context就像一张能让我们画上任何东西的纸。我们要做的第一件事就是把person画上去
    [logoImage drawInRect:CGRectMake(0, 0, logoImage.size.width, logoImage.size.height)];
    // 然后在把hat画在合适的位置
    [watemarkImage drawInRect:CGRectMake(watemarkImageRect.origin.x,
                                         watemarkImageRect.origin.y,
                                         watemarkImageRect.size.width,
                                         watemarkImageRect.size.height)];
    // 通过下面的语句创建新的UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 最后，我们必须得清理并关闭这个再也不需要的context
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 * 加半透明水印
 @param logoImage 需要加水印的图片
 @param translucentWatemarkImage 水印
 @returns 加好水印的图片
 */
+ (UIImage *)addWatemarkImageWithLogoImage:(UIImage *)logoImage
                  translucentWatemarkImage:(UIImage *)translucentWatemarkImage {
    UIGraphicsBeginImageContext(logoImage.size);
    [logoImage drawInRect:CGRectMake(0, 0, logoImage.size.width, logoImage.size.height)];
    // 四个参数为水印的位置
    [translucentWatemarkImage drawInRect:CGRectMake(logoImage.size.width - translucentWatemarkImage.size.width*1.5-30,
                                                    logoImage.size.height- translucentWatemarkImage.size.height*1.5 - 25,
                                                    translucentWatemarkImage.size.width*1.5,
                                                    translucentWatemarkImage.size.height*1.5)];
    UIImage * resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
