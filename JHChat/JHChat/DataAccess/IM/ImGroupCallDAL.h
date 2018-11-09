//
//  ImGroupCallDAL.h
//  LeadingCloud
//
//  Created by gjh on 2017/8/4.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
@class ImGroupCallModel;
@interface ImGroupCallDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImGroupCallDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImGroupCallTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateImGroupCallTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithImGroupCallArray:(NSMutableArray *)imGroupCallArray;

/**
 *  批量数据
 */
-(void)addImGroupCallModel:(ImGroupCallModel *)groupModel;

/* 根据群组id删除对应的数据 */
- (void)deleteImGroupCallModelWithGroupId:(NSString *)groupId;

/**
 删除12小时之前的僵尸数据
 */
- (void)deleteImGroupCallMOdelBeforeOneDay;

/* 更新表中数据 */
- (void)updateImGroupCallModelWithGroupId:(ImGroupCallModel *)groupCallModel;

/* 更新真正在通话中的人 */
- (void)updateImGroupCallRealChatWithGroupId:(ImGroupCallModel *)groupCallModel;

- (void)updateImGroupCallIsCallOtherWithGroupId:(NSString *)iscallother groupid:(NSString *)groupid;

/**
 *  根据groupid获取ImGroupCallModel
 *
 *  @param groupid 联系人ID
 *
 *  @return ImGroupCallModel
 */
- (ImGroupCallModel *)getimGroupCallModelWithGroupid:(NSString *)groupid;
/**
 *  将UserInfoModel转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImTemplateDetailModel
 */
-(ImGroupCallModel *)convertResultSetToModel:(FMResultSet *)resultSet;

@end
