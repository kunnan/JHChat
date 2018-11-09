//
//  UserModel.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/3.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(void)setBirthday:(NSDate *)birthday{
    if([birthday isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)birthday;
        _birthday = [LZFormat String2Date:strDate];
    }
    else {
        _birthday = birthday;
    }
}

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
