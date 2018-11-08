//
//  PANetReachabilityManager.h
//  iVoiceForPA
//
//  Created by loginSin on 16/1/4.
//  Copyright © 2016年 d-Ear. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    //没有网络
    QINetReachabilityStatusNotReachable = 0,
    //wifi
    QINetReachabilityStatusWIFI,
    //手机流量
    QINetReachabilityStatusWWAN,
    
} QINetReachabilityStatus;

//网络连接类，判断当前网络状况
@interface QINetReachabilityManager : NSObject

+ (id)sharedInstance;

/**获取当前网络状态*/
- (QINetReachabilityStatus)currentNetReachabilityStatus;

/**当网络状态改变,回调这个block*/
- (void)currentNetStatusChangedBlock:(void(^)(QINetReachabilityStatus currentStatus))block;
@end
