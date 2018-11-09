//
//  CoMemberModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "CoMemberModel.h"

@implementation CoMemberModel

-(void)setAddtime:(NSDate *)addtime{
    if([addtime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)addtime;
        _addtime = [LZFormat String2Date:strDate];
    }
    else {
        _addtime = addtime;
    }
}

@end
