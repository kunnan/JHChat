//
//  AppTempParse.m
//  LeadingCloud
//
//  Created by dfl on 17/3/7.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "AppTempParse.h"
#import "AppJurisdictionTempParse.h"
#import "AppRemindTempParse.h"

@implementation AppTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AppTempParse *)shareInstance{
    static AppTempParse *instance = nil;
    if (instance == nil) {
        instance = [[AppTempParse alloc] init];
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
    NSString *secondModel = [[HandlerTypeUtil shareInstance] getSecondModel:[dataDic objectForKey:@"handlertype"]];
    
    BOOL isSendReport = NO;
    /* 应用权限 */
    if([secondModel isEqualToString:Handler_App_Jurisdiction]){
        isSendReport = [[AppJurisdictionTempParse shareInstance] parse:dataDic];
    }
    /* 应用提醒 */
    else if ([secondModel isEqualToString:Handler_App_Remind]){
        isSendReport = [[AppRemindTempParse shareInstance] parse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}
@end
