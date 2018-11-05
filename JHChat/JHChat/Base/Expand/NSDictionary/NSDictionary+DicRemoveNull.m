//
//  NSDictionary+DicRemoveNull.m
//  LeadingCloud
//
//  Created by gjh on 16/4/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  gjh
 Date：   2016-04-20
 Version: 1.0
 Description: 去掉json返回字典中的<null>值
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "NSDictionary+DicRemoveNull.h"

@implementation NSDictionary (DicRemoveNull)

+ (id) removeJsonNullFromDic:(id)obj {
    // obj类型是字典类型
    if ([obj isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *mutableDic = [(NSMutableDictionary *)obj mutableCopy];
        
        for (NSString *key in [mutableDic allKeys]) {
            
            id object = [mutableDic objectForKey:key]; //通过遍历所有的key值，获取到每一个value
            if ([object isKindOfClass:[NSNull class]]) {
                
                [mutableDic removeObjectForKey:key]; //删除值类型为NSNull的值
                
            } else if ([object isKindOfClass:[NSArray class]]) {
                
                NSArray *arr = (NSArray *)object;
                object = [self removeJsonNullFromDic:arr]; // 如果类型为数组类型，然后调用递归，判断自己下面的类型是否还有字典类型，直到最底层为NSString或NSNull
                [mutableDic setObject:object forKey:key]; //将这个key位置的字典元素置换成删除<null>后的
                
            } else if ([object isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dic = (NSDictionary *)object;
                object = [self removeJsonNullFromDic:dic]; //如果类型还是为字典类型，调用递归继续判断
                [mutableDic setObject:object forKey:key]; //将这个key位置的字典元素置换成删除<null>后的

            }
        }
        return [mutableDic copy];
        
    } else if ([obj isKindOfClass:[NSArray class]]) { // obj类型是数组类型
        
        NSMutableArray *mutableArr = [(NSMutableArray *)obj mutableCopy];
        for (int i = 0; i<[mutableArr count]; i++) {
            
            NSDictionary *dict = [obj objectAtIndex:i];
            dict = [self removeJsonNullFromDic:dict];
            [mutableArr replaceObjectAtIndex:i withObject:dict];// 将去掉<null>键值对的字典换掉原来的数组元素
            
        }
        return [mutableArr copy];
    }
    return obj;
}

@end
