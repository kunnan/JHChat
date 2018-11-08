//
//  LZColorUtils.h
//  LeadingCloud
//
//  Created by gjh on 16/8/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  gjh
 Date：   2016-08-09
 Version: 1.0
 Description: 根据传进来的数字返回不同的颜色
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import <Foundation/Foundation.h>

@interface LZColorUtils : NSObject

/**
 *  根据传进来的数字返回一个颜色
 *
 */
+ (UIColor *)getColorByNumber:(NSString *)number;

+ (UIColor *)getAppColorKey:(NSString*)key;


@end
