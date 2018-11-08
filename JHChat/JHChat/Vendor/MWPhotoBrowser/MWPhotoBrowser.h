//
//  MWPhotoBrowser.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhoto.h"
#import "MWPhotoProtocol.h"
#import "MWCaptionView.h"

#define MWPhoto_AlertAction_SendToUser @"发送给联系人"
#define MWPhoto_AlertAction_SaveImage @"保存图片"
#define MWPhoto_AlertAction_SaveToDisk @"保存到云盘"
#define MWPhoto_AlertAction_IdentifyQrCode @"识别图中二维码"

#define MWPhoto_AlertAction_Share @"用其它应用打开"
#define MWPhoto_AlertAction_Comment @"评论"

#define MWPhoto_AlertAction_DocumentCoop @"文档协作"

// Debug Logging
#if 0 // Set to 1 to enable debug logging
#define MWLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define MWLog(x, ...)
#endif

@class MWGridCell;
@class MWPhotoBrowser;
//自定义
@class WFMessageBody;

/* 图片浏览时长按 */
typedef void(^AlertBlock)();

@protocol MWPhotoBrowserDelegate <NSObject>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser;
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;

@optional

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index;
- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index;
- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index;
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected;
- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser;

/**
 *  重新设置NavigationController
 */
- (BOOL)lzPhotoBrowserSetNavigationController:(MWPhotoBrowser *)photoBrowser;

/**
 *  更新NavigationController
 */
- (BOOL)lzPhotoBrowserUpdateNavigationController:(MWPhotoBrowser *)photoBrowser;

/**
 *  Grid模式，自定义显示视图
 */
- (MWGridCell *)lzMWGridPhotoBrowser:(MWPhotoBrowser *)photoBrowser collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  Grid模式，点击表格中的某一项
 */
- (void)lzMWGridPhotoBrowser:(MWPhotoBrowser *)photoBrowser didSelectIndexPath:(NSIndexPath *)indexPath;

/**
 *  右导航点击
 */
- (void)lzPhotoBrowserRightBarController:(MWPhotoBrowser *)photoBrowser Cur:(NSInteger)cur;
/**
 *  右导航点击（协作图片文件评论用）
 */
- (void)lzPhotoCommentBrowserRightBarController:(MWPhotoBrowser *)photoBrowser fileSource:(id)Source;

/**
 *  图片长按
 */
- (BOOL)lzPhotoBrowserLongPressClickPhotoBrowser:(MWPhotoBrowser *)photoBrowser key:(NSString *)key;
/**
 *  图片长按
 */
- (void)lzClickExistPhotoBrowser:(MWPhotoBrowser *)photoBrowser controller:(UIViewController*)controller;

@end

@interface MWPhotoBrowser : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet id<MWPhotoBrowserDelegate> delegate;
@property (nonatomic) BOOL zoomPhotosToFill;
@property (nonatomic) BOOL displayNavArrows;
@property (nonatomic) BOOL displayActionButton;
@property (nonatomic) BOOL displaySelectionButtons;
@property (nonatomic) BOOL alwaysShowControls;
@property (nonatomic) BOOL enableGrid;
@property (nonatomic) BOOL enableSwipeToDismiss;
@property (nonatomic) BOOL startOnGrid;
@property (nonatomic) BOOL autoPlayOnAppear;
/* 当图片长按的时候执行该block */
@property (nonatomic,copy) AlertBlock alertBlock;

@property (nonatomic) BOOL isHaveFile;

@property (nonatomic) NSUInteger delayToHideElements;
@property (nonatomic, readonly) NSUInteger currentIndex;
@property (nonatomic, strong) NSString *customTitle;

/* 是否是自定义 */
@property (nonatomic,assign) BOOL isComment;
/* 是否隐藏Navigation Title */
@property (nonatomic, assign) BOOL isHiddenNavTitle;
/* 协作文件评论 */
@property (nonatomic,copy) id coopeationFileComment;
/* 是否识别出图中二维码 */
@property (nonatomic, assign) BOOL isIdentifyQrCode;
/* 是否单击直接退出 */
@property (nonatomic, assign) BOOL isClickExit;
/*从哪个控制器进来的 */
@property (nonatomic, weak) UIViewController *pushFromController;
@property (nonatomic, strong) UILabel *clickExitLabel;

@property (nonatomic, strong) NSString *qrScanResults;

/* 空白区，视图 */
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UIImageView *emptyCenterImage;


// Customise image selection icons as they are the only icons with a colour tint
// Icon should be located in the app's main bundle

@property (nonatomic) BOOL isNotLongPressEvent;/* 是否不适用长按 */
@property (nonatomic, strong) NSMutableArray *customUIAlertActionArray;

@property (nonatomic, strong) NSString *customImageSelectedIconName;
@property (nonatomic, strong) NSString *customImageSelectedSmallIconName;

@property (nonatomic, strong) NSString *lzTag;

// Init
- (id)initWithPhotos:(NSArray *)photosArray;
- (id)initWithDelegate:(id <MWPhotoBrowserDelegate>)delegate;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setCurrentPhotoIndex:(NSUInteger)index;

// Navigation
- (void)showNextPhotoAnimated:(BOOL)animated;
- (void)showPreviousPhotoAnimated:(BOOL)animated;

- (void)showLoadingIndicator:(NSUInteger)index;

/**
 *  刷新Photo模式下的图片
 */
- (void)didStartReloadPhotoView:(NSUInteger)index image:(UIImage *)image photo:(id<MWPhoto>)photo;

/**
 *  刷新Grid模式下的图片
 */
- (void)didStartReloadGridView:(NSUInteger)index image:(UIImage *)image photo:(id<MWPhoto>)photo;

/**
 *  Photo模式下，加载失败
 */
- (void)didLoadPhotoViewFail:(NSUInteger)index;

/**
 *  得到当前图片
 */
-(UIImage *)currentImage;

/**
 *  图片磁盘名称和磁盘显示名称
 */
-(NSString *)otherInfo;

- (void)hideControls;

/**
 *  长按后，点击处理
 */
-(void)longPressUIAlertActionClikc:(NSString *)key;

@end
