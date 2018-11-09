//
//  ResRecycleModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "ResRecycleModel.h"

@implementation ResRecycleModel

-(void)setDeletedate:(NSDate *)deletedate{
    if([deletedate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)deletedate;
        _deletedate = [LZFormat String2Date:strDate];
    }
    else {
        _deletedate = deletedate;
    }
}

@end
