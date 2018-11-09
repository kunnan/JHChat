//
//  OrgBasePostModel.m
//  LeadingCloud
//
//  Created by dfl on 2017/6/16.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "OrgBasePostModel.h"

@implementation OrgBasePostModel

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
