//
//  ImChatLogModel.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 聊天日志表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "ImChatLogBodyModel.h"
#import "NSObject+JsonSerial.h"

@interface ImChatLogModel : NSObject

/* 主键 */
@property(nonatomic,strong) NSString *msgid;
/* 临时主键ID */
@property(nonatomic,strong) NSString *clienttempid;
/* 对话框ID */
@property(nonatomic,strong) NSString *dialogid;
/* 消息发送者类型 */
@property(nonatomic,assign) NSInteger fromtype;
/* 消息发送者 */
@property(nonatomic,strong) NSString *from;
/* 消息接收者类型 */
@property(nonatomic,assign) NSInteger totype;
/* 消息接收者 */
@property(nonatomic,strong) NSString *to;
/* 数据 */
@property(nonatomic,strong) NSString *body;
/* 排序使用日期 */
@property(nonatomic,strong) NSDate *showindexdate;
/* 消息类型 */
@property(nonatomic,strong) NSString *handlertype;
/* 接收的消息是否已读 */
@property(nonatomic,assign) NSInteger recvisread;
/* 发送状态 */
@property(nonatomic,assign) NSInteger sendstatus;
/* 接收状态 */
@property(nonatomic,assign) NSInteger recvstatus;
/* 消息行高度 */
@property(nonatomic,strong) NSString *heightforrow;
/* 文本消息大小 */
@property(nonatomic,strong) NSString *textmsgsize;
/* 该条消息是否撤回 */
@property (nonatomic, assign) NSInteger isrecall;
/* 是否被删除 */
@property (nonatomic, assign) NSInteger isdel;

/* 是否为最后一条消息 */
@property(nonatomic,strong) NSString *islastmsg;
/* 是否是最后一条通知 */
@property (nonatomic, copy) NSString *islastmsgornotice;

/* 该消息是否需要回执 */
@property(nonatomic, assign) NSInteger isrecordstatus;
/* @成员 */
@property(nonatomic, strong) NSString *at;



/* 数据Model */
@property(nonatomic,strong,readonly) ImChatLogBodyModel *imClmBodyModel;

@end
