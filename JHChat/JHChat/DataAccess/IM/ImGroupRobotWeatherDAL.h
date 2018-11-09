//
//  ImGroupRobotWeatherDAL.h
//  LeadingCloud
//
//  Created by gjh on 2018/9/3.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
#import "ImGroupRobotWeatherModel.h"
@interface ImGroupRobotWeatherDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+ (ImGroupRobotWeatherDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImGroupRobotWeatherTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateImGroupRobotWeatherTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
/**
 *  单个数据
 */
-(void)addImGroupRobotWeatherModel:(ImGroupRobotWeatherModel *)groupRobotWeatherModel;
/**
 *  批量添加数据
 */
-(void)addDataWithImGroupRobotWeatherArray:(NSMutableArray *)imGroupRobotWeatherArray;
/**
 *  根据groupid获取ImGroupCallModel
 *
 *  @param groupid
 *
 *  @return ImGroupRobotWeatherModel
 */
- (ImGroupRobotWeatherModel *)getimGroupRobotWeatherModelWithRiid:(NSString *)groupid;

/**
 *  根据rwid获取ImGroupRobotWeatherModel
 *
 *  @param rwid
 *
 *  @return ImGroupRobotWeatherModel
 */
- (ImGroupRobotWeatherModel *)getimGroupRobotWeatherModelWithRwid:(NSString *)rwid;

- (NSMutableArray <ImGroupRobotWeatherModel *>*)getimGroupRobotWeatherModelWithIgid:(NSString *)igid;
/* 根据rwid删除对应的数据 */
- (void)deleteImGroupRobotWeatherModelWithRwId:(NSString *)rwid;
@end
