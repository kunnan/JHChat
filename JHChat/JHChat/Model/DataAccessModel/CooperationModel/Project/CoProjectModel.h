//
//  CoProjectModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 项目表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface CoProjectModel : NSObject

/* 项目ID */
@property(nonatomic,strong) NSString *prid;
/* 协作ID */
@property(nonatomic,strong) NSString *cid;
/* 项目名称 */
@property(nonatomic,strong) NSString *name;
/* 项目状态  1 进行 2 完成 3 废弃*/
@property(nonatomic,assign) NSInteger state;
//项目封面，项目logo
@property(nonatomic,strong) NSString *coverpic;
//管理员ID
@property(nonatomic,copy) NSString *adminid;
//是否被收藏
@property(nonatomic,assign) BOOL isfavorites;
/* 计划开始时间 */
@property(nonatomic,strong) NSDate *planbegindate;
/* 计划结束时间 */
@property(nonatomic,strong) NSDate *planenddate;
//创建时间
@property(nonatomic,strong) NSDate *createdate;

@property(nonatomic,strong)NSString *oid;

@property(nonatomic,strong)NSString *des;

@property(nonatomic,strong)NSString *resourceid;

@property(nonatomic,assign)NSInteger memberslength;


@end
