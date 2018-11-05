//
//  LZUITextView.h
//  LeadingCloud
//
//  Created by dfl on 16/4/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZUITextView : UITextView

@property (nonatomic, strong) UILabel * placeHolderLabel;

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, strong) UIColor * placeholderColor;


/**
 *  检测当输入时改变字体颜色
 *
 *  @param notification 监测
 */
- (void)textChanged:(NSNotification * )notification;
@end

