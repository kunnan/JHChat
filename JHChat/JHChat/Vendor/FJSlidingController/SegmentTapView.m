//
//  SegmentTapView.m
//  SegmentTapView
//
//  Created by fujin on 15/6/20.
//  Copyright (c) 2015年 fujin. All rights reserved.
//
#import "SegmentTapView.h"
#define DefaultTextNomalColor [UIColor blackColor]
#define DefaultTextSelectedColor [UIColor redColor]
#define DefaultLineColor [UIColor redColor]
#define DefaultTitleFont 15
#define LineHeigh 1
@interface SegmentTapView ()
@property (nonatomic, strong)NSMutableArray *buttonsArray;
@property (nonatomic, strong)UIImageView *lineImageView;
@end
@implementation SegmentTapView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        _buttonsArray = [[NSMutableArray alloc] init];
        
        //默认
        _textNomalColor    = DefaultTextNomalColor;
        _textSelectedColor = DefaultTextSelectedColor;
        _lineColor = DefaultLineColor;
        _titleFont = DefaultTitleFont;
        
    }
    return self;
}

-(void)addSubSegmentView
{
    [self.buttonsArray removeAllObjects];
    float width = self.frame.size.width / _dataArray.count;
    
    for (int i = 0 ; i < _dataArray.count ; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, self.frame.size.height)];
        button.tag = i+1;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[_dataArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:self.textNomalColor    forState:UIControlStateNormal];
        [button setTitleColor:self.textSelectedColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:_titleFont];
        
        [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        //默认第一个选中
        if (i == 0) {
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
        
        [self.buttonsArray addObject:button];
        [self addSubview:button];
        
    }
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-LineHeigh, width, LineHeigh)];
    self.lineImageView.backgroundColor = _lineColor;
    [self addSubview:self.lineImageView];
    
}

-(void)tapAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    __weak SegmentTapView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
       weakSelf.lineImageView.frame = CGRectMake(button.frame.origin.x, weakSelf.frame.size.height-LineHeigh, button.frame.size.width, LineHeigh);
    }];
    for (UIButton *subButton in self.buttonsArray) {
        if (button == subButton) {
            subButton.selected = YES;
        }
        else{
            subButton.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:button.tag -1];
    }
}
-(void)selectIndex:(NSInteger)index
{
    for (UIButton *subButton in self.buttonsArray) {
        if (index != subButton.tag) {
            subButton.selected = NO;
        }
        else{
            __weak SegmentTapView *weakSelf = self;
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.lineImageView.frame = CGRectMake(subButton.frame.origin.x, weakSelf.frame.size.height-LineHeigh, subButton.frame.size.width, LineHeigh);
            } completion:^(BOOL finished) {
                subButton.selected = YES;
            }];
        }
    }
}
#pragma mark -- set
-(void)setDataArray:(NSArray *)dataArray{
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
        [self addSubSegmentView];
    }
}
-(void)setLineColor:(UIColor *)lineColor{
    if (_lineColor != lineColor) {
        self.lineImageView.backgroundColor = lineColor;
        _lineColor = lineColor;
    }
}
-(void)setTextNomalColor:(UIColor *)textNomalColor{
    if (_textNomalColor != textNomalColor) {
        for (UIButton *subButton in self.buttonsArray){
            [subButton setTitleColor:textNomalColor forState:UIControlStateNormal];
        }
        _textNomalColor = textNomalColor;
    }
}
-(void)setTextSelectedColor:(UIColor *)textSelectedColor{
    if (_textSelectedColor != textSelectedColor) {
        for (UIButton *subButton in self.buttonsArray){
            [subButton setTitleColor:textSelectedColor forState:UIControlStateSelected];
        }
        _textSelectedColor = textSelectedColor;
    }
}
-(void)setTitleFont:(CGFloat)titleFont{
    if (_titleFont != titleFont) {
        for (UIButton *subButton in self.buttonsArray){
            subButton.titleLabel.font = [UIFont systemFontOfSize:titleFont] ;
        }
        _titleFont = titleFont;
    }
}
@end
