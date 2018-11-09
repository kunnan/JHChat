//
//  ImMsgTemplateDAL.h
//  LeadingCloud
//
//  Created by wchMac on 16/8/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  dfl
 Date：   2016-08-10
 Version: 1.0
 Description: 消息模板集合处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "ImMsgTemplateModel.h"

@interface ImMsgTemplateDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImMsgTemplateDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImMsgTemplateTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateImMsgTemplateTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithImMsgTemplateArray:(NSMutableArray *)imMsgTemplate;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;

#pragma mark - 修改数据



#pragma mark - 查询数据

/**
 *  根据code获取对应的模板信息
 */
-(ImMsgTemplateModel *)getImMsgTemplateModelWithCode:(NSString *)code;

/**
 *  获取所有的模板信息
 */
-(NSArray<ImMsgTemplateModel *> *)getAllImMsgTemplateModel;
@end
