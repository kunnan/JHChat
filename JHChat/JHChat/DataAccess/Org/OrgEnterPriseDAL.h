
//  OrgEnterPriseDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 组织数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "OrgEnterPriseModel.h"

@interface OrgEnterPriseDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgEnterPriseDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createOrgEnterPriseTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateOrgEnterPriseTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

/**
 *  更改管理员身份
 */
-(void)updateEnterpriseWithOEId:(NSString *)oeId isenteradmin:(NSInteger)isenteradmin;

-(void)updateEnterpriseWithOEId:(NSString *)oeId isadmin:(NSInteger)isadmin;

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithOrgEnterpriseArray:(NSMutableArray *)orgEnterPriseArr;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;

/**
 *  根据eid删除组织信息
 *  @param oId
 */
-(void)deleteOrgUserEntetpriseByEId:(NSString *)eId;

#pragma mark - 修改数据

/**
 *  更新组织的信息
 *  @param oeId        组织id
 *  @param name        名称
 *  @param shortName   简称
 *  @param description 描述
 */
-(void)updateEnterpriseWithOEId:(NSString * )oeId name:(NSString *)name shortName:(NSString *)shortName description:(NSString *)description;

/**
 *  更改组织logo
 */
-(void)updateEnterpriseWithOEIdByLogo:(NSString *)oeId Logo:(NSString *)logo;


#pragma mark - 查询数据
/**
 *  获取【我】所属的组织集合
 *  @return
 */
-(NSArray<OrgEnterPriseModel *> *)getOrgEnterPrises;
/**
 *  根据组织主键获取组织数据
 *  @param eId
 *  @return
 */
-(OrgEnterPriseModel *)getEnterpriseByEId:(NSString *)eId;
/**
 *  根据组织主键获取组织名称
 *  @param eId
 *  @return
 */
-(NSString *)getEnterpriseShortNameByEId:(NSString *)eId;

@end
