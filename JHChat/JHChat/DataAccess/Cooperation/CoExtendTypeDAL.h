//
//  CoExtendType.h
//  LeadingCloud
//
//  Created by gjh on 17/3/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
#import "CoExtendTypeModel.h"

@interface CoExtendTypeDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoExtendTypeDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createCoExtendTypeTableIfNotExists;

/**
 *  升级数据库
 */
-(void)updateCoExtendTypeTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)dataArray;

/**
 *  清空所有数据
 */
-(void)deleteAllData;

- (CoExtendTypeModel *)getModelFromCode:(NSString*)code;
@end
