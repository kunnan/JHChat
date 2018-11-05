//
//  UIAlertController+AlertWithMessage.h
//  LeadingCloud
//
//  Created by SY on 16/11/21.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertClickBlock)(id successData);
/**
 UIAlertController拓展方法（ios8及以上）
 */
@interface UIAlertController (AlertWithMessage)
/**
 直接显示弹窗消息，无回调，无按钮设置等
 
 @param message    提示消息
 @param controller 哪个控制器要弹框提示
 */
+(void)alertControllerWithMessage:(NSString *)message controller:(UIViewController*)controller;
/**
 自定义提示框
 
 @param title      自定义提示框title
 @param message    要提示的消息
 @param controller 哪个控制器要弹出提示框
 */
+(void)alertControllerWithTitle:(NSString*)title message:(NSString*)message  controller:(UIViewController*)controller;

/**
 复制信息

 @param title title
 @param message message description
 @param controller controller description
 */
+(void)alertControllerPastMessageWithTitle:(NSString*)title message:(NSString*)message  controller:(UIViewController*)controller;
/**
 自定义提示框(title  message actiontitle controller)
 
 @param title      自定义提示框title
 @param message    要提示的消息
 actionWithTitle
 @param controller 哪个控制器要弹出提示框
 */
+(void)alertControllerWithTitle:(NSString*)title message:(NSString*)message actionWithTitleArr:(NSArray*)actiontitle  controller:(UIViewController*)controller alertClickBlock:(AlertClickBlock)clickBlock;

/**
 alert提示框（message居中）

 @param title title description
 @param message message description
 @param actiontitle actiontitle description
 @param controller controller description
 @param clickBlock clickBlock description
 */
+(void)alertControllerWithCenterTitle:(NSString*)title message:(NSString*)message actionWithTitleArr:(NSArray*)actiontitle  controller:(UIViewController*)controller alertClickBlock:(AlertClickBlock)clickBlock;

/**
 底部淡出alert菜单
 */
+(void)alertBottomAlertControllerWithTitle:(NSString*)title message:(NSString*)message actionWithTitleArr:(NSMutableArray*)actiontitle  controller:(UIViewController*)controller alertClickBlock:(AlertClickBlock)clickBlock;
/**
 添加alertcontroller
 
 @param title title description
 @param message message description
 @param actiontitle actiontitle description
 @param controller controller description
 @param alertStyle 0：底部  1:中间
 @param clickBlock clickBlock description
 */
+(void)alertControllerWithTitle:(NSString*)title message:(NSString*)message actionWithTitleArr:(NSMutableArray*)actiontitle  controller:(UIViewController*)controller type:(UIAlertControllerStyle)alertStyle titleAndStyleDic:(NSDictionary*)titleAndStyle alertClickBlock:(AlertClickBlock)clickBlock;
@end
