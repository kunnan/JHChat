//
//  PostPromptDAL.h
//  LeadingCloud
//
//  Created by wang on 16/3/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  dfl
 Date：   2016-03-08
 Version: 1.0
 Description: 常用语表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "PostPromptModel.h"

@interface PostPromptDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostPromptDAL *)shareInstance;


#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostPromptTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updatePostPromptTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)pArray;

/**
 *  添加单条数据
 */
-(void)addPromptModel:(PostPromptModel *)pModel;
#pragma mark - 删除数据

/**
 *  根据id删除常用语
 *
 *  @param
 */
-(void)deletePromptid:(NSString *)pcid;

/**
 *  删除全部
 */
-(void)deletePrompt;
#pragma mark - 获取数据

/**
    得到常用语
 *  @param oid      组织ID
 
 */
-(NSMutableArray*)getMyPrompt;

#pragma mark - 更新数据
/**
 *  更新常用语名称
 *
 *  @param name 名字
 *  @param pcid 常用语id
 */
- (void)updataPromptName:(NSString*)name Pcid:(NSString*)pcid;

@end
