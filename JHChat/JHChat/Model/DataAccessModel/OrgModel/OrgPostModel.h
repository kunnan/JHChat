//
//  OrgPostModel.h
//  LeadingCloud
//
//  Created by dfl on 16/11/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-11-30
 Version: 1.0
 Description: 岗位表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "UserBasicModel.h"

@interface OrgPostModel : NSObject

/* 岗位id */
@property(nonatomic,strong) NSString *pid;
/* 岗位名称 */
@property(nonatomic,strong) NSString *name;
/* 描述 */
@property(nonatomic,strong) NSString *bewrite;
/* 组织机构id */
@property(nonatomic,strong) NSString *oid;
/* 企业id */
@property(nonatomic,strong) NSString *eid;
/* 基准岗位 */
@property(nonatomic,strong) NSString *bpid;
/* 创建日期 */
@property(nonatomic,strong) NSDate *createtime;
/* 修改日期 */
@property(nonatomic,strong) NSDate *updatetime;

/* 用户基本信息数据 */
@property(nonatomic,strong) UserBasicModel *userBasicModel;

/* 用户ID(选择人员、岗位时使用) */
@property(nonatomic,strong) NSString *uid;
/* 组织基准岗位(职务)ID(选择人员、岗位时使用) */
@property(nonatomic,strong) NSString *obpid;


@end
