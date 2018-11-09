//
//  CoManageDAL.h
//  LeadingCloud
//
//  Created by wang on 16/6/1.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-06-01
 Version: 1.0
 Description: 协作管理表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "CoManageModel.h"

@interface CoManageDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoManageDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createCoManageTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoMemberTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)mArray;


#pragma mark - 删除数据

/**
 *  根据oid删除
 *
 *  @param
 */
-(void)deleteMangeOid:(NSString *)oid type:(NSString*)type;
@end
