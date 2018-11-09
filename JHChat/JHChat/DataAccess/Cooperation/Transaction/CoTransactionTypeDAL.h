//
//  CoTransactionTypeDAL.h
//  LeadingCloud
//
//  Created by wang on 16/10/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-10-28
 Version: 1.0
 Description: 事务类型表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "CoTransactionTypeModel.h"

@interface CoTransactionTypeDAL : LZFMDatabase


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoTransactionTypeDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createCoTransactionTypeTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoTransactionTypeTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)typeArr;

#pragma mark - 删除数据
/**
 *  删除所有的类型
 *
 *  @param
 */
-(void)deleteAllModel;

#pragma mark - 查询数据
/**
 *  根据code获取对应的模板信息
 */
-(CoTransactionTypeModel *)getTransactionModelTtid:(NSString *)ttid;


@end
