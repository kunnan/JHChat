//
//  PostNotificationModel.h
//  LeadingCloud
//
//  Created by wang on 16/3/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-03-23
 Version: 1.0
 Description: 动态提醒模型
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "PostNotificationParamModel.h"

@interface PostNotificationModel : NSObject

// 新增字段
@property(nonatomic,strong)NSString *notificationparams;
/*动态id*/
@property(nonatomic,strong)NSString *receivepid;
/*用户id*/
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *userface;
@property(nonatomic,strong)NSString *username;


/*主键*/
@property(nonatomic,strong)NSString *nid;
/*发送时间*/
@property(nonatomic,strong)NSDate *senddatetime;
@property(nonatomic,strong)NSString *sendDateString;
/*用户模型*/
@property(nonatomic,strong)NSDictionary *notificationparamsdic;
/*回复模型*/
@property(nonatomic,strong)NSDictionary *posttemplatedatadic;

@property(nonatomic,strong)NSString *posttemplateid;

@property(nonatomic,strong)PostNotificationParamModel *paramModel;

@property(nonatomic,strong)NSString *expandtag;
@property(nonatomic,strong)NSString *expandtagtype;
@property(nonatomic,strong)NSString *notificationtype;
@property(nonatomic,strong)NSString *receiverid;


@end
