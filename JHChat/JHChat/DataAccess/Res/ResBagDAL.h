//
//  ResBagDAL.h
//  LeadingCloud
//
//  Created by SY on 16/4/5.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
#import "ResModel.h"
@interface ResBagDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResBagDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createResBagTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateResBagTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)resArray;
#pragma mark - 删除数据
/**
 *  删除数据库中所有对象
 */
-(void)deleteAllData;

#pragma mark - 查询数据
/**
 *  查询本地文件包里的文件
 *
 *  @param versonid 文件包的rid == 文件包里的版本id
 *
 *  @return 文件包里的内容
 */
-(NSMutableArray *)getResBagModelsWithClassid:(ResModel *)resModel;
@end
