//
//  ResShareDAL.h
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
@class ResShareModel;
@interface ResShareDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResShareDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createResShareFolderTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateResShareFolderTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
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
-(NSMutableArray *)getShareModelsWithClass:(NSString *)classid startNum:(NSInteger)start queryCount:(NSInteger)count sort:(NSMutableDictionary *)sortDic;
/**
 *  获取资源列表
 *
 *  @return 资源记录数组
 */
-(NSMutableArray *)getShareModels;
-(ResShareModel*)getDidShareModelWithShareid:(NSString*)shareid;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addShareDataWithArray:(NSMutableArray*)shareArray;
/**
 *  添加分享文件model
 *
 *  @param shareModel 分享的model
 */
-(void)addShareDataWithModel:(ResShareModel*)shareModel;

#pragma mark - 删除数据
/**
 *  取消分享
 *
 *  @param shareid 分享文件的主键id
 */
-(void)deleteCancelShareFile:(NSString*)shareid;
-(void)deleteAllShareFile;
@end
