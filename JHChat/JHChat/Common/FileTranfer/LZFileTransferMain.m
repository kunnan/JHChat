//
//  LZFileTransferMain.m
//  LZMobileIM
//
//  Created by MisWCH on 15-4-28.
//  Copyright (c) 2015年 mis. All rights reserved.
//

#import "LZFileTransferMain.h"
#import "LZFileTransferForHttp.h"
@implementation LZFileTransferMain

+(LZFileTransfer *)getLZFileTransfer:(id)delegate
{
    LZFileTransferForHttp *lzFileTransfer = [[LZFileTransferForHttp alloc] init];
    lzFileTransfer.delegate = delegate;
    
    return lzFileTransfer;
}

+(LZFileTransfer *)getLZFileTransferWithProgress:(LZFileProgressUpload)lzFileProgressUpload success:(LZFileDidSuccessUpload)lzFileDidSuccessUpload error:(LZFileDidErrorUpload)lzFileDidErrorUpload
{
    LZFileTransferForHttp *lzFileTransfer = [[LZFileTransferForHttp alloc] init];
    lzFileTransfer.lzFileProgressUpload=lzFileProgressUpload;
    lzFileTransfer.lzFileDidSuccessUpload = lzFileDidSuccessUpload;
    lzFileTransfer.lzFileDidErrorUpload = lzFileDidErrorUpload;

    
    
    return lzFileTransfer;
}

@end
