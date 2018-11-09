//
//  UIActivityViewController+Private.h
//  LeadingCloud
//
//  Created by SY on 2017/7/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActivityViewController (Private)

/**
 重写私有方法(分享面板控制显隐)

 @param activity ShareExtension的BundleId
 @return BOOL
 */
- (BOOL)_shouldExcludeActivityType:(UIActivity*)activity;


@end
