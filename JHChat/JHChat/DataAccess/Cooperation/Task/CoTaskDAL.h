//
//  CoTaskDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 任务数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "CoTaskModel.h"


@interface CoTaskDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoTaskDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createCoTaskTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoTaskTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)taskArray;

/**
 *  添加单条数据
 */
-(void)addTaskModel:(CoTaskModel *)taskModel;
#pragma mark - 删除数据

/**
 *  根据id删除任务
 *
 *  @param
 */
-(void)deleteOid:(NSString*)oid Taskid:(NSString *)tid;

/**
 *  根据id删除任务
 *
 *  @param
 */
-(void)deleteTaskid:(NSString *)tid;
/**
 *  删除全部任务
 *
 *  @param
 */
-(void)deleteAllTaskDataOid:(NSString*)oid;

/**
 *  删除我参与的任务
 *
 *  @param
 */
-(void)deleteMyJoinTaskDataOid:(NSString*)oid;
/**
 *  删除我负责的任务
 *
 *  @param
 */
-(void)deleteMyChargeTaskDataOid:(NSString*)oid;

/**
 *  删除我托付的任务
 *
 *  @param
 */
-(void)deleteMyTransferTaskDataOid:(NSString*)oid;
/**
 *  删除星标任务
 *
 *  @param
 */
-(void)deleteStarTaskDataOid:(NSString*)oid;

/**
 *  删除废弃任务
 *
 *  @param
 */
-(void)deleteAbandonTaskDataOid:(NSString*)oid;

/**
 *  删除完成任务
 *
 *  @param
 */
-(void)deleteFinishTaskDataOid:(NSString*)oid;

/**
 *  删除未发布的任务
 *
 *  @param
 */
-(void)deleteUnpublishTaskDataOid:(NSString*)oid;

/**
 *  删除子任务
 *
 *  @param
 */
-(void)deleteAllChildTaskTid:(NSString*)tid;
#pragma mark - 修改数据

/**
 修改任务状态
 *  @param tid      任务ID
 *  @param state    任务状态
 */
-(void)updateTaskStateTid:(NSString *)tid withState:(NSInteger)state ;

/**
    修改任务计划时间
 *  @param tid      任务ID
 *  @param plandate    任务状态
 */
-(void)updateTaskPlanDateTid:(NSString *)tid withDate:(NSDate*)plandate;

/**
    修改任务名称
 *  @param tid      任务ID
 *  @param name     任务名称
 */
-(void)updateTaskNameTid:(NSString *)tid withName:(NSString*)name;

/**
    修改任务所在企业
 *  @param tid      任务ID
 *  @param oid      任务所在企业
 */
-(void)updateTaskCompanyTid:(NSString *)tid Oid:(NSString*)oid;

/**
 *  更改任务的父任务
 *
 *  @param tid 任务ID
 *  @param pid 父任务ID
 */
-(void)updataTaskParentTid:(NSString*)tid Pid:(NSString*)pid;

/**
 *  更改任务的描述
 *
 *  @param tid 任务ID
 *  @param des 任务描述
 */
-(void)updataTaskDescribeTid:(NSString*)tid Des:(NSString*)des;

/**
 *  更改任务的收藏
 *
 *  @param tid 任务ID
 *  @param isfavorites 任务收藏状态
 */
-(void)updataTaskFavoriteTid:(NSString*)tid Isfavorites:(NSInteger)isfavorites;

/**
 *  更改任务的锁定
 *
 *  @param tid 任务ID
 *  @param des 任务描述
 */
-(void)updataTaskLock:(NSString*)tid LockUser:(NSString*)lockUser;

/**
 *  更改任务成员数量
 *
 *  @param tid 任务ID
 *  @param mlength 任务成员数量
 */
-(void)updataTaskMemberCount:(NSString*)tid MemberLength:(NSInteger)mlength;


/**
 修改任务加入权限
 *  @param tid        任务ID
 *  @param isApply    权限
 */
-(void)updateTaskId:(NSString *)tid withTaskApplyroot:(NSNumber *)isApply;

#pragma mark - 查询数据

/**
 *  根据任务id 得到任务基本信息
 *
 *  @param tid 任务id
 *
 *  @return 
 */
-(CoTaskModel*)getDataTaskModelTid:(NSString*)tid;
-(CoTaskModel*)getDataTaskModelCid:(NSString*)Cid;

/**
 子任务
 *  @param uid      任务ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getChildTaskID:(NSString*)taskID;

/**
    我负责的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20

 */
-(NSMutableArray*)getMyChargeUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count;

/**
    我参与的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getMyPartUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count;

/**
    我观察的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getMyObserveUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count;


/**
    未发布的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getMyUnPublishUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count;


/**
    标星的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getMyStarUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count;

/**
    我托付任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getMyTransferUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count;

/**
   完成的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getFinshUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count;

/**
  废弃的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getAbandonUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count;

/**
 某任务下是否存在父任务
 
 @param cid 协作id
 
 @return return value description
 */
-(BOOL)isHaveParendTaskWithCid:(NSString*)cid;
/**
 *  根据任务id 得到任务jeson
 *
 *  @param tid 任务tid
 *
 *  @return
 */
-(NSMutableDictionary*)getJeson:(NSString *)tid;

@end
