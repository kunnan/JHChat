//
//  CommonFontModel.h
//  LeadingCloud
//
//  Created by wang on 17/2/23.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFontModel : NSObject


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CommonFontModel *)shareInstance;



/**
 字体大小是否发生改变

 @param font 字体

 @return
 */
- (BOOL)isChangeSystemFont:(NSString*)font;


/**
 得到处理高度系数
 */
- (CGFloat)getHandeHeightRatio;
/**
 得到处理字体系数
 */
- (CGFloat)getHandeFontRatio;
/**
 得到处理高度
 */
- (CGFloat)getHandleHeightFromSystemFont:(CGFloat)height;
/**
 得到处理字体大小
 */
- (CGFloat)getHandleFontFromSystemFont:(CGFloat)font;

- (NSInteger)getLocationFont:(NSString*)font;

- (void)setSystenFont:(NSString*)font;

- (CGFloat)getScale:(NSString*)category;
- (NSString*)getFontStirng;
- (NSString*)getTempFontStirng;


- (void)setChangeSystenFont:(NSInteger)font isTempt:(BOOL)isTempt;
- (CGFloat)getHandleTempFontFromSystemFont:(CGFloat)font;

/**
 改变原有label字体大小

 @param label void
 */
-(void)changeFontWithLabel:(UILabel*)label;
@end
