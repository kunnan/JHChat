//
//  JHBaseViewController.m
//  JHChat
//
//  Created by gjh on 2018/11/5.
//  Copyright © 2018 gjh. All rights reserved.
//

#import "JHBaseViewController.h"
#import "YYFPSLabel.h"

@interface JHBaseViewController ()<MBProgressHUDDelegate>{
    /* 测试FPS */
    YYFPSLabel *fpsLabel;
    CGFloat curRatio;
}

@end

@implementation JHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    curRatio = [[CommonFontModel shareInstance] getHandeHeightRatio];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithUTF8String:object_getClassName(self)] forKey:@"CUR_CLASS_NAME"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if(self.navigationController.viewControllers.count>=2){
        self.view.backgroundColor = [UIColor whiteColor];
        UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        if([NSString isNullOrEmpty:controller.title]){
            [self addCustomDefaultBackButton:LZGDCommonLocailzableString(@"common_back")];
        } else {
            [self addCustomDefaultBackButton:controller.title];
        }
    }
    
    _currentUid = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    
    
    EVENT_SUBSCRIBE(self, EventBus_User_Account_ChangeFace);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [UMengUtil beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
    //用于防止图片浏览为单击退出模式下导航栏消失的问题
    self.navigationController.navigationBarHidden = NO;
    
    /* 是否需要刷新头像或名称 */
    if(self.isNeedRefreshLZTableViewWhenViewAppear){
//        [self refreshWhenViewAppearForUpdateUid];
        self.isNeedRefreshLZTableViewWhenViewAppear = NO;
    }
    
    EVENT_SUBSCRIBE(self, EventBus_WebApi_SendFail);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSArray *subviews = [self.navigationController.navigationBar subviews];
    for (id subView in subviews) {
        NSString *classStr = NSStringFromClass([subView class]);
        if ([classStr isEqualToString:@"UIProgressView"]) {
            [subView removeFromSuperview];
        }
    }
//    [UMengUtil endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
    EVENT_UNSUBSCRIBE(self, EventBus_WebApi_SendFail);
}

#pragma mark - NavigationController

//添加返回按钮
- (void)addCustomDefaultBackButton:(NSString *)title {
    
    [self addCustomDefaultBackButton:title secondTitle:@""];
}

//添加返回、关闭按钮
- (void)addCustomDefaultBackButton:(NSString *)title secondTitle:(NSString *)secondtitle{
    
    UIView *leftView = [[UIView alloc] init];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *backArrowImg=[[UIImageView alloc]init];
    //    UIButton *backArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //       根据按钮名称计算高度和宽度
    CGSize tmpSize=[title sizeWithMaxSize:CGSizeMake(CGFLOAT_MAX, 40) font:backBtn.titleLabel.font];
    if(tmpSize.width>(LZ_SCREEN_WIDTH/4)){
        backBtn.frame=CGRectMake(0, 0, LZ_SCREEN_WIDTH/4, tmpSize.height);
    }else{
        backBtn.frame=CGRectMake(0, 0, tmpSize.width+10, tmpSize.height);
    }
    //    [backBtn setImage:[UIImage imageNamed:@"top_left_arrow"] forState:UIControlStateNormal];
    ////    [backBtn setBackgroundImage:[UIImage imageNamed:@"top_left_arrow"] forState:UIControlStateNormal];
    //    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);//（上，左，下，右）
    backBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 6, -1, 0);
    //    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 10, 0);//（上，左，下，右）
    //    backBtn.titleEdgeInsets=UIEdgeInsetsMake(0, -20, 9, 6);
    //    backBtn.backgroundColor=[UIColor redColor];
    [backBtn setTitle:title forState:UIControlStateNormal];//名称
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    //    backBtn.titleLabel.textAlignment=NSTextAlignmentCenter;//居中对齐
    [backBtn setTitleColor: UIColorWithRGB(0, 122.0f, 255.0f) forState:UIControlStateNormal];//字体颜色
    [backBtn addTarget:self action:@selector(customDefaultBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    backArrowImg.frame=CGRectMake(-17, -5, 32, 32);
    backArrowImg.image=[ImageManager LZGetImageByFileName:@"top_left_arrow"];
    backArrowImg.userInteractionEnabled = YES;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(customDefaultBackButtonClick)];
    [backArrowImg addGestureRecognizer:tapGesture];
    
    //    backArrowBtn.frame = CGRectMake(CGRectGetMinX(backBtn.frame)-17, -5, 32, 32);
    //    [backArrowBtn setBackgroundImage:[ImageManager LZGetImageByFileName:@"top_left_arrow"] forState:UIControlStateNormal];
    //    [backArrowBtn addTarget:self action:@selector(customDefaultBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [leftView addSubview:backBtn];
    [leftView addSubview:backArrowImg];
    //    [leftView addSubview:backArrowBtn];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if(LZ_IS_IOS11)fixedSpace.width = -17;
    
    if([secondtitle isEqualToString:@""]){
        leftView.bounds = CGRectMake(0, 0, backBtn.frame.size.width, tmpSize.height);
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(customDefaultBackButtonClick)];
        
        [leftView addGestureRecognizer:tapGesture];
        
    }
    else {
        /* 关闭按钮 */
        UIButton *secondBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        secondBtn.titleLabel.font = backBtn.titleLabel.font;
        [secondBtn setTitle:secondtitle forState:UIControlStateNormal];//名称
        secondBtn.titleLabel.textAlignment=NSTextAlignmentLeft;//居中对齐
        secondBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [secondBtn setTitleColor: UIColorWithRGB(0, 122.0f, 255.0f) forState:UIControlStateNormal];//字体颜色
        CGSize secondSize=[title sizeWithMaxSize:CGSizeMake(CGFLOAT_MAX, 40) font:backBtn.titleLabel.font];
        secondBtn.frame=CGRectMake(backBtn.frame.size.width+10, 0, secondSize.width, backBtn.frame.size.height);
        secondBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, -1, 0);
        [secondBtn addTarget:self action:@selector(customDefaultCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:secondBtn];
        leftView.frame = CGRectMake(0, 0, backBtn.frame.size.width + secondBtn.frame.size.width+10, tmpSize.height);
        
        if([title isEqualToString:@""]){
            backBtn.hidden = YES;
            secondBtn.frame=CGRectMake(0, 1, secondSize.width, secondSize.height);
        }
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:leftView] ;
    self.navigationItem.leftBarButtonItems = @[fixedSpace,backItem];
}

//返回设置列表
-(void)customDefaultBackButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//默认关闭按钮
-(void)customDefaultCloseButtonClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


/**
 *  根据按钮名称创建ButtonItem
 *  @param buttonName 按钮名称（为空，不创建）
 *  @return Button
 */
-(UIButton *)creaButtonItemWithButtonName:(NSString *)buttonName{
    //              空按钮名称，不设置
    if([NSString isNullOrEmpty:buttonName]) return nil;
    //              先创建按钮
    UIButton *tmpButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [tmpButton setTitle:buttonName forState:UIControlStateNormal];//名称
    tmpButton.titleLabel.textAlignment=NSTextAlignmentCenter;//居中对齐
    [tmpButton setTitleColor:UIColorWithRGB(0, 122.0f, 255.0f) forState:UIControlStateNormal];//字体颜色
    //                              根据按钮名称计算高度和宽度
    CGSize tmpSize=[buttonName sizeWithMaxSize:CGSizeMake(100, 40) font:tmpButton.titleLabel.font];
    tmpButton.frame=CGRectMake(0, 0, tmpSize.width, tmpSize.height);
    [tmpButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    //设置
    //    tmpButton.adjustsImageWhenHighlighted=NO;
    return tmpButton;
}

/**
 *  设置右侧导航按钮
 *  @param itemName                 导航按钮名称
 */
-(void)setNavigationItemForRight:(NSString *)itemName{
    UIButton *tmpButton=[self creaButtonItemWithButtonName:itemName];
    if(tmpButton==nil)return;
    [tmpButton addTarget:self action:@selector(onRightNavigationItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *tmpBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:tmpButton];
    self.navigationItem.rightBarButtonItem=tmpBarButtonItem;
}
/**
 *  设置右侧导航按钮
 *  @param size                     导航按钮大小
 *  @param normalImageName          正常状态的图片名称
 *  @param highlightedImageName     高亮状态的图片名称
 */
-(void)setNavigationItemForRightWithSize:(CGSize)size normalImage:(NSString *)normalImageName highlightedImage:(NSString *)highlightedImageName{
    UIButton *tmpButton=[UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame=CGRectMake(0, 0, size.width, size.height);
    
    if([NSString isNullOrEmpty:normalImageName]==NO)
        [tmpButton setImage:[ImageManager LZGetImageByFileName:normalImageName] forState:UIControlStateNormal];
    
    if([NSString isNullOrEmpty:highlightedImageName]==NO)
        [tmpButton setImage:[ImageManager LZGetImageByFileName:highlightedImageName] forState:UIControlStateHighlighted];
    if(LZ_IS_IOS11)[tmpButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -8)];
    tmpButton.adjustsImageWhenHighlighted=NO;
    [tmpButton addTarget:self action:@selector(onRightNavigationItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *tmpBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:tmpButton];
    self.navigationItem.rightBarButtonItem=tmpBarButtonItem;
}
/**
 *  在右侧导航按钮点击的时候（子类重写以监听事件）
 */
-(void)onRightNavigationItemClicked{
    NSLog(@"============右侧导航按钮被点击了，子类的重写呢");
}
@end
