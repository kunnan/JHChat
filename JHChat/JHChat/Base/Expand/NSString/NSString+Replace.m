//
//  NSString+Replace.m
//  LeadingCloud
//
//  Created by wchMac on 2016/11/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "NSString+Replace.h"
#import "NSString+IsNullOrEmpty.h"

@implementation NSString (Replace)

-(NSString *)stringByReplacingIGNOREOccurrencesOfString:(NSString *)forReplace withString:(NSString *)toRelace{
   if([NSString isNullOrEmpty:toRelace]){
      toRelace = @"";
   }
   
    NSMutableString *afterReplace = [NSMutableString stringWithString:self];
    NSRange range = [[afterReplace lowercaseString]rangeOfString:forReplace];
    if (range.location != NSNotFound) {
        [afterReplace replaceCharactersInRange:range withString:toRelace];
    }
    return afterReplace;
}


// 截取字符串方法封装
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString{
    
    NSRange startRange = [self rangeOfString:startString];
    NSRange endRange = [self rangeOfString:endString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [self substringWithRange:range];
    
}

@end
