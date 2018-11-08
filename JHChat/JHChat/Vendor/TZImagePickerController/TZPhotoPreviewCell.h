//
//  TZPhotoPreviewCell.h
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class TZAssetModel;
@interface TZPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, strong) TZAssetModel *model;
@property (nonatomic, copy) void (^singleTapGestureBlock)();
@property (nonatomic, strong) PHAsset *asset;

- (void)recoverSubviews;

@end
