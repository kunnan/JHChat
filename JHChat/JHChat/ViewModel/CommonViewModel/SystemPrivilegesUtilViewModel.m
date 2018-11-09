//
//  SystemPrivilegesUtilViewModel.m
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

#import "SystemPrivilegesUtilViewModel.h"
#import "UIAlertView+AlertWithMessage.h"

@implementation SystemPrivilegesUtilViewModel



/**
 *  判断访问相册权限
 */
+ (BOOL)plauthorizationStatusAuthorized {
    if (LZ_IS_IOS8) {
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) return YES;
    } else {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) return YES;
    }
    return NO;
}
/**
 *  相册权限提示
 */
+(void)plauthorizationStatusSession{
    /* 添加提示label */
    NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
    if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
    [UIAlertView alertViewWithMessage:[NSString stringWithFormat:LZGDCommonLocailzableString(@"message_allow_access_photo"),[UIDevice currentDevice].model,appName]];
}

/**
 *  判断拍照权限
 */
+ (BOOL)avauthorizationStatusAuthorized {
    if([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]==AVAuthorizationStatusAuthorized) return YES;
    return NO;
}

+(void)avCaptureDevice{
    if(![self avauthorizationStatusAuthorized]){
        /* 添加提示label */
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        [UIAlertView alertViewWithMessage:[NSString stringWithFormat:@"请在%@的\"设置-隐私-相机\"选项中，允许%@访问你的手机相机。",[UIDevice currentDevice].model,appName]];
    }
}

/**
 *  判断定位权限
 */
+ (BOOL)locationServicesEnabled{
//    if([CLLocationManager locationServicesEnabled]) return YES;
//    
//    return NO;
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        
        //定位功能可用
        return YES;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        return NO;
    }
    return NO;

}
/**
 *  定位权限提示
 */
+ (void)locationSession{
    /* 添加提示label */
    NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
    if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
    [UIAlertView alertViewWithMessage:[NSString stringWithFormat:@"无法获取你的位置信息。请到手机系统的[设置]->[隐私]->[定位服务]中打开定位服务并允许%@使用定位服务。",appName]];
}

/**
 *  麦克风权限提示
 */
+ (void)avAudioSession{
    /* 添加提示label */
    NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
    if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
    [UIAlertView alertViewWithMessage:[NSString stringWithFormat:@"请在%@的\"设置-隐私-麦克风\"选项中，允许%@访问你的手机麦克风。",[UIDevice currentDevice].model,appName]];
}

/**
 *  通讯录权限提示
 */
+ (void)ABAddressBookRef{
    /* 添加提示label */
    NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
    if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
    [UIAlertView alertViewWithMessage:[NSString stringWithFormat:@"请在%@的\"设置-隐私-通讯录\"选项中，允许%@访问你的手机通讯录。",[UIDevice currentDevice].model,appName]];
}

@end
