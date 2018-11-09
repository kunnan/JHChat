//
//  OrgPostModel.m
//  LeadingCloud
//
//  Created by dfl on 16/11/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "OrgPostModel.h"

@implementation OrgPostModel


-(void)setCreatetime:(NSDate *)createtime{
    if([createtime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)createtime;
        _createtime = [LZFormat String2Date:strDate];
    }
    else {
        _createtime = createtime;
    }
}

-(void)setUpdatetime:(NSDate *)updatetime{
    if([updatetime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)updatetime;
        _updatetime = [LZFormat String2Date:strDate];
    }
    else {
        _updatetime = updatetime;
    }
}

@end
