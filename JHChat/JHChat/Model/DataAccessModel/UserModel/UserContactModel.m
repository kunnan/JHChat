//
//  UserContactModel.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/3.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "UserContactModel.h"

@implementation UserContactModel

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
