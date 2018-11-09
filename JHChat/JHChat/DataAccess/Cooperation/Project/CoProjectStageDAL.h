//
//  CoProjectStageDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 阶段数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"

@interface CoProjectStageDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoProjectStageDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createCoProjectStageTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoProjectStageTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
@end
