//
//  CoProjectsMainDAL.h
//  LeadingCloud
//
//  Created by SY on 16/10/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   16/10/20
 Version: 1.0
 Description: 项目
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "CoProjectsModel.h"

@interface CoProjectsMainDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoProjectsMainDAL *)shareInstance;
#pragma mark - 表结构操作
-(void)creatProjectsMainTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updataCoProjectMainTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据
/**
 添加项目model
 
 @param array 项目数组
 */
-(void)addProjectsWithArray:(NSMutableArray*)array;
#pragma mark - 删除数据
/**
 删除指定分组下的所有项目
 
 @param pgid 分组id
 */
-(void)deleteProjectsWithPgid:(NSString*)pgid;
#pragma mark - 修改数据
/**
 修改分组id
 
 @param pgid 分组id
 @param prid 项目主键
 */
-(void)updateProjectGroupWithNewPgid:(NSString*)pgid prid:(NSString*)prid;
/**
 项目置顶/取消置顶操作
 
 @param pgid  分组id
 @param istop 是否置顶
 @param prid  项目id
 */
-(void)updateProjectTopActionWithNewPgid:(NSString*)pgid istop:(NSInteger)istop prid:(NSString*)prid;
#pragma mark - 查询数据
/**
 查询某分组下的项目
 
 @param pgid 分组id
 
 @return 项目model
 */
-(NSMutableArray*)getProjectsWith:(NSString*)pgid laodCount:(NSInteger)count starCount:(NSInteger)starCount;

/**
 查询某项目
 
 @param prid 项目id
 
 @return 项目model
 */
-(CoProjectsModel*)getProjectsWithByPrid:(NSString *)prid;

@end
