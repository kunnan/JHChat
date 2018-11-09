//
//  CoTaskModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  wzb
 Date：   2015-12-21
 Version: 1.0
 Description: 任务表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface CoTaskModel : NSObject
/*协作ID*/
@property(nonatomic,strong) NSString *cid;
/* 任务ID */
@property(nonatomic,strong) NSString *tid;
/*创建时间*/
@property(nonatomic,strong) NSDate *createdate;
/* 创建者名字*/
@property(nonatomic,strong) NSString *createuname;
/* 创建者id*/
@property(nonatomic,strong) NSString *createuser;
/*任务描述*/
@property(nonatomic,strong) NSString *des;
/*任务结束时间*/
@property(nonatomic,strong) NSDate *enddate;
/*计划时间*/
@property(nonatomic,strong) NSDate *plandate;
/*父任务id*/
@property(nonatomic,strong) NSString *pid;
/*锁定时间*/
@property(nonatomic,strong) NSDate *lockdate;
/*锁定者id*/
@property(nonatomic,strong) NSString *lockuser;
/*任务名称*/
@property(nonatomic,strong) NSString *name;
/*任务创建企业id*/
@property(nonatomic,strong) NSString *oid;
/*任务资源id*/
@property(nonatomic,strong) NSString *resourceid;
/*任务状态 1未发布 2 已发布 3 完成 4 废弃 5 暂停*/
@property(nonatomic,assign) NSInteger state;
/*任务是否收藏*/
@property(nonatomic,assign) NSInteger isfavorites;
/*人数*/
@property(nonatomic,assign) NSInteger memberslength;
/*管理员id*/
@property(nonatomic,strong) NSString *adminid;


/*任务头像 （外部使用）*/
@property(nonatomic,strong) NSString *face;


@property(nonatomic,assign) NSInteger istask;
//任务英文名字
@property(nonatomic,strong) NSString *englishname;
//任务头像
@property(nonatomic,strong) NSString *logo;
@property(nonatomic,strong) NSString *ruid;

@property(nonatomic,assign) NSInteger finishcount;

@property(nonatomic,assign) NSInteger count;
@property(nonatomic,strong) NSString *dep;

@property(nonatomic,strong) NSString *deptname;


@property(nonatomic,strong) NSString *rootid;
@property(nonatomic,strong) NSString *rootname;
@property(nonatomic,strong) NSString *pname;

@property(nonatomic,strong) NSString *tcode;

@property(nonatomic,assign) BOOL needauditing;



@end
