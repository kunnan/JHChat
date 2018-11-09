//
//  SystemPrivilegesUtilViewModel.h
//  LeadingCloud
//
//  Created by dfl on 16/5/12.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-05-12
 Version: 1.0
 Description: 系统通用功能权限公用类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "ALAsset+LZExpand.h"
#import <Photos/Photos.h>
#import<AVFoundation/AVCaptureDevice.h>
#import <MAMapKit/MAMapKit.h>

@interface SystemPrivilegesUtilViewModel : NSObject

/**
 *  判断访问相册权限
 */
+ (BOOL)plauthorizationStatusAuthorized;
/**
 *  相册权限提示
 */
+ (void)plauthorizationStatusSession;

/**
 *  判断拍照权限
 */
+ (BOOL)avauthorizationStatusAuthorized;

+ (void)avCaptureDevice;

/**
 *  判断定位权限
 */
+ (BOOL)locationServicesEnabled;

/**
 *  定位权限提示
 */
+ (void)locationSession;

/**
 *  麦克风权限提示
 */
+ (void)avAudioSession;

/**
 *  通讯录权限提示
 */
+ (void)ABAddressBookRef;

@end
