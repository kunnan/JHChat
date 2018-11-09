//
//  UserModel.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/3.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  wch dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 用户表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface UserModel : NSObject

/* 用户ID */
@property(nonatomic,strong) NSString *uid;
/* 姓名 */
@property(nonatomic,strong) NSString *username;
/* 登录名*/
@property(nonatomic,strong) NSString *loginname;
/* 手机 */
@property(nonatomic,strong) NSString *mobile;
/* 邮箱 */
@property(nonatomic,strong) NSString *email;
/* 联系地址 */
@property(nonatomic,strong) NSString *address;
/* 注册类型 */
@property(nonatomic,assign) NSInteger regtype;
/* 生日 */
@property(nonatomic,strong) NSDate *birthday;
/* 微信 */
@property(nonatomic,strong) NSString *wechat;
/* 微博 */
@property(nonatomic,strong) NSString *weibo;
/* qq号 */
@property(nonatomic,strong) NSString *qq;
/* 头像JSON */
@property(nonatomic,strong) NSString *face;
/* 是否绑定手机 */
@property(nonatomic,assign) NSInteger isbindphone;
/* 是否绑定Email */
@property(nonatomic,assign) NSInteger isbindemail;
/* 用户注册时间 */
@property(nonatomic,strong) NSDate *addtime;
/* 全称 */
@property(nonatomic,strong) NSString *quancheng;
/* 简称 */
@property(nonatomic,strong) NSString *jiancheng;
/* 性别 */
@property(nonatomic,assign) NSInteger gender;
/* 省份 */
@property(nonatomic,strong) NSString *province;
/* 城市 */
@property(nonatomic,strong) NSString *city;
/* 地区 */
@property(nonatomic,strong) NSString *county;

/* 是否为管理员 */
@property(nonatomic,assign) NSInteger isadmin;

/* 岗位ID(选择人员、岗位时使用) */
@property(nonatomic,strong) NSString *pid;

/* 组织基准岗位(职务)ID(选择人员、岗位时使用) */
@property(nonatomic,strong) NSString *obpid;

/* 部门ID(选择人员、岗位时使用) */
@property(nonatomic,strong) NSString *oid;

/* 办公电话 */
@property(nonatomic,strong) NSString *officecall;

/* 绑定微信标识 */
@property(nonatomic,strong) NSString *wxunionid;
/* 绑定qq标识 */
@property(nonatomic,strong) NSString *qqunionid;
/* 绑定web标识 */
@property(nonatomic,strong) NSString *webounionid;



@end
