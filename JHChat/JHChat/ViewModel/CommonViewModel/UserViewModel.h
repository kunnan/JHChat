//
//  UserViewModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/6/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "BaseViewModel.h"

@class UserModel;
@class ImGroupModel;
@interface UserViewModel : BaseViewModel

/**
 *  同步请求网络，获取用户信息
 */
-(UserModel *)getUserInfoAsynMode:(NSString *)uid;

/**
 *  同步请求网络，获取群信息
 */
-(ImGroupModel *)getImGroupInfoAsynMode:(NSString *)groupid;

@end
