//
//  CoTaskRelatedDAL.h
//  LeadingCloud
//
//  Created by wang on 16/2/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wzb
 Date：   2016-02-25
 Version: 1.0
 Description: 任务 工作组 项目 关联表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "LZFMDatabase.h"
#import "CoTaskRelatedModel.h"

@interface CoTaskRelatedDAL : LZFMDatabase


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoTaskRelatedDAL *)shareInstance;


/**
 *  创建表
 */
-(void)createCoTaskRelatedIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoTaskRelatedTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)relatedArray;

/**
 *  添加单条数据
 */
-(void)addRelated:(CoTaskRelatedModel *)rmodel;

#pragma mark - 删除数据

/**
 *  根据任务id删除关系数据
 *
 *  @param
 */
-(void)deleteAllTaskId:(NSString*)tid;

/**
 *  根据id删除关系数据
 *
 *  @param
 */
-(void)deleteRelatedId:(NSString*)rid;


/**
 *  根据任务id，关联id删除关系数据
 *
 *  @param
 */
-(void)deleteRelatedTid:(NSString*)tid Relateid:(NSString*)relateid;

#pragma mark - 查询数据

-(CoTaskRelatedModel*)getDataTaskRelatedModelRid:(NSString*)rid;

/**
    得到任务关联的工作组
 *  @param tid      任务ID
 */
-(NSMutableArray*)getRelatedWorkGroupTaskId:(NSString*)tid;

/**
 得到任务关联的项目
 *  @param tid      任务ID
 */
-(NSMutableArray*)getRelatedProjectTaskId:(NSString*)tid;



@end
