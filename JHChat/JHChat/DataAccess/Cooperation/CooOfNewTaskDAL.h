//
//  CooOfNewTaskDAL.h
//  LeadingCloud
//
//  Created by SY on 16/3/24.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-03-24
 Version: 1.0
 Description: 新的协作
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "LZFMDatabase.h"
@class CooOfNewModel;
@interface CooOfNewTaskDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooOfNewTaskDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createCooOfNewTaskTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCooOfNewTaskTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

-(void)addNewCooDataWithArray:(NSMutableArray *)newCooArray;

#pragma mark - 删除数据
/**
 *  删除应用
 *
 *  @param state 协作处理状态
 */
-(void)deleteCooOfNewDataWithState:(NSString*)state;
/**
 *  同意或拒绝成功之后从本地移除
 *
 *  @param 新的协作的主键id
 */
-(void)deleteHandleCooOfNewDataWithKeyId:(NSString*)kid;
/**
 *  删除协作邀请
 *
 *  @param 新的协作的主键id
 */
-(void)deleteCooOfNewDataWithcid:(NSString*)cid;

#pragma mark - 修改数据
-(void)updataNewCooWithKeyId:(NSString*)keyid state:(NSInteger)state;

/**
 修改新的协作的操作结果

 @param keyid        主键id
 @param actionResult 操作结果
 */
-(void)updataNewCooWithKeyId:(NSString*)keyid actionResult:(NSInteger)actionResult;

#pragma mark - 查询数据
-(NSMutableArray *)getAllInvite:(NSString*)keyid withState:(NSInteger)state;
-(NSMutableArray *)getAllInvite:(NSString*)keyid withState:(NSInteger)state startNum:(NSInteger)start queryCount:(NSInteger)count;
/**
 获取特定的协作
 
 @param keyid 主键id
 
 @return CooOfNewModel
 */
-(CooOfNewModel *)getAllInvite:(NSString*)keyid;
@end
