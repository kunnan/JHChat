//
//  InviteApprovalModel.h
//  LeadingCloud
//
//  Created by SY on 2017/6/16.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2017/6/16
 Version: 1.0
 Description: 邀请审批对象apimodel
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface InviteApprovalModel : NSObject

@property (nonatomic, strong) NSString *cmiaid;
@property (nonatomic, strong) NSString *cooperationname;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic,strong)  NSMutableDictionary *inviteUserInfoDic;
@property (nonatomic, strong) NSDate *invitetime;
@property (nonatomic, assign) NSInteger approvalresult; // 0其他 1审批中 2同意 3忽略
@property (nonatomic, assign) NSInteger ctype; // 0 无  1任务  2项目  3工作组
@property (nonatomic, strong) NSMutableArray *invitedUserInfoList;

@property (nonatomic,strong) UserModel *inviteUserInfo;
@end
