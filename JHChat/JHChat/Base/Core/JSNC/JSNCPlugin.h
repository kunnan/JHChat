/************************************************************
 Author:  lz-fzj
 Date：   2016-03-29
 Version: 1.0
 Description: 【通用模块】-【JavaScript和Native通信通道】插件基类
                            开发的注意事项：
                                    》.进行插件扩展时：
                                                1.引入头文件“JSNCPlugin.h”，必须继承基类【JSNCPlugin】
                                                2.方法只能有一个参数，并且参数类型必须是【JSNCRunParameter】，例如“-(void)fzjTest:(JSNCRunParameter *)runParameter;”
                                    》.插件实例化对象，默认是在子线程中运行的，如果要涉及操作界面上的东西，要返回主线程进行操作
                                                基类已经提供了：1.在主线程执行代码块的方法；2.各种控制器的显示和隐藏相关操作
                                    》.如果插件调用了控制器，并需要控制器返回结果给插件本身，建议使用机制：
                                                通知和EventBus，并且用runParameter中的runTimeId作为通知名称和事件名称，因为runTimeId每次运行都是唯一的。
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <UIKit/UIKit.h>
#import "JSNCParameter.h"

typedef void (^LCProtocolManagerSendRunResult)(JSNCRunResult * __nonnull runResult);

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】插件基类
/**
 *  【通用模块】-【JavaScript和Native通信通道】插件基类
 */
@class JSNCWebView;

@interface JSNCPlugin : NSObject

@property (strong, nonatomic) NSMutableDictionary * __nonnull lcProtocolManagerParaDic;


#pragma mark - 给子类提供的一些基础方法
/**
 *  在主线程中执行代码块
 *  @param block 要执行的代码块【代码块传入的controller为插件运行所在的controller】
 */
-(void)executeBlockInMainThread:(void(^ __nonnull)(UIViewController*  __nonnull controller))block;

/**
 *  发送插件的运行结果
 *  @param runResult 运行结果对象
 */
-(void)sendRunResult:(JSNCRunResult * __nonnull)runResult;

#pragma mark 控制器的显示和隐藏相关操作
/**
 *  通过插件打开新的控制器
 *  @param newController 要打开的新的控制器
 *  @param animated   是否使用动画
 */
-(void)pushViewController:(UIViewController *__nonnull)newController animated:(Boolean)animated;

/**
 *  弹出到根视图控制器
 *  @param animated 是否使用动画
 */
-(void)popToRootViewControllerAnimated:(Boolean)animated;

/**
 *  弹出到指定的控制器
 *  @param toController 目标控制器
 *  @param animated   是否使用动画
 */
-(void)popToViewController:(UIViewController *__nonnull)toController animated:(Boolean)animated;

/**
 *  弹出当前视图控制器
 *  @param animated 是否使用动画
 */
-(void)popViewControllerAnimated:(Boolean)animated;

/**
 *  模态显示新的控制器
 *  @param controller 要模态显示的新控制器
 *  @param animated   是否使用动画
 */
-(void)presentViewController:(UIViewController *__nonnull)newController animated:(Boolean)animated;

/**
 *  移除模态弹窗的控制器
 *  @param animated 是否使用动画
 */
-(void)dismissViewControllerAnimated:(Boolean)animated;
-(UIViewController * _Nonnull)getController:(UIViewController * _Nonnull)controller;
@end
