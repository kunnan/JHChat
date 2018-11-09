//
//  BaseViewModel.m
//  LeadingCloud
//
//  Created by wchMac on 15/11/16.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "BaseViewModel.h"
#import "LCProgressHUD.h"
#import "ErrorCodeUtil.h"
#import "LZBaseAppDelegate.h"

@implementation BaseViewModel

#pragma mark - 供子类继承重写的方法

/**
 *  加载所有数据
 */
-(void)loadAllDataSource2{
    
}
/**
 *  获取搜索后的数据源
 *
 *  sarchText 搜索内容
 */
-(void)getViewSearchDataSource:(NSString *)sarchText {
    
}
#pragma mark - 调用底层

/**
 *  获取共有Delegate
 */
- (AppDelegate *)appDelegate
{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    return appDelegate;
}

#pragma mark - Loading

/**
 *  显示加载的loading，没有文字的
 */
- (void)showLoading{
    [self showLoadingWithText:nil];
}
/**
 *  显示加载的loading，有文字(正在加载...)
 */
-(void)showLoadingInfo {
    [LCProgressHUD showLoading:LCProgreaaHUD_Show_Loading];
}
/**
 *  显示等待提示
 *  @param text 提示内容
 */
- (void)showLoadingWithText:(NSString *)text {
    [LCProgressHUD showLoading:text];
}
/**
 *  显示警告信息
 *  @param text 信息内容
 */
-(void)showMessageInfoWithText:(NSString*)text {
    [LCProgressHUD showInfoMsg:text];
}

/**
 *  显示成功的HUD
 */
- (void)showSuccess{
    [self showSuccessWithText:nil];
}
/**
 *  显示成功提示
 *  @param text 提示内容
 */
-(void)showSuccessWithText:(NSString *)text{
    [LCProgressHUD showSuccess:text];
}
/**
 *  显示成功的HUD(带文字)
 */
-(void)showSuccessHaveText {
    [LCProgressHUD showSuccess:LCProgressHUD_Show_Success];
}
/**
 *  显示错误的HUD
 */
- (void)showError{
    [self showErrorWithText:nil];
}
/**
 *  显示错误提示
 *  @param text 提示内容
 */
-(void)showErrorWithText:(NSString *)text{
    [LCProgressHUD showFailure:text];
}
/**
 *  隐藏在该View上的所有HUD，不管有哪些，都会全部被隐藏
 */
- (void)hideLoading{
    [LCProgressHUD hide];
}
/**
 *  显示webapi请求返回的错误信息
 */
-(void)showErrorWithErrorCode:(NSDictionary *)data{
    NSDictionary *errorCode = nil;
    if([[data allKeys] containsObject:WebApi_ErrorCode]){
        errorCode = [data lzNSDictonaryForKey:WebApi_ErrorCode];
    }
    else if( [[data allKeys] containsObject:@"Message"] && [[data allKeys] containsObject:@"Code"] ){
        errorCode = data;
    }
    
    /* 弹出提示信息 */
    if(errorCode==nil){
        [self showError];
    }
    else {
        //        [LCProgressHUD showFailure:[errorCode objectForKey:@"Message"]];
        NSString *message = [[ErrorCodeUtil shareInstance] getMessageFromErrorCode:errorCode];
        if(![message isEqualToString:@"-"]){
            [LCProgressHUD showFailure:message];
        }
    }
}
/**
 *  显示网络连接失败，无参数型
 */
-(void)showNetWorkConnectFail{
    
    [LCProgressHUD showFailure:LCProgressHUD_Show_NetWorkConnectFail];
}
/**
 *  显示警告信息
 */
-(void)showWarningWithText:(NSString *)text {
    [LCProgressHUD showInfoMsg:text];
}


@end
