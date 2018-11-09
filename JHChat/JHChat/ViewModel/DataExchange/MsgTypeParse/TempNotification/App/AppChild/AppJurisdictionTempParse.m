//
//  AppJurisdictionTempParse.m
//  LeadingCloud
//
//  Created by dfl on 17/3/7.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "AppJurisdictionTempParse.h"
#import "OrgEnterPriseDAL.h"
#import "AppDAL.h"

@implementation AppJurisdictionTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AppJurisdictionTempParse *)shareInstance{
    static AppJurisdictionTempParse *instance = nil;
    if (instance == nil) {
        instance = [[AppJurisdictionTempParse alloc] init];
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
    /* 应用禁用 */
    if ([handlertype isEqualToString:Handler_App_Jurisdiction_Disabled]) {
        isSendReport = [self parseAppDisabled:dataDic];
    }
    /* 应用启用 */
    else if ([handlertype isEqualToString:Handler_App_Jurisdiction_Enable]){
        isSendReport = [self parseAppEnable:dataDic];
    }
    /* 应用可用 */
    else if ([handlertype isEqualToString:Handler_App_Jurisdiction_Available]){
        isSendReport = [self parseAppAvailable:dataDic];
    }
    /* 应用不可用 */
    else if ([handlertype isEqualToString:Handler_App_Jurisdiction_Unavailable]){
        isSendReport = [self parseAppUnavailable:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    return isSendReport;
}

/**
 * 应用禁用
 */
-(BOOL)parseAppDisabled:(NSMutableDictionary*)dataDic {
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    
//    NSString *appid = [body lzNSStringForKey:@"appid"];
    NSString *orgid = [body lzNSStringForKey:@"orgid"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block AppJurisdictionTempParse * service = self;
        if([orgid isEqualToString:[AppUtils GetCurrentOrgID]]){
            self.appDelegate.lzGlobalVariable.isNeedRefreshAppRootVC = YES;
        }
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Jurisdiction_Disabled, body);
    });
    return YES;
}

/**
 * 应用启用
 */
-(BOOL)parseAppEnable:(NSMutableDictionary*)dataDic {
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    NSString *orgid = [body lzNSStringForKey:@"orgid"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block AppJurisdictionTempParse * service = self;
        if([orgid isEqualToString:[AppUtils GetCurrentOrgID]]){
            self.appDelegate.lzGlobalVariable.isNeedRefreshAppRootVC = YES;
        }
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Jurisdiction_Enable, body);
    });
    return YES;
}

/**
 * 应用可用
 */
-(BOOL)parseAppAvailable:(NSMutableDictionary*)dataDic {
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    
    NSString *orgid = [body lzNSStringForKey:@"orgid"];
    OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseDAL shareInstance]getEnterpriseByEId:orgid];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block AppJurisdictionTempParse * service = self;
        if([orgid isEqualToString:[AppUtils GetCurrentOrgID]]){
            self.appDelegate.lzGlobalVariable.isNeedRefreshAppRootVC = YES;
        }
        if(orgEnterPriseModel.isenteradmin!=1){//是否为组织管理员
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_Jurisdiction_Available, body);
        }
    });
    return YES;
}

/**
 * 应用不可用
 */
-(BOOL)parseAppUnavailable:(NSMutableDictionary*)dataDic {
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    
    NSString *orgid = [body lzNSStringForKey:@"orgid"];
    OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseDAL shareInstance]getEnterpriseByEId:orgid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block AppJurisdictionTempParse * service = self;
        if([orgid isEqualToString:[AppUtils GetCurrentOrgID]]){
            self.appDelegate.lzGlobalVariable.isNeedRefreshAppRootVC = YES;
        }
        if(orgEnterPriseModel.isenteradmin!=1){//是否为组织管理员
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_Jurisdiction_Unavailable, body);
        }
    });
    return YES;
}


@end
