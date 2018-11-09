//
//  PhotoBrowserViewModel.m
//  LeadingCloud
//
//  Created by wchMac on 16/4/6.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-04-06
 Version: 1.0
 Description: 通用浏览图片处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "PhotoBrowserViewModel.h"
#import "SDWebImageDownloader.h"
#import "UIImage+MultiFormat.h"
#import "LCProgressHUD.h"
#import "UploadFileModel.h"
#import "NSString+SerialToDic.h"
#import "SelectMessageRootViewController.h"
#import "MWZoomingScrollView.h"
#import "AppUtils.h"
#import "LargeImageModel.h"
#import "SDWebImageCodersManager.h"
#import "SDWebImageManager.h"
#import "NSData+ImageContentType.h"
#import "FLAnimatedImageView+WebCache.h"

@implementation PhotoBrowserViewModel

/**
 *  获取浏览控件所需要的photo
 *
 *  @param smallImagePath      小图本地路径
 *  @param oriImagePath        大图本地路径
 *  @param smallThumbnailUrl   小图Url地址
 *  @param oriThumbnailUrl     大图Url地址
 *  @param browser             浏览控件
 *  @param index               顺序号
 *  @param downloadFinishBlock 下载完成后的回调
 *
 *  @return 浏览控件所需的photo
 */

- (void)loadGifIMage:(UIImage*)image ImageData:(NSData*)imageData Photo:(MWPhoto*)photo Complete:(LZLoadDownloadImage)complete {

	BOOL shouldDecode = YES;
	// Do not force decoding animated GIFs and WebPs
	//		if (image.images) {
	//			shouldDecode = NO;
	//		} else {
	//#ifdef SD_WEBP
	//			SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:imageData];
	//			if (imageFormat == SDImageFormatWebP) {
	//				shouldDecode = NO;
	//			}
	//#endif
	//		}
	//
	if (shouldDecode) {
		BOOL shouldScaleDown = SDWebImageDownloaderScaleDownLargeImages;
		image = [[SDWebImageCodersManager sharedInstance] decompressedImageWithImage:image data:&imageData options:@{SDWebImageCoderScaleDownLargeImagesKey: @(shouldScaleDown)}];
	}
	
	[photo upImage:image];
//	MWPhoto *photo = [MWPhoto photoWithImage:image];
	
	complete(photo,image);

}

-(MWPhoto *)getMWPhotModelWithSmallImagePath:(NSString *)smallImagePath
                                oriImagePath:(NSString *)oriImagePath
                           smallThumbnailUrl:(NSString *)smallThumbnailUrl
                             oriThumbnailUrl:(NSString *)oriThumbnailUrl
                                photoBrowser:(MWPhotoBrowser *)browser
                                       index:(NSUInteger)index
                                   otherInfo:(NSString *)otherInfo
                         downloadFinishBlock:(LZAfterDownloadPhotoBrowserImage)downloadFinishBlock{
    
    /* 判断原图是否存在 */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    RemotelyServerModel *remotelyServerModel = [[AliyunRemotrlyServerDAL shareInstance] getServerModelWithRfsType:@"oss"];
    //    NSUserDefaults *userDefaluts2 = [NSUserDefaults standardUserDefaults];
    //    NSString *downid = [userDefaluts2 objectForKey:@"downfileid"];
    //    //    // 如果是在这个分区就是阿里云查看
    //    if ([downid longLongValue] > [remotelyServerModel.minpartition longLongValue]) {
    //        [AliyunOSS sharedInstance].AbsolutePath = [NSString stringWithFormat:@"%@%@",_scanFileAbsolutePath,[NSString stringWithFormat:@"%@.%@",_scanFileExpId,[self getExpType]]];
    //        [[AliyunOSS sharedInstance] setupEnvironment];
    //
    //        [[AliyunOSS sharedInstance] downImageWithKey:downid];
    //
    //        return;
    //    }

    if([fileManager fileExistsAtPath:oriImagePath] && !_isNotCachefile){
        
        //wzb ——0503 改  此处不对啊
		
        NSData *data=[NSData dataWithContentsOfFile:oriImagePath];
//
		UIImage *image = [UIImage sd_imageWithData:data];
        

		NSString *dePath = [NSString stringWithFormat:@"%@%@",oriImagePath,@"des"];
		UIImage *smallImage = [UIImage imageWithContentsOfFile:dePath];
		MWPhoto *photo = [MWPhoto photoWithImage:smallImage];
		photo.otherInfo =otherInfo;
		photo.isStillShowLoadingAfterShow = NO;
		photo.photoIndex = index;
		photo.imageData = data;
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			
			[self loadGifIMage:image ImageData:data Photo:photo Complete:^(MWPhoto * _Nullable photo ,UIImage *_Nullable image) {
//				photo.otherInfo =otherInfo;
//				photo.isStillShowLoadingAfterShow = NO;
//				photo.photoIndex = index;
				photo.imageData = data;
				[self saveImage:image Path:oriImagePath];
				dispatch_async(dispatch_get_main_queue(), ^{
					[browser didStartReloadPhotoView:index image:image photo:photo];
				});
			}];
		});


//		UIImage *image =
		
//		[[[LargeImageModel alloc]init]getLargeImagePath:oriImagePath LargeCompleBlock:^(UIImage *image) {
//			MWPhoto *photo = [MWPhoto photoWithImage:image];
//			photo.otherInfo = otherInfo;
//			photo.photoIndex = index;
//			dispatch_async(dispatch_get_main_queue(), ^{
//			[browser didStartReloadPhotoView:index image:image photo:photo];
//			});
//		}];
//        UIImage *orImage=[UIImage sd_imageWithData:data];
        // 0503
//               UIImage *oriImage=[[UIImage alloc] initWithContentsOfFile:oriImagePath];

        return photo;
    }
    else {
        /* 原图不存在，判断小图是否存在 */
        if([fileManager fileExistsAtPath:smallImagePath]){
            UIImage *smallImage = [UIImage imageWithContentsOfFile:smallImagePath];

            //UIImage *smallImage=[[UIImage alloc] initWithContentsOfFile:smallImagePath];
            MWPhoto *photo = [MWPhoto photoWithImage:smallImage];
            photo.isStillShowLoadingAfterShow = YES;
            photo.photoIndex = index;
            
            /* 小图存在，开始下载原图 */
            [self downLoadImageWithOriThembnailUrl:oriThumbnailUrl oriImagePath:oriImagePath photoBrowser:browser index:index size:2 otherInfo:otherInfo downloadFinishBlock:^{
                downloadFinishBlock();
            }];
            
            return photo;
        }
        else {
            
            //            MWPhoto *photo = [MWPhoto photoWithImage:[UIImage imageNamed:@"msg_chat_placeholderImage"]];
                
            MWPhoto *photo = [MWPhoto photoWithImage:[ImageManager LZGetImageByFileName:@"common_default_image_icon"]];
            photo.isStillShowLoadingAfterShow = YES;
            photo.photoIndex = index;
            
            if(index==7){
//                DDLogError(@"-----%@",)
            }
            // 直接下载原图
            if ([NSString isNullOrEmpty:smallThumbnailUrl]) {
                /* 开始下载大图 */
                if(![fileManager fileExistsAtPath:oriImagePath]){
                    [self downLoadImageWithOriThembnailUrl:oriThumbnailUrl oriImagePath:oriImagePath photoBrowser:browser index:index size:2 otherInfo:otherInfo downloadFinishBlock:^{
                        downloadFinishBlock();
                    }];
                }
            }
            else {
                /* 小图和原图都不存在 */
                [self downLoadImageWithOriThembnailUrl:smallThumbnailUrl oriImagePath:smallImagePath photoBrowser:browser index:index size:1 otherInfo:otherInfo downloadFinishBlock:^{
                    /* 开始下载大图 */
                    if(![fileManager fileExistsAtPath:oriImagePath] || _isNotCachefile){
                        [self downLoadImageWithOriThembnailUrl:oriThumbnailUrl oriImagePath:oriImagePath photoBrowser:browser index:index size:2 otherInfo:otherInfo downloadFinishBlock:^{
                            downloadFinishBlock();
                        }];
                    }
                }];
            }
            return photo;
        }
    }
}

- (void)saveImage:(UIImage*)image Path:(NSString*)path{
	
		@autoreleasepool {
			NSData *data ;
			if (image) {
				// If we do not have any data to detect image format, check whether it contains alpha channel to use PNG or JPEG format
				SDImageFormat format;
				if (SDCGImageRefContainsAlpha(image.CGImage)) {
					format = SDImageFormatPNG;
				} else {
					format = SDImageFormatJPEG;
				}
				data = [[SDWebImageCodersManager sharedInstance] encodedDataWithImage:image format:format];
			}
			//保存图片
			NSString *dePath = [NSString stringWithFormat:@"%@%@",path,@"des"];
			NSFileManager *fileManager = [NSFileManager defaultManager];
			[fileManager createFileAtPath:dePath contents:data attributes:nil];

			}
		
}


/**
 *  下载图片
 *
 *  @param oriThumbnailUrl     图片地址
 *  @param oriImagePath        图片客户端文件路径
 *  @param browser             浏览控件
 *  @param index               顺序号
 *  @param downloadFinishBlock 下载完成后的回调
 */
-(void)downLoadImageWithOriThembnailUrl:(NSString *)oriThumbnailUrl
                           oriImagePath:(NSString *)oriImagePath
                           photoBrowser:(MWPhotoBrowser *)browser
                                  index:(NSUInteger)index
                                   size:(NSUInteger)size
                              otherInfo:(NSString *)otherInfo
                    downloadFinishBlock:(LZAfterDownloadPhotoBrowserImage)downloadFinishBlock{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:[AppUtils urlToNsUrl:oriThumbnailUrl]
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                
                                // progression tracking code
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               
                              
                               if (image && finished) {
                                   
                                   /* 刷新UI */
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       //wzb 改 20170503
									   
//									   [[[LargeImageModel alloc]init]getLargeImage:image LargeCompleBlock:^(UIImage *image) {
										   MWPhoto *photo = [MWPhoto photoWithImage:image];
										   photo.otherInfo = otherInfo;
										   photo.photoIndex = index;
										   photo.imageData = data;
										   if([browser.lzTag isEqualToString:@"grid"]){
											   photo.isStillShowLoadingAfterShow = NO;
											   //[activity stopActivity];
											   [browser didStartReloadGridView:index image:image photo:photo];
										   }
										   else {
											   photo.isStillShowLoadingAfterShow = size==1;
											   [browser didStartReloadPhotoView:index image:image photo:photo];
										   }
									   
//									   }];

                                   });
                                   if (!_isNotCachefile) {
                                       NSLog(@"保存了文件");
                                       /* 保存文件 */
                                       [fileManager createFileAtPath:oriImagePath contents:data attributes:nil];
                                       _isNotCachefile = NO;
                                   }
                                    /* 更新数据库 */
                                   downloadFinishBlock();
                               }
                               else {
                                   /* 小图下载失败 */
                                   if(size==1){
                                       /* 刷新UI */
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           /* 判断网络是否连通 */
                                           if (![LZUserDataManager readIsConnectNetWork]) {
                                                                                      
                                               UIImage *failImage = [ImageManager LZGetImageByFileName:@"common_default_image_icon"];
                                               MWPhoto *failPhoto = [MWPhoto photoWithImage:failImage];
                                               failPhoto.photoIndex = index;
                                               /* 无网络状态加载 */
                                               if([browser.lzTag isEqualToString:@"grid"]){
                                                    [browser didStartReloadGridView:index image:failImage photo:failPhoto];
                                               }
                                               else {
                                                   [browser didStartReloadPhotoView:index image:failImage photo:failPhoto];
                                               }
                                           } else {
                                                                                      
                                               UIImage *failImage = [ImageManager LZGetImageByFileName:@"common_default_image_fail"];
                                               MWPhoto *failPhoto = [MWPhoto photoWithImage:failImage];
                                               failPhoto.photoIndex = index;
        //                                       photo.otherInfo = otherInfo;
                                               /* 图片下载失败 */
                                               if([browser.lzTag isEqualToString:@"grid"]){
                                                   [browser didStartReloadGridView:index image:failImage photo:failPhoto];
                                               }
                                               else {
                                                   [browser didStartReloadPhotoView:index image:failImage photo:failPhoto];
                                               }
                                           }
                                       });
                                   }
                                   /* 原图下载失败 */
                                   else if(size==2){
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if(![browser.lzTag isEqualToString:@"grid"]){
                                               [browser didLoadPhotoViewFail:index];
                                           }
                                       });
                                   }
                               }
                           }];
}

@end
