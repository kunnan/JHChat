//
//  CLGPUImageVignetteFilter.m
//
//  Created by sho yakushiji on 2014/01/28.
//  Copyright (c) 2014年 CALACULU. All rights reserved.
//

#if __has_include("GPUImage.h")

#import "CLGPUImageVignetteFilter.h"

#import "GPUImage.h"
@implementation CLGPUImageVignetteFilter

+ (CGFloat)defaultDockedNumber
{
    return 2.5;
}

+ (NSString*)defaultTitle
{
    return [CLImageEditorTheme localizedString:@"CLGPUImageVignetteFilter_DefaultTitle" withDefault:@"Vignette2"];
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5);
}

#pragma mark-

+ (UIImage*)applyFilter:(UIImage*)image
{
    GPUImagePicture *imageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageVignetteFilter *filter = [[GPUImageVignetteFilter alloc] init];
    
    [imageSource addTarget:filter];
    [imageSource processImage];
    // 改成自己工程里面的方法
//    return  [UIImage imageWithCGImage: [filter newCGImageFromCurrentlyProcessedOutput]];
//    modify by wch on 2018-06-08
    CGImageRef imageRef = [filter newCGImageFromCurrentlyProcessedOutput];
    UIImage *returnImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    return returnImage;
}

@end

#endif
