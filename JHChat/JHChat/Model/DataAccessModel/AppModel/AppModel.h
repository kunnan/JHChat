//
//  AppModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 应用管理表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "CommonTemplateModel.h"

@class ControllerModel;

@interface AppModel : NSObject
/* 协作appid */
@property (nonatomic, strong) NSString *cooAppid;
/* 协作id */
@property (nonatomic,strong) NSString *cid;
/* 应用id- guid */
@property(nonatomic,strong) NSString *appid;
/* 名称 */
@property(nonatomic,strong) NSString *name;
/* ios配置信息 */
@property(nonatomic,strong) NSString *controller;
/* 图标 */
@property(nonatomic,strong) NSString *logo;
/* H5界面  接webView */
@property(nonatomic,strong) NSString *html5;
/* 有效 */
@property(nonatomic,strong) NSString *valid;
/*  */
@property(nonatomic,assign) NSInteger protogenesis;
/* 购买 */
@property(nonatomic,assign) NSInteger purchase;
/* 类型 */
@property (nonatomic, strong) NSString *type;
/* 排序 */
@property (nonatomic, assign) NSInteger index;
/* 应用码 */
@property (nonatomic, strong) NSString *appcode;
/* 应用服务器 */
@property (nonatomic, strong) NSString *appserver;
/* 提醒数量 */
@property (nonatomic, assign) NSInteger remindnumber;
/* 应用排序id */
@property (nonatomic,strong) NSString *sortid;
/* 选取类型  0.待选  1.已选 */
@property (nonatomic, assign) NSInteger selecttype;
/* 应用颜色 */
@property (nonatomic,strong) NSString *appcolour;

/* 是否为正式数据，app_temp表中使用 */
@property (nonatomic,strong) NSString *temptype;
/* 企业id */
@property (nonatomic, strong) NSString *orgid;
/* appid */
@property (nonatomic, strong) NSString *nowappid;
/* 版本号 */
@property (nonatomic, strong) NSString *version;
/* 应用别名 */
@property (nonatomic, strong) NSString *alias;

/* iOS配置信息 */
@property(nonatomic,strong) CommonTemplateModel *controllerModel;


@end


/*
 
 {
     "templatetype": 3,
     "platinfo": {
         "formname": "PersonViewController",
         "sendericon": "/Base/PC/Image/group.png"}
     },
     "frameworkinfo": {
                          "framework": "wchDylib.framework",
                          "formname": "PersonViewController",
                          "parametername": "context"
                      },
     "installappinfo": {
         "scheme": "LZIMApp"
     }
 }

 */




