//
//  TodolistModel.h
//  LeadingCloud
//
//  Created by wang on 2017/12/21.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface TodolistModel : NSObject
//主键id
@property (nonatomic,strong)NSString *tlid;
//所属用户id
@property (nonatomic,strong)NSString *userid;
//所属办理类型，如，各自应用在message_type 表中的code字段值，审批：lznotice.approval.newapproval
@property (nonatomic,strong)NSString *templatecode;
//所属应用
@property (nonatomic,strong)NSString *appcode;
//待办数量
@property (nonatomic,assign)NSInteger badge;
//最近的消息
@property (nonatomic,strong)NSString *lastmsg;
//最近的消息时间
@property (nonatomic,strong)NSString *lastdate;
//所属条目id
@property (nonatomic,strong)NSString *tliid;
//企业id
@property (nonatomic,strong)NSString *orgid;
//头像
@property (nonatomic,strong)NSString *face;
//头像背景色
@property (nonatomic,strong)NSString *backcolor;
//联系人名称
@property (nonatomic,strong)NSString *contactname;

@property (nonatomic,strong)NSString *baselinkconfig;


@end
