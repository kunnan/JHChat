//
//  CooperationToolObject.h
//  LeadingCloud
//
//  Created by wang on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CooperationToolObject : NSObject

//颜色
+(UIColor*)creatColorRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b;
//尺寸
+(CGSize)sizeWithLabelFont:(UIFont*)font Text:(NSString *)text Size:(CGSize)size;
//得到一根线
+(UIView*)getLineViewFrame:(CGRect)frame;

//将颜色转成图片
+(UIImage*) createImageWithColor:(UIColor*) color;
@end
