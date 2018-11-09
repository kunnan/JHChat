//
//  UIActivityViewController+Private.m
//  LeadingCloud
//
//  Created by SY on 2017/7/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
// 重写分享面板

#import "UIActivityViewController+Private.h"
#import "AppUtils.h"


@implementation UIActivityViewController (Private)



-(BOOL)_shouldExcludeActivityType:(UIActivity *)activity {
    /* 长按图片分享隐藏自己的app */
   NSString *isshowApp = [[NSUserDefaults standardUserDefaults] objectForKey:@"isshare"];
    NSString *suitName = nil;
    if ([AppUtils CheckIsAppStoreVersion]) {
        suitName = @"com.leading.leadingcloud.share";
    }
    else {
        suitName = @"com.leading.leadingcloud.EE.share";
    }
    
    if ([activity.activityType isEqualToString:suitName] && [isshowApp isEqualToString:@"1"])
    {
        //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isshare"];
       
        return YES;// 分享面板中隐藏自己的app
    }
   
    
    return NO;
}
@end
