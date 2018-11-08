//
//  LZFileTransferForHttp.h
//  LZMobileIM
//
//  Created by MisWCH on 15-4-28.
//  Copyright (c) 2015年 mis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZFileTransfer.h"


@interface LZFileTransferForHttp : LZFileTransfer
{
    
    //url
    NSString *urlString;
    //下载的数据
    NSMutableData *dataNote;
    // 0 : download, 1: upload
    NSInteger fileTransferType;
    
    long long filesize;
    
    NSString *contentType;
    //Content
    long downloaded;
    
    NSURLConnection *connection ;
    
    NSString *token;
    
    int errortimes;
    
    
    BOOL interErrorEvent;
}


//@property ( nonatomic) NSInteger fileTransferType;
//@property (strong, nonatomic) NSString *remotePath;
//@property (strong, nonatomic) NSString *remoteFileName;
//@property (strong, nonatomic) NSString *localPath;
//@property (strong, nonatomic) NSString *localFileName;
//@property (strong, nonatomic) NSString *tag;
//@property (strong, nonatomic) NSString *server;
//@property (strong, nonatomic) NSString *port;
//@property (strong, nonatomic) NSString *protocol;
//@property (nonatomic,strong) NSMutableDictionary *dicInfo;   //其它信息


//
//@property(nonatomic,retain) NSString *urlString;
//
//@property(nonatomic,retain) NSMutableData *dataNote;
//
//-(void)downloadFile;//:(NSString*)filename;
////
//-(void)uploadFile;//:(NSString*)filename;

//-(void)start;

@end
