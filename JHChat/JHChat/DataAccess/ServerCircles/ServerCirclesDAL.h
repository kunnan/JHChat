//
//  ServerCirclesDAL.h
//  LeadingCloud
//
//  Created by wang on 17/3/29.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
#import "ServiceCirclesListItem.h"

@interface ServerCirclesDAL : LZFMDatabase


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ServerCirclesDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createServerCirclesTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateServerCirclesTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;


#pragma mark - 添加数据

-(void)addDataWithAppArray:(NSMutableArray *)appArray;

/**
 *  加入的服务圈
 */
- (NSMutableArray*)searchJoinSearverCircles:(NSString*)oid Search:(NSString*)search;

/**
 * 所有的服务圈
 */
- (NSMutableArray*)searchAllSearverCircles:(NSString*)oid Search:(NSString*)search;

/**
 *  加入的服务圈
 */
- (NSMutableArray*)getJoinAllSearverCircles:(NSString*)oid;

/**
 *  推荐的服务圈
 */
- (NSMutableArray*)getRecommendAllSearverCircles:(NSString*)oid;

/**
 *  服务圈是否加入
 */
- (BOOL)isJoinSearverCircles:(NSString*)scid;

#pragma mark - 删除数据
/**
 *  删除加入的服务圈
 */
- (void)deleJoinServerCircles:(NSString*)oid;

/**
 *  删除推荐的服务圈
 */
- (void)deleRecommendServerCircles:(NSString*)oid;

@end
