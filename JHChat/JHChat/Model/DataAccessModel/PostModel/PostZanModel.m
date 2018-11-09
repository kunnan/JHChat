//
//  PostZanModel.m
//  LeadingCloud
//
//  Created by wang on 16/3/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "PostZanModel.h"

@implementation PostZanModel

-(void)setPraisedate:(NSDate *)praisedate{
    if([praisedate isKindOfClass:[NSString class]]){
        NSString *strUpdateDate = (NSString *)praisedate;
        _praisedate = [LZFormat String2Date:strUpdateDate];
    }
    else {
        _praisedate = praisedate;
    }
    
}


@end
