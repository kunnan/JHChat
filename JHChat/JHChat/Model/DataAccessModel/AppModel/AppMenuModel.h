//
//  AppMenuModel.h
//  LeadingCloud
//
//  Created by dfl on 17/4/14.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2017-04-13
 Version: 1.0
 Description: 应用菜单表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface AppMenuModel : NSObject

/* guid */
@property (nonatomic, strong) NSString *appmenuid;
/* 背景颜色 */
@property (nonatomic,strong) NSString *color;
/* 应用logo */
@property(nonatomic,strong) NSString *logo;
/* 应用名称 */
@property(nonatomic,strong) NSString *name;
/* 应用类型 （0.原生应用 1.自建应用） */
@property(nonatomic,assign) NSInteger type;
/* 企业id */
@property (nonatomic, strong) NSString *orgid;
/* 当前id */
@property (nonatomic, strong) NSString *nowid;


@end
