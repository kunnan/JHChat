//
//  AliyunFileidsDAL.h
//  LeadingCloud
//
//  Created by SY on 2017/7/14.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"

@interface AliyunFileidsDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AliyunFileidsDAL *)shareInstance;
/**
 *  升级数据库
 */
-(void)updateAliFileidsTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createAliFileidsTableIfNotExists;

#pragma mark - 添加数据

-(void)addAliFileids:(NSMutableArray*)fileids  withDate:(NSDate*)creatDate;
#pragma mark - 删除数据
-(void)deleteFileidWithFileid:(NSString *) fileid;
-(void)deleteAllFileids;
#pragma mark - 查询数据
-(NSMutableArray*)getFileids;
-(NSDate*)getFileidsCreatdateWithFileid:(NSString*)fileid;
@end
