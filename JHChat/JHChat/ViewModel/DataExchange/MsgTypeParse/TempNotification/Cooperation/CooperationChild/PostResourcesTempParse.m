//
//  PostResourcesTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-05-04
 Version: 1.0
 Description: 临时消息--协作--资源评论
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "PostResourcesTempParse.h"
#import "CooperationDynamicModel.h"

@implementation PostResourcesTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostResourcesTempParse *)shareInstance{
    static PostResourcesTempParse *instance = nil;
    if (instance == nil) {
        instance = [[PostResourcesTempParse alloc] init];
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
    
    /* 接受邀请 */
    if([handlertype isEqualToString:Handler_Cooperation_PostResources_Insert]){
        
       isSendReport= [self addPostResourcesParse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}


//添加动态
- (BOOL)addPostResourcesParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
    //机构ID
    NSString *orgid = [body objectForKey:@"orgid"];
    //动态ID
    NSString *pid = [body objectForKey:@"pid"];
    
    NSString *oid=[[[LZUserDataManager readCurrentUserInfo] objectForKey:@"notificaton"] objectForKey:@"selectoid"];
    
    //如果是当前企业 处理
    if (orgid && [orgid isEqualToString:oid]) {
        
        [[CooperationDynamicModel shareInstance]GetSinglePost:pid];
        
    }else{
        // 爱咋地咋地
    }
    return YES;
}

@end
