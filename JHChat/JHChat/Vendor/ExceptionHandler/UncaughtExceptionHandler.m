////
////  UncaughtExceptionHandler.m
////  LeadingCloud
////
////  Created by wchMac on 2018/3/5.
////  Copyright © 2018年 LeadingSoft. All rights reserved.
////
//
//#import "UncaughtExceptionHandler.h"
//#include <libkern/OSAtomic.h>
//#include <execinfo.h>
//#import <mach-o/dyld.h>
//#import "AppUtils.h"
//
//NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
//NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
//NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
//
//volatile int32_t UncaughtExceptionCount = 0;
//const int32_t UncaughtExceptionMaximum = 10;
//
//static BOOL showAlertView = nil;
//
//void HandleException(NSException *exception);
//void SignalHandler(int signal);
//NSString* getAppInfo();
//
//
//@interface UncaughtExceptionHandler()
//@property (assign, nonatomic) BOOL dismissed;
//@end
//
//@implementation UncaughtExceptionHandler
//
//+ (void)installUncaughtExceptionHandler:(BOOL)install showAlert:(BOOL)showAlert {
//    
//    if (install && showAlert) {
//        [[self alloc] alertView:showAlert];
//    }
//    
//    NSSetUncaughtExceptionHandler(install ? HandleException : NULL);
//    signal(SIGABRT, install ? SignalHandler : SIG_DFL);
//    signal(SIGILL, install ? SignalHandler : SIG_DFL);
//    signal(SIGSEGV, install ? SignalHandler : SIG_DFL);
//    signal(SIGFPE, install ? SignalHandler : SIG_DFL);
//    signal(SIGBUS, install ? SignalHandler : SIG_DFL);
//    signal(SIGPIPE, install ? SignalHandler : SIG_DFL);
//}
//
//- (void)alertView:(BOOL)show {
//    
//    showAlertView = show;
//}
//
////获取调用堆栈
//+ (NSArray *)backtrace {
//    
//    //指针列表
//    void* callstack[128];
//    //backtrace用来获取当前线程的调用堆栈，获取的信息存放在这里的callstack中
//    //128用来指定当前的buffer中可以保存多少个void*元素
//    //返回值是实际获取的指针个数
//    int frames = backtrace(callstack, 128);
//    //backtrace_symbols将从backtrace函数获取的信息转化为一个字符串数组
//    //返回一个指向字符串数组的指针
//    //每个字符串包含了一个相对于callstack中对应元素的可打印信息，包括函数名、偏移地址、实际返回地址
//    char **strs = backtrace_symbols(callstack, frames);
//    
//    int i;
//    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
//    for (i = 0; i < frames; i++) {
//        
//        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
//    }
//    free(strs);
//    
//    return backtrace;
//}
//
////点击退出
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex {
//#pragma clang diagnostic pop
//    
//    if (anIndex == 0) {
//        
//        self.dismissed = YES;
//    }
//}
//
////处理报错信息
//- (void)validateAndSaveCriticalApplicationData:(NSException *)exception {
//    
//    
////    NSString *exceptionInfo = [NSString stringWithFormat:@"\n--------Log Exception---------\nappInfo             :\n%@\n\nexception name      :%@\nexception reason    :%@\nexception userInfo  :%@\ncallStackSymbols    :%@\n\n--------End Log Exception-----", getAppInfo(),exception.name, exception.reason, exception.userInfo ? : @"no user info", [exception callStackSymbols]];
////
////    NSLog(@"%@", exceptionInfo);
//    
//    
//    //    [exceptionInfo writeToFile:[NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    
//    //获取偏移地址
//    long slide = 0;
//    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
//        if (_dyld_get_image_header(i)->filetype == MH_EXECUTE) {
//            slide = _dyld_get_image_vmaddr_slide(i);
//            break;
//        }
//    }
//    
//    //    unsigned long long result = 0;
//    //    NSScanner *scanner = [NSScanner scannerWithString:[@"0x0000000100f2214c" substringFromIndex:2]];
//    //    [scanner scanHexLongLong:&result];
//    //    NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%16llx",result - 5759308]];
//    
//    NSArray *callStackSymbolsarr = [exception callStackSymbols];        //调用堆栈信息
//    NSString *reason = [exception reason];              //异常原因
//    NSString *name = [exception name];                  //异常类型
//    NSString *loginName = [LZUserDataManager readUserLoginName];
//    NSString *server = [LZUserDataManager readServer];
//    NSString *userName = [AppUtils GetCurrentUserName];
//    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
//    NSString *appVersion = [AppUtils getNowAppVersion];
//    NSString *strSlide = [NSString stringWithFormat:@"%ld",slide];
//    
//    NSString *urlStr = [NSString stringWithFormat:@"mailto://leadingenterprise@163.com?subject=LeadingCloud Crash Report"\
//                        "&body="
//                        "Name:<br>%@<br>"\
//                        "----------------------------------<br>Reason:%@"\
//                        "<br>----------------------------------<br>callStackSymbols:%@"\
//                        "<br>--------用户信息---------<br>登录名:%@<br>"\
//                        "用户名:%@<br>"\
//                        "服务器地址:%@<br>"\
//                        "Bundle ID:%@<br>"\
//                        "Slide Address:%@<br>"\
//                        "App Version:%@",
//                        name,reason,[callStackSymbolsarr componentsJoinedByString:@"<br>"],loginName,userName,server,identifier,strSlide,appVersion];
//    
//    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [[UIApplication sharedApplication] openURL:url];
//
//}
//
//- (void)handleException:(NSException *)exception {
//    
//    [self validateAndSaveCriticalApplicationData:exception];
//    
//    if (!showAlertView) {
//        return;
//    }
//    
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    UIAlertView *alert =
//    [[UIAlertView alloc]
//     initWithTitle:@"出错啦"
//     message:[NSString stringWithFormat:@"你可以尝试继续操作，但是应用可能无法正常运行.\n"]
//     delegate:self
//     cancelButtonTitle:@"退出"
//     otherButtonTitles:@"继续", nil];
//    [alert show];
//#pragma clang diagnostic pop
//    
//    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
//    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
//    
//    while (!self.dismissed) {
//        //点击继续
//        for (NSString *mode in (__bridge NSArray *)allModes) {
//            //快速切换Mode
//            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
//        }
//    }
//    
//    //点击退出
//    CFRelease(allModes);
//    
//    NSSetUncaughtExceptionHandler(NULL);
//    signal(SIGABRT, SIG_DFL);
//    signal(SIGILL, SIG_DFL);
//    signal(SIGSEGV, SIG_DFL);
//    signal(SIGFPE, SIG_DFL);
//    signal(SIGBUS, SIG_DFL);
//    signal(SIGPIPE, SIG_DFL);
//    
//    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
//        
//        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
//        
//    } else {
//        
//        [exception raise];
//    }
//}
//@end
//
//
//
//void HandleException(NSException *exception) {
//    
//    
//    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
//    // 如果太多不用处理
//    if (exceptionCount > UncaughtExceptionMaximum) {
//        return;
//    }
//    
//    //获取调用堆栈
//    NSArray *callStack = [exception callStackSymbols];
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
//    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
//    
//    //在主线程中，执行制定的方法, withObject是执行方法传入的参数
//    [[[UncaughtExceptionHandler alloc] init]
//     performSelectorOnMainThread:@selector(handleException:)
//     withObject:
//     [NSException exceptionWithName:[exception name]
//                             reason:[exception reason]
//                           userInfo:userInfo]
//     waitUntilDone:YES];
//    
//    
//    
//}
//
////处理signal报错
//void SignalHandler(int signal) {
//    
//    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
//    // 如果太多不用处理
//    if (exceptionCount > UncaughtExceptionMaximum) {
//        return;
//    }
//    
//    NSString* description = nil;
//    switch (signal) {
//        case SIGABRT:
//            description = [NSString stringWithFormat:@"Signal SIGABRT was raised!\n"];
//            break;
//        case SIGILL:
//            description = [NSString stringWithFormat:@"Signal SIGILL was raised!\n"];
//            break;
//        case SIGSEGV:
//            description = [NSString stringWithFormat:@"Signal SIGSEGV was raised!\n"];
//            break;
//        case SIGFPE:
//            description = [NSString stringWithFormat:@"Signal SIGFPE was raised!\n"];
//            break;
//        case SIGBUS:
//            description = [NSString stringWithFormat:@"Signal SIGBUS was raised!\n"];
//            break;
//        case SIGPIPE:
//            description = [NSString stringWithFormat:@"Signal SIGPIPE was raised!\n"];
//            break;
//        default:
//            description = [NSString stringWithFormat:@"Signal %d was raised!",signal];
//    }
//    
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    NSArray *callStack = [UncaughtExceptionHandler backtrace];
//    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
//    [userInfo setObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
//    
//    //在主线程中，执行指定的方法, withObject是执行方法传入的参数
//    [[[UncaughtExceptionHandler alloc] init]
//     performSelectorOnMainThread:@selector(handleException:)
//     withObject:
//     [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
//                             reason: description
//                           userInfo: userInfo]
//     waitUntilDone:YES];
//}
//
//NSString* getAppInfo() {
//    
//    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\n",
//                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
//                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
//                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
//                         [UIDevice currentDevice].model,
//                         [UIDevice currentDevice].systemName,
//                         [UIDevice currentDevice].systemVersion];
//    return appInfo;
//}

