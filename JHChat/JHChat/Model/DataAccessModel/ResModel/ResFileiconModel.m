//
//  ResFileiconModel.m
//  LeadingCloud
//
//  Created by gjh on 2017/9/20.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "ResFileiconModel.h"

@implementation ResFileiconModel

/**
 设置添加的时间

 @param addtime 
 */
- (void)setAddtime:(NSDate *)addtime {
    if ([addtime isKindOfClass:[NSString class]]) {
        NSString *strAddTime = (NSString *)addtime;
        _addtime = [LZFormat String2Date:strAddTime];
    } else {
        _addtime = addtime;
    }
}

@end
