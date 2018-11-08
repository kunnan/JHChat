//
//  LZFileTransfer.m
//  LZMobileIM
//
//  Created by MisWCH on 15-4-29.
//  Copyright (c) 2015年 mis. All rights reserved.
//

#import "LZFileTransfer.h"

@implementation LZFileTransfer


@synthesize localFileName = _localFileName;
@synthesize remotePath = _remotePath;
@synthesize remoteFileName = _remoteFileName;
@synthesize tag = _tag;
@synthesize server = _server;
@synthesize port = _port;
@synthesize protocol = _protocol;
@synthesize otherInfo = _otherInfo;
@synthesize showFileName = _showFileName;
@synthesize isUserLeading = _isUserLeading;
@synthesize isReadfile = _isReadfile;

//文件下载
-(void)downloadFile;//:(NSString*)filename;
{}

//停止文件下载
-(void)downloadFilePause
{}

//文件上传
-(void)uploadFile;//:(NSString*)filename;
{}

//停止文件上传
-(void)uploadFilePause
{}

//- (MainAppDelegate *)appDelegate
//{
//    MainAppDelegate *appDelegate = (MainAppDelegate *)[[UIApplication sharedApplication] delegate];
//    return appDelegate;
//}

@end
