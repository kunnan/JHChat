//
//  EmotionUtil.m
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

#import "EmotionUtil.h"

@implementation EmotionUtil

/**
 *  读取表情名称——描述
 *
 *  @return key:名称 value:描述
 */
+(NSDictionary *)getImageNameToDescription{
    static NSDictionary *dicForImageNameToDescription = nil;
    if (dicForImageNameToDescription == nil) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FaceDescription" ofType:@"plist"];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        //将表情描述信息读入字典
        dicForImageNameToDescription = [dictionary objectForKey: @"ImageNameToDescription"];
    }
    return dicForImageNameToDescription;
}

/**
 *  读取表情描述——名称
 *
 *  @return key:描述 value:名称
 */
+(NSDictionary *)getDescriptionToImageName{
    static NSDictionary *dicForDescriptionToImageName = nil;
    if (dicForDescriptionToImageName == nil) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FaceDescription" ofType:@"plist"];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        //将表情描述信息读入字典
        dicForDescriptionToImageName = [dictionary objectForKey: @"DescriptionToImageName"];
    }
    return dicForDescriptionToImageName;
}

@end
