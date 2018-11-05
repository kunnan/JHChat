//
//  NSDictionary+DicSerial.m
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

#import "NSDictionary+DicSerial.h"
#import "NSDictionaryStatic.h"

@implementation NSDictionary (DicSerial)

/**
 *  转换为字符串
 *
 *  @return 字符串
 */
-(NSString *)dicSerial{
    
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:self];

    /* 如果内部还是字典，递归调用 */
    NSDictionary *dic = [NSDictionaryStatic removeUnabelKey:mutableDic];
    
    NSData *postDatas = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:postDatas encoding:NSUTF8StringEncoding];
    return str;
}


///**
// *  转换为字符串（可注册到sessionStory中）
// *
// *  @return 字符串
// */
//-(NSString *)dicSerialForSessionStory{
//    
//    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:self];
//    
//    /* 如果内部还是字典，递归调用 */
//    NSDictionary *dic = [NSDictionaryStatic removeUnabelKeyForSessionStory:mutableDic];
//    
//    NSData *postDatas = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *str = [[NSString alloc] initWithData:postDatas encoding:NSUTF8StringEncoding];
//    return str;
//}




@end
