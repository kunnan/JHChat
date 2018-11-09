//
//  OrgUserIntervateModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "OrgUserIntervateModel.h"

@implementation OrgUserIntervateModel

-(void)setIntervatedate:(NSDate *)intervatedate{
    if([intervatedate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)intervatedate;
        _intervatedate = [LZFormat String2Date:strDate];
    }
    else {
        _intervatedate = intervatedate;
    }
}

-(void)setActiondate:(NSDate *)actiondate{
    if([actiondate isKindOfClass:[NSString class]]){
        NSString *strDate=(NSString *)actiondate;
        _actiondate=[LZFormat String2Date:strDate];
    }else{
        _actiondate=actiondate;
    }
}

@end
