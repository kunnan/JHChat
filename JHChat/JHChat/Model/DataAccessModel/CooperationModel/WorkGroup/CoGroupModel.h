//
//  CoGroupModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 群组表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface CoGroupModel : NSObject


/* 协作ID */
@property(nonatomic,copy)NSString *cid;
/* 创建企业id*/
@property(nonatomic,copy)NSString *oid;
/* 创建时间*/
@property(nonatomic,copy)NSDate *createtime;
/* 创建者名字*/
@property(nonatomic,copy)NSString *createuname;
/* 创建者用户id*/
@property(nonatomic,copy)NSString *createuser;
/* 工作组描述*/
@property(nonatomic,copy)NSString *des;
/* 工作组号*/
@property(nonatomic,copy)NSString *gcode;
/* 工作组ID*/
@property(nonatomic,copy)NSString *gid;
/* 工作组锁定时间*/
@property(nonatomic,copy)NSDate *lockdate;
/* 工作组锁定人*/
@property(nonatomic,copy)NSString *lockuser;
/* 工作组logo*/
@property(nonatomic,copy)NSString *logo;
/* 工作组名称*/
@property(nonatomic,copy)NSString *name;
/* 工作组是否需要审批*/
@property(nonatomic,assign)NSInteger needauditing;
/*  资源id*/
@property(nonatomic,copy)NSString *resourceid;
/*  工作组状态 0 关闭 1 开启*/
@property(nonatomic,assign)NSInteger state;


@property(nonatomic,assign)BOOL isfavorites;



//新增字段
/*成员数量*/
@property(nonatomic,assign)NSInteger memberslength;
/*超级管理员ID (创建者)*/
@property(nonatomic,strong)NSString *superadminid;
/*当前用户类型 1 创建者 2 参与者 3 观察者 4 超级管理员*/
@property(nonatomic,assign)NSInteger currentusertype;
/*当前是否为组织群组*/
@property(nonatomic,strong)NSString *bind_oid;
/*当前组织ID(数据库筛选用)*/
@property(nonatomic,strong)NSString *coid;


/* 本地筛选使用（关联工作组）*/
@property(nonatomic,assign)BOOL isLSelect;

//是否是工作组
@property(nonatomic,assign)NSInteger isgroup;
@property(nonatomic,strong)NSString *extenddefined1;
@property(nonatomic,strong)NSString *extenddefined2;
@property(nonatomic,copy)NSString *ruid;

@property(nonatomic,assign)CGFloat joinindex;
@property(nonatomic,assign)CGFloat creatindex;
@property(nonatomic,assign)CGFloat maginindex;
@property(nonatomic,assign)CGFloat closeindex;

@end
