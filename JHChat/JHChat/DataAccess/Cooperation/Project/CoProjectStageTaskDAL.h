//
//  CoProjectStageTaskDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 阶段任务关系数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"

@interface CoProjectStageTaskDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoProjectStageTaskDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createCoProjectStageTaskTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoProjectStageTaskTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
@end
