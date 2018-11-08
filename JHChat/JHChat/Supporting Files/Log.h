//
//  Log.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#ifndef Log_h
#define Log_h


#endif /* Log_h */

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"
#import "DDFileLogger.h"


#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif

//判断编译模式Release方式屏蔽NSLog 避免影响效率
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif