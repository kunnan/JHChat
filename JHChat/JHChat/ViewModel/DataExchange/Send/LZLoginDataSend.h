//
//  LZLoginDataSend.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/26.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-26
 Version: 1.0
 Description: 完成登录后需要发送的请求
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZBaseSend.h"
#import "EventBus.h"
#import "EventPublisher.h"

@interface LZLoginDataSend : LZBaseSend<EventSyncPublisher>

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(LZLoginDataSend *)shareInstance;

/**
 *  发送登录时需要获取的数据api
 */
-(void)sendForLoginData_Before;

@end
