/************************************************************
 Author:  lz-fzj
 Date：   2016-03-29
 Version: 1.0
 Description: 【通用模块】-【JavaScript和Native通信通道】浏览器控件
 浏览器控件的备注：
 1.浏览器支持的调用插件，目前完全通过外部代码去控制，后续考虑将系统一些默认的基础插件自动话注册，减少外部注册的工作量
 2.浏览器控件的delegate必须为类【JSNCWebViewDelegate】的实例或者子类实例
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class JSNCRunResult;
@class JSNCWebViewDelegate;

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】浏览器控件

typedef void (^AlertCompletionHandler)();

/**
 *  【通用模块】-【JavaScript和Native通信通道】浏览器控件
 *          使用此控件时，请保证其delegate实例继承自【JSNCWebViewDelegate】
 */
@interface JSNCWebView : WKWebView
/**
 *  【只读】浏览器控件的唯一Id
 */
@property(nonatomic,copy,readonly,nonnull)NSString *uniqueId;

/**
 *  【只读】浏览器控件所在的UIViewController对象
 *      备注：调用此属性时，请保证浏览器控件已经加入到ViewController中，否则获取出来为nill
 */
@property(nonatomic,copy,readonly,nonnull)UIViewController *controller;

@property(nonatomic,strong) UIProgressView * _Nullable progressView;

//是否处于弹出View视图中
@property (assign,nonatomic) BOOL isInOpenViewDialog;

@property(nonatomic,copy) AlertCompletionHandler __nullable alertCompletionHandler;

#pragma mark - 公共方法
/**
 *  注册插件
 *  @param pluginCode  插件id
 *  @param pluginClass 继承JSNCPlugin的插件实现类
 */
-(void)registerPlugin:(NSString * __nonnull)pluginCode pluginClass:(Class __nonnull)pluginClass;

#pragma mark - 兼容UIWebView 和 WKWebView
/*
 *  执行JS方法
 */
- (void)lzEvaluateJavaScript:(NSString *_Nullable)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;

/*
 *  设置Delegate
 */
- (void)lzJSNCWebViewDelegate:(NSObject *_Nullable)delegate;

@end

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】浏览器控件的委托处理类
/**
 *  【通用模块】-【JavaScript和Native通信通道】浏览器控件的委托处理类
 *          负责处理浏览器控件的网络监听，保障JavaScript和Native之间通道的畅通
 */
@interface JSNCWebViewDelegate : NSObject<WKNavigationDelegate>

// 浏览器将要加载请求的时候
-(BOOL)lzWebView:(UIWebView *_Nullable)webView shouldStartLoadWithRequest:(NSURLRequest *_Nullable)request navigationType:(UIWebViewNavigationType)navigationType wkWebView:(WKWebView *_Nullable)wkWebView shouldStartProvisionalNavigation:(WKNavigation *_Nullable)navigation;

// 浏览器开始加载请求的时候---调用父方法之前
-(void)lzWebViewBeforeDidStartLoad:(UIWebView *_Nullable)webView wkWebView:(WKWebView *_Nullable)wkWebView didStartProvisionalNavigation:(WKNavigation *_Nullable)navigation;

// 浏览器开始加载请求的时候---调用父方法之后
-(void)lzWebViewAfterDidStartLoad:(UIWebView *_Nullable)webView wkWebView:(WKWebView *_Nullable)wkWebView didStartProvisionalNavigation:(WKNavigation *_Nullable)navigation;

// 页面加载完成以后---调用父方法之前
- (void )lzWebViewBeforeDidFinishLoad:(UIWebView  *_Nullable)webView wkWebView:(WKWebView *_Nullable)wkWebView didFinishNavigation:(WKNavigation *_Nullable)navigation;

// 页面加载完成以后---调用父方法之后
- (void )lzWebViewAfterDidFinishLoad:(UIWebView  *_Nullable)webView wkWebView:(WKWebView *_Nullable)wkWebView didFinishNavigation:(WKNavigation *_Nullable)navigation;

// 页面加载发生错误的时候
-(void)lzWebView:(UIWebView *_Nullable)webView didFailLoadWithError:(NSError *_Nullable)error wkWebView:(WKWebView *_Nullable)wkWebView didFailProvisionalNavigation:(WKNavigation *_Nullable)navigation withError:(NSError *_Nullable)wkError;

@end
#pragma mark - 【通用模块】- WKUIDelegate 的委托处理类
/**
 *  【通用模块】- 用于重新alert,confirm,prompt
 */
@interface JSNCUIDelegate:NSObject<WKUIDelegate>
@end

