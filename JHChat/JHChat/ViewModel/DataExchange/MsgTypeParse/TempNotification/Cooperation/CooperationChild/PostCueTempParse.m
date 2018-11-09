//
//  PostCueTempParse.m
//  LeadingCloud
//
//  Created by wang on 16/5/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "PostCueTempParse.h"
#import "CooperationDynamicModel.h"
#import "PostPromptDAL.h"


@implementation PostCueTempParse


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostCueTempParse *)shareInstance{
    static PostCueTempParse *instance = nil;
    if (instance == nil) {
        instance = [[PostCueTempParse alloc] init];
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
    
    /*添加常用语 */
    if([handlertype isEqualToString:Handler_Cooperation_Postcue_Insert]){
        isSendReport= [self addPostCueParse:dataDic];
    }
    /*删除常用语 */
    else if ([handlertype isEqualToString:Handler_Cooperation_Postcue_Delete]){
        
        isSendReport= [self delPostCueParse:dataDic];
    }else if ([handlertype isEqualToString:Handler_Cooperation_Postcue_Update]){
        
        isSendReport = [self updataPostCueParse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

- (BOOL)addPostCueParse:(NSMutableDictionary*)dataDic{
    
    
    NSDictionary *body=[dataDic objectForKey:@"body"];
    NSString *pcueid=[body objectForKey:@"postcueid"];
    
    [[CooperationDynamicModel shareInstance]addPromptPcid:pcueid];
    
    return YES;
}

- (BOOL)delPostCueParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body=[dataDic objectForKey:@"body"];
    NSString *pcueid=[body objectForKey:@"postcueid"];
    
    [[PostPromptDAL shareInstance]deletePromptid:pcueid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block PostCueTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Prompt_Change, nil);
    });
    return YES;
}

- (BOOL)updataPostCueParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body=[dataDic objectForKey:@"body"];
    NSString *pcueid=[body objectForKey:@"postcueid"];
    NSString *postcuename =[body objectForKey:@"postcuename"];
    [[PostPromptDAL shareInstance]updataPromptName:postcuename Pcid:pcueid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
    __block PostCueTempParse * service = self;
    EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Prompt_Change, nil);
    });
    
    return YES;

}
@end
