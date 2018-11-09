//
//  ImRecentModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 最近消息表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface ImRecentModel : NSObject

/* 主键 */
@property(nonatomic,strong) NSString *irid;
/* 联系人ID */
@property(nonatomic,strong) NSString *contactid;
/* 联系人名称 */
@property(nonatomic,strong) NSString *contactname;
/* 联系人类型(0:单人，1:群组 2:其它群组) */
@property(nonatomic,assign) NSInteger contacttype;
/* 群组关联类型(0:组 1:项 2:任 3:部 4:企) */
@property(nonatomic,assign) NSInteger relatetype;
/* 头像ID */
@property(nonatomic,strong) NSString *face;
/* 最后时间 */
@property(nonatomic,strong) NSDate *lastdate;
/* 最后消息 */
@property(nonatomic,strong) NSString *lastmsg;
/* 最后消息发送人 */
@property(nonatomic,strong) NSString *lastmsguser;
/* 最后消息发送人的姓名 */
@property(nonatomic,strong) NSString *lastmsgusername;
/* 未查看数字 */
@property(nonatomic,assign) NSInteger badge;
/* 是否删除 */
@property(nonatomic,assign) NSInteger isdel;
/*  自动下载聊天记录的时间 */
@property(nonatomic,strong) NSDate *autodownloaddate;
/* 是否置顶 */
@property(nonatomic,assign) NSInteger issettop;
/* 是否被@ */
@property(nonatomic,assign) NSInteger isremindme;
/* 最后一条消息是不是没有被撤回的接收的回执消息 */
@property(nonatomic, assign) NSInteger isrecordmsgnorecallreceive;
/* 聊天记录下载到的位置synck */
@property(nonatomic,strong) NSString *presynck;
/* synck的时间 */
@property(nonatomic,strong) NSDate *presynckdate;
/* 是否在此群组中 */
@property(nonatomic,assign) NSInteger isexistsgroup;

/* 0:只给消息发送   1:只给其它应用发送  2:同时给消息和其它应用发送 */
@property(nonatomic,assign) NSInteger showmode;
/* 最后一条消息的ID */
@property (nonatomic, strong) NSString *lastmsgid;
/* 0：一级消息  1：二级消息 */
@property (nonatomic, assign) NSInteger  parsetype;
/* 业务ID */
@property (nonatomic, strong) NSString *bkid;
/* 是否是回执消息 */
@property (nonatomic, assign) NSInteger isrecordmsg;


/* 是否免打扰消息 */
@property(nonatomic,assign) NSInteger isdisturb;
/* 群组是否正在通话 */
@property(nonatomic,assign) NSInteger isvideocalling;
/* 群人员数量 */
@property(nonatomic,assign) NSInteger usercount;
/* 发送状态 */
@property(nonatomic,assign) NSInteger sendstatus;
/* 是否置顶 */
@property(nonatomic, copy) NSString *stick;

@property(nonatomic, copy) NSString *isonedisturb;

@end
