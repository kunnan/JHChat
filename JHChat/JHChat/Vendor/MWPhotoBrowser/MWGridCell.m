//
//  MWGridCell.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 08/10/2013.
//
//

#import "DACircularProgressView.h"
#import "MWGridCell.h"
#import "MWCommon.h"
#import "MWPhotoBrowserPrivate.h"
#import "UIImage+MWPhotoBrowser.h"

#define VIDEO_INDICATOR_PADDING 10

@interface MWGridCell () {
    
    UIImageView *_imageView;
//    UIImageView *_videoIndicator;
    UIImageView *_loadingError;
	DACircularProgressView *_loadingIndicator;
    UIButton *_selectedButton;
    
}

@end

@implementation MWGridCell

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

        // Grey background
        self.backgroundColor = [UIColor colorWithWhite:0.12 alpha:1];
        
        //lz,自定义视图
        _customView = [[UIView alloc] init];
        _customView.frame = self.bounds;
        _customView.contentMode = UIViewContentModeScaleAspectFill;
        _customView.clipsToBounds = YES;
        _customView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _customView.hidden = YES;
        [self addSubview:_customView];
        
        // 背景图片
        _backImageView = [[UIImageView alloc] init];
        _backImageView.frame = self.bounds;
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.clipsToBounds = YES;
        _backImageView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_customView addSubview:_backImageView];
        
        /* 类型图标 */
        _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _customView.height-32-10, 32, 32)];
        [_customView addSubview:_typeImageView];
        
        /* 文件名称 */
        _titleLbl = [[LZUILabel alloc] initWithFrame:CGRectMake(10, 15, _customView.width-10*2, _customView.height-15-_typeImageView.height-10-10)];
        //titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.font = [UIFont systemFontOfSize:13];
        [_titleLbl setVerticalAlignment:VerticalAlignmentTop];
        _titleLbl.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLbl.numberOfLines = 0;
        [_customView addSubview:_titleLbl];
        
        /* 文件大小 */
        _sizeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10+_typeImageView.x+_typeImageView.width,
                                                             _typeImageView.y,
                                                             _customView.width-10-(10+_typeImageView.x+_typeImageView.width),
                                                             _typeImageView.height)];
        _sizeLbl.font = [UIFont systemFontOfSize:12];
        [_customView addSubview:_sizeLbl];
        
        /* 时长 */
        _durationLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, _customView.height - 25, 50, 20)];
        _durationLbl.font = [UIFont systemFontOfSize:12];
        _durationLbl.textColor = [UIColor whiteColor];
        [_backImageView addSubview:_durationLbl];
        
        /* 视频大小 */
        _sizeVideoLbl = [[UILabel alloc] initWithFrame:CGRectMake(_customView.width-100-10, _customView.height-25, 100, 20)];
        _sizeVideoLbl.font = [UIFont systemFontOfSize:12];
        _sizeVideoLbl.textColor = [UIColor whiteColor];
        _sizeVideoLbl.textAlignment = NSTextAlignmentRight;
        [_backImageView addSubview:_sizeVideoLbl];
        
        // Image
        _imageView = [UIImageView new];
        _imageView.frame = self.bounds;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_imageView];
        
        // Video Image
        _videoIndicator = [UIImageView new];
        _videoIndicator.hidden = NO;
        UIImage *videoIndicatorImage = [UIImage imageForResourcePath:@"MWPhotoBrowser.bundle/PlayButtonOverlayLargeTap" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]];
        _videoIndicator.frame = CGRectMake((self.bounds.size.width - 24)/2, (self.bounds.size.height - 24)/2, 24, 24);
//        _videoIndicator.center = CGPointMake(CGRectGetWidth(_customView.frame) / 2.0, CGRectGetHeight(_customView.frame) / 2.0);
        _videoIndicator.image = videoIndicatorImage;
        _videoIndicator.autoresizesSubviews = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_videoIndicator];
        
        // Selection button
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedButton.contentMode = UIViewContentModeTopRight;
        _selectedButton.adjustsImageWhenHighlighted = NO;
        [_selectedButton setImage:[UIImage imageForResourcePath:@"MWPhotoBrowser.bundle/ImageSelectedSmallOff" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateNormal];
        [_selectedButton setImage:[UIImage imageForResourcePath:@"MWPhotoBrowser.bundle/ImageSelectedSmallOn" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateSelected];
        [_selectedButton addTarget:self action:@selector(selectionButtonPressed) forControlEvents:UIControlEventTouchDown];
        _selectedButton.hidden = YES;
        _selectedButton.frame = CGRectMake(0, 0, 44, 44);
        [self addSubview:_selectedButton];
    
		// Loading indicator
		_loadingIndicator = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
        _loadingIndicator.userInteractionEnabled = NO;
        _loadingIndicator.thicknessRatio = 0.1;
        _loadingIndicator.roundedCorners = NO;
		[self addSubview:_loadingIndicator];
        
        // Listen for photo loading notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setProgressFromNotification:)
                                                     name:MWPHOTO_PROGRESS_NOTIFICATION
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMWPhotoLoadingDidEndNotification:)
                                                     name:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                                   object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setGridController:(MWGridViewController *)gridController {
    _gridController = gridController;
    // Set custom selection image if required
    if (_gridController.browser.customImageSelectedSmallIconName) {
        [_selectedButton setImage:[UIImage imageNamed:_gridController.browser.customImageSelectedSmallIconName] forState:UIControlStateSelected];
    }
}

#pragma mark - View

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    _loadingIndicator.frame = CGRectMake(floorf((self.bounds.size.width - _loadingIndicator.frame.size.width) / 2.),
                                         floorf((self.bounds.size.height - _loadingIndicator.frame.size.height) / 2),
                                         _loadingIndicator.frame.size.width,
                                         _loadingIndicator.frame.size.height);
    _selectedButton.frame = CGRectMake(self.bounds.size.width - _selectedButton.frame.size.width - 0,
                                       0, _selectedButton.frame.size.width, _selectedButton.frame.size.height);
}

#pragma mark - Cell

- (void)prepareForReuse {
    _photo = nil;
    _gridController = nil;
    _imageView.image = nil;
    _loadingIndicator.progress = 0;
    _selectedButton.hidden = YES;
    [self hideImageFailure];
    [super prepareForReuse];
}

#pragma mark - Image Handling

- (void)setPhoto:(id <MWPhoto>)photo {
    _photo = photo;
    if ([photo respondsToSelector:@selector(isVideo)]) {
        _videoIndicator.hidden = !photo.isVideo;
    } else {
        _videoIndicator.hidden = YES;
    }
    if (_photo) {
        if (![_photo underlyingImage]) {
            [self showLoadingIndicator];
        } else {
            [self hideLoadingIndicator];
        }
    } else {
        [self showImageFailure];
    }
}

- (void)displayImage {
    _imageView.image = [_photo underlyingImage];
    _selectedButton.hidden = !_selectionMode;
    [self hideImageFailure];
}

#pragma mark - Selection

- (void)setSelectionMode:(BOOL)selectionMode {
    _selectionMode = selectionMode;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    _selectedButton.selected = isSelected;
}

- (void)selectionButtonPressed {
    _selectedButton.selected = !_selectedButton.selected;
    [_gridController.browser setPhotoSelected:_selectedButton.selected atIndex:_index];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _imageView.alpha = 0.6;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _imageView.alpha = 1;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    _imageView.alpha = 1;
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark Indicators

- (void)hideLoadingIndicator {
    _loadingIndicator.hidden = YES;
}

- (void)showLoadingIndicator {
    _loadingIndicator.progress = 0;
    _loadingIndicator.hidden = NO;
    [self hideImageFailure];
}

- (void)showImageFailure {
    // Only show if image is not empty
    if (![_photo respondsToSelector:@selector(emptyImage)] || !_photo.emptyImage) {
        if (!_loadingError) {
            _loadingError = [UIImageView new];
            _loadingError.image = [UIImage imageForResourcePath:@"MWPhotoBrowser.bundle/ImageError" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]];
            _loadingError.userInteractionEnabled = NO;
            [_loadingError sizeToFit];
            [self addSubview:_loadingError];
        }
        _loadingError.frame = CGRectMake(floorf((self.bounds.size.width - _loadingError.frame.size.width) / 2.),
                                         floorf((self.bounds.size.height - _loadingError.frame.size.height) / 2),
                                         _loadingError.frame.size.width,
                                         _loadingError.frame.size.height);
    }
    [self hideLoadingIndicator];
    _imageView.image = nil;
}

- (void)hideImageFailure {
    if (_loadingError) {
        [_loadingError removeFromSuperview];
        _loadingError = nil;
    }
}

#pragma mark - Notifications

- (void)setProgressFromNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = [notification object];
        id <MWPhoto> photoWithProgress = [dict objectForKey:@"photo"];
        if (photoWithProgress == _photo) {
//            NSLog(@"%f", [[dict valueForKey:@"progress"] floatValue]);
            float progress = [[dict valueForKey:@"progress"] floatValue];
            _loadingIndicator.progress = MAX(MIN(1, progress), 0);
        }
    });
}

- (void)handleMWPhotoLoadingDidEndNotification:(NSNotification *)notification {
    id <MWPhoto> photo = [notification object];
    if (photo == _photo) {
        if ([photo underlyingImage]) {
            // Successful load
            [self displayImage];
        } else {
            // Failed to load
            [self showImageFailure];
        }
        [self hideLoadingIndicator];
    }
}

@end
