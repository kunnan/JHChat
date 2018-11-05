//
//  NSObject+JsonSerial.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/31.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-04
 Version: 1.0
 Description: Json反序列化为对象
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "NSObject+JsonSerial.h"
#import <objc/runtime.h>
#import "NSString+IsNullOrEmpty.h"
#import "NSDictionaryStatic.h"

@implementation NSObject (JsonSerial)

- (void)serialization:(NSString*)json
{
    if(json == nil){
        return;
    }
    
    NSDictionary *dataSource = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:nil];
    [self convert:dataSource];
}

- (void)serializationWithDictionary:(NSDictionary*)dictionary
{
    [self convert:dictionary];
}

- (void)convert:(NSDictionary*)dataSource
{
    for (NSString *key in [dataSource allKeys]) {
        if ([[self propertyKeys] containsObject:key]) {
            id propertyValue = [dataSource valueForKey:key];
            if (![propertyValue isKindOfClass:[NSNull class]]
                && propertyValue != nil) {
                [self setValue:propertyValue
                        forKey:key];
            }
        }
    }
}

- (NSArray*)propertyKeys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *propertys = [NSMutableArray arrayWithCapacity:outCount];
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [propertys addObject:propertyName];
    }
    free(properties);
    return propertys;
}


/**
 模型转字典
 */
-(NSMutableDictionary *)convertModelToDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in [self propertyKeys]) {
        id propertyValue = [self valueForKey:key];
        //该值不为NSNULL，并且也不为nil
        if(propertyValue!=nil){
            [dic setObject:propertyValue forKey:key];
        } else {
            [dic setObject:@"" forKey:key];
        }
    }
    return dic;
}

- (NSString*)dictionaryToJson:(NSMutableDictionary *)dic
{
    if (!dic) {
        
        dic=[[NSMutableDictionary alloc] init];
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        
        if ([dic isKindOfClass:[NSString class]]) {
            NSString *dict=[NSString stringWithFormat:@"%@",dic];

            return dict;
        }
    }
    
//    /* 遍历字典中的值 */
//    if ([dic isKindOfClass:[NSMutableDictionary class]]) {
//        
//        for (NSString *key in [dic allKeys]) {
//            id obj = [dic objectForKey:key];
//            
//            if ([obj isKindOfClass:[NSString class]] ||
//                [obj isKindOfClass:[NSArray class]] ||
//                [obj isKindOfClass:[NSData class]] ||
//                [obj isKindOfClass:[NSURL class]] ||
//                [obj isKindOfClass:[NSNumber class]]) {
//                dic = dic;
//            }
//            /* 如果内部还是字典，递归调用 */
//            else if ([obj isKindOfClass:[NSDictionary class]]) {
//                [self dictionaryToJson:obj];
//            } else {
//                [dic removeObjectForKey:key];
//            }
//        }
//    }
    /* 如果内部还是字典，递归调用 */
    NSDictionary *dicRmove = [NSDictionaryStatic removeUnabelKey:dic];
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicRmove options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//把多个json字符串转为一个json字符串

- (NSString *)objArrayToJSON:(NSArray *)array {

    NSString *jsonStr = @"[";

    for (NSInteger i = 0; i < array.count; ++i) {
        
        if (i != 0) {
            
            jsonStr = [jsonStr stringByAppendingString:@","];
            
        }
        NSString *tmpstr = @"";
        if ([array[i] isKindOfClass:[NSDictionary class]]) {
            tmpstr = [tmpstr dictionaryToJson:array[i]];
        } else if ([array[i] isKindOfClass:[NSArray class]]) {
            tmpstr = [tmpstr objArrayToJSON:array[i]];
        } else if ([array[i] isKindOfClass:[NSString class]]) {
            tmpstr = array[i];
        } else {
            tmpstr = [array[i] stringValue];
        }
        
        jsonStr = [jsonStr stringByAppendingString:tmpstr];
        
    }
    
    jsonStr = [jsonStr stringByAppendingString:@"]"];

    return jsonStr;

}

- (NSMutableDictionary *)createDictionayFromModelProperties
{
    NSMutableDictionary *propsDic = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    // class:获取哪个类的成员属性列表
    // count:成员属性总数
    // 拷贝属性列表
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        // 属性名
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        // 属性值
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        // 设置KeyValues
        if (propertyValue) [propsDic setObject:propertyValue forKey:propertyName];
    }
    // 需手动释放 不受ARC约束
    free(properties);
    return propsDic;
}


@end
