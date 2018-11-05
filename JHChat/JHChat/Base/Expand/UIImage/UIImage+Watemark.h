//
//  UIImage+Watemark.h
//  LeadingCloud
//
//  Created by gjh on 2017/11/28.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+CGSize.h"

@interface UIImage (Watemark)

/**
 * 加文字随意
 @param logoImage 需要加文字的图片
 @param watemarkText 文字描述
 @returns 加好文字的图片
 */
+ (UIImage *)addWatemarkTextAfteriOS7_WithLogoImage:(UIImage *)logoImage
                                   watemarkTextDate:(NSString *)watemarkTextDate
                                watemarkTextWeather:(NSString *)watemarkTextWeather
                               watemarkTextLocation:(NSString *)watemarkTextLocation;

/**
 * 加图片水印
 @param logoImage 需要加水印的logo图片
 @param watemarkImage 水印图片
 @returns 加好水印的图片
 */
+ (UIImage *)addWatemarkImageWithLogoImage:(UIImage *)logoImage
                             watemarkImage:(UIImage *)watemarkImage
//                             logoImageRect:(CGRect)logoImageRect
                         watemarkImageRect:(CGRect)watemarkImageRect;

/**
 * 加半透明水印
 @param logoImage 需要加水印的图片
 @param translucentWatemarkImage 水印
 @returns 加好水印的图片
 */
+ (UIImage *)addWatemarkImageWithLogoImage:(UIImage *)logoImage
                  translucentWatemarkImage:(UIImage *)translucentWatemarkImage;


@end
