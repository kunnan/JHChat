//
//  CoTaskPhaseDAL.h
//  LeadingCloud
//
//  Created by wang on 16/2/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-02-25
 Version: 1.0
 Description: 任务环节表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "LZFMDatabase.h"
#import "CoTaskPhaseModel.h"

@interface CoTaskPhaseDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoTaskPhaseDAL *)shareInstance;


/**
 *  创建表
 */
-(void)createCoTaskPhaseIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoTaskPhaseTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)phaseArray;

/**
 *  添加单条数据
 */
-(void)addPhase:(CoTaskPhaseModel *)pModel;

#pragma mark - 删除数据

/**
 *  根据id删除检查点
 *
 *  @param
 */
-(void)deletePhaseId:(NSString*)pid;


/**
 *  根据任务id删除所有检查点
 *
 *  @param
 */
-(void)deleteAllPhaseTaskId:(NSString*)tid;


#pragma mark - 修改数据
/**
    修改节点状态
 *  @param tid              任务ID
 *  @param phid             节点ID
 *  @param state            状态字段
 *  @param activecount      状态字段

 */
-(void)upDataTaskPhaseState:(NSInteger)state Activecount:(NSInteger)activecount TaskID:(NSString*)tid Phid:(NSString*)phid;


/**
 修改节点描述（name）
 *  @param tid              任务ID
 *  @param phid             节点ID
 *  @param des              状态描述
 
 */
-(void)upDataTaskPhaseDes:(NSString*)des TaskID:(NSString*)tid Phid:(NSString*)phid;

/**
 修改节点提示（des 内容）
 *  @param tid              任务ID
 *  @param phid             节点ID
 *  @param tip              状态提示
 
 */
-(void)upDataTaskPhaseTip:(NSString*)tip TaskID:(NSString*)tid Phid:(NSString*)phid;

/**
 修改节时间（时间）
 *  @param tid              任务ID
 *  @param phid             节点ID
 *  @param datelimit        节点时间
 
 */
-(void)upDataTaskPhaseDatelimit:(NSDate*)datelimit TaskID:(NSString*)tid Phid:(NSString*)phid;

/**
 修改节点管理员
 *  @param tid              任务ID
 *  @param phid             节点ID
 *  @param datelimit        管理员ID
 
 */
-(void)upDataTaskPhaseChief:(NSString*)chief TaskID:(NSString*)tid Phid:(NSString*)phid;

#pragma mark - 查询数据

/**
 *  得到节点详情
 *
 *  @param pid 节点id
 *
 *  @return
 */
-(CoTaskPhaseModel*)getDataTaskPhaseModelPid:(NSString*)pid;

/**
    得到任务检查点
 *  @param tid      任务ID
 */
-(NSMutableArray*)getphaseTaskId:(NSString*)tid;

@end
