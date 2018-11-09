//
//  CoGroupModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "CoGroupModel.h"

@implementation CoGroupModel

-(void)setCreatetime:(NSDate *)createtime{
    if([createtime isKindOfClass:[NSString class]]){
        NSString *strUpdateDate = (NSString *)createtime;
        _createtime = [LZFormat String2Date:strUpdateDate];
    }
    else {
        _createtime = createtime;
    }
 
}

-(void)setLockdate:(NSDate *)lockdate{
    if([lockdate isKindOfClass:[NSString class]]){
        NSString *strLockdate = (NSString *)lockdate;
        _lockdate = [LZFormat String2Date:strLockdate];
    }
    else {
        _lockdate = lockdate;
    }
    
}

@end


