//
//  TZImagePickerViewModel.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/6.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "TZImagePickerViewModel.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <photos/PHAsset.h>
#import <photos/PHImageManager.h>
#import "NSString+IsNullOrEmpty.h"
#import "TZImageManager.h"
#import "FilePathUtil.h"
#import "UIImage+Rotation.h"
@implementation TZImagePickerViewModel

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
                    callBack:(void (^)(NSMutableArray *backArr))block{
    //    NSString *savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
    
    NSMutableArray *sendArr = [[NSMutableArray alloc] init];

    __block NSInteger saveCount = 0; //处理的数量，异步使用
    for(int i=0;i<assets.count;i++){
        id photoData=[assets objectAtIndex:i];
        __block NSData *data = nil; //图片数据
        NSString *fileShowName = @""; //图片显示名称
        NSString *extendName = @""; //图片后缀名
        NSString *filePhysicalName = @""; //图片磁盘名称
        /* 判断PHasset或ALasset */
        if([photoData isKindOfClass:[PHAsset class]]){//PHAsset
            fileShowName=[photoData valueForKey:@"filename"];
            extendName=[fileShowName pathExtension];
            filePhysicalName = [NSString stringWithFormat:@"%@_%d.%@",[LZFormat FormatNow2String],i,extendName];
            /* 判断是否选择原图 */
            if(isSelectOriginalPhoto==YES || [[extendName lowercaseString] isEqualToString:@"gif"]){//原图
                [[PHImageManager defaultManager] requestImageDataForAsset:photoData options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    
                    data = [NSData dataWithData:imageData];
                    data = UIImageJPEGRepresentation([UIImage fixOrientation:[UIImage imageWithData:data]], 0.82);
                    /* ios11高效live图 */
//                    if([[fileShowName lowercaseString] hasSuffix:@"heic"]){
//                        data = UIImageJPEGRepresentation([UIImage fixOrientation:[UIImage imageWithData:data]], 0.82);
////                        UIImage *heicImg = [UIImage imageWithData:data];
////                        /* 微信目前的处理方式是转换成了 jpg 格式，因此直接使用 UIImageJPEGRepresentation(originalImage, 0.82); 转换为jpg即可 */
////                        data = UIImageJPEGRepresentation(heicImg, 0.82);
//                    }
                    
                    /* 保存图片 */
                    UploadFileModel *fileModel = [self savePhotoAndReturnModel:data savePath:savePath filePhysicalName:filePhysicalName fileShowName:fileShowName showIndex:i];
                    if(fileModel!=nil){
                        [sendArr addObject:fileModel];
                    }
                    saveCount += 1;
                    
                    /* 原图处理完，调用回调接口进行发送 */
                    if(saveCount == assets.count){
                        [self sendSureWithArr:sendArr callBack:block];
                        return;
                    }
                }];
            }else{//非原图
                data = UIImageJPEGRepresentation([photos objectAtIndex:i], 0.5);
    
                /* 保存图片 */
                UploadFileModel *fileModel = [self savePhotoAndReturnModel:data savePath:savePath filePhysicalName:filePhysicalName fileShowName:fileShowName showIndex:i];
                if(fileModel!=nil){
                    [sendArr addObject:fileModel];
                }
                
                saveCount += 1;
            }
        }
        else if([photoData isKindOfClass:[ALAsset class]]){//ALAsset
            ALAssetRepresentation *representation = [photoData defaultRepresentation];
            fileShowName=[representation filename];
            extendName=[fileShowName pathExtension];
            filePhysicalName = [NSString stringWithFormat:@"%@_%d.%@",[LZFormat FormatNow2String],i,extendName];
            /* 判断是否选择原图 */
            if(isSelectOriginalPhoto==YES){//原图
                uint8_t *buffer = (Byte*)malloc((NSInteger)representation.size);
                NSUInteger length = [representation getBytes:buffer fromOffset: 0.0  length:(NSInteger)representation.size error:nil];
                if (length != 0)  {
                    data = [[NSData alloc] initWithBytesNoCopy:buffer length:(NSInteger)representation.size freeWhenDone:YES];
                } else {
                    free(buffer);
                }
            }else{//非原图
                data=UIImageJPEGRepresentation([photos objectAtIndex:i], 0.9);
            }
            
            /* 保存图片8. Potential leak of memory pointed to by 'buffer' */
            UploadFileModel *fileModel = [self savePhotoAndReturnModel:data savePath:savePath filePhysicalName:filePhysicalName fileShowName:fileShowName showIndex:i];
            if(fileModel!=nil){
                [sendArr addObject:fileModel];
            }
            
            saveCount += 1;
        }
    }
    if(saveCount == assets.count){
        /* 发送 */
        [self sendSureWithArr:sendArr callBack:block];
        return;
    }
}
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
                    callBack:(void(^)(NSString *imageName, NSString *path, NSString *filePhysicalName))block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"计时-1");
        /* 这段代码发送视频 */
        [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
            NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
            NSLog(@"计时-7");
            // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
            NSString *extendName = @""; //后缀名
            NSString *filePhysicalName = @""; //磁盘名称
            extendName = [outputPath pathExtension];
            filePhysicalName = [NSString stringWithFormat:@"%@.%@",[LZFormat FormatNow2String],extendName];
            NSString *newPlistPath = [savePath stringByAppendingFormat:@"%@",filePhysicalName];
            /* 把文件保存到沙盒 */
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSLog(@"计时-8");
            /* 将选择的视频进行压缩 */
            [TZImagePickerViewModel compressVideoWithInputURL:[NSURL fileURLWithPath:outputPath] outputURL:[NSURL fileURLWithPath:newPlistPath] blockHandler:^(AVAssetExportSession *session) {
                NSLog(@"计时-10");
                if (session.status == AVAssetExportSessionStatusCompleted) {
                    NSData *data = [NSData dataWithContentsOfFile:newPlistPath];
                    NSLog(@"压缩后视频的大小：%lu",(unsigned long)data.length);
                    NSLog(@"压缩完成");
                    /* 将视频文件上传 */
                    NSString *imageName = [NSString stringWithFormat:@"%@.%@",[LZFormat FormatNow2String],@"PNG"];
                    NSString *filePath = [smallPaths stringByAppendingPathComponent:imageName];  // 保存文件的名称
                    [UIImagePNGRepresentation(coverImage)writeToFile:filePath atomically:YES]; // 将图片写入文件
                    /* 删除原路径的视频 */
                    [fileManager removeItemAtPath:outputPath error:nil];
                    NSLog(@"计时-11");
                    block(imageName, newPlistPath, filePhysicalName);
                }else if (session.status == AVAssetExportSessionStatusFailed) {
                    NSLog(@"压缩失败");
                }
            }];
        }];
    });
}

/**
 *  保存文件
 */
-(UploadFileModel *)savePhotoAndReturnModel:(NSData *)data
                      savePath:(NSString *)savePath
              filePhysicalName:(NSString *)filePhysicalName
                  fileShowName:(NSString *)fileShowName
                     showIndex:(NSInteger)showIndex{
    /* 保存图片 */
    if(data!=nil){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        /* ios11高效live图 */
        if([[fileShowName lowercaseString] hasSuffix:@"heic"]){
            if([fileShowName rangeOfString:@"."].location!=NSNotFound){
                fileShowName = [fileShowName stringByReplacingOccurrencesOfString:@"HEIC" withString:@"JPG"];
                filePhysicalName = [filePhysicalName stringByReplacingOccurrencesOfString:@"HEIC" withString:@"JPG"];
            }
            
        }
        if(![NSString isNullOrEmpty:savePath]){
            [fileManager createFileAtPath:[savePath stringByAppendingFormat:@"%@",filePhysicalName] contents:data attributes:nil];
        }        
        
        UploadFileModel *fileModel = [[UploadFileModel alloc] init];
        fileModel.filePhysicalName = filePhysicalName;
        fileModel.fileShowName = fileShowName;
        fileModel.data = data;
        fileModel.showIndex = showIndex;
        return fileModel;
    }
    return nil;
}

/**
 *  确定
 *
 *  @param sendArr 选择的图片
 *  @param block   接口回调
 */
-(void)sendSureWithArr:(NSMutableArray *)sendArr callBack:(void (^)(NSMutableArray *backArr))block{
    
    /* 重新进行排序，避免gif和普通图片混选时顺序出错问题 */
    [sendArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UploadFileModel *fileModel1 = obj1;
        UploadFileModel *fileModel2 = obj2;
        
        NSInteger showIndex1 = fileModel1.showIndex;
        NSInteger showIndex2 = fileModel2.showIndex;
        if (showIndex1 > showIndex2) {
            return NSOrderedDescending;
        } else if (showIndex1 < showIndex2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    block(sendArr);
}

#pragma mark - 视频压缩
+ (void)compressVideoWithInputURL:(NSURL*)inputURL
                        outputURL:(NSURL*)outputURL
                     blockHandler:(void (^)(AVAssetExportSession*))handler {
    NSLog(@"计时-9");
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
        /* 设置输出视频的质量 */
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        session.outputURL = outputURL;
        session.outputFileType = AVFileTypeMPEG4;
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            handler(session);
            /* 压缩完后删除原视频 */
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *inputPath = [[inputURL absoluteString] substringFromIndex:7];
            if ([fileManager fileExistsAtPath:inputPath]) {
                [fileManager removeItemAtPath:inputPath error:nil];
            }
        }];
//    });
}

@end
