//
//  CoProjectMainGroupDAL.h
//  LeadingCloud
//
//  Created by SY on 16/10/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   16/10/17
 Version: 1.0
 Description: 项目分组
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
@class CoProjectGroupModel;

@interface CoProjectMainGroupDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoProjectMainGroupDAL *)shareInstance;
#pragma mark - 表结构操作
-(void)creatProjectMainGroupTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updataCoProjectMainGroupTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark 添加数据

/**
 批量添加项目分组
 
 @param array array
 */
-(void)addProjectMainWithArray:(NSMutableArray*)array;
/**
 添加单个分组
 
 @param pgModel 分组model
 */
-(void)addProjectGroupWithModel:(CoProjectGroupModel*)pgModel;

#pragma mark  删除数据
/**
 删除某条分组
 
 @param pgid 分组主键id
 */
-(void)deleteCustomGroupWithPgid:(NSString*)pgid;
/**
 删除某个组织下的所有分组
 
 @param uid   当前用户id
 @param orgid 当前企业id
 @param state 项目状态
 */
-(void)deleteAllGroupWithUid:(NSString*)uid orgid:(NSString*)orgid state:(NSInteger)state;

#pragma mark 修改数据
/**
 分组重命名
 
 @param newName 新名字
 @param pgid    主键id
 */
-(void)updateGroupNameWithNewName:(NSString*)newName pgid:(NSString*)pgid;
/**
 更新排序下标
 
 @param pgid    组件id
 @param newSort 新的排序下标
 */
-(void)updateGroupSortWithPgid:(NSString*)pgid sort:(NSInteger)newSort;
/**
 更新分组下的项目数量
 
 @param prcount 项目数量
 @param pgid    分组id
 */
-(void)updateGroupPrcountWithPrcount:(NSString*)prcount pgid:(NSString*)pgid;
#pragma mark 查询数据
/**
 查询当前分组
 
 @param uid   当前用户id
 @param orgid 当前组织id
 @param state 当前状态
 
 @return 分组数组
 */
-(NSMutableArray*)getCustomGroupWithUid:(NSString*)uid orgid:(NSString*)orgid state:(NSInteger)state;
/**
 查询单个分组Model
 
 @param pgid 分组主键id
 
 @return 分组model
 */
-(CoProjectGroupModel*)getGroupModelWithPgid:(NSString*)pgid;
@end
