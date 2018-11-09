//
//  OpenTemplateModel.h
//  LeadingCloud
//
//  Created by wang on 16/11/10.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-11-10
 Version: 1.0
 Description: 通过模板打开页面
 
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "XHBaseViewController.h"
#import "CommonTemplateModel.h"
#import "LZPluginManager.h"
#import "ModuleServerUtil.h"

@interface OpenTemplateModel : NSObject

/**
 打开模板的控制器(根)
 
 @param baseVc        当前控制器
 @param context       传递数据
 @param dataParam     参数
 @param lzplugin      插件
 @param templateModel 模板
 @param isjump        是否跳转 默认传YES
 
 */
+ (void)openTemplateViewController:(UIViewController*)baseVc Context:(NSMutableDictionary *)context URLParamsData:(NSString*)dataParam Lzplugin:(LZPluginManager*)lzplugin Model:(CommonTemplateModel *)templateModel AppCode:(NSString *)appcode RelationAppCodes:(NSMutableArray *)relationAppCodes BaskLinkCode:(NSString*)linkcode templateModule:(NSString *)templateModule;
/**
 打开模板的控制器
 
 @param baseVc        当前控制器
 @param context       传递数据
 @param dataParam     参数
 @param lzplugin      插件
 @param templateModel 模板
 @param isjump        是否跳转 默认传YES

 */
+ (void)openCommonTemplateViewController:(UIViewController*)baseVc Context:(NSMutableDictionary *)context URLParamsData:(NSString*)dataParam Lzplugin:(LZPluginManager*)lzplugin Model:(CommonTemplateModel *)templateModel AppCode:(NSString *)appcode RelationAppCodes:(NSMutableArray *)relationAppCodes templateModule:(NSString *)templateModule;

/**
 打开内部的控制器

 @param baseVc        当前控制器
 @param context       传递数据
 @param templateModel 模板
 */
+ (UIViewController *)openInsideViewController:(UIViewController*)baseVc Context:(NSMutableDictionary *)context Model:(CommonTemplateModel *)templateModel;


/**
 打开WebView

 @param baseVc        当前控制器
 @param context       传递数据
 @param dataParam     参数
 @param templateModel 模板
 */
+ (void)openWebViewController:(UIViewController*)baseVc Context:(NSMutableDictionary *)context URLParamsData:(NSString*)dataParam Model:(CommonTemplateModel *)templateModel appCode:(NSString *)appcode templateModule:(NSString *)templateModule;


/**
 打开动态链接库

 @param baseVc        当前控制器
 @param DataDic       传递数据
 @param lzplugin      插件
 @param templateModel 模板
 */
+ (void)openFrameworkController:(UIViewController*)baseVc DataDic:(NSMutableDictionary *)dataDic Lzplugin:(LZPluginManager*)lzplugin Model:(CommonTemplateModel *)templateModel;


/**
 打开外部应用

 @param baseVc        当前控制器
 @param dataDic       传递参数 没有传空
 @param templateModel 模板
 */
+ (void)openOutsideApp:(UIViewController*)baseVc DataDic:(NSMutableDictionary *)dataDic Model:(CommonTemplateModel *)templateModel;


/**
 打开VPN
 
 @param baseVc        当前控制器
 @param dataDic       传递参数 没有传空
 @param templateModel 模板
 */
+ (void)openVpnWebApp:(UIViewController*)baseVc DataDic:(NSMutableDictionary *)dataDic Model:(CommonTemplateModel *)templateModel AppID:(NSString *)appid;

#pragma mark - 获取关联应用的信息
+(void)getRelationAppCodeInfo:(NSMutableArray *)relationAppCodes block:(LZGetAppModel)block;

@end
