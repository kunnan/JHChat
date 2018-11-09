//
//  AppBaseServerModel.h
//  LeadingCloud
//
//  Created by dfl on 16/11/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-11-16
 Version: 1.0
 Description: 基础服务器配置表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface AppBaseServerModel : NSObject

/* 主键 */
@property(nonatomic, strong) NSString *serverid;
/* 应用id */
@property(nonatomic,strong) NSString *appid;
/* 服务器地址 */
@property(nonatomic,strong) NSString *httpwebapihost;
/* Webapi服务器地址 */
@property(nonatomic,strong) NSString *httpwebapiport;
/* html服务器地址 */
@property(nonatomic,strong) NSString *httphtmlhost;
/* html服务器端口 */
@property(nonatomic,strong) NSString *httphtmlport;
/* webApi服务器地址 */
@property(nonatomic,strong) NSString *httpswebapihost;
/* Webapi服务器地址 */
@property(nonatomic,strong) NSString *httpswebapiport;
/* html服务器地址 */
@property(nonatomic, strong) NSString *httpshtmlhost;
/* html服务器端口 */
@property (nonatomic, strong) NSString *httpshtmlport;
/* 单点登陆 */
@property (nonatomic, strong) NSString *sso;
/* 标识 */
@property (nonatomic,strong) NSString *servergroup;


@end
