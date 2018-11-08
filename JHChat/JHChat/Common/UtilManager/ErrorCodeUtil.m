//
//  ErrorCodeUtil.m
//  LeadingCloud
//
//  Created by gjh on 16/5/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "ErrorCodeUtil.h"

@implementation ErrorCodeUtil

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ErrorCodeUtil *)shareInstance{
    static ErrorCodeUtil *instance = nil;
    if (instance == nil) {
        instance = [[ErrorCodeUtil alloc] init];
        [instance initErrorCodeData];
    }
    return instance;
}

/**
 *  初始化ErrorCode数据
 */
-(void)initErrorCodeData{
    
    _errorCodeDic = [[NSMutableDictionary alloc] init];
    
    NSString *plistPath =  [[NSBundle mainBundle] pathForResource:@"ErrorCode" ofType:@"plist"];
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    for (NSString *firstKey in [mutableDic allKeys]) {
        NSDictionary *obj = [mutableDic objectForKey:firstKey];
        
        for (NSString *secondKey in [obj allKeys]) {
            NSString *value = [obj objectForKey:secondKey];
            
            [_errorCodeDic setObject:value forKey:secondKey];
        }
    }
    
}

/**
 *  从ErrorCode得到Message内容
 *
 *  @param errorCode 字典
 *
 *  @return 消息内容
 */
-(NSString *)getMessageFromErrorCode:(NSDictionary *) errorCode {
    
    NSString *str = @"";
    if ([[_errorCodeDic allKeys] containsObject:[errorCode objectForKey:@"Code"]]) {
        str = [_errorCodeDic objectForKey:[errorCode objectForKey:@"Code"]];
    } else {
        str = [errorCode objectForKey:@"Message"];
    }
    
    return [str copy];
}
@end
