//
//  CoRoleDAL.h
//  LeadingCloud
//
//  Created by wang on 16/8/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-06-01
 Version: 1.0
 Description: 协作角色表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/


#import "LZFMDatabase.h"

@interface CoRoleDAL : LZFMDatabase



/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoRoleDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createCoRoleTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoRoleTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSArray *)mArray Cid:(NSString*)cid;


#pragma mark - 删除数据

/**
 *  根据oid删除
 *
 *  @param
 */
-(void)deleteCoRoleCid:(NSString *)cid;

- (NSMutableArray*)getRoleUidFromCid:(NSString*)cid;
@end
