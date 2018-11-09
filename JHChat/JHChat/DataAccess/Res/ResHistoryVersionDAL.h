//
//  ResHistoryVersionDAL.h
//  LeadingCloud
//
//  Created by SY on 16/4/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  sy
 Date：   2016-04-11
 Version: 1.0
 Description: 【云盘】历史版本文件数据库
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "ResModel.h"
@interface ResHistoryVersionDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResHistoryVersionDAL *)shareInstance;
/**
 *  创建表
 */
-(void)createResHistoryVersionTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateResHistoryVersionTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)resArray;
#pragma mark - 删除数据
-(void)deleteHistoryVersionWithRid:(NSString*)rid;

#pragma mark - 查询数据
/**
 *  获取本地历史版本
 *
 *  @param rid  资源id
 *  @param rpid 资源次id
 *
 *  @return 历史文件
 */
-(NSMutableArray *)getResHistoryVersionModelsWithRid:(NSString *)rid rpid:(NSString*)rpid;
@end
