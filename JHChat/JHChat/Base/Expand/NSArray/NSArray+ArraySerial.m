//
//  NSArray+ArraySerial.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-04
 Version: 1.0
 Description: 字典或数组序列化为字符串
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "NSArray+ArraySerial.h"

@implementation NSArray (ArraySerial)

/**
 *  转换为字符串
 *
 *  @return 字符串
 */
-(NSString *)arraySerial{
    NSData *postDatas = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:postDatas encoding:NSUTF8StringEncoding];
    return str;
}

@end
