//
//  AppHT.h
//  LeadingCloud
//
//  Created by dfl on 17/3/7.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#ifndef AppHT_h
#define AppHT_h


#endif /* AppHT_h */

/* =================================应用(app)================================= */
static NSString * const Handler_App = @"app";

/* 权限(jurisdiction) */
static NSString * const Handler_App_Jurisdiction = @"jurisdiction";
static NSString * const Handler_App_Jurisdiction_Disabled  = @"app_jurisdiction_disabled";  //应用禁用--临时通知(已处理)
static NSString * const Handler_App_Jurisdiction_Enable  = @"app_jurisdiction_enable";  //应用启用--临时通知(已处理)
static NSString * const Handler_App_Jurisdiction_Available  = @"app_jurisdiction_available";  //应用可用--临时通知(已处理)
static NSString * const Handler_App_Jurisdiction_Unavailable  = @"app_jurisdiction_unavailable";  //应用不可用--临时通知(已处理)

/* 提醒(Remind) */
static NSString * const Handler_App_Remind = @"remind";
static NSString * const Handler_App_Remind_Remind  = @"App_Remind";  //应用提醒数字--临时通知(已处理)
