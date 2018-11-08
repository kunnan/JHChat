//
//  AppDateUtil.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/5.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-05
 Version: 1.0
 Description: App时间处理工具类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "AppDateUtil.h"
#import "LZFormat.h"
#import "LZUserDataManager.h"
#import "NSString+IsNullOrEmpty.h"

@implementation AppDateUtil

/**
 *  获取当前时间 标准时间+8
 *
 *  @return 返回服务器端的时间
 */
+(NSDate *)GetCurrentDate{
    NSDate *now = [[NSDate alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//	[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
//    NSDateComponents *comps = nil;
//    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
//	NSInteger interval = 8*60*60;
//	[adcomps setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [adcomps setSecond: [LZUserDataManager readIntervalSeconds] ];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:now options:0];
//	newdate = [newdate dateByAddingTimeInterval:interval];
    return newdate;
}

/**
 *  获取当前时间
 *
 *  @return 返回服务器端的时间
 */
+(NSDate *)GetCurrentSendDate{
	NSDate *now = [[NSDate alloc] init];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	//	[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	//    NSDateComponents *comps = nil;
	//    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
	NSDateComponents *adcomps = [[NSDateComponents alloc] init];
	//	NSInteger interval = 8*60*60;
	//	[adcomps setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[adcomps setSecond: [LZUserDataManager readIntervalSeconds]+8*60*60];
	NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:now options:0];
	//	newdate = [newdate dateByAddingTimeInterval:interval];
	return newdate;
}

/**
 *  获取当前时间
 *
 *  @return 返回当前标准的时间
 */
+(NSDate *)GetCurrentStandardDate{
	NSDate *now = [[NSDate alloc] init];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	//	[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	//    NSDateComponents *comps = nil;
	//    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
	NSDateComponents *adcomps = [[NSDateComponents alloc] init];
	//	NSInteger interval = 8*60*60;
	//	[adcomps setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
	[adcomps setSecond: [LZUserDataManager readIntervalSeconds] ];
	NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:now options:0];
	//	newdate = [newdate dateByAddingTimeInterval:interval];
	return newdate;
}
/**
 *  获取当前时间
 *
 *  @return 返回当前时区的时间
 */
+(NSDate *)GetCurrentSystemDate{
	NSDate *now = [NSDate date];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[calendar setTimeZone:[NSTimeZone systemTimeZone]];
	NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMT];

	//    NSDateComponents *comps = nil;
	//    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
	NSDateComponents *adcomps = [[NSDateComponents alloc] init];
	[adcomps setSecond: [LZUserDataManager readIntervalSeconds]];
	
	NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:now options:0];
	newdate = [newdate dateByAddingTimeInterval:interval];

	return newdate;
}

/**
 *  获取当前时间
 *
 *  @return 返回服务器端的时间
 */
+(NSString *)GetCurrentDateForString{
    return [LZFormat Date2String:[AppDateUtil GetCurrentDate]];
}

/**
 *  获取当前时间
 *
 *  @return 返回服务器端的时间
 */
+(NSString *)GetCurrentSendDateForString{
	
	return [LZFormat Date2UTCString:[AppDateUtil GetCurrentSendDate] format:nil];
}
/**
 *  获取当前时间
 *
 *  @return 返回当前标准的时间
 */
+(NSString *)GetCurrentStandardDateForString{
	return [LZFormat Date2String:[AppDateUtil GetCurrentStandardDate]];
}
/**
 *  获取当前时间
 *
 *  @return 返回当前时区的时间
 */
+(NSString *)GetCurrentSystemDateForString{
	return [LZFormat Date2String:[AppDateUtil GetCurrentSystemDate]];
}

/**
 *  获取两个日期的间隔天数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔天数
 */
+(NSInteger)IntervalDays:(NSDate*)startDate endDate:(NSDate*)endDate{
    //将日期改为0时刻
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    
    NSString *strStartDate = [dateFormatter stringFromDate:startDate];
    startDate = [LZFormat String2Date:strStartDate];
    
    NSString *strNowDate = [dateFormatter stringFromDate:endDate];
    endDate = [LZFormat String2Date:strNowDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
    int days = (int)[comps day];
    return days;
}

/**
 *  获取两个日期的间隔分钟数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔分钟数
 */
+(NSInteger)IntervalMinutes:(NSDate *)startDate endDate:(NSDate *)endDate{
    NSInteger cha = [AppDateUtil IntervalSeconds:startDate endDate:endDate];
    return cha/60;
}

/**
 *  获取两个日期的间隔分钟数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔分钟数
 */
+(NSInteger)IntervalMinutesForString:(NSString *)startDate endDate:(NSString *)endDate{
    NSInteger cha = [AppDateUtil IntervalSecondsForString:startDate endDate:endDate];
    return cha/60;
}

/**
 *  获取两个日期的间隔秒数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔秒数
 */
+(NSInteger)IntervalSeconds:(NSDate *)startDate endDate:(NSDate *)endDate{
    
    NSTimeInterval lateS=[startDate timeIntervalSince1970]*1;
    NSTimeInterval lateE=[endDate timeIntervalSince1970]*1;
    
    NSTimeInterval cha=lateE-lateS;
    
    return cha;
}

/**
 *  获取两个日期的间隔毫秒数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔毫秒数
 */
+(CGFloat)IntervalMilliSeconds:(NSDate *)startDate endDate:(NSDate *)endDate{
    
    NSTimeInterval lateS=[startDate timeIntervalSince1970]*1000;
    NSTimeInterval lateE=[endDate timeIntervalSince1970]*1000;
    
    NSTimeInterval cha=lateE-lateS;
    
    return cha;
}
/**
 *  获取两个日期的间隔秒数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 间隔秒数
 */
+(NSInteger)IntervalSecondsForString:(NSString *)startDate endDate:(NSString *)endDate{

    NSDate *dateS = [LZFormat String2Date:startDate];
    NSDate *dateE = [LZFormat String2Date:endDate];
    
    return [AppDateUtil IntervalSeconds:dateS endDate:dateE];
}

/**
 *  判断是否为这周的日期
 *
 *  @param date 日期
 *
 *  @return 是，否
 */
+(BOOL)IsDateThisWeek:(NSDate *)date {
    
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today= [AppDateUtil GetCurrentStandardDate];
    BOOL success= [cal rangeOfUnit:NSWeekCalendarUnit startDate:&start interval: &extends forDate:today];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }
    else {
        return NO;
    }
}

/**
 *  格式化显示时间
 *
 *  @param date 时间
 *
 *  @return 格式化之后的显示
 */
+(NSString *)getSystemShowTime:(NSDate *)date isShowMS:(BOOL)isShowMS{
    
//    NSString *newWeek;
    NSDate *now = [AppDateUtil GetCurrentStandardDate];
    NSInteger interval = [AppDateUtil IntervalDays:date endDate:now];//间隔天数
	

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];

    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *curHour = [dateFormatter stringFromDate:date];
    
    //当天消息显示格式:上午 03:13
    if (interval==0) {
        /* 是否为需要显示上下午 */
        NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
        NSRange containsA = [formatStringForHours rangeOfString:@"a"];
        BOOL hasAMPM = containsA.location != NSNotFound;
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
		NSTimeZone *zone1 = [NSTimeZone systemTimeZone];

		NSLog(@"%@",zone1.name);
		
        [dateFormatter setDateFormat:@"aaahh:mm"];
        if(hasAMPM){
            [dateFormatter setAMSymbol:[NSString stringWithFormat:@"%@ ",@"上午"]];//上午
            [dateFormatter setPMSymbol:[NSString stringWithFormat:@"%@ ",@"下午"]];//下午
        } else {
            [dateFormatter setAMSymbol:@""];
            [dateFormatter setPMSymbol:@""];
        }
        
        NSString *ap = [dateFormatter stringFromDate:date];
        return ap;
    }
    //昨天消息显示:昨天
    if (interval==1) {
        return isShowMS ? [NSString stringWithFormat:@"昨天 %@",curHour] : [NSString stringWithFormat:@"昨天"]; //昨天
    }
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
//    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    comps = [calendar components:unitFlags fromDate:date];
//    NSInteger week = [comps weekday];//获得星期几
    
    //判断是否在一星期以内
//    if ([AppDateUtil IsDateThisWeek:date]) {
//    if (interval<7) {
//        switch (week) {
//            case 1:
//                newWeek = [NSString stringWithFormat:@"星期日"];//星期天
//                break;
//            case 2:
//                newWeek = [NSString stringWithFormat:@"星期一"];//星期一
//                break;
//            case 3:
//                newWeek = [NSString stringWithFormat:@"星期二"];//星期二
//                break;
//            case 4:
//                newWeek = [NSString stringWithFormat:@"星期三"];//星期三
//                break;
//            case 5:
//                newWeek = [NSString stringWithFormat:@"星期四"];//星期四
//                break;
//            case 6:
//                newWeek = [NSString stringWithFormat:@"星期五"];//星期五
//                break;
//            case 7:
//                newWeek = [NSString stringWithFormat:@"星期六"];//星期六
//                break;
//            default:
//                break;
//        }
//        if(isShowMS){
//            newWeek = [newWeek stringByAppendingFormat:@" %@",curHour];
//        }
//        return newWeek;
//    }
//	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];

    [dateFormatter setDateFormat:@"yyyy"];
    
    NSString *curYear = [dateFormatter stringFromDate:date];
    NSString *nowYear = [dateFormatter stringFromDate:now];
    
    if ([curYear integerValue]<[nowYear integerValue]) {
        isShowMS ? [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"] : [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        isShowMS ? [dateFormatter setDateFormat:@"MM-dd HH:mm"] : [dateFormatter setDateFormat:@"MM-dd"];

    }
    NSString * currentStr = [dateFormatter stringFromDate:date];
    return currentStr;
}
/**
 *  得到超期时间
 *
 *  @param date 时间
 *
 *  @return 格式化之后的显示
 */
+(NSString *)getOverdueDate:(NSDate *)date{
    
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    
    NSDate *now = [AppDateUtil GetCurrentStandardDate];
    
    NSTimeInterval nowInterval=[now timeIntervalSinceNow];
    
    //时间差
    NSTimeInterval  time= nowInterval-timeInterval;
    
    time+=(60*60*24);
    NSString *result;
    if(time>0){
        return result;
    }else{
        time=-time;
        long temp = 0;
        if (time < 60) {
            result = [NSString stringWithFormat:@"超期1分钟"];
        }
        else if((temp = time/60) <60){
            result = [NSString stringWithFormat:@"超期%ld分钟",temp];
        }
        
        else if((temp = temp/60) <24){
            result = [NSString stringWithFormat:@"超期%ld个小时",temp];
        }
        
        else if((temp = temp/24) <30){
            result = [NSString stringWithFormat:@"超期%ld天",temp];
        }
        
        else if((temp = temp/30) <12){
            result = [NSString stringWithFormat:@"超期%ld个月",temp];
        }
        else{
            temp = temp/12;
            result = [NSString stringWithFormat:@"超期%ld年",temp];
        }

    }
    
    return  result;
}

/**
 *  收藏显示时间
 *
 *  @param date 时间
 *
 *  @return 格式化之后的显示
 */
+(NSString *)getFavOverdueDate:(NSDate *)date{
    
    NSDate *now = [AppDateUtil GetCurrentStandardDate];
    NSInteger interval = [AppDateUtil IntervalDays:date endDate:now];//间隔天数
    //当天消息显示格式:上午 03:13
    if (interval==0) {
        /* 是否为需要显示上下午 */
        NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
        NSRange containsA = [formatStringForHours rangeOfString:@"a"];
        BOOL hasAMPM = containsA.location != NSNotFound;
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"aaahh:mm"];
        if(hasAMPM){
            [dateFormatter setAMSymbol:[NSString stringWithFormat:@"%@ ",@"上午"]];//上午
            [dateFormatter setPMSymbol:[NSString stringWithFormat:@"%@ ",@"下午"]];//下午
        } else {
            [dateFormatter setAMSymbol:@""];
            [dateFormatter setPMSymbol:@""];
        }
        
        NSString *ap = [dateFormatter stringFromDate:date];
        return ap;
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * currentStr = [dateFormatter stringFromDate:date];
    return currentStr;
}

/**
 *  错误日志显示时间
 *
 *  @param date 时间
 *
 *  @return 格式化之后的显示
 */
+(NSString *)getErrorDataDate:(NSDate *)date{
    
    NSDate *now = [AppDateUtil GetCurrentStandardDate];
    NSInteger interval = [AppDateUtil IntervalDays:date endDate:now];//间隔天数
    //当天消息显示格式:上午 03:13
    if (interval==0) {
        /* 是否为需要显示上下午 */
        NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
        NSRange containsA = [formatStringForHours rangeOfString:@"a"];
        BOOL hasAMPM = containsA.location != NSNotFound;
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"aaahh:mm"];
        if(hasAMPM){
            [dateFormatter setAMSymbol:[NSString stringWithFormat:@"%@ ",@"上午"]];//上午
            [dateFormatter setPMSymbol:[NSString stringWithFormat:@"%@ ",@"下午"]];//下午
        } else {
            [dateFormatter setAMSymbol:@""];
            [dateFormatter setPMSymbol:@""];
        }
        
        NSString *ap = [dateFormatter stringFromDate:date];
        return ap;
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
	
    NSString * currentStr = [dateFormatter stringFromDate:date];
    return currentStr;
}


/**
 *  时间戳转化为时间NSDate
 *
 *  @param timeString 时间
 *
 *  @return 格式化之后的显示
 */
+ (NSString *)timeWithTimeIntervalString:(NSString *)date
{
    if([NSString isNullOrEmpty:date])return nil;
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date1 = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date1];
    return dateString;
}

/**
 *  时间转化为时间戳
 *
 *  @param timeString 时间
 *
 *  @return 格式化之后的显示
 */
+ (NSString *)currentTimeForTimeIntervalString
{
//    NSString *ss = @"2017-04-01 09:14:15";
//    NSDate *s=[LZFormat String2Date:ss];
    NSTimeInterval a=[[AppDateUtil GetCurrentDate] timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    //时间转时间戳的方法:
    return timeString;
}

/**
 *  得到当前时间之后N天的日期
 *
 *  @param dayNumber 天数
 *
 *  @return 格式化之后的显示
 */
+ (NSString *)getCurrentTimeForN_DayTime:(NSInteger)dayNumber{
    NSDate* theDate;
    if(dayNumber!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        
        theDate = [[AppDateUtil GetCurrentDate] initWithTimeIntervalSinceNow: +oneDay*dayNumber ];
        //or
//        theDate = [[AppDateUtil GetCurrentDate] initWithTimeIntervalSinceNow: -oneDay*dayNumber ];
    }
    else
    {
        theDate = [AppDateUtil GetCurrentDate];
    }
//    NSString *timeString = [LZFormat Date2String:theDate];
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM月dd号";
    NSString *timeString = [fmt stringFromDate:theDate];
    return timeString;
    
}

/**
 得到手机系统当前时间
 */
+ (NSString *)getPhoneSystemCurrentTime {
   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
   
   // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
   
   [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
   
   //现在时间,你可以输出来看下是什么格式
   
   NSDate *datenow = [NSDate date];
   
   //----------将nsdate按formatter格式转成nsstring
   
   NSString *nowtimeStr = [formatter stringFromDate:datenow];
   
   return nowtimeStr;
}

/**
 *  得到当前年份
 */
+(NSInteger)getCurrentTimeForYear{
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|
    NSDayCalendarUnit;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    NSInteger year = [d year];
    return year;
}


/**
 *  得到当前时区和系统时区相差的秒数
 */
+(NSInteger)getCurrentTimeZoneForSystemTimeZone{
	
	
	//得到系统时区
	NSTimeZone *systemZone = [NSTimeZone systemTimeZone];
	//得到系统时区与当前时区相差的秒数
	NSInteger seconds1 = [systemZone secondsFromGMT];

	
	return 0;
}
@end
