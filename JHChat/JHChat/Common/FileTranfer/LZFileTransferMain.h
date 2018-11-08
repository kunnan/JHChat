//
//  LZFileTransferMain.h
//  LZMobileIM
//
//  Created by MisWCH on 15-4-28.
//  Copyright (c) 2015年 mis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZFileTransfer.h"

@interface LZFileTransferMain : NSObject

+(LZFileTransfer *)getLZFileTransfer:(id)delegate;

+(LZFileTransfer *)getLZFileTransferWithProgress:(LZFileProgressUpload)lzFileProgressUpload success:(LZFileDidSuccessUpload)lzFileDidSuccessUpload error:(LZFileDidErrorUpload)lzFileDidErrorUpload;

@end
