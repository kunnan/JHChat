//
//  LZLongPolling.h
//  LeadingCloud
//
//  Created by admin on 15/11/12.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  huangyue
 Date：   2015-11-13
 Version: 1.0
 Description: 长链接 处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

#import "LZURLConnection.h"

/*
 链接成功
 */
typedef void (^LZConnectionSuccessHandler)(id data);

/*
 出错消息
 */
typedef void (^LZConnectionFailureHandler)(int code , NSString *error);

/*
 发送消息成功
 */
typedef void (^LZConnectionSendSuccessHandler)(NSDictionary * data);

/*
 发送消息失败
 */
typedef void (^LZConnectionSendFailureHandler)(int type,NSDictionary * data);

/*
 回执消息成功
 */
typedef void (^LZConnectionReportSuccessHandler)(NSArray * synckeys, int msgtype);

/*
 回执消息失败
 */
typedef void (^LZConnectionReportFailureHandler)(NSArray * synckeys, int msgtype,  int code , NSString *error);

/*
 队列中重新发送消息
 */
typedef void (^LZResendMessageHandler)(id data);

/*
 长连接返回值处理
 */
typedef void (^LZLongPullResultHandler)(id data);

/*
 队列中重新发送消息
 */
typedef void (^LZParseMsgResult)(BOOL parseResult);


@interface LZConnection : NSObject

/* 以队列模式请求WebApi */
/* 是否正在请求队列中的webapi */
@property (nonatomic, assign) BOOL queueIsGettingData;
/* 队列中的webapi */
//@property (nonatomic, copy) NSMutableArray *queueWeApiArray;

/* 是否已经链接 */
@property (nonatomic, assign) BOOL connected;

/* 是否正在链接 */
@property (nonatomic, assign) BOOL connecting;

/*
 初始化
 */
-(id) initWithReady;

/*
 取消
 */
-(void) cancel;

/*
 设置登录信息
 */
-(void) setLoginInfo:(NSString *)tokenId msgserver:(NSString*)msgserver serverUrl:(NSString *)serverUrl;

/*
 登录IM
 */
-(void)login;
/*
 发送
 */
-(void)send:(NSDictionary *)data;

/*
 链接成功
 */
- (void)setSuccessHandler:(LZConnectionSuccessHandler)successHandler;

/*
 出错消息
 */
- (void)setFailureHandler:(LZConnectionFailureHandler)failureHandler;

/*
 发送消息成功
 */
- (void)setSendSuccessHandler:(LZConnectionSendSuccessHandler)sendSuccessHandler;

/*
 发送消息失败
 */
- (void)setSendFailureHandler:(LZConnectionSendFailureHandler)sendFailureHandler;

/*
 重新发送消息
 */
- (void)setResendMessageHandler:(LZResendMessageHandler)resendMessageHandler;

/*
 长连接返回值处理
 */
- (void)setLongPullResultHandler:(LZLongPullResultHandler)longPullResultHandler;

/**
 *  以Get模式调用WebApi(不需要队列模式)
 *
 *  @param sendDataDic 包含：webapicontroller，routepath，data，moduleserver
 */
-(void)sendToServer:(NSMutableDictionary *)sendDataDic;

/**
 *  以Get模式调用WebApi(采用队列模式)
 *
 *  @param sendDataDic 包含：webapicontroller，routepath，data，moduleserver
 */
-(void)sendToServerQueue:(NSMutableDictionary *)sendDataDic;

-(void)removeAllWebApi;

@end


