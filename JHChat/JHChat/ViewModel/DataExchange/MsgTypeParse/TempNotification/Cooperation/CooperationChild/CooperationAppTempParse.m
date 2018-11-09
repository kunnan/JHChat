//
//  CooperationAppTempParse.m
//  LeadingCloud
//
//  Created by SY on 16/6/13.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooperationAppTempParse.h"
#import "CooperationToolViewModel.h"

@interface CooperationAppTempParse ()
{
    CooperationToolViewModel *toolAppViewModel;
}
@end
@implementation CooperationAppTempParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationAppTempParse *)shareInstance{
    static CooperationAppTempParse *instance = nil;
    if (instance == nil) {
        instance = [[CooperationAppTempParse alloc] init];
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
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    toolAppViewModel = [[CooperationToolViewModel alloc] init];
    
    BOOL isSendReport = NO;
    /* 添加工具 */
    if ([handlertype isEqualToString:Handler_Cooperation_App_Ref_Insert]) {
        // 通过cid重新获取一遍已添加的工具
        NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    
        isSendReport = YES;
        __block CooperationAppTempParse *service = self;
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_ToolApp_Insert, [body lzNSStringForKey:@"cid"]);
        });
    }
    /* 移除工具 */
    else if ([handlertype isEqualToString:Handler_Cooperation_App_Ref_Delete]) {
        NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
        // 移除也要从新获取一遍工具，然后刷新
        isSendReport = YES;
        __block CooperationAppTempParse *service = self;
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_ToolApp_Insert, [body lzNSStringForKey:@"cid"]);
        });
        
    }
    
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;

}

// 添加工具
-(BOOL)parseInsertApps:(NSMutableDictionary*)dataDic {
    
//    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
//    // 加载工具数据(组织)
//    NSString *orgid = [[[LZUserDataManager readCurrentUserInfo] objectForKey:@"notificaton"] objectForKey:@"selectoid"];
//    // 加载个人的
//    if(orgid == nil||[orgid isEqualToString:@""] ){
//        orgid=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
//    }
//    
//    // 个人还是组织工具
//    NSString *organizationType = [toolAppViewModel orginazationOrPerson];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
////                [toolAppViewModel sendWebApiGetToolDataScource:organizationType
////                                                          type:[body lzNSStringForKey:@"cooperationtype"]
////                                                         orgid:orgid
////                                                           uid:[[LZUserDataManager readCurrentUserInfo] lzNSStringForKey: @"uid"]
////                                                           cid:[body lzNSStringForKey:@"cid"]];
////            
//        });
//    });
    
    return YES;
}
@end
