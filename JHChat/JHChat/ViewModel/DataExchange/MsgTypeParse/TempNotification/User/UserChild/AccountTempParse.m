//
//  AccountTempParse.m
//  LeadingCloud
//
//  Created by dfl on 16/5/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "AccountTempParse.h"
#import "UIAlertView+AlertWithMessage.h"
#import "ErrorDAL.h"
#import "XHHTTPClient.h"
#import "ModuleServerUtil.h"
#import "NSDictionary+DicSerial.h"
#import "AppDateUtil.h"
#import "CRSA.h"

@implementation AccountTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AccountTempParse *)shareInstance{
    static AccountTempParse *instance = nil;
    if (instance == nil) {
        instance = [[AccountTempParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    NSString *handlertype = [dataDic lzNSStringForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    
    /* 修改密码 */
    if([handlertype isEqualToString:Handler_User_Account_UpdatePwd]){
        isSendReport = [self parseUserAccountUpdatePwd:dataDic];
    }
    /* 修改绑定手机号 */
    else if([handlertype isEqualToString:Handler_User_Account_UpdateMobile]){
        isSendReport = [self parseUserAccountUpdateMobile:dataDic];
    }
    /* 修改绑定邮箱 */
    else if([handlertype isEqualToString:Handler_User_Account_UpdateEmail]){
        isSendReport = [self parseUserAccountUpdateEmail:dataDic];
    }
    /* 用户取消手机账号绑定 */
    else if([handlertype isEqualToString:Handler_User_Account_CancelBindMobile]){
        isSendReport = [self parseUserAccountCancelBindMobile:dataDic];
    }
    /* 用户取消邮箱账号绑定 */
    else if([handlertype isEqualToString:Handler_User_Account_CancelBindEmail]){
        isSendReport = [self parseUserAccountCancelBindEmail:dataDic];
    }
    /* 用户取消微信绑定 */
    else if([handlertype isEqualToString:Handler_User_Account_CancelBindWeXin]){
        isSendReport = [self parseUserAccountCancelBindWeXin:dataDic];
    }
    /* 用户取消微博绑定 */
    else if([handlertype isEqualToString:Handler_User_Account_CancelBindWeBo]){
        isSendReport = [self parseUserAccountCancelBindWeBo:dataDic];
    }
    /* 用户取消QQ绑定 */
    else if([handlertype isEqualToString:Handler_User_Account_CancelBindQQ]){
        isSendReport = [self parseUserAccountCancelBindQQ:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

/**
 *  修改密码的通知
 */
-(BOOL)parseUserAccountUpdatePwd:(NSMutableDictionary *)dataDic{
    //得到设备类型
    NSString *clienttype=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"clienttype"]];
    
    if([clienttype integerValue]==1){//判断设备类型
        return YES;
    }else{
        [self passPost:dataDic];
        return NO;
    }
    
}

/**
 *  修改绑定手机号的通知
 */
-(BOOL)parseUserAccountUpdateMobile:(NSMutableDictionary *)dataDic{
    NSString *loginname=[LZUserDataManager readUserLoginName];
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    if([loginname isEqualToString:[body lzNSStringForKey:@"oldmobile"]]){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LZGDCommonLocailzableString(@"common_hint")
                                                            message:LZGDCommonLocailzableString(@"login_change_account_relogin")
                                                           delegate:nil
                                                  cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm")
                                                  otherButtonTitles:nil];
            [alert show];
            
            /* 记录日志，跟踪20161213，收到已读，数量减一 */
            NSString *errorTitle = [NSString stringWithFormat:@"5"];
            [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:@"修改手机号的通知" errortype:Error_Type_Five];
            
            /* 发送消息回执 @dfl */
            NSString *msgid = [dataDic lzNSStringForKey:@"msgid"];
            [self sendReportToServerMsgType:@"1" msgID:msgid];
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate gotoLoginPageIsSendWebApi:NO isGotoLoginVC:YES];
        });
        return NO;
    }else{
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertView alertViewWithMessage:LZGDCommonLocailzableString(@"login_change_phone_confirm")];
            __block AccountTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_UserAccount_Setting, nil);
        });
        return YES;
    }
    
}

/**
 *  修改绑定邮箱的通知
 */
-(BOOL)parseUserAccountUpdateEmail:(NSMutableDictionary *)dataDic{
    NSString *loginname=[[LZUserDataManager readUserLoginName] lowercaseString];
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    if([loginname isEqualToString:[[body lzNSStringForKey:@"oldemail"] lowercaseString]]){
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LZGDCommonLocailzableString(@"common_hint")
                                                                message:LZGDCommonLocailzableString(@"login_change_account_relogin")
                                                               delegate:nil
                                                      cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm")
                                                      otherButtonTitles:nil];
                [alert show];
                
                /* 记录日志，跟踪20161213，收到已读，数量减一 */
                NSString *errorTitle = [NSString stringWithFormat:@"6"];
                [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:@"修改绑定邮箱的通知" errortype:Error_Type_Five];
                
                /* 发送消息回执 @dfl */
                NSString *msgid = [dataDic lzNSStringForKey:@"msgid"];
                [self sendReportToServerMsgType:@"1" msgID:msgid];
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate gotoLoginPageIsSendWebApi:NO isGotoLoginVC:YES];
            });
        return NO;
    }else{
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertView alertViewWithMessage:LZGDCommonLocailzableString(@"login_change_email_confirm")];
            __block AccountTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_UserAccount_Setting, nil);
        });
        return YES;
    }
}

/**
 *  用户取消手机账号绑定
 */
-(BOOL)parseUserAccountCancelBindMobile:(NSMutableDictionary *)dataDic{
//    NSString *loginname=[[LZUserDataManager readUserLoginName] lowercaseString];
//    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
//    if([loginname isEqualToString:[[body lzNSStringForKey:@"mobile"] lowercaseString]]){
//        /* 在主线程中发送通知 */
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LZGDCommonLocailzableString(@"common_hint")
//                                                            message:@"当前登陆账号已在其他客户端解绑,请重新登陆！"
//                                                           delegate:nil
//                                                  cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm")
//                                                  otherButtonTitles:nil];
//            [alert show];
//            
//
//            /* 发送消息回执 @dfl */
//            NSString *msgid = [dataDic lzNSStringForKey:@"msgid"];
//            [self sendReportToServerMsgType:@"1" msgID:msgid];
//            
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate gotoLoginPageIsSendWebApi:NO isGotoLoginVC:YES];
//        });
//        return NO;
//    }else{
        [[self appDelegate].lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_List moduleServer:Modules_Default getData:nil postData:[AppUtils GetCurrentUserID] otherData:@{WebApi_DataSend_Other_Operate:@"accountCancelBindMobile"}];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
//            [UIAlertView alertViewWithMessage:@"当前用户手机号码已解绑，请确认是否为本人操作"];
            __block AccountTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_UserAccount_Setting, nil);
        });
        return YES;
//    }
}

/**
 *  用户取消邮箱账号绑定
 */
-(BOOL)parseUserAccountCancelBindEmail:(NSMutableDictionary *)dataDic{
    NSString *loginname=[[LZUserDataManager readUserLoginName] lowercaseString];
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    if([loginname isEqualToString:[[body lzNSStringForKey:@"email"] lowercaseString]]){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LZGDCommonLocailzableString(@"common_hint")
                                                            message:@"当前登陆账号已在其他客户端解绑,请重新登陆！"
                                                           delegate:nil
                                                  cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm")
                                                  otherButtonTitles:nil];
            [alert show];
            

            /* 发送消息回执 @dfl */
            NSString *msgid = [dataDic lzNSStringForKey:@"msgid"];
            [self sendReportToServerMsgType:@"1" msgID:msgid];
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate gotoLoginPageIsSendWebApi:NO isGotoLoginVC:YES];
        });
        return NO;
    }else{
        [[self appDelegate].lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_List moduleServer:Modules_Default getData:nil postData:[AppUtils GetCurrentUserID] otherData:@{WebApi_DataSend_Other_Operate:@"accountCancelBindEmail"}];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
//            [UIAlertView alertViewWithMessage:@"当前用户邮箱地址已解绑，请确认是否为本人操作"];
            __block AccountTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_UserAccount_Setting, nil);
        });
        return YES;
    }
}


/**
 *  用户取消微信绑定
 */
-(BOOL)parseUserAccountCancelBindWeXin:(NSMutableDictionary *)dataDic{
    if([[LZUserDataManager readLoginType] isEqualToString:Login_Mode_WeChat]){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LZGDCommonLocailzableString(@"common_hint")
                                                            message:LZGDCommonLocailzableString(@"login_user_login_relogin")
                                                           delegate:nil
                                                  cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm")
                                                  otherButtonTitles:nil];
            [alert show];
        
        
            /* 发送消息回执 @dfl */
            NSString *msgid = [dataDic lzNSStringForKey:@"msgid"];
            [self sendReportToServerMsgType:@"1" msgID:msgid];
        
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate gotoLoginPageIsSendWebApi:NO isGotoLoginVC:YES];
        });
        return NO;
    }else{
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertView alertViewWithMessage:LZGDCommonLocailzableString(@"login_change_weixin_confirm")];
//            __block AccountTempParse * service = self;
//            EVENT_PUBLISH_WITHDATA(service, EventBus_UserAccount_Setting, nil);
        });
        return YES;
    }
}

/**
 *  用户取消微博绑定
 */
-(BOOL)parseUserAccountCancelBindWeBo:(NSMutableDictionary *)dataDic{
    if([[LZUserDataManager readLoginType] isEqualToString:Login_Mode_WeiBo]){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LZGDCommonLocailzableString(@"common_hint")
                                                            message:LZGDCommonLocailzableString(@"login_user_login_relogin")
                                                           delegate:nil
                                                  cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm")
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            /* 发送消息回执 @dfl */
            NSString *msgid = [dataDic lzNSStringForKey:@"msgid"];
            [self sendReportToServerMsgType:@"1" msgID:msgid];
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate gotoLoginPageIsSendWebApi:NO isGotoLoginVC:YES];
        });
        return NO;
    } else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertView alertViewWithMessage:LZGDCommonLocailzableString(@"login_change_webo_confirm")];
            //            __block AccountTempParse * service = self;
            //            EVENT_PUBLISH_WITHDATA(service, EventBus_UserAccount_Setting, nil);
        });
        return YES;
    }
}

/**
 *  用户取消QQ绑定
 */
-(BOOL)parseUserAccountCancelBindQQ:(NSMutableDictionary *)dataDic{
    if([[LZUserDataManager readLoginType] isEqualToString:Login_Mode_QQ]){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LZGDCommonLocailzableString(@"common_hint")
                                                            message:LZGDCommonLocailzableString(@"login_user_login_relogin")
                                                           delegate:nil
                                                  cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm")
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            /* 发送消息回执 @dfl */
            NSString *msgid = [dataDic lzNSStringForKey:@"msgid"];
            [self sendReportToServerMsgType:@"1" msgID:msgid];
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate gotoLoginPageIsSendWebApi:NO isGotoLoginVC:YES];
        });
        return NO;
    } else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertView alertViewWithMessage:LZGDCommonLocailzableString(@"login_change_qq_confirm")];
            //            __block AccountTempParse * service = self;
            //            EVENT_PUBLISH_WITHDATA(service, EventBus_UserAccount_Setting, nil);
        });
        return YES;
    }
}


/**
 *  向服务器端发送回执
 *
 *  @param msgType 消息类型
 *  @param msgid   消息ID
 */
-(void)sendReportToServerMsgType:(NSString *)msgType msgID:(NSString *)msgid{
    NSMutableArray *msgids = [[NSMutableArray alloc] init];
    [msgids addObject:msgid];
    
    /* 发送消息回执 */
    NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
    [getData setObject:msgType forKey:@"type"];
    [getData setObject:@"-1" forKey:@"badge"];
    [self.appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_Report moduleServer:Modules_Message getData:getData postData:msgids otherData:@{WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll}];
}

/* 身份认证 */
-(void)passPost:(NSMutableDictionary *)dataDic{

    //加密的密码
    NSString *rsaPassword = [AppUtils encryWithModulus:[self appDelegate].lzservice.lzlogin.publicKey.modulus exponent:[self appDelegate].lzservice.lzlogin.publicKey.exponent content:[LZUserDataManager readUserPassword]];
    
    //登录信息对象
    NSMutableDictionary *loginInfo = [[NSMutableDictionary alloc] initWithCapacity:2] ;
    
    //用户名
    [loginInfo setValue:[LZUserDataManager readUserLoginName] forKey:@"loginname"];
    
    //密码
    [loginInfo setValue:rsaPassword forKey:@"password"];
    
    //客户端类型
    [loginInfo setValue:@"1" forKey:@"clienttype"];
    
    //客户端操作系统
    [loginInfo setValue:@"iOS" forKey:@"clientos"];
    
    //客户端设备类型
    [loginInfo setValue:[LZUtils GetDeveiceModel] forKey:@"devicetype"];
    
    //客户端版本
    [loginInfo setValue:[AppUtils getNowAppVersion] forKey:@"clientversion"];
    
    //iOS的设备
    [[ErrorDAL shareInstance] addDataWithTitle:@"发送--AccountTemp--DeviceToken" data:[NSString stringWithFormat:@"DeviceToken---%@",[LZUserDataManager readDeviceToken]] errortype:Error_Type_Fifth];
    [loginInfo setValue:[LZUserDataManager readDeviceToken] forKey:@"deviceid"];
    
    //iOS的bundleid
    [loginInfo setValue:[[NSBundle mainBundle] bundleIdentifier] forKey:@"bundleid"];
    
    
    NSString *urlString =[NSString stringWithFormat:@"%@%@%@",
                          [ModuleServerUtil GetServerWithModule:Modules_Default] ,
                          @"/api/security/signin/", [self appDelegate].lzservice.lzlogin.publicKey.key];
    
    NSLog(@"lzlogin passport urlString:%@",urlString);
    
    [XHHTTPClient
     
     POSTPath: urlString
     parameters:loginInfo
     //成功
     jsonSuccessHandler:^(LZURLConnection *connection, id json){
         
         if(connection.iscancel == YES) return;
         
         NSLog(@"lzlogin passport json:%@",json);
         NSString *code = [[json objectForKey:@"ErrorCode"] objectForKey:@"Code"];
//         NSString *message = [[json objectForKey:@"ErrorCode"] objectForKey:@"Message"];
         if([code isEqualToString:@"0"])
         {
             
         }
         else
         {
             /* 在主线程中发送通知 */
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LZGDCommonLocailzableString(@"common_hint")
                                                                 message:LZGDCommonLocailzableString(@"login_change_secret_relogin")
                                                                delegate:nil
                                                       cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm")
                                                       otherButtonTitles:nil];
                 [alert show];
                 
                 /* 记录日志，跟踪20161213，收到已读，数量减一 */
                 NSString *errorTitle = [NSString stringWithFormat:@"4"];
                 [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:@"修改密码的通知" errortype:Error_Type_Five];
                 
                 /* 发送消息回执 @dfl */
                 NSString *msgid = [dataDic lzNSStringForKey:@"msgid"];
                 [self sendReportToServerMsgType:@"1" msgID:msgid];
                 
                 AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 [appDelegate gotoLoginPageIsSendWebApi:NO isGotoLoginVC:YES];
             });
         }
     }
     //失败
     failureHandler:^(LZURLConnection *connection,NSData *responseData, NSURLResponse *response, NSError *error){
         
         if(connection.iscancel == YES) return;
         
         //多次检测
         NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
         dataString = [NSString stringWithFormat:@"%@",dataString];
         NSLog(@"lzlogin passport error responseData:%@, error:%@",dataString,error);
         
         
     }
     ];
}

@end

