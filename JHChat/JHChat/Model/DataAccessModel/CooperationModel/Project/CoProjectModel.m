//
//  CoProjectModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "CoProjectModel.h"

@implementation CoProjectModel

-(void)setPlanbegindate:(NSDate *)planbegindate{
    if([planbegindate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)planbegindate;
        _planbegindate = [LZFormat String2Date:strDate];
    }
    else {
        _planbegindate = planbegindate;
    }
}

-(void)setPlanenddate:(NSDate *)planenddate{
    if([planenddate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)planenddate;
        _planenddate = [LZFormat String2Date:strDate];
    }
    else {
        _planenddate = planenddate;
    }
}


@end
