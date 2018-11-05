/************************************************************
 Author:  lz-fzj
 Date：   2015-12-22
 Version: 1.0
 Description: 【字符串】-【是否为空】扩展
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "NSString+IsNullOrEmpty.h"

@implementation NSString (IsNullOrEmpty)

/**
 *  给定的字符串是否是nil或者空字符串
 *  @param str
 *  @return
 */
+(BOOL)isNullOrEmpty:(NSString *)str{
    id tmpValue=str;
    if([NSNull null]==tmpValue) return YES;    
    if(![str isKindOfClass:[NSString class]]) return YES;
    if(str==nil)return YES;
    if([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) return YES;
    return [@"" isEqualToString:str];
}

/**
 *  将空或者nil字符串转为空字符串，非空不处理
 *  @param str
 *  @return
 */
+(NSString *)null2Empty:(NSString *)str{
    if([NSString isNullOrEmpty:str]) return @"";
    return str;
}

@end
