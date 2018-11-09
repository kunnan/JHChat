//
//  OrgEnterPriseModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "OrgEnterPriseModel.h"
#import "NSString+IsNullOrEmpty.h"

@implementation OrgEnterPriseModel


-(id)init{
    
    
    if (self = [super init]) {
        
        self.logo = @"";
    }
    return self;
}

-(void)setCreatedate:(NSDate *)createdate{
    if([createdate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)createdate;
        _createdate = [LZFormat String2Date:strDate];
    }
    else {
        _createdate = createdate;
    }
}

-(void)setRegdate:(NSDate *)regdate{
    if([regdate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)regdate;
        _regdate = [LZFormat String2Date:strDate];
    }
    else {
        _regdate = regdate;
    }
}



@end
