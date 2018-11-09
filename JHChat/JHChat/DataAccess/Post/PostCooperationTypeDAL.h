//
//  PostCooperationTypeDAL.h
//  LeadingCloud
//
//  Created by wang on 16/8/2.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-08-02
 Version: 1.0
 Description: 动态类型表
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"
#import "PostCooperationTypeModel.h"

@interface PostCooperationTypeDAL : LZFMDatabase


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostCooperationTypeDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostCooperationTypeTableIfNotExists;

/**
 *  升级数据库
 */
-(void)updatePostCooperationTypeTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)pArray;

/**
 *  得到手机展示图片
 *
 *  @param posttypecode  动态code
 *
 *  @return
 */
- (NSString*)getCooperationTypeImage:(NSString*)posttypecode AppCode:(NSString*)appcode;

/**
 *  得到手机展示颜色
 *
 *  @param posttypecode  动态code
 *
 *  @return
 */
- (NSString*)getCooperationTypeColor:(NSString*)posttypecode AppCode:(NSString*)appcode;

/**
 *  根据动态code 得到模型
 *
 *  @param type 动态code
 *
 *  @return
 */
- (PostCooperationTypeModel*)getCooperationType:(NSString*)posttypecode AppCode:(NSString*)appcode;

-(void)deleAllPostCoopeationType;

@end
