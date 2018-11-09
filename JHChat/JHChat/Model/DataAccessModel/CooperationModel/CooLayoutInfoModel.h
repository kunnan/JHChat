//
//  CooLayoutInfoModel.h
//  LeadingCloud
//
//  Created by SY on 16/5/6.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CooLayoutInfoModel : NSObject


// 关联工作组
@property (nonatomic, assign) BOOL  relategroup;
// 关联项目
@property (nonatomic, assign) BOOL  relateproject;
// app设置是否允许再添加
@property (nonatomic, assign) BOOL  taskappsetting;
// 任务隶属
@property (nonatomic, assign) BOOL  taskattach;
// 基本信息全部显隐(NSInteger是0的话去不到值)
@property (nonatomic, assign) BOOL  taskbasicmobile;
// 基本信息的位置
@property (nonatomic, assign) NSInteger  taskbasicposition;
// 任务收藏
@property (nonatomic, assign) BOOL  taskfavorite;
// 任务锁
@property (nonatomic, assign) BOOL  tasklock;
// 任务日志
@property (nonatomic, assign) BOOL  tasklog;
//  任务成员
@property (nonatomic, assign) BOOL  taskmember;
//  任务计划完成日期
@property (nonatomic, assign) BOOL  taskplandate;
// 任务动态
@property (nonatomic, assign) BOOL  taskpost;
// 动态的位置
@property (nonatomic, assign) NSInteger taskpostposition;
// 任务设置
@property (nonatomic, assign) BOOL  tasksetting;
// 布局设置
@property (nonatomic, assign) BOOL  tasksettinglayoutsetting;
// 参与身份设置
@property (nonatomic, assign) BOOL  tasksettingparticipstatus;
// 任务设置-角色设置
@property (nonatomic, assign) BOOL  tasksettingrolesetting;
// 任务设置-规则设置
@property (nonatomic, assign) BOOL  tasksettingrulesetting;
// 任务设置-模板设置
@property (nonatomic, assign) BOOL  tasksettingtemplatesetting;
// 任务标签
@property (nonatomic, assign) BOOL  tasktag;

//任务描述
@property (nonatomic,assign) BOOL taskdes;
//重新邀请
@property (nonatomic,assign) BOOL taskmemberafresh;
//邀请
@property (nonatomic,assign) BOOL taskmemberinvite;
//成员退出
@property (nonatomic,assign) BOOL taskmemberquit;
//移除成员
@property (nonatomic,assign) BOOL taskmemberremove;
//撤销邀请
@property (nonatomic,assign) BOOL taskmemberrevoke;
//设置管理员
@property (nonatomic,assign) BOOL taskmembersetting;

//邀请无需审批
@property (nonatomic,assign) BOOL invitenoneedforapproval;


@end
