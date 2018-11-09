//
//  OrgUserModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "OrgUserModel.h"

@implementation OrgUserModel

-(void)setApplytime:(NSDate *)applytime{
    if([applytime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)applytime;
        _applytime = [LZFormat String2Date:strDate];
    }
    else {
        _applytime = applytime;
    }
}

-(void)setJointime:(NSDate *)jointime{
    if([jointime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)jointime;
        _jointime = [LZFormat String2Date:strDate];
    }
    else {
        _jointime = jointime;
    }
}

/* 用户信息Model */
- (UserModel *)userModel
{
    UserModel *userModel = [[UserModel alloc] init];
    [userModel serialization:self.usermodelstr];
    return userModel;
}

@end
