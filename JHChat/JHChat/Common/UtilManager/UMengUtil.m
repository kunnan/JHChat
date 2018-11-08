//
//  UMengUtil.m
//  LeadingCloud
//
//  Created by wchMac on 2018/3/13.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "UMengUtil.h"

@implementation UMengUtil

+ (void)beginLogPageView:(NSString *)pageName{
    if([LZUserDataManager readIsGayScaleUser]){
        return;
    }
    [MobClick beginLogPageView:pageName];
}

+ (void)endLogPageView:(NSString *)pageName{
    if([LZUserDataManager readIsGayScaleUser]){
        return;
    }
    [MobClick endLogPageView:pageName];
}

@end
