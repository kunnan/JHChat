//
//  OrgUserApplyModel.h
//  LeadingCloud
//
//  Created by dfl on 16/5/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-05-30
 Version: 1.0
 Description: 用户申请加入组织成员表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface OrgUserApplyModel : NSObject

/* 主键 */
@property(nonatomic,strong) NSString *ouaid;
/* 用户ID */
@property(nonatomic,strong) NSString *uid;
/* 组织ID */
@property(nonatomic,strong) NSString *oid;
/* 申请时间 */
@property(nonatomic,strong) NSDate *applytime;
/* 用户职务 */
@property(nonatomic,strong) NSString *position;
/* 所属企业 */
@property(nonatomic,strong) NSString *oeid;
/* 组织全称 */
@property(nonatomic,strong) NSString *name;
/* 企业名称 */
@property(nonatomic,strong) NSString *entername;
/* 头像 */
@property(nonatomic,strong) NSString *face;
/* 用户名称 */
@property(nonatomic,strong) NSString *username;
/* 手机号码 */
@property(nonatomic,strong) NSString *mobile;
/* 邮箱 */
@property(nonatomic,strong) NSString *email;
/* 0未操作；1同意；2拒绝；*/
@property(nonatomic,assign) NSInteger result;
/* 审核者用户名称 */
@property(nonatomic,strong) NSString *actionusername;
/* 审核者id */
@property(nonatomic,strong) NSString *actionuid;
/* 审核操作时间 */
@property(nonatomic,strong) NSDate *actiontime;

@end
