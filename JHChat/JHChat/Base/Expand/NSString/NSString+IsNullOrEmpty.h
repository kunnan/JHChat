/************************************************************
 Author:  lz-fzj
 Date：   2015-12-22
 Version: 1.0
 Description: 【字符串】-【是否为空】扩展
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface NSString (IsNullOrEmpty)

/**
 *  给定的字符串是否是nil或者空字符串
 *  @param str
 *  @return
 */
+(BOOL)isNullOrEmpty:(NSString *)str;

/**
 *  将空或者nil字符串转为空字符串，非空不处理
 *  @param str
 *  @return
 */
+(NSString *)null2Empty:(NSString *)str;

@end
