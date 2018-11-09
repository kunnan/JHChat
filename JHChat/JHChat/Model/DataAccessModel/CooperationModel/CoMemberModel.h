//
//  CoMemberModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 成员表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

typedef NS_ENUM(NSInteger, CooperationIdentity) {
    CoAdministrator =1,//1 管理员
    CoParticipant,// 2 成员
    CoObserver,// 3 观察者
    CoSuperadministrator,//4超级管理员

} ;

@interface CoMemberModel : NSObject


@property(nonatomic,copy)NSString *mid;
/*协作id*/
@property(nonatomic,copy)NSString *cid;
/*加入时间*/
@property(nonatomic,copy)NSDate *addtime;
/*部门名称*/
@property(nonatomic,copy)NSString *deptname;
/*部门id*/
@property(nonatomic,copy)NSString *did;
/*头像ID*/
@property(nonatomic,copy)NSString *face;
/*简称*/
@property(nonatomic,copy)NSString *jiancheng;
/*企业id*/
@property(nonatomic,copy)NSString *oid;
/*企业名称*/
@property(nonatomic,copy)NSString *orgname;
/*全称*/
@property(nonatomic,copy)NSString *quancheng;
/*用户名称*/
@property(nonatomic,copy)NSString *uname;
/*用户id*/
@property(nonatomic,copy)NSString *uid;
/*1 管理员 2 成员 3 观察者 4 超级管理员*/
@property(nonatomic,assign)NSInteger utype;
/* 0 未通过 通过状态*/
@property(nonatomic,assign)NSInteger isvalid;


@property(nonatomic,assign)NSInteger type;
//描述
@property(nonatomic,copy)NSString *des;
@property(nonatomic,copy)NSString *cuid;


//外部使用 1 选中 0 未选中 2 不可选
@property(nonatomic,assign)NSInteger selectState;

@end
