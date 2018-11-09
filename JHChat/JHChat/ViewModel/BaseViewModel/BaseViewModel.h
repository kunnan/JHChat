//
//  BaseViewModel.h
//  LeadingCloud
//
//  Created by wchMac on 15/11/16.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"

#import "LZService.h"

/**
 联系人模块页面视图模式
 */
typedef NS_ENUM(NSUInteger ,ContactPageViewMode) {
    /**
     *  正常模式（默认）
     */
    ContactPageViewModeDefault,
    
    /**
     *  人员选择模式
     */
    ContactPageViewModeSelect,
    
    /**
     *  选择成员（单选）
     */
    ContactPageViewModeSelectSinglePerson,
    
    /**
     *  发起聊天（多选）
     */
    ContactPageViewModeCreatChat,
    /**
     *  选择成员（多选）
     */
    ContactPageViewModeSelectPerson,
    
    /**
     *  【部门】选择上级部门的（单选）
     */
    ContactPageViewModeSelectParentDepartment2Department,
    /**
     *  【员工】选择所属部门（多选）
     */
    ContactPageViewModeSelectParentDepartment2Employee,
    
    /**
     *  组织管理的管理模式
     */
    ContactPageViewModeEnterpriseManage,
    
    /**
     *  组织管理中选择部门主管
     */
    ContactPageViewModeSelectDepartmentAdmin,
    
    /**
     *  组织管理中添加部门
     */
    ContactPageViewModeAddDepartment
};

/**
 * 联系人数据的加载模式
 */
typedef NS_ENUM(NSUInteger ,ContactDataLoadMode){
    /**
     *  一次性加载所有数据
     */
    ContactDataLoadModeAll,
    /**
     *  分页加载数据
     */
    ContactDataLoadModePage
};
/**
 *  联系人数据的加载状态
 */
typedef NS_ENUM(NSUInteger ,ContactDataLoadStatus){
    /**
     *  还未开始加载数据
     */
    ContactDataLoadStatusNotStart=0,
    /**
     *  正在加载数据
     */
    ContactDataLoadStatusLoading,
    /**
     *  数据加载完成了
     */
    ContactDataLoadStatusLoaded
    
};
/**
 *  联系人视图即将展现的时候要做的操作
 */
typedef NS_ENUM(NSUInteger ,ContactViewWillAppearAction){
    /**
     *  啥都不做
     */
    ContactViewWillAppearActionNone=0,
    /**
     *  刷新数据【重新从数据库中取】
     */
    ContactViewWillAppearActionRefrenshData,
} ;

//                          WebApi操作成功
#define Contact_ToolTip_WebApi_Operation_Success LZGDCommonLocailzableString(@"common_operation_yes")
//                          WebApi操作失败
#define Contact_ToolTip_WebApi_Operation_Failed LZGDCommonLocailzableString(@"common_operation_fail_retry")

@interface BaseViewModel : NSObject

@property(nonatomic,strong) id dataSource2;

@property(nonatomic,strong) id filterDataSource2;

#pragma mark - 供子类继承重写的方法

/**
 *  加载所有数据
 */
-(void)loadAllDataSource2;

/**
 *  获取搜索后的数据源
 *
 *  sarchText 搜索内容
 */
-(void)getViewSearchDataSource:(NSString *)sarchText;
#pragma mark - 调用底层

/**
 *  获取共有Delegate
 */
- (AppDelegate *)appDelegate;

#pragma mark - Loading

/**
 *  显示加载的loading，没有文字的
 */
- (void)showLoading;
/**
 *  显示加载的loading，有文字(正在加载...)
 */
-(void)showLoadingInfo;
/**
 *  显示等待提示
 *  @param text 提示内容
 */
-(void)showLoadingWithText:(NSString *)text;
/**
 *  显示警告信息
 *  @param text 信息内容
 */
-(void)showMessageInfoWithText:(NSString*)text;

/**
 *  显示成功的HUD(无文字)
 */
- (void)showSuccess;
/**
 *  显示成功提示
 *  @param text 提示内容
 */
-(void)showSuccessWithText:(NSString *)text;
/**
 *  显示成功的HUD(带文字)
 */
-(void)showSuccessHaveText;
/**
 *  显示错误的HUD
 */
- (void)showError;
/**
 *  显示错误提示
 *  @param text 提示内容
 */
-(void)showErrorWithText:(NSString *)text;
/**
 *  隐藏在该View上的所有HUD，不管有哪些，都会全部被隐藏
 */
- (void)hideLoading;
/**
 *  显示webapi请求返回的错误信息
 */
-(void)showErrorWithErrorCode:(NSDictionary *)data;
/**
 *  显示网络连接失败，无参数型
 */
-(void)showNetWorkConnectFail;
/**
 *  显示警告信息
 */
-(void)showWarningWithText:(NSString *)text;

@end
