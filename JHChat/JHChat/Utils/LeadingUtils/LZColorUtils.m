//
//  LZColorUtils.m
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
#import "LZColorUtils.h"
#import "UIColor+NSStringTrunRGB.h"

@implementation LZColorUtils

/**
 *  根据传进来的数字返回一个颜色
 *
 */
+ (UIColor *)getColorByNumber:(NSString *)number {
    
    UIColor *colorValue = nil;
    switch ([number intValue]) {
        case 0:
            colorValue = UIColorWithRGBA(99, 182, 172, 1);
            break;
        case 1:
            colorValue = UIColorWithRGBA(14, 129, 209, 1);
            break;
        case 2:
            colorValue = UIColorWithRGBA(6, 171, 138, 1);
            break;
        case 3:
            colorValue = UIColorWithRGBA(228, 70, 84, 1);
            break;
        case 4:
            colorValue = UIColorWithRGBA(223, 140, 10, 1);
            break;
        case 5:
            colorValue = UIColorWithRGBA(152, 92, 216, 1);
            break;
        case 6:
            colorValue = UIColorWithRGBA(238, 199, 42, 1);
            break;
        case 7:
            colorValue = UIColorWithRGBA(94, 151, 194, 1);
            break;
        case 8:
            colorValue = UIColorWithRGBA(184, 80, 133, 1);
            break;
        case 9:
            colorValue = UIColorWithRGBA(245, 93, 88, 1);
            break;
            
        default:
            break;
    }
    
    return colorValue;
}


+ (UIColor *)getAppColorKey:(NSString*)key{
    
    
    
    NSDictionary *colorDic = [NSDictionary dictionaryWithObjectsAndKeys:@"#279bf1",@"color-1",@"#00b88c",@"color-2",@"#9277ce",@"color-3",@"#f99e49",@"color-4",@"#f65466",@"color-5",@"#8fbe35",@"color-6",@"#3abaf0",@"color-7",@"#f2c53a",@"color-8",@"#6a75e6",@"color-9",@"#46cdd6",@"color-10",@"#F99E49",@"bg-org",@"#6AB556",@"bg-green",@"#EE4B47",@"bg-red", nil];
    
    NSString *colorValue = [colorDic lzNSStringForKey:key];
    
    
    if ([colorValue length]>2) {
        
    }else{
        colorValue = @"#279bf1";
    }
    
    return [UIColor NSStringTrunRGB:colorValue];
}
@end
