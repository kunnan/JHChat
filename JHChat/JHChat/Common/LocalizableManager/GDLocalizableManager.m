//
//  GDLocalizableManager.m
//  LeadingCloud
//
//  Created by wchMac on 15/11/17.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-11-17
 Version: 1.0
 Description: 国际化设置
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "GDLocalizableManager.h"

@implementation GDLocalizableManager

static NSBundle *bundle = nil;

+ ( NSBundle * )bundle{
    if (bundle ==    nil) {
        [GDLocalizableManager initUserLanguage];
    }
    return bundle;
}

+(void)initUserLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:@"userLanguage"];
    if(string.length == 0){
        //获取系统当前语言版本
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        NSString *current = [languages objectAtIndex:0];

//        if([current isEqualToString:@"zh-Hans-US"] || [current isEqualToString:@"zh-Hans-CN"])
//        {
//            current =CHINESE;
//        }
//        else if([current isEqualToString:@"en-US"] || [current isEqualToString:@"en-CN"])
//        {
//            current =ENGLISH;
//        }
        
        if([[current lowercaseString] hasPrefix:@"zh-"]){
            current = CHINESE;
        } else if([[current lowercaseString] hasPrefix:@"en-"]){
            current = ENGLISH;
        }
        
        string = current;
        
        if(![string isEqual:ENGLISH] && ![string isEqual:CHINESE])
        {
            string = CHINESE;
        }
        
        [def setValue:string forKey:@"userLanguage"];
        [def synchronize];//持久化，不加的话不会保存
    }
    else
    {
        if(![string isEqual:ENGLISH] && ![string isEqual:CHINESE])
        {
            string = CHINESE;
            [def setValue:string forKey:@"userLanguage"];
            [def synchronize];//持久化，不加的话不会保存
        }
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

+(NSString *)userLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"userLanguage"];
    return language;
}

+(void)setUserlanguage:(NSString *)language{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [def setValue:language forKey:@"userLanguage"];
    [def synchronize];
}

@end
