//
//  MWGridCell.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 08/10/2013.
//
//

#import <UIKit/UIKit.h>
#import "MWPhoto.h"
#import "MWGridViewController.h"
#import "LZUILabel.h"
#import "UIView+Layout.h"
@interface MWGridCell : UICollectionViewCell {}

@property (nonatomic, weak) MWGridViewController *gridController;
@property (nonatomic) NSUInteger index;
@property (nonatomic) id <MWPhoto> photo;
@property (nonatomic) BOOL selectionMode;
@property (nonatomic) BOOL isSelected;

@property (nonatomic, strong) UIImageView *videoIndicator;

@property (nonatomic, strong) UIView *customView;

/* 类型图标 */
@property (strong, nonatomic) UIImageView *typeImageView;
/* 文件名称 */
@property (strong, nonatomic) LZUILabel *titleLbl;
/* 文件大小 */
@property (strong, nonatomic) UILabel *sizeLbl;
/* 封面图片 */
@property (strong, nonatomic) UIImageView *backImageView;
/* 左下角时长显示 */
@property (strong, nonatomic) UILabel *durationLbl;
/* 右下角视频大小显示 */
@property (nonatomic, strong) UILabel *sizeVideoLbl;

- (void)displayImage;

- (void)hideLoadingIndicator;

@end
