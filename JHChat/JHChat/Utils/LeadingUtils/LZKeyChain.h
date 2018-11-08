//
//  LZKeyChain.h
//  LeadingCloud
//
//  Created by wchMac on 15/11/18.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-11-18
 Version: 1.0
 Description: KeyChain管理基础类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface LZKeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
