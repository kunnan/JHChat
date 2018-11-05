//
//  NSDictionary+DicSerial.h
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

#import <Foundation/Foundation.h>

@interface NSDictionary (DicSerial)

/**
 *  转换为字符串
 *
 *  @return 字符串
 */
-(NSString *)dicSerial;

///**
// *  转换为字符串（可注册到sessionStory中）
// *
// *  @return 字符串
// */
//-(NSString *)dicSerialForSessionStory;

@end
