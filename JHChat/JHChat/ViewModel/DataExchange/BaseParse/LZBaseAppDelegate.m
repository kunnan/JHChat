//
//  LZBaseAppDelegate.m
//  LeadingCloud
//
//  Created by wchMac on 2017/10/31.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZBaseAppDelegate.h"
#import "AppUtils.h"

@implementation LZBaseAppDelegate

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(LZBaseAppDelegate *)shareInstance{
    static LZBaseAppDelegate *instance = nil;    
    if (instance == nil) {
        instance = [[LZBaseAppDelegate alloc] init];
        instance.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return instance;
}

@end
