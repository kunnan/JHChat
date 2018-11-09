//
//  oss_ios_demo.h
//  oss_ios_demo
//
//  Created by zhouzhuo on 9/16/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemotelyServerModel.h"
#import "RemotelyAccountModel.h"
#import "LZFileTransfer.h"
@class UploadFileModel;
typedef void(^UploadProgress)(int64_t progress, NSString *callback);
typedef void(^SuccessBackUrl)(NSString *url);
@interface AliyunOSS : LZFileTransfer


+ (instancetype)sharedInstance;

@property (nonatomic ,copy) UploadProgress progress;
@property (nonatomic, copy) SuccessBackUrl backUrl;
/**
 文件全路径
 */
@property (nonatomic, strong) NSString *AbsolutePath;

/**
 要上传的文件
 */
@property (nonatomic, strong) NSData * data;

/**
 文件显示名
 */
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong)NSString *objectKey;

/**
 url地址是否永久有效
 */
@property (nonatomic, assign) BOOL isread;

+(void)setInstanceToNil;
- (void)setupEnvironment;

- (void)runDemo;

- (void)uploadObjectAsync;

- (void)downloadObjectAsync:(NSString*)objectKey;

-(void)downImageWithKey:(NSString*)objectKey;
// 同步下载
- (void)downloadObjectSync:(NSString*)objectKey;
- (void)resumableUpload;

/**
 获取图片下载的url

 @param objectKey 下载key
 @param fixedOrLfit lfit：等比缩放，限制在设定在指定w与h的矩形内的最大图片。fixed：固定宽高，强制缩略
 @return url
 */
-(NSString *)getDownImageUrlWithObjectKey:(NSString*)objectKey withSize:(NSString*)size fixedOrLfit:(NSString*)parameter isExistedImg:(BOOL)isExistedImg;
@end
