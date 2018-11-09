//
//  OrgUserModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 组织人员表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "UserModel.h"

@interface OrgUserModel : NSObject

/* 主键 */
@property(nonatomic,strong) NSString *ouid;
/* 组织ID */
@property(nonatomic,strong) NSString *oid;
/* 用户ID */
@property(nonatomic,strong) NSString *uid;
/* 申请加入时间 */
@property(nonatomic,strong) NSDate *applytime;
/* 审核通过时间 */
@property(nonatomic,strong) NSDate *jointime;
/* 用户状态（待审核,正常,禁用,未激活) */
@property(nonatomic,assign) NSInteger state;
/* 职务 */
@property(nonatomic,strong) NSString *position;
/* 所属组织ID */
@property(nonatomic,strong) NSString *oeid;
/*头像id*/
@property(nonatomic,copy)NSString* face;

/*头像id*/
@property(nonatomic,copy)NSString* faceid;
/*用户名简称*/
@property(nonatomic,copy)NSString* jiancheng;
/*用户名全称*/
@property(nonatomic,copy)NSString* quancheng;
/*用户名*/
@property(nonatomic,copy)NSString* username;
/* 是否为管理员 */
@property(nonatomic,assign) NSInteger isadmin;

/* 用户的详细信息 */
@property(nonatomic,strong) NSString *usermodelstr;
/* 是否公开手机号码 */
@property(nonatomic,assign) BOOL openmobile;


/* User的Model */
- (UserModel *)userModel;

@end
