//
//  CoLayoutDAL.h
//  LeadingCloud
//
//  Created by SY on 16/5/6.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
@class CooLayoutModel;
@interface CoLayoutDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoLayoutDAL *)shareInstance ;
/**
 *  创建表
 */
-(void)createCoLayoutTableIfNotExists;

/**
 *  升级数据库
 */
-(void)updateCoLayoutTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据
-(void)addLayoutInfo:(CooLayoutModel*)layouModel;

#pragma mark - 查询数据
-(CooLayoutModel*)selectLayoutInfo:(NSString*)cid;

@end
