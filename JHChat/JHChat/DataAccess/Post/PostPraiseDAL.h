//
//  PostPraiseDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 点赞数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "PostZanModel.h"
@interface PostPraiseDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostPraiseDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostPraiseTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updatePostPraiseTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)pArray;

-(void)addDataWithModel:(PostZanModel *)pModel;

#pragma mark - 删除数据

/**
 *  删除动态全部数据
 */
-(void)delePostPID:(NSString *)pid;
/**
 *  删除单条数据
 */
-(void)delePostPraiseID:(NSString *)ppid;


#pragma mark - 修改数据



#pragma mark - 查询数据

@end
