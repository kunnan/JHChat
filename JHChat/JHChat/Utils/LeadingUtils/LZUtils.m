//
//  LZUtils.m
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

#import "LZUtils.h"
#include <netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#import "NSString+IsNullOrEmpty.h"

@implementation LZUtils

/**
 *  创建36位唯一GUID
 *
 *  @return GUID
 */
+(NSString *)CreateGUID{
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    uuid = CFUUIDCreate(NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    result =[NSString stringWithFormat:@"%@", uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    return result;
}

/**
 *  获取手机型号
 *
 *  @return 型号
 */
+ (NSString *)GetDeveiceModel{
    size_t size;
    sysctlbyname("hw.machine",NULL, &size, NULL,0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size,NULL, 0);
    NSString*platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        platform = @"iPhone 1";
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        platform = @"iPhone 3G";
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        platform = @"iPhone 3GS";
    } else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {
        platform = @"iPhone 4";
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        platform = @"iPhone 4S";
    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {
        platform = @"iPhone 5";
    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {
        platform = @"iPhone 5C";
    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {
        platform = @"iPhone 5S";
    } else if ([platform isEqualToString:@"iPhone7,1"]) {
        platform = @"iPhone 6 Plus";
    } else if ([platform isEqualToString:@"iPhone7,2"]) {
        platform = @"iPhone 6";
    } else if ([platform isEqualToString:@"iPhone8,2"]) {
        platform = @"iPhone 6s Plus";
    } else if ([platform isEqualToString:@"iPhone8,1"]) {
        platform = @"iPhone 6s";
    } else if ([platform isEqualToString:@"iPhone8,4"]) {
        platform = @"iPhone SE";
    } else if ([platform isEqualToString:@"iPhone9,1"]||[platform isEqualToString:@"iPhone9,3"]) {
        platform = @"iPhone 7";
    } else if ([platform isEqualToString:@"iPhone9,2"]||[platform isEqualToString:@"iPhone9,4"]) {
        platform = @"iPhone 7 Plus";
    } else if ([platform isEqualToString:@"iPhone10,4"] || [platform isEqualToString:@"iPhone10,1"]) {
        platform = @"iPhone 8";
    } else if ([platform isEqualToString:@"iPhone10,2"] || [platform isEqualToString:@"iPhone10,5"]) {
        platform = @"iPhone 8 Plus";
    }
    
    else if ([platform isEqualToString:@"iPod7,1"]) {
        platform = @"iPod Touch 6";
    }else if ([platform isEqualToString:@"iPod4,1"]) {
        platform = @"iPod Touch 4";
    }else if ([platform isEqualToString:@"iPod5,1"]) {
        platform = @"iPod Touch 5";
    }else if ([platform isEqualToString:@"iPod3,1"]) {
        platform = @"iPod Touch 3";
    }else if ([platform isEqualToString:@"iPod2,1"]) {
        platform = @"iPod Touch 2";
    }else if ([platform isEqualToString:@"iPod1,1"]) {
        platform = @"iPod Touch 1";
    }
    
    else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {
        platform = @"iPad 2";
    }else if ([platform isEqualToString:@"iPad1,1"]) {
        platform = @"iPad 1";
    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {
        platform = @"iPadMini1";
    } else if ([platform isEqualToString:@"iPad3,1"]||[platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,3"]) {
        platform = @"iPad 3";
    } else if ([platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
        platform = @"iPad 4";
    } else if ([platform isEqualToString:@"iPad4,1"]||[platform isEqualToString:@"iPad4,2"]||[platform isEqualToString:@"iPad4,3"]) {
        platform = @"iPad Air";
    } else if ([platform isEqualToString:@"iPad4,4"]||[platform isEqualToString:@"iPad4,6"]||[platform isEqualToString:@"iPad4,5"]) {
        platform = @"iPadMini2";
    } else if ([platform isEqualToString:@"iPad4,7"]||[platform isEqualToString:@"iPad4,8"]||[platform isEqualToString:@"iPad4,9"]) {
        platform = @"iPadMini3";
    } else if ([platform isEqualToString:@"iPad5,1"]||[platform isEqualToString:@"iPad5,2"]) {
        platform = @"iPadMini4";
    } else if ([platform isEqualToString:@"iPad5,3"]||[platform isEqualToString:@"iPad5,4"]) {
        platform = @"iPad Air2";
    }  else if ([platform isEqualToString:@"iPad6,11"]||[platform isEqualToString:@"iPad6,12"]) {
        platform = @"iPad(9.7)";
    } else if ([platform isEqualToString:@"iPad6,3"]||[platform isEqualToString:@"iPad6,4"]) {
        platform = @"iPad Pro(9.7)";
    } else if ([platform isEqualToString:@"iPad6,7"]||[platform isEqualToString:@"iPad6,8"]) {
        platform = @"iPad Pro(12.9)";
    } else if ([platform isEqualToString:@"iPad7,1"] || [platform isEqualToString:@"iPad7,2"]) {
        platform = @"iPad Pro 2(12.9)";
    } else if ([platform isEqualToString:@"iPad7,3"] || [platform isEqualToString:@"iPad7,4"]) {
        platform = @"iPad Pro 2(10.5)";
    }
    
    else if ([platform isEqualToString:@"i386"]||[platform isEqualToString:@"x86_64"]) {
        platform = @"iPhone Simulator";
    }
    return platform;
}

#pragma mark - escape与unescape

/**
 *  escape编码
 *
 *  @param str 原字符串
 *
 *  @return 转码之后的
 */
+(NSString *) escape2:(NSString *)str{
    {
        NSArray *hex = [NSArray arrayWithObjects:
                        @"00",@"01",@"02",@"03",@"04",@"05",
                        @"06",@"07",@"08",@"09",@"0A",@"0B",@"0C",@"0D",@"0E",@"0F",@"10",
                        @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"1A",@"1B",
                        @"1C",@"1D",@"1E",@"1F",@"20",@"21",@"22",@"23",@"24",@"25",@"26",
                        @"27",@"28",@"29",@"2A",@"2B",@"2C",@"2D",@"2E",@"2F",@"30",@"31",
                        @"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"3A",@"3B",@"3C",
                        @"3D",@"3E",@"3F",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",
                        @"48",@"49",@"4A",@"4B",@"4C",@"4D",@"4E",@"4F",@"50",@"51",@"52",
                        @"53",@"54",@"55",@"56",@"57",@"58",@"59",@"5A",@"5B",@"5C",@"5D",
                        @"5E",@"5F",@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",
                        @"69",@"6A",@"6B",@"6C",@"6D",@"6E",@"6F",@"70",@"71",@"72",@"73",
                        @"74",@"75",@"76",@"77",@"78",@"79",@"7A",@"7B",@"7C",@"7D",@"7E",
                        @"7F",@"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",
                        @"8A",@"8B",@"8C",@"8D",@"8E",@"8F",@"90",@"91",@"92",@"93",@"94",
                        @"95",@"96",@"97",@"98",@"99",@"9A",@"9B",@"9C",@"9D",@"9E",@"9F",
                        @"A0",@"A1",@"A2",@"A3",@"A4",@"A5",@"A6",@"A7",@"A8",@"A9",@"AA",
                        @"AB",@"AC",@"AD",@"AE",@"AF",@"B0",@"B1",@"B2",@"B3",@"B4",@"B5",
                        @"B6",@"B7",@"B8",@"B9",@"BA",@"BB",@"BC",@"BD",@"BE",@"BF",@"C0",
                        @"C1",@"C2",@"C3",@"C4",@"C5",@"C6",@"C7",@"C8",@"C9",@"CA",@"CB",
                        @"CC",@"CD",@"CE",@"CF",@"D0",@"D1",@"D2",@"D3",@"D4",@"D5",@"D6",
                        @"D7",@"D8",@"D9",@"DA",@"DB",@"DC",@"DD",@"DE",@"DF",@"E0",@"E1",
                        @"E2",@"E3",@"E4",@"E5",@"E6",@"E7",@"E8",@"E9",@"EA",@"EB",@"EC",
                        @"ED",@"EE",@"EF",@"F0",@"F1",@"F2",@"F3",@"F4",@"F5",@"F6",@"F7",
                        @"F8",@"F9",@"FA",@"FB",@"FC",@"FD",@"FE",@"FF", nil];
        NSMutableString *result = [NSMutableString stringWithString:@""];
        int strLength = (int)str.length;
        for (int i=0; i<strLength; i++) {
            int ch = [str characterAtIndex:i];
            if (ch == ' ')
            {
                [result appendFormat:@"%c%i",'%',20];  //%3F?  %26&  %3D= %2F/ %22"
                //                [result appendFormat:@""];
            }
            else if (ch == '?'){
                [result appendFormat:@"%c%i%c",'%',3,'F'];
            }
            else if (ch == '&'){
                [result appendFormat:@"%c%i",'%',26];
            }
            else if (ch == '='){
                [result appendFormat:@"%c%i%c",'%',3,'D'];
            }
            else if( ch == '/'){
                [result appendFormat:@"%c%i%c",'%',2,'F'];
            }
            else if( ch == '"'){
                [result appendFormat:@"%c%i",'%',22];
            }
            else if ('A' <= ch && ch <= 'Z')
            {
                [result appendFormat:@"%C",(unsigned short)(char)ch];
                
            }
            else if ('a' <= ch && ch <= 'z')
            {
                [result appendFormat:@"%C",(unsigned short)(char)ch];
            }
            else if ('0' <= ch && ch<='9')
            {
                [result appendFormat:@"%C",(unsigned short)(char)ch];
            }
            else if (ch == '?' || ch == '#' ||
                     ch == '[' || ch == ']' || ch == '@' ||
                     ch == '!' || ch == '$' ||
                     ch == '(' || ch == ')' || ch == '*' ||
                     ch == '+' || ch == ',' || ch == ';' ||
                     ch == '"' || ch == '<' ||
                     ch == '>' || ch == '%' || ch == '{'
                     || ch == '}' || ch == '|' || ch == '\\'
                     || ch == '^' || ch == '~' || ch == '`'
                     )
            {
                [result appendFormat:@"%C",(unsigned short)(char)ch];
            }
            else if (ch <= 0x007F)
            {
//                [result appendFormat:@"%%",'%'];
                [result appendString:@"%"];
                [result appendString:[hex objectAtIndex:ch]];
            }
            else
            {
//                [result appendFormat:@"%%",'%'];
                [result appendString:@"%"];
                [result appendFormat:@"%C",(unsigned short)'u'];
                [result appendString:[hex objectAtIndex:ch>>8]];
                [result appendString:[hex objectAtIndex:0x00FF & ch]];
            }
        }
        return result;
        
    }
}


//NSString * tohex(int tmpid)
+(NSString *) tohex:(int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}


//NSString * esp(NSString * src){
+(NSString *) escape:(NSString *)src{
    int i;
    
    
    NSString* tmp = @"";
    
    
    for (i=0; i<[src length]; i++) {
        unichar c  = [src characterAtIndex:(NSUInteger)i];
        
        
        if(isdigit(c)||isupper(c)|islower(c)){
            tmp = [NSString stringWithFormat:@"%@%c",tmp,c];
        }else if((int)c <256){
            tmp = [NSString stringWithFormat:@"%@%@",tmp,@"%"];
            if((int)c <16){
                tmp =[NSString stringWithFormat:@"%@%@",tmp,@"0"];
            }
            tmp = [NSString stringWithFormat:@"%@%@",tmp,[LZUtils tohex:(int)c]];
            
        }else{
            tmp = [NSString stringWithFormat:@"%@%@",tmp,@"%u"];
            tmp = [NSString stringWithFormat:@"%@%@",tmp,[LZUtils tohex:c]];
            
        }
        
        
    }
    
    
    return tmp;
}
//Byte getInt(char c){
+(Byte) getInt:(char)c{
    if(c>='0'&&c<='9'){
        return c-'0';
    }else if((c>='a'&&c<='f')){
        return 10+(c-'a');
    }else if((c>='A'&&c<='F')){
        return 10+(c-'A');
    }
    return c;
}
//int  getIntStr(NSString *src,int len){
+(int) getIntStr:(NSString *)src len:(int)len{
    if(len==2){
        Byte c1 = [LZUtils getInt:[src characterAtIndex:(NSUInteger)0]];
        Byte c2 = [LZUtils getInt:[src characterAtIndex:(NSUInteger)1]];
        return ((c1&0x0f)<<4)|(c2&0x0f);
    }else{
        
        Byte c1 = [LZUtils getInt:[src characterAtIndex:(NSUInteger)0]];
        
        Byte c2 = [LZUtils getInt:[src characterAtIndex:(NSUInteger)1]];
        Byte c3 = [LZUtils getInt:[src characterAtIndex:(NSUInteger)2]];
        Byte c4 = [LZUtils getInt:[src characterAtIndex:(NSUInteger)3]];
        return( ((c1&0x0f)<<12)
               |((c2&0x0f)<<8)
               |((c3&0x0f)<<4)
               |(c4&0x0f));
    }
    
}
//NSString* unesp(NSString* src){
+(NSString *) unescape:(NSString *)src{
    int lastPos = 0;
    int pos=0;
    unichar ch;
    NSString * tmp = @"";
    while(lastPos<src.length){
        NSRange range;
        
        range = [src rangeOfString:@"%" options:NSLiteralSearch range:NSMakeRange(lastPos, src.length-lastPos)];
        if (range.location != NSNotFound) {
            pos = (int)range.location;
        }else{
            pos = -1;
        }
        
        if(pos == lastPos){
            
            if([src characterAtIndex:(NSUInteger)(pos+1)]=='u'){
                NSString* ts = [src substringWithRange:NSMakeRange(pos+2,4)];
                
                int d = [LZUtils getIntStr:ts len:4];
                ch = (unichar)d;
                NSLog(@"%@%C",[LZUtils tohex:d],ch);
                tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%C",ch]];
                
                lastPos = pos+6;
                
            }else{
                NSString* ts = [src substringWithRange:NSMakeRange(pos+1,2)];
                int d = [LZUtils getIntStr:ts len:2];
                ch = (unichar)d;
                tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%C",ch]];
                lastPos = pos+3;
            }
            
        }else{
            if(pos ==-1){
                NSString* ts = [src substringWithRange:NSMakeRange(lastPos,src.length-lastPos)];
                
                tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%@",ts]];
                lastPos = (int)src.length;
            }else{
                NSString* ts = [src substringWithRange:NSMakeRange(lastPos,pos-lastPos)];
                
                tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%@",ts]];
                lastPos  = pos;
            }
        }
    }
    
    return tmp;
}

#pragma mark - unicode

+(NSString *)replaceUnicode:(NSString *)unicodeStr
{
    if([unicodeStr.lowercaseString rangeOfString:@"\\u"].location!=NSNotFound){
        NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
        NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
        NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
        NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
        NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                               mutabilityOption:NSPropertyListImmutable
                                                                         format:NULL
                                                               errorDescription:NULL];
        if([NSString isNullOrEmpty:unicodeStr] || [NSString isNullOrEmpty:returnStr]){
            return unicodeStr;
        }
        return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    }
    return unicodeStr;
}

#pragma mark - 根据域名获取ip

+ (NSString*)getIPWithHostName:(const NSString*)hostName
{
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    
    @try {
        phot = gethostbyname(hostN);
        if (phot == nil) {
            return nil;
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    struct in_addr ip_addr;
    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}


/**
 域名地址转换为ip地址

 @param resultUrl url

 @return ipurl
 */
+(NSString *)getDomainUrlTrunHostUrl:(NSString *)resultUrl{
    
    if([resultUrl hasPrefix:@"http://"] || [resultUrl hasPrefix:@"https://"] ){
        return resultUrl;
    }
    
    if([resultUrl rangeOfString:@"://"].location== NSNotFound){
        return resultUrl;
    }
    
    NSRange rang1 = [resultUrl rangeOfString:@"://"];
    NSString *domainName = [resultUrl substringFromIndex:rang1.length+rang1.location];
    
    if([domainName rangeOfString:@"/"].location== NSNotFound){
        return resultUrl;
    }
    
    NSRange rang2 = [domainName rangeOfString:@"/"];
    domainName = [domainName substringToIndex:rang2.location];
    NSString *host;
    if([domainName rangeOfString:@":"].location!=NSNotFound){
        NSRange range = [domainName rangeOfString:@":"];
        domainName = [domainName substringToIndex:range.location];
        host = [self getIPWithHostName:domainName];
        if(![NSString isNullOrEmpty:host]){
            resultUrl=[resultUrl stringByReplacingOccurrencesOfString:domainName withString:host];
        }
    }
    else{
        host = [self getIPWithHostName:domainName];
        if(![NSString isNullOrEmpty:host]){
            if([resultUrl hasPrefix:@"https://"]){
                host = [NSString stringWithFormat:@"%@:443",host];
            }else{
                host = [NSString stringWithFormat:@"%@:80",host];
            }
            resultUrl=[resultUrl stringByReplacingOccurrencesOfString:domainName withString:host];
            
        }
    }
    
    return resultUrl;
}

/**
 根据地址得到ip
 
 @param resultUrl url
 
 @return ip
 */
+(NSString *)getUrlWithIP:(NSString *)resultUrl{
    NSURL *url = [NSURL URLWithString:resultUrl];
    if ([NSString isNullOrEmpty:url.host]) {
        return @"";
    }
    resultUrl = [self getIPWithHostName:url.host];
    
    return resultUrl;
}
//URL UTF8处理
+ (NSURL *)urlToNsUrl:(NSString *)strUrl{
    NSURL *url = [NSURL URLWithString:strUrl];
    if(url == nil){
        url = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return url;
}

/**
 随机生成一个小于2的32次方的整数

 @return
 */
+ (NSInteger)getRandomNumber {
    NSInteger from = 0;
    NSInteger to = pow(2, 30);
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

@end
