//
//  OpenTemplateModel.m
//  LeadingCloud
//
//  Created by wang on 16/11/10.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "OpenTemplateModel.h"
#import "WebViewController.h"
#import "NSDictionary+DicSerial.h"
#import "NSString+SerialToDic.h"
#import "NSString+IsNullOrEmpty.h"
#import "NSString+Replace.h"
#import "LCProgressHUD.h"
#import "AppUtils.h"
#import "CommonTemplateTypeDAL.h"
#import "NSArray+IsExist.h"
#import "AppTempDAL.h"
#import "LZFormat.h"

@implementation OpenTemplateModel
/**
 打开模板的控制器(根)
 
 @param baseVc        当前控制器
 @param context       传递数据
 @param dataParam     参数
 @param lzplugin      插件
 @param templateModel 模板  可能没有
 @param isjump        是否跳转 默认传YES
 
 */
+ (void)openTemplateViewController:(UIViewController*)baseVc Context:(NSMutableDictionary *)context URLParamsData:(NSString*)dataParam Lzplugin:(LZPluginManager*)lzplugin Model:(CommonTemplateModel *)templateModel AppCode:(NSString *)appcode RelationAppCodes:(NSMutableArray *)relationAppCodes BaskLinkCode:(NSString*)linkcode templateModule:(NSString *)templateModule{
	
	
	//api/system/baselinkconfig/getdeviceconfigbycode/{appcode}/{code}/{tokenid}

    //暂时屏蔽掉baselinkcode功能
//    if (1==1 || !linkcode || [linkcode isEqualToString:@""]) {
		
		[self openCommonTemplateViewController:baseVc Context:context URLParamsData:dataParam Lzplugin:lzplugin Model:templateModel AppCode:appcode RelationAppCodes:relationAppCodes templateModule:templateModule];

//        return;
//    }
	
	
//    CommonTemplateTypeModel * typeMode = [[CommonTemplateTypeDAL shareInstance]getCommonTemplateTypeModelCode:linkcode AppCode:appcode];
//
//    if (typeMode.blcid && [typeMode.blcid length]>0) {
//        NSData *jsonData = [typeMode.config dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *err;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                            options:NSJSONReadingMutableContainers
//                                                              error:&err];
//        CommonTemplateModel *template = [[CommonTemplateModel alloc]init];
//        [template serializationWithDictionary:dic];
//
//        [self openCommonTemplateViewController:baseVc Context:context URLParamsData:dataParam Lzplugin:lzplugin Model:template AppCode:appcode RelationAppCodes:relationAppCodes templateModule:templateModule];
//
//        return;
//    }
//
//    NSMutableDictionary *getDic = [NSMutableDictionary dictionary];
//
//    getDic[@"appcode"] = appcode;
//    getDic[@"code"] = linkcode;
//
//    WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
//        NSString *code = [NSString stringWithFormat:@"%@",[[dataDic lzNSDictonaryForKey:WebApi_ErrorCode] objectForKey:@"Code"]];
//
//        if (code && [code isEqualToString:@"0"]) {
//
//        }else{
//            [LCProgressHUD showInfoMsg:@"暂不支持此类型！"];
//        }
//
//        NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
//
//        CommonTemplateTypeModel * comodel = [[CommonTemplateTypeModel alloc]init];
//        [comodel serializationWithDictionary:contextDic];
//
//        [[CommonTemplateTypeDAL shareInstance]addCommonTemplateTypeModel:comodel];
//
//
//        NSString *config = [contextDic lzNSStringForKey:@"config"];
//
//        NSData *jsonData = [config dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *err;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                            options:NSJSONReadingMutableContainers
//                                                              error:&err];
//        CommonTemplateModel *template = [[CommonTemplateModel alloc]init];
//        [template serializationWithDictionary:dic];
//
//        [self openCommonTemplateViewController:baseVc Context:context URLParamsData:dataParam Lzplugin:lzplugin Model:template AppCode:appcode RelationAppCodes:relationAppCodes templateModule:templateModule];
//
//
//    };
//    NSDictionary *otherData = @{WebApi_DataSend_Other_BackBlock:backBlock,
//                                WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll};
//
//    /* 获取当前用户企业下更多 */
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate.lzservice sendToServerForGet:WebApi_CloudApp
//                                    routePath:WebApi_App_baselinkconfig
//                                 moduleServer:Modules_Default
//                                      getData:getDic
//                                    otherData:otherData];
	
}

/**
 打开模板的控制器
 
 @param baseVc        当前控制器
 @param context       传递数据
 @param dataParam     参数
 @param lzplugin      插件
 @param templateModel 模板
 */
+ (void)openCommonTemplateViewController:(UIViewController*)baseVc Context:(NSMutableDictionary *)context URLParamsData:(NSString*)dataParam Lzplugin:(LZPluginManager*)lzplugin Model:(CommonTemplateModel *)templateModel AppCode:(NSString *)appcode RelationAppCodes:(NSMutableArray *)relationAppCodes templateModule:(NSString *)templateModule{
    
    if(templateModel == nil){
        return;
    }
    
    if(relationAppCodes == nil){
        relationAppCodes = [[NSMutableArray alloc] init];
    }

    //添加AppCode
    if(![NSString isNullOrEmpty:appcode]){
        if(![relationAppCodes isExistString:appcode]){
            [relationAppCodes addObject:appcode];
        }
    }
    
    /* 处理主AppCode */
    if(templateModel.templatetype == 2 && ![NSString isNullOrEmpty:templateModel.webviewModel.appcode]){
        if(![relationAppCodes isExistString:templateModel.webviewModel.appcode]){
            [relationAppCodes addObject:templateModel.webviewModel.appcode];
        }
        appcode = templateModel.webviewModel.appcode;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //是否追加currentAppCode
    if(![NSString isNullOrEmpty:dataParam]){
        NSDictionary *urlParamDic = [dataParam seriaToDic];
        if([[urlParamDic lzNSStringForKey:@"appendappcode"] isEqualToString:@"1"]){
            NSArray *currentAppCodeArr = appDelegate.lzGlobalVariable.currentAppCode;
            if(currentAppCodeArr!=nil){
                for(NSString *currentAppCode in currentAppCodeArr){
                    if(![relationAppCodes containsObject:currentAppCode]){
                        [relationAppCodes addObject:currentAppCode];
                    }
                }
            }
        }
    }
    
    /* 记录当前需要注意的AppCodes */
    appDelegate.lzGlobalVariable.currentAppCode = [relationAppCodes mutableCopy];
    
    if( ![NSString isNullOrEmpty:templateModule] && ![templateModule isEqualToString:Template_Service_Launch]){
        [LCProgressHUD showLoading:LCProgreaaHUD_Show_Loading];
    }
    LZGetAppModel block = ^(AppModel *appModel) {
        
        [LCProgressHUD hide];
        
        NSMutableDictionary *contextForTemplate = [[NSMutableDictionary alloc] initWithDictionary:context];
        if(contextForTemplate == nil){
            contextForTemplate = [[NSMutableDictionary alloc] init];
        }
        
        [contextForTemplate setValue:templateModule forKey:Template_Module];
        if(templateModel.templatetype == 2 && ![NSString isNullOrEmpty:templateModel.webviewModel.pagetransdata]){
            [contextForTemplate setValue:templateModel.webviewModel.pagetransdata forKey:@"lcm_pagetransdata"];
        }
        
        if (templateModel.templatetype == 1){ //协作平台内部Controller
            [self openInsideViewController:baseVc Context:contextForTemplate Model:templateModel];
        }
        else if (templateModel.templatetype == 2){ //webview
            [self openWebViewController:baseVc Context:contextForTemplate URLParamsData:dataParam Model:templateModel appCode:appcode templateModule:templateModule];
        }
        else if (templateModel.templatetype == 3) { //动态链接库
            
            [self openFrameworkController:baseVc DataDic:contextForTemplate Lzplugin:lzplugin Model:templateModel];
        }
        else if (templateModel.templatetype == 4) { //外部应用
            [self openOutsideApp:baseVc DataDic:contextForTemplate Model:templateModel];
        }
        else if (templateModel.templatetype == 5) { //VPN调用
            [self openVpnWebApp:baseVc DataDic:contextForTemplate Model:templateModel AppID:dataParam];
        }
    };
    
    [self getRelationAppCodeInfo:relationAppCodes block:block];
}

/**
 打开内部的控制器
 
 @param baseVc        当前控制器
 @param context       传递数据
 @param templateModel 模板
 */
+ (UIViewController *)openInsideViewController:(UIViewController*)baseVc Context:(NSMutableDictionary *)context Model:(CommonTemplateModel *)templateModel{
    
    UIViewController *commonVC = nil;

    NSString *formname = templateModel.platModel.formname;
	NSString *isnotpush = templateModel.platModel.isnotpush;

    if(![NSString isNullOrEmpty:formname])
    {
        Class exf = NSClassFromString(formname);
        NSObject *object = [[exf alloc] init];
        if([object isKindOfClass:[UIViewController class]]){
            commonVC = (UIViewController *)object;

            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wundeclared-selector"
            /* 添加模板参数 */
            if ( [object respondsToSelector: @selector(setTemplateAppModule:)]) {
                [commonVC setValue:templateModel forKey:@"templateAppModule"];
            }
            #pragma clang diagnostic pop
            
            if(![NSString isNullOrEmpty:templateModel.platModel.parametername]){
                [commonVC setValue:context forKey:templateModel.platModel.parametername];
            }
			
			if([NSString isNullOrEmpty:isnotpush]){
				[baseVc.navigationController pushViewController:commonVC animated:YES];
			}else{
				if (![isnotpush isEqualToString:@"true"]){
					[baseVc.navigationController pushViewController:commonVC animated:YES];
				}
			}
		}
}
    return commonVC;
}


/**
 打开WebView
 
 @param baseVc        当前控制器
 @param context       传递数据
 @param dataParam     参数
 @param templateModel 模板
 */
+ (void)openWebViewController:(UIViewController*)baseVc Context:(NSMutableDictionary *)context URLParamsData:(NSString*)dataParam Model:(CommonTemplateModel *)templateModel appCode:(NSString *)appcode templateModule:(NSString *)templateModule{

    NSMutableString *h5Url = [NSMutableString stringWithString:templateModel.webviewModel.h5url];
    [h5Url lowercaseString];
   
    if(![NSString isNullOrEmpty:h5Url])
    {
        NSDictionary *orgin = [dataParam seriaToDic];
        //更改参数值
        for (NSString *key in orgin) {
            
            if (key && [key length]!=0) {
                NSRange range = [[h5Url lowercaseString]rangeOfString:[NSString stringWithFormat:@"{%@}",[key lowercaseString]]];
                
                if (range.location != NSNotFound) {
                    [h5Url replaceCharactersInRange:range withString:[orgin objectForKey:key]];
                    
                }
            }
        }
        
        NSString *isNotShowNav = templateModel.webviewModel.isnotshownav;
        [ModuleServerUtil GetUrlWithAppcode:appcode url:h5Url isuserserverdata:YES block:^(NSString *blockserver) {

            /* 追加version版本号 */
            NSString *version = [LZFormat FormatNow2String];
            if([[blockserver lowercaseString] rangeOfString:@"version="].location==NSNotFound){
                if(![NSString isNullOrEmpty:appcode]){
                    AppModel *tempAppModel = [[AppTempDAL shareInstance] getAppModelWithAppCode:appcode temptype:@"1"];
                    if(tempAppModel!=nil){
                        version = tempAppModel.version;
                    }
                }
                if([blockserver rangeOfString:@"?"].location!=NSNotFound){
                    blockserver = [NSString stringWithFormat:@"%@&version=%@",blockserver,version];
                } else {
                    blockserver = [NSString stringWithFormat:@"%@?version=%@",blockserver,version];
                }
            }
                        
            NSMutableDictionary *sysdataDic = [[NSMutableDictionary alloc] init];
            [sysdataDic setValue:version forKey:@"lcmappversion"];
            
            blockserver =[AppUtils replaceUrlParameter:blockserver];
           
            WebViewController *appController = [[WebViewController alloc] init];
            appController.url = blockserver;
            [appController.sessionStorage setValue:[context dicSerial] forKey:@"lcm.instancedata"];
            [appController.sessionStorage setValue:[sysdataDic dicSerial] forKey:@"lcm.systemdata"];
            appController.isnotshownav = isNotShowNav;
            [baseVc.navigationController pushViewController:appController animated:YES];
            
//            if (![NSString isNullOrEmpty:appcode]){
//                [ModuleServerUtil GetAppModelWithAppCode:appcode notusertemptype0:YES block:^(AppModel *appModel) {
//                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                    appDelegate.lzGlobalVariable.currentAppCode = @[appcode];
//                    
//                    [baseVc.navigationController pushViewController:appController animated:YES];
//                }];
//            } else {
//                [baseVc.navigationController pushViewController:appController animated:YES];
//            }
        }];
    }

    
}

/**
 打开动态链接库
 
 @param baseVc        当前控制器
 @param DataDic       传递数据
 @param lzplugin      插件
 @param templateModel 模板
 */
+ (void)openFrameworkController:(UIViewController*)baseVc DataDic:(NSMutableDictionary *)dataDic Lzplugin:(LZPluginManager*)lzplugin Model:(CommonTemplateModel *)templateModel{
    
    if(lzplugin==nil){
        return;
    }
    
    NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
 
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [context setObject:appDelegate.lzservice.tokenId forKey:@"tokenid"];
    [lzplugin runPlugin:baseVc
                context:context
              framework:templateModel.frameworkModel.framework
              className:templateModel.frameworkModel.formname
               paraName:templateModel.frameworkModel.parametername];
    
    [lzplugin unloadPlugin];
    
}


/**
 打开外部应用
 
 @param baseVc        当前控制器
 @param dataDic       传递参数 没有传空
 @param templateModel 模板
 */
+ (void)openOutsideApp:(UIViewController*)baseVc DataDic:(NSMutableDictionary *)dataDic Model:(CommonTemplateModel *)templateModel{

    NSString *loadUrl = [AppUtils replaceUrlParameter:templateModel.installappModel.scheme];

    NSURL *URL = [AppUtils urlToNsUrl:loadUrl];
    if(LZ_IS_IOS10){
        [[UIApplication sharedApplication] openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success) {
            if(success){
                DDLogVerbose(@"成功");
            } else {
                DDLogVerbose(@"失败");
                [UIAlertView alertViewWithMessage:@"App打开失败，请确认是否正确安装！"];
            }
        }];
    } else {
//        [[UIApplication sharedApplication] openURL:URL];
        //先判断是否能打开该url
        BOOL result = [[UIApplication sharedApplication] openURL:URL];
        if (result) {
            DDLogVerbose(@"成功");
        } else {
            DDLogVerbose(@"失败");
            [UIAlertView alertViewWithMessage:@"App打开失败，请确认是否正确安装！"];
        }
    }

}

/**
 打开VPN
 
 @param baseVc        当前控制器
 @param dataDic       传递参数 没有传空
 @param templateModel 模板
 */
+ (void)openVpnWebApp:(UIViewController*)baseVc DataDic:(NSMutableDictionary *)dataDic Model:(CommonTemplateModel *)templateModel AppID:(NSString *)appid{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.lzGlobalVariable.isJustConnectTonBJGDVpn = YES;

    NSURL *URL = [AppUtils urlToNsUrl:[templateModel.vpnwebModel.scheme stringByReplacingOccurrencesOfString:@"{tag}" withString:appid]];
    if(LZ_IS_IOS10){
        [[UIApplication sharedApplication] openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success) {
            if(success){
                DDLogVerbose(@"成功");
            } else {
                DDLogVerbose(@"失败");
                [UIAlertView alertViewWithMessage:@"VPN打开失败，请确认是否正确安装！"];
            }
        }];
    } else {
        //        [[UIApplication sharedApplication] openURL:URL];
        //先判断是否能打开该url
        BOOL result = [[UIApplication sharedApplication] openURL:URL];
        if (result) {
            DDLogVerbose(@"成功");
        } else {
            DDLogVerbose(@"失败");
            [UIAlertView alertViewWithMessage:@"VPN打开失败，请确认是否正确安装！"];
        }
    }
    
}


#pragma mark - 获取关联应用的信息
+(void)getRelationAppCodeInfo:(NSMutableArray *)relationAppCodes block:(LZGetAppModel)block{
    NSString *appcode = @"";
    if(relationAppCodes!=nil && relationAppCodes.count>0){
        appcode = [relationAppCodes objectAtIndex:0];
    } else {
        block(nil);
        return;
    }
    //开始请求
    [ModuleServerUtil GetAppModelWithAppCode:appcode notusertemptype0:YES block:^(AppModel *appModel){
        if(relationAppCodes.count>1){
            [relationAppCodes removeObjectAtIndex:0];
            [self getRelationAppCodeInfo:relationAppCodes block:block];
        } else {
            block(appModel);
        }
    }];
}

@end
