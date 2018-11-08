//
//  LZImageUtils.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-19
 Version: 1.0
 Description: 图片处理工具类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LZImageUtils : NSObject

/**
 *  压缩图片
 *
 *  @param image  图片
 *  @param width  宽度
 *  @param height 高度
 *
 *  @return 压缩后的图片
 */
+ (UIImage *)ScaleImage:(UIImage *)image width:(float)width height:(float)height;

/**
 *  缩放为指定的宽和高
 */
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

/**
 *  为图片纠正方向
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 *  根据原图尺寸计算小图尺寸
 *
 *  @param oriSize 原图大小
 *  @param targetSize  最大值
 *  @param minSize  最小值
 *
 *  @return 缩小后的尺寸
 */
+(CGSize)CalculateSmalSize:(CGSize)oriSize maxSize:(float)maxSize minSize:(float)minSize;



@end
