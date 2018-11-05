//
//  NSMutableDictionary+DicObjectForKey.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/27.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "NSMutableDictionary+DicObjectForKey.h"
#import "NSString+IsNullOrEmpty.h"

@implementation NSMutableDictionary (DicObjectForKey)

/**
 *  不可变字典
 */
-(NSDictionary *)lzNSDictonaryForKey:(NSString *)key{
    id data = [self objectForKey:key];
    if([data isKindOfClass:[NSDictionary class]]) {
        return data;
    }
    return [[NSDictionary alloc] init];
}

/**
 *  可变字典
 */
-(NSMutableDictionary *)lzNSMutableDictionaryForKey:(NSString *)key{
    id data = [self objectForKey:key];
    if([data isKindOfClass:[NSDictionary class]]) {
        return [[NSMutableDictionary alloc] initWithDictionary:data];
    }
    return [[NSMutableDictionary alloc] init];
}

/**
 *  不可变数组
 */
-(NSArray *)lzNSArrayForKey:(NSString *)key{
    id data = [self objectForKey:key];
    if([data isKindOfClass:[NSArray class]]) {
        return data;
    }
    return [[NSArray alloc] init];
}

/**
 *  可变数组
 */
-(NSMutableArray *)lzNSMutableArrayForKey:(NSString *)key{
    id data = [self objectForKey:key];
    if([data isKindOfClass:[NSArray class]]) {        
        return [NSMutableArray arrayWithArray:data];
    }
    return [[NSMutableArray alloc] init];
}

/**
 *  字符串
 */
-(NSString *)lzNSStringForKey:(NSString *)key{
    id data = [self objectForKey:key];
    if([data isKindOfClass:[NSString class]]) {
        if([NSString isNullOrEmpty:((NSString *)data)]){
            return @"";
        }
        return data;
    }
    return @"";
}

/**
 *  数值型
 */
-(NSNumber *)lzNSNumberForKey:(NSString *)key{
    id data = [self objectForKey:key];
    if([data isKindOfClass:[NSNumber class]]) {
        return data;
    }
    return [NSNumber numberWithInteger:0];
}

@end
