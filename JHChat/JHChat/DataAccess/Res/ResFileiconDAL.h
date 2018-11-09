//
//  ResFileiconDAL.h
//  LeadingCloud
//
//  Created by gjh on 16/9/1.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  gjh
 Date：   2016-09-01
 Version: 1.0
 Description: 资源文件图片相关
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "LZFMDatabase.h"
#import "ResFileiconModel.h"

@interface ResFileiconDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResFileiconDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createResFileiconTableIfNotExists;

/**
 *  升级数据库
 */
-(void)updateResFileiconTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

/**
 *  根据文件扩展名查询图像iconID
 */
- (ResFileiconModel *)getFileiconIDByFileEXT:(NSString *)fileExt;

/**
 *  给表中插入一条数据
 */
- (void)addDataWithResFileIconModel:(ResFileiconModel *)resFileIconModel;

/**
 更新数据
 
 @param resFileIconModel
 */
- (void)updateDataWithResFileIconModel:(ResFileiconModel *)resFileIconModel;
@end
