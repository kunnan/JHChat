//
//  PostReplyTempParse.m
//  LeadingCloud
//
//  Created by wang on 16/6/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "PostReplyTempParse.h"

#import "CooperationDynamicModel.h"
#import "PostDAL.h"

@implementation PostReplyTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostReplyTempParse *)shareInstance{
    static PostReplyTempParse *instance = nil;
    if (instance == nil) {
        instance = [[PostReplyTempParse alloc] init];
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
	
	__block PostReplyTempParse * service = self;
	
	NSDictionary *body = [dataDic objectForKey:@"body"];
	NSString *relatedpid = [body objectForKey:@"relatedpid"];

	/* 在主线程中发送通知 */
	dispatch_async(dispatch_get_main_queue(), ^{
		EVENT_PUBLISH_WITHDATA(service, EventBus_PostDetial_Refresh_Not, relatedpid);
	});

	
    /*添加回复 */
    if([handlertype isEqualToString:Handler_Cooperation_Post_Reply_Insert]){
        isSendReport= [self addPostReplyParse:dataDic];
    }
    /*删除回复 */
    else if ([handlertype isEqualToString:Handler_Cooperation_Post_Reply_Delete]){
        
        isSendReport= [self delPostReplyParse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

//添加回复
- (BOOL)addPostReplyParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
    //机构ID
    NSString *orgid = [body objectForKey:@"orgid"];
    //回复ID
   // NSString *pid = [body objectForKey:@"pid"];
    //动态ID
    NSString *relatedpid = [body objectForKey:@"relatedpid"];

    NSString *oid=[[[LZUserDataManager readCurrentUserInfo] objectForKey:@"notificaton"] objectForKey:@"selectoid"];
    
    //如果是当前企业 处理
    if (orgid && [orgid isEqualToString:oid]) {
        
        [[CooperationDynamicModel shareInstance]GetReadSinglePost:relatedpid];
        
    }else{
        // 爱咋地咋地
    }
    return YES;
}
// 删除回复
- (BOOL)delPostReplyParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body=[dataDic objectForKey:@"body"];
    NSString *pid=[body objectForKey:@"pid"];
    //机构ID
    NSString *orgid = [body objectForKey:@"orgid"];
    //动态ID
    NSString *relatedpid = [body objectForKey:@"relatedpid"];
    
    NSString *oid=[[[LZUserDataManager readCurrentUserInfo] objectForKey:@"notificaton"] objectForKey:@"selectoid"];
    
    //如果是当前企业 处理
    if (orgid && [orgid isEqualToString:oid]) {
        
        [[CooperationDynamicModel shareInstance]GetReadSinglePost:relatedpid];
        
    }else{
        
        [[PostDAL shareInstance]delePostReplyID:pid Rekatedpid:relatedpid];
    }

    return YES;
}

@end
