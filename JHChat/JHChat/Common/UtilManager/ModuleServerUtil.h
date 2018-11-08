//
//  ModuleServerUtil.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/12.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-12
 Version: 1.0
 Description: 服务器管理工具
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "AppModel.h"

typedef void (^LZGetCommonAppWebOrWebApi)(NSString *blockserver);

typedef void (^LZGetAppModel)(AppModel *appModel);

@interface ModuleServerUtil : NSObject

#pragma mark - 平台级使用

/**
 *  根据模块获取对应的服务器地址
 *
 *  @param module 模块
 *
 *  @return 服务器地址（如:http://192.168.11.14:8400）
 */
+(NSString *)GetServerWithModule:(NSString *)module;

/**
 *  获取H5服务器地址
 *
 *  @param module 服务器
 *
 *  @return 地址
 */
+(NSString *)GetH5ServerWithModule:(NSString *)module;

#pragma mark - 应用App

/**
 *  根据appcode获取对应的Web服务器
 */
+(NSString *)GetAppWebServerWithAppCode:(NSString *)appcode;

/**
 *  根据appcode获取对应的Web服务器
 */
+(NSString *)GetAppWebServerWithAppCode:(NSString *)appcode isusedefault:(BOOL)isuserdefault;

/**
 *  根据appcode获取对应的WebApi服务器
 */
+(NSString *)GetAppWebApiServerWithAppCode:(NSString *)appcode;

/**
 *  根据appcode获取对应的WebApi服务器
 */
+(NSString *)GetAppWebApiServerWithAppCode:(NSString *)appcode isusedefault:(BOOL)isuserdefault;

#pragma mark - BaseServer应用App

/**
 *  根据servergroup获取对应的WebApi服务器
 */
+(NSString *)GetAppWebServerWithServerGroup:(NSString *)servergroup isusedefault:(BOOL)isuserdefault;

/**
 *  根据servergroup获取对应的WebApi服务器
 */
+(NSString *)GetAppWebApiServerWithServerGroup:(NSString *)servergroup isusedefault:(BOOL)isuserdefault;

#pragma mark - 获取url地址

/**
 根据appcode和url获取地址
 
 @param appcode appcode
 @param url     url地址
 
 @return url地址
 */
+(NSString *)GetUrlWithAppcode:(NSString *)appcode
                           url:(NSString *)url
              isuserserverdata:(BOOL)isuserserverdata
                         block:(LZGetCommonAppWebOrWebApi)block;

#pragma mark - 根据AppCode获取服务器地址

/**
 *  根据appcode获取对应的Web服务器
 */
+(NSString *)GetCommonAppWebServerWithAppCode:(NSString *)appcode
                                isuserdefault:(BOOL)isuserdefault
                             isuserserverdata:(BOOL)isuserserverdata
                                        block:(LZGetCommonAppWebOrWebApi)block;

/**
 *  根据appcode获取对应的WebApi服务器
 */
+(NSString *)GetCommonAppWebApiServerWithAppCode:(NSString *)appcode
                                   isuserdefault:(BOOL)isuserdefault
                                isuserserverdata:(BOOL)isuserserverdata
                                           block:(LZGetCommonAppWebOrWebApi)block;

#pragma mark - 根据AppCode获取AppModel

/**
 根据AppCode获取AppModel
 */
+(void)GetAppModelWithAppCode:(NSString *)appcode notusertemptype0:(BOOL)notusertemptype0 block:(LZGetAppModel)block;

@end
