//
//  NetDiskOrgDAL.h
//  LeadingCloud
//
//  Created by SY on 2017/7/21.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
@class NetDiskOrgModel;

@interface NetDiskOrgDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(NetDiskOrgDAL *)shareInstance;
#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createNetDiskOrgTableIfNotExists;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)orgArray;
#pragma mark - 删除数据
/**
 *  删除数据库中所有对象
 */
-(void)deleteAllData;
#pragma mark - 查询数据
/**
 获取企业
 
 @return 企业model
 */
-(NSMutableArray *)getNetOrgModels;
/**
 获取企业分区下的数据
 
 @param orgid 企业id
 @return 企业model
 */
-(NSMutableArray *)getNetOrgChildDataWithOrgid:(NSString*)orgid;
@end
