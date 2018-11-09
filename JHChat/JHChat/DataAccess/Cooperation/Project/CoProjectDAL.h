//
//  CoProjectDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 项目数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "CoProjectModel.h"

@interface CoProjectDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoProjectDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createCoProjectTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoProjectTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)projectArray;

/**
 *  添加单条数据
 */
-(void)addProjectModel:(CoProjectModel *)projectModel;
;

#pragma mark 查询
/**
 *  查询本独
 *
 *  @param oid       企业ID
 *  @param searchStr 搜索
 *  @param condition 条件
 *
 *  @return
 */
- (NSMutableArray*)getDataArrayOid:(NSString*)oid Search:(NSString*)searchStr Condition:(NSInteger)condition;

/**
 *  得到项目详情
 *
 *  @param pid 项目ID
 *
 *  @return
 */
- (CoProjectModel*)getProjectModelPid:(NSString*)pid;

#pragma mark 删除

/**
 *  删除单条项目
 *
 *  @param pid 项目ID
 */
- (void)delsingleProjectPid:(NSString*)pid;

/**
 *  删除当前企业下所有项目
 *
 *  @param oid 企业ID
 */
- (void)delAllProjectionOid:(NSString*)oid;

#pragma mark 更新数据
/**
 *  更新项目名称
 *
 *  @param name 名称
 *  @param pid  项目ID
 */
- (void)upDataProjectName:(NSString*)name Pid:(NSString*)pid;
/**
 *  修改项目描述
 *
 *  @param des 项目描述
 *  @param pid 项目ID
 */
- (void)upDataProjectDes:(NSString*)des Pid:(NSString*)pid;

/**
 *  修改项目开始时间
 *
 *  @param startTime 开始时间
 *  @param pid       项目ID
 */
- (void)upDataProjectStartTime:(NSString*)startTime Pid:(NSString*)pid;

/**
 *  修改项目结束时间
 *
 *  @param endTime   结束时间
 *  @param pid       项目ID
 */
- (void)upDataProjectEndTime:(NSString*)endTime Pid:(NSString*)pid;

/**
 *  修改项目当前转态
 *
 *  @param state 项目状态
 *  @param pid   项目ID
 */
- (void)upDataProjectState:(NSInteger)state Pid:(NSString*)pid;

/**
 *  修改项目企业ID
 *
 *  @param state 项目状态
 *  @param pid   项目ID
 */
- (void)upDataProjectOid:(NSString*)oid Pid:(NSString*)pid;

@end
