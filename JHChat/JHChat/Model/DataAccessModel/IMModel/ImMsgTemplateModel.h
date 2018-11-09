//
//  ImMsgTemplateModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/8/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  dfl
 Date：   2016-08-10
 Version: 1.0
 Description: 消息模板集合表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "CommonTemplateModel.h"

@class ImTemplateModel;
@interface ImMsgTemplateModel : NSObject

/* 主键 */
@property(nonatomic,strong) NSString *mtid;
/* 模板 */
@property(nonatomic,strong) NSString *templates;
/* 模板码 */
@property(nonatomic,strong) NSString *code;
/* 点击刷新 */
@property(nonatomic,assign) NSInteger clickrefresh;
/* 模板类型 */
@property(nonatomic,assign) NSInteger type;
/* 模板数据 */
@property(nonatomic,strong) NSString *templatedetailist;
/* 模板名称*/
@property(nonatomic,strong) NSString *name;
/* 模板图标*/
@property(nonatomic,strong) NSString *icon;

/* iOS模板配置信息 */
@property(nonatomic,strong) CommonTemplateModel *templateModel;

@end

/*
 
 {
     "templatetype": 1,
     "platinfo": {
             "formname": "PersonViewController"
         },
     "webviewinfo":{
             "h5url": "/index.html"
         },
     "frameworkinfo": {
             "framework": "wchDylib.framework",
             "formname": "PersonViewController",
             "parametername": "context"
         }
 }
 
 */




