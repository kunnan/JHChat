//
//  ImRecentModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "ImRecentModel.h"

@implementation ImRecentModel

-(void)setLastdate:(NSDate *)lastdate{
    if([lastdate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)lastdate;
        _lastdate = [LZFormat String2Date:strDate];
    }
    else {
        _lastdate = lastdate;
    }
}

-(void)setAutodownloaddate:(NSDate *)autodownloaddate{
    if([autodownloaddate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)autodownloaddate;
        _autodownloaddate = [LZFormat String2Date:strDate];
    }
    else {
        _autodownloaddate = autodownloaddate;
    }
}

@end
