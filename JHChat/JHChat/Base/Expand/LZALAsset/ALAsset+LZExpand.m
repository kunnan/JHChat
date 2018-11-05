//
//  ALAsset+LZExpand.m
//  LeadingCloud
//
//  Created by wchMac on 16/4/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "ALAsset+LZExpand.h"
#import <objc/runtime.h>

static const void *AssetUrl = &AssetUrl;
static const void *ImageName = &ImageName;
static const void *ImageSize = &ImageSize;

@implementation ALAsset (LZExpand)

/**
 *  图片Url地址
 */
@dynamic assetUrl;
- (NSURL *)assetUrl {
    NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
    [mediaInfo setObject:[self valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
    [mediaInfo setObject:[UIImage imageWithCGImage:[[self defaultRepresentation] fullScreenImage]] forKey:@"UIImagePickerControllerOriginalImage"];
    [mediaInfo setObject:[[self valueForProperty:ALAssetPropertyURLs] valueForKey:[[[self valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
    
    NSURL *newImageURL = [mediaInfo valueForKey:UIImagePickerControllerReferenceURL];
    
    return newImageURL;
//    return objc_getAssociatedObject(self, AssetUrl);
}
//- (void)setAssetUrl:(NSURL *)assetUrl{
//    objc_setAssociatedObject(self, AssetUrl, assetUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}


/**
 *  图片名称
 */
@dynamic imageName;
- (NSString *)imageName {
    return objc_getAssociatedObject(self, ImageName);
}
- (void)setImageName:(NSString *)imageName{
    objc_setAssociatedObject(self, ImageName, imageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/* 获取图片名称 */
- (void)getAssetImageName:(LZAssetGetImageName)getImageBlock{
    NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
    [mediaInfo setObject:[self valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
    [mediaInfo setObject:[UIImage imageWithCGImage:[[self defaultRepresentation] fullScreenImage]] forKey:@"UIImagePickerControllerOriginalImage"];
    [mediaInfo setObject:[[self valueForProperty:ALAssetPropertyURLs] valueForKey:[[[self valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
    
    NSURL *newImageURL = [mediaInfo valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        NSString *fileName = [representation filename];//原始名称
        if(getImageBlock){
            getImageBlock(fileName,nil);
        }
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:newImageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
}

/**
 *  图片大小
 */
@dynamic imageSize;
- (NSString *)imageSize {
    return objc_getAssociatedObject(self, ImageSize);
}
- (void)setImageSize:(NSString *)imageSize{
    objc_setAssociatedObject(self, ImageSize, imageSize, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
