//
//  UserContactOfenCooperationDAL.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/3.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 常用联系人数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "UserContactOfenCooperationModel.h"
#import "ContactRootSearchModel2.h"
#import "UIKit/UIKit.h"

@interface UserContactOfenCooperationDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserContactOfenCooperationDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createUserContactOfenCooperationTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateUserContactOfenCooperationTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据
/**
 *  批量添加数据
 *  @param userArray
 */
-(void)addDataWithUserContactOftenCooperationArray:(NSMutableArray<UserContactOfenCooperationModel *> *)userArray;


#pragma mark - 删除数据
/**
 *  清空数据
 */
-(void)deleteAllData;
/**
 *  根据uId删除记录
 *  @param uId
 */
-(void)deleteByuId:(NSString *)uId;


#pragma mark - 修改数据



#pragma mark - 查询数据

/**
 *  获取常用联系人列表数据
 *
 *  @return 数据
 */
-(NSMutableArray *)getContectOftenCooperationList;
/**
 *  搜索常用联系人
 *  @param searchText
 *  @return
 */
-(NSMutableArray *)searchOfenCooperationContact:(NSString *)searchText;
@end
