//
//  ModuleServerUtil.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/12.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-12
 Version: 1.0
 Description: 服务器管理工具
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ModuleServerUtil.h"
#import "LZUserDataManager.h"
#import "NSString+IsNullOrEmpty.h"
#import "AppModel.h"
#import "AppDAL.h"
#import "NSString+SerialToDic.h"
#import "CoAppDAL.h"
#import "CooAppModel.h"
#import "AppBaseServerModel.h"
#import "AppBaseServerDAL.h"
#import "AppTempDAL.h"
#import "AppDelegate.h"
#import "NSDictionary+DicSerial.h"

@implementation ModuleServerUtil

#pragma mark - 平台级使用

//hdhs 灰度web
//hdws 灰度webapi
//hhs  http 模式时的web
//hshs https 模式时的web
//hsws https 模式时的webapi
//hws  http 模式时的webapi

/**
 *  根据模块获取对应的服务器地址
 *
 *  @param module 模块
 *
 *  @return 服务器地址（如:http://192.168.11.14:8400）
 */
+(NSString *)GetServerWithModule:(NSString *)module{
    
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了操作--GetServerWithModule");
        }
    #else
    #endif
    
    NSDictionary *modulesServer = [LZUserDataManager readModulesServerInfo];
    NSDictionary *modulesDic = [modulesServer objectForKey:@"modules"];
    NSDictionary *serversDic = [modulesServer objectForKey:@"servers"];
    
    /* 从modules中获取对应模块使用的服务器 */
    NSString *moduleKey = nil;
    //存在对应模块
    if([[modulesDic allKeys] containsObject:module]){
        moduleKey = [modulesDic objectForKey:module];
    }
    //不存在对应模块时，取default模块的地址
    else {
        moduleKey = [modulesDic objectForKey:Modules_Default];
    }
    
    /* 从servers中根据moduleKey获取url */
    NSDictionary *urlInfo = [serversDic objectForKey:moduleKey];
    NSString *protocol = [urlInfo objectForKey:@"protocol"];
    NSString *host = [urlInfo objectForKey:@"host"];
    NSString *port = [urlInfo objectForKey:@"port"];
    
    //判断当前用户是否为灰度用户
    if([LZUserDataManager readIsGayScaleUser]){
        host = [urlInfo objectForKey:@"hdhost"];
        port = [urlInfo objectForKey:@"hdport"];
    }
    
    return [NSString stringWithFormat:@"%@://%@:%@",protocol,host,port];
}

/**
 *  获取H5服务器地址
 *
 *  @param module 服务器
 *
 *  @return 地址
 */
+(NSString *)GetH5ServerWithModule:(NSString *)module{
    
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了操作--GetH5ServerWithModule");
        }
    #else
    #endif
    
    NSDictionary *modulesServer = [LZUserDataManager readModulesServerInfo];
    NSDictionary *modulesDic = [modulesServer objectForKey:@"modules"];
    NSDictionary *serversDic = [modulesServer objectForKey:@"servers"];  //h5servers
    
    /* 兼容老代码 20161215 */
    if([[modulesServer allKeys] containsObject:@"h5servers"]){
        module = @"default";
        serversDic = [modulesServer objectForKey:@"h5servers"];  //h5servers
    }
    
    /* 从modules中获取对应模块使用的服务器 */
    NSString *moduleKey = nil;
    //存在对应模块
    if([[modulesDic allKeys] containsObject:module]){
        moduleKey = [modulesDic objectForKey:module];
    }
    //不存在对应模块时，取default模块的地址
    else {
        moduleKey = [modulesDic objectForKey:Modules_H5_Default];
    }
    
    /* 从servers中根据moduleKey获取url */
    NSDictionary *urlInfo = [serversDic objectForKey:moduleKey];
    NSString *protocol = [urlInfo objectForKey:@"protocol"];
    NSString *host = [urlInfo objectForKey:@"host"];
    NSString *port = [urlInfo objectForKey:@"port"];
    
    //判断当前用户是否为灰度用户
    if([LZUserDataManager readIsGayScaleUser]){
        host = [urlInfo objectForKey:@"hdhost"];
        port = [urlInfo objectForKey:@"hdport"];
    }
    
    return [NSString stringWithFormat:@"%@://%@:%@",protocol,host,port];
}

#pragma mark - 应用App

/**
 *  根据appcode获取对应的Web服务器
 */
+(NSString *)GetAppWebServerWithAppCode:(NSString *)appcode{
    
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了操作--GetAppWebServerWithAppCode");
        }
    #else
    #endif
    
    return [ModuleServerUtil GetAppWebServerWithAppCode:appcode isusedefault:YES];
}

/**
 *  根据appcode获取对应的Web服务器
 */
+(NSString *)GetAppWebServerWithAppCode:(NSString *)appcode isusedefault:(BOOL)isuserdefault{
    
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了操作--GetAppWebServerWithAppCode");
        }
    #else
    #endif
    
    NSString *resultServer = @"";
    
    NSString *appserver = @"";
    AppModel *appModel = [[AppDAL shareInstance] getAppModelWithAppCode:appcode];
    if(appModel==nil || [NSString isNullOrEmpty:appModel.appserver]){
        appModel = [[AppTempDAL shareInstance] getAppModelWithAppCode:appcode temptype:@"1"];
        if(appModel==nil || [NSString isNullOrEmpty:appModel.appserver]){
            CooAppModel *coAppModel = [[CoAppDAL shareInstance] getAppModelWithAppCode:appcode];
            if(appModel!=nil && ![NSString isNullOrEmpty:appModel.appserver]){
                appserver = coAppModel.appserver;
            }
        }
        else {
            appserver = appModel.appserver;
        }
    }
    else {
        appserver = appModel.appserver;
    }
    if(![NSString isNullOrEmpty:appserver]){
        NSDictionary *dic = [appserver seriaToDic];
        /* https模式 */
        if([[LZUserDataManager readServerProtocol] isEqualToString:@"https"]){
            resultServer = [dic objectForKey:@"hshs"];
            if([NSString isNullOrEmpty:resultServer]){
                resultServer = [dic objectForKey:@"hhs"];
            }
        }
        /* http模式 */
        else {
            resultServer = [dic objectForKey:@"hhs"];
            if([NSString isNullOrEmpty:resultServer]){
                resultServer = [dic objectForKey:@"hshs"];
            }
        }
        
        //判断当前用户是否为灰度用户
        if([LZUserDataManager readIsGayScaleUser]){
            resultServer = [dic objectForKey:@"hdhs"];
        }
        
    }
    
    /* 未配置时 */
    if([NSString isNullOrEmpty:resultServer]){
        resultServer = isuserdefault ? [ModuleServerUtil GetH5ServerWithModule:appcode] : @"";
    }
    
    return resultServer;
}

/**
 *  根据appcode获取对应的WebApi服务器
 */
+(NSString *)GetAppWebApiServerWithAppCode:(NSString *)appcode{
    
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了操作--GetAppWebApiServerWithAppCode");
        }
    #else
    #endif
    
    return [ModuleServerUtil GetAppWebApiServerWithAppCode:appcode isusedefault:YES];
}

/**
 *  根据appcode获取对应的WebApi服务器
 */
+(NSString *)GetAppWebApiServerWithAppCode:(NSString *)appcode isusedefault:(BOOL)isuserdefault{
    
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了操作--GetAppWebApiServerWithAppCode:(NSString *)appcode");
        }
    #else
    #endif
    
    NSString *resultServer = @"";
    
    NSString *appserver = @"";
    AppModel *appModel = [[AppDAL shareInstance] getAppModelWithAppCode:appcode];
    if(appModel==nil || [NSString isNullOrEmpty:appModel.appserver]){
        appModel = [[AppTempDAL shareInstance] getAppModelWithAppCode:appcode temptype:@"1"];
        if(appModel==nil || [NSString isNullOrEmpty:appModel.appserver]){
            CooAppModel *coAppModel = [[CoAppDAL shareInstance] getAppModelWithAppCode:appcode];
            if(appModel!=nil && ![NSString isNullOrEmpty:appModel.appserver]){
                appserver = coAppModel.appserver;
            }
        }
        else {
            appserver = appModel.appserver;
        }
    }
    else {
        appserver = appModel.appserver;
    }
    if(![NSString isNullOrEmpty:appserver]){
        NSDictionary *dic = [appserver seriaToDic];
        /* https模式 */
        if([[LZUserDataManager readServerProtocol] isEqualToString:@"https"]){
            resultServer = [dic objectForKey:@"hsws"];
            if([NSString isNullOrEmpty:resultServer]){
                resultServer = [dic objectForKey:@"hws"];
            }
        }
        /* http模式 */
        else {
            resultServer = [dic objectForKey:@"hws"];
            if([NSString isNullOrEmpty:resultServer]){
                resultServer = [dic objectForKey:@"hsws"];
            }
        }
        
        //判断当前用户是否为灰度用户
        if([LZUserDataManager readIsGayScaleUser]){
            resultServer = [dic objectForKey:@"hdws"];
        }
    }
    
    return resultServer;
}

#pragma mark - BaseServer应用App

/**
 *  根据servergroup获取对应的WebApi服务器
 */
+(NSString *)GetAppWebServerWithServerGroup:(NSString *)servergroup isusedefault:(BOOL)isuserdefault{
    
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了操作--GetAppWebServerWithServerGroup");
        }
    #else
    #endif
    
    NSString *resultServer = @"";
    
    NSString *protocol = @"";
    NSString *host = @"";
    NSString *port = @"";
    AppBaseServerModel *appModel = [[AppBaseServerDAL shareInstance] getAppBaseServerModelWithServerGroup:servergroup];

    if(appModel!=nil){
        /* https模式 */
        if([[LZUserDataManager readServerProtocol] isEqualToString:@"https"]){
            host = appModel.httpshtmlhost;
            port = appModel.httpshtmlport;
            protocol = @"https";
            if([NSString isNullOrEmpty:host] || [NSString isNullOrEmpty:port]){
                host = appModel.httphtmlhost;
                port = appModel.httphtmlport;
                protocol = @"http";
            }
        }
        /* http模式 */
        else {
            host = appModel.httphtmlhost;
            port = appModel.httphtmlport;
            protocol = @"http";
            if([NSString isNullOrEmpty:host] || [NSString isNullOrEmpty:port]){
                host = appModel.httpshtmlhost;
                port = appModel.httpshtmlport;
                protocol = @"https";
            }
        }
    }
    
    /* host和port至少有一个为空时 */
    if([NSString isNullOrEmpty:host] || [NSString isNullOrEmpty:port]){
    
        if(isuserdefault){
            NSDictionary *modulesServer = [LZUserDataManager readModulesServerInfo];
            NSDictionary *modulesDic = [modulesServer objectForKey:@"modules"];
            NSDictionary *serversDic = [modulesServer objectForKey:@"servers"];  //h5servers
            
            /* 从modules中获取对应模块使用的服务器 */
            NSString *moduleKey = nil;
            //存在对应模块
            if([[modulesDic allKeys] containsObject:servergroup]){
                moduleKey = [modulesDic objectForKey:servergroup];
                
                /* 兼容老代码 20161215 */
                if([[modulesServer allKeys] containsObject:@"h5servers"]){
                    moduleKey = @"default";
                    serversDic = [modulesServer objectForKey:@"h5servers"];  //h5servers
                }
                
                /* 从servers中根据moduleKey获取url */
                NSDictionary *urlInfo = [serversDic objectForKey:moduleKey];
                protocol = [urlInfo objectForKey:@"protocol"];
                host = [urlInfo objectForKey:@"host"];
                port = [NSString stringWithFormat:@"%@",[urlInfo objectForKey:@"port"]];
                
                //判断当前用户是否为灰度用户
                if([LZUserDataManager readIsGayScaleUser]){
                    host = [urlInfo objectForKey:@"hdhost"];
                    port = [NSString stringWithFormat:@"%@",[urlInfo objectForKey:@"hdport"]];
                }
            }
        }
    }
    
    if(![NSString isNullOrEmpty:host] && ![NSString isNullOrEmpty:port]){
        resultServer = [NSString stringWithFormat:@"%@://%@:%@",protocol,host,port];
    }
    
    return resultServer;
}

/**
 *  根据servergroup获取对应的WebApi服务器
 */
+(NSString *)GetAppWebApiServerWithServerGroup:(NSString *)servergroup isusedefault:(BOOL)isuserdefault{
    
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了操作--GetAppWebApiServerWithServerGroup:(NSString *)servergroup");
        }
    #else
    #endif
    
    NSString *resultServer = @"";
    
    NSString *protocol = @"";
    NSString *host = @"";
    NSString *port = @"";
    AppBaseServerModel *appModel = [[AppBaseServerDAL shareInstance] getAppBaseServerModelWithServerGroup:servergroup];
    
    if(appModel!=nil){
        /* https模式 */
        if([[LZUserDataManager readServerProtocol] isEqualToString:@"https"]){
            host = appModel.httpswebapihost;
            port = appModel.httpswebapiport;
            protocol = @"https";
            if([NSString isNullOrEmpty:host] || [NSString isNullOrEmpty:port]){
                host = appModel.httpwebapihost;
                port = appModel.httpwebapiport;
                protocol = @"http";
            }
        }
        /* http模式 */
        else {
            host = appModel.httpwebapihost;
            port = appModel.httpwebapiport;
            protocol = @"http";
            if([NSString isNullOrEmpty:host] || [NSString isNullOrEmpty:port]){
                host = appModel.httpswebapihost;
                port = appModel.httpswebapiport;
                protocol = @"https";
            }
        }
    }
    
    /* host和port至少有一个为空时 */
    if([NSString isNullOrEmpty:host] || [NSString isNullOrEmpty:port]){
        
        if(isuserdefault){
            NSDictionary *modulesServer = [LZUserDataManager readModulesServerInfo];
            NSDictionary *modulesDic = [modulesServer objectForKey:@"modules"];
            NSDictionary *serversDic = [modulesServer objectForKey:@"servers"];
            
            /* 从modules中获取对应模块使用的服务器 */
            NSString *moduleKey = nil;
            //存在对应模块
            if([[modulesDic allKeys] containsObject:servergroup]){
                moduleKey = [modulesDic objectForKey:servergroup];
                
                /* 从servers中根据moduleKey获取url */
                NSDictionary *urlInfo = [serversDic objectForKey:moduleKey];
                protocol = [urlInfo objectForKey:@"protocol"];
                host = [urlInfo objectForKey:@"host"];
                port = [NSString stringWithFormat:@"%@",[urlInfo objectForKey:@"port"]];
                
                //判断当前用户是否为灰度用户
                if([LZUserDataManager readIsGayScaleUser]){
                    host = [urlInfo objectForKey:@"hdhost"];
                    port = [NSString stringWithFormat:@"%@",[urlInfo objectForKey:@"hdport"]];
                }
            }
        }
    }
    
    if(![NSString isNullOrEmpty:host] && ![NSString isNullOrEmpty:port]){
        resultServer = [NSString stringWithFormat:@"%@://%@:%@",protocol,host,port];
    }
    
    return resultServer;
}

#pragma mark - 获取url地址

/**
 根据appcode和url获取地址

 @param appcode appcode
 @param url     url地址

 @return url地址
 */
+(NSString *)GetUrlWithAppcode:(NSString *)appcode
                           url:(NSString *)url
              isuserserverdata:(BOOL)isuserserverdata
                         block:(LZGetCommonAppWebOrWebApi)block{
    
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了操作--GetUrlWithAppcode");
        }
    #else
    #endif
    
    if([[url lowercaseString] rangeOfString:@"http://"].location!=NSNotFound
       || [[url lowercaseString] rangeOfString:@"https://"].location!=NSNotFound){
        
        if(block){
            block(url);
        }
        
        return url;
    }
    
    NSString *server = [ModuleServerUtil GetCommonAppWebServerWithAppCode:appcode isuserdefault:YES isuserserverdata:isuserserverdata block:^(NSString *blockserver) {
        
        NSString *resultServer = @"";
        if([blockserver hasSuffix:@"/"] || [url hasPrefix:@"/"]){
            resultServer = [NSString stringWithFormat:@"%@%@",blockserver,url];
        } else {
            resultServer = [NSString stringWithFormat:@"%@/%@",blockserver,url];
        }
        block(resultServer);
    }];
    
    if([server hasSuffix:@"/"] || [url hasPrefix:@"/"]){
        return [NSString stringWithFormat:@"%@%@",server,url];
    } else {
        return [NSString stringWithFormat:@"%@/%@",server,url];
    }
}

#pragma mark - 根据AppCode获取服务器地址

/**
 *  根据appcode获取对应的Web服务器
 */
+(NSString *)GetCommonAppWebServerWithAppCode:(NSString *)appcode
                                isuserdefault:(BOOL)isuserdefault
                             isuserserverdata:(BOOL)isuserserverdata
                                        block:(LZGetCommonAppWebOrWebApi)block{
    DDLogVerbose(@"---------%@",appcode);
    
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了操作--GetCommonAppWebServerWithAppCode");
        }
    #else
    #endif
    
    /* 1、从app表中取 */
    __block NSString *result = [ModuleServerUtil GetAppWebServerWithAppCode:appcode isusedefault:NO];
    
    /* 2、从app_baseserver中取 */
    if([NSString isNullOrEmpty:result]){
        result = [ModuleServerUtil GetAppWebServerWithServerGroup:appcode isusedefault:NO];
    }

    /* 3、从服务器端去取 */
    if(isuserserverdata && [NSString isNullOrEmpty:result] && ![NSString isNullOrEmpty:appcode]){
        WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
            NSString *code = [[dataDic lzNSDictonaryForKey:WebApi_ErrorCode] objectForKey:@"Code"];
            
            if([code isEqualToString:@"0"]){
                AppModel *appModelForTemp = [[AppModel alloc] init];
                NSDictionary *dataDicForTemp = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
                if([[dataDicForTemp allKeys] containsObject:@"appid"]){
                    [appModelForTemp serializationWithDictionary:dataDicForTemp];
                }
                appModelForTemp.temptype = @"1";
                if( [dataDicForTemp objectForKey:@"appserver"] != [NSNull null]){
                    appModelForTemp.appserver = [[dataDicForTemp objectForKey:@"appserver"] dicSerial];
                }
                else {
                    appModelForTemp.appserver = @"";
                }
                
                if(![NSString isNullOrEmpty:appModelForTemp.appid]){
                    lz_dispatch_async_safe(^{
                        [[AppTempDAL shareInstance] addAppModel:appModelForTemp];
                    });
                }
                
                result = [ModuleServerUtil GetAppWebServerWithAppCode:appcode isusedefault:NO];
            }
            if(isuserdefault && [NSString isNullOrEmpty:result]){
                result = [ModuleServerUtil GetH5ServerWithModule:appcode];
            }
            if(block){
                block(result);
            }

        };
        NSDictionary *otherData = @{WebApi_DataSend_Other_BackBlock:backBlock,
                                    WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll};
        
        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
        [dataDic setObject:appcode forKey:@"appcode"];
        /* 获取当前用户企业下更多 */
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.lzservice sendToServerForGet:WebApi_CloudApp
                                        routePath:WebApi_App_GetAppInfo
                                     moduleServer:Modules_Default
                                          getData:dataDic
                                        otherData:otherData];
    } else {
        if(isuserdefault && [NSString isNullOrEmpty:result]){
            result = [ModuleServerUtil GetH5ServerWithModule:appcode];
        }
        if(block){
            block(result);
        }
    }
    
    if(isuserdefault && [NSString isNullOrEmpty:result]){
        result = [ModuleServerUtil GetH5ServerWithModule:appcode];
    }
    return result;
}

/**
 *  根据appcode获取对应的WebApi服务器
 */
+(NSString *)GetCommonAppWebApiServerWithAppCode:(NSString *)appcode
                                   isuserdefault:(BOOL)isuserdefault
                                isuserserverdata:(BOOL)isuserserverdata
                                           block:(LZGetCommonAppWebOrWebApi)block{
//    if ([NSThread isMainThread]) {
//        DDLogVerbose(@"----------------1111---当前为主线程");
//    } else {
//        DDLogVerbose(@"----------------1111---当前为子线程");
//    }
    
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了操作--GetCommonAppWebApiServerWithAppCode");
        }
    #else
    #endif
    
    /* 1、从app表中取 */
    __block NSString *result = [ModuleServerUtil GetAppWebApiServerWithAppCode:appcode isusedefault:NO];
    
    /* 2、从app_baseserver中取 */
    if([NSString isNullOrEmpty:result]){
        result = [ModuleServerUtil GetAppWebApiServerWithServerGroup:appcode isusedefault:NO];
    }

    /* 3、从服务器端去取 */
    if(isuserserverdata && [NSString isNullOrEmpty:result] && ![NSString isNullOrEmpty:appcode]){
        
        WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
            NSString *code = [[dataDic lzNSDictonaryForKey:WebApi_ErrorCode] objectForKey:@"Code"];
            
            if([code isEqualToString:@"0"]){
                AppModel *appModelForTemp = [[AppModel alloc] init];
                NSDictionary *dataDicForTemp = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
                if([[dataDicForTemp allKeys] containsObject:@"appid"]){
                    [appModelForTemp serializationWithDictionary:dataDicForTemp];
                }
                appModelForTemp.temptype = @"1";
                if( [dataDicForTemp objectForKey:@"appserver"] != [NSNull null]){
                    appModelForTemp.appserver = [[dataDicForTemp objectForKey:@"appserver"] dicSerial];
                }
                else {
                    appModelForTemp.appserver = @"";
                }
                
                if(![NSString isNullOrEmpty:appModelForTemp.appid]){
                    lz_dispatch_async_safe(^{
                        [[AppTempDAL shareInstance] addAppModel:appModelForTemp];
                    });
                }
                
                result = [ModuleServerUtil GetAppWebApiServerWithAppCode:appcode isusedefault:NO];
            }
            if(isuserdefault && [NSString isNullOrEmpty:result]){
                result = [ModuleServerUtil GetServerWithModule:appcode];
            }
            if(block){
                block(result);
            }
            
        };
        NSDictionary *otherData = @{WebApi_DataSend_Other_BackBlock:backBlock,
                                    WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll};
        
        NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
        [dataDic setObject:appcode forKey:@"appcode"];
        /* 获取当前用户企业下更多 */
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.lzservice sendToServerForGet:WebApi_CloudApp
                                        routePath:WebApi_App_GetAppInfo
                                     moduleServer:Modules_Default
                                          getData:dataDic
                                        otherData:otherData];
    } else {
        if(isuserdefault && [NSString isNullOrEmpty:result]){
            result = [ModuleServerUtil GetServerWithModule:appcode];
        }
        if(block){
            block(result);
        }
    }
    
    if(isuserdefault && [NSString isNullOrEmpty:result]){
        result = [ModuleServerUtil GetServerWithModule:appcode];
    }
    
    return result;
}

#pragma mark - 根据AppCode获取AppModel

/**
 根据AppCode获取AppModel
 */
+(void)GetAppModelWithAppCode:(NSString *)appcode notusertemptype0:(BOOL)notusertemptype0 block:(LZGetAppModel)block{
    
    #ifdef DEBUG
        if ([NSThread isMainThread]) {
            DDLogVerbose(@"----------------在主线程中执行了操作--GetAppModelWithAppCode");
        }
    #else
    #endif
    
    if([NSString isNullOrEmpty:appcode]){
        block(nil);
        return;
    }
    
    AppModel *appModel = [[AppDAL shareInstance] getAppModelWithAppCode:appcode];
    if(appModel==nil){
        appModel = [[AppTempDAL shareInstance] getAppModelWithAppCode:appcode temptype:@"1"];
        if(appModel==nil){
            if(!notusertemptype0){
                appModel = [[AppTempDAL shareInstance] getAppModelWithAppCode:appcode temptype:@"0"];
                if(appModel!=nil){
                    block(appModel);
                }
            }
            
            /* 从服务器端请求数据 */
            WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
                NSString *code = [[dataDic lzNSDictonaryForKey:WebApi_ErrorCode] objectForKey:@"Code"];
                
                if([code isEqualToString:@"0"]){
                    AppModel *appModelForTemp = [[AppModel alloc] init];
                    NSDictionary *dataDicForTemp = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
                    if([[dataDicForTemp allKeys] containsObject:@"appid"]){
                        [appModelForTemp serializationWithDictionary:dataDicForTemp];
                    }
                    appModelForTemp.temptype = @"1";
                    if( [dataDicForTemp objectForKey:@"appserver"] != [NSNull null]){
                        appModelForTemp.appserver = [[dataDicForTemp objectForKey:@"appserver"] dicSerial];
                    }
                    else {
                        appModelForTemp.appserver = @"";
                    }
                    
                    if(![NSString isNullOrEmpty:appModelForTemp.appid]){
                        lz_dispatch_async_safe(^{
                            [[AppTempDAL shareInstance] addAppModel:appModelForTemp];
                        });
                    }

                    block(appModelForTemp);
                } else {
                    block(nil);
                }
            };
            NSDictionary *otherData = @{WebApi_DataSend_Other_BackBlock:backBlock,
                                        WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll};
            
            NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
            [dataDic setObject:appcode forKey:@"appcode"];
            /* 获取当前用户企业下更多 */
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.lzservice sendToServerForGet:WebApi_CloudApp
                                            routePath:WebApi_App_GetAppInfo
                                         moduleServer:Modules_Default
                                              getData:dataDic
                                            otherData:otherData];
        }
        else {
           block(appModel);
        }
    } else {
        block(appModel);
    }
}


@end
