//
//  UIColor+NStringTrunRGB.m
//  LeadingCloud
//
//  Created by dfl on 16/10/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "UIColor+NSStringTrunRGB.h"

@implementation UIColor (NSStringTrunRGB)

+(UIColor *)NSStringTrunRGB:(NSString *)stringColor{
    NSRange range;
    range.location = 1;
    range.length = 2;
    NSString *rString = [stringColor substringWithRange:range];
    
    range.location = 3;
    NSString *gString = [stringColor substringWithRange:range];
    
    range.location = 5;
    NSString *bString = [stringColor substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //NSLog(@"r = %u, g = %u, b = %u",r, g, b);
    UIColor *color  = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    
    return color;
}




@end
