//
//  LCProtocolManager.m
//  LeadingCloud
//
//  Created by wchMac on 16/7/14.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LCProtocolManager.h"
#import "JSNCPlugin.h"
#import "UIAlertView+AlertWithMessage.h"
#import "NSDictionary+DicSerial.h"

@implementation LCProtocolManager

/**
 *  构造对象
 */
+(LCProtocolManager *)loadLCProtocolPluginCode:(NSString *)pluginCode methodName:(NSString *)methodName controller:(UIViewController *)sourceController{
    LCProtocolManager *manager=nil;
    if(manager==nil){
        manager = [[LCProtocolManager alloc] init];
        manager.pluginCode = pluginCode;
        manager.methodName = methodName;
        manager.sourceController = sourceController;
    }
    return manager;
}

/**
 *  运行
 */
-(void)runWithParameters:(NSDictionary *)parameters callBack:(LCProtocolManagerCallBack)callBack{
    _parameters = parameters;
    _callBack = callBack;

    NSDictionary *runParameterDic = @{@"PluginCode":_pluginCode,
                                      @"MethodName":_methodName,
                                      @"Parameters":parameters
                                      };
    
    JSNCRunParameter *runParameter = [JSNCRunParameter parameterWithJSONString:[runParameterDic dicSerial]];

//    NSString *tmpString=[[NSBundle mainBundle] pathForResource:@"JSNCCfg.xml" ofType:@""];
//    if([[NSFileManager defaultManager] fileExistsAtPath:tmpString]==true){
//        NSURL *fileUrl=[NSURL fileURLWithPath:tmpString];
//        NSXMLParser *xmlParser=[[NSXMLParser alloc]initWithContentsOfURL:fileUrl];
//        xmlParser.delegate=self;
//        [xmlParser parse];
//    }
    
    /* 判断是否注册 */
    Class exf = NSClassFromString(_pluginCode);
    id object = [[exf alloc] init];
    if(object==nil || ![object isKindOfClass:[JSNCPlugin class]]){
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:runParameter resultType:JSNCRunResultType_PluginNotRegist resultData:[NSString stringWithFormat:@"未注册PluginCode【%@】的处理类",runParameter.pluginCode] isFinished:YES];
        [self dealPluginRunResult:runResult];
        return;
    }
    
    /* 判断方法是否实现 */
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:",_methodName]);
    if(![object respondsToSelector:sel]){
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:runParameter resultType:JSNCRunResultType_MethodNotSupport resultData:[NSString stringWithFormat:@"插件类未实现方法【%@】",runParameter.methodName] isFinished:YES];
        [self dealPluginRunResult:runResult];
        return;
    }

    /* 设置LCProtocolManager 参数 */
    LCProtocolManagerSendRunResult sendRunResult = ^(JSNCRunResult * __nonnull runResult){
        [self dealPluginRunResult:runResult];
    };
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:sendRunResult forKey:@"block"];
    if(_sourceController!=nil){
        [dic setObject:_sourceController forKey:@"controller"];
    }
    
    [object setValue:dic forKey:@"lcProtocolManagerParaDic"];
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    /* 执行 */
    [object performSelector:sel withObject:runParameter];
    
     #pragma clang diagnostic pop
}

-(void)dealPluginRunResult:(JSNCRunResult *)runResult{
//runResult.resultType
    _callBack(runResult.resultType,runResult.resultData);
    
    //      发送结果通知：回到主线程发送通知
//    __block JSNCRunResult *tmpResult=runResult;
//    __block JSNCManager *tmpManager=self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:tmpManager.notificatioName2RunResult object:tmpManager userInfo:@{@"data":tmpResult}];
//    });
}

@end
