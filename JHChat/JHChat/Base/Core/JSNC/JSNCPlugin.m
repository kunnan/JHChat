/************************************************************
 Author:  lz-fzj
 Date：   2016-03-29
 Version: 1.0
 Description: 【通用模块】-【JavaScript和Native通信通道】插件基类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "JSNCPlugin.h"
#import "JSNCManager.h"
#import "JSNCWebView.h"
#import "ErrorDAL.h"
#import "NSDictionary+DicSerial.h"

/**
 *  忽略 反射 调用方法时的警告：PerformSelector may cause a leak because its selector is unknown
 */
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】通信通道的管理者内部扩展方法
@interface JSNCManager ()
/**
 *  【静态】处理插件的运行结果
 *  @param runResult 插件运行结果
 *  @param webView   插件浏览器
 */
+(void)dealPluginRunResult:(JSNCRunResult *)runResult webView:(JSNCWebView *)webView;
@end

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】JSNC配置文件解析器
/**
 *  【通用模块】-【JavaScript和Native通信通道】JSNC配置文件解析器
 */
@interface JSNCCfgFileParser: NSObject
/**
 *  注册的插件集合
 */
@property(nonatomic,strong,readonly) NSDictionary<NSString *,NSString *> *plugins;
/**
 *  开始解析
 */
-(void)parser;
@end

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】插件基类
/**
 *  【通用模块】-【JavaScript和Native通信通道】插件基类：扩展代码
 */
@interface JSNCPlugin ()
/**
 *  运行插件的浏览器控件,readonly
 */
@property(nonatomic,weak)JSNCWebView *webView;
/**
 *  运行插件的浏览器控件所属的控制器对象
 */
@property(nonatomic,weak,readonly)UIViewController *controller;
@end
/**
 *  【通用模块】-【JavaScript和Native通信通道】插件基类：实现代码
 */
@implementation JSNCPlugin

#pragma mark - 给子类提供的一些基础方法
/**
 *  在主线程中执行代码块
 *  @param block 要执行的代码块【代码块传入的controller为插件运行所在的controller】
 */
-(void)executeBlockInMainThread:(void(^ __nonnull)(UIViewController*  __nonnull controller))block{
    __block JSNCPlugin *tmpSelf=self;
    dispatch_async(dispatch_get_main_queue(), ^{
        block(tmpSelf.controller);
    });
}
/**
 *  发送插件的运行结果
 *  @param runResult 运行结果对象
 */
-(void)sendRunResult:(JSNCRunResult * __nonnull)runResult{
    /* 第三方原生应用调用 */
    if(_lcProtocolManagerParaDic!=nil && [[_lcProtocolManagerParaDic allKeys] count]>0){
        if([[_lcProtocolManagerParaDic allKeys] containsObject:@"block"]){
            LCProtocolManagerSendRunResult backBlock = [_lcProtocolManagerParaDic objectForKey:@"block"];
            backBlock(runResult);
        }
    }
    /* webview调用 */
    else {
        [JSNCManager dealPluginRunResult:runResult webView:self.webView];
    }
}

#pragma mark 控制器的显示和隐藏相关操作

-(UIViewController * _Nonnull)getController:(UIViewController * _Nonnull)controller{

    /* 第三方原生应用调用 */
    if(_lcProtocolManagerParaDic!=nil && [[_lcProtocolManagerParaDic allKeys] count]>0){
        if([[_lcProtocolManagerParaDic allKeys] containsObject:@"controller"]){
            return [_lcProtocolManagerParaDic objectForKey:@"controller"];
        }
    }
    
    return controller;
}

/**
 *  通过插件打开新的控制器
 *  @param newController 要打开的新的控制器
 *  @param animated   是否使用动画
 */
-(void)pushViewController:(UIViewController *__nonnull)newController animated:(Boolean)animated{
    
    [self executeBlockInMainThread:^(UIViewController * _Nonnull controller) {
        [[[self getController:controller] navigationController]  pushViewController:newController animated:animated];
    }];
}

/**
 *  弹出到根视图控制器
 *  @param animated 是否使用动画
 */
-(void)popToRootViewControllerAnimated:(Boolean)animated{
    [self executeBlockInMainThread:^(UIViewController * _Nonnull controller) {
        [[[self getController:controller] navigationController]  popToRootViewControllerAnimated:animated];
    }];
}

/**
 *  弹出到指定的控制器
 *  @param toController 目标控制器
 *  @param animated   是否使用动画
 */
-(void)popToViewController:(UIViewController *__nonnull)toController animated:(Boolean)animated{
    [self executeBlockInMainThread:^(UIViewController * _Nonnull controller) {
        [[[self getController:controller] navigationController]  popToViewController:toController animated:animated];
    }];
}

/**
 *  弹出当前视图控制器
 *  @param animated 是否使用动画
 */
-(void)popViewControllerAnimated:(Boolean)animated{
    [self executeBlockInMainThread:^(UIViewController * _Nonnull controller) {
        [[[self getController:controller] navigationController]  popViewControllerAnimated:animated];
    }];
}

/**
 *  模态显示新的控制器
 *  @param controller 要模态显示的新控制器
 *  @param animated   是否使用动画
 */
-(void)presentViewController:(UIViewController *__nonnull)newController animated:(Boolean)animated{
    [self executeBlockInMainThread:^(UIViewController * _Nonnull controller) {
        [[self getController:controller]  presentViewController:newController animated:animated  completion:nil];
    }];
}

/**
 *  移除模态弹窗的控制器
 *  @param animated 是否使用动画
 */
-(void)dismissViewControllerAnimated:(Boolean)animated{
    [self executeBlockInMainThread:^(UIViewController * _Nonnull controller) {
        [[self getController:controller] dismissViewControllerAnimated:animated  completion:nil];
    }];
}

#pragma mark - 私有方法
/**
 *  设置插件的属性值在初始化对象的时候
 *  @param webView 插件运行的浏览器控件
 */
-(void)setPropertyValueWhileInitial:(JSNCWebView *)webView{
    _webView=webView;
    UIViewController *tmpController=[webView controller];
    _controller=tmpController;
}

#pragma mark - 生命周期
/**
 *  对象销毁的时候做的操作
 */
-(void)dealloc{
    NSLog(@"JSNCPlugin：插件对象被销毁了");
}

@end

#pragma mark - 【通用模块】-【JavaScript和Native通信通道】通信通道的管理者
/**
 *  【通用模块】-【JavaScript和Native通信通道】通信通道的管理者
 */
@interface JSNCManager()
//      下面这几个对象，会在多线程中使用，先使用原子性标记多线程安全

/**
 *  插件的浏览器对象
 */
@property(atomic,weak) JSNCWebView *webView;

/**
 *  插件注册缓存。key：pluginCode；value：插件的实现类名称
 */
@property(atomic,strong)NSMutableDictionary<NSString *,NSString *> *pluginRegisterCache;

/**
 *  插件实例对象缓存。key：pluginCode；value：插件对象实例
 */
@property(atomic,strong)NSMutableDictionary<NSString *,JSNCPlugin *> *pluginInstanceCache;

/**
 *  插件运行记录缓存。key：pluginCode；value：插件的runTimeid集合
 */
@property(atomic,strong)NSMutableDictionary<NSString *,NSMutableArray<NSString *> *> *pluginRunRecordCache;

@end

@implementation JSNCManager
/**
 *  插件管理者实例缓存。key：运行环境id《如浏览器标记》；value：对应的管理者实例对象
 */
static NSMutableDictionary<NSString *,JSNCManager *> *_pluginMangerIntanceCache;
/**
 *  通用的插件注册信息缓存。key：插件编码；value：插件实现类名称
 */
static NSDictionary<NSString *,NSString *> *_commonPluginRegisterCache;
#pragma mark - 公共方法
/**
 *  【静态】加载管理者实例【不存在则自动构建新实例】
 *  @param webView 浏览器对象
 *  @return 管理者实例
 */
+(JSNCManager * __nonnull)loadManager:(JSNCWebView *__nonnull)webView{
    
    JSNCManager *manager=nil;
    @synchronized(self) {
        //          获取管理者实例对象，如果不存在则构建
        manager=[_pluginMangerIntanceCache objectForKey:webView.uniqueId];
        if(manager==nil){
            manager=[[JSNCManager alloc]init];
            manager.webView=webView;
            manager->_notificatioName2RunResult=[NSString stringWithFormat:@"JSNC_RunResult【%@】",webView.uniqueId];
            [_pluginMangerIntanceCache setObject:manager forKey:webView.uniqueId];
        }
    }
    return manager;
}

/**
 *  注册插件
 *  @param pluginCode 插件编码
 *  @param pluginClass 继承JSNCPlugin的插件实现类
 */
-(void)registerPluginWithPluginCode:(NSString * __nonnull)pluginCode pluginClass:(Class __nonnull)pluginClass{
    @synchronized(self) {
        [self.pluginRegisterCache setObject:NSStringFromClass(pluginClass) forKey:pluginCode];
    }
}

/**
 *  运行插件
 *  @param runParameter 插件运行时参数
 */
-(void)runPlugin:(JSNCRunParameter * __nonnull)runParameter{
    //          运行之前的数据验证。非空：插件Code，插件运行方法Name，插件运行时Id
    if(runParameter==nil) @throw [NSException exceptionWithName:@"JSNC" reason:@"runParameter为nil，运行插件失败" userInfo:nil];
    if(runParameter.pluginCode==nil||runParameter.pluginCode.length==0) [NSException exceptionWithName:@"JSNC" reason:@"pluginCode为空或者空字符串，运行插件失败" userInfo:nil];
    if(runParameter.methodName==nil||runParameter.methodName.length==0) [NSException exceptionWithName:@"JSNC" reason:@"methodName为空或者空字符串，运行插件失败" userInfo:nil];
    if(runParameter.runTimeId==nil||runParameter.runTimeId.length==0) [NSException exceptionWithName:@"JSNC" reason:@"runTimeId为空或者空字符串，运行插件失败" userInfo:nil];
    //          锁，访问插件的相关缓存数据，最终得到要访问的插件实例和对应的调用方法
    JSNCPlugin *plugin;
    SEL methodSelector;
    @synchronized(self) {
        //      根据pluginCode找到实例缓存，如果不存在，则全新构建
        plugin=[self.pluginInstanceCache objectForKey:runParameter.pluginCode];
        if(plugin==nil){
            //              找插件处理类：先找当前实例注册的，再找通用的
            NSString *pluginClassName=[self.pluginRegisterCache objectForKey:runParameter.pluginCode];
            if(pluginClassName==nil) pluginClassName=[_commonPluginRegisterCache objectForKey:runParameter.pluginCode];
            //              如果插件处理类为空，则发送【不支持】的操作结果
            if(pluginClassName==nil){
                JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:runParameter resultType:JSNCRunResultType_PluginNotRegist resultData:[NSString stringWithFormat:@"未注册PluginCode【%@】的处理类",runParameter.pluginCode] isFinished:YES];
                [self dealPluginRunResult:runResult];
                return;
            }
            //              构建注册的插件实例，如果不是继承【JSNCPlugin】的子类，则报错
            NSObject *tmpInstance=[[NSClassFromString(pluginClassName) alloc]init];
            if([tmpInstance isKindOfClass:[JSNCPlugin class]]==false){
                JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:runParameter resultType:JSNCRunResultType_Error resultData:[NSString stringWithFormat:@"PluginCode【%@】注册的处理类未继承基类【JSNCPlugin】",runParameter.pluginCode] isFinished:YES];
                [self dealPluginRunResult:runResult];
                return;
            }
            //              加入缓存，并进行初始化设置操作
            plugin=(JSNCPlugin *)tmpInstance;
            [plugin setPropertyValueWhileInitial:self.webView];
            [self.pluginInstanceCache setObject:plugin forKey:runParameter.pluginCode];
        }
        //      判断运行的方法是否存在；统一一个参数
        methodSelector=NSSelectorFromString([NSString stringWithFormat:@"%@:",runParameter.methodName]);
        if([plugin respondsToSelector:methodSelector]==false){
            JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:runParameter resultType:JSNCRunResultType_MethodNotSupport resultData:[NSString stringWithFormat:@"插件类未实现方法【%@】",runParameter.methodName] isFinished:YES];
            [self dealPluginRunResult:runResult];
            return;
        }
        //      方法也存在了：加入运行记录缓存，然后运行
        NSMutableArray<NSString *> *tmpRecordArray=[self.pluginRunRecordCache objectForKey:runParameter.pluginCode];
        if(tmpRecordArray==nil) {
            tmpRecordArray=[NSMutableArray array];
            [self.pluginRunRecordCache setObject:tmpRecordArray forKey:runParameter.pluginCode];
        }
        [tmpRecordArray addObject:runParameter.runTimeId];
    }
    //      运行插件
    @try {
        /* 记录日志 */
        @try {
            NSString *errorTitle =[NSString stringWithFormat:@"%@--->%@",runParameter.pluginCode,runParameter.methodName];
            NSString *paraData = @"";
            if(runParameter.parameters!= [NSNull null] && runParameter.parameters!=nil){
                paraData = [runParameter.parameters dicSerial];
            }
            [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:paraData errortype:Error_Type_Six];
        }@catch (NSException *exception) {}
            
        /* 运行 */
        [plugin performSelector:methodSelector withObject:runParameter];
    }
    @catch (NSException *exception) {
        //发生错误，则发送处理结果
        [self dealPluginRunResult:[JSNCRunResult resultWithRunParameter:runParameter resultType:JSNCRunResultType_Error resultData:exception.reason isFinished:YES]];
    }
}

/**
 *  【静态】卸载管理者实例
 *  @param webView 浏览器对象
 */
+(void)unloadManager:(JSNCWebView * __nonnull)webView{
    //      锁，移除当前key对象的管理者对象，从而触发其dealloc销毁实例对象
    @synchronized(self) {
        [_pluginMangerIntanceCache removeObjectForKey:[webView uniqueId]];
    }
}

#pragma mark - 生命周期
/**
 *  实例初始化
 *  @return
 */
-(instancetype)init{
    if(self=[super init]){
        //      将缓存对象初始化
        _pluginRegisterCache=[NSMutableDictionary dictionary];
        _pluginInstanceCache=[NSMutableDictionary dictionary];
        _pluginRunRecordCache=[NSMutableDictionary dictionary];
    }
    return self;
}

/**
 *  静态初始化方法
 */
+(void)initialize{
    //      初始化管理者实例缓存字典
    _pluginMangerIntanceCache=[NSMutableDictionary dictionary];
    //      初始化通用插件资源的注册，缓存起来
    JSNCCfgFileParser *parser=[[JSNCCfgFileParser alloc]init];
    [parser parser];
    _commonPluginRegisterCache=parser.plugins;
}

/**
 *  销毁的时候处理一下
 */
-(void)dealloc{
    //      将这些属性全部置空，释放对象句柄
    _webView=nil;
    _pluginRegisterCache=nil;
    _pluginInstanceCache=nil;
    _pluginRunRecordCache=nil;

    
    NSLog(@"对象管理者被销毁了");
}

#pragma mark - 内部使用的私有方法
/**
 *  【静态】处理插件的运行结果
 *  @param runResult 插件运行结果
 *  @param webView   插件浏览器
 */
+(void)dealPluginRunResult:(JSNCRunResult *)runResult webView:(JSNCWebView *)webView{
    JSNCManager *manager=nil;
    //          锁，去缓存去管理者对象
    @synchronized(self) {
        manager=[_pluginMangerIntanceCache objectForKey:[webView uniqueId]];
    }
    //          根据管理者对象，分配处理插件的运行结果
    if(manager ==nil){
        NSLog(@"获取JSNCManager失败，无法处理插件的运行结果");
        return;
    }
    [manager dealPluginRunResult:runResult];
}

/**
 *  【动态】处理插件的运行结果
 *  @param runResult
 */
-(void)dealPluginRunResult:(JSNCRunResult *)runResult{
    //      找到当前的运行缓存记录集合，判断是否需要清空当前的运行记录
    NSMutableArray<NSString *> *tmpRecordArray=[self.pluginRunRecordCache objectForKey:runResult.pluginCode];
    if(tmpRecordArray&&runResult.isFinished==true){
        [tmpRecordArray removeObject:runResult.runTimeid];
        //              如果无操作记录了，那么移除记录缓存，并置空
        if([tmpRecordArray count]==0){
            if(runResult.pluginCode!=nil){
                [self.pluginRunRecordCache removeObjectForKey:runResult.pluginCode];
            }
            tmpRecordArray=nil;
        }
    }
    //      如果运行记录为空，找到插件实例对象，考虑移除
    if(tmpRecordArray==nil){
        if(runResult.pluginCode!=nil){
            [self.pluginInstanceCache removeObjectForKey:runResult.pluginCode];
        }
    }
    //      发送结果通知：回到主线程发送通知
    __block JSNCRunResult *tmpResult=runResult;
    __block JSNCManager *tmpManager=self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:tmpManager.notificatioName2RunResult object:tmpManager userInfo:@{@"data":tmpResult}];
    });
}
@end


#pragma mark - 【通用模块】-【JavaScript和Native通信通道】JSNC配置文件解析器
/**
 *  【通用模块】-【JavaScript和Native通信通道】JSNC配置文件解析器
 */
@interface JSNCCfgFileParser ()<NSXMLParserDelegate>
{
    NSMutableDictionary *_tmpPlugins;
}
@end
@implementation JSNCCfgFileParser
/**
 *  开始解析
 */
-(void)parser{
    //              找配置文件，取通用的插件注册信息
    NSString *tmpString=[[NSBundle mainBundle] pathForResource:@"JSNCCfg.xml" ofType:@""];
    _tmpPlugins=[NSMutableDictionary dictionary];
    if([[NSFileManager defaultManager] fileExistsAtPath:tmpString]==true){
        NSURL *fileUrl=[NSURL fileURLWithPath:tmpString];
        NSXMLParser *xmlParser=[[NSXMLParser alloc]initWithContentsOfURL:fileUrl];
        xmlParser.delegate=self;
        [xmlParser parse];
    }
    //              解析完成，对属性进行赋值
    _plugins=[_tmpPlugins copy];
}

#pragma mark - NSXMLParserDelegate
/**
 *  开始解析一个节点的时候
 *  @param parser
 *  @param elementName
 *  @param namespaceURI
 *  @param qName
 *  @param attributeDict
 */
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    //              先只处理【Plugin】
    if([@"Plugin" isEqualToString:elementName]==true){
        NSString *pluginCode=[attributeDict objectForKey:@"Code"];
        if([pluginCode length]==0) return;
        NSString *pluginClass=[attributeDict objectForKey:@"Class"];
        if([pluginClass length]==0) return;
        //              注册
        [_tmpPlugins setObject:pluginClass forKey:pluginCode];
    }
}


@end

