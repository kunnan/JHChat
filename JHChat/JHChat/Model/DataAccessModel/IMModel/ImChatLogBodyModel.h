//
//  ImChatLogBodyModel.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/31.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-31
 Version: 1.0
 Description: 聊天日志表Body字段模型
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "ImChatLogBodyInnerModel.h"

@interface ImChatLogBodyModel : NSObject

/* 接收范围类型(0:用户 1:群组id) */
@property(nonatomic,assign) NSInteger totype;
/* 接收范围 */
@property(nonatomic,strong) NSString *to;
/* 消息类型 */
@property(nonatomic,strong) NSString *msgtype;
/* 消息内容 */
@property(nonatomic,strong) NSString *content;
/* 发送时间 */
@property(nonatomic,strong) NSString *senddatetime;
/* 发送范围类型 */
@property(nonatomic,assign) NSInteger fromtype;
/* 发送范围 */
@property(nonatomic,strong) NSString *from;
/* 发送人姓名 */
@property (nonatomic, copy) NSString *sendusername;
/* 发送人头像 */
@property (nonatomic, copy) NSString *senduserface;
/* 客户端ID */
@property(nonatomic,strong) NSString *clientid;
/* 处理类型 */
@property(nonatomic,strong) NSString *handlertype;
/* 消息Id */
@property(nonatomic,strong) NSString *msgid;
/* 客户端类型:PC-0；IOS-1；Androi-2 */
@property(nonatomic,strong) NSString *clienttype;
/* 所属用户 */
@property(nonatomic,strong) NSString *belongto;
/* 业务主键 */
@property(nonatomic,strong) NSString *bkid;
/* 状态 */
@property(nonatomic,assign) NSInteger status;
/* 其它信息 */
@property(nonatomic,strong) NSMutableDictionary *body;

/* @信息 */
@property (nonatomic, strong) NSMutableArray *at;

/* 客户端生成的临时ID */
@property(nonatomic,strong) NSString *clienttempid;
/* 文件信息 */
@property(nonatomic,strong) NSString *fileinfo;
/* 语音信息 */
@property(nonatomic,strong) NSString *voiceinfo;
/* 位置信息 */
@property(nonatomic,strong) NSString *geolocationinfo;
/* 已读信息 */
@property(nonatomic,strong) NSString *readstatus;
/* 系统消息 */
@property(nonatomic,strong) NSString *systemmsg;
/* app */
@property (nonatomic, copy) NSString *app;
/* 0:只给消息发送   1:只给其它应用发送  2:同时给消息和其它应用发送 */
@property(nonatomic,assign) NSInteger sendmode;
/* 0：一级消息 1：二级消息 */
@property(nonatomic,assign) NSInteger parsetype;
/* 消息是否回执 */
@property (nonatomic, copy) NSString *isrecordstatus;

/* Body的Model */
- (ImChatLogBodyInnerModel *)bodyModel;

/* 文件信息Model */
- (ImChatLogBodyFileModel *)fileModel;
/* 语音信息Model */
- (ImChatLogBodyVoiceModel *)voiceModel;
/* 位置信息Model */
- (ImChatLogBodyGeolocationModel *)geolocationModel;
/* 已读信息Model */
- (ImChatLogBodyReadStatusModel *)readstatusModel;

@end
