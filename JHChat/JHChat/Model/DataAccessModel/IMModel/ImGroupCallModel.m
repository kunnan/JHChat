//
//  ImGroupCallModel.m
//  LeadingCloud
//
//  Created by gjh on 2017/8/4.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "ImGroupCallModel.h"

@implementation ImGroupCallModel


- (void)setStarttime:(NSDate *)starttime {
    if ([starttime isKindOfClass:[NSString class]]) {
        NSString *strDate = (NSString *)starttime;
        _starttime = [LZFormat String2Date:strDate];
    } else {
        _starttime = starttime;
    }
}

-(void)setUpdatetime:(NSDate *)updatetime {
    if ([updatetime isKindOfClass:[NSString class]]) {
        NSString *strDate = (NSString *)updatetime;
        _updatetime = [LZFormat String2Date:strDate];
    } else {
        _updatetime = updatetime;
    }
}


@end
