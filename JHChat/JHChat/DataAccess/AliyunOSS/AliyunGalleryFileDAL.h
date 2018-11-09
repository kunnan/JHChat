//
//  AliyunGalleryFileDAL.h
//  LeadingCloud
//
//  Created by SY on 2017/6/29.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
@class AliyunGalleryFileModel;
@interface AliyunGalleryFileDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AliyunGalleryFileDAL *)shareInstance;
/**
 *  创建表
 */
-(void)createAliFileTableIfNotExists;
#pragma mark - 添加数据

-(void)addAliFileModel:(AliyunGalleryFileModel*)fileModel;
@end
