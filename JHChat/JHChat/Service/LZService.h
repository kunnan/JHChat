//
//  LZService.h
//  LeadingCloud
//
//  Created by admin on 15/12/1.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  huangyue
 Date：   2015-12-01
 Version: 1.0
 Description: 服务
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import <Foundation/Foundation.h>

#import "BaseConst.h"

#import "LZUserDataManager.h"

//#import "LZLogin.h"
#import "LZConnection.h"

@interface LZService : NSObject

/*
 登录
 */
//@property (nonatomic, strong) LZLogin *lzlogin;

/*
 长链接
 */
@property (nonatomic, strong) LZConnection *lzconnection;

/*
 令牌
 */
@property (nonatomic, copy) NSString * tokenId;

/*
 自动大重连次数
 */
@property (nonatomic, assign) int connectfailurecount;
@property (nonatomic, strong) NSString *loginRestartGUID;

/*
 是否从登录页面登录
 */
@property (nonatomic, assign) BOOL isLoginFromLoginVC;

#pragma mark start & stop
/*
 开始
 */
-(void) start;
/*
 结束
 */
-(void)stop;


#pragma mark login & connection
/*
 开始登录
 */
-(void)loginStartForClick:(NSString *)server loginName:(NSString*)loginName password:(NSString *)password;

/**
 *  登录到消息服务器，并开始长连接
 */
-(void)loginToIMServer;

/*
 点击注册，或找回密码时调用
 */
-(void)loginForGetTokenID:(NSString *)server;

/**
 *  在已经有Token的时候，进行登录
 */
-(void)loginStartAfterGetTokenID:(NSString *)server loginName:(NSString*)loginName password:(NSString *)password;

/*
 开始登录(临时)
 */
//-(void) loginCancel;

/*
 用户操作重新登录
 */
-(void)loginRestartForUserHandle;

/*
 获取服务器
 */
-(void)loginForGetModuleServer:(NSString *)server;


/*
 开始长链接
 */
-(void)connectPollingStart:(NSString *)tokenId msgserver:(NSString*)msgserver;

/*
 长链接(临时)
 */
-(void)connectPollingCancel;

/*
 取消
 */
-(void)cancel;

/*
 发送消息
 */
-(void)send:(NSDictionary *)data;


#pragma mark - 安全校验登录
//-(void)loginStartForIsPhoneValidClick:(NSString *)server loginName:(NSString*)loginName password:(NSString *)password;
//
//
//#pragma mark - 第三方登录
//-(void)loginThirdAppForClick:(NSString *)server apptype:(NSString *)appType openid:(NSString*)openid otherData:(NSDictionary *)otherData;
//
////注册成功之后，登录消息服务器
//-(void)loginIMForThirdApp;

#pragma mark - 请求数据(非队列模式)

/**
 *  以Get模式调用WebApi
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param getData         get请求的数据
 *  @param data            其它数据
 */
-(void)sendToServerForGet:(NSString *)webApiControler
                routePath:(NSString *)routePath
             moduleServer:(NSString *)moduleServer
                  getData:(NSDictionary *)getData
                otherData:(NSDictionary *)data;

/**
 *  以Post模式调用WebApi
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param getData         get请求的数据
 *  @param postData        Post传递的数据
 *  @param data            其它数据
 */
-(void)sendToServerForPost:(NSString *)webApiControler
                 routePath:(NSString *)routePath
              moduleServer:(NSString *)moduleServer
                   getData:(NSDictionary *)getData
                  postData:(id)postData
                 otherData:(NSDictionary *)data;

#pragma mark - 请求数据(队列模式)

/**
 *  以Get队列模式调用WebApi
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param getData         get请求的数据
 *  @param data            其它数据
 */
-(void)sendToServerQueueForGet:(NSString *)webApiControler
                     routePath:(NSString *)routePath
                  moduleServer:(NSString *)moduleServer
                       getData:(NSDictionary *)getData
                     otherData:(NSDictionary *)data;

/**
 *  以Post队列模式调用WebApi
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param getData         get请求的数据
 *  @param postData        Post传递的数据
 *  @param data            其它数据
 */
-(void)sendToServerQueueForPost:(NSString *)webApiControler
                      routePath:(NSString *)routePath
                   moduleServer:(NSString *)moduleServer
                        getData:(NSDictionary *)getData
                       postData:(id)postData
                      otherData:(NSDictionary *)data;

#pragma mark - 未登录，请求数据(非队列模式)

/**
 *  以Get模式调用WebApi
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param getData         get请求的数据
 *  @param data            其它数据
 */
-(void)noLoginSendToServerForGet:(NSString *)webApiControler
                       routePath:(NSString *)routePath
                    moduleServer:(NSString *)moduleServer
                         getData:(NSDictionary *)getData
                       otherData:(NSDictionary *)data;

/**
 *  以Post模式调用WebApi
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param getData         get请求的数据
 *  @param postData        Post传递的数据
 *  @param data            其它数据
 */
-(void)noLoginSendToServerForPost:(NSString *)webApiControler
                        routePath:(NSString *)routePath
                     moduleServer:(NSString *)moduleServer
                          getData:(NSDictionary *)getData
                         postData:(id)postData
                        otherData:(NSDictionary *)data;


#pragma mark - 消息队列处理

/**
 *  将发送中的消息更改为失败状态
 */
-(void)resetSendingMsgToFail;

/**
 *  发送过程中断网
 */
-(void)resendAfterNetWorkIsDisconnect;

@end
