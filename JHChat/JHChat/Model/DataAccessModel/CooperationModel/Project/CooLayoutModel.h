//
//  CooLayoutModel.h
//  LeadingCloud
//
//  Created by SY on 16/5/6.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-05-06
 Version: 1.0
 Description: 协作-基本信息/动态显隐控制
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface CooLayoutModel : NSObject

@property (nonatomic ,strong) NSString *cid;
// 关联工作组
@property (nonatomic, assign) NSInteger  relategroup;
// 关联项目
@property (nonatomic, assign) NSInteger  relateproject;
// app设置是否允许再添加
@property (nonatomic, assign) NSInteger  taskappsetting;
// 任务隶属
@property (nonatomic, assign) NSInteger  taskattach;
// 基本信息全部显隐
@property (nonatomic, assign) NSInteger  taskbasicmobile;
// 任务收藏
@property (nonatomic, assign) NSInteger  taskfavorite;
// 任务锁
@property (nonatomic, assign) NSInteger  tasklock;
// 任务日志
@property (nonatomic, assign) NSInteger  tasklog;
//  任务成员
@property (nonatomic, assign) NSInteger  taskmember;
//  任务计划完成日期
@property (nonatomic, assign) NSInteger  taskplandate;
// 任务动态
@property (nonatomic, assign) NSInteger  taskpost;
// 任务设置
@property (nonatomic, assign) NSInteger  tasksetting;
// 布局设置
@property (nonatomic, assign) NSInteger  tasksettinglayoutsetting;
// 参与身份设置
@property (nonatomic, assign) NSInteger  tasksettingparticipstatus;
// 任务设置-角色设置
@property (nonatomic, assign) NSInteger  tasksettingrolesetting;
// 任务设置-规则设置
@property (nonatomic, assign) NSInteger  tasksettingrulesetting;
// 任务设置-模板设置
@property (nonatomic, assign) NSInteger  tasksettingtemplatesetting;
// 任务标签
@property (nonatomic, assign) NSInteger  tasktag;

@end
