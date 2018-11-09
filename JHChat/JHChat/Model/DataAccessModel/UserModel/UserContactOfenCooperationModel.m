//
//  UserContactOfenCooperationModel.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/3.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "UserContactOfenCooperationModel.h"

@implementation UserContactOfenCooperationModel

-(void)setLastdate:(NSDate *)lastdate{
    if([lastdate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)lastdate;
        _lastdate = [LZFormat String2Date:strDate];
    }
    else {
        _lastdate = lastdate;
    }
}

@end
