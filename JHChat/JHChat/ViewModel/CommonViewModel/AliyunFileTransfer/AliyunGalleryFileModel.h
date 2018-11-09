//
//  AliyunGalleryModel.h
//  LeadingCloud
//
//  Created by SY on 2017/6/28.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
// 阿里云文件上传成功后服务器返回的model

#import <Foundation/Foundation.h>

@interface AliyunGalleryFileModel : NSObject

/**
 文件id
 */
@property (nonatomic, strong) NSString *fileid;
/**
 图标d
 */
@property (nonatomic, strong) NSString *icon;
/**
 图标路径
 */
@property (nonatomic, strong) NSString *iconurl;
/**
 32图标
 */
@property (nonatomic, strong) NSString *iconurl32;
/**
 64图标
 */
@property (nonatomic, strong) NSString *iconurl64;
/**
 128图标
 */
@property (nonatomic, strong) NSString *iconurl128;
/**
图标路径(无tokenid)
 */
@property (nonatomic, strong) NSString *iconurlnottoken;
/**
 
 文件名称
 */
@property (nonatomic, strong) NSString *filename;
/**
扩展名
 */
@property (nonatomic, strong) NSString *fileext;
/**
文件大小
 */
@property (nonatomic, assign) long long filesize;
/**
 文件显示大小
 */
@property (nonatomic, strong) NSString *showsize;
/**
 创建时间
 */
@property (nonatomic, strong) NSDate *createdate;
/**
 原图宽
 */
@property (nonatomic, strong) NSString *artworkwidth;
/**
 原图高
 */
@property (nonatomic, strong) NSString *artworkheight;
/**
 文件描述信息
 */
@property (nonatomic, strong) NSString *descripte;
/**
 文件解压缩描述
 */
@property (nonatomic, strong) NSString *filezipdescriptionid;

@end
