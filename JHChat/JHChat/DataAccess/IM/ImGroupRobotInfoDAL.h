//
//  ImGroupRobotInfoDAL.h
//  LeadingCloud
//
//  Created by gjh on 2018/9/3.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
//@class ImGroupRobotInfoModel;
#import "ImGroupRobotInfoModel.h"
@interface ImGroupRobotInfoDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+ (ImGroupRobotInfoDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImGroupRobotInfoTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateImGroupRobotInfoTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
/**
 *  批量添加数据
 */
-(void)addDataWithImGroupRobotInfoArray:(NSMutableArray *)imGroupRobotInfoArray;

/**
 *  ImGroupRobotInfoModel
 *
 *  @param
 *
 *  @return ImGroupRobotInfoModel
 */
-(NSMutableArray<ImGroupRobotInfoModel *> *)getimGroupRobotInfoModelArr;
/**
 *  单个数据
 */
-(void)addImGroupRobotInfoModel:(ImGroupRobotInfoModel *)groupRobotInfoModel;
/* 删除对应的数据 */
- (void)deleteImGroupRobotInfoModel;

- (ImGroupRobotInfoModel *)getimGroupRobotInfoModelByRiid:(NSString *)riid;
@end
