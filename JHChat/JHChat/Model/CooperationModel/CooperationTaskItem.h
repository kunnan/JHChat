//
//  CooperationTaskItem.h
//  LeadingCloud
//
//  Created by wnngxzhibin on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CooperationTaskCheckItem.h"
#import "CoMemberModel.h"
#import "CooLayoutModel.h"

@interface CooperationTaskItem : NSObject

//任务ID
@property(nonatomic,copy)NSString *taskID;

@property(nonatomic,copy)NSString *taskName;
//任务描述
@property(nonatomic,copy)NSString *taskDesciption;

//任务描述去掉html 标签
@property(nonatomic,copy)NSString *taskDes;

// 任务logo
@property(nonatomic,copy)NSString *logo;

// 任务号
@property(nonatomic,copy)NSString *tasknumber;

@property(nonatomic,assign)BOOL isHidden;


//是否需要管理员 同意
@property(nonatomic,assign)BOOL isneeding;

//展示描述高度
@property(nonatomic,assign)CGFloat taskShowHeight;

//展示描述高度
@property(nonatomic,assign)CGFloat taskHeight;
//任务描述是否展开
@property(nonatomic,assign)BOOL isShowAll;

//父任务
@property(nonatomic,copy)NSString *parentID;

@property(nonatomic,copy)NSString *parentName;


@property(nonatomic,copy)NSString *rootname;
@property(nonatomic,copy)NSString *rootid;



//关联项目
@property(nonatomic,retain)NSMutableArray *projectArray;
//关联工作组
@property(nonatomic,retain)NSMutableArray *workGroupArray;

//子任务数组
@property(nonatomic,retain)NSMutableArray *childArray;

//任务类型
@property(nonatomic,copy)NSString *subjects;

//任务文件
@property(nonatomic,retain)NSArray *taskFileArray;
//成员列表
@property(nonatomic,retain)NSMutableArray *memberArray;
//主要负责人
@property(nonatomic,retain)CoMemberModel *chargeModel;


@property(nonatomic,assign)NSInteger identity;

//标签
@property(nonatomic,retain)NSMutableArray *labelsArray;

//标签原始值
@property(nonatomic,retain)NSMutableArray *tagArray;
//标签
@property(nonatomic,retain)NSMutableArray *toolArray;

//开始日期
@property(nonatomic,copy)NSString *starDate;
//截止日期
@property(nonatomic,copy)NSString *stopDate;

//节点数组
@property(nonatomic,retain)NSMutableArray *checkArray;

//收藏
@property(nonatomic,assign)BOOL isFavorites;

//任务状态 1 未发布 2 已发布 3 完成 4 废弃 5 暂停
@property(nonatomic,assign)NSInteger state;

//锁定
@property(nonatomic,assign)BOOL isLock;


@property(nonatomic,strong) NSString *lockUser;

// 是否是管理员
@property(nonatomic,assign)BOOL isCharge;

//资源池ID
@property(nonatomic,strong)NSString *taskFilerpid;

//讨论组id
@property(nonatomic,strong)NSString *igid;

//任务人数
@property(nonatomic,assign)NSInteger memberslength;



// 当前用户角色
@property (nonatomic,strong)NSArray *curRolekeyArr;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@property (nonatomic,strong)CooLayoutModel *layoutModel;


@end
