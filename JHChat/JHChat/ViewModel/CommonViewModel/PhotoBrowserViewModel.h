//
//  PhotoBrowserViewModel.h
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

#import <Foundation/Foundation.h>
#import "MWPhotoBrowser.h"


typedef void (^LZAfterDownloadPhotoBrowserImage)();
typedef void(^LZLoadDownloadImage)(MWPhoto * _Nullable photo,UIImage *_Nullable image);

@interface PhotoBrowserViewModel : NSObject


@property (nonatomic,strong) NSMutableArray * _Nullable sendArr;

/**
 是否缓存文件
 */
@property (nonatomic, assign) BOOL isNotCachefile;
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
-(MWPhoto *_Nullable)getMWPhotModelWithSmallImagePath:(NSString *_Nullable)smallImagePath
                                         oriImagePath:(NSString *_Nullable)oriImagePath
                                    smallThumbnailUrl:(NSString *_Nullable)smallThumbnailUrl
                                      oriThumbnailUrl:(NSString *_Nullable)oriThumbnailUrl
                                         photoBrowser:(MWPhotoBrowser *_Nullable)browser
                                       index:(NSUInteger)index
                                            otherInfo:(NSString *_Nullable)otherInfo
                                  downloadFinishBlock:(LZAfterDownloadPhotoBrowserImage _Nullable )downloadFinishBlock;

/**
 *  发送给联系人操作
 *
 *  @param otherInfo  参数
 */
//+(void)sendMessageWithOtherInfo:(NSString *)otherInfo;



@end
