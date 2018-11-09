//
//  AppRemindTempParse.m
//  LeadingCloud
//
//  Created by dfl on 17/3/17.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "AppRemindTempParse.h"
#import "AppDAL.h"
#import "AppMenuDAL.h"

@implementation AppRemindTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AppRemindTempParse *)shareInstance{
    static AppRemindTempParse *instance = nil;
    if (instance == nil) {
        instance = [[AppRemindTempParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    NSString *handlertype = [dataDic lzNSStringForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    /* 应用提醒数字 */
    if ([handlertype isEqualToString:Handler_App_Remind_Remind]) {
        isSendReport = [self parseAppRemind:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    return isSendReport;
}

/**
 * 应用提醒数字
 */
-(BOOL)parseAppRemind:(NSMutableDictionary*)dataDic {
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    
    NSString *appid = [body lzNSStringForKey:@"appid"];
    NSString *orgid = [body lzNSStringForKey:@"orgid"];
    NSInteger number = [[body lzNSNumberForKey:@"mobilenumber"] integerValue];
    
    NSMutableArray *tmpAppArray = [[AppMenuDAL shareInstance] getUserAllAppMenu];
    
    if([orgid isEqualToString:[AppUtils GetCurrentOrgID]] && [[tmpAppArray valueForKeyPath:@"nowid"] containsObject:appid]){
        [[AppDAL shareInstance]updateAppWithRemindNumber:number appid:appid];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block AppRemindTempParse * service = self;
        if([orgid isEqualToString:[AppUtils GetCurrentOrgID]]){
            self.appDelegate.lzGlobalVariable.isNeedRefreshAppRootVC = YES;
        }
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Remind, body);
    });
    return YES;
}

@end
