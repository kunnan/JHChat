/************************************************************
 Author:  lz-fzj
 Date：   2016-03-29
 Version: 1.0
 Description: 【通用模块】-【JavaScript和Native通信通道】浏览器控件
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <JavaScriptCore/JavaScriptCore.h>
#import "JSNCWebView.h"
#import "JSNCManager.h"
#import "LZBaseAppDelegate.h"
#import "JSNCParameter.h"

#import "UIView+MemoryLeak.h"

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】浏览器控件
/**
 *  【通用模块】-【JavaScript和Native通信通道】浏览器控件
 */
@interface JSNCWebView()<WKScriptMessageHandler,UIAlertViewDelegate>
/**
 *  插件通道管理者
 */
@property(nonatomic,weak) JSNCManager *pluginManager;
@end
@implementation JSNCWebView{
    JSNCWebViewDelegate *tmpDelegate;
    JSNCUIDelegate *uiDelegate;
    Boolean hasInitialDefaultValue;
}
@synthesize uniqueId=_uniqueId;

#pragma mark - 公共方法
/**
 *  注册插件
 *  @param pluginCode  插件id
 *  @param pluginClass 继承JSNCPlugin的插件实现类
 */
-(void)registerPlugin:(NSString * __nonnull)pluginCode pluginClass:(Class __nonnull)pluginClass{
    [self.pluginManager registerPluginWithPluginCode:pluginCode pluginClass:pluginClass];
}

#pragma mark - 生命周期
/**
 *  初始化的方法
 *  @return
 */
-(instancetype)init{
    if(self=[super init]){
        [self setPropertyValueWhileInit];
    }
    return self;
}

/**
 *  通过StoryBoard创建浏览器控件的时候的初始化方法
 *  @param aDecoder
 *  @return
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super initWithCoder:aDecoder]){
        [self setPropertyValueWhileInit];
    }
    return self;
}

/**
 *  通过制定Frame初始化控件时的初始化方法
 *  @param frame
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setPropertyValueWhileInit];
    }
    return self;
}

/**
 *  通过制定Frame初始化控件时的初始化方法
 *  @param frame
 *  @param configuration
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration{
    if (self=[super initWithFrame:frame configuration:configuration]) {
        [self setPropertyValueWhileInit];
    }
    return self;
}

/**
 *  在初始化的时候设置属性值
 */
-(void)setPropertyValueWhileInit{
    //      保证此方法只执行一次
    if(hasInitialDefaultValue==true) return;
    hasInitialDefaultValue=true;
    //    //      设置浏览器控件本身的默认属性
    //    [self setScalesPageToFit:YES];
    self.scrollView.bounces=NO;
    self.scrollView.bouncesZoom=NO;
    //    [self setDataDetectorTypes:UIDataDetectorTypeNone];  //不检测电话号码
    //    /* 使用focus时，弹出键盘 */
    //    self.keyboardDisplayRequiresUserAction = NO;
    //      设置默认的委托处理类
    tmpDelegate = [[JSNCWebViewDelegate alloc]init];
    //    self.navigationDelegate = tmpDelegate;
    [self lzJSNCWebViewDelegate:tmpDelegate];
    
    uiDelegate = [[JSNCUIDelegate alloc] init];
    [self setUIDelegate:uiDelegate];
    //      加载通信通道管理者
    JSNCManager *tmpManager=[JSNCManager loadManager:self];
    _pluginManager=tmpManager;
    //      注册通知中心：【插件运行结果】
    [[NSNotificationCenter defaultCenter] removeObserver:self name:tmpManager.notificatioName2RunResult object:tmpManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceivedPluginRunResultNotification:) name:tmpManager.notificatioName2RunResult object:tmpManager];
    // 注册JS回调的方法
    [[self configuration].userContentController addScriptMessageHandler:self name:@"__JSNCBridge__"];
}
-(BOOL)willDealloc {
    return NO;
}
/**
 *  对象销毁的时候，清除掉所有的注册插件
 */
-(void)dealloc{
    //    NSLog(@"JSNCWebView销毁了");
    //      销毁的时候，把网络活动状态隐藏掉
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
    //      移除所有的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    tmpDelegate = nil;
    uiDelegate = nil;
    //      销毁插件管理者对象
    _pluginManager=nil;
    [JSNCManager unloadManager:self];
}

#pragma mark - JS回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    
    JSNCRunParameter *runParameter=[JSNCRunParameter parameterWithJSONString:message.body];
    //          运行插件：先统一做成异步
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            [self.pluginManager runPlugin:runParameter];
        }
        @catch (NSException *exception) {
            //      能跑到这里的异常，都是通道管理者无法将信息细化到每个插件的结果处理中，所以需要做个保险套
            NSLog(@"插件运行出错。详细信息：%@",exception.reason);
        }
    });
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        /* 一直走着 */
        //        for (float i = 0; i <= 1;i += 0.002) {
        //            if (i >=0.8) {
        //                sleep(0.1);
        //            }
        //            self.progressView.progress = i;
        //        }
        
        //self.progressView.progress = (self.progressView.progress >= self.estimatedProgress) ? self.progressView.progress:self.estimatedProgress;
        [self.progressView setProgress:self.estimatedProgress animated:YES];
        // self.progressView.progress = self.webView.estimatedProgress;
        NSLog(@"wkwebview进度：%f  estimatedProgress:%f",self.progressView.progress,self.estimatedProgress);
        if (self.progressView.progress == 1) {
            [UIView animateWithDuration:0.7 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.progressView.alpha = 0.0;
            } completion:^(BOOL completed){
                CGRect frame = self.progressView.frame;
                frame.size.width = 0;
                self.progressView.frame = frame;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

#pragma mark - 通知中心
/**
 *  接收到插件运行结果的通知
 *  @param notification
 */
-(void)onReceivedPluginRunResultNotification:(NSNotification *)notification{
    //          进行通知的校验，必须是当前管理者发出的，并且插件运行结果有值
    if(notification.object!=self.pluginManager) return;
    if(notification.userInfo==nil||[notification.userInfo.allKeys containsObject:@"data"]==false) return;
    id tmpData=[notification.userInfo objectForKey:@"data"];
    if([tmpData isKindOfClass:[JSNCRunResult class]]==false) return;
    //          处理插件的运行结果，将插件运行结果组装为json字符串
    JSNCRunResult *runResult=(JSNCRunResult *)tmpData;
    [self sendPluginRunResult2JavaScript:runResult];
}

#pragma mark - 浏览器控件处理插件运行结果，发送给JavaScript前台处理
/**
 *  获取插件的运行结果
 *  @param runResult 插件的运行结果
 */
-(void)sendPluginRunResult2JavaScript:(JSNCRunResult *)runResult{
    //              组装运行结果数据
    NSDictionary *postMessageData=[runResult result2Dictionary];
    postMessageData=@{
                      @"action":@"JSNC_RunResult",
                      @"result":postMessageData
                      };
    //              转成JSON
    NSError *error;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:postMessageData options:NSJSONWritingPrettyPrinted error:&error];
    if(jsonData.length>0&&error==nil){
        NSString *jsonString=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"插件运行结果数据：%@",jsonString);
        NSString *javaScriptString=[NSString stringWithFormat:@"window.postMessage(%@,'*');",jsonString];
        [self evaluateJavaScript:javaScriptString completionHandler:nil];
    }
    else NSLog(@"将运行结果转换为JSON数据失败");
}

#pragma mark - Setter、Getter
/**
 *  取得唯一标记值
 *  @return
 */
-(NSString *)uniqueId{
    if(_uniqueId==nil){
        CFUUIDRef   uuid;
        CFStringRef uuidStr;
        uuid = CFUUIDCreate(NULL);
        uuidStr = CFUUIDCreateString(NULL, uuid);
        _uniqueId =[NSString stringWithFormat:@"%@", uuidStr];
        CFRelease(uuidStr);
        CFRelease(uuid);
    }
    return _uniqueId;
}
/**
 *  浏览器控件所在的UIViewController对象
 *  @return
 */
-(UIViewController *)controller{
   __block UIViewController *tmpController = [[UIViewController alloc] init]; // nil;
    
    if (@available(iOS 12.0, *)) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIResponder *tmpResponder=[self nextResponder];
            while (tmpResponder) {
                if([tmpResponder isKindOfClass:[UIViewController class]]){
                    tmpController=(UIViewController *)tmpResponder;
                    break;
                }
                tmpResponder=[tmpResponder nextResponder];
            }
            NSLog(@"iOS12要走主线程001");
        });
    }
    else {
        UIResponder *tmpResponder=[self nextResponder];
        while (tmpResponder) {
            if([tmpResponder isKindOfClass:[UIViewController class]]){
                tmpController=(UIViewController *)tmpResponder;
                break;
            }
            tmpResponder=[tmpResponder nextResponder];
        }
    }
   
    NSLog(@"iOS12要走完主线程002");
    return tmpController;
}
///**
// *  设置WebView控件的委托处理类
// *  @param delegate
// */
//-(void)setNavigationDelegate:(id<WKNavigationDelegate>)delegate{
//    [super setNavigationDelegate:delegate];
//    //          设置完成以后，将当前浏览器控件默认的委托处理类去掉
//    if(delegate!=tmpDelegate){
//            tmpDelegate=nil;
//    }
//}
-(void)setUIDelegate:(id<WKUIDelegate>)delegate{
    [super setUIDelegate:delegate];
    //          设置完成以后，将当前浏览器控件默认的委托处理类去掉
    if(delegate!=uiDelegate){
        uiDelegate=nil;
    }
}

#pragma mark - 兼容UIWebView 和 WKWebView
/*
 *  执行JS方法
 */
- (void)lzEvaluateJavaScript:(NSString *_Nullable)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler{
    [self evaluateJavaScript:javaScriptString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        completionHandler(data,error);
    }];
}

/*
 *  设置Delegate
 */
- (void)lzJSNCWebViewDelegate:(NSObject *_Nullable)delegate{
    [super setNavigationDelegate:(id<WKNavigationDelegate>)delegate];
    //          设置完成以后，将当前浏览器控件默认的委托处理类去掉
    if(delegate!=tmpDelegate){
        tmpDelegate=nil;
    }
}

//alert弹框回调
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(alertView.tag==2001){
        _alertCompletionHandler();
    }
}

@end

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】浏览器控件的委托处理类
/**
 *  【通用模块】-【JavaScript和Native通信通道】浏览器控件的委托处理类
 *          负责处理浏览器控件的网络监听，保障JavaScript和Native之间通道的畅通
 */
@interface JSNCWebViewDelegate()
/**
 *  JSNCWebView控件实例
 */
@property(nonatomic,weak) JSNCWebView *jsncWebView;
@end
@implementation JSNCWebViewDelegate{
}

//支持加载https
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self lzWebViewBeforeDidStartLoad:nil wkWebView:webView didStartProvisionalNavigation:navigation];
    
    /* 显示网络状态指示器 */
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self lzWebViewAfterDidStartLoad:nil wkWebView:webView didStartProvisionalNavigation:navigation];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self lzWebViewBeforeDidFinishLoad:nil wkWebView:webView didFinishNavigation:navigation];
    
    /* 隐藏网络状态指示器 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
    //          不去处理
    if([webView isKindOfClass:[JSNCWebView class]]==false) return;
    self.jsncWebView=(JSNCWebView *)webView;
    
    //          加载JS的核心代码，备注：这里和Android保持一致，都加载经过压缩处理的min版本js
    //          页面加载完成以后，直接将通道的js注册到页面上，不用页面自己去请求URL加载
    NSString *jsLocalFilePath=[[NSBundle mainBundle ] pathForResource:@"LeadingCloud.JSNC.min.js" ofType:@""];
    if([[NSFileManager defaultManager] fileExistsAtPath:jsLocalFilePath]){
        NSURL *jsLocalFileUrl=[NSURL fileURLWithPath:jsLocalFilePath];
        NSString *javaScript2JSNC= [NSString stringWithContentsOfURL:jsLocalFileUrl encoding:NSUTF8StringEncoding error:nil];
        [webView evaluateJavaScript:javaScript2JSNC completionHandler:nil];
        //              在注册了上面的核心JavaScript代码以后，注册针对核心js的扩展代码
        jsLocalFilePath=[[NSBundle mainBundle] pathForResource:@"LeadingCloud.JSNC.Extend.min.js" ofType:@""];
        if([[NSFileManager defaultManager] fileExistsAtPath:jsLocalFilePath]){
            jsLocalFileUrl=[NSURL fileURLWithPath:jsLocalFilePath];
            javaScript2JSNC= [NSString stringWithContentsOfURL:jsLocalFileUrl encoding:NSUTF8StringEncoding error:nil];
            [webView evaluateJavaScript:javaScript2JSNC completionHandler:nil];
        }
    }
    
    NSString *jsncLoadedEventJSScript=@"window.dispatchEvent(new Event('JSNCLoaded'));";//  触发 JSNC加载完成的事件
    [webView evaluateJavaScript:jsncLoadedEventJSScript completionHandler:nil];
    
    [self lzWebViewAfterDidFinishLoad:nil wkWebView:webView didFinishNavigation:navigation];
}

// 导航错误
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    /* 隐藏网络状态指示器 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
    
    [self lzWebView:nil didFailLoadWithError:nil wkWebView:webView didFailProvisionalNavigation:navigation withError:error];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    /* 隐藏网络状态指示器 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
    
    [self lzWebView:nil didFailLoadWithError:nil wkWebView:webView didFailProvisionalNavigation:navigation withError:error];
}



// 浏览器将要加载请求的时候
-(BOOL)lzWebView:(UIWebView *_Nullable)webView shouldStartLoadWithRequest:(NSURLRequest *_Nullable)request navigationType:(UIWebViewNavigationType)navigationType wkWebView:(WKWebView *)wkWebView shouldStartProvisionalNavigation:(WKNavigation *)navigation{
    return YES;
}

// 浏览器开始加载请求的时候---调用父方法之前
-(void)lzWebViewBeforeDidStartLoad:(UIWebView *_Nullable)webView wkWebView:(WKWebView *)wkWebView didStartProvisionalNavigation:(WKNavigation *)navigation{
}

// 浏览器开始加载请求的时候---调用父方法之后
-(void)lzWebViewAfterDidStartLoad:(UIWebView *_Nullable)webView wkWebView:(WKWebView *)wkWebView didStartProvisionalNavigation:(WKNavigation *)navigation{
}

// 页面加载完成以后---调用父方法之前
- (void )lzWebViewBeforeDidFinishLoad:(UIWebView  *_Nullable)webView wkWebView:(WKWebView *)wkWebView didFinishNavigation:(WKNavigation *)navigation{
}

// 页面加载完成以后---调用父方法之后
- (void )lzWebViewAfterDidFinishLoad:(UIWebView  *_Nullable)webView wkWebView:(WKWebView *)wkWebView didFinishNavigation:(WKNavigation *)navigation{
}

// 页面加载发生错误的时候
-(void)lzWebView:(UIWebView *_Nullable)webView didFailLoadWithError:(NSError *_Nullable)error wkWebView:(WKWebView *)wkWebView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)wkError{
}


#pragma mark - 生命周期
-(void)dealloc{
    //    NSLog(@"JSNCWebViewDelegate销毁了");
}

@end


#pragma mark - 【通用模块】- WKUIDelegate 的委托处理类
/**
 *  【通用模块】- 用于重新alert,confirm,prompt
 */
@interface JSNCUIDelegate()
@property(nonatomic,weak) JSNCWebView *jsncWebView;
@end
@implementation JSNCUIDelegate

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(AlertCompletionHandler)completionHandler {

    if([webView isKindOfClass:[JSNCWebView class]]==false) return;
    self.jsncWebView=(JSNCWebView *)webView;
    
    if(self.jsncWebView.isInOpenViewDialog){
        UIAlertView *tmpAlertView=[[UIAlertView alloc]initWithTitle:nil message:message delegate:self.jsncWebView cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        tmpAlertView.tag = 2001;
        [tmpAlertView show];
        
        self.jsncWebView.alertCompletionHandler = completionHandler;
        return;
    }
    
//    UIAlertController  *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *sureAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }];
//    [alertController addAction:sureAlert];
//    
//    [self.jsncWebView.controller presentViewController:alertController animated:YES completion:^{}];
    
//    [LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.currentWebView
    //添加到数组
    if([LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.alertArr==nil){
        [LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.alertArr = [[NSMutableArray alloc] init];
    }
    [[LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.alertArr
     addObject:@{@"message":message,@"block":completionHandler}];
    
    //如果当前alert展现着
    if(![LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.isShowingAlert
       || [LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.alertArr.count==1){
        NSDictionary *infoDic = [[LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.alertArr objectAtIndex:0];
        message = [infoDic objectForKey:@"message"];
        completionHandler = [infoDic objectForKey:@"block"];
    } else {
        return;
    }
    
    [self showAlert:message completionHandler:completionHandler];
}

//队列进行弹框
-(void)showAlert:(NSString *)message completionHandler:(void (^)(void))completionHandler {

    UIAlertController  *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.alertArr removeObjectAtIndex:0];
        [LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.isShowingAlert = NO;
        
        completionHandler();
        
        if([LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.alertArr.count>0){
            NSDictionary *infoDic = [[LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.alertArr objectAtIndex:0];
            NSString *nextMessage = [infoDic objectForKey:@"message"];
            void(^nextCompletionHandler)() = [infoDic objectForKey:@"block"];
            [self showAlert:nextMessage completionHandler:nextCompletionHandler];
        }
    }];
    [alertController addAction:sureAlert];

    [LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.isShowingAlert = YES;
    
    [[LZBaseAppDelegate shareInstance].appDelegate.lzGlobalVariable.currentNavigationController presentViewController:alertController animated:YES completion:^{}];
//    [self.jsncWebView.controller presentViewController:alertController animated:YES completion:^{}];
}

-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {

    if([webView isKindOfClass:[JSNCWebView class]]==false) return;
    self.jsncWebView=(JSNCWebView *)webView;
    
    UIAlertController  *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleDeleAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *sureAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertController addAction:cancleDeleAlert];
    [alertController addAction:sureAlert];
    
    [self.jsncWebView.controller presentViewController:alertController animated:YES completion:^{}];
}

-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    if([webView isKindOfClass:[JSNCWebView class]]==false) return;
    self.jsncWebView=(JSNCWebView *)webView;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.text = defaultText;
    }];
    
    UIAlertAction *cancleDeleAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(nil);
    }];
    UIAlertAction *sureAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *userEmail = alertController.textFields.firstObject;
        completionHandler(userEmail.text);
    }];
    [alertController addAction:cancleDeleAlert];
    [alertController addAction:sureAlert];
    
    [self.jsncWebView.controller presentViewController:alertController animated:YES completion:^{}];
}

@end
