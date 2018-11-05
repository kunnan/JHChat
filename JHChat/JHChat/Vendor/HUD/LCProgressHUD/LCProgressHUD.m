//
//  Created by lz on 15/12/31.
//  Copyright (c) 2015年 Leo. All rights reserved.
//
//  Email : leoios@sina.com
//  GitHub: http://github.com/LeoiOS
//  如有问题或建议请给我发 Email, 或在该项目的 GitHub 主页 Issues 我, 谢谢:)
//
//  活动指示器

#import "LCProgressHUD.h"

// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 文字大小
#define TEXT_SIZE    16.0f

@implementation LCProgressHUD

+ (instancetype)sharedHUD {
    
    static LCProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hud = [[LCProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

+ (instancetype)sharedHideHUDForNotClickHide {
    
    static LCProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hud = [[LCProgressHUD alloc] initWithWindowForNotClickHide:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

+ (instancetype)sharedHideHUDForNotClickHide2 {
    
    static LCProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hud = [[LCProgressHUD alloc] initWithWindowForNotClickHide2:[UIApplication sharedApplication].keyWindow];
        hud.isNotShowStatus2 = NO;
    });
    return hud;
}

/** 在 window 上添加一个 HUD */
+ (LCProgressHUD *)showStatus:(LCProgressHUDStatus)status text:(NSString *)text isnotclicktohide:(BOOL)isnotclicktohide{
    return [self showStatus:status text:text isnotclicktohide:isnotclicktohide isDetailsLabelText:NO];
}
+ (LCProgressHUD *)showStatus2:(LCProgressHUDStatus)status text:(NSString *)text isnotclicktohide:(BOOL)isnotclicktohide{
    return [self showStatus2:status text:text isnotclicktohide:isnotclicktohide isDetailsLabelText:NO];
}

+ (LCProgressHUD *)showStatus:(LCProgressHUDStatus)status text:(NSString *)text{
    return [self showStatus:status text:text isnotclicktohide:NO isDetailsLabelText:NO];
}
+ (LCProgressHUD *)showStatus:(LCProgressHUDStatus)status text:(NSString *)text isDetailsLabelText:(BOOL)isDetailsLabelText{
    return [self showStatus:status text:text isnotclicktohide:NO isDetailsLabelText:isDetailsLabelText];
}

+ (LCProgressHUD *)showStatus:(LCProgressHUDStatus)status text:(NSString *)text isnotclicktohide:(BOOL)isnotclicktohide isDetailsLabelText:(BOOL)isDetailsLabelText{
    
    LCProgressHUD *hud = [LCProgressHUD sharedHUD];
    
    if(isnotclicktohide){
        hud = [LCProgressHUD sharedHideHUDForNotClickHide];
    }
    hud.labelText = nil;
    hud.detailsLabelText = nil;
    [hud show:YES];
    [hud setRemoveFromSuperViewOnHide:YES];
    if(isDetailsLabelText){
        [hud setDetailsLabelText:text];
        [hud setDetailsLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    }else{
        [hud setLabelText:text];
        [hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    }
    [hud setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"LCProgressHUD" ofType:@"bundle"];
    
    switch (status) {
            
        case LCProgressHUDStatusSuccess: {
            
            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"new/checkmark.png"];
            UIImage *sucImage = [UIImage imageWithContentsOfFile:sucPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            hud.customView = sucView;
            [hud hide:YES afterDelay:2.0f];
        }
            break;
            
        case LCProgressHUDStatusError: {
            
            NSString *errPath = [bundlePath stringByAppendingPathComponent:@"new/cross.png"];
            UIImage *errImage = [UIImage imageWithContentsOfFile:errPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            hud.customView = errView;
            [hud hide:YES afterDelay:2.0f];
        }
            break;
            
        case LCProgressHUDStatusWaitting: {
            
            hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
        case LCProgressHUDStatusInfo: {
            
            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"warning.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            hud.customView = infoView;
            [hud hide:YES afterDelay:2.0f];
        }
            break;
            
        default:
            break;
    }
    
    return hud;
}


+ (LCProgressHUD *)showStatus2:(LCProgressHUDStatus)status text:(NSString *)text isnotclicktohide:(BOOL)isnotclicktohide isDetailsLabelText:(BOOL)isDetailsLabelText{
    
    LCProgressHUD *hud = [LCProgressHUD sharedHUD];
    
    if(isnotclicktohide){
        hud = [LCProgressHUD sharedHideHUDForNotClickHide2];
    }
    hud.labelText = nil;
    hud.detailsLabelText = nil;
    [hud show:YES];
    [hud setRemoveFromSuperViewOnHide:YES];
    if(isDetailsLabelText){
        [hud setDetailsLabelText:text];
        [hud setDetailsLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    }else{
        [hud setLabelText:text];
        [hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    }
    [hud setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"LCProgressHUD" ofType:@"bundle"];
    
    switch (status) {
            
        case LCProgressHUDStatusSuccess: {
            
            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"new/checkmark.png"];
            UIImage *sucImage = [UIImage imageWithContentsOfFile:sucPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            hud.customView = sucView;
            [hud hide:YES afterDelay:2.0f];
        }
            break;
            
        case LCProgressHUDStatusError: {
            
            NSString *errPath = [bundlePath stringByAppendingPathComponent:@"new/cross.png"];
            UIImage *errImage = [UIImage imageWithContentsOfFile:errPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            hud.customView = errView;
            [hud hide:YES afterDelay:2.0f];
        }
            break;
            
        case LCProgressHUDStatusWaitting: {
            
            hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
        case LCProgressHUDStatusInfo: {
            
            NSString *infoPath = [bundlePath stringByAppendingPathComponent:@"warning.png"];
            UIImage *infoImage = [UIImage imageWithContentsOfFile:infoPath];
            
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            hud.customView = infoView;
            [hud hide:YES afterDelay:2.0f];
        }
            break;
            
        default:
            break;
    }
    
    return hud;
}



+ (LCProgressHUD *)showMessage:(NSString *)text {
    
    LCProgressHUD *hud = [LCProgressHUD sharedHUD];
    [hud show:YES];
    [hud setLabelText:text];
//    [hud setDetailsLabelText:text];
    [hud setMinSize:CGSizeZero];
    [hud setMode:MBProgressHUDModeText];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
//    [hud setDetailsLabelFont:[UIFont boldSystemFontOfSize:TEXT_SIZE]];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud hide:YES afterDelay:2.0f];
    
    return hud;
}

+ (LCProgressHUD *)showInfoMsg:(NSString *)text{
    return [self showStatus:LCProgressHUDStatusInfo text:text];
}
+ (LCProgressHUD *)showInfoMsg:(NSString *)text isDetailsLabelText:(BOOL)isDetailsLabelText{
    
    return [self showStatus:LCProgressHUDStatusInfo text:text isDetailsLabelText:isDetailsLabelText];
}

+ (LCProgressHUD *)showFailure:(NSString *)text{
    return [self showStatus:LCProgressHUDStatusError text:text];
}
+ (LCProgressHUD *)showFailure:(NSString *)text isDetailsLabelText:(BOOL)isDetailsLabelText{
    
    return [self showStatus:LCProgressHUDStatusError text:text isDetailsLabelText:isDetailsLabelText];
}

+ (LCProgressHUD *)showSuccess:(NSString *)text{
    return [self showStatus:LCProgressHUDStatusSuccess text:text];
}
+ (LCProgressHUD *)showSuccess:(NSString *)text isDetailsLabelText:(BOOL)isDetailsLabelText{
    
    return [self showStatus:LCProgressHUDStatusSuccess text:text isDetailsLabelText:isDetailsLabelText];
}

+ (LCProgressHUD *)showLoading:(NSString *)text{
    return [self showStatus:LCProgressHUDStatusWaitting text:text];
}
+ (LCProgressHUD *)showLoading:(NSString *)text isDetailsLabelText:(BOOL)isDetailsLabelText{
    
    return [self showStatus:LCProgressHUDStatusWaitting text:text isDetailsLabelText:isDetailsLabelText];
}

+ (LCProgressHUD *)showLoadingForNotClickHide:(NSString *)text {
    
    return [self showStatus:LCProgressHUDStatusWaitting text:text isnotclicktohide:YES];
}

+ (LCProgressHUD *)showLoadingForNotClickHide2:(NSString *)text {
    if([LCProgressHUD sharedHideHUDForNotClickHide2].isNotShowStatus2){
        return nil;
    }
    else{
        return [self showStatus2:LCProgressHUDStatusWaitting text:text isnotclicktohide:YES];
    }
}

+ (void)hide {
    
    [[LCProgressHUD sharedHUD] hide:YES];
    [[LCProgressHUD sharedHideHUDForNotClickHide] hide:YES];
}


+ (void)hideForNotClick {
    [[LCProgressHUD sharedHideHUDForNotClickHide2] hide:YES];
}

@end
