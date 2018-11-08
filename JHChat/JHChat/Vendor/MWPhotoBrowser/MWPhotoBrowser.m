//
//  MWPhotoBrowser.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MWCommon.h"
#import "MWPhotoBrowser.h"
#import "MWPhotoBrowserPrivate.h"
#import "SDImageCache.h"
#import "UIImage+MWPhotoBrowser.h"
#import "LCProgressHUD.h"
#import "NSString+IsNullOrEmpty.h"
#import "NSString+CGSize.h"
#import "ZXingobjC.h"
#import "LZToast.h"
#import "ShareActivityModel.h"
#import "MainViewController.h"
#import "AppUtils.h"
#import "NSString+SerialToDic.h"
#import "SystemPrivilegesUtilViewModel.h"
#define PADDING                  0

static void * MWVideoPlayerObservation = &MWVideoPlayerObservation;

@implementation MWPhotoBrowser

#pragma mark - Init

- (id)init {
    if ((self = [super init])) {
        [self _initialisation];
    }
    return self;
}

- (id)initWithDelegate:(id <MWPhotoBrowserDelegate>)delegate {
    if ((self = [self init])) {
        _delegate = delegate;
	}
	return self;
}

- (id)initWithPhotos:(NSArray *)photosArray {
	if ((self = [self init])) {
		_fixedPhotosArray = photosArray;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super initWithCoder:decoder])) {
        [self _initialisation];
	}
	return self;
}

- (void)_initialisation {
    
    // Defaults
    NSNumber *isVCBasedStatusBarAppearanceNum = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
    if (isVCBasedStatusBarAppearanceNum) {
        _isVCBasedStatusBarAppearance = isVCBasedStatusBarAppearanceNum.boolValue;
    } else {
        _isVCBasedStatusBarAppearance = YES; // default
    }
    self.hidesBottomBarWhenPushed = YES;
    _hasBelongedToViewController = NO;
    _photoCount = NSNotFound;
    _previousLayoutBounds = CGRectZero;
    _currentPageIndex = 0;
    _previousPageIndex = NSUIntegerMax;
    _displayActionButton = YES;
    _displayNavArrows = NO;
    _zoomPhotosToFill = YES;
    _performingLayout = NO; // Reset on view did appear
    _rotating = NO;
    _viewIsActive = NO;
    _enableGrid = YES;
    _startOnGrid = NO;
    _enableSwipeToDismiss = YES;
    _delayToHideElements = 5;
    _visiblePages = [[NSMutableSet alloc] init];
    _recycledPages = [[NSMutableSet alloc] init];
    _photos = [[NSMutableArray alloc] init];
    _thumbPhotos = [[NSMutableArray alloc] init];
    _currentGridContentOffset = CGPointMake(0, CGFLOAT_MAX);
    _didSavePreviousStateOfNavBar = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Listen for MWPhoto notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMWPhotoLoadingDidEndNotification:)
                                                 name:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                               object:nil];
    
}

- (void)dealloc {
    NSLog(@"浏览图片的MWPhotoBrower控制器销毁了");
    [self clearCurrentVideo];
    _pagingScrollView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseAllUnderlyingPhotos:NO];
    [[SDImageCache sharedImageCache] clearMemory]; // clear memory
}

- (BOOL)willDealloc {
    return NO;
}

- (void)releaseAllUnderlyingPhotos:(BOOL)preserveCurrent {
    // Create a copy in case this array is modified while we are looping through
    // Release photos
    NSArray *copy = [_photos copy];
    for (id p in copy) {
        if (p != [NSNull null]) {
            if (preserveCurrent && p == [self photoAtIndex:self.currentIndex]) {
                continue; // skip current
            }
            [p unloadUnderlyingImage];
        }
    }
    // Release thumbs
    copy = [_thumbPhotos copy];
    for (id p in copy) {
        if (p != [NSNull null]) {
            [p unloadUnderlyingImage];
        }
    }
}

- (void)didReceiveMemoryWarning {

	// Release any cached data, images, etc that aren't in use.
    [self releaseAllUnderlyingPhotos:YES];
	[_recycledPages removeAllObjects];
	
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
}

#pragma mark - View Loading

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [LCProgressHUD hide];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:@"applicationWillEnterForeground" object:nil];
    // Validate grid settings
    if (_startOnGrid) _enableGrid = YES;
    if (_enableGrid) {
        _enableGrid = [_delegate respondsToSelector:@selector(photoBrowser:thumbPhotoAtIndex:)];
    }
    if (!_enableGrid) _startOnGrid = NO;
	
	// View
	self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;

	// Setup paging scrolling view
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
	_pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
	_pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_pagingScrollView.pagingEnabled = YES;
	_pagingScrollView.delegate = self;
	_pagingScrollView.showsHorizontalScrollIndicator = NO;
	_pagingScrollView.showsVerticalScrollIndicator = NO;
	_pagingScrollView.backgroundColor = [UIColor blackColor];
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
	[self.view addSubview:_pagingScrollView];
	
    // Toolbar
    _toolbar = [[UIToolbar alloc] initWithFrame:[self frameForToolbarAtOrientation:self.interfaceOrientation]];
    _toolbar.tintColor = [UIColor whiteColor];
    _toolbar.barTintColor = nil;
    [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsLandscapePhone];
    _toolbar.barStyle = UIBarStyleBlackTranslucent;
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    // Toolbar Items
    if (self.displayNavArrows) {
        NSString *arrowPathFormat = @"MWPhotoBrowser.bundle/UIBarButtonItemArrow%@";
        UIImage *previousButtonImage = [UIImage imageForResourcePath:[NSString stringWithFormat:arrowPathFormat, @"Left"] ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]];
        UIImage *nextButtonImage = [UIImage imageForResourcePath:[NSString stringWithFormat:arrowPathFormat, @"Right"] ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]];
        _previousButton = [[UIBarButtonItem alloc] initWithImage:previousButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(gotoPreviousPage)];
        _nextButton = [[UIBarButtonItem alloc] initWithImage:nextButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(gotoNextPage)];
    }
    if (self.displayActionButton) {
        
        if (_isComment || _coopeationFileComment != nil) {
            _actionButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dropdown_comment"] style:UIBarButtonItemStylePlain target:self action:@selector(actionButtonPressed:)];

        }else{
            _actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed:)];
        }
    }
    
    /* 单击退出 */
    if(_isClickExit){
        //        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.alpha = 0;
        self.clickExitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, LZ_SCREEN_HEIGHT-65, LZ_SCREEN_WIDTH, 30)];
        self.clickExitLabel.font = [UIFont systemFontOfSize:21];
        self.clickExitLabel.textAlignment = NSTextAlignmentCenter;
        self.clickExitLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:self.clickExitLabel];
    }
    
    // Update
    [self reloadData];
    
    // Swipe to dismiss
    if (_enableSwipeToDismiss) {
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doneButtonPressed:)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:swipeGesture];
    }
    
    //longpress
    if(!_isNotLongPressEvent){
        /* 图片长按事件 */
        UILongPressGestureRecognizer *longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onImageViewLongPressEvent:)];
        [self.view addGestureRecognizer:longPressGesture];
    }
	// Super
    [super viewDidLoad];
}

-(void)applicationWillEnterForeground:(NSNotificationCenter *)ss{
    /* 单击退出 */
    UIViewController *curVC = [self getCurrentVC];
    NSString *VCStr = [NSString stringWithUTF8String:object_getClassName(self)];
    NSString *curStr  = [NSString stringWithUTF8String:object_getClassName(curVC)];
    
    if(_isClickExit && [VCStr isEqualToString:curStr]){
        self.navigationController.navigationBarHidden = YES;
    }
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    /*
     *  在此判断返回的视图是不是你的根视图--我的根视图是tabbar
     */
    if ([result isKindOfClass:[MainViewController class]]) {
        MainViewController *mainTabBarVC = (MainViewController *)result;
        result = [mainTabBarVC selectedViewController];
        result = [result.childViewControllers lastObject];
    }
    
    NSLog(@"非模态视图%@", result);
    return result;
}

- (void)performLayout {
    
    // Setup
    _performingLayout = YES;
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    
	// Setup pages
    [_visiblePages removeAllObjects];
    [_recycledPages removeAllObjects];
    
    // Navigation buttons
    if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
        // We're first on stack so show done button
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
        // Set appearance
        [_doneButton setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_doneButton setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        [_doneButton setBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [_doneButton setBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
        [_doneButton setTitleTextAttributes:[NSDictionary dictionary] forState:UIControlStateNormal];
        [_doneButton setTitleTextAttributes:[NSDictionary dictionary] forState:UIControlStateHighlighted];
        self.navigationItem.rightBarButtonItem = _doneButton;
    } else {
        // We're not first so show back button
        UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//        NSString *backButtonTitle = previousViewController.navigationItem.backBarButtonItem ? previousViewController.navigationItem.backBarButtonItem.title : previousViewController.title;
        NSString *backButtonTitle = @"返回";
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:backButtonTitle style:UIBarButtonItemStylePlain target:nil action:nil];
        // Appearance
        [newBackButton setBackButtonBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [newBackButton setBackButtonBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        [newBackButton setBackButtonBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [newBackButton setBackButtonBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
        [newBackButton setTitleTextAttributes:[NSDictionary dictionary] forState:UIControlStateNormal];
        [newBackButton setTitleTextAttributes:[NSDictionary dictionary] forState:UIControlStateHighlighted];
        _previousViewControllerBackButton = previousViewController.navigationItem.backBarButtonItem; // remember previous
        previousViewController.navigationItem.backBarButtonItem = newBackButton;
    }

    // Toolbar items
    BOOL hasItems = NO;
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = 32; // To balance action button
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSMutableArray *items = [[NSMutableArray alloc] init];

    // Left button - Grid
    if (_enableGrid) {
        hasItems = YES;
        [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage imageForResourcePath:@"MWPhotoBrowser.bundle/UIBarButtonItemGrid" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]] style:UIBarButtonItemStylePlain target:self action:@selector(showGridAnimated)]];
    } else {
        [items addObject:fixedSpace];
    }

    // Middle - Nav
    if (_previousButton && _nextButton && numberOfPhotos > 1) {
        hasItems = YES;
        [items addObject:flexSpace];
        [items addObject:_previousButton];
        [items addObject:flexSpace];
        [items addObject:_nextButton];
        [items addObject:flexSpace];
    } else {
        [items addObject:flexSpace];
    }

    // Right - Action
    if (_actionButton && !(!hasItems && !self.navigationItem.rightBarButtonItem)) {
        [items addObject:_actionButton];
    } else {
        // We're not showing the toolbar so try and show in top right
        if (_actionButton)
            self.navigationItem.rightBarButtonItem = _actionButton;
        [items addObject:fixedSpace];
    }

    // Toolbar visibility
    [_toolbar setItems:items];
    BOOL hideToolbar = YES;
    for (UIBarButtonItem* item in _toolbar.items) {
        if (item != fixedSpace && item != flexSpace) {
            hideToolbar = NO;
            break;
        }
    }
    if (hideToolbar) {
        [_toolbar removeFromSuperview];
    } else {
        [self.view addSubview:_toolbar];
        [_toolbar layoutIfNeeded];
    }
    
    // Update nav
    if (!_isHiddenNavTitle) {
        [self updateNavigation];
    }
	
    
    // Content offset
	_pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:_currentPageIndex];
    
    [self tilePages];
    _performingLayout = NO;
    
}

// Release any retained subviews of the main view.
- (void)viewDidUnload {
	_currentPageIndex = 0;
    _pagingScrollView = nil;
    _visiblePages = nil;
    _recycledPages = nil;
    _toolbar = nil;
    _previousButton = nil;
    _nextButton = nil;
    _progressHUD = nil;
    [super viewDidUnload];
}

- (BOOL)presentingViewControllerPrefersStatusBarHidden {
    UIViewController *presenting = self.presentingViewController;
    if (presenting) {
        if ([presenting isKindOfClass:[UINavigationController class]]) {
            presenting = [(UINavigationController *)presenting topViewController];
        }
    } else {
        
        if (self.navigationController && self.navigationController.viewControllers.count > 1) {
                presenting = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        }
    }
    if (presenting) {
        return [presenting prefersStatusBarHidden];
    } else {
        return NO;
    }
}

#pragma mark - Appearance

- (void)viewWillAppear:(BOOL)animated {
    
	// Super
	[super viewWillAppear:animated];
    if(_isClickExit && !_startOnGrid){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationBar.alpha = 0;
    }else{
        //用于防止图片浏览为单击退出模式下导航栏消失的问题
        self.navigationController.navigationBarHidden = NO;
    }
    // Status bar
    if (!_viewHasAppearedInitially) {
        _leaveStatusBarAlone = [self presentingViewControllerPrefersStatusBarHidden];
        // Check if status bar is hidden on first appear, and if so then ignore it
        if (CGRectEqualToRect([[UIApplication sharedApplication] statusBarFrame], CGRectZero)) {
            _leaveStatusBarAlone = YES;
        }
    }
   
    // Set style
    if (!_leaveStatusBarAlone && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        _previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    }
    
    // Navigation bar appearance
    if (!_viewIsActive && [self.navigationController.viewControllers objectAtIndex:0] != self) {
        [self storePreviousNavBarAppearance];
    }
    
    BOOL isRest = NO;
    if([self.delegate respondsToSelector:@selector(lzPhotoBrowserSetNavigationController:)]){
        isRest = [self.delegate lzPhotoBrowserSetNavigationController:self];
    }
    if(!isRest){
        [self setNavBarAppearance:animated];
    }
    
    // Update UI
	[self hideControlsAfterDelay];
    
    // Initial appearance
    if (!_viewHasAppearedInitially) {
        if (_startOnGrid) {
            [self showGrid:NO];
        }
    }
    
    // If rotation occured while we're presenting a modal
    // and the index changed, make sure we show the right one now
    if (_currentPageIndex != _pageIndexBeforeRotation) {
        [self jumpToPageAtIndex:_pageIndexBeforeRotation animated:NO];
    }
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _viewIsActive = YES;
    
    // Autoplay if first is video
    if (!_viewHasAppearedInitially) {
        if (_autoPlayOnAppear) {
            MWPhoto *photo = [self photoAtIndex:_currentPageIndex];
            if ([photo respondsToSelector:@selector(isVideo)] && photo.isVideo) {
                [self playVideoAtIndex:_currentPageIndex];
            }
        }
    }
    
    _viewHasAppearedInitially = YES;
    if(_isClickExit&& !_startOnGrid){
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.alpha = 0;
        /* 不允许滑动返回 */
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            NSLog(@"不允许滑动返回");
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    /* 允许滑动返回 */
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        NSLog(@"允许滑动返回");
    }
    // Detect if rotation occurs while we're presenting a modal
    _pageIndexBeforeRotation = _currentPageIndex;
    
    // Check that we're being popped for good
    if ([self.navigationController.viewControllers objectAtIndex:0] != self &&
        ![self.navigationController.viewControllers containsObject:self]) {
        
        // State
        _viewIsActive = NO;
        
        // Bar state / appearance
        [self restorePreviousNavBarAppearance:animated];
        
    }
    
    // Controls
    [self.navigationController.navigationBar.layer removeAllAnimations]; // Stop all animations on nav bar
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // Cancel any pending toggles from taps
    if(_isClickExit){
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self setControlsHidden:NO animated:YES permanent:YES];
    }else{
        [self setControlsHidden:NO animated:NO permanent:YES];
    }
    // Status bar
    if (!_leaveStatusBarAlone && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[UIApplication sharedApplication] setStatusBarStyle:_previousStatusBarStyle animated:animated];
    }
    
	// Super
	[super viewWillDisappear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //用于防止图片浏览为单击退出模式下导航栏消失的问题
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent && _hasBelongedToViewController) {
        [NSException raise:@"MWPhotoBrowser Instance Reuse" format:@"MWPhotoBrowser instances cannot be reused."];
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (!parent) _hasBelongedToViewController = YES;
}

#pragma mark - Nav Bar Appearance

- (void)setNavBarAppearance:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    navBar.barTintColor = nil;
    navBar.shadowImage = nil;
    navBar.translucent = YES;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsLandscapePhone];
}

- (void)storePreviousNavBarAppearance {
    _didSavePreviousStateOfNavBar = YES;
    _previousNavBarBarTintColor = self.navigationController.navigationBar.barTintColor;
    _previousNavBarTranslucent = self.navigationController.navigationBar.translucent;
    _previousNavBarTintColor = self.navigationController.navigationBar.tintColor;
    _previousNavBarHidden = self.navigationController.navigationBarHidden;
    _previousNavBarStyle = self.navigationController.navigationBar.barStyle;
    _previousNavigationBarBackgroundImageDefault = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    _previousNavigationBarBackgroundImageLandscapePhone = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsLandscapePhone];
}

- (void)restorePreviousNavBarAppearance:(BOOL)animated {
    if (_didSavePreviousStateOfNavBar) {
        [self.navigationController setNavigationBarHidden:_previousNavBarHidden animated:animated];
        UINavigationBar *navBar = self.navigationController.navigationBar;
        navBar.tintColor = _previousNavBarTintColor;
        navBar.translucent = _previousNavBarTranslucent;
        navBar.barTintColor = _previousNavBarBarTintColor;
        navBar.barStyle = _previousNavBarStyle;
        [navBar setBackgroundImage:_previousNavigationBarBackgroundImageDefault forBarMetrics:UIBarMetricsDefault];
        [navBar setBackgroundImage:_previousNavigationBarBackgroundImageLandscapePhone forBarMetrics:UIBarMetricsLandscapePhone];
        // Restore back button if we need to
        if (_previousViewControllerBackButton) {
            UIViewController *previousViewController = [self.navigationController topViewController]; // We've disappeared so previous is now top
            previousViewController.navigationItem.backBarButtonItem = _previousViewControllerBackButton;
            _previousViewControllerBackButton = nil;
        }
    }
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutVisiblePages];
}

- (void)layoutVisiblePages {
    
	// Flag
	_performingLayout = YES;
	
	// Toolbar
	_toolbar.frame = [self frameForToolbarAtOrientation:self.interfaceOrientation];
    
	// Remember index
	NSUInteger indexPriorToLayout = _currentPageIndex;
	
	// Get paging scroll view frame to determine if anything needs changing
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    
	// Frame needs changing
    if (!_skipNextPagingScrollViewPositioning) {
        _pagingScrollView.frame = pagingScrollViewFrame;
    }
    _skipNextPagingScrollViewPositioning = NO;
	
	// Recalculate contentSize based on current orientation
	_pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
	
	// Adjust frames and configuration of each visible page
	for (MWZoomingScrollView *page in _visiblePages) {
        NSUInteger index = page.index;
		page.frame = [self frameForPageAtIndex:index];
        if (page.captionView) {
            page.captionView.frame = [self frameForCaptionView:page.captionView atIndex:index];
        }
        if (page.selectedButton) {
            page.selectedButton.frame = [self frameForSelectedButton:page.selectedButton atIndex:index];
        }
        if (page.playButton) {
            page.playButton.frame = [self frameForPlayButton:page.playButton atIndex:index];
        }
        
        // Adjust scales if bounds has changed since last time
        if (!CGRectEqualToRect(_previousLayoutBounds, self.view.bounds)) {
            // Update zooms for new bounds
            [page setMaxMinZoomScalesForCurrentBounds];
            _previousLayoutBounds = self.view.bounds;
        }

	}
    
    // Adjust video loading indicator if it's visible
    [self positionVideoLoadingIndicator];
	
	// Adjust contentOffset to preserve page location based on values collected prior to location
	_pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:indexPriorToLayout];
	[self didStartViewingPageAtIndex:_currentPageIndex]; // initial
    
	// Reset
	_currentPageIndex = indexPriorToLayout;
	_performingLayout = NO;
    
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
	// Remember page index before rotation
	_pageIndexBeforeRotation = _currentPageIndex;
	_rotating = YES;
    
    // In iOS 7 the nav bar gets shown after rotation, but might as well do this for everything!
    if ([self areControlsHidden]) {
        // Force hidden
        self.navigationController.navigationBarHidden = YES;
    }
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	// Perform layout
	_currentPageIndex = _pageIndexBeforeRotation;
	
	// Delay control holding
	[self hideControlsAfterDelay];
    
    // Layout
    [self layoutVisiblePages];
	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	_rotating = NO;
    // Ensure nav bar isn't re-displayed
    if ([self areControlsHidden]) {
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.alpha = 0;
    }
}

#pragma mark - Data

- (NSUInteger)currentIndex {
    return _currentPageIndex;
}

- (void)reloadData {
    
    // Reset
    _photoCount = NSNotFound;
    
    // Get data
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    [self releaseAllUnderlyingPhotos:YES];
    [_photos removeAllObjects];
    [_thumbPhotos removeAllObjects];
    for (int i = 0; i < numberOfPhotos; i++) {
        [_photos addObject:[NSNull null]];
        [_thumbPhotos addObject:[NSNull null]];
    }

    // Update current page index
    if (numberOfPhotos > 0) {
        _currentPageIndex = MAX(0, MIN(_currentPageIndex, numberOfPhotos - 1));
    } else {
        _currentPageIndex = 0;
    }
    
    // Update layout
    if ([self isViewLoaded]) {
        while (_pagingScrollView.subviews.count) {
            [[_pagingScrollView.subviews lastObject] removeFromSuperview];
        }
        [self performLayout];
        [self.view setNeedsLayout];
    }
    
}

- (NSUInteger)numberOfPhotos {
    if (_photoCount == NSNotFound) {
        if ([_delegate respondsToSelector:@selector(numberOfPhotosInPhotoBrowser:)]) {
            _photoCount = [_delegate numberOfPhotosInPhotoBrowser:self];
        } else if (_fixedPhotosArray) {
            _photoCount = _fixedPhotosArray.count;
        }
    }
    if (_photoCount == NSNotFound) _photoCount = 0;
    return _photoCount;
}

- (id<MWPhoto>)photoAtIndex:(NSUInteger)index {
    id <MWPhoto> photo = nil;
    if (index < _photos.count) {
        if ([_photos objectAtIndex:index] == [NSNull null]) {
            if ([_delegate respondsToSelector:@selector(photoBrowser:photoAtIndex:)]) {
                photo = [_delegate photoBrowser:self photoAtIndex:index];
            } else if (_fixedPhotosArray && index < _fixedPhotosArray.count) {
                photo = [_fixedPhotosArray objectAtIndex:index];
            }
            if (photo) [_photos replaceObjectAtIndex:index withObject:photo];
        } else {
            photo = [_photos objectAtIndex:index];
        }
    }
    return photo;
}

- (id<MWPhoto>)thumbPhotoAtIndex:(NSUInteger)index {
    id <MWPhoto> photo = nil;
    if (index < _thumbPhotos.count) {
        if ([_thumbPhotos objectAtIndex:index] == [NSNull null]) {
            if ([_delegate respondsToSelector:@selector(photoBrowser:thumbPhotoAtIndex:)]) {
                photo = [_delegate photoBrowser:self thumbPhotoAtIndex:index];
            }
            if (photo) [_thumbPhotos replaceObjectAtIndex:index withObject:photo];
        } else {
            photo = [_thumbPhotos objectAtIndex:index];
        }
    }
    return photo;
}

- (MWCaptionView *)captionViewForPhotoAtIndex:(NSUInteger)index {
    MWCaptionView *captionView = nil;
    if ([_delegate respondsToSelector:@selector(photoBrowser:captionViewForPhotoAtIndex:)]) {
        captionView = [_delegate photoBrowser:self captionViewForPhotoAtIndex:index];
    } else {
        id <MWPhoto> photo = [self photoAtIndex:index];
        if ([photo respondsToSelector:@selector(caption)]) {
            if ([photo caption]) captionView = [[MWCaptionView alloc] initWithPhoto:photo];
        }
    }
    captionView.alpha = [self areControlsHidden] ? 0 : 0.8; // Initial alpha
    return captionView;
}

- (BOOL)photoIsSelectedAtIndex:(NSUInteger)index {
    BOOL value = NO;
    if (_displaySelectionButtons) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:isPhotoSelectedAtIndex:)]) {
            value = [self.delegate photoBrowser:self isPhotoSelectedAtIndex:index];
        }
    }
    return value;
}

- (void)setPhotoSelected:(BOOL)selected atIndex:(NSUInteger)index {
    if (_displaySelectionButtons) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:photoAtIndex:selectedChanged:)]) {
            [self.delegate photoBrowser:self photoAtIndex:index selectedChanged:selected];
        }
    }
}

- (UIImage *)imageForPhoto:(id<MWPhoto>)photo {
	if (photo) {
		// Get image or obtain in background
		if ([photo underlyingImage]) {
			return [photo underlyingImage];
		} else {
            [photo loadUnderlyingImageAndNotify];
		}
	}
	return nil;
}

- (void)loadAdjacentPhotosIfNecessary:(id<MWPhoto>)photo {
    MWZoomingScrollView *page = [self pageDisplayingPhoto:photo];
    if (page) {
        // If page is current page then initiate loading of previous and next pages
        NSUInteger pageIndex = page.index;
        if (_currentPageIndex == pageIndex) {
            if (pageIndex > 0) {
                // Preload index - 1
                id <MWPhoto> photo = [self photoAtIndex:pageIndex-1];
                if (![photo underlyingImage]) {
                    [photo loadUnderlyingImageAndNotify];
                    MWLog(@"Pre-loading image at index %lu", (unsigned long)pageIndex-1);
                }
            }  
            if (pageIndex < [self numberOfPhotos] - 1) {
                // Preload index + 1
                id <MWPhoto> photo = [self photoAtIndex:pageIndex+1];
                if (![photo underlyingImage]) {
                    [photo loadUnderlyingImageAndNotify];
                    MWLog(@"Pre-loading image at index %lu", (unsigned long)pageIndex+1);
                }
            }
        }
    }
}

#pragma mark - MWPhoto Loading Notification

- (void)handleMWPhotoLoadingDidEndNotification:(NSNotification *)notification {
    id <MWPhoto> photo = [notification object];
    MWZoomingScrollView *page = [self pageDisplayingPhoto:photo];
    if (page) {
        if ([photo underlyingImage]) {
            // Successful load
            [page displayImage];
            [self loadAdjacentPhotosIfNecessary:photo];
        } else {
            
            // Failed to load
            [page displayImageFailure];
        }
        // Update nav
        if (!_isHiddenNavTitle) {
            [self updateNavigation];
        }

    }
}

#pragma mark - Paging

- (void)tilePages {
	
	// Calculate which pages should be visible
	// Ignore padding as paging bounces encroach on that
	// and lead to false page loads
	CGRect visibleBounds = _pagingScrollView.bounds;
	NSInteger iFirstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds)+PADDING*2) / CGRectGetWidth(visibleBounds));
	NSInteger iLastIndex  = (NSInteger)floorf((CGRectGetMaxX(visibleBounds)-PADDING*2-1) / CGRectGetWidth(visibleBounds));
    if (iFirstIndex < 0) iFirstIndex = 0;
    if (iFirstIndex > [self numberOfPhotos] - 1) iFirstIndex = [self numberOfPhotos] - 1;
    if (iLastIndex < 0) iLastIndex = 0;
    if (iLastIndex > [self numberOfPhotos] - 1) iLastIndex = [self numberOfPhotos] - 1;
	
	// Recycle no longer needed pages
    NSInteger pageIndex;
	for (MWZoomingScrollView *page in _visiblePages) {
        pageIndex = page.index;
		if (pageIndex < (NSUInteger)iFirstIndex || pageIndex > (NSUInteger)iLastIndex) {
			[_recycledPages addObject:page];
            [page.captionView removeFromSuperview];
            [page.selectedButton removeFromSuperview];
            [page.playButton removeFromSuperview];
            [page prepareForReuse];
			[page removeFromSuperview];
			MWLog(@"Removed page at index %lu", (unsigned long)pageIndex);
		}
	}
	[_visiblePages minusSet:_recycledPages];
    while (_recycledPages.count > 2) // Only keep 2 recycled pages
        [_recycledPages removeObject:[_recycledPages anyObject]];
	
	// Add missing pages
	for (NSUInteger index = (NSUInteger)iFirstIndex; index <= (NSUInteger)iLastIndex; index++) {
		if (![self isDisplayingPageForIndex:index]) {
            
            if(index==3){
                DDLogVerbose(@"33");
            }
            
            // Add new page
			MWZoomingScrollView *page = [self dequeueRecycledPage];
			if (!page) {
				page = [[MWZoomingScrollView alloc] initWithPhotoBrowser:self];
			}
			[_visiblePages addObject:page];
			[self configurePage:page forIndex:index];

			[_pagingScrollView addSubview:page];
			MWLog(@"Added page at index %lu", (unsigned long)index);
            
            // Add caption
            MWCaptionView *captionView = [self captionViewForPhotoAtIndex:index];
            if (captionView) {
                captionView.frame = [self frameForCaptionView:captionView atIndex:index];
                [_pagingScrollView addSubview:captionView];
                page.captionView = captionView;
            }
            
            // Add play button if needed
            if (page.displayingVideo) {
                UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [playButton setImage:[UIImage imageForResourcePath:@"MWPhotoBrowser.bundle/PlayButtonOverlayLarge" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateNormal];
                [playButton setImage:[UIImage imageForResourcePath:@"MWPhotoBrowser.bundle/PlayButtonOverlayLargeTap" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateHighlighted];
                [playButton addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                [playButton sizeToFit];
                playButton.frame = [self frameForPlayButton:playButton atIndex:index];
                [_pagingScrollView addSubview:playButton];
                page.playButton = playButton;
            }
            
            // Add selected button
            if (self.displaySelectionButtons) {
                UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [selectedButton setImage:[UIImage imageForResourcePath:@"MWPhotoBrowser.bundle/ImageSelectedOff" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateNormal];
                UIImage *selectedOnImage;
                if (self.customImageSelectedIconName) {
                    selectedOnImage = [UIImage imageNamed:self.customImageSelectedIconName];
                } else {
                    selectedOnImage = [UIImage imageForResourcePath:@"MWPhotoBrowser.bundle/ImageSelectedOn" ofType:@"png" inBundle:[NSBundle bundleForClass:[self class]]];
                }
                [selectedButton setImage:selectedOnImage forState:UIControlStateSelected];
                [selectedButton sizeToFit];
                selectedButton.adjustsImageWhenHighlighted = NO;
                [selectedButton addTarget:self action:@selector(selectedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                selectedButton.frame = [self frameForSelectedButton:selectedButton atIndex:index];
                [_pagingScrollView addSubview:selectedButton];
                page.selectedButton = selectedButton;
                selectedButton.selected = [self photoIsSelectedAtIndex:index];
            }
            
		}
	}
	
}

- (void)updateVisiblePageStates {
    NSSet *copy = [_visiblePages copy];
    for (MWZoomingScrollView *page in copy) {
        
        // Update selection
        page.selectedButton.selected = [self photoIsSelectedAtIndex:page.index];
        
    }
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
	for (MWZoomingScrollView *page in _visiblePages)
		if (page.index == index) return YES;
	return NO;
}

- (MWZoomingScrollView *)pageDisplayedAtIndex:(NSUInteger)index {
	MWZoomingScrollView *thePage = nil;
	for (MWZoomingScrollView *page in _visiblePages) {
		if (page.index == index) {
			thePage = page; break;
		}
	}
	return thePage;
}

- (MWZoomingScrollView *)pageDisplayingPhoto:(id<MWPhoto>)photo {
	MWZoomingScrollView *thePage = nil;
	for (MWZoomingScrollView *page in _visiblePages) {
		if (page.photo == photo) {
			thePage = page; break;
		}
	}
	return thePage;
}

- (void)configurePage:(MWZoomingScrollView *)page forIndex:(NSUInteger)index {
	page.frame = [self frameForPageAtIndex:index];
    page.index = index;
    page.photo = [self photoAtIndex:index];
}

- (MWZoomingScrollView *)dequeueRecycledPage {
	MWZoomingScrollView *page = [_recycledPages anyObject];
	if (page) {
		[_recycledPages removeObject:page];
	}
	return page;
}

// Handle page changes
- (void)didStartViewingPageAtIndex:(NSUInteger)index {
    
    // Handle 0 photos
    if (![self numberOfPhotos]) {
        // Show controls
        [self setControlsHidden:NO animated:YES permanent:YES];
        return;
    }
    
    // Handle video on page change
    if (!_rotating || index != _currentVideoIndex) {
        [self clearCurrentVideo];
    }
    
    // Release images further away than +/-1
    NSUInteger i;
    if (index > 0) {
        // Release anything < index - 1
        for (i = 0; i < index-1; i++) { 
            id photo = [_photos objectAtIndex:i];
            if (photo != [NSNull null]) {
                [photo unloadUnderlyingImage];
                [_photos replaceObjectAtIndex:i withObject:[NSNull null]];
                MWLog(@"Released underlying image at index %lu", (unsigned long)i);
            }
        }
    }
    if (index < [self numberOfPhotos] - 1) {
        // Release anything > index + 1
        for (i = index + 2; i < _photos.count; i++) {
            id photo = [_photos objectAtIndex:i];
            if (photo != [NSNull null]) {
                [photo unloadUnderlyingImage];
                [_photos replaceObjectAtIndex:i withObject:[NSNull null]];
                MWLog(@"Released underlying image at index %lu", (unsigned long)i);
            }
        }
    }
    
    // Load adjacent images if needed and the photo is already
    // loaded. Also called after photo has been loaded in background
    id <MWPhoto> currentPhoto = [self photoAtIndex:index];
    if ([currentPhoto underlyingImage]) {
        // photo loaded so load ajacent now
        [self loadAdjacentPhotosIfNecessary:currentPhoto];
    }
    
    // Notify delegate
    if (index != _previousPageIndex) {
        if ([_delegate respondsToSelector:@selector(photoBrowser:didDisplayPhotoAtIndex:)])
            [_delegate photoBrowser:self didDisplayPhotoAtIndex:index];
        _previousPageIndex = index;
    }
    
    // Update nav
    if (!_isHiddenNavTitle) {
        [self updateNavigation];
    }
    
    
}

- (void)showLoadingIndicator:(NSUInteger)index {
    id <MWPhoto> photo = [self photoAtIndex:index];
    MWZoomingScrollView *page = [self pageDisplayingPhoto:photo];
    if (page) {
        [page showLoadingIndicator];
    }
}

/**
 *  刷新Photo模式下的图片
 */
- (void)didStartReloadPhotoView:(NSUInteger)index image:(UIImage *)image photo:(id<MWPhoto>)photo{
    /* 先刷新当前展现出的图片 */
    id<MWPhoto> oldPhoto = [_photos objectAtIndex:index];
    MWZoomingScrollView *page = [self pageDisplayingPhoto:oldPhoto];

    if (page) {
        [page reloadImage:image];
        [page hideLoadingIndicator];
    } else {
//        [self didStartViewingPageAtIndex:index];
        MWZoomingScrollView *page = [self pageDisplayingPhoto:oldPhoto];
        [page reloadImage:image];
    }
    
    /* 再替换 */
    [_photos replaceObjectAtIndex:index withObject:photo];
    /* 替换_visiblePages中的photo，避免再次reload此图时失效，即从小图到大图 */
    for (MWZoomingScrollView *page in _visiblePages) {
        if (page.photo == oldPhoto) {
            page.photo = photo;
            [page setMaxMinZoomScalesForCurrentBounds]; //解决首次加载网络图片时，双击后图片消失的问题
            [page hideLoadingIndicator];
        }
    }
}

/**
 *  刷新Grid模式下的图片
 */
- (void)didStartReloadGridView:(NSUInteger)index image:(UIImage *)image photo:(id<MWPhoto>)photo{
    /* 先替换 */
    [_thumbPhotos replaceObjectAtIndex:index withObject:photo];
    
    /* 再刷新 */
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    [_gridController.collectionView reloadItemsAtIndexPaths:indexPaths];
}

/**
 *  Photo模式下，加载失败
 */
- (void)didLoadPhotoViewFail:(NSUInteger)index{
    /* 取消index的加载进度 */
//    id<MWPhoto> oldPhoto = [_photos objectAtIndex:index];
    MWZoomingScrollView *page = [self pageDisplayedAtIndex:index];
    if (page) {
        [page hideLoadingIndicator];
    }
    id<MWPhoto> oldPhoto = [_photos objectAtIndex:index];
    if(oldPhoto != NULL && ![oldPhoto isEqual:[NSNull null]]){
        [oldPhoto setIsStillShowLoadingAfterShow:NO];
    }
    
    /* 若为当前展现的图片，给出提示 */
    if(_currentPageIndex == index){
        [LZToast showWithText:@"下载原图失败" bottomOffset:50.f];
    }
}

#pragma mark - Frame Calculations

- (CGRect)frameForPagingScrollView {
    CGRect frame = self.view.bounds;// [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return CGRectIntegral(frame);
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = _pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return CGRectIntegral(pageFrame);
}

- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = _pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self numberOfPhotos], bounds.size.height);
}

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index {
	CGFloat pageWidth = _pagingScrollView.bounds.size.width;
	CGFloat newOffset = index * pageWidth;
	return CGPointMake(newOffset, 0);
}

- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation {
    CGFloat height = 44;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
        UIInterfaceOrientationIsLandscape(orientation)) height = 32;
	return CGRectIntegral(CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height));
}

- (CGRect)frameForCaptionView:(MWCaptionView *)captionView atIndex:(NSUInteger)index {
    CGRect pageFrame = [self frameForPageAtIndex:index];
    CGSize captionSize = [captionView sizeThatFits:CGSizeMake(pageFrame.size.width, 0)];
    CGRect captionFrame = CGRectMake(pageFrame.origin.x,
                                     pageFrame.size.height - captionSize.height - (_toolbar.superview?_toolbar.frame.size.height:0),
                                     pageFrame.size.width,
                                     captionSize.height);
    return CGRectIntegral(captionFrame);
}

- (CGRect)frameForSelectedButton:(UIButton *)selectedButton atIndex:(NSUInteger)index {
    CGRect pageFrame = [self frameForPageAtIndex:index];
    CGFloat padding = 20;
    CGFloat yOffset = 0;
    if (![self areControlsHidden]) {
        UINavigationBar *navBar = self.navigationController.navigationBar;
        yOffset = navBar.frame.origin.y + navBar.frame.size.height;
    }
    CGRect selectedButtonFrame = CGRectMake(pageFrame.origin.x + pageFrame.size.width - selectedButton.frame.size.width - padding,
                                            padding + yOffset,
                                            selectedButton.frame.size.width,
                                            selectedButton.frame.size.height);
    return CGRectIntegral(selectedButtonFrame);
}

- (CGRect)frameForPlayButton:(UIButton *)playButton atIndex:(NSUInteger)index {
    CGRect pageFrame = [self frameForPageAtIndex:index];
    return CGRectMake(floorf(CGRectGetMidX(pageFrame) - playButton.frame.size.width / 2),
                      floorf(CGRectGetMidY(pageFrame) - playButton.frame.size.height / 2),
                      playButton.frame.size.width,
                      playButton.frame.size.height);
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
    // Checks
	if (!_viewIsActive || _performingLayout || _rotating) return;
	
	// Tile pages
	[self tilePages];
	
	// Calculate current page
	CGRect visibleBounds = _pagingScrollView.bounds;
	NSInteger index = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
	if (index > [self numberOfPhotos] - 1) index = [self numberOfPhotos] - 1;
	NSUInteger previousCurrentPage = _currentPageIndex;
	_currentPageIndex = index;
	if (_currentPageIndex != previousCurrentPage) {
        [self didStartViewingPageAtIndex:index];
    }
	
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	// Hide controls when dragging begins
    /* 区分单击退出和tarbar退出长按后tarbar显影问题 */
    if(_isClickExit){
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.alpha = 0;
    }else{
        [self setControlsHidden:YES animated:YES permanent:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	// Update nav when page changes
	[self updateNavigation];
}

#pragma mark - Navigation

- (void)updateNavigation {
    
    BOOL isUpdate = NO;
    if([self.delegate respondsToSelector:@selector(lzPhotoBrowserUpdateNavigationController:)]){
        isUpdate = [self.delegate lzPhotoBrowserUpdateNavigationController:self];
    }

    if(isUpdate){
        return;
    }
    
	// Title
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    if([NSString isNullOrEmpty:_customTitle]){
        if (_gridController) {
            if (_gridController.selectionMode) {
                self.title = NSLocalizedString(@"Select Photos", nil);
                self.clickExitLabel.text = NSLocalizedString(@"Select Photos", nil);
            } else {
                NSString *photosText;
                if (numberOfPhotos == 1) {
                    photosText = NSLocalizedString(@"photo", @"Used in the context: '1 photo'");
                } else {
                    photosText = NSLocalizedString(@"photos", @"Used in the context: '3 photos'");
                }
                self.title = [NSString stringWithFormat:@"%lu %@", (unsigned long)numberOfPhotos, photosText];
                self.clickExitLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)numberOfPhotos, photosText];
            }
        } else if (numberOfPhotos > 1) {
            if ([_delegate respondsToSelector:@selector(photoBrowser:titleForPhotoAtIndex:)]) {
                self.title = [_delegate photoBrowser:self titleForPhotoAtIndex:_currentPageIndex];
                self.clickExitLabel.text = [_delegate photoBrowser:self titleForPhotoAtIndex:_currentPageIndex];
            } else {
                self.title = [NSString stringWithFormat:@"%lu %@ %lu", (unsigned long)(_currentPageIndex+1), NSLocalizedString(@"/", @"Used in the context: 'Showing 1 / 3 items'"), (unsigned long)numberOfPhotos];
                self.clickExitLabel.text = [NSString stringWithFormat:@"%lu %@ %lu", (unsigned long)(_currentPageIndex+1), NSLocalizedString(@"/", @"Used in the context: 'Showing 1 / 3 items'"), (unsigned long)numberOfPhotos];
            }
        } else {
    //		self.title = nil;
            
            if ([_delegate respondsToSelector:@selector(photoBrowser:titleForPhotoAtIndex:)]) {
                self.title = [_delegate photoBrowser:self titleForPhotoAtIndex:_currentPageIndex];
                self.clickExitLabel.text = [_delegate photoBrowser:self titleForPhotoAtIndex:_currentPageIndex];
            } else {
                self.title = [NSString stringWithFormat:@"%lu %@ %lu", (unsigned long)(_currentPageIndex+1), NSLocalizedString(@"/", @"Used in the context: 'Showing 1 / 3 items'"), (unsigned long)numberOfPhotos];
                self.clickExitLabel.text = [NSString stringWithFormat:@"%lu %@ %lu", (unsigned long)(_currentPageIndex+1), NSLocalizedString(@"/", @"Used in the context: 'Showing 1 / 3 items'"), (unsigned long)numberOfPhotos];
            }
        }
    }
	
	// Buttons
	_previousButton.enabled = (_currentPageIndex > 0);
	_nextButton.enabled = (_currentPageIndex < numberOfPhotos - 1);
    
    // Disable action button if there is no image or it's a video
    MWPhoto *photo = [self photoAtIndex:_currentPageIndex];
    if ([photo underlyingImage] == nil || ([photo respondsToSelector:@selector(isVideo)] && photo.isVideo)) {
        _actionButton.enabled = NO;
        _actionButton.tintColor = [UIColor clearColor]; // Tint to hide button
    } else {
        _actionButton.enabled = YES;
        _actionButton.tintColor = nil;
    }
    if ([photo respondsToSelector:@selector(caption)]) {
        if ([photo caption]) {
            _clickExitLabel.hidden = YES;
        }
        else{
            _clickExitLabel.hidden = NO;
        }
    }
}

- (void)jumpToPageAtIndex:(NSUInteger)index animated:(BOOL)animated {
	
	// Change page
	if (index < [self numberOfPhotos]) {
		CGRect pageFrame = [self frameForPageAtIndex:index];
        [_pagingScrollView setContentOffset:CGPointMake(pageFrame.origin.x - PADDING, 0) animated:animated];
		[self updateNavigation];
	}
	
	// Update timer to give more time
	[self hideControlsAfterDelay];
	
}

- (void)gotoPreviousPage {
    [self showPreviousPhotoAnimated:NO];
}
- (void)gotoNextPage {
    [self showNextPhotoAnimated:NO];
}

- (void)showPreviousPhotoAnimated:(BOOL)animated {
    [self jumpToPageAtIndex:_currentPageIndex-1 animated:animated];
}

- (void)showNextPhotoAnimated:(BOOL)animated {
    [self jumpToPageAtIndex:_currentPageIndex+1 animated:animated];
}

#pragma mark - Interactions

- (void)selectedButtonTapped:(id)sender {
    UIButton *selectedButton = (UIButton *)sender;
    selectedButton.selected = !selectedButton.selected;
    NSUInteger index = NSUIntegerMax;
    for (MWZoomingScrollView *page in _visiblePages) {
        if (page.selectedButton == selectedButton) {
            index = page.index;
            break;
        }
    }
    if (index != NSUIntegerMax) {
        [self setPhotoSelected:selectedButton.selected atIndex:index];
    }
}

- (void)playButtonTapped:(id)sender {
    UIButton *playButton = (UIButton *)sender;
    NSUInteger index = NSUIntegerMax;
    for (MWZoomingScrollView *page in _visiblePages) {
        if (page.playButton == playButton) {
            index = page.index;
            break;
        }
    }
    if (index != NSUIntegerMax) {
        if (!_currentVideoPlayerViewController) {
            [self playVideoAtIndex:index];
        }
    }
}

#pragma mark - Video

- (void)playVideoAtIndex:(NSUInteger)index {
    id photo = [self photoAtIndex:index];
    if ([photo respondsToSelector:@selector(getVideoURL:)]) {
        
        // Valid for playing
        _currentVideoIndex = index;
        [self clearCurrentVideo];
        [self setVideoLoadingIndicatorVisible:YES atPageIndex:index];
        
        // Get video and play
        [photo getVideoURL:^(NSURL *url) {
            if (url) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self _playVideo:url atPhotoIndex:index];
                });
            } else {
                [self setVideoLoadingIndicatorVisible:NO atPageIndex:index];
            }
        }];
        
    }
}

- (void)_playVideo:(NSURL *)videoURL atPhotoIndex:(NSUInteger)index {

    // Setup player
    _currentVideoPlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [_currentVideoPlayerViewController.moviePlayer prepareToPlay];
    _currentVideoPlayerViewController.moviePlayer.shouldAutoplay = YES;
    _currentVideoPlayerViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    _currentVideoPlayerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // Remove the movie player view controller from the "playback did finish" notification observers
    // Observe ourselves so we can get it to use the crossfade transition
    [[NSNotificationCenter defaultCenter] removeObserver:_currentVideoPlayerViewController
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:_currentVideoPlayerViewController.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_currentVideoPlayerViewController.moviePlayer];

    // Show
    [self presentViewController:_currentVideoPlayerViewController animated:YES completion:nil];

}

- (void)videoFinishedCallback:(NSNotification*)notification {
    
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:_currentVideoPlayerViewController.moviePlayer];
    
    // Clear up
    [self clearCurrentVideo];
    
    // Dismiss
    BOOL error = [[[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue] == MPMovieFinishReasonPlaybackError;
    if (error) {
        // Error occured so dismiss with a delay incase error was immediate and we need to wait to dismiss the VC
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)clearCurrentVideo {
    if (!_currentVideoPlayerViewController) return;
    [_currentVideoLoadingIndicator removeFromSuperview];
    _currentVideoPlayerViewController = nil;
    _currentVideoLoadingIndicator = nil;
    _currentVideoIndex = NSUIntegerMax;
}

- (void)setVideoLoadingIndicatorVisible:(BOOL)visible atPageIndex:(NSUInteger)pageIndex {
    if (_currentVideoLoadingIndicator && !visible) {
        [_currentVideoLoadingIndicator removeFromSuperview];
        _currentVideoLoadingIndicator = nil;
    } else if (!_currentVideoLoadingIndicator && visible) {
        _currentVideoLoadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        [_currentVideoLoadingIndicator sizeToFit];
        [_currentVideoLoadingIndicator startAnimating];
        [_pagingScrollView addSubview:_currentVideoLoadingIndicator];
        [self positionVideoLoadingIndicator];
    }
}

- (void)positionVideoLoadingIndicator {
    if (_currentVideoLoadingIndicator && _currentVideoIndex != NSUIntegerMax) {
        CGRect frame = [self frameForPageAtIndex:_currentVideoIndex];
        _currentVideoLoadingIndicator.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    }
}

#pragma mark - Grid

- (void)showGridAnimated {
    [self showGrid:YES];
}

- (void)showGrid:(BOOL)animated {

    if (_gridController) return;
    
    // Init grid controller
    _gridController = [[MWGridViewController alloc] init];
    _gridController.initialContentOffset = _currentGridContentOffset;
    _gridController.browser = self;
    _gridController.selectionMode = _displaySelectionButtons;
    _gridController.view.frame = self.view.bounds;
    _gridController.view.frame = CGRectOffset(_gridController.view.frame, 0, (self.startOnGrid ? -1 : 1) * self.view.bounds.size.height);
    
    // Stop specific layout being triggered
    _skipNextPagingScrollViewPositioning = YES;
    
    // Add as a child view controller
    [self addChildViewController:_gridController];
    [self.view addSubview:_gridController.view];
    
    
    if (!_isHaveFile && !_emptyView) {
        
        /* 空白区，视图 */
        _emptyView = [[UIView alloc] init];
        _emptyView.frame = CGRectMake(0, 0, LZ_SCREEN_WIDTH, LZ_SCREEN_HEIGHT);
        _emptyView.userInteractionEnabled = NO ;
        _emptyView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];;
        [_gridController.view addSubview:_emptyView];
//        _gridController.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        
        /* 构建中间区域 */
        UIView *emptyCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 100+30)];
//        emptyCenterView.backgroundColor =  [UIColor redColor];
        emptyCenterView.center=CGPointMake(LZ_SCREEN_WIDTH/2, (LZ_SCREEN_HEIGHT/2)*9/10);
        
        _emptyCenterImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
        
        _emptyCenterImage.image = [ImageManager LZGetImageByFileName:@"nocont"];
        [emptyCenterView addSubview:_emptyCenterImage];
        
        UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _emptyCenterImage.bounds.size.height, emptyCenterView.bounds.size.width, 30)];
        emptyLabel.text = @"无聊天文件";
        emptyLabel.font = [UIFont systemFontOfSize:14];
        emptyLabel.textColor = [UIColor colorWithRed:0.690 green:0.686 blue:0.707 alpha:1.000];
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        [emptyCenterView addSubview:emptyLabel];
        
        //        [self hideEmptyView];
        [_emptyView addSubview:emptyCenterView];
    }
    // Perform any adjustments
    [_gridController.view layoutIfNeeded];
    [_gridController adjustOffsetsAsRequired];
    
    // Hide action button on nav bar if it exists
    if (self.navigationItem.rightBarButtonItem == _actionButton) {
        _gridPreviousRightNavItem = _actionButton;
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    } else {
        _gridPreviousRightNavItem = nil;
    }
    
    // Update
    [self updateNavigation];
    [self setControlsHidden:NO animated:YES permanent:YES];
    
    // Animate grid in and photo scroller out
    [_gridController willMoveToParentViewController:self];
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^(void) {
        _gridController.view.frame = self.view.bounds;
        CGRect newbounds = _gridController.view.frame;
        newbounds.origin.y -= 1;
        _gridController.view.frame = newbounds;
        CGRect newPagingFrame = [self frameForPagingScrollView];
        newPagingFrame = CGRectOffset(newPagingFrame, 0, (self.startOnGrid ? 1 : -1) * newPagingFrame.size.height);
        _pagingScrollView.frame = newPagingFrame;
    } completion:^(BOOL finished) {
        [_gridController didMoveToParentViewController:self];
    }];
}

- (void)hideGrid {
    
    if (!_gridController) return;
    
    // Remember previous content offset
    _currentGridContentOffset = _gridController.collectionView.contentOffset;
    
    // Restore action button if it was removed
    if (_gridPreviousRightNavItem == _actionButton && _actionButton) {
        [self.navigationItem setRightBarButtonItem:_gridPreviousRightNavItem animated:YES];
    }
    
    // Position prior to hide animation
    CGRect newPagingFrame = [self frameForPagingScrollView];
    newPagingFrame = CGRectOffset(newPagingFrame, 0, (self.startOnGrid ? 1 : -1) * newPagingFrame.size.height);
    _pagingScrollView.frame = newPagingFrame;
    
    // Remember and remove controller now so things can detect a nil grid controller
    MWGridViewController *tmpGridController = _gridController;
    _gridController = nil;
    
    // Update
    [self updateNavigation];
    [self updateVisiblePageStates];
    
    // Animate, hide grid and show paging scroll view
    [UIView animateWithDuration:0.3 animations:^{
        tmpGridController.view.frame = CGRectOffset(self.view.bounds, 0, (self.startOnGrid ? -1 : 1) * self.view.bounds.size.height);
        _pagingScrollView.frame = [self frameForPagingScrollView];
    } completion:^(BOOL finished) {
        [tmpGridController willMoveToParentViewController:nil];
        [tmpGridController.view removeFromSuperview];
        [tmpGridController removeFromParentViewController];
        [self setControlsHidden:NO animated:YES permanent:NO]; // retrigger timer
    }];

}

#pragma mark - Control Hiding / Showing

// If permanent then we don't set timers to hide again
// Fades all controls on iOS 5 & 6, and iOS 7 controls slide and fade
- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated permanent:(BOOL)permanent {
    
    // Force visible
    if (![self numberOfPhotos] || _gridController || _alwaysShowControls)
        hidden = NO;
    
    // Cancel any timers
    [self cancelControlHiding];
    CGFloat animatedNum;
    if(_isClickExit){
        animatedNum = 0.75;
    }else{
        animatedNum = 0.35;
    }
    // Animations & positions
    CGFloat animatonOffset = 20;
    CGFloat animationDuration = (animated ? animatedNum : 0);
    
    // Status bar
    if (!_leaveStatusBarAlone) {

        // Hide status bar
        if (!_isVCBasedStatusBarAppearance) {
            
            // Non-view controller based
            [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:animated ? UIStatusBarAnimationSlide : UIStatusBarAnimationNone];
            
        } else {
            
            // View controller based so animate away
            _statusBarShouldBeHidden = hidden;
            [UIView animateWithDuration:animationDuration animations:^(void) {
                [self setNeedsStatusBarAppearanceUpdate];
            } completion:^(BOOL finished) {}];
            
        }

    }
    
    // Toolbar, nav bar and captions
    // Pre-appear animation positions for sliding
    if ([self areControlsHidden] && !hidden && animated) {
        
        // Toolbar
        _toolbar.frame = CGRectOffset([self frameForToolbarAtOrientation:self.interfaceOrientation], 0, animatonOffset);
        
        // Captions
        for (MWZoomingScrollView *page in _visiblePages) {
            if (page.captionView) {
                MWCaptionView *v = page.captionView;
                // Pass any index, all we're interested in is the Y
                CGRect captionFrame = [self frameForCaptionView:v atIndex:0];
                captionFrame.origin.x = v.frame.origin.x; // Reset X
                v.frame = CGRectOffset(captionFrame, 0, animatonOffset);
            }
        }
        
    }
    [UIView animateWithDuration:animationDuration animations:^(void) {
        
        CGFloat alpha = hidden ? 0 : 1;

        // Nav bar slides up on it's own on iOS 7+
        [self.navigationController.navigationBar setAlpha:alpha];
        
        // Toolbar
        _toolbar.frame = [self frameForToolbarAtOrientation:self.interfaceOrientation];
        if (hidden) _toolbar.frame = CGRectOffset(_toolbar.frame, 0, animatonOffset);
        _toolbar.alpha = alpha;

        // Captions
        for (MWZoomingScrollView *page in _visiblePages) {
            if (page.captionView) {
                MWCaptionView *v = page.captionView;
                // Pass any index, all we're interested in is the Y
                CGRect captionFrame = [self frameForCaptionView:v atIndex:0];
                captionFrame.origin.x = v.frame.origin.x; // Reset X
                if (hidden) captionFrame = CGRectOffset(captionFrame, 0, animatonOffset);
                v.frame = captionFrame;
                v.alpha = alpha;
            }
        }
        
        // Selected buttons
        for (MWZoomingScrollView *page in _visiblePages) {
            if (page.selectedButton) {
                UIButton *v = page.selectedButton;
                CGRect newFrame = [self frameForSelectedButton:v atIndex:0];
                newFrame.origin.x = v.frame.origin.x;
                v.frame = newFrame;
            }
        }

    } completion:^(BOOL finished) {
    
       
        
    }];
    
	// Control hiding timer
	// Will cancel existing timer but only begin hiding if
	// they are visible
	if (!permanent) [self hideControlsAfterDelay];
	
}

- (BOOL)prefersStatusBarHidden {
    if (!_leaveStatusBarAlone) {
        return _statusBarShouldBeHidden;
    } else {
        return [self presentingViewControllerPrefersStatusBarHidden];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (void)cancelControlHiding {
	// If a timer exists then cancel and release
	if (_controlVisibilityTimer) {
		[_controlVisibilityTimer invalidate];
		_controlVisibilityTimer = nil;
	}
}

// Enable/disable control visiblity timer
- (void)hideControlsAfterDelay {
	if (![self areControlsHidden]) {
        if(!_isClickExit){
            [self cancelControlHiding];
           _controlVisibilityTimer = [NSTimer scheduledTimerWithTimeInterval:self.delayToHideElements target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
        }
	}
}

- (BOOL)areControlsHidden { return (_toolbar.alpha == 0); }
- (void)hideControls {
    if(_isClickExit){
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.alpha = 0;
    }else{
        [self setControlsHidden:YES animated:YES permanent:NO];
    }
}
- (void)showControls {
    [self setControlsHidden:NO animated:YES permanent:NO]; }
- (void)toggleControls {
    if(_isClickExit){
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        //用于防止图片浏览为单击退出模式下导航栏消失的问题
        self.navigationController.navigationBarHidden = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(lzClickExistPhotoBrowser:controller:)]) {
            [self.delegate lzClickExistPhotoBrowser:self controller:_pushFromController];
            
        }
        else {
             [self.navigationController popViewControllerAnimated:YES];
        }
       
    }else{
        [self setControlsHidden:![self areControlsHidden] animated:YES permanent:NO];
    }
}

#pragma mark - Properties

- (void)setCurrentPhotoIndex:(NSUInteger)index {
    // Validate
    NSUInteger photoCount = [self numberOfPhotos];
    if (photoCount == 0) {
        index = 0;
    } else {
        if (index >= photoCount)
            index = [self numberOfPhotos]-1;
    }
    _currentPageIndex = index;
	if ([self isViewLoaded]) {
        [self jumpToPageAtIndex:index animated:NO];
        if (!_viewIsActive)
            [self tilePages]; // Force tiling if view is not visible
    }
}

#pragma mark - Misc

- (void)doneButtonPressed:(id)sender {
    // Only if we're modal and there's a done button
    if (_doneButton) {
        // See if we actually just want to show/hide grid
        if (self.enableGrid) {
            if (self.startOnGrid && !_gridController) {
                [self showGrid:YES];
                return;
            } else if (!self.startOnGrid && _gridController) {
                [self hideGrid];
                return;
            }
        }
        // Dismiss view controller
        if ([_delegate respondsToSelector:@selector(photoBrowserDidFinishModalPresentation:)]) {
            // Call delegate method and let them dismiss us
            [_delegate photoBrowserDidFinishModalPresentation:self];
        } else  {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - Actions

- (void)actionButtonPressed:(id)sender {

    // Only react when image has loaded
    id <MWPhoto> photo = [self photoAtIndex:_currentPageIndex];
    if ([self numberOfPhotos] > 0 && [photo underlyingImage]) {
        
        // If they have defined a delegate method then just message them
        if ([self.delegate respondsToSelector:@selector(photoBrowser:actionButtonPressedForPhotoAtIndex:)]) {
            
            // Let delegate handle things
            [self.delegate photoBrowser:self actionButtonPressedForPhotoAtIndex:_currentPageIndex];
            
        } else {
            
            // Show activity view controller
            UIImage *img = [photo underlyingImage];
            
           // UIImage *image = [UIImage imageWithCGImage:img.CGImage];
            

            NSMutableArray *items = [NSMutableArray arrayWithObject:img];
            
            if (photo.caption) {
                [items addObject:photo.caption];
            }
            ShareActivityModel *shareModel = [[ShareActivityModel alloc] init];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshare"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            shareModel.isNotShowSelfApp = YES;
            [shareModel  shareWithDataArr:items controller:self];
            
//            self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
//             [LCProgressHUD showLoading:@""];
            // Show loading spinner after a couple of seconds
//            double delayInSeconds = 2.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                if (self.activityViewController) {
////                    [self showProgressHUDWithMessage:nil];
//                }
//            });

            // Show
//            typeof(self) __weak weakSelf = self;
//            [self.activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
//                weakSelf.activityViewController = nil;
//                [weakSelf hideControlsAfterDelay];
//                [weakSelf hideProgressHUD:YES];
//                
//            }];
           
            // iOS 8 - Set the Anchor Point for the popover
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
                shareModel.activityVC.popoverPresentationController.barButtonItem = _actionButton;
            }
            
//            [self presentViewController:self.activityViewController animated:YES completion:nil];
//            [LCProgressHUD hide];
        }
        if(!_isClickExit){
            // Keep controls hidden
            [self setControlsHidden:NO animated:YES permanent:YES];
        }
    }
    
}

- (void)actionButtonIsCommentAction{
    if(_isComment){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(lzPhotoBrowserRightBarController:Cur:)]) {
            
            [self.delegate lzPhotoBrowserRightBarController:self Cur:_currentPageIndex];
        }
        return;
    }
    if (_coopeationFileComment != nil) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(lzPhotoCommentBrowserRightBarController:fileSource:)]) {
            [self.delegate lzPhotoCommentBrowserRightBarController:self fileSource:_coopeationFileComment];
        }
        return;
    }
}

#pragma mark - Action Progress

- (MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view isnotclicktohide:NO];
        _progressHUD.minSize = CGSizeMake(120, 120);
        _progressHUD.minShowTime = 1;
        [self.view addSubview:_progressHUD];
    }
    return _progressHUD;
}

- (void)showProgressHUDWithMessage:(NSString *)message {
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    [self.progressHUD show:YES];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}

- (void)hideProgressHUD:(BOOL)animated {
    [self.progressHUD hide:animated];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}

- (void)showProgressHUDCompleteMessage:(NSString *)message {
    if (message) {
        if (self.progressHUD.isHidden) [self.progressHUD show:YES];
        self.progressHUD.labelText = message;
        self.progressHUD.mode = MBProgressHUDModeCustomView;
        [self.progressHUD hide:YES afterDelay:1.5];
    } else {
        [self.progressHUD hide:YES];
    }
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}

#pragma mark UILongPressGestureRecognizer
/**
 *  图片长按事件
 *
 */
-(void)onImageViewLongPressEvent:(UILongPressGestureRecognizer *)gesture{
    /* 当长按图片的时候，调用block，再重新添加一遍_customUIAlertActionArray数组 */
    if (_alertBlock) {
        _alertBlock();
    }
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        if(!_isNotLongPressEvent){
            
            if(gesture.state!=UIGestureRecognizerStateBegan) return;
            
            /* 小图和坏图不显示 */
            if([self otherInfo] == nil){
                return;
            }
            /* 区分单击退出和tarbar退出长按后tarbar显影问题 */
            if(_isClickExit){
                self.navigationController.navigationBarHidden = NO;
                self.navigationController.navigationBar.alpha = 0;
            }else{
                [self setControlsHidden:YES animated:NO permanent:YES];
            }

    //        if (self.delegate && [self.delegate respondsToSelector:@selector(lzPhotoBrowserLongPressEvent:)]) {
    //            
    //            [self.delegate lzPhotoBrowserLongPressEvent:self];
    //        }
            
            UIAlertController *moreAlter = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            __weak typeof(self) weakSelf = self;
            if(_customUIAlertActionArray && _customUIAlertActionArray.count>0){
                for(int i=0;i<_customUIAlertActionArray.count;i++){
                    id data = [_customUIAlertActionArray objectAtIndex:i];
                    if( [data isKindOfClass:[NSString class]] ){
                        NSString *strData = (NSString *)data;
                        if([strData isEqualToString:MWPhoto_AlertAction_IdentifyQrCode]){
                            /* 子线程执行 */
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                [weakSelf identifyQrCode];
                                /* 在主线程中 */
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if(_isIdentifyQrCode){
        //                                self.isIdentifyQrCode=NO;
                                        UIAlertAction *identifyAction = [UIAlertAction actionWithTitle:strData style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                            [weakSelf longPressUIAlertActionClikc:strData];
                                        }];
                                        [moreAlter addAction:identifyAction];
                                    }else{
                                        return;
                                    }
                                    
                                });
                            });
                        }
//                        else if([strData isEqualToString:MWPhoto_AlertAction_DocumentCoop]){
//                            UIAlertAction *documentCoopAction = [UIAlertAction actionWithTitle:strData style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                                [weakSelf longPressUIAlertActionClikc:strData];
//                            }];
//                            /* 文档协作 */
//                            if([AppUtils checkIsPublicServer:@"documentcoop"] && ![NSString isNullOrEmpty:[[self.otherInfo seriaToDic] lzNSStringForKey:@"rid"]]){
//                                [moreAlter addAction:documentCoopAction];
//                            }
//                        }
                        else{
                            UIAlertAction *sendAction = [UIAlertAction actionWithTitle:strData style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [weakSelf longPressUIAlertActionClikc:strData];
                            }];
                            if(!_isClickExit){
                                if([strData isEqualToString:MWPhoto_AlertAction_Share]|| [strData isEqualToString:MWPhoto_AlertAction_Comment]){
                                }else{
                                    [moreAlter addAction:sendAction];
                                }
                            }else{
                                [moreAlter addAction:sendAction];
                            }
                        }
                    }
                    else if([data isKindOfClass:[UIAlertAction class]]){
                        UIAlertAction *actionData = (UIAlertAction *)data;
                        [moreAlter addAction:actionData];
                    }
                }
            }
            /* 使用默认 */
            else {
         
                UIAlertAction *sendToUserAction = [UIAlertAction actionWithTitle:MWPhoto_AlertAction_SendToUser style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf longPressUIAlertActionClikc:MWPhoto_AlertAction_SendToUser];
                }];
                
                UIAlertAction *saveImageAction = [UIAlertAction actionWithTitle:MWPhoto_AlertAction_SaveImage style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     [weakSelf longPressUIAlertActionClikc:MWPhoto_AlertAction_SaveImage];
                }];
                UIAlertAction *saveToDiskAction = [UIAlertAction actionWithTitle:MWPhoto_AlertAction_SaveToDisk style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf longPressUIAlertActionClikc:MWPhoto_AlertAction_SaveToDisk];
                }];
                UIAlertAction *shareAction = [UIAlertAction actionWithTitle:MWPhoto_AlertAction_Share style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf longPressUIAlertActionClikc:MWPhoto_AlertAction_Share];
                }];
//                UIAlertAction *documentCoopAction = [UIAlertAction actionWithTitle:MWPhoto_AlertAction_DocumentCoop style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [weakSelf longPressUIAlertActionClikc:MWPhoto_AlertAction_DocumentCoop];
//                }];
                
//                UIAlertAction *commentAction = [UIAlertAction actionWithTitle:MWPhoto_AlertAction_Comment style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [weakSelf longPressUIAlertActionClikc:MWPhoto_AlertAction_Comment];
//                }];
				
                [moreAlter addAction:sendToUserAction];
                [moreAlter addAction:saveToDiskAction];
                [moreAlter addAction:saveImageAction];
                if(_isClickExit){//单击模式
                    if(_isComment || _coopeationFileComment != nil){
                        [moreAlter addAction:shareAction];
                       // [moreAlter addAction:commentAction];
                    }
                    else{
                        [moreAlter addAction:shareAction];
                    }
                }
//                /* 文档协作 */
//                if([AppUtils checkIsPublicServer:@"documentcoop"] && ![NSString isNullOrEmpty:[[self.otherInfo seriaToDic] lzNSStringForKey:@"rid"]]){
//                    [moreAlter addAction:documentCoopAction];
//                }
                /* 子线程执行 */
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [weakSelf identifyQrCode];
                
                    /* 在主线程中 */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(_isIdentifyQrCode){
                            
                            UIAlertAction *identifyAction = [UIAlertAction actionWithTitle:MWPhoto_AlertAction_IdentifyQrCode style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [weakSelf longPressUIAlertActionClikc:MWPhoto_AlertAction_IdentifyQrCode];
                            }];
                            [moreAlter addAction:identifyAction];
                        }
                    });
                });
            }
            
            UIAlertAction *canelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { }];
            [moreAlter addAction:canelAction];
            
            [weakSelf presentViewController:moreAlter animated:YES completion:nil];
            
            return;
        }
    }
}

-(UIImage *)currentImage{
    MWPhoto *photo = [self photoAtIndex:_currentPageIndex];
    return  photo.underlyingImage;
}

//图片磁盘名称和磁盘显示名称
-(NSString *)otherInfo{
    MWPhoto *photo = [self photoAtIndex:_currentPageIndex];
    return photo.otherInfo;
}

#pragma mark - LZExpand

-(void)setCustomTitle:(NSString *)customTitle{
    UIView *titleview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, LZ_SCREEN_WIDTH-155, 25)];
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    titleLabel.frame=CGRectMake(0, 0, LZ_SCREEN_WIDTH-155, 25);
    titleLabel.text=customTitle;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleview.userInteractionEnabled=YES;
    _customTitle = titleLabel.text;
    [titleview addSubview:titleLabel];
    self.navigationItem.titleView = titleview;
}

/**
 *  长按后，点击处理
 */
-(void)longPressUIAlertActionClikc:(NSString *)key{
    BOOL result = NO;
    if(self.delegate && [self.delegate respondsToSelector:@selector(lzPhotoBrowserLongPressClickPhotoBrowser:key:)]){
        result = [self.delegate lzPhotoBrowserLongPressClickPhotoBrowser:self key:key];
    }
    /* delegate未处理 */
    if(!result){
        if([key isEqualToString:MWPhoto_AlertAction_SendToUser]){
            
        }
        else if([key isEqualToString:MWPhoto_AlertAction_SaveImage]){
            PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
            
            // 2. 判断授权状态
            if (authorizationStatus == PHAuthorizationStatusAuthorized) {
                
                [self saveImageToAlbum];
                
            } else if (authorizationStatus == PHAuthorizationStatusNotDetermined) { // 如果没决定, 弹出指示框, 让用户选择
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    
                    // 如果用户选择授权, 则保存图片
                    if (status == PHAuthorizationStatusAuthorized) {
                        [self saveImageToAlbum];
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [LCProgressHUD showFailure:@"保存失败"];
                        });
                    }
                }];
            } else {
                [SystemPrivilegesUtilViewModel plauthorizationStatusSession];
            }
        }
        else if([key isEqualToString:MWPhoto_AlertAction_SaveToDisk]){
            
        }
        else if ([key isEqualToString:MWPhoto_AlertAction_IdentifyQrCode]){
            
        }
        else if ([key isEqualToString:MWPhoto_AlertAction_Share]){
            [self actionButtonPressed:nil];
        }
//        else if ([key isEqualToString:MWPhoto_AlertAction_DocumentCoop]){
//
//        }
//        else if ([key isEqualToString:MWPhoto_AlertAction_Comment]){
//            [self actionButtonIsCommentAction];
//        }
    }
}

//保存图片到本地
- (void)saveImageToAlbum{
    
    NSData *imageData;
    UIImage *img=[self currentImage];
    NSLog(@"+++++++++%@",_customTitle);
    if([_customTitle.lowercaseString hasSuffix:@"png"]){
        imageData =  UIImagePNGRepresentation(img);
    }else{
        imageData =  UIImageJPEGRepresentation(img, 1.0);
    }
    UIImage* pngImage = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(pngImage,self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}
//实现imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:方法
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [LCProgressHUD showSuccess:@"保存成功"];
        
    }else{
        [LCProgressHUD showFailure:@"保存失败"];
    }
}

/**
 *  识别图中是否存在二维码
 */
-(void)identifyQrCode{
    
    /* 当前设备型号 */
    NSString *iPhoneDeveice=[self platform];
    UIImage *image = [self currentImage];
    
    
    /* 判断当前系统版本（大于8使用ios原生识别相册二维码，否则使用zxingObjec） */
    if(!([iPhoneDeveice rangeOfString:@"iPhone5,"].location != NSNotFound)&&LZ_IS_IOS8){
        
        CGImageRef imageToDecode = [image CGImage];  //给定图片寻找二维码
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                
                                                  context:[CIContext contextWithOptions:nil]
                                
                                                  options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:imageToDecode]];
        if (features.count >=1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            self.qrScanResults = feature.messageString;
            _isIdentifyQrCode=YES;
        }
        else{
            _isIdentifyQrCode=NO;
            NSLog(@"无QRCode");
            return;
        }
    }else{
        
//        if(image.size.height>LZ_SCREEN_HEIGHT){
//            CGSize sizes=CGSizeMake(image.size.width, LZ_SCREEN_HEIGHT);
//            UIGraphicsBeginImageContext(sizes);  //size 为CGSize类型，即你所需要的图片尺寸
//            
//            [image drawInRect:CGRectMake(0, 0, LZ_SCREEN_WIDTH, LZ_SCREEN_WIDTH)];
//            
//            NSLog(@"%f,%f",sizes.width,sizes.height);
//            image = UIGraphicsGetImageFromCurrentImageContext();
//            
//            UIGraphicsEndImageContext();
//        }
        
        CGImageRef imageToDecode = [image CGImage];  //给定图片寻找二维码
        ZXCGImageLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
        ZXHybridBinarizer *binarizer = [[ZXHybridBinarizer alloc] initWithSource: source];
        ZXBinaryBitmap *bitmap = [[ZXBinaryBitmap alloc] initWithBinarizer:binarizer];
        
        NSError *error;
        
        id<ZXReader> reader;
        if (NSClassFromString(@"ZXMultiFormatReader")) {
            reader = [NSClassFromString(@"ZXMultiFormatReader") performSelector:@selector(reader)];
        }
        ZXDecodeHints *_hints = [ZXDecodeHints hints];
        ZXResult *result = [reader decode:bitmap hints:_hints error:&error];
        if (result == nil) {
            _isIdentifyQrCode=NO;
            NSLog(@"无QRCode");
            return;
        }
        _isIdentifyQrCode=YES;
        self.qrScanResults=result.text;
        NSLog(@"QRCode = %d，%@",result.barcodeFormat,result.text);
    }
    
}

/**
 *  获取当前设备型号
 *
 */
- (NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

//通过图片Data数据第一个字节 来获取图片扩展名

- (NSString *)contentTypeForImageData:(NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @"jpeg";
            
        case 0x89:
            
            return @"png";
            
        case 0x47:
            
            return @"gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"tiff";
            
        case 0x52:
            if (data.length >= 12) {
                //RIFF....WEBP
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                    return @"webp";
                }
            }
            return nil;
        case 0x00:
            if (data.length >= 12) {
                //....ftypheic ....ftypheix ....ftyphevc ....ftyphevx
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, 8)] encoding:NSASCIIStringEncoding];
                if ([testString isEqualToString:@"ftypheic"]
                    || [testString isEqualToString:@"ftypheix"]
                    || [testString isEqualToString:@"ftyphevc"]
                    || [testString isEqualToString:@"ftyphevx"]) {
                    return @"heic";
                }
            }
            return nil;
            
    }
    
    return nil;
    
}

@end
