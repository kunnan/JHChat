//
//  OrgModel.h
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

@interface OrgModel : NSObject

/* 组织ID */
@property(nonatomic,strong) NSString *oid;
/* 上级组织ID */
@property(nonatomic,strong) NSString *opid;
/* 组织名称 */
@property(nonatomic,strong) NSString *name;
/* 显示名称 */
@property(nonatomic,strong) NSString *shortname;
/* 结构编号 */
@property(nonatomic,strong) NSString *code;
/* 创建人 */
@property(nonatomic,strong) NSString *createuser;
/* 创建日期 */
@property(nonatomic,strong) NSDate *createdate;
/* 描述 */
@property(nonatomic,strong) NSString *descript;
/* 启用状态 */
@property(nonatomic,assign) NSInteger state;
/* 类型 */
@property(nonatomic,assign) NSInteger type;
/* 顺序号 */
@property(nonatomic,assign) NSInteger sort;
/* 所属组织 */
@property(nonatomic,strong) NSString *oeid;
/* 所属父路径 */
@property(nonatomic,strong) NSString *opath;
/* 人员数量 */
@property(nonatomic,assign) NSInteger normalcount;
/* 未激活数量 */
@property(nonatomic,assign) NSInteger unactivecount;
/* 是否显示官方群组 */
@property(nonatomic,assign) NSInteger showgroup;
/* 递归的所有子部门的正常用户数 */
@property(nonatomic,assign) NSInteger childnormalcount;
/* 递归的所有子部门的待激活用户数（组织邀请的用户数） */
@property(nonatomic,assign) NSInteger childunactivecount;

/* 岗位ID(选择人员、岗位时使用) */
@property(nonatomic,strong) NSString *pid;
/* 用户ID(选择人员、岗位时使用) */
@property(nonatomic,strong) NSString *uid;
/* 组织基准岗位(职务)ID(选择人员、岗位时使用) */
@property(nonatomic,strong) NSString *obpid;


@end
