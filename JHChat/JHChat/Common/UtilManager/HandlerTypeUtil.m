//
//  HandlerTypeUtil.m
//  LeadingCloud
//
//  Created by gjh on 16/5/10.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  gjh
 Date：   2016-05-10
 Version: 1.0
 Description: 从handlertype得到一二级的key工具类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "HandlerTypeUtil.h"

@implementation HandlerTypeUtil

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(HandlerTypeUtil *)shareInstance{
    static HandlerTypeUtil *instance = nil;
    if (instance == nil) {
        instance = [[HandlerTypeUtil alloc] init];
        [instance initHandlerTypeData];
    }
    return instance;
}

/**
 *  初始化HandlerType数据
 */
-(void)initHandlerTypeData{
    _handlerTypeDic = [[NSMutableDictionary alloc] init];
    
    NSString *plistPath =  [[NSBundle mainBundle] pathForResource:@"HandlerType" ofType:@"plist"];
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    for (NSString *firstKey in [mutableDic allKeys]) {
        NSDictionary *obj = [mutableDic objectForKey:firstKey];
        for (NSString *secondKey in [obj allKeys]) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:firstKey forKey:@"main"];
            [dic setObject:secondKey forKey:@"second"];
            
            NSArray *value = [obj objectForKey:secondKey];
            for (NSString *str in value) {
                [_handlerTypeDic setObject:dic forKey:str];
//                if ([str isEqualToString:HTStr]) {
//                    
//                    [dic setObject:firstKey forKey:@"firstkey"];
//                    [dic setObject:secondKey forKey:@"secondkey"];
//                    break;
//                }
            }
        }
    }
}

/**
 *  获取第一级名称
 *
 *  @param handlerType 处理类型
 *
 *  @return 第一级名称
 */
-(NSString *)getMainModel:(NSString *) handlerType{
    if([handlerType hasPrefix:Handler_Message_LZChat_LZTemplateMsg_BSform]){
        handlerType = Handler_Message_LZChat_LZTemplateMsg_BSform;
    }
    
    if([handlerType hasPrefix:Handler_Message_LZChat_SR]){
        handlerType = Handler_Message_LZChat_SR;
    }
    
    if([[_handlerTypeDic allKeys] containsObject:handlerType]){
        NSMutableDictionary *dic = [_handlerTypeDic objectForKey:handlerType];
        return [dic objectForKey:@"main"];
    }
    return @"";
}

/**
 *  获取第二级名称
 *
 *  @param handlerType 处理类型
 *
 *  @return 第二级名称
 */
-(NSString *)getSecondModel:(NSString *) handlerType{
    if([handlerType hasPrefix:Handler_Message_LZChat_LZTemplateMsg_BSform]){
        handlerType = Handler_Message_LZChat_LZTemplateMsg_BSform;
    }
    
    if([handlerType hasPrefix:Handler_Message_LZChat_SR]){
        handlerType = Handler_Message_LZChat_SR;
    }
    
    if([[_handlerTypeDic allKeys] containsObject:handlerType]){
        NSMutableDictionary *dic = [_handlerTypeDic objectForKey:handlerType];
        return [dic objectForKey:@"second"];
    }
    return @"";
}

/**
 *  从handlertype得到一二级的key
 *
 *  @param HTStr handlertype字符串
 *
 *  @return 一二级组成的字典
 */
+ (NSDictionary *) getFirAndSecFromHandlerType:(NSString *) HTStr {
    
    NSString *plistPath =  [[NSBundle mainBundle] pathForResource:@"HandlerType" ofType:@"plist"];
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"plist文件的内容：%@",mutableDic);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSString *firstKey in [mutableDic allKeys]) {
        NSDictionary *obj = [mutableDic objectForKey:firstKey];
        for (NSString *secondKey in [obj allKeys]) {
            NSArray *value = [obj objectForKey:secondKey];
            for (NSString *str in value) {
                if ([str isEqualToString:HTStr]) {
                    
                    [dic setObject:firstKey forKey:@"firstkey"];
                    [dic setObject:secondKey forKey:@"secondkey"];
                    break;
                }
            }
        }
    }
    
    return [dic copy];
}

@end
