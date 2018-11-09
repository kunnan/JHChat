//
//  PostPromptModel.m
//  LeadingCloud
//
//  Created by wang on 16/3/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "PostPromptModel.h"

@implementation PostPromptModel


-(void)setCreatedate:(NSDate *)createdate{
    if([createdate isKindOfClass:[NSString class]]){
        NSString *strUpdateDate = (NSString *)createdate;
        _createdate = [LZFormat String2Date:strUpdateDate];
    }
    else {
        _createdate = createdate;
    }
    
}

@end
