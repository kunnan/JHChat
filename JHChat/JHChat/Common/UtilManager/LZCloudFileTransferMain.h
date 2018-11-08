//
//  LZCloudFileTransferMain.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-18
 Version: 1.0
 Description: 文件上传类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFileTransferMain.h"
#import "LZFileTransfer.h"
#import "LZFileTransferForHttp.h"

@interface LZCloudFileTransferMain : LZFileTransferMain

///**
// *  文件上传，使用block进行回调
// *
// *  @param IsTemp 是否上传到临时区
// *  @param lzFileProgressUpload   上传进度block
// *  @param lzFileDidSuccessUpload 上传成功block
// *  @param lzFileDidErrorUpload   上传失败block
// *
// *  @return LZFileTransfer
// */
//+(LZFileTransfer *)getLZFileTransferForUploadWithIsTemp:(BOOL)istemp Progress:(LZFileProgressUpload)lzFileProgressUpload success:(LZFileDidSuccessUpload)lzFileDidSuccessUpload error:(LZFileDidErrorUpload)lzFileDidErrorUpload;

/**
 *  文件上传，使用block进行回调
 *
 *  @param fileType 文件类型
 *  @param lzFileProgressUpload   上传进度block
 *  @param lzFileDidSuccessUpload 上传成功block
 *  @param lzFileDidErrorUpload   上传失败block
 *
 *  @return LZFileTransfer
 */
+(LZFileTransfer *)getLZFileTransferForUploadWithFileType:(NSString *)fileType Progress:(LZFileProgressUpload)lzFileProgressUpload success:(LZFileDidSuccessUpload)lzFileDidSuccessUpload error:(LZFileDidErrorUpload)lzFileDidErrorUpload;

/**
 *  文件替换，使用block进行回调
 *
 *  @param IsTemp 是否上传到临时区
 *  @param lzFileProgressUpload   上传进度block
 *  @param lzFileDidSuccessUpload 上传成功block
 *  @param lzFileDidErrorUpload   上传失败block
 *
 *  @return LZFileTransfer
 */
+(LZFileTransfer *)getLZFileReplaceTransferForUploadWithFiledid:(NSString*)fileid Progress:(LZFileProgressUpload)lzFileProgressUpload success:(LZFileDidSuccessUpload)lzFileDidSuccessUpload error:(LZFileDidErrorUpload)lzFileDidErrorUpload;
/**
 文件上传 - 通过完整URL地址上传
 
 @param uploadurl 上传的URL
 @param lzFileProgressUpload 上传进度
 @param lzFileDidSuccessUpload 上传成功
 @param lzFileDidErrorUpload 上传失败
 @return return value description
 */
+(LZFileTransfer *)getLzFileUploadForUploadURLWithURL:(NSString*)uploadurl Progress:(LZFileProgressUpload)lzFileProgressUpload success:(LZFileDidSuccessUpload)lzFileDidSuccessUpload error:(LZFileDidErrorUpload)lzFileDidErrorUpload;
///**
// *  文件下载，使用delegate进行回调
// *
// *  @param dic      下载所需数据
// *  @param delegate 调用源
// *
// *  @return LZFileTransfer
// */
//+(LZFileTransfer *)getLZFileTransForUploadWithDic:(NSMutableDictionary *)dic delegate:(id)delegate;
//
///**
// *  文件下载，使用block进行回调
// *
// *  @param IsTemp 是否上传到临时区
// *  @param lzFileProgressDownload   下载进度block
// *  @param lzFileDidSuccessDownload 下载成功block
// *  @param lzFileDidErrorDownload   下载失败block
// *
// *  @return LZFileTransfer
// */
//+(LZFileTransfer *)getLZFileTransferForDownloadWithDic:(NSMutableDictionary *)dic Progress:(LZFileProgressDownload)lzFileProgressDownload success:(LZFileDidSuccessDownload)lzFileDidSuccessDownload error:(LZFileDidErrorDownload)lzFileDidErrorDownload;

/**
 *  文件下载(Url方式)，使用block进行回调
 *
 *  @param IsTemp 是否上传到临时区
 *  @param lzFileProgressDownload   下载进度block
 *  @param lzFileDidSuccessDownload 下载成功block
 *  @param lzFileDidErrorDownload   下载失败block
 *
 *  @return LZFileTransfer
 */
+(LZFileTransfer *)getLZFileTransferForDownloadWithUrl:(NSString *)downloadUrl Progress:(LZFileProgressDownload)lzFileProgressDownload success:(LZFileDidSuccessDownload)lzFileDidSuccessDownload error:(LZFileDidErrorDownload)lzFileDidErrorDownload;

@end
