//
//  CoProjectModsModel.h
//  LeadingCloud
//
//  Created by dfl on 16/10/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   16/10/28.
 Version: 1.0
 Description: 项目模块
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "CommonTemplateModel.h"
#import "NSObject+JsonSerial.h"

@interface CoProjectModsModel : NSObject


/**
 模块关系id(主键)
 */
@property (nonatomic, strong) NSString *cpmid;

/**
 模块id
 */
@property (nonatomic, strong) NSString *modid;

/**
 模块名称
 */
@property (nonatomic, strong) NSString *name;

/**
 应用id
 */
@property (nonatomic, strong) NSString *appid;

/**
 应用名称
 */
@property (nonatomic, strong) NSString *appname;

/**
 开放平台唯一标识
 */
@property (nonatomic, strong) NSString *codeguid;

/**
 业务模块标识
 */
@property (nonatomic, strong) NSString *businessguid;

/**
 应用模板使用颜色
 */
@property (nonatomic, strong) NSString *modcolour;

/**
 应用模块logo
 */
@property (nonatomic, strong) NSString *modlogo;

/**
 页面地址
 */
@property (nonatomic, strong) NSString *weburl;

/**
 html5导向地址
 */
@property (nonatomic, strong) NSString *html5;

/* 是否可用，true的时候则是在模块关系数据中存在数据 到【设置】界面上，
 就是true的时候选中；否则不选中
 */
@property (nonatomic, assign) BOOL isuseable;

/* 
 模块顺序
 */
@property (nonatomic, assign) NSInteger sort;

/**
 项目ID
 */
@property (nonatomic, strong) NSString *prid;

/**
 项目应用码
 */
@property (nonatomic, strong) NSString *appcode;

/** 
 是否为原生
 */
@property (nonatomic, assign) BOOL protogenesis;

/**
 android跳转视图控制器
 */
@property (nonatomic, strong) NSString *activity;

/**
 ios跳转视图控制器
 */
@property (nonatomic, strong) NSString *controller;

/* iOS配置信息 */
@property(nonatomic,strong) CommonTemplateModel *controllerModel;


/**
 是否右上角显示
 */
@property (nonatomic, assign) BOOL isshowtopright;

@end
