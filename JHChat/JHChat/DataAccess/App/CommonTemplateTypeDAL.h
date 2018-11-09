//
//  CommonTemplateTypeDAL.h
//  LeadingCloud
//
//  Created by wang on 2017/7/31.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
#import "CommonTemplateTypeModel.h"


@interface CommonTemplateTypeDAL : LZFMDatabase


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CommonTemplateTypeDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createCommonTemplateTypeTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCommonTemplateTypeTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据


/**
 *  插入单条数据
 *
 *  @param model AppModel
 */
-(void)addCommonTemplateTypeModel:(CommonTemplateTypeModel *)model;

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData;


/**
 *  得到模型
 *
 *
 *  @return
 */
- (CommonTemplateTypeModel*)getCommonTemplateTypeModelCode:(NSString*)code AppCode:(NSString*)appcode;

@end
