//
//  CooNewMemberApplyModel.m
//  LeadingCloud
//
//  Created by SY on 16/6/8.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooNewMemberApplyModel.h"

@implementation CooNewMemberApplyModel

-(void)setApplytime:(NSDate *)applytime {
    
    if([applytime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)applytime;
        _applytime = [LZFormat String2Date:strDate];
    }
    else {
        _applytime = applytime;
    }

    
    
}
@end
