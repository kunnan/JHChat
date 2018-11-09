//
//  FavoriteTypeModel.h
//  LeadingCloud
//
//  Created by dfl on 16/4/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-04-09
 Version: 1.0
 Description: 收藏分类管理表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface FavoriteTypeModel : NSObject

/* 主键收藏类型id */
@property(nonatomic,strong) NSString *ftid;
/* 收藏类型名称 */
@property(nonatomic,strong) NSString *name;
/* 收藏详细信息查看方法（Web） */
@property(nonatomic,strong) NSString *webviewfun;
/* 收藏详细信息查看方法（iOS） */
@property(nonatomic,strong) NSString *iosviewfun;
/* 收藏详细信息查看方法（Android） */
@property(nonatomic,strong) NSString *androidviewfun;
/* Web端图片路径目录 */
@property(nonatomic,strong) NSString *web_image_directory;
/* iOS端图片路径目录 */
@property(nonatomic,strong) NSString *ios_image_directory;
/* Android端图片路径目录 */
@property(nonatomic,strong) NSString *android_image_directory;

/* web跳转json */
@property(nonatomic,strong) NSString *trunjs;
/* ios跳转json */
@property(nonatomic,strong) NSString *iostrun;
/* android跳转json */
@property(nonatomic,strong) NSString *androidtrun;
/* 编码 */
@property(nonatomic,strong) NSString *code;
/* 跳转方式 */
@property(nonatomic,strong) NSString *trunmethod;

/* 应用id */
@property(nonatomic,strong) NSString *appid;
/* 应用logo */
@property(nonatomic,strong) NSString *applogo;
/* 应用颜色 */
@property(nonatomic,strong) NSString *appcolor;
/* 应用code */
@property(nonatomic,strong) NSString *appcode;
/* 收藏0 关注1 */
@property(nonatomic,assign) NSInteger state;


@property(nonatomic,strong)NSString *baselinkcode;

@end
