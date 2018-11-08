//
//  CLTextSettingView.h
//
//  Created by sho yakushiji on 2013/12/18.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectTextClolorView;
@protocol CLTextSettingViewDelegate;

@protocol SelectTextClolorDelegate <NSObject>

-(void)textSetting:(UIColor*)textColor;

@end
@interface SelectTextClolorView : UIView

-(id)initWithFrame:(CGRect)frame delegate:(id)selectTextClolorDelegate;

-(void)creatClolorButton:(CGRect)frame;
@property (nonatomic, weak) id<SelectTextClolorDelegate> textColorDelegate;
@property (nonatomic, strong) UIColor *didSelectColor;
@property (nonatomic, copy) NSString *defaultSeletColor;


@end



@interface CLTextSettingView : UIView

- (id)initWithFrame:(CGRect)frame settingViewDelegate:(id)delegate;

@property (nonatomic, weak) id<CLTextSettingViewDelegate> delegate;
@property (nonatomic, strong) NSString *selectedText;
@property (nonatomic, strong) UIColor *selectedFillColor;
@property (nonatomic, strong) UIColor *selectedBorderColor;
@property (nonatomic, assign) CGFloat selectedBorderWidth;
@property (nonatomic, strong) UIFont *selectedFont;

@property (nonatomic,assign) BOOL isAddText;

@property (nonatomic, strong) SelectTextClolorView *selectColor;
- (void)setTextColor:(UIColor*)textColor;
- (void)setFontPickerForegroundColor:(UIColor*)foregroundColor;

- (void)showSettingMenuWithIndex:(NSInteger)index animated:(BOOL)animated;

@end



@protocol CLTextSettingViewDelegate <NSObject>
@optional
- (void)textSettingView:(CLTextSettingView*)settingView didChangeText:(NSString*)text;
- (void)textSettingView:(CLTextSettingView*)settingView didChangeFillColor:(UIColor*)fillColor;
- (void)textSettingView:(CLTextSettingView*)settingView didChangeBorderColor:(UIColor*)borderColor;
- (void)textSettingView:(CLTextSettingView*)settingView didChangeBorderWidth:(CGFloat)borderWidth;
- (void)textSettingView:(CLTextSettingView*)settingView didChangeFont:(UIFont*)font;
- (void)KeyBoardWillChange:(CGFloat)y;
@end
