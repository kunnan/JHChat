//
//  SelfAppModel.h
//  LeadingCloud
//
//  Created by dfl on 17/4/13.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2017-04-13
 Version: 1.0
 Description: 自建应用表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface SelfAppModel : NSObject
/* 自建应用id - guid */
@property (nonatomic, strong) NSString *osappid;
/* 应用编码 */
@property (nonatomic,strong) NSString *osappcode;
/* 描述 */
@property(nonatomic,strong) NSString *descriptions;
/* 应用名称 */
@property(nonatomic,strong) NSString *name;
/* 背景颜色 */
@property(nonatomic,strong) NSString *osappcolour;
/* 应用logo图标 */
@property(nonatomic,strong) NSString *oslogo;
/* 图标资源id */
@property(nonatomic,strong) NSString *logorid;
/* 是否支持pc 0：不支持，1：支持 */
@property(nonatomic,assign) NSInteger issupportpc;
/* pc端地址 */
@property(nonatomic,strong) NSString *pcurl;
/* 是否支持手机 */
@property(nonatomic,assign) NSInteger issupportmobile;
/* 手机端地址 */
@property(nonatomic,strong) NSString *mobileurl;
/* 企业id */
@property (nonatomic, strong) NSString *orgid;
/* 创建人id */
@property (nonatomic, strong) NSString *createuserid;
/* 创建时间 */
@property (nonatomic, strong) NSDate *createtime;
/* 是否已停用 0:启用，1：停用 */
@property (nonatomic, assign) NSInteger isavailable;
/* 打开方式 0：iframe，1：其他 */
@property (nonatomic, assign) NSInteger handlertype;
/* 可见范围集合 */
@property (nonatomic, strong) NSString *permissionslist;
/* 当前orgid */
@property (nonatomic, strong) NSString *noworgid;
/* 当前appid */
@property (nonatomic, strong) NSString *nowosappid;
/* 版本号 */
@property (nonatomic, strong) NSString *version;
/* 提醒数量 */
@property (nonatomic, assign) NSInteger remindnumber;


@end
