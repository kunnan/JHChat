//
//  RegisterByMobileParse.m
//  LeadingCloud
//
//  Created by lz on 16/3/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-03-03
 Version: 1.0
 Description: 手机号注册
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "RegisterByMobileParse.h"
#import "LZUtils.h"
#import "NSDictionary+DicSerial.h"
#import "LZFormat.h"
#import "NSString+IsNullOrEmpty.h"
#import "NSString+SerialToDic.h"

@implementation RegisterByMobileParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(RegisterByMobileParse *)shareInstance{
    static RegisterByMobileParse *instance = nil;
    if (instance == nil) {
        instance = [[RegisterByMobileParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic objectForKey:WebApi_Route];
    if([route isEqualToString:WebApi_CloudUser_SaveValidCode])  [self parseSaveValidCode:dataDic];    //  发送手机号，获取验证码
    if([route isEqualToString:WebApi_CloudUser_ExistUserByLoginName])  [self parseExistUserByLoginName:dataDic];    //  判断账号是否被注册
    if([route isEqualToString:WebApi_CloudUser_RegisterByMobile])  [self parseRegisterByMobile:dataDic];    //  立即注册
    if([route isEqualToString:WebApi_CloudUser_UpdateUserByPhoneNum]) [self parseUpdateUserByPhoneNum:dataDic]; //手机找回密码
    if([route isEqualToString:WebApi_CloudUser_UpdateUserByEmail]) [self parseUpdateUserByEmail:dataDic]; //邮箱找回密码
}
/**
 *  发送手机号
 */
-(void)parseSaveValidCode:(NSMutableDictionary *)dataDict{
//    NSString *dataString  = [NSString stringWithFormat:@"%@",[dataDict lzNSStringForKey:WebApi_DataContext]];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block RegisterByMobileParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Register_ByMobile_SaveValidCode, dataDict);
    });
}
/**
 *  判断手机号是否被注册
 */
-(void)parseExistUserByLoginName:(NSMutableDictionary *)dataDict{
//    NSString *dataString  = [NSString stringWithFormat:@"%@",[dataDict lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block RegisterByMobileParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Register_ByMobile_ExistUserByLoginName, dataString);
    });
}
/**
 *  立即注册
 */
-(void)parseRegisterByMobile:(NSMutableDictionary *)dataDict{
    NSLog(@"%@!!!!!!!!",dataDict);
    NSMutableDictionary *userInfo  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    /* 去除空字符 */
    NSMutableDictionary *userinfoCopy = [[NSMutableDictionary alloc] init];
    for (NSString *key in [userInfo allKeys]) {
       [userinfoCopy setObject:[userInfo objectForKey:key] forKey:key];
    }
    /* 处理selectoid 为空的情况 */
    NSString *notification = [userInfo objectForKey:@"notificaton"];
    if(![NSString isNullOrEmpty:notification]){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[notification seriaToDic]];
        if( [dic objectForKey:@"selectoid"] == [NSNull null]){
            [dic setObject:[userInfo objectForKey:@"uid"] forKey:@"selectoid"];
        }
        [userinfoCopy setObject:dic forKey:@"notificaton"];
        
    }
    [LZUserDataManager saveCurrentUserInfo:userinfoCopy];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block RegisterByMobileParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Register_ByMobile, userinfoCopy);
    });
}

/**
 *  手机找回密码
 */
-(void)parseUpdateUserByPhoneNum:(NSMutableDictionary *)dataDict{
//    NSString *dataString  = [NSString stringWithFormat:@"%@",[dataDict lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block RegisterByMobileParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Register_ByMobile_UpdateUserByPhoneNum, dataString);
    });
}

/**
 *  邮箱找回密码
 */
-(void)parseUpdateUserByEmail:(NSMutableDictionary *)dataDict{
//    NSString *dataString  = [NSString stringWithFormat:@"%@",[dataDict lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block RegisterByMobileParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Register_ByMobile_UpdateUserByEmail, dataString);
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
