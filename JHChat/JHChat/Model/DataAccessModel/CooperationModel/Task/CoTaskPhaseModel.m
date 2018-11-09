//
//  CoTaskPhaseModel.m
//  LeadingCloud
//
//  Created by wang on 16/2/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoTaskPhaseModel.h"

@implementation CoTaskPhaseModel

-(void)setDatelimit:(NSDate *)datelimit{
    
    if([datelimit isKindOfClass:[NSString class]]){
        NSString *strUpdateDate = (NSString *)datelimit;
        _datelimit = [LZFormat String2Date:strUpdateDate];
    }
    else {
        _datelimit = datelimit;
    }

}
@end
