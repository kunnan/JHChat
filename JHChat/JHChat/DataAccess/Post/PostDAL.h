//
//  PostDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 动态信息数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "PostModel.h"
#import "LZFMDatabase.h"

@interface PostDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updatePostTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)pArray;

/**
 *  添加单条数据
 */
-(void)addPostModel:(PostModel *)pModel;
#pragma mark - 删除数据
/**
 *  删除单条数据
 */
-(void)delePostID:(NSString *)pid;

/**
 *  删除动态回复数据
 */
-(void)delePostReplyID:(NSString *)pid;


/**
 *  删除动态单条回复数据
 */
-(void)delePostReplyID:(NSString *)pid Rekatedpid:(NSString*)relatedpid;

/**
 *  删除组织时间段的协作
 */
-(void)delePostOid:(NSString*)oid ListStarTime:(NSDate*)starTime EndTime:(NSDate*)endTime;



/**
 *  删除组织时间段的协作
 */

-(void)delePostOid:(NSString*)oid;

-(void)delePostAppID:(NSString *)appid;

#pragma mark - 修改数据



#pragma mark - 查询数据

//得到第一条动态的id
- (NSString*)getMyPostFirstOid:(NSString*)oid;
/**
    得到组织动态列表
 *  @param oid      组织ID
 
 */
-(NSMutableArray*)getMyPostOid:(NSString*)oid StarIndex:(NSInteger)starIndex Count:(NSInteger)count IsShowFileName:(BOOL)isShowFileName;


@end
