//
//  MARFaceBeautyControllerViewController.h
//  MARFaceBeauty
//
//  Created by Maru on 2016/11/12.
//  Copyright © 2016年 Maru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GPUImageShowStyle) {
    GPUImageShowStyleOnlyPhoto = 0,
    GPUImageShowStyleOnlyVideo,
    GPUImageShowStyleAll
};

typedef NS_ENUM(NSUInteger, LZVideoRecordOrientation) {
    LZVideoRecordOrientationPortrait,
    LZVideoRecordOrientationPortraitDown,
    LZVideoRecordOrientationLandscapeRight,
    LZVideoRecordOrientationLandscapeLeft,
};

typedef NS_ENUM(NSUInteger, LZWaterMarkShowStyle) {
    /**
     照片都不显示水印
     */
    LZWaterMarkShowStylePhotoNone,
    /**
     照片只显示信息文字水印
     */
    LZWaterMarkShowStylePhotoInfo,
    /**
     照片显示全部水印
     */
    LZWaterMarkShowStylePhotoLogoAndInfo
};

@protocol MARFaceRecorderVideoDelegate <NSObject>

- (void)finishAliPlayShortVideo:(NSString *)videoPath;

- (void)finishAliPhotoImage:(NSString *)imagePath;

@end

@interface MARFaceBeautyController : UIViewController

@property (nonatomic, assign) id <MARFaceRecorderVideoDelegate> delegate;

@property (nonatomic, assign) GPUImageShowStyle showStyle;
/* 视频限制的时间长度，不传值或为0默认为10秒(单位是秒) */
@property (nonatomic, assign) NSUInteger limitTime;

@property (nonatomic, assign) BOOL isShowEditButton;
// 添加水印的方式
@property (nonatomic, assign) LZWaterMarkShowStyle lzWaterMarkShowStyle;

@end
