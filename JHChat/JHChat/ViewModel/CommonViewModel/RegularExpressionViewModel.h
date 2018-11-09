//
//  RegularExpressionViewModel.h
//  LeadingCloud
//
//  Created by dfl on 16/5/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-05-20
 Version: 1.0
 Description: 通用正则验证
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface RegularExpressionViewModel : NSObject

/**
 *  验证手机号
 *
 *  @param mobile 手机号
 */
+(BOOL)isValidateMobile:(NSString *)mobile;

/**
 *  验证密码
 *
 *  @param mobile 密码
 */
+(BOOL)isValidatePwd:(NSString *)passWord;

/**
 *  验证邮箱
 *
 *  @param email 邮箱
 */
+(BOOL) isValidateEmail:(NSString *)email;

/**
 *  验证用户注册的昵称
 *
 *  @param name 用户注册昵称
 */
+(BOOL) isValidateUserName:(NSString *)name;

/**
 *  验证用户在企业下的名称
 *
 *  @param name 企业下用户名
 */
+(BOOL) isValidateEnterpriseUserName:(NSString *)name;

/**
 *  得到IP地址
 *
 *  @param name ip
 */
+(NSString *) isValidateIP:(NSString *)name;

/**
 *  得到{}中的数据
 *
 *  @param name 字符串
 */
+(NSMutableArray *)isValidateQrcodeData:(NSString *)name;

/**
 *  验证办公电话
 *
 *  @param name 字符串
 */
+(BOOL)isValidateOfficeCall:(NSString *)name;

@end
