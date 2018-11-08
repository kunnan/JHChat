//
//  LZUtils.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/30.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-30
 Version: 1.0
 Description: 其它工具类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "sys/utsname.h"
#include <sys/sysctl.h>

@interface LZUtils : NSObject

/**
 *  创建36位唯一GUID
 *
 *  @return GUID
 */
+(NSString *)CreateGUID;

/**
 *  获取手机型号
 *
 *  @return 型号
 */
+ (NSString *)GetDeveiceModel;
/**
 *  escape编码
 *
 *  @param str 原字符串
 *
 *  @return 转码之后的
 */
+(NSString *) escape2:(NSString *)str;
/**
 *  escape编码
 */
+(NSString *) escape:(NSString *)str;
/**
 *  unescape解码
 */
+(NSString *) unescape:(NSString *)str;

/**
 *  Unicode解码
 */
+(NSString *)replaceUnicode:(NSString *)unicodeStr;

/**
 根据域名得到ip 地址

 @param hostName 域名

 @return 返回ip 地址 ，错误为nil
 */
+ (NSString*)getIPWithHostName:(const NSString*)hostName;

/**
 域名地址转换为ip地址
 
 @param resultUrl url
 
 @return ipurl
 */
+(NSString *)getDomainUrlTrunHostUrl:(NSString *)resultUrl;

/**
 根据地址得到ip
 
 @param resultUrl url
 
 @return ip
 */
+(NSString *)getUrlWithIP:(NSString *)resultUrl;
//URL UTF8处理
+ (NSURL *)urlToNsUrl:(NSString *)strUrl;

/**
 随机生成一个32位的整数
 
 */
+ (NSInteger)getRandomNumber;
@end
