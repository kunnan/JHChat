//
//  CooNewMemberApplyModel.h
//  LeadingCloud
//
//  Created by SY on 16/6/8.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-06-08
 Version: 1.0
 Description: 新的协作- 新的成员
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface CooNewMemberApplyModel : NSObject
// 主键
@property (nonatomic, strong) NSString *keyid;
// 申请人头像
@property (nonatomic, strong) NSString *applyface;
// 申请人id
@property (nonatomic, strong) NSString *applyid;
// 申请人姓名
@property (nonatomic, strong) NSString *applyname;
// 申请时间
@property (nonatomic, strong) NSDate *applytime;
// 协作id
@property (nonatomic, strong) NSString *cid;
// 协作名字
@property (nonatomic, strong) NSString *cname;
// 协作类型
@property (nonatomic, assign) NSInteger cooperationtype;
// 部门名字
@property (nonatomic, strong) NSString  *departname;
// 组织名
@property (nonatomic ,strong) NSString *orgname;
// 状态 0拒绝 1接收 2未处理
@property (nonatomic, assign) NSInteger state;


// 申请日志的主键id
@property (nonatomic, strong) NSString *cmalid;
// 申请处理的结果 0拒绝 1同意
@property (nonatomic, assign) NSInteger result;
/* 操作结果 1：邀请中 2：已同意 3：已忽略 4：已撤销 */
@property (nonatomic, assign) NSInteger actionresult;

@end
