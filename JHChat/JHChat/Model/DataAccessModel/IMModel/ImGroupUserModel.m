//
//  ImGroupUserModel.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "ImGroupUserModel.h"

@implementation ImGroupUserModel

-(void)setJointime:(NSDate *)jointime{
    if([jointime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)jointime;
        _jointime = [LZFormat String2Date:strDate];
    }
    else {
        _jointime = jointime;
    }
}

@end
