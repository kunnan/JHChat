//
//  SecurityParse.m
//  LeadingCloud
//
//  Created by dfl on 16/12/22.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-12-22
 Version: 1.0
 Description: 账号安全
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "SecurityParse.h"
#import "NSObject+JsonSerial.h"

@implementation SecurityParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(SecurityParse *)shareInstance{
    static SecurityParse *instance = nil;
    if (instance == nil) {
        instance = [[SecurityParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic
{
    NSString *route = [dataDic objectForKey:WebApi_Route];

    //移动端扫描后操作
    if([route isEqualToString:WebApi_Security_CheckQrLogin]){
        [self parseSecurityCheckQrLogin:dataDic];
    }
    //手机端确认二维码登录
    else if([route isEqualToString:WebApi_Security_CheckSubmit]){
        [self parseSecurityCheckSubmit:dataDic];
    }
    //手机端取消二维码登录
    else if([route isEqualToString:WebApi_Security_CheckCancel]){
        [self parseSecurityCheckCancel:dataDic];
    }
    
}

/**
 *  移动端扫描后操作
 */
-(void)parseSecurityCheckQrLogin:(NSMutableDictionary *)dataDic{
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block SecurityParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Security_CheckQrLogin, dataString);
    });
}


/**
 *  手机端确认二维码登录
 */
-(void)parseSecurityCheckSubmit:(NSMutableDictionary *)dataDic{
    
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block SecurityParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Security_CheckSubmit, dataString);
    });
}

/**
 *  手机端取消二维码登录
 */
-(void)parseSecurityCheckCancel:(NSMutableDictionary *)dataDic{
    
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block SecurityParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Security_CheckCancel, dataString);
    });
}


#pragma mark -
#pragma mark - 解析数据(服务器返回的ErrorCode非0)

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic{
    
}

@end
