//
//  SelfAppModel.m
//  LeadingCloud
//
//  Created by dfl on 17/4/13.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "SelfAppModel.h"

@implementation SelfAppModel

-(void)setCreatetime:(NSDate *)createtime{
    if([createtime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)createtime;
        _createtime = [LZFormat String2Date:strDate];
    }
    else {
        _createtime = createtime;
    }
}
@end
