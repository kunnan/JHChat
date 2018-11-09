//
//  OrgEnterPriseModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 组织表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface OrgEnterPriseModel : NSObject

/* 组织ID */
@property(nonatomic,strong) NSString *eid;
/* 上级组织ID */
@property(nonatomic,strong) NSString *epid;
/* 组织号 */
@property(nonatomic,strong) NSString *ecode;
/* 组织名称 */
@property(nonatomic,strong) NSString *name;
/* 组织简称 */
@property(nonatomic,strong) NSString *shortname;
/* 组织简介 */
@property(nonatomic,strong) NSString *descript;
/* 省份 */
@property(nonatomic,strong) NSString *province;
/* 城市 */
@property(nonatomic,strong) NSString *city;
/* 县 */
@property(nonatomic,strong) NSString *county;
/* 省份名称 */
@property(nonatomic,strong) NSString *provincename;
/* 城市名称 */
@property(nonatomic,strong) NSString *cityname;
/* 县名称 */
@property(nonatomic,strong) NSString *countyname;
/* 创建人 */
@property(nonatomic,strong) NSString *createuser;
/* 创建日期 */
@property(nonatomic,strong) NSDate *createdate;
/* 详细地址 */
@property(nonatomic,strong) NSString *detailaddress;
/* 设置(logo) */
@property(nonatomic,strong) NSString *setup;
/* 组织机构代码 */
@property(nonatomic,strong) NSString *regorgcode;
/* 工商营业注册号 */
@property(nonatomic,strong) NSString *regiccode;
/* 组织类型 */
@property(nonatomic,assign) NSInteger regtype;
/* 成立日期 */
@property(nonatomic,strong) NSDate *regdate;
/* 法定代表人 */
@property(nonatomic,strong) NSString *reglegalperson;
/* 省份 */
@property(nonatomic,strong) NSString *regprovince;
/* 城市 */
@property(nonatomic,strong) NSString *regcity;
/* 县级 */
@property(nonatomic,strong) NSString *regcounty;
/* 详细地址 */
@property(nonatomic,strong) NSString *regdetailaddress;
/* 组织营业执照 */
@property(nonatomic,strong) NSString *reglicense;
/* 组织实名状态（0:未实名；1:实名） */
@property(nonatomic,assign) NSInteger regstate;
/* 用户总数（正常+待激活） */
@property(nonatomic,assign) NSInteger userallcount;
/* 组织下所有待审核成员数 */
@property(nonatomic,assign) NSInteger unauditallcount;
/* 组织logo信息 */
@property(nonatomic,strong) NSString *logo;
/**
 *  是否为组织管理员
 */
@property(nonatomic,assign) NSInteger isenteradmin;
/* 当前用户在此企业下的名称 */
@property(nonatomic,strong) NSString *username;
/* 是否为管理员 */
@property(nonatomic,assign) NSInteger isadmin;

@end
