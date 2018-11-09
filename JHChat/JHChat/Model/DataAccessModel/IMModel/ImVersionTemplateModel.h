//
//  ImVersionTemplateModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/8/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-08-16
 Version: 1.0
 Description: 消息模板版本表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "CommonTemplateModel.h"

@class CommonTemplateModel;
@interface ImVersionTemplateModel : NSObject

/* 主键 */
@property(nonatomic,strong) NSString *tvid;
/* 编号 */
@property(nonatomic,strong) NSString *tmcode;
/* 版本 */
@property(nonatomic,assign) NSInteger version;
/* 模板配置信息 */
@property(nonatomic,strong) NSString *templates;
/* 参数替换 */
@property(nonatomic,strong) NSString *replaceparams;
/* 模板链接 */
@property(nonatomic,strong) NSString *linktemplate;
/* 替换参数 */
@property(nonatomic,strong) NSString *linkreplaceparams;

/* iOS模板配置信息 */
@property(nonatomic,strong) CommonTemplateModel *templateModel;

/* iOS点击模板 */
@property(nonatomic,strong) CommonTemplateModel *linkModel;

@end


/*
 
 {
     "templatetype": 1,
     "platinfo": {
         "formname": "LZNoticeTemplateView",
         "sendericon": "/Base/PC/Image/group.png"},
         },
     "replacepara":{
         "lblnoticetag":"tagtitle",
         "lblnoticetitle":"title",
         "imgnoticephoto":"imgpath",
         "lblnoticedetail":"content"
     }
 }
 
 */

