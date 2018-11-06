//
//  LCProtocolManager.h
//  LeadingCloud
//
//  Created by wchMac on 16/7/14.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^LCProtocolManagerCallBack)(int resultType,id resultData);

@interface LCProtocolManager : NSObject

/* 插件编码 */
@property(nonatomic,strong) NSString *pluginCode;
/* 方法名称 */
@property(nonatomic,strong) NSString *methodName;
/* 源控制器 */
@property(nonatomic,strong) UIViewController *sourceController;

/* 参数 */
@property(nonatomic,strong) NSDictionary *parameters;
/* block回调 */
@property(nonatomic,copy) LCProtocolManagerCallBack callBack;


/**
 *  构造对象
 */
+(LCProtocolManager *)loadLCProtocolPluginCode:(NSString *)pluginCode methodName:(NSString *)methodName controller:(UIViewController *)sourceController;

/**
 *  运行
 */
-(void)runWithParameters:(NSDictionary *)parameters callBack:(LCProtocolManagerCallBack)callBack;

@end
