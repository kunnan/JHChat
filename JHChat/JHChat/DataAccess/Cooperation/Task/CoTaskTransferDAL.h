//
//  CoTaskTransferDAL.h
//  LeadingCloud
//
//  Created by wang on 16/2/24.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 任务托付表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "LZFMDatabase.h"

@interface CoTaskTransferDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoTaskTransferDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createCoTaskTransferIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoTaskTransferTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)taskArray;

/**
 *  添加单条数据
 */
-(void)addTaskID:(NSString *)cid;


/**
 *  根据oid删除关系数据
 *
 *  @param
 */
-(void)deleteTransferOid:(NSString*)oid;
@end
