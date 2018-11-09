//
//  GalleryImageViewModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/2/3.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-02-03
 Version: 1.0
 Description: 缩略图相关处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface GalleryImageViewModel : NSObject

/**
 *  获取图标的Url地址
 *
 *  @param fileid 文件ID
 *  @param size   尺寸
 *
 *  @return 地址
 */
+(NSString *)GetGalleryIconImageUrlFileId:(NSString *)fileid size:(NSString *)size;

/**
 *  获取等比例缩略图的Url地址
 *
 *  @param fileid 文件ID
 *  @param size   尺寸
 *
 *  @return 地址
 */
+(NSString *)GetGalleryThumbnailImageUrlFileId:(NSString *)fileid size:(NSString *)size;

/**
 *  获取原图的Url地址
 *
 *  @param fileid 文件ID
 *
 *  @return 地址
 */
+(NSString *)GetGalleryOriImageUrlFileId:(NSString *)fileid;

/**
 *  获取灰色图片的Url地址
 *
 *  @param fileid 文件ID
 *
 *  @return 地址
 */
+(NSString *)GetGrayIconUrlFileId:(NSString *)fileid;
/**
 *  获取原图的Url地址(加入是否有效)
 *
 *  @param fileid 文件ID
 *
 *  @return 地址
 */
+(NSString *)GetGalleryOriImageUrlIsReadFileId:(NSString *)fileid isThumbnailImageUrl:(BOOL)isThumbnailImageUrl size:(NSString *)size withisRead:(BOOL)isread ;

/**
 获取图形验证码的Url地址
 
 @param typeid 类型id
 @param key 当前id
 @param codelength 图形验证码长度
 @param graphsize 图形尺寸
 @param fontsize 字体大小
 @return url地址
 */
+(NSString *)GetGraphCodeImageUrlTypeId:(NSString *)typeid key:(NSString *)key;

@end
