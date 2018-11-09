//
//  ImGroupModel.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 分组表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "GroupResourceModel.h"
#import "ImGroupRobotModel.h"

@interface ImGroupModel : NSObject

/* 主键 */
@property(nonatomic,strong) NSString *igid;
/* 群主名称 */
@property(nonatomic,strong) NSString *name;
/* 创建时间 */
@property(nonatomic,strong) NSDate *createdate;
/* 创建人 */
@property(nonatomic,strong) NSString *createuser;
/* 是否重命名 */
@property(nonatomic,assign) NSInteger renamestate;
/* 分组类型 */
@property(nonatomic,assign) NSInteger imtype;
/* 顺序 */
@property(nonatomic,assign) NSInteger showindex;
/* 关联类型 */
@property(nonatomic,assign) NSInteger relatetype;
/* 关联部门名称 */
@property(nonatomic,strong) NSString *relatename;
/* 关联部门ID */
@property(nonatomic,strong) NSString *relateid;
/* 头像ID */
@property(nonatomic,strong) NSString *face;
/* 最后消息时间 */
@property(nonatomic,strong) NSDate *lastmsgdate;
/* 最后一条消息发送人 */
@property(nonatomic,strong) NSString *lastmsguser;
/* 群组人员数量 */
@property(nonatomic,assign) NSInteger usercount;
/* 是否关闭群组 */
@property(nonatomic,assign) NSInteger isclosed;
/* 是否开启免打扰 */
@property(nonatomic,assign) NSInteger disturb;

@property (nonatomic, strong) NSString *relateopencode;

/* 0:只给消息发送   1:只给其它应用发送  2:同时给消息和其它应用发送 */
@property (nonatomic, assign) NSInteger showmode;

/* 是否保存到通讯录 0:没保存   1:保存 */
@property (nonatomic, assign) NSInteger isshow;

/* 是否是临时数据的群组 0:不是   1:是 */
@property (nonatomic, assign) NSInteger isnottemp;

/* 是否显示到列表 */
@property (nonatomic, assign) NSInteger isshowinlist;
/* 新成员加入是否加载消息 */
@property (nonatomic, assign) NSInteger isloadmsg;

/* 数据 */
@property(nonatomic,strong) NSString *groupresource;
/* 群组资源 */
@property(nonatomic,strong,readonly) GroupResourceModel *groupResourceModel; 
/* 群组机器人 */
@property(nonatomic, strong) NSString *imgrouprobots;

@property(nonatomic, strong, readonly) NSMutableArray<ImGroupRobotModel *> *imGroupRobotsModels;

@end
