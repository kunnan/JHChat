//
//  UIAlertView+AlertWithMessage.h
//  LeadingCloud
//
//  Created by MISPT on 15/12/19.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  扩展【AlertView】的展示方法
 */
@interface UIAlertView (AlertWithMessage)

/**
 *  直接显示弹窗消息，无回调，无按钮设置等
 *  @param message 要显示的消息
 */
+(void)alertViewWithMessage:(NSString *)message;

+(void)alertViewWithTitle:(NSString *)Title Message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

@end
