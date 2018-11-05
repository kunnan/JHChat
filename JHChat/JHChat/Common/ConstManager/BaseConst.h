//
//  BaseConst.h
//  LeadingCloud
//
//  Created by wchMac on 15/11/17.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-11-17
 Version: 1.0
 Description: 基础静态声明
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifndef BaseConst_h
#define BaseConst_h


#endif /* BaseConst_h */

//#if TARGET_IPHONE_SIMULATOR
//#define SIMULATOR 1
//#elif TARGET_OS_IPHONE
//#define SIMULATOR 0
//#endif

/* 软件数据库版本 */
static NSInteger const LeadingCloudMain_DBVersion = 93;
//static NSString * const LeadingCloudError_Type = @"error";
static BOOL const LeadingCloud_MsgParseSerial = YES;   //顺序解析长连接返回的消息

/* SystemInfo 信息 */
static NSString * const SystemInfo_DbVersion = @"dbVersion";

/* 默认服务器地址 */
static NSString * const DEFAULTSERVER_YUN = @"plat.jiansheyun.com.cn";   //plat.jiansheyun.com.cn
static NSString * const DEFAULTSERVER_PLAT = @"plat.jiansheyun.com.cn";  //plat.jiansheyun.com.cn

/* 每次需要变化引导页的时候改变此常量 */
static NSString * const BOOT_PAGE_IS_SHOW = @"boot_page_is_show_version_0";

/* 高德Key */
static NSString * const APIKEY_EE = @"f214e27c01053fcd6aae651e03ee3684";
static NSString * const APIKEY_APPSTORE = @"a2343fefb3c4fc22f88170344beda16e";

/* 友盟Key */
static NSString * const UMENG_KEY_EE = @"577cfa5367e58e86e0001630";
static NSString * const UMENG_KEY_APPSTORE = @"58f579eda40fa33fcb0025da";

/* 屏幕大小 */
#define LZ_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define LZ_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

/* 状态栏高度超过20<##> 开热点时*/
#define STATUS_BAR_BIGGER_THAN_20 [UIApplication sharedApplication].statusBarFrame.size.height > 20
/* 各个屏幕大小 */
#define SCREEN_MAX_LENGTH (MAX(LZ_SCREEN_WIDTH, LZ_SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(LZ_SCREEN_WIDTH, LZ_SCREEN_HEIGHT))
#define LZ_IPHONE_4_OR_LESS_SCREEN (SCREEN_MAX_LENGTH < 568.0)
#define LZ_IPHONE_5_SCREEN (SCREEN_MAX_LENGTH == 568.0)
#define LZ_IPHONE_6_SCREEN (SCREEN_MAX_LENGTH == 667.0)
#define LZ_IPHONE_6P_SCREEN (SCREEN_MAX_LENGTH >= 736.0)

#define LZ_IPHONEX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)
//判断iPHoneXr
#define LZ_IPHONEXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPHoneX、iPHoneXs
#define LZ_IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define LZ_IPHONEXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs Max
#define LZ_IPHONEXS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)


/* 状态栏高度(20) */
#define LZ_STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

/* 导航栏高度(44) */
#define LZ_NAVGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height

/* 底部工具条的高度(34) */
#define LZ_TOOLBAR_HEIGHT (LZ_IPHONEX_All?34:0)

/* 系统版本 */
#define LZ_IS_IOS7	([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define LZ_IS_IOS8	([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define LZ_IS_IOS9	([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define LZ_IS_IOS10	([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define LZ_IS_IOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)

/* 状态栏和导航栏高度(64) */
#define LZ_STATUS_NAV_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height+self.navigationController.navigationBar.frame.size.height)

/* 图片调用方式 */
#define LZIMForUIImage(name)  [ImageManager imageNamed:(name)]

/* 尺寸调用方式 */
#define LZDMForNSNumber(key,view)  [DimenMagnager dimenForKey:(key) inView:(view)]
#define LZDMForNSInteger(key,view) [[DimenMagnager dimenForKey:(key) inView:(view)] integerValue]
#define LZDMForFloat(key,view) [[DimenMagnager dimenForKey:(key) inView:(view)] floatValue]

/*颜色调用方式：直接传入x颜色的RGB颜色，不用除以255*/
#define UIColorWithRGB(redValue, greenValue, blueValue) [UIColor colorWithRed:(redValue) / 255.0f green:(greenValue) / 255.0f blue:(blueValue) / 255.0f alpha:1.0f]  
#define UIColorWithRGBA(redValue, greenValue, blueValue,alphaValue) [UIColor colorWithRed:(redValue) / 255.0f green:(greenValue) / 255.0f blue:(blueValue) / 255.0f alpha:(alphaValue)]

/* 统一背景色 */
#define BACKGROUND_COLOR [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0]
/* 蓝色字体颜色 */
#define LZColor_Button_TintColor [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1.000]


#define lz_dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

#define lz_dispatch_async_safe(block)\
    if ([NSThread isMainThread]) {\
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);\
    } else {\
        block();\
    }


#define lz_dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }

//#define lz_dispatch_sync_safe(block)\
//    if ([NSThread isMainThread]) {\
//        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);\
//    } else {\
//        block();\
//    }

/* 多语言调用方式 */
static NSString * const CHINESE = @"zh-Hans";
static NSString * const ENGLISH = @"en";
#define LZGDBaseLocailzableString(key) [[GDLocalizableManager bundle] localizedStringForKey:(key) value:@"" table:@"BaseLocailzable"]
#define LZGDLoginLocailzableString(key) [[GDLocalizableManager bundle] localizedStringForKey:(key) value:@"" table:@"LoginLocailzable"]
#define LZGDMainLocailzableString(key) [[GDLocalizableManager bundle] localizedStringForKey:(key) value:@"" table:@"MainLocailzable"]
#define LZGDCommonLocailzableString(key) [[GDLocalizableManager bundle] localizedStringForKey:(key) value:@"" table:@"CommonLocailzable"]
#define LZGDMessageLocailzableString(key) [[GDLocalizableManager bundle] localizedStringForKey:(key) value:@"" table:@"MessageLocailzable"]
#define LZGDCooperationLocailzableString(key) [[GDLocalizableManager bundle] localizedStringForKey:(key) value:@"" table:@"CooperationLocailzable"]
#define LZGDAppLocailzableString(key) [[GDLocalizableManager bundle] localizedStringForKey:(key) value:@"" table:@"AppLocailzable"]
#define LZGDResLocailzableString(key) [[GDLocalizableManager bundle] localizedStringForKey:(key) value:@"" table:@"ResLocailzable"]
#define LZGDMoreLocailzableString(key) [[GDLocalizableManager bundle] localizedStringForKey:(key) value:@"" table:@"MoreLocailzable"]

/* 键盘高度 */
static NSInteger const KeyBoard_PadHeight = 264;
static NSInteger const KeyBoard_PhoneHeight = 216;

/* 通知，MainViewController */
static NSString * const Notification_MainViewController_SelectTab = @"mainviewcontroller_selecttab";
static NSString * const Notification_MainViewController_RefreshBadge = @"mainviewcontroller_refreshbadge";
static NSString * const Notification_MainViewController_RefreshAppRemindBadge = @"mainviewcontroller_refreshappremindbadge";


/*------------------二维码相关-------------------*/
/*加为好友*/
static NSString * const Code_AddUser = @"AddUser";
/*链接加为好友*/
static NSString * const Code_InviteFriends = @"InviteFriends";
/*加入工作组*/
static NSString * const Code_AddWorkGroup = @"AddWorkGroup";
/*加入任务*/
static NSString * const Code_AddTask = @"AddTask";
/*加入群组*/
static NSString * const Code_AddChatGroup = @"AddChatGroup";
/*加入组织(部门)*/
static NSString * const Code_AddOrg = @"AddOrg";
/*链接加入组织(部门)*/
static NSString * const Code_JoinOrg = @"JoinOrg";
/* 云盘文件分享 */
static NSString * const Code_FileShare = @"/R/S";
/* 协作文件分享 */
static NSString * const Code_CooFileShare = @"/C/RS";

/*------------------模板类型-------------------*/
static NSString * const Template_Module = @"lcmmodule";

/* 消息 im_template */
static NSString * const Template_Message = @"lcm_message";
/* 二级消息界面（个人提醒、企业提醒） im_template */
static NSString * const Template_Message_Second = @"lcm_message_second";
/* 聊天界面 templateversion */
static NSString * const Template_Chat = @"lcm_chat";
/* 聊天跳转到协作 co_extend_type */
static NSString * const Template_ChatRelateid = @"lcm_chatrelateid";
/* 动态 post_type */
static NSString * const Template_Post = @"lcm_post";
/* 办理 transaction_type */
static NSString * const Template_Transaction = @"lcm_transaction";
/* 通用任务 co_app */
static NSString * const Template_Task = @"lcm_task";
/* 工作圈 co_app */
static NSString * const Template_WorkGroup = @"lcm_workgroup";
/* 收藏 favirutes_type */
static NSString * const Template_Favorite = @"lcm_favorite";
/* 应用 app */
static NSString * const Template_App = @"lcm_app";
/* 项目类型 co_projectmain */
static NSString * const Template_Project_Main = @"lcm_project_main";
/* 项目模块 */
static NSString * const Template_Project_Module = @"lcm_project_module";
/* 服务圈 */
static NSString * const Template_Service = @"lcm_service";
/* 服务圈(启动页) */
static NSString * const Template_Service_Launch = @"lcm_service_launch";
/* 业务会话 */
static NSString * const Template_BusinessSession = @"lcm_businesssession";
/* 业务会话(表单) */
static NSString * const Template_BusinessSession_Expand = @"lcm_businesssession_expand";


/* 新的** 分页加载数量 */
static NSInteger const NewsDataCount = 25;

/*------------------通用tableViewCell高度-------------------*/
static NSInteger const LZ_TableViewCell_Height44 = 44;
static NSInteger const LZ_Cell_IconWidthHeight26 = 26;

static NSInteger const LZ_TableViewCell_Height48 = 48;
static NSInteger const LZ_Cell_IconWidthHeight32 = 32;

static NSInteger const LZ_TableViewCell_Height50 = 50;
static NSInteger const LZ_Cell_IconWidthHeight34 = 34;

static NSInteger const LZ_TableViewCell_Height54 = 54;
static NSInteger const LZ_Cell_IconWidthHeight40 = 40;

static NSInteger const LZ_TableViewCell_Height64 = 64;
static NSInteger const LZ_Cell_IconWidthHeight50 = 50;

/*------------------Cell中的View距离右侧距离-------------------*/
static NSInteger const LZ_Cell_MarginRight36 = 36;
static NSInteger const LZ_Cell_MarginRight18 = 18;

static float const Cell_Icon_RadioWidthHeight = 24.0f;



/*------------------LCprogressHUD 常用文字说明-------------------*/
static NSString * const LCProgressHUD_Show_NetWorkConnectFail = @"网络连接失败";
static NSString * const LCProgreaaHUD_Show_Loading = @"正在加载...";
static NSString * const LCProgressHUD_Show_Processing = @"正在处理...";
static NSString * const LCProgressHUD_Show_Success = @"成功";
static NSString * const LCProgressHUD_Show_ChangeSuccess = @"修改成功";
static NSString * const LCProgressHUD_Show_Fail = @"失败";


/*------------------打开隐藏功能-----------------*/
static NSString * const Function_Set_ServiceCircle = @"://lc.servicecircle";  //服务圈是否显示
static NSString * const Function_Set_ChatVideo = @"://lc.chatvideo";  //语音通话是否显示
static NSString * const Function_Set_DocumentCoop = @"://lc.documentcoop";  //文档协作是否显示
static NSString * const Function_Set_InfoShare = @"://lc.infoshare";  //分享是否显示
static NSString * const Function_Set_InfoHelp = @"://lc.infohelp";  //帮助是否显示
static NSString * const Function_Set_ProjectBranch = @"://lc.projectbranch";  //项目分支 projectbranch


