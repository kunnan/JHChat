//
//  GDLocalizableManager.h
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

#import <Foundation/Foundation.h>

@interface GDLocalizableManager : NSObject

+(NSBundle *)bundle;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言

@end
