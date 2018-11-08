//
//  CLEmoticonTool.m
//
//  Created by Mokhlas Hussein on 01/02/14.
//  Copyright (c) 2014 iMokhles. All rights reserved.
//  CLImageEditor Author sho yakushiji.
//

#import "CLEmoticonTool.h"

#import "CLCircleView.h"


static NSString* const kCLEmoticonToolEmoticonPathKey = @"EmoticonPath";
static NSString* const kCLEmoticonToolDeleteIconName = @"deleteIconAssetsName";

//@interface _CLEmoticonView : UIView
//+ (void)setActiveEmoticonView:(_CLEmoticonView*)view;
//- (UIImageView*)imageView;
//- (id)initWithImage:(UIImage *)image tool:(CLEmoticonTool*)tool;
//- (void)setScale:(CGFloat)scale;
//
//
//@end


@interface CLEmoticonTool ()
{
    _CLEmoticonView *emoticonView;
    BOOL isRepeatUpdataFrame;
}
@property (nonatomic,strong) UIView *workingView;
@end
@implementation CLEmoticonTool
{
    UIImage *_originalImage;
    
    //UIView *_workingView;
    
    UIScrollView *_menuScroll;
    
    LZEmotionManagerView *emotionManagerView;
}
-(UIView *)workingView {
    if (_workingView == nil) {
        _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    }
    return _workingView;
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return [CLImageEditorTheme localizedString:@"CLEmoticonTool_DefaultTitle" withDefault:@"Emoticons"];
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 0.6;//7
}

#pragma mark- optional info

+ (NSString*)defaultEmoticonPath
{
    return [[[CLImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Emoticons", NSStringFromClass(self)]];
}

+ (NSDictionary*)optionalInfo
{
    return @{
             kCLEmoticonToolEmoticonPathKey:[self defaultEmoticonPath],
             kCLEmoticonToolDeleteIconName:@"",
             };
}

#pragma mark- implementation

- (void)setup
{
    _originalImage = self.editor.imageView.image;
    
  //  [self.editor fixZoomScaleWithAnimated:YES];
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    //[self.editor.view addSubview:_menuScroll];
    
    // 显示表情的view
   //_workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    self.editor.editBaseView.clipsToBounds = YES;
    self.editor.editBaseView.userInteractionEnabled = YES;
    self.editor.imageView.userInteractionEnabled = YES;
    //self.editor.editBaseView.frame = [self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview];
    //[self.editor.view addSubview:self.editor.editBaseView];
    
    
    [self.editor.view addSubview:self.editor.menuView]; // 再添加 一下让编辑栏 放到最前面 以免画布给挡着
    
    [self setEmoticonMenu];
    
//    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
//    [UIView animateWithDuration:kCLImageToolAnimationDuration
//                     animations:^{
//                         _menuScroll.transform = CGAffineTransformIdentity;
//                     }];
}

- (void)cleanup
{
    [self.editor resetZoomScaleWithAnimated:YES];
    
    //[_workingView removeFromSuperview];
    [emotionManagerView removeFromSuperview];// 返回时要把表情c菜单给请掉
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    [_CLEmoticonView setActiveEmoticonView:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark-

- (void)setEmoticonMenu
{
    emotionManagerView = [[LZEmotionManagerView alloc] initWithFrame:CGRectMake(0, LZ_SCREEN_HEIGHT, LZ_SCREEN_WIDTH, KeyBoard_PhoneHeight)];
    emotionManagerView.isChangeColor = YES;
    emotionManagerView.sendtitle=LZGDCommonLocailzableString(@"common_confirm");
    [emotionManagerView.emotionSendButton setBackgroundColor:[UIColor colorWithRed:53/255.0 green:168/255.0 blue:244/255.0 alpha:1.000]];
    [emotionManagerView.emotionSendButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.000] forState:UIControlStateNormal];
    [emotionManagerView reloadEmotins];
    emotionManagerView.delegate = self;
    [self.editor.view addSubview:emotionManagerView];
    [self showEmotion];
    
    
//    CGFloat W = 70;
//    CGFloat H = _menuScroll.height;
//    CGFloat x = 0;
//    
//    NSString *EmoticonPath = self.toolInfo.optionalInfo[kCLEmoticonToolEmoticonPathKey];
//    if(EmoticonPath==nil){ EmoticonPath = [[self class] defaultEmoticonPath]; }
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    NSError *error = nil;
//    NSArray *list = [fileManager contentsOfDirectoryAtPath:EmoticonPath error:&error];
//    
//    for(NSString *path in list){
//        NSString *filePath = [NSString stringWithFormat:@"%@/%@", EmoticonPath, path];
//        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//        if(image){
//            CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedEmoticonPanel:) toolInfo:nil];
//            view.iconImage = [image aspectFit:CGSizeMake(50, 50)];
//            view.userInfo = @{@"filePath" : filePath};
//            
//            [_menuScroll addSubview:view];
//            x += W;
//        }
//    }
//    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}
-(void)showEmotion{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        emotionManagerView.frame=CGRectMake(0, LZ_SCREEN_HEIGHT-KeyBoard_PhoneHeight, LZ_SCREEN_WIDTH, KeyBoard_PhoneHeight);
    } completion:^(BOOL finished) {
        
        
    }];
}
-(void)hiddenEmotionView{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        emotionManagerView.frame=CGRectMake(0, LZ_SCREEN_HEIGHT, LZ_SCREEN_WIDTH, KeyBoard_PhoneHeight);
        
    } completion:^(BOOL finished) {
       
        
    }];
     //self.editor.rightBottombutton.hidden = NO;
    
}
#pragma mark - emotion 表情点击代理
-(void)didSelecteLZEmotion:(id)sender iconName:(NSString *)iconname emotionText:(NSString *)emotiontext {
    emoticonView = [[_CLEmoticonView alloc] initWithImage:[UIImage imageNamed:iconname] tool:self];
    CGFloat ratio = MIN( (0.5 * self.editor.editBaseView.width) / emoticonView.width, (0.5 * self.editor.editBaseView.height) / emoticonView.height);
    [emoticonView setScale:ratio];
//    emoticonView.autoresizingMask = UIViewAutoresizingNone;
//    emoticonView.autoresizesSubviews  = NO;
    // 默认给中间
    emoticonView.center = CGPointMake(self.editor.editBaseView.width/2, self.editor.editBaseView.height/2);
    
    [self.editor.editBaseView addSubview:emoticonView];
    [_CLEmoticonView setActiveEmoticonView:emoticonView];

    NSLog(@"oldemotionframe:%@",NSStringFromCGRect(emoticonView.frame));
    
    emoticonView.alpha = 0.2;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClipingNewFrame:) name:@"newframe" object:nil];
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                 animations:^{
                     emoticonView.alpha = 1;
                 }
 
    
     ];
//    UIPanGestureRecognizer *panGuest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
//    panGuest.delegate = (id) self.editor;
//    [view.imageView addGestureRecognizer:panGuest];
    
     [self hiddenEmotionView];

}
#pragma mark - 得到新的frame
-(void)getClipingNewFrame:(NSNotification*)notification {
    NSLog(@"emotionframe:%@",NSStringFromCGRect(emoticonView.frame));
//    if ([notification.name isEqualToString:@"newframe"] ) {
//        NSMutableDictionary *dic = notification.object;
//        CGRect rectOld = CGRectFromString([dic lzNSStringForKey:@"oldframe"]);
//        CGRect rectNew = CGRectFromString([dic lzNSStringForKey:@"newframe"]);
//        CGRect newimagerect;
//        if ([dic.allKeys containsObject:@"imageframe"]) {
//            newimagerect = CGRectFromString([dic lzNSStringForKey:@"imageframe"]);
//        }
//        else {
////            // 得出 裁剪多少
//            CGFloat centerW =rectOld.size.width - rectNew.size.width;
//            CGFloat centerH = rectOld.size.height - rectNew.size.height;
//            CGFloat viewX= rectOld.origin.x - rectNew.origin.x;
//            CGFloat viewY = rectOld.origin.y - rectNew.origin.y;
//
//            NSLog(@"juyoujuzuo:%f,%f,%f,%f", emoticonView.top,emoticonView.left,emoticonView.right,emoticonView.bottom);
          
            
//            emoticonView.top =  emoticonView.top - viewY;
//            emoticonView.left = emoticonView.left - centerW;
//            emoticonView.right = emoticonView.right + centerW;
//            emoticonView.bottom = emoticonView.bottom + centerH;
            
//
//            NSLog(@"juyoujuzuo:%f,%f,%f,%f", emoticonView.top,emoticonView.left,emoticonView.right,emoticonView.bottom);
//            // 更新frame
//            // emoticonView.frame = CGRectMake(emoticonView.frame.origin.x + centerW +viewX, emoticonView.frame.origin.y + centerH+viewY, emoticonView.width, emoticonView.height);
//            //emoticonView.center = CGPointMake(emoticonView.centerX + centerW, emoticonView.centerY + centerH);
//
//            NSLog(@"emotionframe:%@",NSStringFromCGRect(emoticonView.frame));
            
//        }
//
//
//    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didClickLZEmotionDoneBtn:(id)sender{
    // 应当是走和右上角确定键走的一样  不让其走确定的方法了
//    if (self.EditEmotionFinshBlock) {
//        self.EditEmotionFinshBlock(YES);
//    }
    [self hiddenEmotionView];
}
// 点击表情
- (void)tappedEmoticonPanel:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    
    NSString *filePath = view.userInfo[@"filePath"];
    if(filePath){
        _CLEmoticonView *view = [[_CLEmoticonView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath] tool:self];
        CGFloat ratio = MIN( (0.5 * self.editor.editBaseView.width) / view.width, (0.5 * self.editor.editBaseView.height) / view.height);
        [view setScale:ratio];
        view.center = CGPointMake(self.editor.editBaseView.width/2, self.editor.editBaseView.height/2);
        
        [self.editor.editBaseView addSubview:view];
        [_CLEmoticonView setActiveEmoticonView:view];
    }
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
}

- (UIImage*)buildImage:(UIImage*)image
{
    [_CLEmoticonView setActiveEmoticonView:nil];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [image drawAtPoint:CGPointZero];
    
    CGFloat scale = image.size.width / self.editor.editBaseView.width;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [self.editor.editBaseView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self hiddenEmotionView];
    return tmp;
}

@end
@interface _CLEmoticonView ()<UIGestureRecognizerDelegate>

@end

@implementation _CLEmoticonView
{
    UIImageView *_imageView;
    UIButton *_deleteButton;
    CLCircleView *_circleView;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}

+ (void)setActiveEmoticonView:(_CLEmoticonView*)view
{
    static _CLEmoticonView *activeView = nil;
    if(view != activeView){
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
}

- (id)initWithImage:(UIImage *)image tool:(CLEmoticonTool*)tool
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width+68, image.size.height+68)];
    if(self){
        
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.layer.borderColor = [[UIColor blackColor] CGColor];
        _imageView.layer.cornerRadius = 3;
        _imageView.center = self.center;
        _imageView.tag = 200;
        [self addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
        [_deleteButton setImage:[tool imageForKey:kCLEmoticonToolDeleteIconName defaultImageName:@"btn_delete.png"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        //_deleteButton.center = _imageView.frame.origin;
        _deleteButton.alpha = 0.5;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _circleView = [[CLCircleView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) , CGRectGetMaxY(_imageView.frame), 32, 32)];
       // _circleView.center = CGPointMake(_imageView.width + _imageView.left, _imageView.height + _imageView.top);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.radius = 0.7;
        _circleView.alpha = 0.5;
        _circleView.color = [UIColor whiteColor];
        _circleView.borderColor = [UIColor blackColor];
        _circleView.borderWidth = 5;
        [self addSubview:_circleView];
        
        _scale = 1;
        _arg = 0;
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
   
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
    
    UIPanGestureRecognizer *panGuest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
    panGuest.delegate = self;
    [_imageView addGestureRecognizer:panGuest];
}
//// 询问delegate是否允许手势接收者接收一个touch对象
//// 返回YES，则允许对这个touch对象审核，NO，则不允许。
//// 这个方法在touchesBegan:withEvent:之前调用，为一个新的touch对象进行调用
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    
//    NSLog(@" 输出点击的view的类名%@", NSStringFromClass([touch.view class]));
//    if (touch.view.tag == 200) {
//        NSLog(@" 输出点击的view的Tag:%ld", touch.view.tag);
//        return YES;
//    }
//    return NO;
//}
//// 询问一个手势接收者是否应该开始解释执行一个触摸接收事件
//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    
//    
//    return YES;
//}
//// 询问delegate，两个手势是否同时接收消息，返回YES同事接收。返回NO，不同是接收（如果另外一个手势返回YES，则并不能保证不同时接收消息）the default implementation returns NO。
//// 这个函数一般在一个手势接收者要阻止另外一个手势接收自己的消息的时候调用
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    
//    
//    return NO;
//}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    return view;
}

- (UIImageView*)imageView
{
    return _imageView;
}

- (void)pushedDeleteBtn:(id)sender
{
    _CLEmoticonView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[_CLEmoticonView class]]){
            nextTarget = (_CLEmoticonView*)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[_CLEmoticonView class]]){
                nextTarget = (_CLEmoticonView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveEmoticonView:nextTarget];
    [self removeFromSuperview];
}

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _circleView.hidden = !active;
    _imageView.layer.borderWidth = (active) ? 1/_scale : 0;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _imageView.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_imageView.height + 32)) / 2;
    rct.size.width  = _imageView.width + 32;
    rct.size.height = _imageView.height + 32;
    self.frame = rct;
    
    _imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _imageView.layer.borderWidth = 1/_scale;
    _imageView.layer.cornerRadius = 3/_scale;
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    [[self class] setActiveEmoticonView:self];
}
// 拖动
- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveEmoticonView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    [self setScale:MAX(_initialScale * R / tmpR, 0.2)];
}

@end
