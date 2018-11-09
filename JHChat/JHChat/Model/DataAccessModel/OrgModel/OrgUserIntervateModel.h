//
//  OrgUserIntervateModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 组织邀请成员
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface OrgUserIntervateModel : NSObject

/* 组织邀请人员主键 */
@property(nonatomic,strong) NSString *ouiid;
/* 组织ID(组织、部门) */
@property(nonatomic,strong) NSString *objid;
/* 组织ID */
@property(nonatomic,strong) NSString *objoeid;
/* 邀请用户邮箱 */
@property(nonatomic,strong) NSString *email;
/* 邀请时间 */
@property(nonatomic,strong) NSDate *intervatedate;
 /* 0未注册；1已注册 */
@property(nonatomic,assign) NSInteger regtype;
/* 邀请用户手机号码 */
@property(nonatomic,strong) NSString *mobile;
/* 用户ID */
@property(nonatomic,strong) NSString *uid;
/* 主体类型 0：邮箱邀请人员；1：手机邀请人员 */
@property(nonatomic,assign) NSInteger objtype;
/* 事件发出者 */
@property(nonatomic,strong) NSString *senduid;
/* 用户名称 */
@property(nonatomic,strong) NSString *username;
/* 职位 */
@property(nonatomic,strong) NSString *position;
/* 组织部门名称 */
@property(nonatomic,strong) NSString *depname;
/* 组织名称 */
@property(nonatomic,strong) NSString *entername;
/* 0:未操作、1:已同意、2:已拒绝 */
@property(nonatomic,assign) NSInteger result;
/* logo */
@property(nonatomic,strong) NSString *logo;
/* 操作时间 */
@property(nonatomic,strong) NSDate *actiondate;
/* 撤销者uid */
@property(nonatomic,strong) NSString *revokeuid;
/* 撤销者用户名 */
@property(nonatomic,strong) NSString *revokeusername;


@end
