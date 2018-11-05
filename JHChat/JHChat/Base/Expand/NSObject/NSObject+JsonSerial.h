//
//  NSObject+JsonSerial.h
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

#import <Foundation/Foundation.h>

@interface NSObject (JsonSerial)

- (void)serialization:(NSString*)json;

- (void)serializationWithDictionary:(NSDictionary*)dictionary;

- (void)convert:(NSDictionary*)dataSource;

- (NSArray*)propertyKeys;
//model转字典
-(NSMutableDictionary *)convertModelToDictionary;

- (NSString*)dictionaryToJson:(NSDictionary *)dic;
//把多个json字符串转为一个json字符串
// 数组转json
- (NSString *)objArrayToJSON:(NSArray *)array;
// 模型转字典
- (NSMutableDictionary *)createDictionayFromModelProperties;

@end
