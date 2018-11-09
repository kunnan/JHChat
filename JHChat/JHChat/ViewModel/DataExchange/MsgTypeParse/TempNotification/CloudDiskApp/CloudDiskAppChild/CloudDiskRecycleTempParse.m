//
//  CloudDiskRecycleTempParse.m
//  LeadingCloud
//
//  Created by SY on 16/5/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CloudDiskRecycleTempParse.h"
#import "ResRecycleDAL.h"
@implementation CloudDiskRecycleTempParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CloudDiskRecycleTempParse *)shareInstance{
    static CloudDiskRecycleTempParse *instance = nil;
    if (instance == nil) {
        instance = [[CloudDiskRecycleTempParse alloc] init];
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
    
    BOOL isSendReport = NO;
    /* 删除 */
    if ([handlertype isEqualToString:Handler_CloudDiskApp_Recycle_Delete]) {
        isSendReport = [self deleteParse:dataDic];
    }
    /* 添加(还原) */
    else if ([handlertype isEqualToString:Handler_CloudDiskApp_Recycle_Add]) {
        
        isSendReport = [self addParse:dataDic];
    }
    /* 清空(无参数) */
    else if ([handlertype isEqualToString:Handler_CloudDiskApp_Recycle_Clear]) {
        isSendReport = [self clearAllParse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}
-(BOOL)deleteParse:(NSMutableDictionary*)dataDic {
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
     [[ResRecycleDAL shareInstance] deleRecycleFile:[body objectForKey:@"recyid"]];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskRecycleTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskRecycle_Notice_Delete, body);
    });
    
    return YES;
}
// 还原
-(BOOL)addParse:(NSMutableDictionary*)dataDic {
    
    
    return YES;
}
-(BOOL)clearAllParse:(NSMutableDictionary *)dataDic {
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
    
    [[ResRecycleDAL shareInstance] deleAllRecycleFile:nil];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskRecycleTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskRecycle_Notice_ClearAll, body);
    });
    
    return YES;
}
@end
