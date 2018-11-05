  /************************************************************
 Author:  lz-fzj
 Date：   2015-12-26
 Version: 1.0
 Description: 【字符串】-【尺寸大小】扩展
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "NSString+CGSize.h"

/**
 *  【字符串】-【尺寸大小】扩展
 */
@implementation NSString (CGSize)
/**
 *  计算当前字符串的尺寸大小
 *  @param maxSize  最大的尺寸大小
 *  @param font           计算大小时用到的字体
 *  @return                    尺寸大小
 */
-(CGSize)sizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font{
    CGRect tmpRect=[self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return tmpRect.size;
}


- (CGSize) sizeForFont:(UIFont*)font
     constrainedToSize:(CGSize)constraint
         lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size;
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary *attributes = @{NSFontAttributeName:font};
        
        CGSize boundingBox = [self boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }
    else
    {
        size = [self sizeWithFont:font constrainedToSize:constraint lineBreakMode:lineBreakMode];
    }
    
    return size;
}

@end
