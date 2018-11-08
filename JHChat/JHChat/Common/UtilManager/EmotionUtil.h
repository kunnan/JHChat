//
//  EmotionUtil.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/7.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-07
 Version: 1.0
 Description: 表情管理类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface EmotionUtil : NSObject

/**
 *  读取表情名称——描述
 *
 *  @return key:名称 value:描述
 */
+(NSDictionary *)getImageNameToDescription;

/**
 *  读取表情描述——名称
 *
 *  @return key:描述 value:名称
 */
+(NSDictionary *)getDescriptionToImageName;

@end
