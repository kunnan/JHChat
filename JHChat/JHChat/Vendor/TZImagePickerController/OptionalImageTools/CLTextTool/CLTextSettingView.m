//
//  CLTextSettingView.m
//
//  Created by sho yakushiji on 2013/12/18.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLTextSettingView.h"

#import "UIView+Frame.h"
#import "CLImageEditorTheme.h"
#import "CLColorPickerView.h"
#import "CLFontPickerView.h"
#import "CLCircleView.h"
#pragma mark - 文字颜色选项 view

@interface SelectTextClolorView ()
{
    UIButton *tmpButton;
}
@end

@implementation SelectTextClolorView
//-(void)setDefaultSeletColor:(UIColor *)defaultSeletColor {
//   
//    if (self.textColorDelegate && [self.textColorDelegate respondsToSelector:@selector(textSetting:)]) {
//        [self.textColorDelegate textSetting:defaultSeletColor];
//    }
//}
-(id)initWithFrame:(CGRect)frame delegate:(id)selectTextClolorDelegate {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.textColorDelegate = selectTextClolorDelegate;
        [self creatClolorButton:frame];
    }
    return self;
}
#pragma mark - 创建颜色选择的button
-(void)creatClolorButton:(CGRect)frame {
    
    NSArray *whiteRGB = @[@"249",@"249",@"249"];
    NSArray *blackRGB = @[@"0",@"1",@"3"];
    NSArray *redRGB = @[@"255",@"0",@"33"];
    NSArray *yellowRGB = @[@"254",@"243",@"74"];
    NSArray *greenRGB = @[@"0",@"226",@"66"];
    NSArray *purpleRGB = @[@"139",@"38",@"247"];
    NSArray *blueRGB = @[@"0",@"161",@"249"];
    NSArray *roseRedRGB = @[@"254",@"0",@"248"];
    
    NSMutableArray *colorButtonRGB = [NSMutableArray arrayWithObjects:whiteRGB,blackRGB,redRGB,blueRGB,greenRGB,purpleRGB,yellowRGB,roseRedRGB, nil];
    //NSInteger sep = ((frame.size.height - 6 + 15)*(colorButtonRGB.count-1)) + frame.size.height - 6; // 所有颜色按钮的总长度
    
    //CGFloat X = (self.frame.size.width - sep)/2;
    
    CGFloat W = frame.size.height - 6;
    
    CGFloat buttonAllLen = colorButtonRGB.count* W;
    
    CGFloat allLength = frame.size.width - buttonAllLen;
    CGFloat padding = allLength/(colorButtonRGB.count + 1);

    
    CGFloat X = 0;
    for (int i = 0; i < colorButtonRGB.count; i++) {
        NSArray *colorRGB = nil;
        colorRGB  =[colorButtonRGB objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIColor *color = [UIColor colorWithRed:[colorRGB[0] floatValue]/255.0f  green:[colorRGB[1] floatValue]/255.0f blue:[colorRGB[2] floatValue]/255.0f alpha:1];
        [button setBackgroundColor:color];
        button.tag = i;
        NSLog(@"button是否允许交互：%d",button.isUserInteractionEnabled);
        [button addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
        //[button setImage:[UIImage imageNamed:@"1"] forState:UIControlStateSelected];
        
        button.userInteractionEnabled = YES;
        button.frame = CGRectMake(X + padding, 3, W,W);
        X += padding+W;
        //button.centerY = self.centerY;
        button.layer.cornerRadius = W/2;
        button.layer.masksToBounds = YES;
        button.tag = i;
        if (i == 0) {
            button.width = button.width + 3;
            button.height = button.height + 3;
            button.y = button.y - 3/2;
            //button.centerY = self.centerY;
            button.layer.cornerRadius = ( button.height)/2;
            //设置边框颜色
            button.layer.borderColor = [[UIColor whiteColor] CGColor];
            //设置边框宽度
            button.layer.borderWidth = 1.5f;
            tmpButton = button ;
        }
        
        [self addSubview:button];
        if (button.tag == 2) {
            [self selectColor:button];
        }
        NSLog(@"父视图frame：%@,%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(button.frame));
    }
}
-(void)selectColor:(UIButton*)button {
   UIColor *selectColor = button.backgroundColor;
    self.didSelectColor = button.backgroundColor;
     // 弄个临时变量的button,每次点击要对比button的tag如果一样的话边框不变 否则就把上一个button还原
    if (tmpButton.tag != button.tag) {
        tmpButton.width = tmpButton.width - 3;
        tmpButton.height = tmpButton.height - 3 ;
        tmpButton.y = tmpButton.y + 3/2;
        //tmpButton.centerY = self.centerY;
        tmpButton.layer.cornerRadius = ( tmpButton.height)/2;
        //设置边框宽度
        tmpButton.layer.borderWidth = 0.0f;
        
        button.width = button.width + 3;
        button.height = button.height + 3;
        button.y = button.y - 3/2;
        //button.centerY = self.centerY;
        button.layer.cornerRadius = ( button.height)/2;
        //设置边框颜色
        button.layer.borderColor = [[UIColor whiteColor] CGColor];
        //设置边框宽度
        button.layer.borderWidth = 1.5f;
        
        
        tmpButton = button ;
    }
   
    if (self.textColorDelegate && [self.textColorDelegate respondsToSelector:@selector(textSetting:)]) {
        [self.textColorDelegate textSetting:selectColor];
    }
}
@end


@interface CLTextSettingView()
<CLColorPickerViewDelegate, CLFontPickerViewDelegate, UITextViewDelegate,SelectTextClolorDelegate>
@property (nonatomic, strong) UIView *selectedMode;

@end


@implementation CLTextSettingView
{
    UIScrollView *_scrollView;
    
    UITextView *_textView; //
    CLColorPickerView *_colorPickerView;
    CLFontPickerView *_fontPickerView;
    
    UIView *_colorPanel;
    CLCircleView *_fillCircle;
    CLCircleView *_pathCircle;
    UISlider *_pathSlider;
}

- (id)initWithFrame:(CGRect)frame settingViewDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self customInit];
        //[self creatColorPanl:frame];
    }
    return self;
}
//-(void)creatColorPanl:(CGRect)frame {
//      _selectColor = [[SelectTextClolorView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(frame), frame.size.width,26)];
//    _selectColor.backgroundColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.7];
//    self.userInteractionEnabled = YES;
//    [_selectColor creatClolorButton];
//    [self addSubview:_selectColor];
//}
#pragma mark - 设置颜色的盘 是固定的 不行
- (void)setColorPanel
{
    _colorPickerView = [[CLColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 160)];
    _colorPickerView.delegate = self;
    _colorPickerView.center = CGPointMake(_colorPanel.width/2 - 10, _colorPickerView.height/2 - 5);
    [_colorPanel addSubview:_colorPickerView];
    
    _pathSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, _colorPickerView.width*0.8, 34)];
    _pathSlider.center = CGPointMake(_colorPickerView.center.x, _colorPickerView.bottom + 5);
    _pathSlider.minimumValue = 0;
    _pathSlider.maximumValue = 1;
    _pathSlider.value = 0;
    [_pathSlider addTarget:self action:@selector(pathSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [_colorPanel addSubview:_pathSlider];
    
    _pathCircle = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _pathCircle.right = _colorPanel.width - 10;
    _pathCircle.bottom = _pathSlider.center.y;
    _pathCircle.radius = 0.6;
    _pathCircle.borderWidth = 2;
    _pathCircle.borderColor = [UIColor blackColor];
    _pathCircle.color = [UIColor clearColor];
    [_colorPanel addSubview:_pathCircle];
    
    _fillCircle = [[CLCircleView alloc] initWithFrame:_pathCircle.frame];
    _fillCircle.bottom = _pathCircle.top;
    _fillCircle.radius = 0.6;
    [_colorPanel addSubview:_fillCircle];
    
    [_pathCircle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modeViewTapped:)]];
    [_fillCircle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modeViewTapped:)]];
    
    _fillCircle.tag = 0;
    _pathCircle.tag = 1;
    self.selectedMode = _fillCircle;
}

- (void)customInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    [self addSubview:_scrollView];
    
    // 直接显示文字正在编辑文字的view  y = 0 CGRectGetMaxY(_selectColor.frame)
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10,45, self.width-42, 80 - 25)];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_textView];
    
    
    _colorPanel = [[UIView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
    _colorPanel.backgroundColor = [UIColor clearColor];
    //[_scrollView addSubview:_colorPanel];
    //[self setColorPanel];
    
    
    _fontPickerView = [[CLFontPickerView alloc] initWithFrame:CGRectMake(self.width * 2, 0, self.width, self.height)];
    _fontPickerView.delegate = self;
    _fontPickerView.sizeComponentHidden = YES;
    //[_scrollView addSubview:_fontPickerView];
    
    _scrollView.contentSize = CGSizeMake(self.width * 3, self.height);
    
    // 添加文字颜色选项
    _selectColor = [[SelectTextClolorView alloc] initWithFrame:CGRectMake(0, _scrollView.height - 30, _scrollView.width,26) delegate:self];
    _selectColor.defaultSeletColor = @"white";
    [_scrollView addSubview:_selectColor];
   
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 设置字体颜色
- (void)setTextColor:(UIColor*)textColor
{
    _fontPickerView.textColor = textColor;
    _textView.textColor = textColor;
}
#pragma mark  - 处理键盘相应
- (BOOL)isFirstResponder
{
    return _textView.isFirstResponder;
}

- (BOOL)becomeFirstResponder
{
    return [_textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    return [_textView resignFirstResponder];
}

- (void)modeViewTapped:(UITapGestureRecognizer*)sender
{
    self.selectedMode = sender.view;
}

#pragma mark - Properties

- (void)setSelectedMode:(UIView *)selectedMode
{
    if(selectedMode != _selectedMode){
        _selectedMode.backgroundColor = [UIColor clearColor];
        _selectedMode = selectedMode;
        _selectedMode.backgroundColor = [[CLImageEditorTheme theme] toolbarSelectedButtonColor];
        
        if(_selectedMode==_fillCircle){
            _colorPickerView.color = _fillCircle.color;
        }
        else{
            _colorPickerView.color = _pathCircle.borderColor;
        }
    }
}

- (void)setSelectedText:(NSString *)selectedText
{
    _textView.text = selectedText;
}

- (NSString*)selectedText
{
    return _textView.text;
}

- (void)setSelectedFillColor:(UIColor *)selectedFillColor
{
    _fillCircle.color = selectedFillColor;
    
    if(self.selectedMode==_fillCircle){
        _colorPickerView.color = _fillCircle.color;
    }
}

- (UIColor*)selectedFillColor
{
    return _fillCircle.color;
}

- (void)setSelectedBorderColor:(UIColor *)selectedBorderColor
{
    _pathCircle.borderColor = selectedBorderColor;
    
    if(self.selectedMode==_pathCircle){
        _colorPickerView.color = _pathCircle.borderColor;
    }
}

- (UIColor*)selectedBorderColor
{
    return _pathCircle.borderColor;
}

- (void)setSelectedBorderWidth:(CGFloat)selectedBorderWidth
{
    _pathSlider.value = selectedBorderWidth;
}

- (CGFloat)selectedBorderWidth
{
    return _pathSlider.value;
}

- (void)setSelectedFont:(UIFont *)selectedFont
{
    _fontPickerView.font = selectedFont;
}

- (UIFont*)selectedFont
{
    return _fontPickerView.font;
}

- (void)setFontPickerForegroundColor:(UIColor*)foregroundColor
{
    _fontPickerView.foregroundColor = foregroundColor;
}

- (void)showSettingMenuWithIndex:(NSInteger)index animated:(BOOL)animated
{
    [_scrollView setContentOffset:CGPointMake(index * self.width, 0) animated:animated];
}

#pragma mark - keyboard events 对键盘的处理

- (void)keyBoardWillShow:(NSNotification *)notificatioin
{
    
    //获取键盘的高度
    NSDictionary *userInfo = [notificatioin userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    
    [self keyBoardWillChange:notificatioin withTextViewHeight:height ];//height80 - 20
    [_textView scrollRangeToVisible:_textView.selectedRange];
}

- (void)keyBoardWillHide:(NSNotification *)notificatioin
{
    [self keyBoardWillChange:notificatioin withTextViewHeight:self.height - 45];
}

- (void)keyBoardWillChange:(NSNotification *)notificatioin withTextViewHeight:(CGFloat)height
{
    CGRect keyboardFrame = [[notificatioin.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [self.superview convertRect:keyboardFrame fromView:self.window];
     NSLog(@"%f, %f",_selectColor.y,self.height);
    _selectColor.y =  keyboardFrame.origin.y - _selectColor.height - 5;
    NSLog(@"%f,%f",_selectColor.y,self.height);
    // _textView = [[UITextView alloc] initWithFrame:CGRectMake(10,5, self.width-42, self.height - keyboardFrame.size.height - _selectColor.y)];
    //_textView.height = self.height - keyboardFrame.size.height - _selectColor.y;
    //[_scrollView addSubview:_textView];
    
    UIViewAnimationCurve animationCurve = [[notificatioin.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notificatioin.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | (animationCurve<<16)
                     animations:^{
                         //_textView.height = height;
                         _textView.height = height +  _selectColor.height;
                         CGFloat dy = MIN(0, (keyboardFrame.origin.y - _textView.height) - self.top);
                         self.transform = CGAffineTransformMakeTranslation(0, dy);
                     } completion:^(BOOL finished) {
                         
                     }
     ];
}
#pragma mark- Color picker delegate
// 新的改变颜色的代理
-(void)textSetting:(UIColor *)textColor {
    //if(self.selectedMode==_fillCircle){
        _fontPickerView.textColor = textColor;
        _textView.textColor = textColor;
        _fillCircle.color = textColor;
        if([self.delegate respondsToSelector:@selector(textSettingView:didChangeFillColor:)]){
            [self.delegate textSettingView:self didChangeFillColor:textColor];
        }
    //}
}
- (void)colorPickerView:(CLColorPickerView *)picker colorDidChange:(UIColor *)color
{
    if(self.selectedMode==_fillCircle){
        _fillCircle.color = color;
        if([self.delegate respondsToSelector:@selector(textSettingView:didChangeFillColor:)]){
            [self.delegate textSettingView:self didChangeFillColor:color];
        }
    }
    else{
        _pathCircle.borderColor = color;
        if([self.delegate respondsToSelector:@selector(textSettingView:didChangeBorderColor:)]){
            [self.delegate textSettingView:self didChangeBorderColor:color];
        }
    }
}

#pragma mark- PathSlider event

- (void)pathSliderDidChange:(UISlider*)sender
{
    if([self.delegate respondsToSelector:@selector(textSettingView:didChangeBorderWidth:)]){
        [self.delegate textSettingView:self didChangeBorderWidth:_pathSlider.value];
    }
}

#pragma mark- Font picker delegate

- (void)fontPickerView:(CLFontPickerView *)pickerView didSelectFont:(UIFont *)font
{
    if([self.delegate respondsToSelector:@selector(textSettingView:didChangeFont:)]){
        [self.delegate textSettingView:self didChangeFont:font];
    }
}

#pragma mark- UITextView delegate
-(void)textViewDidEndEditing:(UITextView *)textView {
    if (self.isAddText) {
        _fontPickerView.textColor = textView.textColor;
        NSRange selection = textView.selectedRange;
        if(selection.location+selection.length == textView.text.length && [textView.text characterAtIndex:textView.text.length-1] == '\n') {
            [textView layoutSubviews];
            [textView scrollRectToVisible:CGRectMake(0, textView.contentSize.height - 1, 1, 1) animated:YES];
        }
        else {
            [textView scrollRangeToVisible:textView.selectedRange];
        }
        
        if([self.delegate respondsToSelector:@selector(textSettingView:didChangeText:)]){
            [self.delegate textSettingView:self didChangeText:textView.text];
        }
    }
}
- (void)textViewDidChange:(UITextView*)textView
{
//    _fontPickerView.textColor = textView.textColor;
//    NSRange selection = textView.selectedRange;
//    if(selection.location+selection.length == textView.text.length && [textView.text characterAtIndex:textView.text.length-1] == '\n') {
//        [textView layoutSubviews];
//        [textView scrollRectToVisible:CGRectMake(0, textView.contentSize.height - 1, 1, 1) animated:YES];
//    }
//    else {
//        [textView scrollRangeToVisible:textView.selectedRange];
//    }
//    
//    if([self.delegate respondsToSelector:@selector(textSettingView:didChangeText:)]){
//        [self.delegate textSettingView:self didChangeText:textView.text];
//    }
}

@end
