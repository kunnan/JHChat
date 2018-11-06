//
//  JHBaseNavigationController.m
//  JHChat
//
//  Created by gjh on 2018/11/6.
//  Copyright © 2018 gjh. All rights reserved.
//

#import "JHBaseNavigationController.h"
#import "ChatViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface JHBaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, weak) UIViewController *currentShowVC;
@end

@implementation JHBaseNavigationController

#pragma mark 手势退出
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    JHBaseNavigationController *nav = [super initWithRootViewController:rootViewController];
    nav.interactivePopGestureRecognizer.delegate = self;
    nav.delegate = self;
    return nav;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (1 == navigationController.viewControllers.count) {
        self.currentShowVC = nil;
    } else {
        self.currentShowVC = viewController;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Life cycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self.navigationBar setBackgroundColor:[UIColor redColor]];
    //    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbg.png"] forBarMetrics:UIBarMetricsDefault];
    //    导航栏变为透明
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //    //    让黑线消失的方法
    //    self.navigationController.navigationBar.shadowImage=[UIImage new];
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithWhite:0.918 alpha:0.100]];
    //    self.navigationController.navigationBar.alpha = 0.0;
    //    [self.navigationBar setBackgroundColor:[UIColor colorWithWhite:0.918 alpha:1.000]];
    [self.navigationBar setBarTintColor:[UIColor colorWithWhite:0.918 alpha:1.00]];
    //    self.navigationBar.translucent = NO;
    //    [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 0.1;
    
    
    //    [self.navigationBar setTintColor:[UIColor blackColor]];
    
    //    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //    bar.tintColor = [UIColor whiteColor];
    
    //    UIStatusBarStyleDefault                                     = 0, // Dark content, for use on light backgrounds
    //    UIStatusBarStyleLightContent     NS_ENUM_AVAILABLE_IOS(7_0) = 1, // Light content, for use on dark backgrounds
    //
    //    UIStatusBarStyleBlackTranslucent NS_ENUM_DEPRECATED_IOS(2_0, 7_0, "Use UIStatusBarStyleLightContent") = 1,
    //    UIStatusBarStyleBlackOpaque      NS_ENUM_DEPRECATED_IOS(2_0, 7_0, "Use UIStatusBarStyleLightContent") = 2,
    
    //    [self.navigationBar setBarTintColor:[UIColor colorWithRed:0.071 green:0.060 blue:0.086 alpha:1.000]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//重写返回按钮
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self == self.navigationController.topViewController) {
        return ;
    }
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    BOOL isExistSameVC = NO;
    /* 打开聊天框时，需要特殊处理 */
    if([viewController isKindOfClass:[ChatViewController class]]){
        for (UIViewController *controller in self.viewControllers) {
            if ([controller isKindOfClass:[ChatViewController class]]) {
                ChatViewController *oldChatVC = (ChatViewController *)controller;
                ChatViewController *newChatVC = (ChatViewController *)viewController;
                if([oldChatVC.dialogid isEqualToString:newChatVC.dialogid]){
                    isExistSameVC = YES;
                    [super popToViewController:controller animated:YES];
                }
            }
        }
    }
    
    if(!isExistSameVC){
        [super pushViewController:viewController animated:animated];
    }
    
    
    //    if (viewController.navigationItem.leftBarButtonItem ==nil && self.viewControllers.count >1) {
    //        viewController.navigationItem.leftBarButtonItem = [self creatBackButton:viewController.navigationItem.leftBarButtonItem];
    //    }
}
//重写返回按钮
-(void)pushViewControllerr:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
}


//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;


-(UIBarButtonItem *)creatBackButton:(UIBarButtonItem *)defaultButtonItem
{
    //    UIImage *btnImageNoraml = [UIImage imageNamed:@"nav_left_back_normal"];
    //    UIImage *btnImagePress = [UIImage imageNamed:@"nav_left_back_pressed"];
    //    CGFloat top = 0; // 顶端盖高度
    //    CGFloat bottom = 0 ; // 底端盖高度
    //    CGFloat left = 15; // 左端盖宽度
    //    CGFloat right = 15; // 右端盖宽度
    //    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    //    btnImageNoraml = [btnImageNoraml resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
    //    btnImagePress = [btnImagePress resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
    //
    //    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    backBtn.frame = CGRectMake(0, 100, 48, 29);
    //    [backBtn setBackgroundImage:btnImageNoraml forState:UIControlStateNormal];
    //    [backBtn setBackgroundImage:btnImagePress forState:UIControlStateSelected];
    //    [backBtn addTarget:self action: @selector(defaultPopBack) forControlEvents: UIControlEventTouchUpInside];
    //    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [backBtn setTitle:[NSString stringWithFormat:@"  %@",LZGDCommonLocailzableString(@"common_back")] forState:UIControlStateNormal];
    //    [backBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    //    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    //
    //    defaultButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    
    return defaultButtonItem;
}

-(void)defaultPopBack
{
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(customDefaultBackButtonClick)]) {
        [vc customDefaultBackButtonClick];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }
}


@end
