//
//  CooOfNewModel.h
//  LeadingCloud
//
//  Created by SY on 16/3/24.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "BaseViewModel.h"

@interface CooOfNewModel : BaseViewModel

/* 协作 id */
@property (nonatomic, strong) NSString *cid;
/* 协作名称 */
@property (nonatomic, strong) NSString *cooperationname;
/* 协作类型 1.任务 2. 项目 3.工作组 */
@property (nonatomic, assign) NSInteger cooperationtype;
/* 被邀请人的邮箱 */
@property (nonatomic, strong) NSString *invitedemail;
/* 被邀请人的头像 */
@property (nonatomic, strong) NSString *invitedface;
/* 被邀请人的id */
@property (nonatomic, strong) NSString *invitedid;
/* 被邀请人姓名 */
@property (nonatomic, strong) NSString *invitedname;
/* 被邀请人电话 */
@property (nonatomic, strong) NSString *invitedphone;
/* 邀请人的头像 */
@property (nonatomic, strong) NSString *inviteface;
/* 邀请人的id */
@property (nonatomic, strong) NSString *inviteid;
/* 邀请人的姓名 */
@property (nonatomic, strong) NSString *invitename;
/* 邀请时间 */
@property (nonatomic, strong) NSDate *invitetime;
/* 邀请类型 */
@property (nonatomic, assign) NSInteger invitetype;
/* 是否有效 */
@property (nonatomic, assign) NSInteger isvalid;
/* 主键 */
@property (nonatomic, strong) NSString *keyid;
/* 0.已拒绝 1.已同意 2.未处理 */
@property (nonatomic, assign) NSInteger state;
/* 是否同意 1:同意 */
@property (nonatomic,assign) NSInteger isagree;

/* 新加属性 */
/* 操作结果 1：邀请中 2：已同意 3：已忽略 4：已撤销 */
@property (assign, nonatomic) NSInteger actionresult;
/* 部门名字 */
@property (nonatomic,strong) NSString *deptname;
/* 部门id */
@property (nonatomic, strong) NSString *did;
/* 企业id */
@property (nonatomic, strong) NSString *oid;
/* 企业名 */
@property (nonatomic, strong) NSString *orgname;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *maintitle;
@end
