//
//  ResShareItemDAL.h
//  LeadingCloud
//
//  Created by SY on 16/2/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  sy
 Date：   2016-02-23
 Version: 1.0
 Description: 【云盘】分享文件数据库
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"

@interface ResShareItemDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResShareItemDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createResShareItemTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateResShareItemTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据
-(void)addShareItemsWithArray:(NSMutableArray*)shareArray;
#pragma mark - 删除数据
-(void)deleteAllShareFile;
#pragma mark - 查询数据
/**
 *  获取资源列表
 *
 *  @param classid  文件夹ID
 *  @param start    起始条目
 *  @param count    需要获取的条目数量
 *  @param sortDic  排序规则
 *
 *  @return 资源记录数组
 */
-(NSMutableArray *)getShareItemModelsWithShiid:(NSString *)shiid startNum:(NSInteger)start queryCount:(NSInteger)count sort:(NSMutableDictionary *)sortDic;
@end
