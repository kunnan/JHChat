//
//  AliyunRemotrlyServerDAL.h
//  LeadingCloud
//
//  Created by SY on 2017/6/29.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
@class RemotelyServerModel;
@interface AliyunRemotrlyServerDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AliyunRemotrlyServerDAL *)shareInstance;
#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createAliServerTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateAliyunTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)serverArray;
#pragma mark - 删除数据
-(void)deleteServer;
#pragma mark - 查询数据

/**
 查询相应服务器model
 
 @param rfstype oss：阿里云  lzy:理正云
 @return
 */
-(RemotelyServerModel*)getServerModelWithRfsType:(NSString*)rfstype;
@end
