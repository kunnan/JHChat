//
//  LZBaseSend.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "LZBaseSend.h"

@implementation LZBaseSend

/**
 *  获取供有Delegate
 *
 *  @return AppDelegate
 */
- (AppDelegate *)appDelegate
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}

@end
