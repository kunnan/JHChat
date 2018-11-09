//
//  LZBaseAppDelegate.h
//  LeadingCloud
//
//  Created by wchMac on 2017/10/31.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface LZBaseAppDelegate : NSObject

@property (nonatomic, strong) AppDelegate  * appDelegate;

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(LZBaseAppDelegate *)shareInstance;

@end
