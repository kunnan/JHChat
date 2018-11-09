//
//  CloudDiskShareTempParse.m
//  LeadingCloud
//
//  Created by SY on 16/5/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CloudDiskShareTempParse.h"
#import "NetDiskShareViewModel.h"
#import "ResShareDAL.h"
@interface CloudDiskShareTempParse ()
{
    NetDiskShareViewModel *shareViewModel;
    
}

@end

@implementation CloudDiskShareTempParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CloudDiskShareTempParse *)shareInstance{
    static CloudDiskShareTempParse *instance = nil;
    if (instance == nil) {
        instance = [[CloudDiskShareTempParse alloc] init];
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
    shareViewModel = [[NetDiskShareViewModel alloc] init];
    
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    /* 删除 */
    if ([handlertype isEqualToString:Handler_CloudDiskApp_Share_Delete]) {
        isSendReport = [self deleteParse:dataDic];
    }
    /* 添加 */
    else if ([handlertype isEqualToString:Handler_CloudDiskApp_Share_Add]) {
        isSendReport = [self addParse:dataDic];
        
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }

    return isSendReport;
}
-(BOOL)deleteParse:(NSMutableDictionary*)dataDic {
    NSDictionary * body = [dataDic objectForKey:@"body"];
    //更新库
    [[ResShareDAL shareInstance] deleteCancelShareFile:[body objectForKey:@"shareid"]];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskShareTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskShare_Notice_CancelShare, body);
    });
        
    return YES;
}
-(BOOL)addParse:(NSMutableDictionary*)dataDic {
    NSDictionary *body = [dataDic objectForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskShareTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskShare_Notice_AddShare, body);
    });
    // 获取分享文件的信息
//    [shareViewModel getShareModelInfoWithShareId:[body objectForKey:@"shareid"] paw:[body objectForKey:@"paw"]];
    
    return YES;
}
@end
