/************************************************************
 Author:  lz-fzj
 Date：   2015-12-26
 Version: 1.0
 Description: 【字符串】-【尺寸大小】扩展
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <UIKit/UIKit.h>

/**
 *  【字符串】-【尺寸大小】扩展
 */
@interface NSString (CGSize)

/**
 *  计算当前字符串的尺寸大小
 *  @param maxSize  最大的尺寸大小
 *  @param font           计算大小时用到的字体
 *  @return                    尺寸大小
 */
-(CGSize)sizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font;


- (CGSize) sizeForFont:(UIFont*)font
     constrainedToSize:(CGSize)constraint
         lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end
