//
//  CooOfNewModel.m
//  LeadingCloud
//
//  Created by SY on 16/3/24.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooOfNewModel.h"

@implementation CooOfNewModel

-(void)setInvitetime:(NSDate *)invitetime {
    if([invitetime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)invitetime;
        _invitetime = [LZFormat String2Date:strDate];
    }
    else {
        _invitetime = invitetime;
    }

}
@end
