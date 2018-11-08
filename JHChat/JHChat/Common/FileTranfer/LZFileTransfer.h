//
//  LZFileTransfer.h
//  LZMobileIM
//
//  Created by MisWCH on 15-4-29.
//  Copyright (c) 2015年 mis. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "FileModel.h"

/**
 *  接口回调
 */
@protocol LZFileTransferDelegate <NSObject>

@optional

-(void) didErrorDownload:(NSString*) title message:(NSString*)message tag:(NSString *)tag otherInfo:(id)info;
-(void) didErrorUpload:(NSString*) title message:(NSString*)message tag:(NSString *)tag otherInfo:(id)info;

-(void) didSuccessDownload:(NSDictionary *)result tag:(NSString *)tag otherInfo:(id)info;
-(void) didSuccessUpload:(NSDictionary *)result tag:(NSString *)tag otherInfo:(id)info;

-(void) progressDetailDownload:(NSInteger)bytesWritten
             totalBytesWritten:(NSInteger)totalBytesWritten
                   totalLength:(NSInteger)totalLength
                           tag:(NSString *)tag
                     otherInfo:(id)info;

-(void) progressDetailUpload:(NSInteger)bytesWritten
           totalBytesWritten:(NSInteger)totalBytesWritten
                 totalLength:(NSInteger)totalLength
                         tag:(NSString *)tag
                   otherInfo:(id)info;

-(void) progressDownload:(float)percent tag:(NSString *)tag otherInfo:(id)info;
-(void) progressUpload:(float)percent tag:(NSString *)tag otherInfo:(id)info;

@end

/**
 *  block回调
 */
typedef void (^LZFileDidErrorUpload)(NSString *title, NSString *message, NSString *tag, id otherInfo);
typedef void (^LZFileDidErrorDownload)(NSString *title, NSString *message, NSString *tag, id otherInfo);

typedef void (^LZFileDidSuccessUpload)(NSDictionary *result, NSString *tag, id otherInfo);
typedef void (^LZFileDidSuccessDownload)(NSDictionary *result, NSString *tag, id otherInfo);

typedef void (^LZFileProgressUpload)(float percent, NSString *tag, id otherInfo);
typedef void (^LZFileProgressDownload)(float percent, NSString *tag, id otherInfo);

/**
 *  文件传输基类
 */
@interface LZFileTransfer : NSObject
{
}

@property (strong, nonatomic) NSString *remotePath;
@property (strong, nonatomic) NSString *remoteFileName;
@property (strong, nonatomic) NSString *localPath;
@property (strong, nonatomic) NSString *localFileName;
@property (strong, nonatomic) NSString *tag;
@property (strong, nonatomic) NSString *server;
@property (strong, nonatomic) NSString *port;
@property (strong, nonatomic) NSString *protocol;
@property (strong, nonatomic) NSString *showFileName;
@property (assign,nonatomic) BOOL isUserLeading;

@property (nonatomic,strong)  id otherInfo;   //其它信息

@property (nonatomic,assign) NSInteger maxErrorTimes;

/**
 是否把文件上传都永久区
 */
@property (nonatomic, assign) BOOL isReadfile;


/* block 方法 */
@property (copy, nonatomic) LZFileDidErrorUpload lzFileDidErrorUpload;
@property (copy, nonatomic) LZFileDidErrorDownload lzFileDidErrorDownload;

@property (copy, nonatomic) LZFileDidSuccessUpload lzFileDidSuccessUpload;
@property (copy, nonatomic) LZFileDidSuccessDownload lzFileDidSuccessDownload;

@property (copy, nonatomic) LZFileProgressUpload lzFileProgressUpload;
@property (copy, nonatomic) LZFileProgressDownload lzFileProgressDownload;

/* 上传文件时，使用的url地址 */
@property (strong, nonatomic) NSString *uploadUrl;
/* 下载文件时，使用的url地址 */
@property (strong, nonatomic) NSString *downloadUrl;
/* 下载的文件大小 */
@property (nonatomic, assign) long long downloadFileSize;
/* 文件下载id */
@property (nonatomic, strong) NSString *fileDownId;
@property (nonatomic, assign) BOOL isNotUserAliyun;

@property (nonatomic, assign) BOOL isCustomUploadUrl;


/* post模式下载数据时传递的数据 */
@property (nonatomic, strong) NSMutableDictionary *postDataForDownload;

@property(assign,nonatomic) id<LZFileTransferDelegate> delegate;

//文件下载
-(void)downloadFile;//:(NSString*)filename;

//停止文件下载
-(void)downloadFilePause;

//文件上传
-(void)uploadFile;//:(NSString*)filename;

//停止文件上传
-(void)uploadFilePause;

//- (MainAppDelegate *)appDelegate;
@end
