//
//  CoTransactionPostInfoDAL.h
//  LeadingCloud
//
//  Created by wang on 16/10/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-10-19
 Version: 1.0
 Description: 事务岗位表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "LZFMDatabase.h"
#import "CoTransactionPostInfoModel.h"

@interface CoTransactionPostInfoDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoTransactionPostInfoDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createCoTransactionPostInfoTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoTransactionPostInfoTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)postInfoArray Orgid:(NSString*)oid;

#pragma mark - 删除数据
/**
 *  根据企业id删除所有岗位信息
 *
 *  @param
 */
-(void)deleteAllPostInfoOid:(NSString*)oid;

#pragma mark - 查询数据
/**
    得到所以岗位信息
 *  @param oid      企业ID
 */
-(NSMutableArray*)getPostInfoArrOId:(NSString*)oid;
@end
