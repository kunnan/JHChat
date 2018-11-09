//
//  PostTemplateDAL.h
//  LeadingCloud
//
//  Created by wang on 16/7/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-07-28
 Version: 1.0
 Description: 动态模板表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/


#import "LZFMDatabase.h"
#import "PostTemplateModel.h"

@interface PostTemplateDAL : LZFMDatabase


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostTemplateDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostTemplateTableIfNotExists;

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)pArray;


#pragma mark - 删除数据
/**
 *  删除单条数据
 */
-(void)deleAllPostTemplate;

/**
 *  得到动态模板
 *
 *  @param ecode 更加动态code
 *
 *  @return
 */
- (NSDictionary*)getTemplateFromEcodle:(NSString*)ecode;
@end
