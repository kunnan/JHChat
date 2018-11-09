//
//  JHBaseViewController.h
//  JHChat
//
//  Created by gjh on 2018/11/5.
//  Copyright © 2018 gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCProgressHUD.h"
#import "EventBus.h"
#import "XHFoundationMacro.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBaseViewController : UIViewController<EventSyncSubscriber,EventSyncPublisher>
/* 界面可见时，是否需要刷新数据 */
@property (nonatomic, assign) BOOL isNeedRefreshLZTableViewWhenViewAppear;

@property (strong, nonatomic) NSString *currentUid;

#pragma mark - NavigationController

/**
 *  自定义返回按钮
 *
 *  @param title 左侧返回title
 */
- (void)addCustomDefaultBackButton:(NSString *)title;
- (void)customDefaultBackButtonClick;

//添加返回、关闭按钮
- (void)addCustomDefaultBackButton:(NSString *)title secondTitle:(NSString *)secondtitle;
-(void)customDefaultCloseButtonClick;

/**
 *  根据按钮名称创建ButtonItem
 *  @param buttonName 按钮名称（为空，不创建）
 *  @return Button
 */
-(UIButton *)creaButtonItemWithButtonName:(NSString *)buttonName;

/**
 *  设置右侧导航按钮
 *  @param itemName                 导航按钮名称
 */
-(void)setNavigationItemForRight:(NSString *)itemName;
/**
 *  设置右侧导航按钮
 *  @param size                     导航按钮大小
 *  @param normalImageName          正常状态的图片名称
 *  @param highlightedImageName     高亮状态的图片名称
 */
-(void)setNavigationItemForRightWithSize:(CGSize)size normalImage:(NSString *)normalImageName highlightedImage:(NSString *)highlightedImageName;

/**
 *  在右侧导航按钮点击的时候（子类重写以监听事件）
 */
-(void)onRightNavigationItemClicked;
@end

NS_ASSUME_NONNULL_END
