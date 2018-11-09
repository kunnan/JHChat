//
//  PostNotificationDAL.h
//  LeadingCloud
//
//  Created by wang on 16/3/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-03-19
 Version: 1.0
 Description: 动态提醒表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "LZFMDatabase.h"
#import "PostNotificationModel.h"

@interface PostNotificationDAL : LZFMDatabase


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostNotificationDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostNotificationTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updatePostNotificationTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark 插入数据

-(void)addDataWithArray:(NSMutableArray *)pArray;


#pragma mark - 查询数据
/**
     得到动态提醒
  *  @param count      
  
  */
-(NSMutableArray*)getPostNotificationArrStart:(NSInteger)start Count:(NSInteger)count;

@end
