//
//  CooGroupLayoutInfoModel.h
//  LeadingCloud
//
//  Created by SY on 16/7/21.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CooGroupLayoutInfoModel : NSObject
// 管理员移除
@property (nonatomic,assign) BOOL groupadminremove;
// 管理员设置
@property (nonatomic, assign) BOOL groupadminsetting;
// 工具设置
@property (nonatomic, assign) BOOL groupappsetting;
// 基本信息
@property (nonatomic, assign) BOOL  groupbasicmobile;
// 基本信息位置
@property (nonatomic, assign) NSInteger  groupbasicposition;
//
@property (nonatomic, assign) BOOL groupcode;
@property (nonatomic, assign) BOOL  grouplog;
@property (nonatomic, assign) BOOL grouplogo;
// 成员
@property (nonatomic, assign) BOOL groupmember;
@property (nonatomic, assign) BOOL groupmemberafresh;
@property (nonatomic, assign) BOOL groupmemberinvite;
@property (nonatomic, assign) BOOL groupmemberparticipstatus;
@property (nonatomic, assign) BOOL groupmemberquit;
@property (nonatomic, assign) BOOL groupmemberremove;
@property (nonatomic, assign) BOOL groupmemberrevoke;
@property (nonatomic, assign) BOOL grouppost;
@property (nonatomic, assign) NSInteger grouppostposition;
@property (nonatomic, assign) BOOL groupsetting;
@property (nonatomic, assign) BOOL groupsettingbasicinfosetting;
@property (nonatomic, assign) BOOL groupsettinglayoutsetting;
@property (nonatomic, assign) BOOL groupsettingrolesetting;
@property (nonatomic, assign) BOOL groupsettingtemplatesetting;
@property (nonatomic, assign) BOOL grouptag;
@property (nonatomic,assign ) BOOL groupdes;
@property (nonatomic,assign ) BOOL onlyadmininvite;

@end

