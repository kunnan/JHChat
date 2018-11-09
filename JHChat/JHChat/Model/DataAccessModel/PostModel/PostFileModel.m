//
//  PostFileModel.m
//  LeadingCloud
//
//  Created by wang on 16/3/8.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "PostFileModel.h"

@implementation PostFileModel

-(void)setUpdatedate:(NSDate *)updatedate{
    if([updatedate isKindOfClass:[NSString class]]){
        NSString *strUpdateDate = (NSString *)updatedate;
        _updatedate = [LZFormat String2Date:strUpdateDate];
    }
    else {
        _updatedate = updatedate;
    }
 
}

@end
