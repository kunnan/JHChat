//
//  CooAppModel.h
//  LeadingCloud
//
//  Created by SY on 16/5/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author: SY
 Date：   2016-05-19
 Version: 1.0
 Description: 协作工具应用
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface CooAppModel : NSObject
/* 协作appid */
@property (nonatomic, strong) NSString *cooAppid;
/* 协作id */
@property (nonatomic,strong) NSString *cid;
/* 应用id */
@property(nonatomic,strong) NSString *appid;
/* 名称 */
@property(nonatomic,strong) NSString *name; // 标签js插件，名字
/*  */
@property(nonatomic,strong) NSString *controller;
/* 图标 */
@property(nonatomic,strong) NSString *logo;

/*颜色*/
@property(nonatomic,strong)NSString *coappcolour;



/* H5界面  接webView */
@property(nonatomic,strong) NSString *html5;  // 标签js插件，url地址
/* 传入sessionstory的数据  接webView */
@property(nonatomic,strong) NSString *pagetransdata;  // 标签js插件，url地址
/* 有效 */
@property(nonatomic,strong) NSString *valid;
/* 是否是原生  */
@property(nonatomic,assign) NSInteger protogenesis;// 标签js插件，是否原生
/* 购买 */
@property(nonatomic,assign) NSInteger purchase;
/* 类型 */
@property (nonatomic, strong) NSString *type;
/* 排序 */
@property (nonatomic, assign) NSInteger index;
/* 应用码 */
//@property (nonatomic, strong) NSString *appcode; // 标签js插件，发动态用

@property (nonatomic, strong) NSString *mainappcode; // 标签js插件，发动态用


/* 应用服务器 */
@property (nonatomic, strong) NSString *appserver;
/* 提醒数量 */
@property (nonatomic, assign) NSInteger remindnumber;

@property (nonatomic,strong) NSArray *rolesArr;
/* 角色权限 用*/
@property (nonatomic, assign) NSInteger isShowApp;


// 标签栏js插件属性

/* 原生控制器标识 */
@property (nonatomic, strong) NSString *ioscontroller;
/* 应用名字  */
@property (nonatomic, strong) NSString *appname;
/* 协作id  动态模块用*/
@property (nonatomic, strong) NSString *bid;
/* 文件资源池id */
@property (nonatomic, strong) NSString *rpid;
/* 代表哪个模块 动态用传Cooperation属性 */
@property (nonatomic,strong) NSString *relevanceappcode;
/* 通用文件只读性 0可操作  1只读 */
@property (nonatomic,strong)  NSString * right;
/* 自定义right */
@property (nonatomic, strong) NSMutableDictionary *customright;
/*通用文件 跳转到指定的文件目录下 */
@property (nonatomic, strong) NSString *folderid;
/* appicon 插件用 */
@property (nonatomic,strong) NSString *defaluticon;
@property (nonatomic, strong) NSString *selectedicon;

@property (nonatomic, strong) NSString * ispost;
@property (nonatomic, strong) NSString * islog;
@property (nonatomic, strong) NSString *posttype;
@property (nonatomic, strong) NSString *rootname;

@property (nonatomic, strong) NSString *prid;
@end
