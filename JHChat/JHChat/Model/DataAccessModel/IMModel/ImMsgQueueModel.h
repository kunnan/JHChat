//
//  ImMsgQueueModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-11
 Version: 1.0
 Description: 消息发送队列表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface ImMsgQueueModel : NSObject

/* 主键 */
@property(nonatomic,strong) NSString *mqid;
/* 消息模块 */
@property(nonatomic,strong) NSString *module;
/* 路由 */
@property(nonatomic,strong) NSString *route;
/* 发送数据 */
@property(nonatomic,strong) NSString *data;
/* 加入队列时间 */
@property(nonatomic,strong) NSDate *createdatetime;
/* 更新队列时间 */
@property(nonatomic,strong) NSDate *updatedatetime;
/* 状态 */
@property(nonatomic,assign) NSInteger status;

@end
