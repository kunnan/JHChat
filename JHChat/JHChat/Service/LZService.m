//
//  LZService.m
//  LeadingCloud
//
//  Created by admin on 15/12/1.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  huangyue
 Date：   2015-12-01
 Version: 1.0
 Description: 服务
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "LZService.h"

#import "EventBus.h"
#import "EventPublisher.h"
#import "DataAccessMain.h"
#import "NSDictionary+DicSerial.h"
#import "ImMsgQueueDAL.h"
#import "ImMsgQueueModel.h"
#import "AppDateUtil.h"
#import "ImMsgQueueDAL.h"
#import "ImChatLogDAL.h"
#import "ImChatLogModel.h"
#import "LZLoginDataSend.h"
#import "NSString+SerialToDic.h"
#import "DataExchangeParse.h"
#import "NSString+IsNullOrEmpty.h"
#import "ErrorModel.h"
#import "ErrorDAL.h"
#import "ImRecentDAL.h"
#import "AppDateUtil.h"
#import "NSString+Base64.h"
#import "XHHTTPClient.h"
#import "ModuleServerUtil.h"

//最大重连次数
#define CONNECTFAILURECOUNTMAX 3

@interface LZService()<EventSyncPublisher,EventSyncSubscriber>{
    /* 登录时使用的LZServeice */
    __block LZService * serviceForLogin;
}

/*
 最后一条发送出去的消息ID
 */
@property (nonatomic, strong) NSString *longPoolIsRuning;

/*
 msgserver
 */
@property (nonatomic, copy) NSString * msgserver;
/*
 平台服务器
 */
@property (nonatomic, copy) NSString * serverUrl;

@end

@implementation LZService

/*
 开始
 */
-(void) start
{
    self.connectfailurecount = 0;
    self.loginRestartGUID = @"";
    
    //订阅
    EVENT_SUBSCRIBE(self, EventBus_ConnectHandle);
    
}
/*
 结束
 */
-(void)stop
{
    //取消
    EVENT_UNSUBSCRIBE(self, EventBus_ConnectHandle);
    
}

#pragma mark  EventBus delegate

/*
 事件代理
 */
- (void)eventOccurred:(NSString *)eventName event:(Event *)event
{
    //NSLog(@"eventName:%@",eventName);
    
   // NSLog(@"event:%@",[event eventData]);
    
    
    if([eventName isEqualToString:EventBus_ConnectHandle])
    {
        
        NSString *type = [[event eventData] objectForKey:@"type"];
        
        NSLog(@"service event name:%@ type:%@",eventName, type);
        
        if(type!=nil)
        {
            if( [type isEqualToString:LZConnection_Connection_Success] ){
                NSLog(@"--------------IM服务器连接成功!");
            
                /* 清空队列中的请求 */
                if(self.lzconnection)
                {
                    [self.lzconnection removeAllWebApi];
                    self.lzconnection.queueIsGettingData = NO;
                }
                
                /* 清空临时通知后，首次登录成功 */
                __block LZService * service = self;
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if(appDelegate.lzGlobalVariable.isJustSetTempNotificationToZero){
                    appDelegate.lzGlobalVariable.isJustSetTempNotificationToZero = NO;
                    DDLogVerbose(@"----------------发送登录web成功的临时通知------------");
                    EVENT_PUBLISH_WITHDATA(service, EventBus_LoginWebSuccessForTempNotification, nil);
                }
                
                /* 请求基础数据 */
                [[LZLoginDataSend shareInstance] sendForLoginData_Before];
            }
        }
        
    }
}


#pragma mark login & connection

/*
 出错了 自动重链
// */
//-(void)loginRestartForConnectionFailure
//{
//    __block LZService * service = self;
//
//    self.connectfailurecount++;
//
//    DDLogVerbose(@"失败后，开始自动重连");
//
//    if(self.connectfailurecount<=CONNECTFAILURECOUNTMAX)
//    {
//        /* 发送状态，更改为"登录中.." */
//        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//        [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//        [data setObject:LZConnection_Login_NetWorkStatus_PrepareConect forKey:@"status"];
//        EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//
//        /* 重新登录 */
////        [self loginRestart];
//        NSString *tagID = [LZUtils CreateGUID];
//        self.loginRestartGUID = tagID;
//
//        [service performSelector:@selector(loginAutoRestart:) withObject:tagID afterDelay:2];
//    }
//    else
//    {
//        int sleepInterval = self.connectfailurecount;
//        if(sleepInterval>120){
//            sleepInterval = 120;
//        } else if(sleepInterval>60){
//            sleepInterval = 60;
//        } else if(sleepInterval>30){
//            sleepInterval = 30;
//        }
//        DDLogVerbose(@"间隔%d执行",sleepInterval);
//
//        NSString *tagID = [LZUtils CreateGUID];
//        self.loginRestartGUID = tagID;
//
//        [service performSelector:@selector(loginAutoRestart:) withObject:tagID afterDelay:sleepInterval];
//    }
//}
//-(void)loginAutoRestart:(NSString *)tagid{
//    if([self.loginRestartGUID isEqualToString:tagid]){
//        [self loginRestart];
//    }
//}
//
///*
// 用户操作重新登录(程序进入前台)
// */
//-(void)loginRestartForUserHandle
//{
//    self.connectfailurecount = 0;
//    self.loginRestartGUID = @"";
//
//    //用户操作重新登录
//    BOOL islogin_after = [LZUserDataManager readIsLoginBefore];
//
//    if(self.lzconnection.connected == NO && islogin_after)
//    {
//        _isLoginFromLoginVC = NO;
//
//        /* 超时处理 */
//        NSString *loginGUID = [LZUtils CreateGUID];
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        appDelegate.lzGlobalVariable.loginGUID = loginGUID;
//        [self performSelector:@selector(logingOutOfTime:) withObject:loginGUID afterDelay:180];
//
//        /* 开始登录 */
//        [self loginRestart];
//    }
//}
//
//
//
///*
// 重新登录
// */
//-(void)loginRestart
//{
//    //重新登录；
//    //登录成功记录信息
//    NSString *server =  [LZUserDataManager readServer];
//    NSString *loginName = [LZUserDataManager readUserLoginName];
//    NSString *password = [LZUserDataManager readUserPassword];
//
//    [[ErrorDAL shareInstance] addDataWithTitle:@"读取到的登录名、密码：" data:[NSString stringWithFormat:@"loginName：%@    password:%@",loginName,password] errortype:Error_Type_Seventeen];
//
//    NSString *loginType = [LZUserDataManager readLoginType];
//    NSString *refreshToken = [LZUserDataManager readThirdAppRefreshToken];
//
//    [self cancel];
//
//
//    if([NSString isNullOrEmpty:loginType]){
//        if([LZUserDataManager readIsPhoneValid]){//为安全校验登录
//            [self loginStartForIsPhoneValid:server loginName:loginName password:password];
//        }else{
//            [self loginStart:server loginName:loginName password:password];
//        }
//    } else {
//        [self loginThirdAppForRefreshToken:server apptype:loginType refreshtoken:refreshToken];
//    }
//}
//
//-(void)loginStartForClick:(NSString *)server loginName:(NSString*)loginName password:(NSString *)password
//{
//
//    //同步Synk
////    NSString* syncKey = @"344640037847703552_0_0";
////    //最后的 synckeys
////    NSMutableDictionary *syncDic = [LZUserDataManager readSynkInfo];
////
////    NSMutableDictionary *syncDicCopy = [[NSMutableDictionary alloc] init];
////    for (NSString *key in [syncDic allKeys]) {
////        [syncDicCopy setObject:[syncDic objectForKey:key] forKey:key];
////
////
////    [syncDicCopy setObject:[syncKey copy] forKey:[AppUtils GetCurrentUserID]];
////    [LZUserDataManager saveSynkInfo:syncDicCopy];
//    self.connectfailurecount = 0;
//    self.loginRestartGUID = @"";
//
//    [self cancel];
//
//    _isLoginFromLoginVC = YES;
//
//    /* 超时处理 */
//    NSString *loginGUID = [LZUtils CreateGUID];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.lzGlobalVariable.loginGUID = loginGUID;
//    [self performSelector:@selector(logingOutOfTime:) withObject:loginGUID afterDelay:180];
//
//    /* 开始登录 */
//    [self loginStart:server loginName:loginName password:password];
//}
/*
 开始登录
 */
//-(void)loginStart:(NSString *)server loginName:(NSString*)loginName password:(NSString *)password
//{
//    [self loginStart:server loginName:loginName password:password isHaveGetToken:NO];
//}

/*
 开始登录验证（登录web服务器）
 */
//-(void)loginStart:(NSString *)server loginName:(NSString*)loginName password:(NSString *)password isHaveGetToken:(BOOL)isHaveGetToken
//{
//    /* 记录日志，跟踪20161213，收到已读，数量减一 */
//    NSString *errorTitle = [NSString stringWithFormat:@"16--2--5"];
//    [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[NSString stringWithFormat:@"loginStart---loginName----%@",loginName] errortype:Error_Type_Five];
//
//    server = [[server stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
//
//    /* 去除收尾空格，中间空格不做处理 */
//    loginName = [loginName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if(!isHaveGetToken){
//        if(self.lzlogin == nil)
//        {
//            self.lzlogin = [[LZLogin alloc] initWithStart];
//        }
//
//        //当前不是登录中
//        if(self.lzlogin.loginning == YES)
//        {
//            return;
//        }
//        //登录中
//        self.lzlogin.loginning = YES;
//    }
//
//    __block LZService * service = self;
//
//    /* 设置成功事件 */
//    [self.lzlogin setSuccessHandler:^(NSString * tokenId,NSMutableDictionary *userinfo){
//
//        service.tokenId = tokenId;
//
//        /* 发送通知，TokenID */
//        NSMutableDictionary *loginSuccessData = [[NSMutableDictionary alloc] init];
//        [loginSuccessData setValue:tokenId forKey:@"tokenid"];
//        EVENT_PUBLISH_WITHDATA(service, EventBus_LoginWebSuccess, loginSuccessData);
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        if(appDelegate.lzGlobalVariable.lzLoginWebSuccess){
//            appDelegate.lzGlobalVariable.lzLoginWebSuccess(tokenId);
//            appDelegate.lzGlobalVariable.lzLoginWebSuccess = nil;
//        }
//
//        if([NSString isNullOrEmpty:password]){
//            [[ErrorDAL shareInstance] addDataWithTitle:@"存储登录密码出错：" data:[NSString stringWithFormat:@"password:%@",password] errortype:Error_Type_Seventeen];
//        }
//
//        //登录成功记录信息
//        [LZUserDataManager saveServer:server];
//        [LZUserDataManager saveUserLoginName:loginName];
//        [LZUserDataManager saveUserPassWord:password];
//        [LZUserDataManager saveLoginType:Login_Mode_Password];
//
//        [[ErrorDAL shareInstance] addDataWithTitle:@"登录成功记录信息--存储密码记录日志：" data:[NSString stringWithFormat:@"新的password:%@",[LZUserDataManager readUserPassword]] errortype:Error_Type_Seventeen];
//
//        /* 保存当前用户信息 */
//        NSMutableDictionary *userinfoCopy = [[NSMutableDictionary alloc] init];
//        for (NSString *key in [userinfo allKeys]) {
//            [userinfoCopy setObject:[userinfo objectForKey:key] forKey:key];
//        }
//
//        /* 处理selectoid 为空的情况 */
//        NSString *notification = [userinfo objectForKey:@"notificaton"];
//        if(![NSString isNullOrEmpty:notification]){
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[notification seriaToDic]];
//            NSNumber *identitytypeNum = [dic lzNSNumberForKey:@"identitytype"];
//            NSString *identitytype = [NSString stringWithFormat:@"%@",identitytypeNum];
//            if([identitytype isEqualToString:@"1"]){
//                [dic setValue:[userinfo lzNSStringForKey:@"uid"] forKey:@"selectoid"];
//            }
//            if( [dic objectForKey:@"selectoid"] == [NSNull null]){
//                /* 处理新用户第一次注册登录时，创建组织后 默认进入创建的组织  dfl 2016-04-21 */
//                NSMutableArray *orgbyuser=[userinfo objectForKey:@"orgsbyuser"];
//                NSMutableDictionary *orgdic=[orgbyuser firstObject];
//                if(orgbyuser.count==0){
//                    /* 没有创建组织时，默认进入己方 */
//                    [dic setValue:[userinfo lzNSStringForKey:@"uid"] forKey:@"selectoid"];
//                }else{
//                    [dic setValue:[orgdic lzNSStringForKey:@"oid"] forKey:@"selectoid"];
//                }
//
//            }
//            NSDictionary *loginsecurity = [dic lzNSDictonaryForKey:@"loginsecurity"];
//            NSNumber *isphonevalidNum = [loginsecurity lzNSNumberForKey:@"isphonevalid"];
//            /* 记录是否开启登录安全校验 */
//            [LZUserDataManager saveIsPhoneValid:isphonevalidNum.intValue==1];
//
//            [userinfoCopy setObject:dic forKey:@"notificaton"];
//        } else {
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//            [dic setValue:[userinfo lzNSStringForKey:@"uid"] forKey:@"selectoid"];
//            [userinfoCopy setObject:dic forKey:@"notificaton"];
//        }
//
//        /* 记录上一用户的uid */
//        NSString *preUid = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
//        if([NSString isNullOrEmpty:preUid]){
//            preUid = @"";
//        }
//        [userinfoCopy setObject:preUid forKey:@"preuid"];
//
//        /* 处理orgsbyuser 中属性为空的情况 */
//        [LZUserDataManager saveCurrentUserInfo:userinfoCopy];
//
//        /* 判断当前用户是否为灰度用户 */
//        NSNumber *gayScaleNum = [userinfoCopy lzNSNumberForKey:@"gayscale"];
//        [LZUserDataManager saveIsGayScaleUser:gayScaleNum.intValue==1];
//
//        DataAccessMain *daMain = [[DataAccessMain alloc] init];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setObject:[AppUtils GetCurrentUserID] forKey:@"uid"];
//        [dic setObject: [NSNumber numberWithBool:[daMain checkIsCreatedDB]] forKey:@"iscreateddb"];
//        [LZUserDataManager saveIsFirstLaunch:dic];

//        /* 开始长连接 */
//        [service connectPollingStart:service.tokenId msgserver: service.msgserver];
//        
//        //创建或升级数据库
//        DataAccessMain *daMain = [[DataAccessMain alloc] init];
//        [daMain createOrUpdateDataTable];
//        
//        //取得当前人信息
//        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//        [data setObject:LZConnection_Login_Success forKey:@"type"];
//        [data setObject:userinfo forKey:@"userinfo"];
//        
//        EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//        
//        
//        //已经链接
//        data = [[NSMutableDictionary alloc] init];
//        [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//        [data setObject:LZConnection_Login_NetWorkStatus_Connected forKey:@"status"];
//        
//        EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
        
//        NSString *isContinueLoginIM = @"1";
//        if(service.isLoginFromLoginVC){
////            isContinueLoginIM = @"0";
//        }
//        if([LZUserDataManager readIsPhoneValid]){
//            isContinueLoginIM = @"0";
//        }
//        [service.lzconnection setLoginInfo:tokenId msgserver:nil serverUrl:nil];
//        //服务圈启动
//        NSDictionary *cirdic = [LZUserDataManager readHomeSeriviceCircleUid:[AppUtils GetCurrentUserID]];
//        NSString *curScid = [cirdic lzNSStringForKey:@"scid"];
//        if(([[LZUserDataManager readServer] isEqualToString:[LZUserDataManager readPublicServer]]
//            || [[[LZUserDataManager readServer] lowercaseString] rangeOfString:@"y.lizheng.com.cn"].location!=NSNotFound) && [NSString isNullOrEmpty:curScid]){//公有云
//            if(![LZUserDataManager readIsPhoneValid]){
//                /* 开始长连接 */
//                [service connectPollingStart:service.tokenId msgserver: service.msgserver];
//            }
//            NSString *scirfirsturl = [NSString stringWithFormat:@"%@%@%@",[ModuleServerUtil GetServerWithModule:Modules_Default],@"/api/servicecircles/getfirstpagebyuid/2/",tokenId];
//            [XHHTTPClient  GETPath: scirfirsturl
//                jsonSuccessHandler:^(LZURLConnection *connection, id json) {
//
//                    NSDictionary *contextDic=[json lzNSDictonaryForKey:@"DataContext"];
//                    DDLogVerbose(@"--------%@",json);
//                    NSString *scid = [contextDic lzNSStringForKey:@"scid"];
//                    if (scid && [scid length]>1) {
//                        //读取本地的
//                        NSDictionary *olddic = [LZUserDataManager readHomeSeriviceCircleUid:[AppUtils GetCurrentUserID]];
//                        NSString * oldfile = [olddic lzNSStringForKey:@"firstlogo"];
//
//                        [LZUserDataManager saveIsLoadHomeSeriviceCircle:YES Uid:[AppUtils GetCurrentUserID]];
//                        [LZUserDataManager saveHomeSeriviceCircle:contextDic Uid:[AppUtils GetCurrentUserID]];
//
//                        NSString *fileid = [contextDic lzNSStringForKey:@"firstlogo"];
//                        if (fileid && [fileid length]>0) { //每次都下载吗？是否要读取本地呢
//                            if(![fileid isEqualToString:oldfile]){ //不等时才下载
//                                [AppUtils GetImageWithFileID:fileid Size:nil GetNewImage:^(UIImage *image, NSData *data) {
//                                    [[ServiceCircleModel shareInstance]saveMainFileLogo:data];
//                                }];
//                            }
//                        }else{
//                            [[ServiceCircleModel shareInstance]removeMainFileLogo];
//                        }
//
//                    }else{
//                        //没有主服务圈 删除
//                        [[ServiceCircleModel shareInstance]removeMainFileLogo];
//                        [[ServiceCircleModel shareInstance]saveMainHomeServiceCirclesInfo:nil Uid:[AppUtils GetCurrentUserID]];
//                    }
//                    //开始登录
//                    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//                    [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//                    [data setObject:LZConnection_Login_NetWorkStatus_NamePwdRight forKey:@"status"];
//                    [data setObject:isContinueLoginIM forKey:@"iscontinueloginim"];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//                        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, @"100");
//                    });
//                    if([isContinueLoginIM isEqualToString:@"1"]){
//                        /* 登录消息服务器 */
//                        //            [service loginToIMServer];
//                        [service performSelector:@selector(loginToIMServer) withObject:nil afterDelay:0.1];
//                    }
//
//                } failureHandler:^(LZURLConnection *connection, NSData *responseData, NSURLResponse *response, NSError *error) {
//                    //开始登录
//                    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//                    [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//                    [data setObject:LZConnection_Login_NetWorkStatus_NamePwdRight forKey:@"status"];
//                    [data setObject:isContinueLoginIM forKey:@"iscontinueloginim"];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
////                        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, @"100");
//                    });
//                    if([isContinueLoginIM isEqualToString:@"1"]){
//                        /* 登录消息服务器 */
//                        //            [service loginToIMServer];
//                        [service performSelector:@selector(loginToIMServer) withObject:nil afterDelay:0.1];
//                    }
//                    if(connection.iscancel == YES) return;
//                    NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//                    dataString = [NSString stringWithFormat:@"%@",dataString];
//
//                    DDLogError(@"lzlogin getModulesServer error responseData:%@, error:%@",dataString,error);
//                }];
//        }
//        else{
            //开始登录
//            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//            [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//            [data setObject:LZConnection_Login_NetWorkStatus_NamePwdRight forKey:@"status"];
//            [data setObject:isContinueLoginIM forKey:@"iscontinueloginim"];
//
//            EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//
//            if([isContinueLoginIM isEqualToString:@"1"]){
//                /* 登录消息服务器 */
//                //            [service loginToIMServer];
//                [service performSelector:@selector(loginToIMServer) withObject:nil afterDelay:0.1];
//            }
//        }
//        //开始登录
//        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//        [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//        [data setObject:LZConnection_Login_NetWorkStatus_NamePwdRight forKey:@"status"];
//        [data setObject:isContinueLoginIM forKey:@"iscontinueloginim"];
//        
//        EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//
//        if([isContinueLoginIM isEqualToString:@"1"]){
//            /* 登录消息服务器 */
////            [service loginToIMServer];
//            [service performSelector:@selector(loginToIMServer) withObject:nil afterDelay:0.1];
//        }
        //服务圈启动
//        NSDictionary *cirdic = [LZUserDataManager readHomeSeriviceCircleUid:[AppUtils GetCurrentUserID]];
//        NSString *curScid = [cirdic lzNSStringForKey:@"scid"];
//        if(([[LZUserDataManager readServer] isEqualToString:[LZUserDataManager readPublicServer]]
//            || [[[LZUserDataManager readServer] lowercaseString] rangeOfString:@"y.lizheng.com.cn"].location!=NSNotFound)  && [NSString isNullOrEmpty:curScid]){//公有云
//            /* 从服务器端请求模板 */
//            WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
//                NSString *code = [[dataDic lzNSDictonaryForKey:WebApi_ErrorCode] objectForKey:@"Code"];
//
//                if([code isEqualToString:@"0"]){
//                    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
//
//                    NSString *scid = [contextDic lzNSStringForKey:@"scid"];
//                    if (scid && [scid length]>1) {
//                        //读取本地的
//                        NSDictionary *olddic = [LZUserDataManager readHomeSeriviceCircleUid:[AppUtils GetCurrentUserID]];
//                        NSString * oldfile = [olddic lzNSStringForKey:@"firstlogo"];
//
//                        [LZUserDataManager saveIsLoadHomeSeriviceCircle:YES Uid:[AppUtils GetCurrentUserID]];
//                        [LZUserDataManager saveHomeSeriviceCircle:contextDic Uid:[AppUtils GetCurrentUserID]];
//
//                        NSString *fileid = [contextDic lzNSStringForKey:@"firstlogo"];
//                        if (fileid && [fileid length]>0) { //每次都下载吗？是否要读取本地呢
//                            if(![fileid isEqualToString:oldfile]){ //不等时才下载
//                                [AppUtils GetImageWithFileID:fileid Size:nil GetNewImage:^(UIImage *image, NSData *data) {
//                                    [[ServiceCircleModel shareInstance]saveMainFileLogo:data];
//                                }];
//                            }
//                        }else{
//                            [[ServiceCircleModel shareInstance]removeMainFileLogo];
//                        }
//                    }else{
//                        //没有主服务圈 删除
//                        [[ServiceCircleModel shareInstance]removeMainFileLogo];
//                        [[ServiceCircleModel shareInstance]saveMainHomeServiceCirclesInfo:nil Uid:[AppUtils GetCurrentUserID]];
//                    }
//                }
//                //开始登录
//                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//                [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//                [data setObject:LZConnection_Login_NetWorkStatus_NamePwdRight forKey:@"status"];
//                [data setObject:isContinueLoginIM forKey:@"iscontinueloginim"];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//                    EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, @"100");
//                });
//                if([isContinueLoginIM isEqualToString:@"1"]){
//                    /* 登录消息服务器 */
//                    //            [service loginToIMServer];
//                    [service performSelector:@selector(loginToIMServer) withObject:nil afterDelay:0.1];
//                }
//
//            };
//            //应该每次请求，
//            NSMutableDictionary *cirGetDic = [NSMutableDictionary dictionary];
//            cirGetDic[@"client"] = @"2";
//            NSDictionary *otherData = @{WebApi_DataSend_Other_BackBlock:backBlock,
//                                        WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowNetFail,
//                                        };
//            [appDelegate.lzservice noLoginSendToServerForGet:WebApi_CloudsServiceCircles routePath:WebApi_CloudsServiceCircles_Getfirstpagebyuid moduleServer:Modules_Default getData:cirGetDic otherData:otherData];
//
//        }
//        else{
//            //开始登录
//            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//            [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//            [data setObject:LZConnection_Login_NetWorkStatus_NamePwdRight forKey:@"status"];
//            [data setObject:isContinueLoginIM forKey:@"iscontinueloginim"];
//
//            EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//
//            if([isContinueLoginIM isEqualToString:@"1"]){
//                /* 登录消息服务器 */
//    //            [service loginToIMServer];
//                [service performSelector:@selector(loginToIMServer) withObject:nil afterDelay:0.1];
//            }
//        }
        
        
//    } ];

    /* 设置失败事件 */
//    [self.lzlogin setFailureHandler:^(int code, NSString *error) {
//
//        /* 密码错误时，不再重试 */
//        BOOL isContinueLogin = NO;
//        if(code==8810000 || code==884000){
//            isContinueLogin = YES;
//        }
//
//        /* 超过重连次数，或者在后台，或者网络未连接 */
//        if(self.connectfailurecount>CONNECTFAILURECOUNTMAX
//           || [[UIApplication sharedApplication] applicationState] != UIApplicationStateActive
//           || ![LZUserDataManager readIsConnectNetWork]
//           || !isContinueLogin){
//
//            /* 记录日志，跟踪20161213，收到已读，数量减一 */
//            NSString *errorTitle = [NSString stringWithFormat:@"16--2"];
//            [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[NSString stringWithFormat:@"MessageRootVC---LZConnection_Login_Failure-----%d",code] errortype:Error_Type_Five];
//
//            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//            [data setObject:LZConnection_Login_Failure forKey:@"type"];
//            [data setObject:  [NSString stringWithFormat:@"%d",code] forKey:@"code"];
//            [data setObject:error forKey:@"error"];
//
//            EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//
//            /* 消息页（联网且不再后台时且非密码错误），一直自动重连 */
//            if([LZUserDataManager readIsLoginBefore]
//               && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive
//               && [LZUserDataManager readIsConnectNetWork]
//               && isContinueLogin){
//                //自动重链
//                [service loginRestartForConnectionFailure];
//            }
//        } else {
//
//            //自动重链
//            [service loginRestartForConnectionFailure];
//        }
//
//    }];
//
//    if(!isHaveGetToken){
//        [self.lzconnection cancel];
//
////        [self.lzlogin initLogin];
//
//        /* 开始登录 */
////        [self.lzlogin login:server loginName:loginName password:password];
//    }
//    else {
////        [self.lzlogin loginWithLoginName:loginName password:password];
//    }
//
//    //开始登录
//    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//    [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//    [data setObject:LZConnection_Login_NetWorkStatus_Connecting forKey:@"status"];
//
//    EVENT_PUBLISH_WITHDATA(self, EventBus_ConnectHandle, data);
//}

/**
 *  登录到消息服务器，并开始长连接
 */
-(void)loginToIMServer{
    
    _isLoginFromLoginVC = NO;
    
    __block LZService * service = self;

    //已经链接
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
    [data setObject:LZConnection_Login_NetWorkStatus_Connected forKey:@"status"];
    EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //创建或升级数据库(尝试三次)
        DataAccessMain *daMain = [[DataAccessMain alloc] init];
        BOOL result = YES;
        for(int i=0;i<3;i++){
            DDLogVerbose(@"数据库创建----第%d次",i);
            result = [daMain createOrUpdateDataTable];
            if(result){
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!result){
                //数据库创建失败
                NSMutableDictionary *dataForDb = [[NSMutableDictionary alloc] init];
                [dataForDb setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
                [dataForDb setObject:LZConnection_Login_NetWorkStatus_DbCreateError forKey:@"status"];
                EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, dataForDb);
                return;
            }
            EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);

            /* 开始长连接 */
            [self connectPollingStart:self.tokenId msgserver: self.msgserver];

            //    //创建或升级数据库
            //    DataAccessMain *daMain = [[DataAccessMain alloc] init];
            //    [daMain createOrUpdateDataTable];
            
            //取得当前人信息
            NSMutableDictionary *datainmain = nil;
            datainmain = [[NSMutableDictionary alloc] init];
            [datainmain setObject:LZConnection_Login_Success forKey:@"type"];
            
            EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, datainmain);

            //已经链接
            datainmain = [[NSMutableDictionary alloc] init];
            [datainmain setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
            [datainmain setObject:LZConnection_Login_NetWorkStatus_Connected forKey:@"status"];
            
            EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, datainmain);
        });

    });

    
}

/*
 点击注册，或找回密码时调用
 */
//-(void)loginForGetTokenID:(NSString *)server
//{
//    [self cancel];
//
//    server = [[server stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
//
//    /* 先取消上一次的请求 */
////    self.lzlogin = nil;
////    self.lzlogin = [[LZLogin alloc] initWithStart];
//
////    if(self.lzlogin == nil)
////    {
////        self.lzlogin = [[LZLogin alloc] initWithStart];
////    }
//
//    //当前不是登录中
//    if(self.lzlogin.loginning == YES)
//    {
//        return;
//    }
//
//    //登录中
//    self.lzlogin.loginning = YES;
//
//    __block LZService * service = self;
//
//    /* 设置成功事件 */
//    [self.lzlogin setGetTokenIDSuccessHandler:^(NSString *tokenId) {
//        DDLogVerbose(@"获取TokenID成功");
//        EVENT_PUBLISH_WITHDATA(service, EventBus_LZConnection_GetToken, LZConnection_GetToken_Success);
//    }];
//
//    /* 设置失败事件 */
//    [self.lzlogin setGetTokenIDFailureHandler:^(int code, NSString *error) {
//        DDLogVerbose(@"获取TokenID失败");
//        EVENT_PUBLISH_WITHDATA(service, EventBus_LZConnection_GetToken, LZConnection_GetToken_Failure);
//    }];
//    [self.lzconnection cancel];
//    [self.lzlogin initLogin];
//
//    /* 开始获取 */
//    [self.lzlogin loginForGetTokenID:server];
//}
//
///**
// *  在已经有Token的时候，进行登录
// */
//-(void)loginStartAfterGetTokenID:(NSString *)server loginName:(NSString*)loginName password:(NSString *)password{
//    self.connectfailurecount = 0;
//    self.loginRestartGUID = @"";
//
//    /* 记录日志，跟踪20161213，收到已读，数量减一 */
//    NSString *errorTitle = [NSString stringWithFormat:@"16--2--6"];
//    [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[NSString stringWithFormat:@"loginStartAfterGetTokenID--loginName----%@",loginName] errortype:Error_Type_Five];
//
//    _isLoginFromLoginVC = NO;
//
//    /* 避免自动尝试登录时，使用之前的用户名、密码 */
//    [LZUserDataManager saveUserLoginName:loginName];
//    [LZUserDataManager saveUserPassWord:@""];
//
//    [self loginStart:server loginName:loginName password:password isHaveGetToken:YES];
//}
//
///*
// 开始登录
// */
//-(void) loginCancel
//{
//    if (self.lzlogin!=nil) {
//        [self.lzlogin cancel];
//    }
//}


/*
 获取服务器
 */
//-(void)loginForGetModuleServer:(NSString *)server
//{
//    server = [[server stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
//
//    /* 先取消上一次的请求 */
//    [self loginCancel];
//    self.lzlogin = nil;
//    self.lzlogin = [[LZLogin alloc] initWithStart];
//
////    if(self.lzlogin == nil)
////    {
////        self.lzlogin = [[LZLogin alloc] initWithStart];
////    }
//
//    __block LZService * service = self;
//    /* 设置成功事件 */
//    [self.lzlogin setGetModuleServerSuccessHandler:^(NSString *tokenId) {
//        DDLogVerbose(@"获取ModuleServer成功");
//        EVENT_PUBLISH_WITHDATA(service, EventBus_LZConnection_GetModuleServer, LZConnection_GetModuleServer_Success);
//    }];
//
//    /* 设置失败事件 */
//    [self.lzlogin setGetModuleServerFailureHandler:^(int code, NSString *error) {
//        DDLogVerbose(@"获取ModuleServer失败");
//        EVENT_PUBLISH_WITHDATA(service, EventBus_LZConnection_GetModuleServer, LZConnection_GetModuleServer_Failure);
//    }];
//    [self.lzlogin initLogin];
//
//    /* 开始获取 */
//    [self.lzlogin loginForGetModuleServers:server];
//}
//

/*
 开始长链接
 */
-(void)connectPollingStart:(NSString *)tokenId msgserver:(NSString*)msgserver
{
    //connection 始终只创建一次
    if(self.lzconnection == nil)
    {
        NSString *errorTitle = [NSString stringWithFormat:@"创建新的LZConnection=%@",[AppDateUtil GetCurrentDateForString]];
        
        [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:@"" errortype:Error_Type_Twelve];
        
        self.lzconnection = [[LZConnection alloc] initWithReady];
    }
    
    if (self.lzconnection.connecting == YES) {
        return;
    }
    
    self.lzconnection.connecting = YES;
    
    __block LZService * service = self;
    
    //链接成功
    [self.lzconnection setSuccessHandler:^(id tempdata) {
       
        service.connectfailurecount = 0;
        service.loginRestartGUID = @"";
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:LZConnection_Connection_Success forKey:@"type"];
        
        EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
    }];
    
    //设置错误事件
    [self.lzconnection setFailureHandler:^(int code, NSString *error) {

        /* 超过重连次数，或者在后台，或者网络未连接 */
        if(self.connectfailurecount>CONNECTFAILURECOUNTMAX
           || [[UIApplication sharedApplication] applicationState] != UIApplicationStateActive
           || ![LZUserDataManager readIsConnectNetWork]){
    
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
            [data setObject:LZConnection_Login_NetWorkStatus_ConnectFail forKey:@"status"];
            [data setObject:  [NSString stringWithFormat:@"%d",code] forKey:@"code"];
            [data setObject:error forKey:@"error"];
            
            EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
            
            /* 消息页（联网且不再后台时），一直自动重连 */
            if([LZUserDataManager readIsLoginBefore]
               && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive
               && [LZUserDataManager readIsConnectNetWork]){
                //自动重链
//                [service loginRestartForConnectionFailure];
            }
        } else {
            
            //自动重链
//            [service loginRestartForConnectionFailure];
        }
        
    }];
    
    
    //发送成功
    [self.lzconnection setSendSuccessHandler:^(id senddata) {
        
//        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//        [data setObject:LZConnection_Send_Success forKey:@"type"];
//        [data setObject:senddata forKey:@"data"];
        
        [[DataExchangeParse shareInstance] parse:senddata];
    }];
    
    //发送失败
    [self.lzconnection setSendFailureHandler:^(int type,id senddata) {
        
        if(type ==0 ){
            DDLogError(@"消息发送失败");

            /* 更改发送队列中的数据为失败状态 */
            NSString *clienttempid = [senddata objectForKey:@"clienttempid"];
            [[ImMsgQueueDAL shareInstance] updateStatusWithMqid:clienttempid status:Message_Queue_SendFail];
        }
        else {
            DDLogError(@"WebApi请求超时");
                        
            if([senddata isKindOfClass:[NSDictionary class]] &&
               [[[senddata lzNSDictonaryForKey:WebApi_DataSend_Get] lzNSStringForKey:@"lastwebapi"] isEqualToString:@"1"]){
                
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
                [data setObject:LZConnection_Login_NetWorkStatus_RecvFinish forKey:@"status"];
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.lzGlobalVariable.isShowLoadingWhenLoginWebFromLoginVC = NO;
                
                EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
            }
            
            EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, senddata);
        }
        
    }];
    
    //设置定时重发消息
    [self.lzconnection setResendMessageHandler:^(id data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [service resendFailedMsgQueue:300];
        });
    }];
    
    //长连接结果处理
    [self.lzconnection setLongPullResultHandler:^(id data) {
        NSString *code = [[data objectForKey:@"ErrorCode"] objectForKey:@"Code"];
        if([code isEqualToString:@"0"])
        {
            int ret = 0;
            if([[data objectForKey:@"DataContext"] isKindOfClass:[NSDictionary class]]){
                NSDictionary *datacontext = [data objectForKey:@"DataContext"];
                NSNumber *retNum = [datacontext objectForKey:@"ret"];
                ret = retNum.intValue;
            } else {
                ret = [[data objectForKey:@"DataContext"] intValue];
            }

            /* 被踢下线 */
            if(ret==-10)
            {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    EVENT_PUBLISH_WITHDATA(service, EventBus_Login_Quit, nil);
                    
                });

                
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LZGDCommonLocailzableString(@"common_hint")
//                                                                message:LZGDCommonLocailzableString(@"login_user_login_other")
//                                                               delegate:nil
//                                                      cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm")
//                                                      otherButtonTitles:nil];
//                [alert show];
//
//                /* 记录日志，跟踪20161213，收到已读，数量减一 */
//                NSString *errorTitle = [NSString stringWithFormat:@"12"];
//                [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:@"被踢下线" errortype:Error_Type_Five];
//
//                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                [appDelegate gotoLoginPageIsSendWebApi:NO isGotoLoginVC:YES];
            }
        }
    }];
    
    /* 记录下当前的synk */
    ErrorModel *errorModel=[[ErrorModel alloc]init];
    errorModel.errorid=[LZUtils CreateGUID];
    errorModel.errortitle=[NSString stringWithFormat:@"登录时的Synk:%@",[LZUserDataManager readLoginType]];
    errorModel.erroruid=[AppUtils GetCurrentUserID];
    errorModel.errorclass=@"";
    errorModel.errormethod=@"";
    errorModel.errordata=[NSString stringWithFormat:@"data: %@",[LZUserDataManager readSynkInfo]];
    errorModel.errordate=[AppDateUtil GetCurrentDate];
    errorModel.errortype=2;
    [[ErrorDAL shareInstance]addDataWithErrorModel:errorModel];
    
    //设置登录信息
    [self.lzconnection setLoginInfo:tokenId msgserver:msgserver serverUrl:self.serverUrl];
    
    //登录IM
    [self.lzconnection login];
    
   
    
}

/*
 取消
 */
-(void)cancel
{
    [self connectPollingCancel];
    [self loginCancel];
}

/*
 长链接
 */
-(void)connectPollingCancel
{
    if(self.lzconnection !=nil)
    {
        [self.lzconnection cancel];
    }
}

/*
 发送消息
 */
-(void)send:(NSDictionary *)data
{
    /**
     发送之前，将数据转换为发送格式的类型
     */
    NSMutableDictionary *msgInfo = [[NSMutableDictionary alloc] initWithDictionary:data];
    NSString *chatMsgType = [msgInfo objectForKey:@"handlertype"];
    /* 转换to */
    NSString *to = (NSString *)[msgInfo objectForKey:@"to"];
    
    NSMutableArray *toArray = [[NSMutableArray alloc] init];
    [toArray addObject:to];
    [msgInfo setObject:toArray forKey:@"to"];
    
    /* 发送文本 */
    if([chatMsgType hasSuffix:Handler_Message_LZChat_LZMsgNormal_Text]){
        NSString *content = [msgInfo lzNSStringForKey:@"content"];
        [msgInfo setValue:[[LZUtils escape:content] base64EncodedString] forKey:@"content"];
        [msgInfo setValue:@"base64" forKey:@"Encode"];
    }
    /* 发送拍照、图片 */
    else if([chatMsgType hasSuffix:Handler_Message_LZChat_Image_Download]){
    }
    /* 发送云盘文件 */
    else if([chatMsgType hasSuffix:Handler_Message_LZChat_File_Download]){
    }
    /* url链接 */
    else if ([chatMsgType hasSuffix:Handler_Message_LZChat_UrlLink]) {
    }
    else if ([chatMsgType hasSuffix:Handler_Message_LZChat_ChatLog]) {
    }
    /* 共享文件 */
    else if ([chatMsgType hasSuffix:Handler_Message_LZChat_LZTemplateMsg_CooperationShareFile]) {
    }
    /* 发送语音文件 */
    else if([chatMsgType hasSuffix:Handler_Message_LZChat_Voice]){
    }
    /* 发送语音通话 */
    else if([chatMsgType hasSuffix:Handler_Message_LZChat_VoiceCall]){
    }
    /* 发送视频通话 */
    else if([chatMsgType hasSuffix:Handler_Message_LZChat_VideoCall]){
    }
    /* 发送位置 */
    else if([chatMsgType hasSuffix:Handler_Message_LZChat_Geolocation]){
    }
    /* 发送视频 */
    else if ([chatMsgType hasSuffix:Handler_Message_LZChat_Micro_Video]) {
    }
    [msgInfo removeObjectForKey:@"fileinfo"];
    [msgInfo removeObjectForKey:@"voiceinfo"];
    [msgInfo removeObjectForKey:@"geolocationinfo"];
    [msgInfo removeObjectForKey:@"readstatus"];
    
    /* 记录最后一次发送出去的消息ID  */
    _longPoolIsRuning = @"";
    [self performSelector:@selector(resendAfterLastMsgSend:) withObject:[msgInfo objectForKey:@"clienttempid"] afterDelay:60];
    
    [self.lzconnection send:msgInfo];
}

#pragma mark - 登录超时处理

/**
 *  登录超时处理
 */
- (void)logingOutOfTime:(NSString *)uuid
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([uuid isEqualToString:appDelegate.lzGlobalVariable.loginGUID]){
        
        /* 记录日志，跟踪20161213，收到已读，数量减一 */
        NSString *errorTitle = [NSString stringWithFormat:@"16--1"];
        [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:@"LZService---logingOutOfTime" errortype:Error_Type_Five];
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:LZConnection_Login_Failure forKey:@"type"];
        EVENT_PUBLISH_WITHDATA(self, EventBus_ConnectHandle, data);
    }
}

#pragma mark - 安全校验登录
//-(void)loginStartForIsPhoneValidClick:(NSString *)server loginName:(NSString*)loginName password:(NSString *)password{
//    self.connectfailurecount = 0;
//    self.loginRestartGUID = @"";
//
//    [self cancel];
//
//    _isLoginFromLoginVC = YES;
//
//    /* 超时处理 */
//    NSString *loginGUID = [LZUtils CreateGUID];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.lzGlobalVariable.loginGUID = loginGUID;
//    [self performSelector:@selector(logingOutOfTime:) withObject:loginGUID afterDelay:180];
//
//    /* 开始登录 */
//    [self loginStartForIsPhoneValid:server loginName:loginName password:password isHaveGetToken:NO];
//}
//
//-(void)loginStartForIsPhoneValid:(NSString *)server loginName:(NSString*)loginName password:(NSString *)password{
//    /* 开始登录 */
//    [self loginStartForIsPhoneValid:server loginName:loginName password:password isHaveGetToken:NO];
//}

/*
 开始登录验证（登录web服务器）
 */
//-(void)loginStartForIsPhoneValid:(NSString *)server loginName:(NSString*)loginName password:(NSString *)password isHaveGetToken:(BOOL)isHaveGetToken
//{
//    /* 记录日志，跟踪20161213，收到已读，数量减一 */
//    NSString *errorTitle = [NSString stringWithFormat:@"16--2--5"];
//    [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[NSString stringWithFormat:@"loginStart---loginName----%@",loginName] errortype:Error_Type_Five];
//
//    server = [[server stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
//
//    /* 去除收尾空格，中间空格不做处理 */
//    loginName = [loginName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if(!isHaveGetToken){
////        if(self.lzlogin == nil)
////        {
////            self.lzlogin = [[LZLogin alloc] initWithStart];
////        }
////
////        //当前不是登录中
////        if(self.lzlogin.loginning == YES)
////        {
////            return;
////        }
//        //登录中
//        self.lzlogin.loginning = YES;
//    }
//
//    __block LZService * service = self;
//
//    /* 设置成功事件 */
//    [self.lzlogin setSuccessHandler:^(NSString * tokenId,NSMutableDictionary *userinfo){
//
//        service.tokenId = tokenId;
//
//        /* 发送通知，TokenID */
//        NSMutableDictionary *loginSuccessData = [[NSMutableDictionary alloc] init];
//        [loginSuccessData setValue:tokenId forKey:@"tokenid"];
//        EVENT_PUBLISH_WITHDATA(service, EventBus_LoginWebSuccess, loginSuccessData);
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        if(appDelegate.lzGlobalVariable.lzLoginWebSuccess){
//            appDelegate.lzGlobalVariable.lzLoginWebSuccess(tokenId);
//            appDelegate.lzGlobalVariable.lzLoginWebSuccess = nil;
//        }
//
//        if([NSString isNullOrEmpty:password]){
//            [[ErrorDAL shareInstance] addDataWithTitle:@"存储登录密码出错：" data:[NSString stringWithFormat:@"password:%@",password] errortype:Error_Type_Seventeen];
//        }
//
//        //登录成功记录信息
//        [LZUserDataManager saveServer:server];
//        [LZUserDataManager saveUserLoginName:loginName];
//        [LZUserDataManager saveUserPassWord:password];
//        [LZUserDataManager saveLoginType:Login_Mode_Password];
//
//        [[ErrorDAL shareInstance] addDataWithTitle:@"登录成功记录信息（安全校验）--存储密码记录日志：" data:[NSString stringWithFormat:@"新的password:%@",[LZUserDataManager readUserPassword]] errortype:Error_Type_Seventeen];
//
//        /* 保存当前用户信息 */
//        NSMutableDictionary *userinfoCopy = [[NSMutableDictionary alloc] init];
//        for (NSString *key in [userinfo allKeys]) {
//            [userinfoCopy setObject:[userinfo objectForKey:key] forKey:key];
//        }
//
//        /* 处理selectoid 为空的情况 */
//        NSString *notification = [userinfo objectForKey:@"notificaton"];
//        if(![NSString isNullOrEmpty:notification]){
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[notification seriaToDic]];
//            NSNumber *identitytypeNum = [dic lzNSNumberForKey:@"identitytype"];
//            NSString *identitytype = [NSString stringWithFormat:@"%@",identitytypeNum];
//            if([identitytype isEqualToString:@"1"]){
//                [dic setValue:[userinfo lzNSStringForKey:@"uid"] forKey:@"selectoid"];
//            }
//            if( [dic objectForKey:@"selectoid"] == [NSNull null]){
//                /* 处理新用户第一次注册登录时，创建组织后 默认进入创建的组织  dfl 2016-04-21 */
//                NSMutableArray *orgbyuser=[userinfo objectForKey:@"orgsbyuser"];
//                NSMutableDictionary *orgdic=[orgbyuser firstObject];
//                if(orgbyuser.count==0){
//                    /* 没有创建组织时，默认进入己方 */
//                    [dic setValue:[userinfo lzNSStringForKey:@"uid"] forKey:@"selectoid"];
//                }else{
//                    [dic setValue:[orgdic lzNSStringForKey:@"oid"] forKey:@"selectoid"];
//                }
//
//            }
//            NSDictionary *loginsecurity = [dic lzNSDictonaryForKey:@"loginsecurity"];
//            NSNumber *isphonevalidNum = [loginsecurity lzNSNumberForKey:@"isphonevalid"];
//            /* 记录是否开启登录安全校验 */
//            [LZUserDataManager saveIsPhoneValid:isphonevalidNum.intValue==1];
//
//            [userinfoCopy setObject:dic forKey:@"notificaton"];
//        } else {
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//            [dic setValue:[userinfo lzNSStringForKey:@"uid"] forKey:@"selectoid"];
//            [userinfoCopy setObject:dic forKey:@"notificaton"];
//        }
//
//        /* 记录上一用户的uid */
//        NSString *preUid = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
//        if([NSString isNullOrEmpty:preUid]){
//            preUid = @"";
//        }
//        [userinfoCopy setObject:preUid forKey:@"preuid"];
//
//        /* 处理orgsbyuser 中属性为空的情况 */
//        [LZUserDataManager saveCurrentUserInfo:userinfoCopy];
//
//        /* 判断当前用户是否为灰度用户 */
//        NSNumber *gayScaleNum = [userinfoCopy lzNSNumberForKey:@"gayscale"];
//        [LZUserDataManager saveIsGayScaleUser:gayScaleNum.intValue==1];
//
//        DataAccessMain *daMain = [[DataAccessMain alloc] init];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setObject:[AppUtils GetCurrentUserID] forKey:@"uid"];
//        [dic setObject: [NSNumber numberWithBool:[daMain checkIsCreatedDB]] forKey:@"iscreateddb"];
//        [LZUserDataManager saveIsFirstLaunch:dic];
//
//        NSString *isContinueLoginIM = @"1";
//        if(service.isLoginFromLoginVC){
//            //            isContinueLoginIM = @"0";
//        }
//        //开始登录
//        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//        [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//        [data setObject:LZConnection_Login_NetWorkStatus_NamePwdRight forKey:@"status"];
//        [data setObject:isContinueLoginIM forKey:@"iscontinueloginim"];
//
//        EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//
//        if([isContinueLoginIM isEqualToString:@"1"]){
//            /* 登录消息服务器 */
//            //            [service loginToIMServer];
//            [service performSelector:@selector(loginToIMServer) withObject:nil afterDelay:0.1];
//        }
//
//    } ];
//
//    /* 设置失败事件 */
//    [self.lzlogin setFailureHandler:^(int code, NSString *error) {
//
//        /* 密码错误时，不再重试 */
//        BOOL isContinueLogin = NO;
//        if(code==8810000 || code==884000){
//            isContinueLogin = YES;
//        }
//
//        /* 超过重连次数，或者在后台，或者网络未连接 */
//        if(self.connectfailurecount>CONNECTFAILURECOUNTMAX
//           || [[UIApplication sharedApplication] applicationState] != UIApplicationStateActive
//           || ![LZUserDataManager readIsConnectNetWork]
//           || !isContinueLogin){
//
//            /* 记录日志，跟踪20161213，收到已读，数量减一 */
//            NSString *errorTitle = [NSString stringWithFormat:@"16--2"];
//            [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[NSString stringWithFormat:@"MessageRootVC---LZConnection_Login_Failure-----%d",code] errortype:Error_Type_Five];
//
//            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//            [data setObject:LZConnection_Login_Failure forKey:@"type"];
//            [data setObject:  [NSString stringWithFormat:@"%d",code] forKey:@"code"];
//            [data setObject:error forKey:@"error"];
//
//            EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//
//            /* 消息页（联网且不再后台时且非密码错误），一直自动重连 */
//            if([LZUserDataManager readIsLoginBefore]
//               && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive
//               && [LZUserDataManager readIsConnectNetWork]
//               && isContinueLogin){
//                //自动重链
//                [service loginRestartForConnectionFailure];
//            }
//        } else {
//
//            //自动重链
//            [service loginRestartForConnectionFailure];
//        }
//
//    }];
//
//    if(!isHaveGetToken){
//        [self.lzconnection cancel];
//
//        [self.lzlogin initLogin];
//
//        /* 开始登录 */
//        [self.lzlogin login:server loginName:loginName password:password];
//    }
//    else {
//        [self.lzlogin loginWithLoginName:loginName password:password];
//    }
//
//    //开始登录
//    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//    [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//    [data setObject:LZConnection_Login_NetWorkStatus_Connecting forKey:@"status"];
//
//    EVENT_PUBLISH_WITHDATA(self, EventBus_ConnectHandle, data);
//}

#pragma mark - 第三方登录
//-(void)loginThirdAppForClick:(NSString *)server apptype:(NSString *)appType openid:(NSString*)openid otherData:(NSDictionary *)otherData
//{
//    self.connectfailurecount = 0;
//    self.loginRestartGUID = @"";
//    _isLoginFromLoginVC = YES;
//
//    /* 超时处理 */
//    NSString *loginGUID = [LZUtils CreateGUID];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.lzGlobalVariable.loginGUID = loginGUID;
//    [self performSelector:@selector(logingOutOfTime:) withObject:loginGUID afterDelay:180];
//
//    /* 开始登录 */
//    [self loginStartThirdApp:server apptype:appType openidOrRefreshToken:openid isHaveGetToken:YES otherData:otherData];
//}
//
//-(void)loginThirdAppForRefreshToken:(NSString *)server apptype:(NSString *)appType refreshtoken:(NSString*)refreshtoken
//{
//    [self loginStartThirdApp:server apptype:appType openidOrRefreshToken:refreshtoken isHaveGetToken:NO otherData:nil];
//}

//-(void)loginStartThirdApp:(NSString *)server apptype:(NSString *)appType openidOrRefreshToken:(NSString*)openidOrRefreshToken isHaveGetToken:(BOOL)isHaveGetToken otherData:(NSDictionary *)otherData
//{
//    if(!isHaveGetToken){
//        if(self.lzlogin == nil)
//        {
//            self.lzlogin = [[LZLogin alloc] initWithStart];
//        }
//
//        //当前不是登录中
//        if(self.lzlogin.loginning == YES)
//        {
//            return;
//        }
//        //登录中
//        self.lzlogin.loginning = YES;
//    }
//
//    __block LZService * service = self;
//
//    /* 设置成功事件 */
//    [self.lzlogin setSuccessHandler:^(NSString * tokenId,NSMutableDictionary *backDatainfo){
//
//        NSString *loginGUID = [LZUtils CreateGUID];
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        appDelegate.lzGlobalVariable.loginGUID = loginGUID;
//
//        service.tokenId = tokenId;
//
//        NSInteger isbind = [backDatainfo lzNSNumberForKey:@"isbind"].integerValue;
//
//        //判断是否为绑定手机号
//        bool isBindPhone = NO;
//        if(otherData!=nil){
//            NSString *loginStep = [otherData lzNSStringForKey:@"step"];
//            if([loginStep isEqualToString:Login_Step_Second_BindPhone]){
//                isBindPhone = YES;
//            }
//        }
//
//        if(isbind==1 || isBindPhone){
//            /* 发送通知，TokenID */
//            NSMutableDictionary *loginSuccessData = [[NSMutableDictionary alloc] init];
//            [loginSuccessData setValue:tokenId forKey:@"tokenid"];
//            EVENT_PUBLISH_WITHDATA(service, EventBus_LoginWebSuccess, loginSuccessData);
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            if(appDelegate.lzGlobalVariable.lzLoginWebSuccess){
//                appDelegate.lzGlobalVariable.lzLoginWebSuccess(tokenId);
//                appDelegate.lzGlobalVariable.lzLoginWebSuccess = nil;
//            }
//
//            /* 解析数据 */
//            NSString *refreshToken = [backDatainfo lzNSStringForKey:@"refresh_token"];
//            NSDictionary *userinfo = [backDatainfo lzNSDictonaryForKey:@"signinfo"];
//            NSString *mobile = [userinfo lzNSStringForKey:@"mobile"];
//
//            //登录成功记录信息
//            [LZUserDataManager saveServer:server];
//            [LZUserDataManager saveLoginType:appType];
//            [LZUserDataManager saveThirdAppRefreshToken:refreshToken];
//            if(![NSString isNullOrEmpty:mobile]){
//                [LZUserDataManager saveUserLoginName:mobile];
//            }
//
//            /* 保存当前用户信息 */
//            NSMutableDictionary *userinfoCopy = [[NSMutableDictionary alloc] init];
//            for (NSString *key in [userinfo allKeys]) {
//                [userinfoCopy setObject:[userinfo objectForKey:key] forKey:key];
//            }
//
//            /* 处理selectoid 为空的情况 */
//            NSString *notification = [userinfo objectForKey:@"notificaton"];
//            if(![NSString isNullOrEmpty:notification]){
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[notification seriaToDic]];
//                NSNumber *identitytypeNum = [dic lzNSNumberForKey:@"identitytype"];
//                NSString *identitytype = [NSString stringWithFormat:@"%@",identitytypeNum];
//                if([identitytype isEqualToString:@"1"]){
//                    [dic setValue:[userinfo lzNSStringForKey:@"uid"] forKey:@"selectoid"];
//                }
//                if( [dic objectForKey:@"selectoid"] == [NSNull null]){
//                    /* 处理新用户第一次注册登录时，创建组织后 默认进入创建的组织  dfl 2016-04-21 */
//                    NSMutableArray *orgbyuser=[userinfo objectForKey:@"orgsbyuser"];
//                    NSMutableDictionary *orgdic=[orgbyuser firstObject];
//                    if(orgbyuser.count==0){
//                        /* 没有创建组织时，默认进入己方 */
//                        [dic setValue:[userinfo lzNSStringForKey:@"uid"] forKey:@"selectoid"];
//                    }else{
//                        [dic setValue:[orgdic lzNSStringForKey:@"oid"] forKey:@"selectoid"];
//                    }
//
//                }
//
//                NSDictionary *loginsecurity = [dic lzNSDictonaryForKey:@"loginsecurity"];
//                NSNumber *isphonevalidNum = [loginsecurity lzNSNumberForKey:@"isphonevalid"];
//                /* 记录是否开启登录安全校验 */
//                [LZUserDataManager saveIsPhoneValid:isphonevalidNum.intValue==1];
//
//                [userinfoCopy setObject:dic forKey:@"notificaton"];
//            } else {
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                [dic setValue:[userinfo lzNSStringForKey:@"uid"] forKey:@"selectoid"];
//                [userinfoCopy setObject:dic forKey:@"notificaton"];
//            }
//
//            /* 记录上一用户的uid */
//            NSString *preUid = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
//            if([NSString isNullOrEmpty:preUid]){
//                preUid = @"";
//            }
//            [userinfoCopy setObject:preUid forKey:@"preuid"];
//
//            /* 处理orgsbyuser 中属性为空的情况 */
//            [LZUserDataManager saveCurrentUserInfo:userinfoCopy];
//
//            /* 判断当前用户是否为灰度用户 */
//            NSNumber *gayScaleNum = [userinfoCopy lzNSNumberForKey:@"gayscale"];
//            [LZUserDataManager saveIsGayScaleUser:gayScaleNum.intValue==1];
//
//            if(isbind==1){
//                DataAccessMain *daMain = [[DataAccessMain alloc] init];
//                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                [dic setObject:[AppUtils GetCurrentUserID] forKey:@"uid"];
//                [dic setObject: [NSNumber numberWithBool:[daMain checkIsCreatedDB]] forKey:@"iscreateddb"];
//                [LZUserDataManager saveIsFirstLaunch:dic];
//
//                NSString *isContinueLoginIM = @"1";
//                if(service.isLoginFromLoginVC){
//                    //            isContinueLoginIM = @"0";
//                }
//
//                //开始登录
//                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//                [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//                [data setObject:LZConnection_Login_NetWorkStatus_NamePwdRight forKey:@"status"];
//                [data setObject:isContinueLoginIM forKey:@"iscontinueloginim"];
//
//                EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//
//                if([isContinueLoginIM isEqualToString:@"1"]){
//                    /* 登录消息服务器 */
//                    //            [service loginToIMServer];
//                    [service performSelector:@selector(loginToIMServer) withObject:nil afterDelay:0.1];
//                }
//            } else {
//                //开始登录
//                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//                [data setObject:EventBus_LoginThirdApp_NoReg forKey:@"type"];
//                [data setObject:backDatainfo forKey:@"userinfo"];
//
//                EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectThirdApp, data);
//            }
//        } else {
//            //开始登录
//            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//            [data setObject:EventBus_LoginThirdApp_NoReg forKey:@"type"];
//            [data setObject:backDatainfo forKey:@"userinfo"];
////            [data setObject:LZConnection_Login_NetWorkStatus_NamePwdRight forKey:@"status"];
////            [data setObject:isContinueLoginIM forKey:@"iscontinueloginim"];
//
//            EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectThirdApp, data);
//        }
//
//    } ];
//
//    /* 设置失败事件 */
//    [self.lzlogin setFailureHandler:^(int code, NSString *error) {
//
//        NSString *loginGUID = [LZUtils CreateGUID];
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        appDelegate.lzGlobalVariable.loginGUID = loginGUID;
//
//        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//        [data setObject:EventBus_LoginThirdApp_Error forKey:@"type"];
//        [data setObject:error forKey:@"error"];
//        [data setObject:[NSString stringWithFormat:@"%d",code] forKey:@"code"];
//
//        EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectThirdApp, data);
//
////        /* 密码错误时，不再重试 */
////        BOOL isContinueLogin = NO;
////        if(code==8810000 || code==884000){
////            isContinueLogin = YES;
////        }
////
////        /* 超过重连次数，或者在后台，或者网络未连接 */
////        if(self.connectfailurecount>CONNECTFAILURECOUNTMAX
////           || [[UIApplication sharedApplication] applicationState] != UIApplicationStateActive
////           || ![LZUserDataManager readIsConnectNetWork]
////           || !isContinueLogin){
////
////            /* 记录日志，跟踪20161213，收到已读，数量减一 */
////            NSString *errorTitle = [NSString stringWithFormat:@"16--2"];
////            [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[NSString stringWithFormat:@"MessageRootVC---LZConnection_Login_Failure-----%d",code] errortype:Error_Type_Five];
////
////            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
////            [data setObject:LZConnection_Login_Failure forKey:@"type"];
////            [data setObject:  [NSString stringWithFormat:@"%d",code] forKey:@"code"];
////            [data setObject:error forKey:@"error"];
////
////            EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
////
////            /* 消息页（联网且不再后台时且非密码错误），一直自动重连 */
////            if([LZUserDataManager readIsLoginBefore]
////               && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive
////               && [LZUserDataManager readIsConnectNetWork]
////               && isContinueLogin){
////                //自动重链
////                [service loginRestartForConnectionFailure];
////            }
////        } else {
////
////            //自动重链
////            [service loginRestartForConnectionFailure];
////        }
//
//    }];
//
//    if(!isHaveGetToken){
//        [self.lzconnection cancel];
//
//        [self.lzlogin initLogin];
//
//        /* 开始登录 */
//        [self.lzlogin loginThirdAppWithServer:server appType:appType refreshToken:openidOrRefreshToken];
//    }
//    else {
////        [self.lzlogin loginWithLoginName:loginName password:password];
//        [self.lzlogin loginWithAppType:appType code:openidOrRefreshToken otherData:otherData];
//    }
//
//    //开始登录
//    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//    [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//    [data setObject:LZConnection_Login_NetWorkStatus_Connecting forKey:@"status"];
//
//    EVENT_PUBLISH_WITHDATA(self, EventBus_ConnectHandle, data);
//}
//
////注册成功之后，登录消息服务器
//-(void)loginIMForThirdApp{
//    DataAccessMain *daMain = [[DataAccessMain alloc] init];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:[AppUtils GetCurrentUserID] forKey:@"uid"];
//    [dic setObject: [NSNumber numberWithBool:[daMain checkIsCreatedDB]] forKey:@"iscreateddb"];
//    [LZUserDataManager saveIsFirstLaunch:dic];
//
//    __block LZService * service = self;
//
//    NSString *isContinueLoginIM = @"1";
//    if(service.isLoginFromLoginVC){
//        //            isContinueLoginIM = @"0";
//    }
//
//    //开始登录
//    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//    [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
//    [data setObject:LZConnection_Login_NetWorkStatus_NamePwdRight forKey:@"status"];
//    [data setObject:isContinueLoginIM forKey:@"iscontinueloginim"];
//
//    EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
//
//    if([isContinueLoginIM isEqualToString:@"1"]){
//        /* 登录消息服务器 */
//        //            [service loginToIMServer];
//        [service performSelector:@selector(loginToIMServer) withObject:nil afterDelay:0.1];
//    }
//}

#pragma mark - 请求数据(非队列模式)

/**
 *  以Get模式调用WebApi
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param getData         get请求的数据
 *  @param data            其它数据
 */
-(void)sendToServerForGet:(NSString *)webApiControler
                routePath:(NSString *)routePath
             moduleServer:(NSString *)moduleServer
                  getData:(NSDictionary *)getData
                otherData:(NSDictionary *)data
{
    [self sendToServer:webApiControler routePath:routePath moduleServer:moduleServer httpMethod:@"get" getData:getData postData:nil otherData:data];
}

/**
 *  以Post模式调用WebApi
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param getData         get请求的数据
 *  @param postData        Post传递的数据
 *  @param data            其它数据
 */
-(void)sendToServerForPost:(NSString *)webApiControler
                routePath:(NSString *)routePath
             moduleServer:(NSString *)moduleServer
                  getData:(NSDictionary *)getData
                 postData:(id)postData
                otherData:(NSDictionary *)data
{
    [self sendToServer:webApiControler routePath:routePath moduleServer:moduleServer httpMethod:@"post" getData:getData postData:postData otherData:data];
}

/**
 *  调用WebApi(私有方法)
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param httpMethod      请求方式：Get，Post
 *  @param getData         get请求的数据
 *  @param postData        post请求时的数据
 *  @param otherData            其它数据
 */
-(void)sendToServer:(NSString *)webApiControler
                routePath:(NSString *)routePath
             moduleServer:(NSString *)moduleServer
               httpMethod:(NSString *)httpMethod
                  getData:(NSDictionary *)getData
                 postData:(id)postData
                otherData:(id)otherData
{
    NSMutableDictionary *sendDataDic = [self makeDataToDic:webApiControler
                                                 routePath:routePath
                                              moduleServer:moduleServer
                                                httpMethod:httpMethod
                                                   getData:getData
                                                  postData:postData
                                                 otherData:otherData];
    if(self.lzconnection==NULL){
        NSString *showErrorType = [[sendDataDic lzNSDictonaryForKey:WebApi_DataSend_Other] lzNSStringForKey:WebApi_DataSend_Other_ShowError];
        if(![showErrorType isEqualToString:WebApi_DataSend_Other_SE_NotShowAll]){
            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
            [dataDic setObject:@{@"Code":@"0",@"Message":LZGDCommonLocailzableString(@"common_network_link_fail")} forKey:WebApi_ErrorCode];
            if(postData!=nil){
                [dataDic setObject:postData forKey:WebApi_DataSend_Post];
            }
            if(getData!=nil){
                [dataDic setObject:getData forKey:WebApi_DataSend_Get];
            }
            if(otherData!=nil){
                [dataDic setObject:otherData forKey:WebApi_DataSend_Other];
            }
            [dataDic setObject:webApiControler forKey:WebApi_Controller];
            [dataDic setObject:routePath forKey:WebApi_Route];
            
            __block LZService * service = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, dataDic);
            });
        }
    }
    [self.lzconnection sendToServer:sendDataDic];
}

#pragma mark - 请求数据(队列模式)

/**
 *  以Get队列模式调用WebApi
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param getData         get请求的数据
 *  @param data            其它数据
 */
-(void)sendToServerQueueForGet:(NSString *)webApiControler
                     routePath:(NSString *)routePath
                  moduleServer:(NSString *)moduleServer
                       getData:(NSDictionary *)getData
                     otherData:(NSDictionary *)data
{
    [self sendToServerQueue:webApiControler routePath:routePath moduleServer:moduleServer httpMethod:@"get" getData:getData postData:nil otherData:data];
}

/**
 *  以Post队列模式调用WebApi
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param getData         get请求的数据
 *  @param postData        Post传递的数据
 *  @param data            其它数据
 */
-(void)sendToServerQueueForPost:(NSString *)webApiControler
                      routePath:(NSString *)routePath
                   moduleServer:(NSString *)moduleServer
                        getData:(NSDictionary *)getData
                       postData:(id)postData
                      otherData:(NSDictionary *)data
{
    [self sendToServerQueue:webApiControler routePath:routePath moduleServer:moduleServer httpMethod:@"post" getData:getData postData:postData otherData:data];
}

/**
 *  调用WebApi(私有方法)
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param httpMethod      请求方式：Get，Post
 *  @param getData         get请求的数据
 *  @param postData        post请求时的数据
 *  @param otherData            其它数据
 */
-(void)sendToServerQueue:(NSString *)webApiControler
               routePath:(NSString *)routePath
            moduleServer:(NSString *)moduleServer
              httpMethod:(NSString *)httpMethod
                 getData:(NSDictionary *)getData
                postData:(id)postData
               otherData:(id)otherData
{
    NSMutableDictionary *sendDataDic = [self makeDataToDic:webApiControler
                                                 routePath:routePath
                                              moduleServer:moduleServer
                                                httpMethod:httpMethod
                                                   getData:getData
                                                  postData:postData
                                                 otherData:otherData];
    if(self.lzconnection==NULL){
        NSString *showErrorType = [[sendDataDic lzNSDictonaryForKey:WebApi_DataSend_Other] lzNSStringForKey:WebApi_DataSend_Other_ShowError];
        if(![showErrorType isEqualToString:WebApi_DataSend_Other_SE_NotShowAll]){
            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
            [dataDic setObject:@{@"Code":@"0",@"Message":LZGDCommonLocailzableString(@"common_network_link_fail")} forKey:WebApi_ErrorCode];
            if(postData!=nil){
                [dataDic setObject:postData forKey:WebApi_DataSend_Post];
            }
            if(getData!=nil){
                [dataDic setObject:getData forKey:WebApi_DataSend_Get];
            }
            if(otherData!=nil){
                [dataDic setObject:otherData forKey:WebApi_DataSend_Other];
            }
            [dataDic setObject:webApiControler forKey:WebApi_Controller];
            [dataDic setObject:routePath forKey:WebApi_Route];
            
            __block LZService * service = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, dataDic);
            });
        }
    }
    [self.lzconnection sendToServerQueue:sendDataDic];
}


#pragma mark - 未登录，请求数据(非队列模式)

/**
 *  以Get模式调用WebApi
 *
 *  @param webApiControler WebApi所在Controller
 *  @param routePath       WebApi的路由
 *  @param moduleServer    模块服务器
 *  @param getData         get请求的数据
 *  @param data            其它数据
 */
//-(void)noLoginSendToServerForGet:(NSString *)webApiControler
//                routePath:(NSString *)routePath
//             moduleServer:(NSString *)moduleServer
//                  getData:(NSDictionary *)getData
//                otherData:(NSDictionary *)data
//{
//
//    NSMutableDictionary *sendDataDic = [self makeDataToDic:webApiControler
//                                                 routePath:routePath
//                                              moduleServer:moduleServer
//                                                httpMethod:@"get"
//                                                   getData:getData
//                                                  postData:nil
//                                                 otherData:data];
////    [self.lzlogin sendToServer:sendDataDic];
//}
//
///**
// *  以Post模式调用WebApi
// *
// *  @param webApiControler WebApi所在Controller
// *  @param routePath       WebApi的路由
// *  @param moduleServer    模块服务器
// *  @param getData         get请求的数据
// *  @param postData        Post传递的数据
// *  @param data            其它数据
// */
//-(void)noLoginSendToServerForPost:(NSString *)webApiControler
//                 routePath:(NSString *)routePath
//              moduleServer:(NSString *)moduleServer
//                   getData:(NSDictionary *)getData
//                  postData:(id)postData
//                 otherData:(NSDictionary *)data
//{
//    NSMutableDictionary *sendDataDic = [self makeDataToDic:webApiControler
//                                                 routePath:routePath
//                                              moduleServer:moduleServer
//                                                httpMethod:@"post"
//                                                   getData:getData
//                                                  postData:postData
//                                                 otherData:data];
//    [self.lzlogin sendToServer:sendDataDic];
//}

#pragma mark - Private Function

/**
 *  将数据组织成字典(私有方法)
 *  @return 字典
 */
-(NSMutableDictionary *)makeDataToDic:(NSString *)webApiControler
          routePath:(NSString *)routePath
       moduleServer:(NSString *)moduleServer
         httpMethod:(NSString *)httpMethod
           getData:(NSDictionary *)getData
           postData:(id)postData
          otherData:(id)otherData
{
    NSMutableDictionary *sendDataDic = [[NSMutableDictionary alloc] init];
    /* Controller */
    [sendDataDic setObject:webApiControler forKey:@"webapicontroller"];
    /* Route */
    [sendDataDic setObject:routePath forKey:@"routepath"];
    /* Get或Post模式 */
    if(httpMethod!=nil && [[httpMethod lowercaseString] isEqualToString:@"post"]){
        [sendDataDic setObject:httpMethod forKey:@"httpmethod"];
    }
    /* Get模式时，传递的数据 */
    if(getData!=nil){
        [sendDataDic setObject:getData forKey:@"getdata"];
    }
    /* Post模式时，传递的数据 */
    if(postData!=nil){
        [sendDataDic setObject:postData forKey:@"postdata"];
    }
    /* 服务器 */
    if(moduleServer!=nil){
        [sendDataDic setObject:moduleServer forKey:@"moduleserver"];
    }/* 其它数据 */
    if(otherData != nil){
        [sendDataDic setObject:otherData forKey:@"otherdata"];
    }
    
    return sendDataDic;
}

#pragma mark - 消息队列处理

/**
 *  处理发送时就已经断网，或发送过程中断网的情况
 */
-(void)resendAfterLastMsgSend:(id)obj{
    if([NSString isNullOrEmpty:_longPoolIsRuning]){
        DDLogVerbose(@"开始使用断网后的处理");
//        [self resendFailedMsgQueue:60];
        
        //获取失败的消息，将状态更改为发送中，重新调用发送接口
        NSMutableArray *failedMsgQueue = [[ImMsgQueueDAL shareInstance] getMessageWithModule:Modules_Message];
        for(int i=0;i<[failedMsgQueue count];i++){
            ImMsgQueueModel *imMsgQueueModel = [failedMsgQueue objectAtIndex:i];
            if ([imMsgQueueModel.route isEqualToString:WebApi_Message_DeleteMsg]) {
                /* 删除失败的消息，重新删除 */
                NSArray *dataArr = [imMsgQueueModel.data componentsSeparatedByString:@","];
                NSString *dialogid = [dataArr lastObject];
                NSString *msgid = [dataArr firstObject];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_DeleteMsg moduleServer:Modules_Message getData:@{@"container":dialogid} postData:@[msgid] otherData:nil];
            } else {
                NSString *mqid = imMsgQueueModel.mqid;
                NSDate *createdatetime = imMsgQueueModel.createdatetime;
                
                //若失败时间超过5分钟，则认定发送失败，使用循环主要是为了能够按发送时间先后一次标识为失败状态
                NSInteger intervalSeconds = [AppDateUtil IntervalSeconds:createdatetime endDate:[AppDateUtil GetCurrentDate]];
                if(intervalSeconds>=60){
                    //删除队列中的数据
                    [[ImMsgQueueDAL shareInstance] deleteImMsgQueueWithMqid:mqid];

                    ImChatLogModel *chatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:nil orClienttempid:mqid];
                    
                    //数据库中更改为失败状态
                    [[ImChatLogDAL shareInstance] updateSendStatusWithClientTempId:mqid withSendstatus:Chat_Msg_SendFail];
                    
                    //通知界面
                    EVENT_PUBLISH_WITHDATA(self, EventBus_Chat_UpdateSendStatus, chatLogModel);
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                    /* 刷新消息页面 */
                    if(chatLogModel.imClmBodyModel.parsetype==0){
                        appDelegate.lzGlobalVariable.chatDialogID = chatLogModel.dialogid;
                        appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
                    } else {
                        /* 刷新二级消息页面 */
                        NSString *strToType = [NSString stringWithFormat:@"%ld",chatLogModel.totype];
                        EVENT_PUBLISH_WITHDATA(self, EventBus_Chat_RefreshSecondMsgVC, strToType );
                        
                        /* 刷新消息页面 */
                        chatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:nil orClienttempid:[mqid stringByAppendingString:@"_First"]];
                        appDelegate.lzGlobalVariable.chatDialogID = chatLogModel.dialogid;
                        appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
                    }
                    
                    
                    
                }
            }
        }
    }
}

/**
 *  重新发送消息队列中的失败数据
 */
-(void)resendFailedMsgQueue:(NSInteger)outTime{
    DDLogVerbose(@"开始使用连网时的重发");
    
    /* 不再执行 resendAfterLastMsgSend */
    _longPoolIsRuning = @"1";
    
    //获取失败的消息，将状态更改为发送中，重新调用发送接口
    NSMutableArray *failedMsgQueue = [[ImMsgQueueDAL shareInstance] getMessageWithModule:Modules_Message];
    for(int i=0;i<[failedMsgQueue count];i++){
        ImMsgQueueModel *imMsgQueueModel = [failedMsgQueue objectAtIndex:i];
        if ([imMsgQueueModel.route isEqualToString:WebApi_Message_DeleteMsg]) {
            /* 删除失败的消息，重新删除 */
            NSArray *dataArr = [imMsgQueueModel.data componentsSeparatedByString:@","];
            NSString *dialogid = [dataArr lastObject];
            NSString *msgid = [dataArr firstObject];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_DeleteMsg moduleServer:Modules_Message getData:@{@"container":dialogid} postData:@[msgid] otherData:nil];
        } else {
            NSString *mqid = imMsgQueueModel.mqid;
            NSDate *createdatetime = imMsgQueueModel.createdatetime;
            NSDate *updatedatetime = imMsgQueueModel.updatedatetime;
            NSString *data = imMsgQueueModel.data;
            
            /* 若为发送中的消息，且时间间隔小于1分钟，说明正在发送此消息，则不进行处理(服务器没给返回失败的情况下回调用) */
            if(imMsgQueueModel.status == Message_Queue_Sending){
                if([AppDateUtil IntervalSeconds:updatedatetime endDate:[AppDateUtil GetCurrentDate]]<60){
                    continue;
                }
            }
            
            DDLogVerbose(@"开始重新发送数据");
            
            //若失败时间超过5分钟，则认定发送失败
            ImChatLogModel *chatLogModel = nil;
            NSInteger intervalSeconds = [AppDateUtil IntervalSeconds:createdatetime endDate:[AppDateUtil GetCurrentDate]];
            if(intervalSeconds>=outTime){
                //删除队列中的数据
                [[ImMsgQueueDAL shareInstance] deleteImMsgQueueWithMqid:mqid];
                
                chatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:nil orClienttempid:mqid];
                
                //数据库中更改为失败状态
                [[ImChatLogDAL shareInstance] updateSendStatusWithClientTempId:mqid withSendstatus:Chat_Msg_SendFail];
                
                //通知界面
                EVENT_PUBLISH_WITHDATA(self, EventBus_Chat_UpdateSendStatus, chatLogModel);
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                /* 刷新消息页面 */
                if(chatLogModel.imClmBodyModel.parsetype==0){
                    appDelegate.lzGlobalVariable.chatDialogID = chatLogModel.dialogid;
                    appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
                } else {
                    /* 刷新二级消息页面 */
                    NSString *strToType = [NSString stringWithFormat:@"%ld",chatLogModel.totype];
                    EVENT_PUBLISH_WITHDATA(self, EventBus_Chat_RefreshSecondMsgVC, strToType );
                    
                    /* 刷新消息页面 */
                    chatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:nil orClienttempid:[mqid stringByAppendingString:@"_First"]];
                    appDelegate.lzGlobalVariable.chatDialogID = chatLogModel.dialogid;
                    appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
                }
                
                continue;
            }
            
            /* 否则重新发送 */
            // 消息状态更改为发送中
            [[ImMsgQueueDAL shareInstance] updateStatusWithMqid:mqid status:Message_Queue_Sending];
            
            NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dataDic1 = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&err];
            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:dataDic1];
            
            NSDate *currentDate = [AppDateUtil GetCurrentDate];
            NSString *currentDateStr = [LZFormat Date2String:currentDate];
            /* 重新发送时，更新ChatLog中的时间和dataDic中的时间 */
            [dataDic setObject:currentDateStr forKey:@"senddatetime"];
            if(chatLogModel==nil){
                chatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:nil orClienttempid:mqid];
            }
            NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] initWithDictionary:[chatLogModel.body seriaToDic]];
            [[ImChatLogDAL shareInstance] updateMsgSendDateTimeWithShowindexDate:currentDate body:[bodyDic dicSerial] msgid:chatLogModel.msgid orClienttempid:chatLogModel.clienttempid];
            
            /* 更新一级消息发送时间 */
            if(chatLogModel.imClmBodyModel.parsetype!=0){

                chatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:nil orClienttempid:[mqid stringByAppendingString:@"_First"]];                
                [[ImChatLogDAL shareInstance] updateMsgSendDateTimeWithShowindexDate:currentDate body:[bodyDic dicSerial] msgid:chatLogModel.msgid orClienttempid:chatLogModel.clienttempid];
            }
            
            NSString *chatMsgType = [dataDic1 objectForKey:@"handlertype"];
            /* 发送文本 */
            if([chatMsgType hasSuffix:Handler_Message_LZChat_LZMsgNormal_Text]){
                NSString *content = [dataDic1 lzNSStringForKey:@"content"];
                [dataDic setValue:[[LZUtils escape:content] base64EncodedString] forKey:@"content"];
                [dataDic setValue:@"base64" forKey:@"Encode"];
            }
            
            [self.lzconnection send:dataDic];
        }
    }
    
    //云盘文件，若停止则继续上传
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSMutableDictionary *netDiskViewControllerDic = appDelegate.lzSingleInstance.netDiskDictionary;
//    for(id key in [netDiskViewControllerDic allKeys]){
//        AppNetDiskMyFileViewController2 *netVC = (AppNetDiskMyFileViewController2 *)[netDiskViewControllerDic objectForKey:key];
//        [netVC checkIsNeedStart];
//    }
    
    
    //若失败时间超过5分钟，则认定发送失败
    NSMutableArray *modules = [[ImMsgQueueDAL shareInstance] getMessageWithModule:Modules_Message_Receipt];
    for (ImMsgQueueModel *model in modules) {
        
        NSDate *updatedatetime = model.updatedatetime;
    
        NSInteger intervalSeconds = [AppDateUtil IntervalSeconds:updatedatetime endDate:[AppDateUtil GetCurrentDate]];
        if(intervalSeconds>=outTime){
            
            [[ImMsgQueueDAL shareInstance] updateStatusWithMqid:model.mqid status:1];
            
            NSMutableArray *msgids = [NSMutableArray array];
            [msgids addObject:model.data];
            NSInteger otherNoReadCount = [[ImRecentDAL shareInstance] getImRecentNoReadMsgCount];
            /* 发送消息回执 */
            NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
            [getData setObject:@"2" forKey:@"type"];
            [getData setObject:[NSString stringWithFormat:@"%ld",(long)otherNoReadCount] forKey:@"badge"];
//            [appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_Report moduleServer:Modules_Message getData:getData postData:msgids otherData:@{WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll}];
        }
    }
}

/**
 *  将发送中的消息更改为失败状态
 */
-(void)resetSendingMsgToFail{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[ImChatLogDAL shareInstance] updateSendingStatusToFail];
        [[ImMsgQueueDAL shareInstance] deleteImMsgQueueWithModule:Modules_Message];
    });
}

/**
 *  发送过程中断网
 */
-(void)resendAfterNetWorkIsDisconnect{
    _longPoolIsRuning = @"";
    [self performSelector:@selector(resendAfterLastMsgSend:) withObject:nil afterDelay:60];
}

@end
