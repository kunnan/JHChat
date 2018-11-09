//
//  OrgBasePostModel.h
//  LeadingCloud
//
//  Created by dfl on 2017/6/16.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2017-06-16
 Version: 1.0
 Description: 岗职务表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface OrgBasePostModel : NSObject

/* 职务id */
@property(nonatomic,strong) NSString *obpid;
/* 职务名称 */
@property(nonatomic,strong) NSString *name;
/* 描述 */
@property(nonatomic,strong) NSString *bewrite;
/* 企业id */
@property(nonatomic,strong) NSString *eid;
/* 创建日期 */
@property(nonatomic,strong) NSDate *createtime;
/* 修改日期 */
@property(nonatomic,strong) NSDate *updatetime;

/* 岗位ID(选择人员、岗位时使用) */
@property(nonatomic,strong) NSString *pid;
/* 用户ID(选择人员、岗位时使用) */
@property(nonatomic,strong) NSString *uid;
/* 部门ID(选择人员、岗位时使用) */
@property(nonatomic,strong) NSString *oid;

@end
