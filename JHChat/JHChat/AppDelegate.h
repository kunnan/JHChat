//
//  AppDelegate.h
//  JHChat
//
//  Created by gjh on 2018/11/5.
//  Copyright © 2018 gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LZService.h"
#import "LZSingleInstance.h"
#import "LZGlobalVariable.h"
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/* 底层服务 */
@property (nonatomic, strong) LZService * lzservice;
/* 界面单一实例管理 */
@property (nonatomic, strong) LZSingleInstance *lzSingleInstance;
/* 全局变量存储 */
@property (nonatomic, strong) LZGlobalVariable *lzGlobalVariable;

@property (strong, nonatomic) UIView *lunchView;

- (void)deepClean;

@end

