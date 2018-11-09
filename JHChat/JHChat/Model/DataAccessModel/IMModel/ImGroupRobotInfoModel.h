//
//  ImGroupRobotInfoModel.h
//  LeadingCloud
//
//  Created by gjh on 2018/8/31.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImGroupRobotInfoModel : NSObject

/// 主键
@property (nonatomic, copy) NSString *riid;

/// *必填
@property (nonatomic, copy) NSString *appid;

/// *必填appcode
@property (nonatomic, copy) NSString *appcode;

/// *必填机器人名称
@property (nonatomic, copy) NSString *name;

/// 图标
@property (nonatomic, copy) NSString *icon;

/// 简介
@property (nonatomic, copy) NSString *intro;

/// 预览图
@property (nonatomic, copy) NSString *preview;

/// 是否开户自定义设置
@property (nonatomic, assign) NSInteger iscustomsettint;

/// web模板
//@property (nonatomic, copy) NSString *web;
//
///// ios模板
//@property (nonatomic, copy) NSString *ios;
//
///// android模板
//@property (nonatomic, copy) NSString *android;

@property (nonatomic, copy) NSString *templatecode;

@property (nonatomic, copy) NSString *linkconfig;
/// *必填api地址
@property (nonatomic, copy) NSString *messageapi;

@end
