//
//  ALAsset+LZExpand.h
//  LeadingCloud
//
//  Created by wchMac on 16/4/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^LZAssetGetImageName)(NSString *imageName, id otherInfo);

@interface ALAsset (LZExpand)

/* 图片路径 */
@property(nonatomic,strong) NSURL *assetUrl;

/* 图片名称 */
@property(nonatomic,strong) NSString *imageName;

/* 图片大小 */
@property(nonatomic,strong) NSString *imageSize;

/* 获取图片名称 */
- (void)getAssetImageName:(LZAssetGetImageName)getImageBlock;

@end
