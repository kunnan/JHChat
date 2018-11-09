//
//  ImMsgQueueDAL.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-11
 Version: 1.0
 Description: 消息队列数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"

@class ImMsgQueueModel;
@interface ImMsgQueueDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImMsgQueueDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImMsgQueueTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateImMsgQueueTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  添加单条聊天记录
 */
-(void)addImMsgQueueModelModel:(ImMsgQueueModel *)imMsgQueueModel;

#pragma mark - 删除数据

/**
 *  根据队列ID删除队列中的数据
 *
 *  @param msgid mqid
 */
-(void)deleteImMsgQueueWithMqid:(NSString *)mqid;

/**
 *  根据类型删除队列中的数据
 *
 *  @param module module
 */
-(void)deleteImMsgQueueWithModule:(NSString *)module;

/**
 *  根据类型删除队列中的数据
 *
 *  @param module module
 */
-(void)deleteImMsgQueueWithData:(NSString *)data;

/**
 *  根据类型删除队列中的数据(被删除的消息)
 *
 *  @param module module
 */
-(void)deleteImMsgQueueDeletedMsgWithData:(NSString *)data;

#pragma mark - 修改数据

/**
 *  更改消息队列中的数据状态
 *
 *  @param mqid   队列ID
 *  @param status 发送状态
 */
-(void)updateStatusWithMqid:(NSString *)mqid status:(NSInteger)status;

/**
 *  更新所有消息的发送状态
 */
-(void)updateAllMsgStatus:(NSInteger)status;

#pragma mark - 查询数据

/**
 *  获取发送真正失败的消息
 *
 *  @param module 功能模块
 *
 *  @return 失败的消息
 */
-(NSMutableArray *)getMessageWithModule:(NSString *)module;

@end
