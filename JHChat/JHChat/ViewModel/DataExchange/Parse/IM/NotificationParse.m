//
//  NotificationParse.m
//  LeadingCloud
//
//  Created by gjh on 2017/7/12.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "NotificationParse.h"

@implementation NotificationParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+ (NotificationParse *)shareInstance {
    static NotificationParse *instance = nil;
    if (instance == nil) {
        instance = [[NotificationParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析webapi请求的数据
- (void)parse:(NSMutableDictionary *)dataDic {
    NSString *route = [dataDic lzNSStringForKey:WebApi_Route];
    
    if ([route isEqualToString:WebApi_Notification_Send]) {
        [self parseSendNotification:dataDic];
    }
}

- (void)parseSendNotification:(NSMutableDictionary *)dataDic {
    NSString *result = [dataDic lzNSStringForKey:WebApi_DataContext];
    
    if ([result isEqualToString:@"true"]) {
        NSLog(@"通知发送成功");
    }
}
#pragma mark - 解析数据(服务器返回的ErrorCode非0)

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
- (void)parseErrorDataContext:(NSMutableDictionary *)dataDic {
    
}

@end
