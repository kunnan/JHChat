//
//  TagDataDAL.h
//  LeadingCloud
//
//  Created by wang on 16/2/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author: wzb
 Date：   2016-2-18
 Version: 1.0
 Description: 标签数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "TagDataModel.h"

@interface TagDataDAL : LZFMDatabase


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(TagDataDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createTagDataTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateTagDataTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithTagDataArray:(NSMutableArray *)tagsArray;

/**
 *  添加单条数据
 */
-(void)addTagDataModel:(TagDataModel *)tagModel;
#pragma mark - 删除数据

/**
 *  根据id删除群组
 *
 *  @param
 */
-(void)deleteTagid:(NSString *)tid;

/**
 *  根据协作cid删除群组
 *
 *  @param
 */
-(void)deleteCooperationCid:(NSString *)cid;
/**
 *  根据标签类型id删除数据
 *  @param ttId
 */
-(void)deleteByTagTypeId:(NSString *)ttId;

/**
 *  删除表中字段【dataextend1】值为“dataExtend1Value”的所有数据
 *  @param dataExtend1Value 值
 */
-(void)deleteByDataExtend1Value:(NSString *)dataExtend1Value;

/**
 *  删除表中字段【dataextend2】值为“dataExtend2Value”的数据
 *  @param dataExtend2Value 值
 */
-(void)deleteByDataExtend2Value:(NSString *)dataExtend2Value DataExterend1Value:(NSString *)dataExterend1Value;


#pragma mark - 修改数据



#pragma mark - 查询数据
/**
 *  获取群组全部列表
 *
 *  @param gid      群组ID
 *  @return TagDataModel 数组
 */
-(NSMutableArray *)getCooDataWithCid:(NSString *)cid ;

/**
 *  根据标签id获取标签数据
 *  @param tagid
 *  @return
 */
-(NSMutableArray *)getTagDataByTagId:(NSString *)dataExtend1Value;

@end
