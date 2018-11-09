//
//  PostFileDAL.h
//  LeadingCloud
//
//  Created by wang on 16/3/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-03-19
 Version: 1.0
 Description: 动态文件表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "LZFMDatabase.h"
#import "PostFileModel.h"

@interface PostFileDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostFileDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostFileTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updatePostFileTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark 插入数据

-(void)addDataWithArray:(NSMutableArray *)pArray;

@end
