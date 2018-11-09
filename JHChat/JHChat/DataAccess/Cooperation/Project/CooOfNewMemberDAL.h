//
//  CooOfNewMemberDAL.h
//  LeadingCloud
//
//  Created by SY on 16/6/8.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-06-08
 Version: 1.0
 Description: 新的协作 - 新的成员
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
@class CooNewMemberApplyModel;
@interface CooOfNewMemberDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooOfNewMemberDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createCooOfNewMemberTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCooOfNewMemberTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据
-(void)addCooMember:(NSMutableArray*)applyModelArray;
#pragma mark - 删除数据
-(void)deleteAllDataWithState:(NSString*)state;
-(void)deleteDidHandleSourceWithCid:(NSString*)cid applyid:(NSString*)applyid;
-(void)deleteApplySourceWithCid:(NSString*)cid;
-(void)deleteApplyLogSourceWithCmalid:(NSString*)cmalid;
#pragma mark - 修改数据
-(void)updataNewApplyWithUid:(NSString*)uid cid:(NSString*)cid  state:(NSInteger)state;
-(void)updataNewApplyActionResultWithKeyid:(NSString*)keyid  actionresult:(NSInteger)action;
#pragma mark - 查询数据
-(NSMutableArray*)selectAllDataWithState:(NSInteger)state;
-(CooNewMemberApplyModel*)selectApplyModelWithApplyId:(NSString*)applyid cid:(NSString*)cid;
-(CooNewMemberApplyModel*)selectApplyModelWithKeyid:(NSString*)keyid;
-(NSMutableArray*)selectLogDataWithState:(NSInteger)state startNum:(NSInteger)start queryCount:(NSInteger)count;
@end
