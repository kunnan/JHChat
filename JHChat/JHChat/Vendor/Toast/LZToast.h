//
//  LZToast.h
//  scanCode
//
//  Created by lz on 15/10/13.
//  Copyright © 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define DEFAULT_DISPLAY_DURATION 2.0f
#define Version_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)

@interface LZToast : NSObject {
    NSString *text;
    UIButton *contentView;
    CGFloat  duration;
}

+ (void)showWithText:(NSString *) text_;
+ (void)showWithText:(NSString *) text_
            duration:(CGFloat)duration_;

+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset_;
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration_;

+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_;
+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_
            duration:(CGFloat) duration_;

@end
