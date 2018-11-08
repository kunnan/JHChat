//
//  LZFormat.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 格式化转换 数据库存储，发到服务器用服务器时间（即北京时间），传输比较用标准时间，展示用当前系统时间）
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface LZFormat : NSObject

/**
 *  将日期格式转为字符串
 *
 *  @param date 日期
 *
 *  @return 日期字符串
 */
+(NSString*)Date2String:(NSDate *)date;

/**
 *  将日期格式转为字符串
 *
 *  @param date   日期
 *  @param format 格式化格式
 *
 *  @return 日期字符串
 */
+(NSString*)Date2String:(NSDate *)date format:(NSString *)format;

/**
 *  将日期格式转为字符串以标准时区
 *
 *  @param date   日期
 *  @param format 格式化格式
 *
 *  @return 日期字符串
 */
+(NSString*)Date2UTCString:(NSDate *)date format:(NSString *)format;

/**
 *  将字符串转为标准日期
 *
 *  @param strDate 日期字符串
 *
 *  @return 日期
 */
+(NSDate *)String2Date:(NSString *)strDate;

/**
 *  将字符串转为标准日期（处理+08:00）的字符串时间
 *
 *  @param strDate 日期字符串
 *
 *  @return 日期
 */
+(NSDate *)String2StandardDate:(NSString *)strDate;

/**
 *  将字符串转为系统日期
 *
 *  @param strDate 日期字符串
 *
 *  @return 日期
 */
+(NSDate *)String2SystemDate:(NSString *)strDate;

/**
 *  将字符串转为日期(协作)
 *
 *  @param strDate 日期字符串
 *
 *  @return 日期
 */
+(NSDate *)StringCooperationDate:(NSString *)strDate;

/**
 *  将字符串转为+8日期(协作)系统时间字符串
 *
 *  @param strDate 日期字符串
 *
 *  @return 日期
 */
+(NSString *)String8CooperationDate:(NSString *)strDate;

/**
 *  时间格式化 2014-8-2 16:36:23转2014-08-02 04:36:23
 *
 *  @param date 日期字符串
 *
 *  @return 格式化后的日期字符串
 */
+(NSString*)FormatDate:(NSString*)date;

/**
 *  格式化当前时间，用户给文件或图片命名
 *
 *  @return 时间格式:yyyyMMddhhmmssSSS
 */
+(NSString *)FormatNow2String;

/**
 *  转换为数字类型
 *
 *  @param objNum 任何类型值
 *
 *  @return 数值
 */
+(NSInteger)Safe2Int32:(id)objNum;

/**
 *  转换为字符串
 *
 *  @param objStr 数据
 *
 *  @return 字符串
 */
+(NSString *)Null2String:(id)objStr;

/**
 *  转换为字符串
 *
 *  @param objStr 数据
 *  @param defaultStr 为空时的默认值
 *
 *  @return 字符串
 */
+(NSString *)Null2String:(id)objStr defaultStr:(NSString *)defaultStr;

/**
 *  将html 字符串转换普通字符串
 *
 *  @param html html 字符串
 *
 *  @return 字符串
 */
+(NSString *)flattenHTML:(NSString *)html;

//清除回车换行
+(NSString*)clearSurplusReturnHtml:(NSString*)html;
/**
 秒数转化成时分秒结构
 
 */
+ (NSString *)returndate:(NSString *)num;

@end
