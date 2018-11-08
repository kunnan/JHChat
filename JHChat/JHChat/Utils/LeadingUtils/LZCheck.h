//
//  LZCheck.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/24.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-24
 Version: 1.0
 Description: 检验类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface LZCheck : NSObject

/**
 *  判断是否为数值型
 *
 *  @param number 验证的数据
 *
 *  @return 是否数值
 */
+(BOOL)IsNumber:(id)number;

@end
