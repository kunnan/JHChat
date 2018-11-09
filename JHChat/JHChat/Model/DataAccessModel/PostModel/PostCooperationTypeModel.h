//
//  PostCooperationTypeModel.h
//  LeadingCloud
//
//  Created by wang on 16/8/5.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-08-05
 Version: 1.0
 Description: 动态类型模型
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/
#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface PostCooperationTypeModel : NSObject
/* 主键 */
@property(nonatomic,strong)NSString *posttypeid;
/* 动态类型名称 */
@property(nonatomic,strong)NSString *posttypename;
/* 动态类型code */
@property(nonatomic,strong)NSString *posttypecode;
/* 手机logo */
@property(nonatomic,strong)NSString *mobilelogo;
/* @好友 应用id*/
@property(nonatomic,strong)NSString *appid;
/* @好友 应用颜色*/
@property(nonatomic,strong)NSString *appcolor;
/* @好友 应用logo id*/
@property(nonatomic,strong)NSString *applogo;
/* @好友 应用 code */
@property(nonatomic,strong)NSString *appcode;
/* @好友 api*/
@property(nonatomic,strong)NSString *antwebapi;
/* ios动态跳转模板 字典 */
@property(nonatomic,strong)NSString *iostrun;

/* code */
@property(nonatomic,strong)NSString *baselinkcode;

@property(nonatomic,strong)NSString *describe;
@property(nonatomic,strong)NSString *trunjs;
@property(nonatomic,strong)NSString *trunmethod;
@property(nonatomic,strong)NSString *logo;


@end
