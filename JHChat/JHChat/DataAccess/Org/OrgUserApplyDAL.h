//
//  OrgUserApplyDAL.h
//  LeadingCloud
//
//  Created by dfl on 16/5/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-05-30
 Version: 1.0
 Description: 用户申请加入组织成员列表数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/


#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "OrgUserApplyModel.h"

@interface OrgUserApplyDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgUserApplyDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createOrgUserApplyTableIfNotExists;
/**
 *  升级数据库
 */
//-(void)updateOrgUserApplyTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)orgArray;

/**
 *  插入单条数据
 *
 *  @param model OrgUserApplyModel
 */
-(void)addOrgUserApplyModel:(OrgUserApplyModel *)model;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;

/**
 *  根据oid清空数据
 */
-(void)deleteAllDataByOid:(NSString *)oid;

/**
 *  根据ouaid清空数据
 */
-(void)deleteOrgUserApplyByOuaid:(NSString *)ouaid;

#pragma mark - 修改数据



#pragma mark - 查询数据

/**
 *  获取新的员工数据
 *
 */
-(NSMutableArray *)getOrgUserApplyDataWithStartNum:(NSInteger)startNum End:(NSInteger)end;

/**
 *  根据oid获取管理部门下申请成员列表的数据
 *
 */
-(NSMutableArray *)getOrgUserApplyDataWithByOid:(NSString *)oid StartNum:(NSInteger)startNum End:(NSInteger)end;

/**
 *  根据oeid获取管理组织下申请成员列表的数据
 *
 */
-(NSMutableArray *)getOrgUserApplyDataWithByOeId:(NSString *)oeid StartNum:(NSInteger)startNum End:(NSInteger)end;

/**
 *  根据主键id获取好友信息
 *  @param ouaid 主键ID
 *  @return
 */
-(OrgUserApplyModel *)getOrgUserApplyByOuaId:(NSString *)ouaid;

@end
