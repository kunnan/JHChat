//
//  NSDictionaryStatic.m
//  LeadingCloud
//
//  Created by wchMac on 16/10/14.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "NSDictionaryStatic.h"

@implementation NSDictionaryStatic

+(NSDictionary *)removeUnabelKey:(NSDictionary *)dic{
    
    /* 遍历字典中的值 */
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        for (NSString *key in [mutableDic allKeys]) {
            id obj = [mutableDic objectForKey:key];
            
            if ([obj isKindOfClass:[NSString class]] ||
                [obj isKindOfClass:[NSArray class]] ||
                [obj isKindOfClass:[NSURL class]] ||
                [obj isKindOfClass:[NSNumber class]]) {
                
            }
            /* 如果内部还是字典，递归调用 */
            else if ([obj isKindOfClass:[NSDictionary class]]) {
                [mutableDic setObject:[NSDictionaryStatic removeUnabelKey:obj] forKey:key];
            } else {
                [mutableDic removeObjectForKey:key];
            }
        }
        
        return mutableDic;
    }
    
    
    else {
        return dic;
    }
}

+(NSDictionary *)removeUnabelKeyForSessionStory:(NSDictionary *)dic{
    /* 遍历字典中的值 */
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        for (NSString *key in [mutableDic allKeys]) {
            id obj = [mutableDic objectForKey:key];
            
            if ([obj isKindOfClass:[NSArray class]] ||
                [obj isKindOfClass:[NSData class]] ||
                [obj isKindOfClass:[NSURL class]] ||
                [obj isKindOfClass:[NSNumber class]]) {
                
            }
            else if ([obj isKindOfClass:[NSString class]]) {
                NSString *val = [mutableDic lzNSStringForKey:key];
                val = [val stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                [mutableDic setObject:val forKey:key];
            }
            /* 如果内部还是字典，递归调用 */
            else if ([obj isKindOfClass:[NSDictionary class]]) {
                [mutableDic setObject:[NSDictionaryStatic removeUnabelKey:obj] forKey:key];
            } else {
                [mutableDic removeObjectForKey:key];
            }
        }
        
        return mutableDic;
    } else {
        return dic;
    }
}

@end
