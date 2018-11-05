//
//  NSMutableDictionary+DicObjectForKey.h
//  LeadingCloud
//
//  Created by wchMac on 16/5/27.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (DicObjectForKey)

/**
 *  不可变字典
 */
-(NSDictionary *)lzNSDictonaryForKey:(NSString *)key;

/**
 *  可变字典
 */
-(NSMutableDictionary *)lzNSMutableDictionaryForKey:(NSString *)key;

/**
 *  不可变数组
 */
-(NSArray *)lzNSArrayForKey:(NSString *)key;

/**
 *  可变数组
 */
-(NSMutableArray *)lzNSMutableArrayForKey:(NSString *)key;

/**
 *  字符串
 */
-(NSString *)lzNSStringForKey:(NSString *)key;

/**
 *  数值型
 */
-(NSNumber *)lzNSNumberForKey:(NSString *)key;

@end
