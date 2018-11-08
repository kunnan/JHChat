//
//  CLDrawTool.m
//
//  Created by sho yakushiji on 2014/06/20.
//  Copyright (c) 2014年 CALACULU. All rights reserved.
//

#import "CLDrawTool.h"
#import "CLTextSettingView.h"
static NSString* const kCLDrawToolEraserIconName = @"eraserIconAssetsName";

@interface CLDrawTool ()<SelectTextClolorDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong)  UIImageView *drawingView;
@property (nonatomic, strong) NSMutableArray *drawLineArr; // 记录画的线

@end

@implementation CLDrawTool
{
    CGSize _originalImageSize;
    UIImage *originalImage;
    
    CGPoint _prevDraggingPosition;
    //UIView *_menuView;
    UISlider *_colorSlider;
    UISlider *_widthSlider;
    UIView *_strokePreview;
    UIView *_strokePreviewBackground;
    UIImageView *_eraserIcon;
    
    UIImageView *_grayeraseIcon;
    
    SelectTextClolorView *_selectColor;
    
    CLToolbarMenuItem *_colorBtn;
}
-(NSMutableArray *)drawLineArr {
    if (_drawLineArr == nil) {
        _drawLineArr = [[NSMutableArray alloc] init];
    }
    return _drawLineArr;
}
-(UIImageView *)drawingView {
    if (_drawingView == nil) {
        _drawingView = [[UIImageView alloc] initWithFrame:self.editor.imageView.frame];
    }
    return _drawingView;
}
+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return [CLImageEditorTheme localizedString:@"CLDrawTool_DefaultTitle" withDefault:@"Draw"];
}

+ (BOOL)isAvailable
{
    return YES;
}

+ (CGFloat)defaultDockedNumber
{
    return 0.5;// 4.5
}

#pragma mark- optional info

+ (NSDictionary*)optionalInfo
{
    return @{
             kCLDrawToolEraserIconName : @"",
             };
}

#pragma mark- implementation

- (void)setup
{
    _originalImageSize = self.editor.imageView.image.size;
    originalImage = self.editor.imageView.image;
    //_drawingView = [[UIImageView alloc] initWithFrame:self.editor.imageView.bounds];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidPan:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.delegate = (id)self.editor;
    
    self.editor.editBaseView.userInteractionEnabled = YES;
    
    [self.editor.editBaseView addGestureRecognizer:panGesture];
    
    //self.editor.imageView  点击哪个编辑按钮 就把哪个放到最上面insertSubview:self.drawingView atIndex:self.editor.view.subviews.count - 1
    //[self.editor.view addSubview:self.drawingView];
    self.editor.imageView.userInteractionEnabled = YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1; 
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    
    self.menuView = [[UIView alloc] initWithFrame:self.editor.menuView.frame];
    
    // 修改 编辑菜单
    self.menuView.y = self.editor.menuView.frame.origin.y - self.editor.menuView.frame.size.height - 25;
    self.menuView.height = self.menuView.height + 25;
    self.menuView.width = self.editor.view.width;
    self.menuView.backgroundColor = self.editor.menuView.backgroundColor;
    [self.editor.view insertSubview:self.menuView aboveSubview:self.editor.menuView];
    [self.editor.view addSubview:self.editor.menuView]; // 再添加 一下让编辑栏 放到最前面 以免画布给挡着
    
    [self setMenu];
    
    self.menuView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-self.menuView.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         self.menuView.transform = CGAffineTransformIdentity;
                     }];
    
}
//// 询问delegate是否允许手势接收者接收一个touch对象
//// 返回YES，则允许对这个touch对象审核，NO，则不允许。
//// 这个方法在touchesBegan:withEvent:之前调用，为一个新的touch对象进行调用
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    
//    NSLog(@" 输出点击的view的类名%@", NSStringFromClass([touch.view class]));
//     NSLog(@" 输出点击的view的Tag:%ld", touch.view.tag);
//    if (touch.view.tag == 200 ) {
//        UIImageView *tmpImageView = (UIImageView*)[touch.view class];
//        //NSLog(@" 输出点击的view的Tag:%ld", tmpImageView.tag);
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

- (void)cleanup
{
   // [_drawingView removeFromSuperview]; // 不要移除
    self.editor.imageView.userInteractionEnabled = YES;//NO;

    [self.menuView removeFromSuperview]; // 放到这里 不然点击一次再点击的话 出不来编辑选项
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         self.menuView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-self.menuView.top);
                     }
                     completion:^(BOOL finished) {
                        // [self.menuView removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark-

- (UISlider*)defaultSliderWithWidth:(CGFloat)width
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, width, 15)];
    UIImage *image = [UIImage imageNamed:@"sliderPoint"];
    
    [slider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setThumbImage:image forState:UIControlStateNormal];
    //slider.thumbTintColor = [UIColor whiteColor];
    
    return slider;
}

- (UIImage*)colorSliderBackground
{
    CGSize size = _colorSlider.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect frame = CGRectMake(5, (size.height-10)/2, size.width-10, 5);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:5].CGPath;
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {
        0.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 1.0f, 1.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 0.0f, 1.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        0.0f, 1.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 1.0f
    };
    
    size_t count = sizeof(components)/ (sizeof(CGFloat)* 4);
    CGFloat locations[] = {0.0f, 0.9/3.0, 1/3.0, 1.5/3.0, 2/3.0, 2.5/3.0, 1.0};
    
    CGPoint startPoint = CGPointMake(5, 0);
    CGPoint endPoint = CGPointMake(size.width-5, 0);
    
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, count);
    
    CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (UIImage*)widthSliderBackground
{
    CGSize size = _widthSlider.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = [[[CLImageEditorTheme theme] toolbarTextColor] colorWithAlphaComponent:0.5];
    
    CGFloat strRadius = 1;
    CGFloat endRadius = size.height/2 * 0.6;
    
    CGPoint strPoint = CGPointMake(strRadius + 5, size.height/2 - 2);
    CGPoint endPoint = CGPointMake(size.width-endRadius - 1, strPoint.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, strPoint.x, strPoint.y, strRadius, -M_PI/2, M_PI-M_PI/2, YES);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y + endRadius);
    CGPathAddArc(path, NULL, endPoint.x, endPoint.y, endRadius, M_PI/2, M_PI+M_PI/2, YES);
    CGPathAddLineToPoint(path, NULL, strPoint.x, strPoint.y - strRadius);
    
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    CGPathRelease(path);
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (UIColor*)colorForValue:(CGFloat)value
{
    if(value<1/3.0){
        return [UIColor colorWithWhite:value/0.3 alpha:1];
    }
    return [UIColor colorWithHue:((value-1/3.0)/0.7)*2/3.0 saturation:1 brightness:1 alpha:1];
}

- (void)setMenu
{
    CGFloat W = 60;
    
    _colorSlider = [self defaultSliderWithWidth:self.menuView.width - W - 20];
    _colorSlider.left = 15;
    _colorSlider.top  = 5;
    //[_colorSlider addTarget:self action:@selector(colorSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _colorSlider.backgroundColor = [UIColor colorWithPatternImage:[self colorSliderBackground]];
    _colorSlider.value = 0;
    //[self.menuView addSubview:_colorSlider];
      
    _strokePreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W - 15, W - 15)];
    _strokePreview.layer.cornerRadius = _strokePreview.height/2;
    _strokePreview.layer.borderWidth = 1;
    _strokePreview.tag = 22;
    _strokePreview.layer.borderColor = [[[CLImageEditorTheme theme] toolbarTextColor] CGColor];
    _strokePreview.center = CGPointMake(self.menuView.width-W/2, self.menuView.height/2);
    [self.menuView addSubview:_strokePreview];
    
    _strokePreviewBackground = [[UIView alloc] initWithFrame:_strokePreview.frame];
    _strokePreviewBackground.layer.cornerRadius = _strokePreviewBackground.height/2;
    _strokePreviewBackground.alpha = 0.3;
    _strokePreviewBackground.tag = 22;
    _strokePreviewBackground.backgroundColor = [[CLImageEditorTheme theme] toolbarTextColor];
    [_strokePreviewBackground addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(strokePreviewDidTap:)]];
    [self.menuView insertSubview:_strokePreviewBackground aboveSubview:_strokePreview];
    
    //点击高亮的图片
    _eraserIcon = [[UIImageView alloc] initWithFrame:_strokePreview.frame];
    _eraserIcon.image  = [UIImage imageNamed:@"icon_rubber_blue"] ;
    _eraserIcon.tag = 22;
    _eraserIcon.hidden = YES;
    [self.menuView addSubview:_eraserIcon];
    
    // 再放个正常显示的橡皮擦
    _grayeraseIcon = [[UIImageView alloc] initWithFrame:_strokePreview.frame];
    _grayeraseIcon.image  = [UIImage imageNamed:@"icon_rubber_gray"] ;
    _grayeraseIcon.tag = 22;
    _grayeraseIcon.hidden = NO;
    [self.menuView addSubview:_grayeraseIcon];
    //[self colorSliderDidChange:_colorSlider];
    
    
    _selectColor = [[SelectTextClolorView alloc] initWithFrame:CGRectMake(0, 0,self.menuView.width - W,25) delegate:self];
    [self.menuView addSubview:_selectColor];
    
    _widthSlider = [self defaultSliderWithWidth:_colorSlider.width];
    _widthSlider.left = 10;
    _widthSlider.top = _selectColor.bottom + 15;
    [_widthSlider addTarget:self action:@selector(widthSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _widthSlider.value = 0.1;
    _widthSlider.backgroundColor = [UIColor colorWithPatternImage:[self widthSliderBackground]];
    [self.menuView addSubview:_widthSlider];

    [self widthSliderDidChange:_widthSlider];
    self.menuView.clipsToBounds = NO;
}
#pragma mark - 选颜色代理
-(void)textSetting:(UIColor *)textColor {
    //if(_eraserIcon.hidden){
        _strokePreview.backgroundColor = textColor;
        //_strokePreviewBackground.backgroundColor = textColor;
        _colorSlider.thumbTintColor = _strokePreview.backgroundColor;
   // }
}
//- (void)colorSliderDidChange:(UISlider*)sender
//{
//    if(_eraserIcon.hidden){
//        _strokePreview.backgroundColor = [self colorForValue:_colorSlider.value];
//        _strokePreviewBackground.backgroundColor = _strokePreview.backgroundColor;
//        _colorSlider.thumbTintColor = _strokePreview.backgroundColor;       
//    }
//}

- (void)widthSliderDidChange:(UISlider*)sender
{
    CGFloat scale = MAX(0.05, _widthSlider.value);
    _strokePreview.transform = CGAffineTransformMakeScale(scale, scale);
    _strokePreview.layer.borderWidth = 2/scale;
}

- (void)strokePreviewDidTap:(UITapGestureRecognizer*)sender
{
    self.menuView.hidden = NO;
    self.editor.menuView.hidden = NO;
    self.editor.rightBottombutton.hidden = NO;
    _eraserIcon.hidden = !_eraserIcon.hidden;
    
    if(_eraserIcon.hidden){
        _grayeraseIcon.hidden = NO;
        [self textSetting:_colorSlider.thumbTintColor];
    }
    else{
        _grayeraseIcon.hidden = YES;
        _strokePreview.backgroundColor = [[CLImageEditorTheme theme] toolbarTextColor];
        _strokePreviewBackground.backgroundColor = _strokePreview.backgroundColor;
    }
}

// 画
- (void)drawingViewDidPan:(UIPanGestureRecognizer*)sender
{
    // 在这里可以一直隐藏编辑菜单
    // 记录点击的手势
//    if (sender && ![self.editor.didEditItem containsObject:sender]) {
//        [self.editor.didEditItem addObject:sender];
//    }
    NSLog(@"开始画");
    CGPoint currentDraggingPosition = [sender locationInView:self.editor.editBaseView];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _prevDraggingPosition = currentDraggingPosition;
        
        NSLog(@"_prevDraggingPosition位置：%@",NSStringFromCGPoint(_prevDraggingPosition));
    }
    
    if(sender.state != UIGestureRecognizerStateEnded){
        [self drawLine:_prevDraggingPosition to:currentDraggingPosition lineColor:nil];
        NSLog(@"currentDraggingPosition位置：%@",NSStringFromCGPoint(currentDraggingPosition));
    }
    
    if (sender.state ==  UIGestureRecognizerStateCancelled || sender.state ==  UIGestureRecognizerStateEnded) {
        
    }
    
    _prevDraggingPosition = currentDraggingPosition;
     NSLog(@"_prevDraggingPosition= currentDraggingPosition;位置：%@",NSStringFromCGPoint(_prevDraggingPosition));
}
// 执行划线
-(void)drawLine:(CGPoint)from to:(CGPoint)to lineColor:(UIColor*)lineColor
{
    
    CGSize size = self.editor.editBaseView.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.editor.editBaseView.image drawAtPoint:CGPointZero];
    
    CGFloat strokeWidth = MAX(1, _widthSlider.value * 65);
    UIColor *strokeColor = _strokePreview.backgroundColor;
    
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    if(!_eraserIcon.hidden){
        CGContextSetBlendMode(context, kCGBlendModeClear);
    }
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
    
    self.editor.editBaseView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //[self.editor.didEditItem addObject:];
    UIGraphicsEndImageContext();
    
}

- (UIImage*)buildImage
{
  // UIImage *result = [self.editor.editBaseView.image crop:self.editor.imageView.frame];
    //_originalImageSize--》self.editor.imageView.image.size
//    UIGraphicsBeginImageContextWithOptions(self.editor.imageView.image.size, NO, self.editor.imageView.image.scale);
//    [self.editor.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    [self.editor.editBaseView.image drawInRect:CGRectMake(0, 0, self.editor.imageView.image.size.width, self.editor.imageView.image.size.height)];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
   // return result;
    
    UIGraphicsBeginImageContextWithOptions(self.editor.imageView.image.size, NO, self.editor.imageView.image.scale);
    NSLog(@" 图片大小：%@,%@",NSStringFromCGSize(_originalImageSize),NSStringFromCGSize(self.editor.imageView.image.size));
     //3、绘制图片
    [self.editor.imageView.image drawAtPoint:CGPointZero];
     //3.绘制到图形上下文中 _originalImageSize.width _originalImageSize.height  改改起始位置
    [self.editor.editBaseView.image drawInRect:CGRectMake(0, 0, self.editor.imageView.image.size.width, self.editor.imageView.image.size.height)];

    //4.从上下文中获取图片
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();

    return tmp;
}

@end
