//
//  RegularExpressionViewModel.m
//  LeadingCloud
//
//  Created by dfl on 16/5/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-05-20
 Version: 1.0
 Description: 通用正则验证
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/


#import "RegularExpressionViewModel.h"
#import "NSString+IsNullOrEmpty.h"

@implementation RegularExpressionViewModel



/**
 *  验证手机号
 *
 *  @param mobile 手机号
 */
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSString *phoneRegex = @"^(1)\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

/**
 *  验证密码
 *
 *  @param mobile 密码
 */
+(BOOL) isValidatePwd:(NSString *)passWord
{
    NSString *pattern = @"^(?![\\d]+$)(?![a-zA-Z]+$)(?![^\\da-zA-Z]+$).{6,30}$";
    /* 密码正则配置 */
    NSString *pwdpattern = [[LZUserDataManager readAvailableDataContext] lzNSStringForKey:@"pwdpattern"];
    if(![NSString isNullOrEmpty:pwdpattern]){
        pattern = pwdpattern;
    }
//    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,30}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:passWord];
    return isMatch;
}

/**
 *  验证邮箱
 *
 *  @param email 邮箱
 */
+(BOOL) isValidateEmail:(NSString *)email
{
    
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSString *pattern = @"[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+\\.+[a-zA-Z0-9]{2,4}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:email];
    return isMatch;
}

/**
 *  验证用户注册的昵称
 *
 *  @param name 用户注册昵称
 */
+(BOOL) isValidateUserName:(NSString *)name
{
    
    NSString *pattern = @"^[\\D]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:name];
    return isMatch;
}

/**
 *  验证用户在企业下的名称
 *
 *  @param name 企业下用户名
 */
+(BOOL) isValidateEnterpriseUserName:(NSString *)name
{
    
    NSString *pattern = @"^[\\D]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:name];
    return isMatch;
}

/**
 *  得到IP地址
 *
 *  @param name ip
 */
+(NSString *) isValidateIP:(NSString *)name
{
    
    NSString *pattern = @"\\d+\\.\\d+\\.\\d+\\.\\d+";
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray* array=[regular matchesInString:name options:0 range:NSMakeRange(0, [name length])];
    NSString * string;
    for( NSTextCheckingResult * result in array){
        
        string=[name substringWithRange:result.range];
        
    }
    return string;
}

/**
 *  得到{}中的数据
 *
 *  @param name 字符串
 */
+(NSMutableArray *)isValidateQrcodeData:(NSString *)name
{
    NSString *pattern = @"\\{([^}]*?)\\}";
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray* array=[regular matchesInString:name options:0 range:NSMakeRange(0, [name length])];
//    NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
    NSMutableArray *newArr = [NSMutableArray array];
//    for (long i=reversedArray.count-1;i>=0;i--) {
//        NSTextCheckingResult *result = [reversedArray objectAtIndex:i];
//        NSString * string=[name substringWithRange:result.range];
//        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
//        [dic setObject:@"" forKey:string];
//    }
    for( NSTextCheckingResult * result in array){

        NSString * string=[name substringWithRange:result.range];
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
        [newArr addObject:string];
    }
    
    
    return newArr;
}

/**
 *  验证办公电话
 *
 *  @param name 字符串
 */
+(BOOL)isValidateOfficeCall:(NSString *)name
{
    NSString *officecall_pattern = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    NSPredicate *officecall_pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", officecall_pattern];
    NSString *officecall_pattern2 = @"^\\d{3,}$";
    NSPredicate *officecall_pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", officecall_pattern2];
    if(![NSString isNullOrEmpty:name]){
        NSArray  *array = [name componentsSeparatedByString:@","];
        for(int i=0;i<array.count;i++){
            NSString *nowofficecall = [array objectAtIndex:i];
            BOOL isMatch = [officecall_pred evaluateWithObject:nowofficecall] || [officecall_pred2 evaluateWithObject:nowofficecall];
            if(!isMatch)return NO;
        }
        return YES;
    }
    return NO;
}


@end
