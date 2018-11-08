//
//  LZFormat.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 格式化转换
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFormat.h"
#import "NSString+Replace.h"

@implementation LZFormat



/**
 *  将日期格式转为字符串
 *
 *  @param date 日期
 *
 *  @return 日期字符串
 */
+(NSString*)Date2String:(NSDate *)date{
    return [LZFormat Date2String:date format:@"yyyy-MM-dd HH:mm:ss.SSS"];
}

/**
 *  将日期格式转为字符串
 *
 *  @param date   日期
 *  @param format 格式化格式
 *
 *  @return 日期字符串
 */
+(NSString*)Date2UTCString:(NSDate *)date format:(NSString *)format{
	if (!date) {
		return @"";
	}
	if (format == nil) {
		format = @"yyyy-MM-dd HH:mm:ss.SSS";
	}
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	[dateFormatter setDateFormat:format];
	NSString *destDateString = [dateFormatter stringFromDate:date];
	return destDateString;
}
/**
 *  将日期格式转为字符串
 *
 *  @param date   日期
 *  @param format 格式化格式
 *
 *  @return 日期字符串
 */
+(NSString*)Date2String:(NSDate *)date format:(NSString *)format{
    if (!date) {
        return @"";
    }
    if (format == nil) {
        format = @"yyyy-MM-dd HH:mm:ss.SSS";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

/**
 *  将字符串转为标准日期（服务器时间，显示用）
 *
 *  @param strDate 日期字符串
 *
 *  @return 日期
 */
+(NSDate *)String2StandardDate:(NSString *)strDate{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	strDate = [[strDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
	if([strDate rangeOfString:@"+"].location != NSNotFound){
		strDate = [strDate substringToIndex:[strDate rangeOfString:@"+"].location];

	}
	
	NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]; //北京的时间 这加的不对啊
	[dateFormatter setTimeZone:timeZone];
	if([strDate rangeOfString:@"."].location != NSNotFound){
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
	}else if([strDate rangeOfString:@"Z"].location != NSNotFound){
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
	}
	else {
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	}
	
	NSDate *curDate = [dateFormatter dateFromString:strDate];
	if (curDate == nil) {
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		curDate = [dateFormatter dateFromString:strDate];
	}
	return curDate;
}


/**
 *  将字符串转为系统日期 (用不到吧）
 *
 *  @param strDate 日期字符串
 *
 *  @return 日期
 */
+(NSDate *)String2SystemDate:(NSString *)strDate{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	strDate = [[strDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
	if([strDate rangeOfString:@"+"].location != NSNotFound){
		strDate = [strDate substringToIndex:[strDate rangeOfString:@"+"].location];
	}
//	NSTimeZone *timeZone = [NSTimeZone systemTimeZone]; //北京的时间 这加的不对啊
//	[dateFormatter setTimeZone:timeZone];
	
	if([strDate rangeOfString:@"."].location != NSNotFound){
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
	}else if([strDate rangeOfString:@"Z"].location != NSNotFound){
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
	}
	else {
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	}
	
	NSDate *curDate = [dateFormatter dateFromString:strDate];
	if (curDate == nil) {
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		curDate = [dateFormatter dateFromString:strDate];
	}
	return curDate;
}

/**
 *  将字符串转为日期
 *
 *  @param strDate 日期字符串
 *
 *  @return 日期
 */
+(NSDate *)String2Date:(NSString *)strDate{

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    strDate = [[strDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    if([strDate rangeOfString:@"+"].location != NSNotFound){
        strDate = [strDate substringToIndex:[strDate rangeOfString:@"+"].location];
		NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]; //北京的时间 这加的不对啊
		[dateFormatter setTimeZone:timeZone];
    }
	NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]; //北京的时间 这加的不对啊
	[dateFormatter setTimeZone:timeZone];

    if([strDate rangeOfString:@"."].location != NSNotFound){
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }else if([strDate rangeOfString:@"Z"].location != NSNotFound){
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    NSDate *curDate = [dateFormatter dateFromString:strDate];
    if (curDate == nil) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        curDate = [dateFormatter dateFromString:strDate];
    }
    return curDate;
}

/**
 *  将字符串转为日期(协作)
 *
 *  @param strDate 日期字符串
 *
 *  @return 日期
 */
+(NSDate *)StringCooperationDate:(NSString *)strDate{
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd "];
        NSDate* inputDate = [formatter dateFromString:strDate];
    return inputDate;
}

/**
 *  将字符串转为+8日期(协作)系统时间字符串
 *
 *  @param strDate 日期字符串
 *
 *  @return 日期
 */
+(NSString *)String8CooperationDate:(NSString *)strDate{
	
	NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:timeZone];
	[formatter setDateFormat:@"yyyy-MM-dd "];
	NSDate* inputDate = [formatter dateFromString:strDate];
	NSTimeZone *zone = [NSTimeZone systemTimeZone];
	
	
	//计算世界时间与本地时区的时间偏差值
	NSInteger offset = [LZUserDataManager readIntervalSeconds]+8*60*60 -[zone secondsFromGMT];
	
	//世界时间＋偏差值 得出中国区时间
	NSDate *localDate = [inputDate dateByAddingTimeInterval:offset];
	
	
	return [LZFormat Date2UTCString:localDate format:nil];
}
/**
 *  时间格式化 2014-8-2 16:36:23转2014-08-02 04:36:23
 *
 *  @param date 日期字符串
 *
 *  @return 格式化后的日期字符串
 */
+(NSString*)FormatDate:(NSString*)date{
    if(date==nil){
        return @"";
    }
    
    date = [[date stringByReplacingOccurrencesOfString:@"/" withString:@"-"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-M-d HH:mm:ss.SSS"];
    NSDate *newDate = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *destDateString = [dateFormatter stringFromDate:newDate];
    return destDateString;
}

/**
 *  格式化当前时间，用户给文件或图片命名
 *
 *  @return 时间格式:yyyyMMddhhmmssSSS
 */
+(NSString *)FormatNow2String{
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *nowDateStr = [dateFormatter stringFromDate:now];
    nowDateStr = [nowDateStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    return nowDateStr;
}

/**
 *  转换为数字类型
 *
 *  @param objNum 任何类型值
 *
 *  @return 数值
 */
+(NSInteger)Safe2Int32:(id)objNum{
    if(objNum==nil || [objNum isEqual:[NSNull null]]){
        return 0;
    }
    
    NSString *strNum = (NSString *)objNum;
    if([LZCheck IsNumber:strNum]){
        return strNum.integerValue;
    } else {
        return 0;
    }
}

/**
 *  转换为字符串
 *
 *  @param objStr 数据
 *
 *  @return 字符串
 */
+(NSString *)Null2String:(id)objStr{
    return [LZFormat Null2String:objStr defaultStr:@""];
}

/**
 *  转换为字符串
 *
 *  @param objStr 数据
 *  @param defaultStr 为空时的默认值
 *
 *  @return 字符串
 */
+(NSString *)Null2String:(id)objStr defaultStr:(NSString *)defaultStr{
    if(objStr==nil || [objStr isEqual:[NSNull null]]){
        return @"";
    }
    
    return (NSString *)objStr;
}


/**
 *  将html 字符串转换普通字符串
 *
 *  @param html html 字符串
 *
 *  @return 字符串
 */
+(NSString *)flattenHTML:(NSString *)html{
    if(html==nil){
        return @"";
    }
    
    html = [[[[html stringByReplacingOccurrencesOfString:@"<BR>" withString:@"\n"]
              stringByReplacingOccurrencesOfString:@"<Br>" withString:@"\n"]
             stringByReplacingOccurrencesOfString:@"<bR>" withString:@"\n"]
            stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    html = [html stringByReplacingIGNOREOccurrencesOfString:@"<div></div>" withString:@"\n"];
    html = [html stringByReplacingIGNOREOccurrencesOfString:@"<div>" withString:@"\n"];
    html = [html stringByReplacingIGNOREOccurrencesOfString:@"</div>" withString:@"\n"];
    
    NSString *result = nil;
    NSRange arrowTagStartRange = [html rangeOfString:@"<"];
    NSRange arrowTagEndRange = [html rangeOfString:@">"];
    if (arrowTagStartRange.location != NSNotFound && arrowTagEndRange.location != NSNotFound) {
        if(arrowTagEndRange.location < arrowTagStartRange.location )
        {
            result = [html stringByReplacingCharactersInRange:NSMakeRange(arrowTagEndRange.location, 1) withString:@""];
            
        }
        else{
            result = [html stringByReplacingCharactersInRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location + 1) withString:@""];
        }
        return [self flattenHTML:result];
    }else{
        result = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];  // 过滤&nbsp等标签
    }
    return [self clearHtml:result];
}
//过滤HTML转义字符
+(NSString *)clearHtml:(NSString *)html{
    NSString *result = nil;
    if (html!=nil) {
        result = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];  // 过滤&nbsp等标签
        result = [result stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        result = [result stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        result = [result stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        result = [result stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        result = [result stringByReplacingOccurrencesOfString:@"&#13;&#10;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    }
    return [self clearSurplusReturnHtml:result];
}

+(NSString*)clearSurplusReturnHtml:(NSString*)html{
    
    NSString *result = nil;
    
    result = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return result;
}

/**
 秒数转化成时分秒结构 

 @param num
 @return
 */
+ (NSString *)returndate:(NSString *)num{
    int totalSeconds = num.intValue;
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    
}

@end
