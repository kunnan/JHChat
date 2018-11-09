//
//  OrgUserIntervateDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 组织邀请成员数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "OrgUserIntervateModel.h"

@interface OrgUserIntervateDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgUserIntervateDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createOrgUserIntervateTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateOrgUserIntervateTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)orgArray;

/**
 *  插入单条数据
 *
 *  @param model OrgUserIntervateModel
 */
-(void)addOrgUserIntervateModel:(OrgUserIntervateModel *)model;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;

/**
 *  根据ouiid删除信息
 *  @param ouiid
 */
-(void)deleteOrgUserIntervateByOuiId:(NSString *)ouiid;

#pragma mark - 修改数据



#pragma mark - 查询数据

/**
 *  获取新的组织全部数据
 *
 */
-(NSMutableArray *)getOrgUserIntervateDataWithUid:(NSString *)uid;

/**
 *  获取新的组织数据
 *
 */
-(NSMutableArray *)getOrgUserIntervateDataWithUid:(NSString *)uid StartNum:(NSInteger)startNum End:(NSInteger)end;

/**
 *  根据主键id获取组织数据
 *  @param ouiid 主键ID
 *  @return
 */
-(OrgUserIntervateModel *)getOrgUserIntervateByOuiId:(NSString *)ouiid;

/**
 *  根据组织id获取组织数据
 *  @param objoeid 组织ID
 *  @return
 */
-(OrgUserIntervateModel *)getOrgUserIntervateByObjOeid:(NSString *)objoeid;

@end
