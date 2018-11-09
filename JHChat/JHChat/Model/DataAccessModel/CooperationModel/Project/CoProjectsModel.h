//
//  CoProjectsModel.h
//  LeadingCloud
//
//  Created by SY on 16/10/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   16/10/19.
 Version: 1.0
 Description: 项目model
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "CommonTemplateModel.h"
#import "NSObject+JsonSerial.h"

@interface CoProjectsModel : NSObject

/**
 项目id
 */
@property (nonatomic,strong) NSString *prid;

/**
 项目名称
 */
@property (nonatomic, strong) NSString *prname;

/**
 项目所属组织机构名称
 */
@property (nonatomic, strong) NSString *orgname;

/**
 项目创建时间
 */
@property (nonatomic, strong) NSDate *createdate;

/**
 封面图片
 */
@property (nonatomic, strong) NSString *coverpic;

/**
 所属项目分组id
 */
@property (nonatomic, strong) NSString *pgid;

/**
 是否是置顶项目
 */
@property (nonatomic, assign) BOOL istop;


@property (nonatomic, strong) NSString *appcode;
@property (nonatomic) BOOL isadmin;

/**
 管理员名称
 */
@property (nonatomic, strong) NSString *managername;

/**
 管理员id
 */
@property (nonatomic, strong) NSString *managerid;

/* 展现类型  0 原生  2 自定义 */
@property (nonatomic, assign) NSInteger showmode;

/* 自定义跳转数据 */
@property (nonatomic, strong) NSString *customopenjsondata;

/* 是否同步过项目组 */
@property (nonatomic, assign) BOOL isimgroup;

/* iOS配置信息 */
@property(nonatomic,strong) CommonTemplateModel *controllerModel;

@end
