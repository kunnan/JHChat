/************************************************************
 Author:  lz-fzj
 Date：   2016-03-29
 Version: 1.0
 Description: 【通用模块】-【JavaScript和Native通信通道】通信通道的管理者
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

@class JSNCWebView;
@class JSNCRunParameter;

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】通信通道的管理者
/**
 *  【通用模块】-【JavaScript和Native通信通道】通信通道的管理者
 *              此类的实现在【JSNCPlugin.m】中
 */
@interface JSNCManager : NSString
/**
 *  运行结果的消息通知名称
 */
@property(nonatomic,readonly,copy,nonnull)NSString *notificatioName2RunResult;

/**
 *  【静态】加载管理者实例【不存在则自动构建新实例】
 *  @param webView 浏览器对象
 *  @return 管理者实例
 */
+(JSNCManager * __nonnull)loadManager:(JSNCWebView *__nonnull)webView;

/**
 *  【静态】卸载管理者实例
 *  @param webView 浏览器对象
 */
+(void)unloadManager:(JSNCWebView * __nonnull)webView;

/**
 *  注册插件
 *  @param pluginCode 插件编码
 *  @param pluginClass 继承JSNCPlugin的插件实现类
 */
-(void)registerPluginWithPluginCode:(NSString * __nonnull)pluginCode pluginClass:(Class __nonnull)pluginClass;

/**
 *  运行插件
 *  @param runParameter 插件运行时参数
 */
-(void)runPlugin:(JSNCRunParameter * __nonnull)runParameter;

@end