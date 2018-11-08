//
//  LZEmotionManagerView.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/29.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-19
 Version: 1.0
 Description: 表情视图
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <UIKit/UIKit.h>
#import "EmotionUtil.h"
#import "XLSlideSwitch.h"

@protocol LZEmotionManagerViewDelegate <NSObject>

@optional

/**
 *  点击了表情
 *
 *  @param sender 表情按钮
 */
- (void)didSelecteLZEmotion:(id)sender iconName:(NSString *)iconname emotionText:(NSString *)emotiontext;

/**
 *  点击了删除表情的按钮
 *
 *  @param sender 删除按钮
 */
- (NSString *)didClickLZEmotionDelBtn:(id)sender;

/**
 *  点击了确定按钮
 *
 *  @param sender 确定按钮
 */
- (void)didClickLZEmotionDoneBtn:(id)sender;

@end

@interface LZEmotionManagerView : UIView<UIScrollViewDelegate,XLSlideSwitchDelegate>

@property (nonatomic, assign) id <LZEmotionManagerViewDelegate> delegate;

/**
 *  显示表情的scrollView控件
 */
@property (nonatomic, weak) UIScrollView *emotionScrollView;

/**
 *  显示页码的控件
 */
@property (nonatomic, weak) UIPageControl *emotionPageControl;

/**
 *  显示确定按钮控件
 */
@property (nonatomic, weak) UIButton *emotionSendButton;

/**
 *  显示横向底部选择栏
 */
@property (nonatomic, weak) XLSlideSwitch *slideSwitch;

/**
 *  显示竖向分割线
 */
@property (nonatomic, weak) UIView *emotionVerticalSegmentLine;

/**
 *  确定按钮的背景、文字
 */
@property (nonatomic, strong) NSString *img_done_default;
@property (nonatomic, strong) NSString *img_done_hl;
@property (nonatomic, strong) NSString *img_done_title;
/* 是否改变按钮的颜色 */
@property (nonatomic, assign) BOOL isChangeColor;
/*
 右侧发送按钮文字
 */
@property (nonatomic, strong) NSString *sendtitle;

/**
 *  加载表情
 */
-(void)reloadEmotins;

@end
