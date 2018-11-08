//
//  MARFaceBeautyController.m
//  MARFaceBeauty
//
//  Created by Maru on 2016/11/12.
//  Copyright © 2016年 Maru. All rights reserved.
//

#import "MARFaceBeautyController.h"
#import "GPUImage.h"
#import <CoreMotion/CoreMotion.h>
#import "CLImageEditor.h"
#import "XHBaseNavigationController.h"
#import "NetRequest.h"
#import "UIImage+Watemark.h"
#import <CoreLocation/CoreLocation.h>      //添加定位服务头文件（不可缺少）
#import "AppDateUtil.h"
#import "HmacSha1Tool.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kMARGap 20.0
#define kMARSwitchW 30
#define kLimitRecLen 10.7f
#define kCameraWidth 540.0f
#define kCameraHeight 960.0f
#define kRecordW 87

#pragma mark -  心知天气的 API KEY / USER ID
static NSString *TIANQI_API_SECRET_KEY = @"qxeimbik1oilzk1v";   // YOUR API KEY
static NSString *TIANQI_API_USER_ID = @"U5ACD77300";            // YOUR USER ID
static NSString *TIANQI_NOW_WEATHER_URL = @"https://api.seniverse.com/v3/weather/now.json";         //天气实况 URL

#define kRecordCenter CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 70)

#define kFaceUColor [UIColor colorWithRed:66 / 255.0 green:222 / 255.0 blue:182 / 255.0 alpha:1]

#define kWeakSelf __weak typeof(self) weakSelf = self;

#define RMDefaultVideoPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Movie.MP4"]
#define RMDefaultImagePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Image.JPG"]
@interface MARFaceBeautyController () <CAAnimationDelegate,CLImageEditorDelegate,CLLocationManagerDelegate> {
    CGFloat _allTime;
    UIImage *_tempImg;
    AVPlayerLayer *_avplayer;
    CGFloat _initialPinchZoom;
    NSString *weatherType;
    NSString *address;
    
    ///AVFoundation
//    AVAsset * videoAsset;
    AVAssetExportSession *exporter;
}
//******** UIKit Property *************
@property (nonatomic, strong) UISlider *sliderView;
@property (nonatomic, strong) UIButton *flashSwitch; // 闪光灯开关
@property (nonatomic, strong) UIButton *filterSwitch;
@property (nonatomic, strong) UIButton *cameraSwitch; // 摄像头前后切换
@property (nonatomic, strong) UIButton *recordButton; // 录制按钮
@property (nonatomic, strong) UIButton *sendButton; // 发送按钮
@property (nonatomic, strong) UIButton *closeButton;  // 关闭按钮
@property (nonatomic, strong) UIButton *backButton;  // 返回按钮
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UILabel *hintLabel; // 提示文字
@property (nonatomic, strong) GPUImageView *gpuImageView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *weatherLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *logoImageView;

//******** Animation Property **********
@property (nonatomic, strong) CAShapeLayer *cycleLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *ballLayer;
@property (nonatomic, strong) CALayer *focusLayer;
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, strong) CADisplayLink *timerDate;
@property (nonatomic, strong) CABasicAnimation *scaleAnimation;

//******** Media Property **************
@property (nonatomic, copy) NSString *moviePath;
@property (nonatomic, strong) NSDictionary *audioSettings;
@property (nonatomic, strong) NSMutableDictionary *videoSettings;

//******** GPUImage Property ***********
@property (nonatomic, strong) GPUImageStillCamera *gpuImageStillCamera;
@property (nonatomic, strong) GPUImageFilterGroup *gpuImageFilterGroup;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;

@property (nonatomic, assign) UIInterfaceOrientation orientationLast; //方向
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) BOOL isCapturing; //是否正在拍摄中
@property (nonatomic, assign) LZVideoRecordOrientation recordOrientation;

//******** 定位地址  ***********
@property (nonatomic, strong) CLLocationManager *locationManager;//定位服务管理类
@property (nonatomic, assign) NSInteger locationNumber;

@property(nonatomic, strong) AVAsset *videoAsset;

@end

@implementation MARFaceBeautyController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _isCapturing = NO;
    
    [self setupUI];
    
    [self setupNotification];
    
    [self performSelector:@selector(hiddenHintLabel) withObject:nil afterDelay:4.0f];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self configInitScreenMode];
    });
    /* 添加捏合手势 */
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self.gpuImageView addGestureRecognizer:pinchGesture];
    
    // 设置获取天气位置的信息
//    _lzWaterMarkShowStyle = LZWaterMarkShowStylePhotoLogoAndInfo;
    if (_lzWaterMarkShowStyle != LZWaterMarkShowStylePhotoNone) {
        _locationManager = [[CLLocationManager alloc] init]; //创建CLLocationManager对象
        _locationManager.delegate = self; //设置代理，这样函数didUpdateLocations才会被回调
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters]; //精确到10米范围
        [_locationManager requestAlwaysAuthorization];
        [_locationManager startUpdatingLocation]; //启动定位服务
        self.locationNumber = 0;
    }
    else {
        _locationLabel.hidden = YES;
        _weatherLabel.hidden = YES;
        _dateLabel.hidden = YES;
        _logoImageView.hidden = YES;
    }
    _timerDate = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerDateUpdating)];
    _timerDate.frameInterval = 1;
    [_timerDate addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

/**
 *  处理捏合手势
 *
 *  @param recognizer 捏合手势识别器对象实例
 */
- (void)pinchDetected:(UIPinchGestureRecognizer*)recogniser {
    if (!self.gpuImageStillCamera.inputCamera)
        return;
    if (recogniser.state == UIGestureRecognizerStateBegan) {
        _initialPinchZoom = self.gpuImageStillCamera.inputCamera.videoZoomFactor;
    }
    NSError *error = nil;
    [self.gpuImageStillCamera.inputCamera lockForConfiguration:&error];
    
    if (!error) {
        CGFloat zoomFactor;
        CGFloat scale = recogniser.scale;
        if (scale < 1.0f) {
            zoomFactor = _initialPinchZoom - pow(self.gpuImageStillCamera.inputCamera.activeFormat.videoMaxZoomFactor, 1.0f - recogniser.scale);
        } else {
            zoomFactor = _initialPinchZoom + pow(self.gpuImageStillCamera.inputCamera.activeFormat.videoMaxZoomFactor, (recogniser.scale - 1.0f) / 2.5f);
        }
        zoomFactor = MIN(5.0f, zoomFactor);
        zoomFactor = MAX(1.0f, zoomFactor);
        
        self.gpuImageStillCamera.inputCamera.videoZoomFactor = zoomFactor;
        [self.gpuImageStillCamera.inputCamera unlockForConfiguration];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UMengUtil beginLogPageView:@"MARFaceBeautyController"];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    kWeakSelf
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL grantedVideo) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted || !grantedVideo) {
                    /* 添加提示label */
                    NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
                    if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未获得授权使用相机或麦克风" message:[NSString stringWithFormat:@"请在%@的\"设置-隐私-相机\"选项中，允许%@访问你的手机相机和麦克风。",[UIDevice currentDevice].model,appName] delegate:weakSelf cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                    alertView.tag = 1;
                    [alertView show];
                }
            });
        }];
    }];
    
    /* 隐藏状态栏 */
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    if([self.motionManager isAccelerometerAvailable]){
        [self orientationChange];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UMengUtil endLogPageView:@"MARFaceBeautyController"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LZMessageTextViewNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetLocationOfSelfNotific" object:nil];
    
    _timerDate = nil;
    [_timerDate invalidate];
    
    _timer = nil;
    [_timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _gpuImageStillCamera = nil;
    _gpuImageFilterGroup = nil;
//    _movieWriter = nil;
    _motionManager = nil;
    _locationManager = nil;
    _videoAsset = nil;
    _audioSettings = nil;
}

- (void)dealloc {
    _movieWriter = nil;
}

#pragma mark - Private Method

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor blackColor];
    /* 整个拍摄相机 */
    self.gpuImageView = ({
        GPUImageView *g = [[GPUImageView alloc] init];
        [g.layer addSublayer:self.focusLayer];
        [g addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusTap:)]];
        [g setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
        [self.view addSubview:g];
        g;
    });
    /* 用于展示拍照后的图片 */
    self.imageView = ({
        UIImageView *i = [[UIImageView alloc] init];
        i.hidden = YES;
        [self.view addSubview:i];
        i;
    });
    /* 闪光灯开关 */
    self.flashSwitch = ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setBackgroundImage:[UIImage imageNamed:@"record_light_off"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"record_light_on"] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(flashAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:b];
        b;
    });

    /* 前后摄像头转换开关 */
    self.cameraSwitch = ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setBackgroundImage:[UIImage imageNamed:@"video_turn"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"video_turn"] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(turnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:b];
        b;
    });
    /* 录制按钮 */
    self.recordButton = ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setBackgroundImage:[UIImage imageNamed:@"camera_btn_camera_normal_87x87_"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"camera_btn_camera_normal_87x87_"] forState:UIControlStateHighlighted];
        [b addTarget:self action:@selector(beginRecord) forControlEvents:UIControlEventTouchDown];
        [b addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self.view addSubview:b];
        b;
    });
    /* 提示文字 */
    self.hintLabel = ({
        UILabel *hint = [[UILabel alloc] init];
        hint.textColor = [UIColor whiteColor];
        hint.font = [UIFont systemFontOfSize:16.];
        hint.layer.cornerRadius = 6;
        hint.text = @"轻触拍照，按住摄像";
        hint.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:hint];
        hint;
    });
    /* 水印时间 */
    self.dateLabel = ({
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.font = [UIFont systemFontOfSize:10.];
        dateLabel.layer.cornerRadius = 6;
        dateLabel.text = [[[AppDateUtil GetCurrentDateForString] componentsSeparatedByString:@"."] firstObject];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:dateLabel];
        dateLabel;
    });
    /* 水印天气 */
    self.weatherLabel = ({
        UILabel *weatherLabel = [[UILabel alloc] init];
        weatherLabel.textColor = [UIColor whiteColor];
        weatherLabel.font = [UIFont systemFontOfSize:10.];
        weatherLabel.layer.cornerRadius = 6;
        weatherLabel.text = @"获取中...";
        weatherLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:weatherLabel];
        weatherLabel;
    });
    /* 水印地点 */
    self.locationLabel = ({
        UILabel *locationLabel = [[UILabel alloc] init];
        locationLabel.textColor = [UIColor whiteColor];
        locationLabel.font = [UIFont systemFontOfSize:10.];
        locationLabel.layer.cornerRadius = 6;
        locationLabel.text = @"获取中...";
        locationLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:locationLabel];
        locationLabel;
    });
    /* logo 水印 */
    self.logoImageView = ({
        UIImageView *logo = [[UIImageView alloc] init];
//        logo.hidden = _lzWaterMarkShowStyle != LZWaterMarkShowStylePhotoInfoVideoLogo && _lzWaterMarkShowStyle != LZWaterMarkShowStylePhotoLogoVideoInfo && _lzWaterMarkShowStyle != LZWaterMarkShowStylePhotoLogoVideoLogo && _lzWaterMarkShowStyle != LZWaterMarkShowStylePhotoLogoVideoNone && _lzWaterMarkShowStyle != LZWaterMarkShowStylePhotoNoneVideoLogo;
        [logo setImage:[UIImage imageNamed:@"login_default_avatar"]];
        [self.view addSubview:logo];
        logo;
    });
    /* 发送按钮 */
    self.sendButton = ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.alpha = 0.0;
        [b addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [b setBackgroundImage:[UIImage imageNamed:@"video_ok"] forState:UIControlStateNormal];
        [self.view addSubview:b];
        b;
    });
    /* 取消按钮 */
    self.backButton = ({
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.alpha = 0.0;
        [b setBackgroundImage:[UIImage imageNamed:@"video_back"] forState:UIControlStateNormal];
        [b addTarget:self action:@selector(recaptureAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:b];
        b;
    });
    /* 编辑按钮 */
    self.editButton = ({
        UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
        edit.alpha = 0.0;
        [edit setBackgroundImage:[UIImage imageNamed:@"video_setting"] forState:UIControlStateNormal];
        [edit addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
        edit.hidden = !_isShowEditButton;
        [self.view addSubview:edit];
        edit;
    });
    /* 关闭按钮 */
    self.closeButton = ({
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        [close setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        close.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        [close addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:close];
        close;
    });
    
    self.sliderView = ({
        UISlider *s = [[UISlider alloc] init];
        [s setThumbImage:[UIImage new] forState:UIControlStateNormal];
        s;
    });
    /* 圆环状 */
    self.cycleLayer = ({
        CAShapeLayer *l = [CAShapeLayer layer];
        l.lineWidth = 5.0f;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:kRecordCenter radius:kRecordW / 2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
        l.path = path.CGPath;
        l.fillColor = nil;
        l.strokeColor = [UIColor whiteColor].CGColor;
        l;
    });
    /* 录制视频进度条 */
    self.progressLayer = ({
        CAShapeLayer *l = [CAShapeLayer layer];
        l.lineWidth = 5.0f;
        l.fillColor = nil;
        l.strokeColor = kFaceUColor.CGColor;
        l.lineCap = kCALineCapRound;
        l;
    });
    /* 录制视频中间的绿色圆形 */
    self.ballLayer = ({
        CAShapeLayer *l = [CAShapeLayer layer];
        l.lineWidth = 1.0f;
        l.fillColor = kFaceUColor.CGColor;
        l.strokeColor = kFaceUColor.CGColor;
        l.lineCap = kCALineCapRound;
        l;
    });
    
    switch (_showStyle) {
        case GPUImageShowStyleOnlyPhoto:
            _hintLabel.text = @"请轻触拍照";
            break;
        case GPUImageShowStyleOnlyVideo:
            _hintLabel.text = @"请按住摄像";
            break;
        case GPUImageShowStyleAll:
            _hintLabel.text = @"轻触拍照，按住摄像";
            break;
            
        default:
            break;
    }
//    [self.flashSwitch setHidden:YES];
    self.filterSwitch.selected = YES;
    self.filterSwitch.hidden = YES;
    
    [self.gpuImageStillCamera addTarget:self.gpuImageFilterGroup];
    [self.gpuImageFilterGroup addTarget:self.gpuImageView];
    
    // 初始化视频录制
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[NSURL fileURLWithPath:self.moviePath] size:CGSizeMake(kCameraWidth, kCameraWidth) fileType:AVFileTypeQuickTimeMovie outputSettings:self.videoSettings];
    self.gpuImageStillCamera.audioEncodingTarget = _movieWriter;
    
    [self.gpuImageStillCamera startCameraCapture];
}

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayDidEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}
#pragma mark -- 屏幕的横屏竖屏
- (void)configInitScreenMode {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self configView:orientation];
}

/**
 配置录制过程中的方向
 */
- (void)configVideoOutputOrientation
{
    switch (self.orientationLast) {
        case UIInterfaceOrientationPortrait:
            self.recordOrientation = LZVideoRecordOrientationPortrait;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            self.recordOrientation = LZVideoRecordOrientationPortraitDown;
            break;
        case UIInterfaceOrientationLandscapeRight:
            self.recordOrientation = LZVideoRecordOrientationLandscapeRight;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            self.recordOrientation = LZVideoRecordOrientationLandscapeLeft;
            break;
        default:
            NSLog(@"不支持的录制方向");
            break;
    }
}

- (UIInterfaceOrientation)orientationChange {
    kWeakSelf
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        CMAcceleration acceleration = accelerometerData.acceleration;
        UIInterfaceOrientation orientationNew;
        if (acceleration.x >= 0.75) {
            orientationNew = UIInterfaceOrientationLandscapeLeft;
        }
        else if (acceleration.x <= -0.75) {
            orientationNew = UIInterfaceOrientationLandscapeRight;
        }
        else if (acceleration.y <= -0.75) {
            orientationNew = UIInterfaceOrientationPortrait;
        }
        else if (acceleration.y >= 0.75) {
            orientationNew = UIInterfaceOrientationPortraitUpsideDown;
        }
        else {
            // Consider same as last time
            return;
        }
        
        if (!weakSelf.isCapturing) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (orientationNew == weakSelf.orientationLast)
                    return;
                [weakSelf configView:orientationNew];
                weakSelf.orientationLast = orientationNew;
            });
        }
    }];
    
    return self.orientationLast;
}
#pragma mark - Load View
- (void)configView:(UIInterfaceOrientation)aOrientation {
    switch (aOrientation) {
        case UIInterfaceOrientationLandscapeRight: {
            [self configLandscapeRightUI];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft: {
            [self configLandscapeLeftUI];
        }
            break;
        case UIInterfaceOrientationPortrait: {
            [self configPortraitUI];
        }
            break;
        default: {
            NSLog(@"不支持的方向");
        }
            break;
    }
}

- (void)configPortraitUI {
    if (self.orientationLast == UIInterfaceOrientationLandscapeLeft) {
        self.flashSwitch.transform = CGAffineTransformRotate(self.flashSwitch.transform, M_PI_2);
        self.cameraSwitch.transform = CGAffineTransformRotate(self.cameraSwitch.transform, M_PI_2);
    } else if (self.orientationLast == UIInterfaceOrientationLandscapeRight) {
        self.flashSwitch.transform = CGAffineTransformRotate(self.flashSwitch.transform, -M_PI_2);
        self.cameraSwitch.transform = CGAffineTransformRotate(self.cameraSwitch.transform, -M_PI_2);
    }
}

- (void)configLandscapeRightUI {
    if (self.orientationLast == UIInterfaceOrientationPortrait || self.orientationLast == UIInterfaceOrientationUnknown) {
        self.flashSwitch.transform = CGAffineTransformRotate(self.flashSwitch.transform, M_PI_2);
        self.cameraSwitch.transform = CGAffineTransformRotate(self.cameraSwitch.transform, M_PI_2);
    } else if (self.orientationLast == UIInterfaceOrientationLandscapeLeft) {
        self.flashSwitch.transform = CGAffineTransformRotate(self.flashSwitch.transform, -M_PI);
        self.cameraSwitch.transform = CGAffineTransformRotate(self.cameraSwitch.transform, -M_PI);
    }
}

- (void)configLandscapeLeftUI {
    if (self.orientationLast == UIInterfaceOrientationLandscapeRight) {
        self.flashSwitch.transform = CGAffineTransformRotate(self.flashSwitch.transform, -M_PI);
        self.cameraSwitch.transform = CGAffineTransformRotate(self.cameraSwitch.transform, -M_PI);
        
    } else if (self.orientationLast == UIInterfaceOrientationPortrait || self.orientationLast == UIInterfaceOrientationUnknown) {
        self.flashSwitch.transform = CGAffineTransformRotate(self.flashSwitch.transform, -M_PI_2);
        self.cameraSwitch.transform = CGAffineTransformRotate(self.cameraSwitch.transform, -M_PI_2);
    }
}

/**
 控件的布局
 */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.gpuImageView.frame = self.view.bounds;
    
    switch (_recordOrientation) {
        case LZVideoRecordOrientationPortrait:
        case LZVideoRecordOrientationPortraitDown:
            self.imageView.frame = self.view.bounds;
            break;
        case LZVideoRecordOrientationLandscapeLeft:
        case LZVideoRecordOrientationLandscapeRight:
            self.imageView.frame = CGRectMake(0,
                                              (LZ_SCREEN_HEIGHT-LZ_SCREEN_WIDTH*LZ_SCREEN_WIDTH/LZ_SCREEN_HEIGHT)/2,
                                              LZ_SCREEN_WIDTH,
                                              LZ_SCREEN_WIDTH*LZ_SCREEN_WIDTH/LZ_SCREEN_HEIGHT);
            break;
        default:
            break;
    }
    /* 摄像头转换按钮 */
    self.cameraSwitch.frame = CGRectMake(self.view.frame.size.width - kMARSwitchW*2 - kMARGap, 10, 72, 72);
    /* 闪光灯转换 */
    self.flashSwitch.frame = CGRectMake(CGRectGetMinX(self.cameraSwitch.frame) - kMARSwitchW , 30, kMARSwitchW, kMARSwitchW);
//    self.flashSwitch.frame = CGRectMake(CGRectGetMinX(self.filterSwitch.frame) - kMARSwitchW - kMARGap, 30, kMARSwitchW, kMARSwitchW);
    /* 录制按钮 */
    self.recordButton.bounds = CGRectMake(0, 0, kRecordW, kRecordW);
    self.recordButton.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 70);
    self.hintLabel.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 140);
    self.hintLabel.bounds = CGRectMake(0, 50, 150, 30);
    /* 关闭按钮 */
    self.closeButton.center = CGPointMake((self.view.frame.size.width - kRecordW) / 4, self.recordButton.center.y);
    self.closeButton.bounds = CGRectMake(0, 0, 60, 60);
    
    /* 发送、返回按钮 */
    self.sendButton.center = CGPointMake(self.view.frame.size.width - 80, self.view.frame.size.height - 70);
    self.sendButton.bounds = CGRectMake(0, 0, 72, 72);
    self.backButton.center = CGPointMake(80, self.sendButton.center.y);
    self.backButton.bounds = CGRectMake(0, 0, 72, 72);
    self.editButton.center = CGPointMake(self.view.frame.size.width / 2, self.sendButton.center.y);
    self.editButton.bounds = CGRectMake(0, 0, 72, 72);
    
    // 水印的位置
    [self setWaterMarkFrame];
    CGSize logoImageSize = self.logoImageView.image.size;
    self.logoImageView.frame = CGRectMake(LZ_SCREEN_WIDTH-10-logoImageSize.width*0.5f,
                                          LZ_SCREEN_HEIGHT-10-logoImageSize.height*0.5f,
                                          logoImageSize.width*0.5f,
                                          logoImageSize.height*0.5f);
    
}
// 设置水印的位置
- (void)setWaterMarkFrame {
    UIFont *font = [UIFont systemFontOfSize:10.0];
    CGSize dateSize = [_dateLabel.text sizeWithMaxSize:CGSizeMake(300, 30) font:font];
    CGSize weatherSize = [_weatherLabel.text sizeWithMaxSize:CGSizeMake(100, 30) font:font];
    CGSize locationSize = [_locationLabel.text sizeWithMaxSize:CGSizeMake(500, 30) font:font];
    
    self.dateLabel.frame = CGRectMake(10, LZ_SCREEN_HEIGHT-35, dateSize.width+5, dateSize.height);
    self.weatherLabel.frame = CGRectMake(10, LZ_SCREEN_HEIGHT - 20.0, weatherSize.width, weatherSize.height);
    self.locationLabel.frame = CGRectMake(10+weatherSize.width, LZ_SCREEN_HEIGHT - 20.0, locationSize.width, locationSize.height);
}

#pragma mark - Logic Method

- (void)beginRecord {
    
    _isCapturing = YES;
    
    [self configVideoOutputOrientation];
    unlink([self.moviePath UTF8String]);
    
    [self.view.layer addSublayer:self.cycleLayer];
    [self.view.layer addSublayer:self.progressLayer];
    [self.view.layer addSublayer:self.ballLayer];
    
    switch (_showStyle) {
        case GPUImageShowStyleOnlyPhoto:
            self.recordButton.hidden = NO;
            self.cycleLayer.hidden = YES;
            self.progressLayer.hidden = YES;
            self.ballLayer.hidden = YES;
            break;
        case GPUImageShowStyleOnlyVideo:
            self.recordButton.hidden = YES;
            break;
        case GPUImageShowStyleAll:
            
            break;
            
        default:
            break;
    }
    
    [self hideAllFunctionButton];
    
    [(self.filterSwitch.selected ? self.gpuImageFilterGroup : self.gpuImageFilterGroup) addTarget:self.movieWriter];
    /* 设置录制时的方向 */
    switch (_recordOrientation) {
        case LZVideoRecordOrientationPortrait:
            [self.movieWriter startRecording];
            break;
        case LZVideoRecordOrientationLandscapeLeft:
            [self.movieWriter startRecordingInOrientation:CGAffineTransformMakeRotation(M_PI_2)];
            break;
        case LZVideoRecordOrientationLandscapeRight:
            [self.movieWriter startRecordingInOrientation:CGAffineTransformMakeRotation(-M_PI_2)];
            break;
        case LZVideoRecordOrientationPortraitDown:
            [self.movieWriter startRecordingInOrientation:CGAffineTransformMakeRotation(M_PI)];
            break;
        default:
            break;
    }
    /* 时间的增加 */
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerupdating)];
    _timer.frameInterval = 3;
    [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _allTime = 0;
}


- (void)endRecord {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [(self.filterSwitch.selected ? self.gpuImageFilterGroup : self.gpuImageFilterGroup) removeTarget:self.movieWriter];
        
        if (_allTime < 0.5) {
            // 储存到图片库,并且设置回调.
            [self.movieWriter finishRecording];
            
            if (_showStyle == GPUImageShowStyleOnlyVideo) {
                [self createNewWritter];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.hidden = NO;
                });
                [self recaptureAction];
            } else {
                UIImageOrientation imageOrientation = UIImageOrientationUp;
                switch (_recordOrientation) {
                    case LZVideoRecordOrientationPortrait:
                        break;
                    case LZVideoRecordOrientationLandscapeLeft:
                        imageOrientation = UIImageOrientationRight;
                        break;
                    case LZVideoRecordOrientationLandscapeRight:
                        imageOrientation = UIImageOrientationLeft;
                        break;
                    case LZVideoRecordOrientationPortraitDown:
                        imageOrientation = UIImageOrientationDown;
                        break;
                    default:
                        break;
                }
                
                kWeakSelf
                [self.gpuImageStillCamera capturePhotoAsImageProcessedUpToFilter:self.gpuImageFilterGroup withOrientation:imageOrientation withCompletionHandler:^(UIImage *processedImage, NSError *error) {
                    //                UIImageOrientation imageOrientation = processedImage.imageOrientation;
                    if(imageOrientation != UIImageOrientationUp) {
                        //以下为调整图片角度的部分
                        UIGraphicsBeginImageContext(processedImage.size);
                        [processedImage drawInRect:CGRectMake(0, 0, processedImage.size.width, processedImage.size.height)];
                        processedImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                    } else {
                        /* 清空控件的旋转方向 */
                        //                    self.imageView.transform = CGAffineTransformIdentity;
                        //                    switch (_recordOrientation) {
                        //                        case LZVideoRecordOrientationPortrait:
                        //                            break;
                        //                        case LZVideoRecordOrientationLandscapeLeft:
                        //                            self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI_2);
                        //                            break;
                        //                        case LZVideoRecordOrientationLandscapeRight:
                        //                            self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, -M_PI_2);
                        //                            break;
                        //                        case LZVideoRecordOrientationPortraitDown:
                        //                            self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
                        //                            break;
                        //                        default:
                        //                            break;
                        //                    }
                    }
                    switch (_lzWaterMarkShowStyle) {
                            // 图片什么水印都不要
                        case LZWaterMarkShowStylePhotoNone:
                            break;
                        case LZWaterMarkShowStylePhotoInfo:
                            processedImage = [weakSelf setLeftWaterMarkForImage:processedImage];
                            break;
                        case LZWaterMarkShowStylePhotoLogoAndInfo:{
                            processedImage = [weakSelf setLeftWaterMarkForImage:processedImage];
                            processedImage = [UIImage addWatemarkImageWithLogoImage:processedImage translucentWatemarkImage:[UIImage imageNamed:@"login_default_avatar"]];
                        }
                            break;
                            
                        default:
                            break;
                    }
                    _tempImg = processedImage;
                    [weakSelf createNewWritter];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.imageView setImage:processedImage];
                        weakSelf.imageView.hidden = NO;
                        weakSelf.gpuImageView.alpha = 0;
                    });
                }];
            }
        }else {
            // 储存到视频库,并且设置回调.
            kWeakSelf
            [self.movieWriter finishRecordingWithCompletionHandler:^{
                [weakSelf createNewWritter];
                
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf _addwater];
//                    [weakSelf AVsaveVideoPath:[NSURL fileURLWithPath:self.moviePath] WithWaterImg:[UIImage imageNamed:@"start_logo"] WithCoverImage:[UIImage imageNamed:@"start_logo"] WithQustion:@"文字水印：hudongdongBlog" WithFileName:nil];
                    _avplayer = [AVPlayerLayer playerLayerWithPlayer:[AVPlayer playerWithURL:[NSURL fileURLWithPath:weakSelf.moviePath]]];
                    _avplayer.frame = weakSelf.view.bounds;
                    
                    [weakSelf.view.layer insertSublayer:_avplayer above:weakSelf.gpuImageView.layer];
                    weakSelf.gpuImageView.alpha = 0;
                    [_avplayer.player play];
                    if (_showStyle == GPUImageShowStyleOnlyPhoto) {
                        [weakSelf recaptureAction];
                    }
                });
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSThread sleepForTimeInterval:0.7];
            _isCapturing = NO;
            if (!_timer) {
                return;
            }
            
            [_timer invalidate];
            _timer = nil;
            
            [self.cycleLayer removeFromSuperlayer];
            [self.progressLayer removeFromSuperlayer];
            [self.ballLayer removeFromSuperlayer];
            
            //    [self showAllFunctionButton];
            
            self.recordButton.alpha = 0;
            self.recordButton.frame = self.sendButton.frame;
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                
                switch (_showStyle) {
                    case GPUImageShowStyleOnlyPhoto:
                        if (_allTime < 0.5) {
                            //                    self.recordButton.alpha = 0;
                            self.editButton.alpha = 1.0;
                            self.closeButton.alpha = 0;
                            self.dateLabel.alpha = 0;
                            self.weatherLabel.alpha = 0;
                            self.locationLabel.alpha = 0;
                            self.logoImageView.alpha = 0;
                            self.backButton.alpha = 1.0;
                            self.sendButton.alpha = 1.0;
                        }
                        break;
                    case GPUImageShowStyleOnlyVideo:
                        if (_allTime > 0.5) {
                            //                    self.recordButton.alpha = 0;
                            self.closeButton.alpha = 0;
                            self.dateLabel.alpha = 0;
                            self.weatherLabel.alpha = 0;
                            self.locationLabel.alpha = 0;
                            self.logoImageView.alpha = 0;
                            self.backButton.alpha = 1.0;
                            self.sendButton.alpha = 1.0;
                        }
                        break;
                    case GPUImageShowStyleAll:
                        if (_allTime < 0.5) {
                            self.editButton.alpha = 1.0;
                        }
                        self.closeButton.alpha = 0;
                        self.dateLabel.alpha = 0;
                        self.weatherLabel.alpha = 0;
                        self.locationLabel.alpha = 0;
                        self.logoImageView.alpha = 0;
                        self.backButton.alpha = 1.0;
                        self.sendButton.alpha = 1.0;
                        break;
                        
                    default:
                        break;
                }
            } completion:^(BOOL finished) {
                
            }];
        });
    });
}

- (void)timerupdating {
    _allTime += 0.05;
    [self updateProgress:_allTime / (_limitTime > 0 ? _limitTime : kLimitRecLen)];
    
}

- (void)timerDateUpdating {
//    _dateLabel.text = [[[AppDateUtil GetCurrentDateForString] componentsSeparatedByString:@"."] firstObject];
}

- (void)createNewWritter {
    
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[NSURL fileURLWithPath:self.moviePath] size:CGSizeMake(kCameraWidth, kCameraWidth) fileType:AVFileTypeQuickTimeMovie outputSettings:self.videoSettings];
    /// 如果不加上这一句，会出现第一帧闪现黑屏
    [_gpuImageStillCamera addAudioInputsAndOutputs];
    _gpuImageStillCamera.audioEncodingTarget = _movieWriter;
}


- (void)hideAllFunctionButton {

//    self.recordButton.hidden = YES;
    /* 隐藏三个图标 */
    kWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.filterSwitch.alpha = 0;
        weakSelf.cameraSwitch.alpha = 0;
        weakSelf.flashSwitch.alpha = 0;
    }];
}

- (void)showAllFunctionButton {
    
//    self.recordButton.hidden = NO;
    kWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.filterSwitch.alpha = 1.0;
        weakSelf.cameraSwitch.alpha = 1.0;
        weakSelf.flashSwitch.alpha = 1.0;
    }];
}

#pragma mark - AnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self performSelector:@selector(focusLayerNormal) withObject:self afterDelay:1.0f];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    if (_avplayer) {
        [_avplayer.player pause];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (_avplayer) {
        [_avplayer.player play];
    }
}

- (UIImage *)setLeftWaterMarkForImage:(UIImage *)image {
    // 给照片添加水印
    // 得到当前时间
    NSString *dateStr = [AppDateUtil GetCurrentDateForString];
    dateStr = [[dateStr componentsSeparatedByString:@"."] firstObject];
    return image = [UIImage addWatemarkTextAfteriOS7_WithLogoImage:image
                                              watemarkTextDate:dateStr
                                           watemarkTextWeather:weatherType
                                          watemarkTextLocation:address];
}

#pragma mark - User Action

- (void)saveAction {
    /* 拍照图片 */
    if (_tempImg) {
        
//        UIImageWriteToSavedPhotosAlbum(_tempImg, self, nil, nil);
        NSString *imagePath = RMDefaultImagePath;
        /* 压缩图片 */
        [UIImageJPEGRepresentation(_tempImg, 0.8) writeToFile:imagePath atomically:YES];// 将图片写入文件
        if ([self.delegate respondsToSelector:@selector(finishAliPhotoImage:)]) {
            [self.delegate finishAliPhotoImage:imagePath];
        }
    } else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UISaveVideoAtPathToSavedPhotosAlbum(RMDefaultVideoPath, self, nil, nil);
//        });
//        [self saveVedioPath:[NSURL fileURLWithPath:RMDefaultVideoPath]
//               WithWaterImg:[UIImage imageNamed:@"start_logo"]
//             WithCoverImage:[UIImage imageNamed:@"start_logo"]
//                WithQustion:@"郭健豪"
//               WithFileName:RMDefaultVideoPath];
        
        if ([self.delegate respondsToSelector:@selector(finishAliPlayShortVideo:)]) {
            [self.delegate finishAliPlayShortVideo:self.moviePath];
        }
    }
//    [self recaptureAction];
    [self closeButtonAction];
}

- (void)recaptureAction {
    
    [_avplayer.player pause];
    [_avplayer removeFromSuperlayer];
    _avplayer = nil;
    _tempImg = nil;
    self.imageView.hidden = YES;
    self.recordButton.hidden = NO;
    self.recordButton.bounds = CGRectMake(0, 0, kRecordW, kRecordW);
    self.recordButton.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 70);
    self.recordButton.alpha = 1.0;
    self.sendButton.alpha = 0.0;
    self.backButton.alpha = 0.0;
    self.editButton.alpha = 0.0;
    self.closeButton.alpha = 1.0;
    self.dateLabel.alpha = 1.0;
    self.weatherLabel.alpha = 1.0;
    self.locationLabel.alpha = 1.0;
    self.logoImageView.alpha = 1.0;
    self.gpuImageView.alpha = 1.0;
    /* 重新返回录制节目的时候显示各个控件 */
    [self showAllFunctionButton];
    /* 加上水印后取消再拍摄会崩溃的问题处理 */
//    _movieWriter = nil;
    [self createNewWritter];
}

/* 编辑按钮的点击事件 */
- (void)editButtonAction {
    if (_tempImg) {
        
        //        UIImageWriteToSavedPhotosAlbum(_tempImg, self, nil, nil);
        NSString *imagePath = RMDefaultImagePath;
       
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:_tempImg];
         NSString *fileShowName = [NSString stringWithFormat:@"IMG_%@.JPG", [[LZFormat FormatNow2String] substringWithRange:NSMakeRange(10, 4)]];
        //editor.delegate = self;
        editor.fileName = fileShowName;
        kWeakSelf
        [editor setDidFinishImageEditBlock:^(UIImage *editFinsihImage, NSString *fileshowName,UIViewController *viewController) {
            
            [UIImageJPEGRepresentation(editFinsihImage, 0.8) writeToFile:imagePath atomically:YES];// 将图片写入文件
           
            if ([weakSelf.delegate respondsToSelector:@selector(finishAliPhotoImage:)]) {
                [weakSelf.delegate finishAliPhotoImage:imagePath];
            }
            [viewController dismissViewControllerAnimated:NO completion:nil];
            [_avplayer.player pause];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        XHBaseNavigationController *navController=[[XHBaseNavigationController alloc]initWithRootViewController:editor];
       // [self.navigationController pushViewController:editor animated:NO];
        [self presentViewController:navController animated:YES completion:nil];
        
    }
    
}

- (void)closeButtonAction {
    [_avplayer.player pause];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)turnAction:(id)sender {
    
    [self.gpuImageStillCamera pauseCameraCapture];
    
    if (self.gpuImageStillCamera.cameraPosition == AVCaptureDevicePositionBack) {
        self.flashSwitch.hidden = YES;
//        self.filterSwitch.selected = NO;
    }else {
        self.flashSwitch.hidden = NO;
//        self.filterSwitch.selected = YES;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.gpuImageStillCamera rotateCamera];
        [self.gpuImageStillCamera resumeCameraCapture];
    });
    
    [self performSelector:@selector(animationCamera) withObject:self afterDelay:0.2f];
}

- (void)flashAction:(id)sender {
    
    if (self.flashSwitch.selected) {
        self.flashSwitch.selected = NO;
        if ([self.gpuImageStillCamera.inputCamera lockForConfiguration:nil]) {
            [self.gpuImageStillCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
            [self.gpuImageStillCamera.inputCamera setFlashMode:AVCaptureFlashModeOff];
            [self.gpuImageStillCamera.inputCamera unlockForConfiguration];
        }
    }else {
        self.flashSwitch.selected = YES;
        if ([self.gpuImageStillCamera.inputCamera lockForConfiguration:nil]) {
            [self.gpuImageStillCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
            [self.gpuImageStillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
            [self.gpuImageStillCamera.inputCamera unlockForConfiguration];
        }
    }
}

- (void)focusTap:(UITapGestureRecognizer *)tap {
    
    self.gpuImageView.userInteractionEnabled = NO;
    CGPoint touchPoint = [tap locationInView:tap.view];
    [self layerAnimationWithPoint:touchPoint];
    touchPoint = CGPointMake(touchPoint.x / tap.view.bounds.size.width, touchPoint.y / tap.view.bounds.size.height);
    
    if ([self.gpuImageStillCamera.inputCamera isFocusPointOfInterestSupported] && [self.gpuImageStillCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([self.gpuImageStillCamera.inputCamera lockForConfiguration:&error]) {
            [self.gpuImageStillCamera.inputCamera setFocusPointOfInterest:touchPoint];
            [self.gpuImageStillCamera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
            
            if([self.gpuImageStillCamera.inputCamera isExposurePointOfInterestSupported] && [self.gpuImageStillCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [self.gpuImageStillCamera.inputCamera setExposurePointOfInterest:touchPoint];
                [self.gpuImageStillCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            
            [self.gpuImageStillCamera.inputCamera unlockForConfiguration];
            
        } else {
            NSLog(@"ERROR = %@", error);
        }
    }
}

#pragma mark - Notification Action 

- (void)moviePlayDidEnd:(NSNotification *)notification {
    [_avplayer.player seekToTime:kCMTimeZero];
    [_avplayer.player play];
}

#pragma mark - Animation

- (void)animationCamera {
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    [self.gpuImageView.layer addAnimation:animation forKey:nil];
}

- (void)updateProgress:(CGFloat)value {
//    NSAssert(value <= 1.0 && value >= 0.0, @"Progress could't accept invail number .");
    if (value > 1.0) {
        [self endRecord];
    }else {
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:kRecordCenter radius:kRecordW / 2 startAngle:- M_PI_2 endAngle:2 * M_PI * (value) - M_PI_2 clockwise:YES];
        if (value - 0.1 <= CGFLOAT_MIN) {
            CGFloat val = value / 0.1;
            UIBezierPath *ballpath = [UIBezierPath bezierPathWithArcCenter:kRecordCenter radius:(kRecordW / 2  - 10) *val startAngle:0 endAngle:2 * M_PI clockwise:YES];
            self.ballLayer.path = ballpath.CGPath;
        }
        self.progressLayer.path = path.CGPath;
    }
}

- (void)focusLayerNormal {
    self.gpuImageView.userInteractionEnabled = YES;
    _focusLayer.hidden = YES;
}

- (void)layerAnimationWithPoint:(CGPoint)point {
    if (_focusLayer) {
        CALayer *focusLayer = _focusLayer;
        focusLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [focusLayer setPosition:point];
        focusLayer.transform = CATransform3DMakeScale(2.0f,2.0f,1.0f);
        [CATransaction commit];
        
        CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
        animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0f,1.0f,1.0f)];
        animation.delegate = self;
        animation.duration = 0.3f;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [focusLayer addAnimation: animation forKey:@"animation"];
    }
}

#pragma mark - Property

- (GPUImageStillCamera *)gpuImageStillCamera {
    if (!_gpuImageStillCamera) {
        _gpuImageStillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
        _gpuImageStillCamera.outputImageOrientation = UIInterfaceOrientationPortrait; // 镜头的方向
        _gpuImageStillCamera.horizontallyMirrorFrontFacingCamera = YES;
    }
    return _gpuImageStillCamera;
}

- (GPUImageFilterGroup *)gpuImageFilterGroup {
    if (!_gpuImageFilterGroup) {
        GPUImageFilter *filter = [[GPUImageFilter alloc] init]; //默认
        _gpuImageFilterGroup = [[GPUImageFilterGroup alloc] init];
        [(GPUImageFilterGroup *) _gpuImageFilterGroup setInitialFilters:[NSArray arrayWithObject: filter]];
        [(GPUImageFilterGroup *) _gpuImageFilterGroup setTerminalFilter:filter];
    }
    return _gpuImageFilterGroup;
}

- (CALayer *)focusLayer {
    if (!_focusLayer) {
        UIImage *focusImage = [UIImage imageNamed:@"touch_focus_x"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, focusImage.size.width, focusImage.size.height)];
        imageView.image = focusImage;
        _focusLayer = imageView.layer;
        _focusLayer.hidden = YES;
    }
    return _focusLayer;
}

- (NSString *)moviePath {
    if (!_moviePath) {
        _moviePath = RMDefaultVideoPath;
        NSLog(@"maru: %@",_moviePath);
    }
    return _moviePath;
}

- (NSDictionary *)audioSettings {
    if (!_audioSettings) {
        // 音频设置
        AudioChannelLayout channelLayout;
        memset(&channelLayout, 0, sizeof(AudioChannelLayout));
        channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
        _audioSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                          [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                          [ NSNumber numberWithInt: 2 ], AVNumberOfChannelsKey,
                          [ NSNumber numberWithFloat: 16000.0 ], AVSampleRateKey,
                          [ NSData dataWithBytes:&channelLayout length: sizeof( AudioChannelLayout ) ], AVChannelLayoutKey,
                          [ NSNumber numberWithInt: 32000 ], AVEncoderBitRateKey,
                          nil];
    }
    return _audioSettings;
}

- (NSMutableDictionary *)videoSettings {
    if (!_videoSettings) {
        _videoSettings = [[NSMutableDictionary alloc] init];
        [_videoSettings setObject:AVVideoCodecH264 forKey:AVVideoCodecKey];
        [_videoSettings setObject:[NSNumber numberWithInteger:kCameraWidth] forKey:AVVideoWidthKey];
        [_videoSettings setObject:[NSNumber numberWithInteger:kCameraHeight] forKey:AVVideoHeightKey];
    }
    return _videoSettings;
}

- (CABasicAnimation *)scaleAnimation {
    if (!_scaleAnimation) {
        _scaleAnimation = [CABasicAnimation animation];
        _scaleAnimation.repeatCount = HUGE_VALF;
        _scaleAnimation.duration = 0.8;
        _scaleAnimation.keyPath = @"transform.scale";
        _scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        _scaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
        _scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeOut"];
    }
    return _scaleAnimation;
}

/**
 五秒之后隐藏
 */
- (void)hiddenHintLabel {
    [UIView animateWithDuration:0.5 animations:^{
        self.hintLabel.alpha = 0.0;
    }];
}
- (CMMotionManager *)motionManager {
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 1./15.;
    }
    return _motionManager;
}
#pragma mark alertDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            if(buttonIndex==0&&alertView.tag==1){
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            NSLog(@"取消");
            break;
        default:
            break;
    }
    
}
#pragma mark - 定位的代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // 设备的当前位置
    CLLocation *currLocation = [locations lastObject];
    
    [_locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:currLocation
                   completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *place in placemarks) {
            NSDictionary *location = [place addressDictionary];
            NSString *city = [location objectForKey:@"City"];
            NSString *subLocality = [location objectForKey:@"SubLocality"];
            NSString *street = [location objectForKey:@"Street"];
            if (city == nil) {
                city = @"";
            }if (subLocality == nil) {
                subLocality = @"";
            }if (street == nil) {
                street = @"";
            }
            address = [NSString stringWithFormat:@"┃%@%@%@",city,subLocality,street];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.locationLabel.text = address;
                [self setWaterMarkFrame];
            });
            if (self.locationNumber == 0) {
                //进行天气网络请求
                self.locationNumber += 1;
                [self dicWithUrl:city subLocality:subLocality];
            }
        }
    }];
}

- (void)dicWithUrl:(NSString *)city subLocality:(NSString *)subLocality{
    // 心知天气接口
    NSString *urlStr = [self fetchWeatherWithURL:TIANQI_NOW_WEATHER_URL ttl:@30 Location:@"ip" language:@"zh-Hans" unit:@"c" start:@"1" days:@"1"];
    kWeakSelf
    [NetRequest GET:urlStr parameters:nil success:^(id responseObject) {
        NSArray *responseArray = [responseObject lzNSArrayForKey:@"results"];
        if (responseArray.count != 0 && responseArray != nil) {
            NSDictionary *responseDic = [responseArray firstObject];
            NSDictionary *now = [responseDic lzNSDictonaryForKey:@"now"];
            weatherType = [now lzNSStringForKey:@"text"]; //天气
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.weatherLabel.text = weatherType;
                [weakSelf setWaterMarkFrame];
            });
        } else {
            NSString *urlStr = [self fetchWeatherWithURL:TIANQI_NOW_WEATHER_URL ttl:@30 Location:city language:@"zh-Hans" unit:@"c" start:@"1" days:@"1"];
            [NetRequest GET:urlStr parameters:nil success:^(id responseObject) {
                NSArray *responseArray = [responseObject lzNSArrayForKey:@"results"];
                if (responseArray.count != 0 && responseArray != nil) {
                    NSDictionary *responseDic = [responseArray firstObject];
                    NSDictionary *now = [responseDic lzNSDictonaryForKey:@"now"];
                    weatherType = [now lzNSStringForKey:@"text"]; //天气
                } else {
                    weatherType = @"天气获取失败...";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.weatherLabel.text = weatherType;
                    [weakSelf setWaterMarkFrame];
                });
            } failure:^(NSError *error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"天气获取失败" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:a];
                [weakSelf presentViewController:alert animated:true completion:nil];
            }];
        }
    } failure:^(NSError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"天气获取失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:a];
        [weakSelf presentViewController:alert animated:true completion:nil];
    }];
}
/**
 配置带请求参数的 url 地址。
 
 @param url 需要请求的 url 地址。 例如：获取指定城市的天气实况 url 为 TIANQI_NOW_WEATHER_URL
 @param ttl 签名失效时间(可选)，默认有效期为 1800 秒（30分钟）
 @param location 所查询的位置
 @param language 语言(可选)。 默认值：zh-Hans
 @param unit 单位 (可选)。默认值：c
 @param start 起始时间 (可选)。默认值：0
 @param days 天数 (可选)。 默认为你的权限允许的最多天数
 @return return 带请求参数的 url 地址
 */
- (NSString *)fetchWeatherWithURL:(NSString *)url ttl:(NSNumber *)ttl Location:(NSString *)location
                         language:(NSString *)language unit:(NSString *)unit
                            start:(NSString *)start days:(NSString *)days{
    NSString *timestamp = [NSString stringWithFormat:@"%.0ld",time(NULL)];
    NSString *params = [NSString stringWithFormat:@"ts=%@&ttl=%@&uid=%@", timestamp, ttl, TIANQI_API_USER_ID];
    NSString *signature =  [self getSigntureWithParams:params];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@&sig=%@&location=%@&language=%@&unit=%@&start=%@&days=%@",
                        url, params, signature, location, language, unit, start, days];
    return urlStr;
}

/**
 获得签名字符串，关于如何使用签名验证方式，详情见 https://www.seniverse.com/doc#sign
 
 @param params 验证参数字符串
 @return signature HMAC-SHA1 加密后得到的签名字符串
 */
- (NSString *)getSigntureWithParams:(NSString *)params {
    NSString *signature = [HmacSha1Tool HmacSha1Key:TIANQI_API_SECRET_KEY data:params];
    return signature;
}

#pragma mark - 视频添加水印

///使用AVfoundation添加水印
- (void)AVsaveVideoPath:(NSURL*)videoPath WithWaterImg:(UIImage*)img WithCoverImage:(UIImage*)coverImg WithQustion:(NSString*)question WithFileName:(NSString*)fileName {
    if (!videoPath) {
        return;
    }

    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
    _videoAsset = [AVAsset assetWithURL:videoPath];
    //2 创建AVMutableComposition实例. apple developer 里边的解释 【AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.】
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];

    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, _videoAsset.duration)
                        ofTrack:[[_videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject]
                         atTime:kCMTimeZero
                          error:nil];

    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, _videoAsset.duration);

    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[_videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
//    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
//        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
//        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
//        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
//        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:_videoAsset.duration];

    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];

    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }

    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    NSString *dateStr = [AppDateUtil GetCurrentDateForString];
    dateStr = [[dateStr componentsSeparatedByString:@"."] firstObject];
    [self applyVideoEffectsToComposition:mainCompositionInst
                            WithWaterImg:img
                                WithDate:dateStr
                             WithWeather:weatherType
                            withLocation:address
                                    size:naturalSize];

    // 4 - 输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo-%d.mp4",arc4random() % 1000]];
    self.moviePath = myPathDocs;

    // 5 - 视频文件输出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=[NSURL fileURLWithPath:myPathDocs];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            [self exportDidFinish:exporter];
        });
    }];
}

- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition WithWaterImg:(UIImage*)img WithDate:(NSString *)date WithWeather:(NSString*)weather withLocation:(NSString *)location size:(CGSize)size {

    UIFont *font = [UIFont systemFontOfSize:15.0];
    // 时间
    CATextLayer *dateStr = [[CATextLayer alloc] init];
    [dateStr setFontSize:15.0];
    [dateStr setString:date];
    [dateStr setAlignmentMode:kCAAlignmentCenter];
    [dateStr setForegroundColor:[[UIColor whiteColor] CGColor]];
//    [dateStr setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor];
    CGSize datetextSize = [date sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, nil]];
    [dateStr setFrame:CGRectMake(13, img.size.height*0.55f, datetextSize.width, datetextSize.height)];
    
    // 天气
    CATextLayer *weatherStr = [[CATextLayer alloc] init];
    [weatherStr setFontSize:15.0];
    [weatherStr setString:weather];
    [weatherStr setAlignmentMode:kCAAlignmentCenter];
    [weatherStr setForegroundColor:[[UIColor whiteColor] CGColor]];
//    [weatherStr setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor];
    CGSize weathertextSize = [weather sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, nil]];
    [weatherStr setFrame:CGRectMake(13, img.size.height*0.25f, weathertextSize.width, weathertextSize.height)];
    
    // 地址
    CATextLayer *locationStr = [[CATextLayer alloc] init];
    [locationStr setFontSize:15.0];
    [locationStr setString:location];
    [locationStr setAlignmentMode:kCAAlignmentCenter];
    [locationStr setForegroundColor:[[UIColor whiteColor] CGColor]];
//    [locationStr setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor];
    CGSize locationtextSize = [location sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, nil]];
    [locationStr setFrame:CGRectMake(13+weatherStr.bounds.size.width, img.size.height*0.25f, locationtextSize.width, locationtextSize.height)];
    
    //logo水印
    CALayer *imgLayer = [CALayer layer];
    imgLayer.contents = (id)img.CGImage;
//    imgLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    imgLayer.bounds = CGRectMake(0, 0, img.size.width*0.7, img.size.height*0.7);
    imgLayer.position = CGPointMake(size.width - img.size.width*0.4f, img.size.height*0.6f);
    //第二个水印
//    CALayer *coverImgLayer = [CALayer layer];
//    coverImgLayer.contents = (id)coverImg.CGImage;
//    [coverImgLayer setContentsGravity:@"resizeAspect"];
//    coverImgLayer.bounds =  CGRectMake(50, 200, 210, 50);
//    coverImgLayer.position = CGPointMake(size.width/4.0, size.height/4.0);

    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:dateStr];
    [overlayLayer addSublayer:weatherStr];
    [overlayLayer addSublayer:locationStr];
    [overlayLayer addSublayer:imgLayer];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];

    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
//    [parentLayer addSublayer:coverImgLayer];

    //设置封面
//    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    anima.fromValue = [NSNumber numberWithFloat:1.0f];
//    anima.toValue = [NSNumber numberWithFloat:0.0f];
//    anima.repeatCount = 0;
//    anima.duration = 5.0f;  //5s之后消失
//    [anima setRemovedOnCompletion:NO];
//    [anima setFillMode:kCAFillModeForwards];
//    anima.beginTime = AVCoreAnimationBeginTimeAtZero;
//    [coverImgLayer addAnimation:anima forKey:@"opacityAniamtion"];

    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer
                                 inLayer:parentLayer];

}

- (void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        _avplayer = [AVPlayerLayer playerLayerWithPlayer:[AVPlayer playerWithURL:[NSURL fileURLWithPath:self.moviePath]]];
        _avplayer.frame = self.view.bounds;
        
        [self.view.layer insertSublayer:_avplayer above:self.gpuImageView.layer];
        self.gpuImageView.alpha = 0;
        [_avplayer.player play];

//        NSURL *outputURL = session.outputURL;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            __block PHObjectPlaceholder *placeholder;
//            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputURL.path)) {
//                NSError *error;
//                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//                    PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputURL];
//                    placeholder = [createAssetRequest placeholderForCreatedAsset];
//                } error:&error];
//                if (error) {
//
//                }
//                else{
//
//                }
//            }else {
//
//            }
//        });
    }
}
@end
