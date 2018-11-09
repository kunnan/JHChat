//
//  PostTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/3.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-04-29
 Version: 1.0
 Description: 临时消息--协作--动态
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "PostTempParse.h"
#import "CooperationDynamicModel.h"
#import "PostDAL.h"

@implementation PostTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostTempParse *)shareInstance{
    static PostTempParse *instance = nil;
    if (instance == nil) {
        instance = [[PostTempParse alloc] init];
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
    
    /*添加动态 */
    if([handlertype isEqualToString:Handler_Cooperation_Postmain_Insert]){
       isSendReport= [self addPostParse:dataDic];
    }
    /*删除动态 */
    else if ([handlertype isEqualToString:Handler_Cooperation_Postmain_Delete]){
        
       isSendReport= [self delPostParse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

//添加动态
- (BOOL)addPostParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
    //机构ID
    NSString *orgid = [body objectForKey:@"orgid"];
    //动态ID
    NSString *pid = [body objectForKey:@"pid"];

    
    NSString *oid=[[[LZUserDataManager readCurrentUserInfo] objectForKey:@"notificaton"] objectForKey:@"selectoid"];
    
    //如果是当前企业 处理
    if (orgid && [orgid isEqualToString:oid]) {
        
        NSString *relevanceappcode = [body objectForKey:@"relevanceappcode"];
    
        if (relevanceappcode && [relevanceappcode isEqualToString:@"Cooperation"]) {
            
            [[CooperationDynamicModel shareInstance]GetSinglePost:pid];
        }
         
    }else{
        // 爱咋地咋地
    }
    return YES;
}
// 删除动态通知
- (BOOL)delPostParse:(NSMutableDictionary*)dataDic{

    NSDictionary *body=[dataDic objectForKey:@"body"];
    NSString *pid=[body objectForKey:@"pid"];
    
    [[PostDAL shareInstance]delePostID:pid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block PostTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Post_del, pid);
    });
    
    return YES;
}

@end
