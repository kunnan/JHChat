//
//  PostReplyTextDAL.h
//  LeadingCloud
//
//  Created by wang on 17/2/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wzb
 Date：   2017-02-27
 Version: 1.0
 Description: 动态临时回复文字表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"

@interface PostReplyTextDAL : LZFMDatabase


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostReplyTextDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostReplyTextTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updatePostReplyTextTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;



/**
 添加临时文本

 @param text   文本
 @param people @好友
 @param pid    动态id
 */
/**
 添加临时文本
 
 @param text   文本
 @param people @好友
 @param pid    动态id
 */
- (void)addTempText:(NSString*)text Peoples:(NSArray*)peoples Firends:(NSDictionary*)firends Pid:(NSString*)pid;



/**
 删除动态临时文本

 @param pid 动态id
 */
- (void)deleTempTextPid:(NSString*)pid;


/**
 得到动态临时文本 
 
 @param pid 动态id
 */
- (NSDictionary*)getTempReplyTextPostID:(NSString*)pid;

@end
