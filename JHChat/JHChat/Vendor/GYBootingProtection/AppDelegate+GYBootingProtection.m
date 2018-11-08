//
//  AppDelegate+GYBootingProtection.m
//  WeRead
//
//  Created by richliu on 16/5/19.
//

#import "AppDelegate+GYBootingProtection.h"
#import <objc/runtime.h>
#import "GYBootingProtection.h"

static NSString *const makeCrashAlertTitle = @"制造一个 Crash ？";
static NSString *const fixCrashAlertTitle = @"提示";
static NSString *const fixCrashButtonTitle = @"修复";
static NSString *const cancelButtonTitle = @"取消";
static NSString *const createCrashButtonTitle = @"制造Crash!";
static NSString *const mainStoryboardInfoKey = @"UIMainStoryboardFile";
#define IOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0

@implementation AppDelegate (GYBootingProtection)

/*
 * 连续闪退检测前需要执行的逻辑，如上报统计初始化
 */
- (void)onBeforeBootingProtection {

#pragma mark TODO
    
    [GYBootingProtection setLogger:^(NSString *msg) {
        // 设置Logger
        NSLog(@"%@", msg);
    }];
    
    [GYBootingProtection setReportBlock:^(NSInteger crashCounts) {
        // crash 上报逻辑
    }];
    
    // 彩蛋: 弹 Tips 询问是否制造 crash
    [GYBootingProtection setStartupCrashForTest:NO];
    [self showAlertForCreateCrashIfNeeded];
}


/*
 * 修复逻辑，如删除文件
 */
- (void)onBootingProtection {
#pragma mark TODO
    // TODO 可先检查 JSPatch 更新
    
    // 删除 Documents Library Caches 目录下所有文件
//    [GYBootingProtection deleteAllFilesUnderDocumentsLibraryCaches];
    /* 调用APPDelegate中的深度清理的方法 */
    [self deepClean];
}

- (void)onBootingProtectionWithCompletion:(BoolCompletionBlock)completion {
    [self onBootingProtection];
#pragma mark TODO 如果需要异步修复，在完成后调用 completion
    // 正常启动流程
    if (completion) completion();
}

#pragma mark - Method Swizzling

/**
 * 连续闪退检测逻辑，Method Swizzle 了原来 didFinishLaunch
 * 如果检测到连续闪退，提示用户进行修复
 */
- (BOOL)swizzled_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self onBeforeBootingProtection];
    
    // only protect tapping icon launch
    if (launchOptions != nil) {
        return [self swizzled_application:application didFinishLaunchingWithOptions:launchOptions];
    }

    /* ------- 启动连续闪退保护 ------- */
    
    [GYBootingProtection setBoolCompletionBlock:^BOOL{

        // 原 didFinishLaunch 正常启动流程
        return [self swizzled_application:application didFinishLaunchingWithOptions:launchOptions];
    }];
    [GYBootingProtection setRepairBlock:^(BoolCompletionBlock completion) {
        [self showAlertForFixContinuousCrashOnCompletion:completion];
    }];
    return [GYBootingProtection launchContinuousCrashProtect];
}

#pragma mark - 修复启动连续 Crash 逻辑
/**
 * 弹Tip询问用户是否修复连续 Crash
 * @param BoolCompletionBlock 无论用户是否修复，最后执行该 block 一次
 */
- (void)showAlertForFixContinuousCrashOnCompletion:(BoolCompletionBlock)completion {
    NSLog(@"Detect continuous crash %ld times. Prompt user to fix.",  (long)[GYBootingProtection crashCount]);
    /* 不出现弹框，直接进行修复 */
    [self tryToFixContinuousCrash:^BOOL {
        if (completion) return completion();
        return YES;
    }];
//    NSString *message = @"检测到应用可能已损坏，是否尝试修复？";
//    if (IOS8) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:fixCrashAlertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            if (completion) completion();
//        }];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:fixCrashButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alertController addAction:okAction];
//        [alertController addAction:cancelAction];
//        [self presentAlertViewController:alertController];
//    } else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:fixCrashAlertTitle
//                                                            message:message
//                                                           delegate:self
//                                                  cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel")
//                                                  otherButtonTitles:fixCrashButtonTitle, nil];
//        alertView.tag = 1;
//        [alertView show];
//    }
}

/**
 * 弹Tip询问用户是否制造 Crash
 */
- (void)showAlertForCreateCrashIfNeeded {
    if ([GYBootingProtection startupCrashForTest]) {
        NSString *message = [NSString stringWithFormat:@"已经连续 crash 了%ld 次\n可以在设置彩蛋取消这个提示", (long)[GYBootingProtection crashCount]];
        if (IOS8) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:makeCrashAlertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:createCrashButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // create crash
                id a = @"demo";
                [a numberOfRowsInSection:0];
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            
            [self presentAlertViewController:alertController];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:makeCrashAlertTitle
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel")
                                                      otherButtonTitles:createCrashButtonTitle, nil];
            alertView.tag = 2;
            [alertView show];
        }
    }
}

/** 
 * 对于代码构建 UI 的项目一般在 didFinishLaunch 方法中初始化 window，
 * 想在 swizzling 方法中 present alertController 需要自己先初始化 window 并提供一个 rootViewController
 */
- (void)presentAlertViewController:(UIAlertController *)alertController {
    if (![self hasStoryboardInfo]) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.rootViewController = [[UIViewController alloc] init];
    }
    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - UIAlert Delegate

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
//    switch (buttonIndex) {
//        case 0:
//            break;
//        case 1:
//        {
//            if(alertView.tag==1){
//                
//                [self tryToFixContinuousCrash:^BOOL {
//                    return YES;
//                }];
//            } else if (alertView.tag==2){
//                // create crash
//                id a = @"demo";
//                [a numberOfRowsInSection:0];
//            }
//            break;
//        }
//        default:
//            break;
//    }
//}
/**
 * 判断项目是否是用 info.plist 配置 storyboard 的，
 * 是的话就不需要手动初始化 window 和 rootViewController
 */
- (BOOL)hasStoryboardInfo {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:mainStoryboardInfoKey];
}

- (void)tryToFixContinuousCrash:(BoolCompletionBlock)completion
{
    [self onBootingProtectionWithCompletion:completion];
}

#pragma mark - Method Swizzling
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [super class];
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(application:didFinishLaunchingWithOptions:);
        SEL swizzledSelector = @selector(swizzled_application:didFinishLaunchingWithOptions:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

@end
