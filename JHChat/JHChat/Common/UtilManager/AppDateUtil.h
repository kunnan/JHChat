//
//  AppDateUtil.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/5.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-05
 Version: 1.0
 Description: App时间处理工具类 （发到服务器用服务器时间（即北京时间），数据库存储，传输比较用标准时间，展示用当前系统时间）
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface AppDateUtil : NSObject

/**
 *  获取当前时间
 *
 *  @return 返回的时间
 */
+(NSDate *)GetCurrentDate;

/**
 *  获取当前时间
 *
 *  @return 返回当前时区的时间
 */
+(NSDate *)GetCurrentSystemDate;

/**
 *  获取当前时间
 *
 *  @return 返回当前标准的时间
 */
+(NSDate *)GetCurrentStandardDate;

/**
 *  获取当前时间
 *
 *  @return 返回服务器端的时间
 */
+(NSDate *)GetCurrentSendDate;
/**
 *  获取当前时间
 *
 *  @return 返回当前标准的时间
 */
+(NSString *)GetCurrentStandardDateForString;
/**
 *  获取当前时间
 *
 *  @return 返回时间
 */
+(NSString *)GetCurrentDateForString;

/**
 *  获取当前时间
 *
 *  @return 返回服务器端的时间
 */
+(NSString *)GetCurrentSendDateForString;

/**
 *  获取当前时间
 *
 *  @return 返回当前时区的时间
 */
+(NSString *)GetCurrentSystemDateForString;

/**
 *  获取两个日期的间隔天数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔天数
 */
+(NSInteger)IntervalDays:(NSDate*)startDate endDate:(NSDate*)endDate;

/**
 *  获取两个日期的间隔分钟数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔分钟数
 */
+(NSInteger)IntervalMinutes:(NSDate *)startDate endDate:(NSDate *)endDate;

/**
 *  获取两个日期的间隔分钟数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔分钟数
 */
+(NSInteger)IntervalMinutesForString:(NSString *)startDate endDate:(NSString *)endDate;

/**
 *  获取两个日期的间隔秒数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔秒数
 */
+(NSInteger)IntervalSeconds:(NSDate *)startDate endDate:(NSDate *)endDate;

/**
 *  获取两个日期的间隔毫秒数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔毫秒数
 */
+(CGFloat)IntervalMilliSeconds:(NSDate *)startDate endDate:(NSDate *)endDate;
/**
 *  获取两个日期的间隔秒数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔秒数
 */
+(NSInteger)IntervalSecondsForString:(NSString *)startDate endDate:(NSString *)endDate;

/**
 *  判断是否为这周的日期
 *
 *  @param date 日期
 *
 *  @return 是，否
 */
+(BOOL)IsDateThisWeek:(NSDate *)date;

/**
 *  格式化显示时间
 *
 *  @param date 时间
 *
 *  @return 格式化之后的显示
 */
+(NSString *)getSystemShowTime:(NSDate *)date isShowMS:(BOOL)isShowMS;

/**
 *  得到超期时间
 *
 *  @param date 时间
 *
 *  @return 格式化之后的显示
 */
+(NSString *)getOverdueDate:(NSDate *)date;
/**
 *  收藏显示时间格式化
 *
 *  @param date 时间
 *
 *  @return 格式化之后的显示
 */
+(NSString *)getFavOverdueDate:(NSDate *)date;
/**
 *  错误日志显示时间
 *
 *  @param date 时间
 *
 *  @return 格式化之后的显示
 */
+(NSString *)getErrorDataDate:(NSDate *)date;
/**
 *  时间戳转化为时间NSDate
 *
 *  @param date 时间
 *
 *  @return 格式化之后的显示
 */
+(NSString *)timeWithTimeIntervalString:(NSString *)date;

/**
 *  时间转化为时间戳
 *
 *  @param timeString 时间
 *
 *  @return 格式化之后的显示
 */
+ (NSString *)currentTimeForTimeIntervalString;

/**
 *  得到当前时间之后N天的日期
 *
 *  @param dayNumber 天数
 *
 *  @return 格式化之后的显示
 */
+ (NSString *)getCurrentTimeForN_DayTime:(NSInteger)dayNumber;

/**
 得到手机系统当前时间
 */
+ (NSString *)getPhoneSystemCurrentTime;

/**
 *  得到当前年份
 */
+ (NSInteger )getCurrentTimeForYear;
@end
