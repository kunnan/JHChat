//
//  TZImagePickerViewModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/5/6.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadFileModel.h"
#import <AVFoundation/AVFoundation.h>
@interface TZImagePickerViewModel : NSObject

/**
 *  处理选择的图片
 *
 *  @param photos                图片信息
 *  @param assets                assets信息
 *  @param isSelectOriginalPhoto 是否原图
 *  @param savePath              物理文件保存沙盒路径
 *  @param block                 回调
 */
-(void)operateSelectedPhotos:(NSArray<UIImage *> *)photos
                      assets:(NSArray *)assets
       isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
                    savePath:(NSString *)savePath
                    callBack:(void (^)(NSMutableArray *backArr))block;

/**
 *  保存文件
 */
-(UploadFileModel *)savePhotoAndReturnModel:(NSData *)data
                                   savePath:(NSString *)savePath
                           filePhysicalName:(NSString *)filePhysicalName
                               fileShowName:(NSString *)fileShowName
                                  showIndex:(NSInteger)showIndex;

/**
 *  处理选择的视频
 *
 *  @param coverImage 视频封面
 *  @param asset      视频
 *  @param block      回调
 */
- (void)operateSelectedVideo:(UIImage *)coverImage
                       asset:(id)asset
                    savePath:(NSString *)savePath
                  smallPaths:(NSString *)smallPaths
                    callBack:(void(^)(NSString *imageName, NSString *path, NSString *filePhysicalName))block;

/**
 视频压缩
 
 @param url url
 */
//+(void)compressVideo:(NSURL*)url completion:(void(^)(NSString *path))completion;
+ (void)compressVideoWithInputURL:(NSURL*)inputURL
                      outputURL:(NSURL*)outputURL
                   blockHandler:(void (^)(AVAssetExportSession*))handler;
@end
