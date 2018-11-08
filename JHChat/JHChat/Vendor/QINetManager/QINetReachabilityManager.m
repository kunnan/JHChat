//
//  PANetReachabilityManager.m
//  iVoiceForPA
//
//  Created by loginSin on 16/1/4.
//  Copyright © 2016年 d-Ear. All rights reserved.
//

#import "QINetReachabilityManager.h"
#import "QIReachability.h"

static QIReachability *_networkConn;
static void(^(_netStatusChangedBlock))(QINetReachabilityStatus status);

@interface QINetReachabilityManager ()
@end

@implementation QINetReachabilityManager


+ (id)sharedInstance {
    static QINetReachabilityManager *instance = nil;
    static dispatch_once_t once ;
    dispatch_once(&once, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
        _networkConn = [QIReachability reachabilityForInternetConnection];
        [_networkConn startNotifier];
    }
    return self;
}

- (void)networkStateChange {
    QINetReachabilityStatus status = [[QINetReachabilityManager sharedInstance] currentNetReachabilityStatus];
    if(_netStatusChangedBlock){
        _netStatusChangedBlock(status);
    }
}

- (QINetReachabilityStatus)currentNetReachabilityStatus {
    QIReachability *wifi = [QIReachability reachabilityForLocalWiFi];
    QIReachability *conn = [QIReachability reachabilityForInternetConnection];
    
    if([wifi currentReachabilityStatus] != QINotReachable){
        return QINetReachabilityStatusWIFI;
    }else if ([conn currentReachabilityStatus] != QINotReachable){
        return QINetReachabilityStatusWWAN;
    }else {
        return QINetReachabilityStatusNotReachable;
    }
}

- (void)currentNetStatusChangedBlock:(void(^)(QINetReachabilityStatus currentStatus))block {
    _netStatusChangedBlock = [block copy];
}
@end
