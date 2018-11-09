//
//  CommonTemplateModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/9/14.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 {
     "templatetype": 1,
     "platinfo": {
        "formname": "PersonViewController",
        "parametername": "context",
        "constdata": "xxxx"
     },
     "webviewinfo":{
        "h5url": "/index.html",
        "appcode": "BlueTurnWhite",
        "isnotshownav":"1"
     },
     "frameworkinfo": {
         "framework": "wchDylib.framework",
         "formname": "PersonViewController",
         "parametername": "context"
     },
     "replacepara":{
         "lblnoticetag":"tagtitle",
         "lblnoticetitle":"title",
         "imgnoticephoto":"imgpath",
         "lblnoticedetail":"content"
     },
     "installappinfo": {
        "scheme": "LZIMApp://xxxxx/{ssotokenid}",
        "type": "aroute"
     },
     "vpnwebinfo": {
        "scheme": "LZIMApp://xxxxx/{ssotokenid}",
        "h5url": "/index.html",
        "appcode": "BlueTurnWhite",
        "isnotshownav":"1"
     }
 }
 
 */

@class CommonTemplatePlatModel;
@class CommonTemplateWebViewModel;
@class CommonTemplateFrameworkModel;
@class CommonTemplateInstallAppModel;
@class CommonTemplateVpnWebModel;
@interface CommonTemplateModel : NSObject

/* 应用类型，1：协作平台内部Controller 2:webview 3：动态链接库 4: 独立app 5:vpn */
@property(nonatomic,assign) NSInteger templatetype;

/* 平台内部配置信息 */
@property(nonatomic,strong) id platinfo;

/* webview配置信息 */
@property(nonatomic,strong) id webviewinfo;

/* 动态链接库配置信息 */
@property(nonatomic,strong) id frameworkinfo;

/* 独立app配置信息 */
@property(nonatomic,strong) id installappinfo;

/* VPN配置信息 */
@property(nonatomic,strong) id vpnwebinfo;

/* 模板参数(消息模板使用) */
@property(nonatomic,strong) NSDictionary *replaceparaDic;

@property(nonatomic,strong) CommonTemplatePlatModel *platModel;
@property(nonatomic,strong) CommonTemplateWebViewModel *webviewModel;
@property(nonatomic,strong) CommonTemplateFrameworkModel *frameworkModel;
@property(nonatomic,strong) CommonTemplateInstallAppModel *installappModel;
@property(nonatomic,strong) CommonTemplateVpnWebModel *vpnwebModel;

@end


/**
 *  平台原生ViewController
 */
@interface CommonTemplatePlatModel : NSObject

/* 启动时的ViewController名称 */
@property(nonatomic,strong) NSString *controllername;
@property(nonatomic,strong) NSString *formname;

@property(nonatomic,strong) NSString *isnotpush;

/* ViewController接收参数的变量名称 */
@property(nonatomic,strong) NSString *parametername;

/* 模板使用到的固定参数 */
@property(nonatomic,strong) NSString *constdata;

///* 发送者头像(消息模板使用) */
//@property(nonatomic,strong) NSString *sendericon;

@end


/**
 *  H5页面
 */
@interface CommonTemplateWebViewModel : NSObject

/* 对应的h5地址 */
@property(nonatomic,strong) NSString *h5url;

/* 应用 */
@property(nonatomic,strong) NSString *appcode;

/* 是否不显示导航 */
@property(nonatomic,strong) NSString *isnotshownav;

/* 传递的数据 */
@property(nonatomic,strong) NSString *pagetransdata;

@end


/**
 *  动态链接库
 */
@interface CommonTemplateFrameworkModel : NSObject

/* 动态链接库名称 */
@property(nonatomic,strong) NSString *framework;

/* 启动时的ViewController名称 */
@property(nonatomic,strong) NSString *formname;

/* ViewController接收参数的变量名称 */
@property(nonatomic,strong) NSString *parametername;

@end


/**
 *  独立app
 */
@interface CommonTemplateInstallAppModel : NSObject

/* 启动时的协议 */
@property(nonatomic,strong) NSString *scheme;

@end

/**
 *  vpn
 */
@interface CommonTemplateVpnWebModel : NSObject

/* 启动时的协议 */
@property(nonatomic,strong) NSString *scheme;

/* 对应的h5地址 */
@property(nonatomic,strong) NSString *h5url;

/* 应用 */
@property(nonatomic,strong) NSString *appcode;

@end

