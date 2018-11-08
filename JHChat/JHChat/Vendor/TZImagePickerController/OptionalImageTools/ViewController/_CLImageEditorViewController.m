//
//  _CLImageEditorViewController.m
//
//  Created by sho yakushiji on 2013/11/05.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "_CLImageEditorViewController.h"
#import "CLImageToolBase.h"

#import "CLDrawTool.h"
#import "CLTextTool.h"
#import "CLBlurTool.h"
#import "CLClippingTool.h"
#import "CLEmoticonTool.h"
#import "CLRotateTool.h"

#import "LCProgressHUD.h"

#import "ImageEditScrollView.h"

#import "TZImageManager.h"

#pragma mark- _CLImageEditorViewController

/* 底部工具条的高度(34) */
//#define LZ_TOOLBAR_HEIGHT (LZ_IPHONEX?34:0)
//static const CGFloat kNavBarHeight = 44.0f;
static const CGFloat kMenuBarHeight = 44.0f; // 80

@interface _CLImageEditorViewController()
<CLImageToolProtocol, UINavigationBarDelegate,ImageEditScrollViewDelegate>


@property (nonatomic, strong) CLImageToolBase *currentTool; //
@property (nonatomic, strong, readwrite) CLImageToolInfo *toolInfo;
@property (nonatomic, strong) UIImageView *targetImageView;
@property (nonatomic, strong)  NSMutableArray *toolArray;

@end


//@implementation UIScrollView (UITouch)
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    NSLog(@"走了touchesBegan");
//}
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesEnded:touches withEvent:event];
//    //做你想要的操作
//}
//@end
@implementation _CLImageEditorViewController
{
    UIImage *_originalImage;
    UIView *_bgView;
    BOOL isHiddenNav;
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    
    UIButton *cancleButton;
    UIButton *sureOrFinishButton;
    
    UIView *_bgView2;
    
    UIView *_buttonBacgroudView;

}
@synthesize toolInfo = _toolInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.toolInfo = [CLImageToolInfo toolInfoForToolClass:[self class]];
    }
    return self;
}

- (id)init
{
    self = [self initWithNibName:nil bundle:nil];
    if (self){
        
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithImage:image delegate:nil];
}

- (id)initWithImage:(UIImage*)image delegate:(id<CLImageEditorDelegate>)delegate
{
    self = [self init];
    if (self){
        _originalImage = [image deepCopy];
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithDelegate:(id<CLImageEditorDelegate>)delegate
{
    self = [self init];
    if (self){
        self.delegate = delegate;
    }
    return self;
}
//-(UIImageView *)editBaseView {
//    if (_editBaseView == nil) {
//        _editBaseView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
//        
//    }
//    return _editBaseView;
//}
- (void)dealloc
{
    [_navigationBar removeFromSuperview];
}

#pragma mark- Custom initialization

- (void)initNavigationBar
{
    self.navigationController.navigationBar.hidden = YES;
    _navigationBar.hidden = YES;
    
    _bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 48)];
    _bgView2.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    _bgView2.alpha = 0.7;
    [self.view addSubview:_bgView2];
    
    CGFloat centenX = self.view.frame.size.width/2;
    CGFloat Width = 40;
    CGFloat height = 30;
    cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(10, 15, Width, height);
    cancleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancleButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancleButton addTarget:self action:@selector(clickCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView2 addSubview:cancleButton];
    
    sureOrFinishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureOrFinishButton.frame = CGRectMake(centenX+(centenX - (Width+10)),15, Width, height);
    //[sureOrFinishButton setTitle:@"完成" forState:UIControlStateNormal];
    //sureOrFinishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //[sureOrFinishButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    sureOrFinishButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureOrFinishButton setBackgroundImage:[UIImage imageNamed:@"msg_cota_savelocal_white"] forState:UIControlStateNormal];
    [sureOrFinishButton addTarget:self action:@selector(clickSureOrFinishButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView2 addSubview:sureOrFinishButton];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//     UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
//    statusBarView.backgroundColor=[UIColor clearColor];
//    [self.navigationController.navigationBar addSubview:statusBarView];
//    _navigationBar = self.navigationController.navigationBar;
    
//    UIBarButtonItem *rightBarButtonItem = nil;
//    NSString *doneBtnTitle = [CLImageEditorTheme localizedString:@"CLImageEditor_DoneBtnTitle" withDefault:nil];
//    
//    if(![doneBtnTitle isEqualToString:@"CLImageEditor_DoneBtnTitle"]){
//        rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:doneBtnTitle style:UIBarButtonItemStyleDone target:self action:@selector(pushedFinishBtn:)];
//    }
//    else{
//        rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushedFinishBtn:)];
//    }
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    
//    if (self.presentedViewController) {
//        //rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(pushedFinishBtn:)];
//    }
//
//    if(_navigationBar==nil){
//        UINavigationItem *navigationItem  = [[UINavigationItem alloc] init];
//        navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pushedCloseBtn:)];
//        
//        navigationItem.rightBarButtonItem = rightBarButtonItem;
//        
//        
//        CGFloat dy = ([UIDevice iosVersion]<7) ? 0 : MIN([UIApplication sharedApplication].statusBarFrame.size.height, [UIApplication sharedApplication].statusBarFrame.size.width);
//        
//        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, dy, self.view.width, kNavBarHeight)];
//           
//        
//        [navigationBar pushNavigationItem:navigationItem animated:NO];
//        navigationBar.delegate = self;
//        
////        if(self.navigationController){
////            [self.navigationController.view addSubview:navigationBar];
////            [_CLImageEditorViewController setConstraintsLeading:@0 trailing:@0 top:@(dy) bottom:nil height:@(kNavBarHeight) width:nil parent:self.navigationController.view child:navigationBar peer:nil];
////        }
////        else{
//            [self.view addSubview:navigationBar];
//            [_CLImageEditorViewController setConstraintsLeading:@0 trailing:@0 top:@(dy) bottom:nil height:@(kNavBarHeight) width:nil parent:self.view child:navigationBar peer:nil];
//        }
        
//        _navigationBar = navigationBar;
//    }
//    [_navigationBar setTintColor:[UIColor clearColor]];
//    if(self.navigationController!=nil){
//        _navigationBar.frame  = self.navigationController.navigationBar.frame;
//        _navigationBar.hidden = YES;
//        [_navigationBar popNavigationItemAnimated:NO];
//    }
//    else{
//        //_navigationBar.topItem.title = self.title;
//    }
//    
//    if([UIDevice iosVersion] < 7){
//        _navigationBar.barStyle = UIBarStyleBlackTranslucent;
//    }
    
}
#pragma mark - 导航栏按钮点击事件
-(void)clickCancleButton:(UIButton*)button {
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if ([_rightBottombutton.titleLabel.text isEqualToString:@"确定"]) {
        _imageView.image = _originalImage;
        [self resetImageViewFrame:NO];
        self.currentTool = nil;
        for (int i = 0; i < self.toolArray.count; i++) {
            id toolclass = [self.toolArray objectAtIndex:i];
            if ([toolclass isKindOfClass:[CLClippingTool class]]) { // 裁剪
                            // 裁剪过之后 baseEditView需要从新布局才行
                [self.toolArray removeObject:toolclass]; // 把裁剪移除掉 不然再编辑其它的话 会再裁剪的
            }
        }
        [_rightBottombutton setTitle:@"发送" forState:UIControlStateNormal];
    }
   else if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        //present方式
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}
-(void)clickSureOrFinishButton:(UIButton*)button {
//    if ([button.titleLabel.text isEqualToString:@"确定"]) {
        self.view.userInteractionEnabled = YES;
        [self buildAllImage:YES];
        [self.currentTool executeWithCompletionBlock:^(UIImage *image, NSError *error, NSDictionary *userInfo) {
            self.view.userInteractionEnabled = YES;
        }];
}
#pragma mark - 保存到系统相册
- (void)loadImageFinished:(UIImage *)image
{
    [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
        if (!error) {
            [LCProgressHUD showSuccess:@"成功保存至系统相册"];
            [self.editBaseView removeFromSuperview]; // 保存成功后 移除
            self.editBaseView = nil;
            if ([self.delegate respondsToSelector:@selector(imageEditSaveToAblum:saveImage:)]) {
                [self.delegate imageEditSaveToAblum:self saveImage:self.imageView.image];
            }
        }
    }];

    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [LCProgressHUD showSuccess:@"成功保存至系统相册"];
       
    }
    else {
        [LCProgressHUD showFailure:@"保存失败"];
    }
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark - 初始化 底部菜单栏
- (void)initMenuScrollView
{
    
    if(self.menuView==nil){
        
        UIScrollView *menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - kMenuBarHeight -LZ_TOOLBAR_HEIGHT, self.view.frame.size.width - 70 , kMenuBarHeight)];
        menuScroll.top = self.view.height - menuScroll.height-LZ_TOOLBAR_HEIGHT;
        menuScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator = NO;
        menuScroll.showsVerticalScrollIndicator = NO;
        //self.menuView.alpha = 0.5;
        [self.view addSubview:menuScroll];
        self.menuView = menuScroll;
        
        //[_CLImageEditorViewController setConstraintsLeading:@0 trailing:@0 top:nil bottom:@0 height:@(kMenuBarHeight) width:nil parent:self.view child:menuScroll peer:nil];
        
        UIView *bacgroudView= [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(menuScroll.frame), menuScroll.y, self.view.frame.size.width - menuScroll.width, menuScroll.height)];
        bacgroudView.userInteractionEnabled = YES;
       // bacgroudView.backgroundColor = [UIColor redColor];
        [self.view addSubview:bacgroudView];
       
        
        CGFloat W = bacgroudView.width - 20;
        CGFloat H = bacgroudView.height - 10;
        
       UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((bacgroudView.width - W)/2, (bacgroudView.height - H)/2, W, H);
        
        //_rightBottombutton.top = self.view.height - menuScroll.height;
       // button.centerY = bacgroudView.centerY;
        //button.centerX = bacgroudView.centerX;
        // 53 168 245
        button.backgroundColor = [UIColor colorWithRed:53/255.0 green:168/255.0 blue:245/255.0 alpha:1];
        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button setTintColor:[UIColor whiteColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        button.hidden = NO;
        [button addTarget:self action:@selector(clickSend:) forControlEvents:UIControlEventTouchUpInside];
        
        [bacgroudView addSubview:button];
        _rightBottombutton = button;
        _buttonBacgroudView = bacgroudView;
    }
    
    self.menuView.backgroundColor = [CLImageEditorTheme toolbarColor];
    self.menuView.alpha = 0.7;
    _buttonBacgroudView.backgroundColor = [[CLImageEditorTheme toolbarColor] colorWithAlphaComponent:0.7];
    NSLog(@"===== %f",self.menuView.width);
    //self.menuView.width = self.view.width - 44;
    NSLog(@"=====+ %f",self.menuView.width);
}

- (void)initImageScrollView
{
    if(_scrollView==nil){
        ImageEditScrollView *imageScroll = [[ImageEditScrollView alloc] initWithFrame:self.view.frame];
        imageScroll.imageEditScrollViewDelegate = self;
        imageScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageScroll.showsHorizontalScrollIndicator = NO;
        imageScroll.showsVerticalScrollIndicator = NO;
        imageScroll.delegate = self;
        imageScroll.clipsToBounds = NO;
        
        CGFloat y = 0;
        if(self.navigationController){
            if(self.navigationController.navigationBar.translucent){
                y = self.navigationController.navigationBar.bottom;
            }
            y = ([UIDevice iosVersion] < 7) ? y-[UIApplication sharedApplication].statusBarFrame.size.height : y;
        }
        else{
            y = _navigationBar.bottom;
        }
        
        imageScroll.top = y;
        imageScroll.height = self.view.height - imageScroll.top - _menuView.height;
        
        [self.view insertSubview:imageScroll atIndex:0];
        _scrollView = imageScroll;
        // bottom:@(-_menuView.height top:@(y)
        [_CLImageEditorViewController setConstraintsLeading:@0 trailing:@0 top:@(0) bottom:@(LZ_TOOLBAR_HEIGHT) height:nil width:nil parent:self.view child:imageScroll peer:nil];
    }
}
#pragma mark - scrollView点击事件代理
-(void)imageEditScrollViewTouchBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"走了点击屏幕的方法");
    NSArray *allObject= touches.allObjects;
    for (int i = 0; i< allObject.count; i++) {
        UITouch *touch = [allObject objectAtIndex:i];
        NSLog(@" 输出点击的view的Tag:%ld", touch.view.tag);
        if (touch.view.tag == 22) {
            NSLog(@" touches输出点击的view的类名%@", NSStringFromClass([touch.view class]));
            return;
        }
    }
    
    isHiddenNav = !isHiddenNav;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _navigationBar.hidden = YES;
    //    [UIView animateWithDuration:0.2 animations:^{
    _bgView2.hidden = isHiddenNav;
    _menuView.hidden = isHiddenNav;
    _currentTool.menuView.hidden = isHiddenNav;
    
    
    if ([_currentTool isKindOfClass:[CLEmoticonTool class]]) {
        
        [(CLEmoticonTool*)_currentTool hiddenEmotionView];
        //_rightBottombutton.hidden = NO;
    }
    
    
    _buttonBacgroudView.hidden = isHiddenNav;
//    if ([_rightBottombutton.titleLabel.text isEqualToString:@"确定"]) {
//        _rightBottombutton.hidden = NO;
//    }

}
+(NSArray <NSLayoutConstraint *>*)setConstraintsLeading:(NSNumber *)leading
                                               trailing:(NSNumber *)trailing
                                                    top:(NSNumber *)top
                                                 bottom:(NSNumber *)bottom
                                                 height:(NSNumber *)height
                                                  width:(NSNumber *)width
                                                 parent:(UIView *)parent
                                                  child:(UIView *)child
                                                   peer:(UIView *)peer
{
    NSMutableArray <NSLayoutConstraint *>*constraints = [NSMutableArray new];
    //Trailing
    if (trailing) {
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint
                                                  constraintWithItem:child
                                                  attribute:NSLayoutAttributeTrailing
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:(peer ?: parent)
                                                  attribute:NSLayoutAttributeTrailing
                                                  multiplier:1.0f
                                                  constant:trailing.floatValue];
        [parent addConstraint:trailingConstraint];
        [constraints addObject:trailingConstraint];
    }
    //Leading
    if (leading) {
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint
                                                 constraintWithItem:child
                                                 attribute:NSLayoutAttributeLeading
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:(peer ?: parent)
                                                 attribute:NSLayoutAttributeLeading
                                                 multiplier:1.0f
                                                 constant:leading.floatValue];
        [parent addConstraint:leadingConstraint];
        [constraints addObject:leadingConstraint];
    }
    //Bottom
    if (bottom) {
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint
                                                constraintWithItem:child
                                                attribute:NSLayoutAttributeBottom
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:(peer ?: parent)
                                                attribute:NSLayoutAttributeBottom
                                                multiplier:1.0f
                                                constant:bottom.floatValue];
        [parent addConstraint:bottomConstraint];
        [constraints addObject:bottomConstraint];
    }
    //Top
    if (top) {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint
                                             constraintWithItem:child
                                             attribute:NSLayoutAttributeTop
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:(peer ?: parent)
                                             attribute:NSLayoutAttributeTop
                                             multiplier:1.0f
                                             constant:top.floatValue];
        [parent addConstraint:topConstraint];
        [constraints addObject:topConstraint];
    }
    //Height
    if (height) {
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint
                                                constraintWithItem:child
                                                attribute:NSLayoutAttributeHeight
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:nil
                                                attribute:NSLayoutAttributeNotAnAttribute
                                                multiplier:1.0f
                                                constant:height.floatValue];
        [child addConstraint:heightConstraint];
        [constraints addObject:heightConstraint];
    }
    //Width
    if (width) {
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint
                                               constraintWithItem:child
                                               attribute:NSLayoutAttributeWidth
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:nil
                                               attribute:NSLayoutAttributeNotAnAttribute
                                               multiplier:1.0f
                                               constant:width.floatValue];
        [child addConstraint:widthConstraint];
        [constraints addObject:widthConstraint];
    }
    child.translatesAutoresizingMaskIntoConstraints = NO;
    return constraints;
}

#pragma mark-

- (void)showInViewController:(UIViewController*)controller withImageView:(UIImageView*)imageView;
{
    _originalImage = imageView.image;
    
    self.targetImageView = imageView;
    
    [controller addChildViewController:self];
    [self didMoveToParentViewController:controller];
    
    self.view.frame = controller.view.bounds;
    [controller.view addSubview:self.view];
    [self refreshImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _navigationBar.hidden = YES;
    //self.title = self.toolInfo.title;
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = self.theme.backgroundColor;
    //self.navigationController.view.backgroundColor = self.view.backgroundColor;
    
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self initImageScrollView];
    
    [self refreshToolSettings];
    
    if(_imageView==nil){
        _imageView = [UIImageView new];
        [_scrollView addSubview:_imageView];
        [self refreshImageView];
    }
   //self.imageView
    self.imageView.clipsToBounds = YES;
    [self.imageView setAutoresizesSubviews:YES];
    [self creatEditBaseView];
     [self initNavigationBar];
     [self initMenuScrollView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if(self.targetImageView){
        [self expropriateImageView];
    }
    else{
        [self refreshImageView];
    }
}
#pragma mark - 创建编辑视图
-(void)creatEditBaseView {
    self.editBaseView =  [[UIImageView alloc] initWithFrame:self.imageView.bounds];
    self.editBaseView.userInteractionEnabled = YES; // frame有时候是对的 有时候是不对的
    self.editBaseView.tag = 100;
    //self.editBaseView.height = self.editBaseView.height - LZ_TOOLBAR_HEIGHT
    self.editBaseView.contentMode = UIViewContentModeScaleAspectFit;
    self.editBaseView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth|
    UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin ;
    self.editBaseView.autoresizesSubviews  = NO;
    [self.imageView addSubview:self.editBaseView];
    
}
#pragma mark- View transition

- (void)copyImageViewInfo:(UIImageView*)fromView toView:(UIImageView*)toView
{
    CGAffineTransform transform = fromView.transform;
    fromView.transform = CGAffineTransformIdentity;
    
    toView.transform = CGAffineTransformIdentity;
    toView.frame = [toView.superview convertRect:fromView.frame fromView:fromView.superview];
    toView.transform = transform;
    toView.image = fromView.image;
    toView.contentMode = fromView.contentMode;
    toView.clipsToBounds = fromView.clipsToBounds;
    
    fromView.transform = transform;
}

- (void)expropriateImageView
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIImageView *animateView = [UIImageView new];
    [window addSubview:animateView];
    [self copyImageViewInfo:self.targetImageView toView:animateView];
    
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_bgView atIndex:0];
    
    _bgView.backgroundColor = self.view.backgroundColor;
    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    
    self.targetImageView.hidden = YES;
    _imageView.hidden = YES;
    _bgView.alpha = 0;
    _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
    _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-_menuView.top);
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         animateView.transform = CGAffineTransformIdentity;
                         
                         CGFloat dy = ([UIDevice iosVersion]<7) ? [UIApplication sharedApplication].statusBarFrame.size.height : 0;
                         
                         CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
                         if(size.width>0 && size.height>0){
                             CGFloat ratio = MIN(_scrollView.width / size.width, _scrollView.height / size.height);
                             CGFloat W = ratio * size.width;
                             CGFloat H = ratio * size.height;
                             animateView.frame = CGRectMake((_scrollView.width-W)/2 + _scrollView.left, (_scrollView.height-H)/2 + _scrollView.top + dy, W, H);
                         }
                         
                         _bgView.alpha = 1;
                         _navigationBar.transform = CGAffineTransformIdentity;
                         _menuView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         self.targetImageView.hidden = NO;
                         _imageView.hidden = NO;
                         [animateView removeFromSuperview];
                     }
     ];
}

- (void)restoreImageView:(BOOL)canceled
{
    if(!canceled){
        self.targetImageView.image = _imageView.image;
    }
    self.targetImageView.hidden = YES;
    
    id<CLImageEditorTransitionDelegate> delegate = [self transitionDelegate];
    if([delegate respondsToSelector:@selector(imageEditor:willDismissWithImageView:canceled:)]){
        [delegate imageEditor:self willDismissWithImageView:self.targetImageView canceled:canceled];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIImageView *animateView = [UIImageView new];
    [window addSubview:animateView];
    [self copyImageViewInfo:_imageView toView:animateView];
    
    _menuView.frame = [window convertRect:_menuView.frame fromView:_menuView.superview];
    _navigationBar.frame = [window convertRect:_navigationBar.frame fromView:_navigationBar.superview];
    
    [window addSubview:_menuView];
    [window addSubview:_navigationBar];
    
    self.view.userInteractionEnabled = NO;
    _menuView.userInteractionEnabled = NO;
    _navigationBar.userInteractionEnabled = NO;
    _imageView.hidden = YES;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _bgView.alpha = 0;
                         _menuView.alpha = 0;
                         _navigationBar.alpha = 0;
                         
                         _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-_menuView.top);
                         _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
                         
                         [self copyImageViewInfo:self.targetImageView toView:animateView];
                     }
                     completion:^(BOOL finished) {
                         [animateView removeFromSuperview];
                         [_menuView removeFromSuperview];
                         [_navigationBar removeFromSuperview];
                         
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                         
                         _imageView.hidden = NO;
                         self.targetImageView.hidden = NO;
                         
                         if([delegate respondsToSelector:@selector(imageEditor:didDismissWithImageView:canceled:)]){
                             [delegate imageEditor:self didDismissWithImageView:self.targetImageView canceled:canceled];
                         }
                     }
     ];
}

#pragma mark- Properties

- (id<CLImageEditorTransitionDelegate>)transitionDelegate
{
    if([self.delegate conformsToProtocol:@protocol(CLImageEditorTransitionDelegate)]){
        return (id<CLImageEditorTransitionDelegate>)self.delegate;
    }
    return nil;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.toolInfo.title = title;
}

- (UIScrollView*)scrollView
{
    return _scrollView;
}
-(NSMutableArray *)toolArray {
    if (_toolArray == nil) {
        _toolArray = [[NSMutableArray alloc] init];
    }
    return _toolArray;
}
-(NSMutableArray *)didEditItem {
    if (_didEditItem==nil) {
        _didEditItem =[[NSMutableArray alloc] init];
    }
    return _didEditItem;
}
#pragma mark- ImageTool setting


+ (NSString*)defaultIconImagePath
{
    return nil;
}

+ (CGFloat)defaultDockedNumber
{
    return 0;
}

+ (NSString*)defaultTitle
{
    return [CLImageEditorTheme localizedString:@"CLImageEditor_DefaultTitle" withDefault:@"Edit"];
}

+ (BOOL)isAvailable
{
    return YES;
}

+ (NSArray*)subtools
{
    return [CLImageToolInfo toolsWithToolClass:[CLImageToolBase class]];
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

#pragma mark-  创建编辑项

- (void)refreshToolSettings
{
    
    for(UIView *sub in _menuView.subviews){
        
        [sub removeFromSuperview];
    }
    
    CGFloat x = 0;
    CGFloat W = 50; //70
    CGFloat H = _menuView.height;
    
    int toolCount = 0;
    CGFloat padding = 0; //0
    for(CLImageToolInfo *info in self.toolInfo.sortedSubtools){
        
        if(info.available && ![self filterItem:info]){
            toolCount++;
        }
    }
    NSLog(@"总共编辑图片的选项：%d",toolCount);
    // _menuView.withd
    CGFloat diff = _menuView.frame.size.width - toolCount * W;
    //padding = 10;
    
//    if (0<diff && diff<2*W) {
        padding = diff/(toolCount+1);
//    }
//    if (diff > 0) {
//        padding = diff/(toolCount);
//    }
    NSLog(@"边距padding:%f",padding);
    for(CLImageToolInfo *info in self.toolInfo.sortedSubtools){
        if(!info.available || [self filterItem:info]){
            continue;
        }
        
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x+padding, 0, W, H) target:self action:@selector(tappedMenuView:) toolInfo:info];
        
        [_menuView addSubview:view];
        NSLog(@"view`s X:%f",view.x);
        x += W+padding;
    }
    
    _menuView.contentSize = CGSizeMake(MAX(x, _menuView.frame.size.width+1), 0);//MAX(x, _menuView.frame.size.width+1)
}
#pragma mark  - 更新图片frame
- (void)resetImageViewFrame:(BOOL)isCliping
{
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width>0 && size.height>0){
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;

        _imageView.frame = CGRectMake(MAX(0, (_scrollView.width-W)/2), MAX(0, (_scrollView.height-H)/2), W, H);
    }
    if (isCliping) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:NSStringFromCGRect(_imageView.frame) forKey:@"imageframe"];
        
      //  [[NSNotificationCenter defaultCenter] postNotificationName:@"newframe" object:dic];
    }
    // 更新一下 应该是把编辑view给裁剪掉
    self.imageView.clipsToBounds = YES;
    
    [self.imageView setAutoresizesSubviews:YES];
   // self.editBaseView.frame =  self.imageView.bounds;//bound
    self.editBaseView.userInteractionEnabled = YES;
    //[self.imageView addSubview:self.editBaseView];
    
   
}
-(BOOL)filterItem:(CLImageToolInfo*)info {
    if ([info.title isEqualToString:@"滤镜"]
        || [info.toolName isEqualToString:@"CLFilterTool"]
        || [info.title isEqualToString:@"调整"]
        || [info.toolName isEqualToString:@"CLAdjustmentTool"]
        || [info.title isEqualToString:@"效果"]
        || [info.toolName isEqualToString:@"CLEffectTool"]
        || [info.title isEqualToString:@"喷溅"]
        || [info.toolName isEqualToString:@"CLSplashTool"]
        || [info.title isEqualToString:@"调整"]
        || [info.toolName isEqualToString:@"CLResizeTool"]
        || [info.title isEqualToString:@"色调曲线"]
        || [info.toolName isEqualToString:@"CLToneCurveTool"]
        || [info.title isEqualToString:@"贴纸"]
        || [info.toolName isEqualToString:@"CLStickerTool"]
        || [info.title isEqualToString:@"旋转"]
        || [info.toolName isEqualToString:@"CLRotateTool"]
        || [info.title isEqualToString:@"模糊与聚焦"]
        || [info.toolName isEqualToString:@"CLBlurTool"]
        ) {
        return YES;
    }
    return NO;
}
#pragma  - scorllview缩放的方法，把imageview缩放

- (void)fixZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat minZoomScale = _scrollView.minimumZoomScale;
    _scrollView.maximumZoomScale = 0.80*minZoomScale;// 0.95
    _scrollView.minimumZoomScale = 0.80*minZoomScale;// 0.95
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
}

- (void)resetZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
}

- (void)refreshImageView
{
    _imageView.image = _originalImage;
    
    [self resetImageViewFrame:NO];
    [self resetZoomScaleWithAnimated:NO];
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (BOOL)shouldAutorotate
{
    return (_currentTool == nil);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return (_currentTool == nil
            ? UIInterfaceOrientationMaskAll
            : (UIInterfaceOrientationMask)[UIApplication sharedApplication].statusBarOrientation);
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self resetImageViewFrame:NO];
    [self refreshToolSettings];
    [self scrollViewDidZoom:_scrollView];
    
    if (STATUS_BAR_BIGGER_THAN_20) {
        _rightBottombutton.frame = CGRectMake(_rightBottombutton.frame.origin.x, _rightBottombutton.frame.origin.y + 10, _rightBottombutton.frame.size.width, _rightBottombutton.frame.size.height);
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [[CLImageEditorTheme theme] statusBarStyle];
}

#pragma mark- Tool actions
// 如果工具不一样的话 就切换工具菜单
- (void)setCurrentTool:(CLImageToolBase *)currentTool
{
    
    if (self.editBaseView == nil) {
        [self creatEditBaseView];
    }
    // 如果有此view就不在
    if (currentTool != _currentTool) {
//        [_CLEmoticonView setActiveEmoticonView:nil];
//         [_CLTextView setActiveTextView:nil];
//        [_currentTool cleanup]; //处理上个编辑工具
//        _currentTool = currentTool;
    }
   

    
   // if(currentTool != _currentTool ){
        [_currentTool cleanup]; //处理上个编辑工具
        _currentTool = currentTool;
        [_currentTool setup];
        
        [self swapToolBarWithEditing:(_currentTool!=nil)];
    if (![currentTool isKindOfClass:[CLTextTool class]]) {
        [self.view addSubview:_bgView2]; // 再添加一遍否则会被覆盖
    }
    if ([currentTool isKindOfClass:[CLRotateTool class]]
        || [currentTool isKindOfClass:[CLClippingTool class]]) {
        [_rightBottombutton setTitle:@"确定" forState:UIControlStateNormal];
        _rightBottombutton.backgroundColor = [UIColor greenColor];
    }
    else {
        _rightBottombutton.backgroundColor = [UIColor colorWithRed:53/255.0 green:168/255.0 blue:245/255.0 alpha:1];
    }
    // 只要有点击操作 就不隐藏
    _menuView.hidden = NO;
    _currentTool.menuView.hidden = NO;
    _buttonBacgroudView.hidden = NO;
    

    [self resetImageViewFrame:NO];
    
    

    NSLog(@"editBaseframe:%f",self.editBaseView.frame.origin.y);
   // }
}

// 询问delegate是否允许手势接收者接收一个touch对象
// 返回YES，则允许对这个touch对象审核，NO，则不允许。
// 这个方法在touchesBegan:withEvent:之前调用，为一个新的touch对象进行调用
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@" 输出点击的view的类名%@", NSStringFromClass([touch.view class]));
    NSLog(@" 输出点击的view的Tag:%ld", touch.view.tag);
    if (touch.view.tag == 200) {
        
        return NO; // 使表情拖动能起作用
    }
    return YES;
}
// 询问一个手势接收者是否应该开始解释执行一个触摸接收事件
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    
    return YES;
}
// 询问delegate，两个手势是否同时接收消息，返回YES同事接收。返回NO，不同是接收（如果另外一个手势返回YES，则并不能保证不同时接收消息）the default implementation returns NO。
// 这个函数一般在一个手势接收者要阻止另外一个手势接收自己的消息的时候调用
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    
    return NO;
}

#pragma mark- Menu actions

- (void)swapMenuViewWithEditing:(BOOL)editing
{
//    [UIView animateWithDuration:kCLImageToolAnimationDuration
//                     animations:^{
//                         if(editing){// 让底部菜单切换
//                             //_menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-_menuView.top);
//                         }
//                         else{
//                             _menuView.transform = CGAffineTransformIdentity;
//                         }
//                     }
//     ];
}

- (void)swapNavigationBarWithEditing:(BOOL)editing
{
    if(self.navigationController==nil){
        return;
    }
    
    if(editing){
        //_navigationBar.hidden = YES; // no
        _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -self.navigationController.navigationBar.height-20);
                             _navigationBar.transform = CGAffineTransformIdentity;
                         }
         ];
    }
    else{
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
                             _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
                         }
                         completion:^(BOOL finished) {
                             _navigationBar.hidden = NO; // yes隐藏的话 会变透明
                             _navigationBar.transform = CGAffineTransformIdentity;
                         }
         ];
    }
}
// 点击切换导航和底部菜单栏
- (void)swapToolBarWithEditing:(BOOL)editing
{
//    [self swapMenuViewWithEditing:editing];
//    [self swapNavigationBarWithEditing:editing];
//    // 判断是否要编辑图片
//    if(self.currentTool){
//       // [sureOrFinishButton setTitle:@"确定" forState:UIControlStateNormal];
//        // 获取工具的title self.currentTool.toolInfo.title
////        UINavigationItem *item  = [[UINavigationItem alloc] initWithTitle:@""];
////        item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[CLImageEditorTheme localizedString:@"CLImageEditor_OKBtnTitle" withDefault:@"OK"] style:UIBarButtonItemStyleDone target:self action:@selector(pushedDoneBtn:)];
////        item.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:[CLImageEditorTheme localizedString:@"CLImageEditor_BackBtnTitle" withDefault:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(pushedCancelBtn:)];
//        
//        //[_navigationBar pushNavigationItem:item animated:(self.navigationController==nil)];
//    }
//    else{
//        //[_navigationBar popNavigationItemAnimated:(self.navigationController==nil)];
//    }
}
// 点击某个工具触发的方法
- (void)setupToolWithToolInfo:(CLImageToolInfo*)info
{
    //if(self.currentTool){ return; }
    NSLog(@"setupToolWithToolInfo:%f",self.editBaseView.frame.origin.y);
    Class toolClass = NSClassFromString(info.toolName);
    // 加载过得view 就不让再加载
    for (int i = 0; i < self.toolArray.count; i++) {
        CLImageToolBase *tool =[self.toolArray objectAtIndex:i];
        if ([info.toolName isEqualToString:tool.toolInfo.toolName]) {
            self.currentTool = tool;
            return;
        }
    }
    //_menuView.height = 80;
    if(toolClass){
        id instance = [toolClass alloc];
        if(instance!=nil && [instance isKindOfClass:[CLImageToolBase class]]){
            
            // 每次点击都初始化工具 是不是可以
            instance = [instance initWithImageEditor:self withToolInfo:info];
            
            self.currentTool = instance;
            __weak __typeof(self)weakSelf = self;
            
            // 用于点击确定emotion表情时回调 
            _currentTool.EditEmotionFinshBlock = ^(BOOL isClickSureButton) {
                if (isClickSureButton) {
                    [weakSelf pushedDoneBtn:nil];
                }
            };
        }
        if(instance!=nil){
            [self.toolArray addObject:instance];
        }
    }
}
// 点击某个工具触发的方法
- (void)tappedMenuView:(UITapGestureRecognizer*)sender
{
     NSLog(@"tappedMenuView:%f",self.editBaseView.frame.origin.y);
    UIView *view = sender.view;
    
    // 是不是切换编辑按钮的时候，就触发一下确定按钮 是不是判断一下是否存在这个view,,如果存在的话，就把这个veiw放到最上面？？？
//    if (self.currentTool) {
//        [self pushedDoneBtn:@"1"];
//    }
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
    [self setupToolWithToolInfo:view.toolInfo];
}
// 编辑中 返回
- (IBAction)pushedCancelBtn:(id)sender
{
    _imageView.image = _originalImage;
    [self resetImageViewFrame:NO];
    
    self.currentTool = nil;
}
// 编辑中 确定
- (IBAction)pushedDoneBtn:(id)sender
{
    self.view.userInteractionEnabled = NO;
    [self buildAllImage:NO];
    [self.currentTool executeWithCompletionBlock:^(UIImage *image, NSError *error, NSDictionary *userInfo) {
        if(error){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
//        else if(image){
//            // 裁剪 旋转
//            if ([self.currentTool isKindOfClass:[CLClippingTool class]]
//                || [self.currentTool isKindOfClass:[CLRotateTool class]]) {
////                _originalImage = image;
////                _imageView.image = image;
//            }
//            
//            [self resetImageViewFrame];
//            
//                self.currentTool = nil;
//        }
//        self.view.userInteractionEnabled = YES;
    }];
}


#pragma mark - 把在一张图上的东西整合到一块

//
- (void)buildAllImage:(BOOL)isSaveAblum{
    //把按钮给消掉
    [_CLEmoticonView setActiveEmoticonView:nil];
    [_CLTextView setActiveTextView:nil];
    //NSMutableArray *tmp = self.toolArray;
    // 发个通知？ 记录老的和新的frame
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
   
   
    // 把裁剪 单拿出来
    for (int i = 0; i < self.toolArray.count; i++) {
        
        id toolclass = [self.toolArray objectAtIndex:i];
        if ([toolclass isKindOfClass:[CLClippingTool class]]) { // 裁剪
            
            _originalImage = [toolclass bulidImage];
            _imageView.image = _originalImage;
            
            // 裁剪过之后 baseEditView需要从新布局才行
            [self.toolArray removeObject:toolclass]; // 把裁剪移除掉 不然再编辑其它的话 会再裁剪的
            
             [dic setValue:NSStringFromCGRect(_editBaseView.frame) forKey:@"oldframe"];
            
            [self resetImageViewFrame:YES];
            
            [dic setValue:NSStringFromCGRect(_editBaseView.frame) forKey:@"newframe"];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"newframe" object: dic];
            
            self.currentTool = nil;
            self.view.userInteractionEnabled = YES;
            
            if (isSaveAblum) {
                [self loadImageFinished:_imageView.image];
            }
            return;
        }
    }
    
    for (int i = 0; i < self.toolArray.count; i++) {
        
        id toolclass = [self.toolArray objectAtIndex:i];
        if ([toolclass isKindOfClass:[CLDrawTool class]] ) {
            _originalImage = [toolclass buildImage];
            _imageView.image = [toolclass buildImage];
            
        }
        else if ([toolclass isKindOfClass:[CLTextTool class]]) {
            _originalImage = [toolclass buildImage:self.imageView.image];
            _imageView.image = [toolclass buildImage:self.imageView.image];
        }
        else if ([toolclass isKindOfClass:[CLBlurTool class]]) { // 模糊
            _originalImage = [toolclass bulidImage]; // 改了image
            _imageView.image = [toolclass bulidImage];
            
        }
        else if ([toolclass isKindOfClass:[CLClippingTool class]]) { // 裁剪
            
            _originalImage = [toolclass bulidImage];
            _imageView.image = [toolclass bulidImage];
            
            // 裁剪过之后 baseEditView需要从新布局才行
            [self.toolArray removeObject:toolclass]; // 把裁剪移除掉 不然再编辑其它的话 会再裁剪的
        }
        else if ([toolclass isKindOfClass:[CLRotateTool class]]) {// 模糊
            _originalImage = [toolclass buildImage:self.imageView.image];
            _imageView.image = [toolclass buildImage:self.imageView.image];
            [self.toolArray removeObject:toolclass];
        }
        else if ([toolclass isKindOfClass:[CLEmoticonTool class]]) {
            _originalImage = [toolclass buildImage:self.imageView.image];
            _imageView.image = [toolclass buildImage:self.imageView.image];
        }
        // 是不是把image 再传到相应点击过的view里面 生成相应的图片的时候 要拿到最新生成的图片才行
       // [self.toolArray removeObject:toolclass];
        [self resetImageViewFrame:NO];
        self.currentTool = nil;
        self.view.userInteractionEnabled = YES;
        
    }
    if (isSaveAblum) {
        [self loadImageFinished:_imageView.image];
        
    }
  
}

- (void)pushedCloseBtn:(id)sender
{
    if(self.targetImageView==nil){
        if([self.delegate respondsToSelector:@selector(imageEditorDidCancel:)]){
            [self.delegate imageEditorDidCancel:self];
        }
        else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else{
        _imageView.image = self.targetImageView.image;
        [self restoreImageView:YES];
    }
}
-(void)clickSend:(UIButton*)button {
    if ([button.titleLabel.text isEqualToString:@"确定"]) {
        [self buildAllImage:NO];
        [_rightBottombutton setTitle:@"发送" forState:UIControlStateNormal];
    }
    else {
        [self buildAllImage:NO];
        [self pushedFinishBtn:nil];
    }
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //dispatch_async(dispatch_get_main_queue(), ^{
    
//        });
//    });
//    
}
// 完成 发送
- (void)pushedFinishBtn:(id)sender
{
    if(self.targetImageView==nil){
        if([self.delegate respondsToSelector:@selector(imageEditor:didFinishEditingWithImage:fileName:)]){
            [self.delegate imageEditor:self didFinishEditingWithImage:_originalImage fileName:self.fileName];
        }
        else if([self.delegate respondsToSelector:@selector(imageEditor:didFinishEdittingWithImage:)]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [self.delegate imageEditor:self didFinishEdittingWithImage:_originalImage];
#pragma clang diagnostic pop
        }
        else if (self.didFinishImageEditBlock) {
            self.didFinishImageEditBlock(_originalImage, self.fileName,self);
        }
        else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else{
        _imageView.image = _originalImage;
        [self restoreImageView:NO];
    }
}

#pragma mark- ScrollView delegate
//告诉代理要缩放那个控件
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
//缩放改变的时候调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _imageView.frame.size.width;
    CGFloat H = _imageView.frame.size.height;
    
    CGRect rct = _imageView.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _imageView.frame = rct;
}

@end
