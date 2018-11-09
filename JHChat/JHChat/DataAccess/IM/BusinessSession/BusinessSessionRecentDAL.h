//
//  BusinessSessionRecentDAL.h
//  LeadingCloud
//
//  Created by gjh on 17/4/5.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
#import "BusinessSessionRecentModel.h"

@interface BusinessSessionRecentDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(BusinessSessionRecentDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createBusinessSessionRecentTableIfNotExists;

/**
 *  升级数据库
 */
-(void)updateBusinessSessionRecentTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

/*
 删除表
 */
-(void)dropTableBusinessSessionRecentAndBusinessSessionRecent1;

-(void)dropTableBusiness_Session_Recent;

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithBusinessSessionRecentArray:(NSMutableArray *)RecentArray;

/**
 *  单条添加
 *
 */
-(void)addDataWithBusinessSessionRecentModel:(BusinessSessionRecentModel*)recentModel;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;

#pragma mark - 修改数据


#pragma mark - 查询数据

/**
 *  根据专业类型查询数据
 *
 *  bstype 专业类型
 *  contactid 消息ID
 *  @return 消息列表数组
 */
-(NSMutableArray *)getBusinessSessionRecentWithBstype:(NSInteger )bstype contactid:(NSString *)contactid;

/**
 *  获取消息列表选择数据
 *
 *  @return 消息列表数组
 */
-(NSMutableArray *)getBusinessSessionRecentList;


/**
 *  根据targetid获取数据
 *
 *  @return model
 */
-(BusinessSessionRecentModel *)getBusinessSessionRecentWithTargetId:(NSString *)targetid;

@end
