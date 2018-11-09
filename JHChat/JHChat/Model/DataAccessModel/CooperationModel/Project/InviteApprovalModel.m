//
//  InviteApprovalModel.m
//  LeadingCloud
//
//  Created by SY on 2017/6/16.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
// 邀请审批对象apimodel

#import "InviteApprovalModel.h"

@implementation InviteApprovalModel
-(void)setInvitetime:(NSDate *)invitetime {
    if([invitetime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)invitetime;
        _invitetime = [LZFormat String2Date:strDate];
    }
    else {
        _invitetime = invitetime;
    }

}
-(UserModel *)inviteUserInfo {
    UserModel *userModel = [[UserModel alloc] init];
    [userModel serializationWithDictionary:self.inviteUserInfoDic];
    return userModel;
}
@end
