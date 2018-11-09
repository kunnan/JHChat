//
//  LZLoginDataSend.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/26.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-26
 Version: 1.0
 Description: 完成登录后需要发送的请求
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZLoginDataSend.h"
#import "NSString+IsNullOrEmpty.h"
#import "XHHTTPClient.h"
#import "ModuleServerUtil.h"
#import "CoTransactionTypeDAL.h"
#import "AppTempDAL.h"
#import "LZUserDataManager.h"
#import "AppDateUtil.h"
#import "ImRecentDAL.h"
#import "AliyunViewModel.h"
#import "RemotelyServerModel.h"
#import "RemotelyAccountModel.h"
#import "CommonTemplateTypeDAL.h"
#import "ErrorDAL.h"
#import "LCProgressHUD.h"
#import "NSDictionary+DicSerial.h"
#import "SysApiVersionDAL.h"
#import "SysApiVersionViewModel.h"
#import "ImGroupDAL.h"
#import "ImMsgTemplateDAL.h"
#import "ImVersionTemplateDAL.h"
#import "AliyunRemotrlyServerDAL.h"
#import "CooperationpendingModel.h"


@implementation LZLoginDataSend

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(LZLoginDataSend *)shareInstance{
    static LZLoginDataSend *instance = nil;
    if (instance == nil) {
        instance = [[LZLoginDataSend alloc] init];
    }
    return instance;
}

/**
 *  发送登录时需要获取的数据api之前，获取webapi版本号
 */
-(void)sendForLoginData_Before{
    [LCProgressHUD sharedHideHUDForNotClickHide2].isNotShowStatus2 = NO;//处理加载数据进度框展现
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* 更改临时应用信息的状态值 */
        [[AppTempDAL shareInstance] updateAppTempType];
        
        /* 登录成功，直接进入主页面 */
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
        [data setObject:LZConnection_Login_NetWorkStatus_RecvFinish forKey:@"status"];
        dispatch_async(dispatch_get_main_queue(), ^{
            __block LZLoginDataSend * service = self;
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.lzGlobalVariable.isShowLoadingWhenLoginWebFromLoginVC = NO;
            EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
        });
        
        [self getWebApiVersion];
    });
    
//    //请求基础数据
//    [self sendForLoginData];
}

/**
 *  获取WebApi版本
 */
-(void)getWebApiVersion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *server = [ModuleServerUtil GetServerWithModule:Modules_Default];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *apiServer=[NSString stringWithFormat:@"%@/%@",server,WebApi_System_ApiVersion];
            apiServer = [apiServer stringByReplacingOccurrencesOfString:@"{tokenid}" withString:self.appDelegate.lzservice.tokenId];
            
            NSDictionary *postData = @{@"uid":[AppUtils GetCurrentUserID],
                                       @"subordinate":@"plat"};

            [XHHTTPClient POSTPath:apiServer parameters:postData jsonSuccessHandler:^(LZURLConnection *connection, id json) {
                NSString *code = [[json lzNSDictonaryForKey:@"ErrorCode"] lzNSStringForKey:@"Code"];
                
                //记录日志
                NSString *errordata=[NSString stringWithFormat:@"post:\n%@\nresult:\n%@",[postData dicSerial],[self JSONUnicode2Utf8:json]];
                [[ErrorDAL shareInstance] addDataWithTitle:@"WebApi信息--获取WebApi版本" data:errordata errortype:0];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if([code isEqualToString:@"0"])
                    {
                        NSDictionary *datacontext = [json lzNSDictonaryForKey:@"DataContext"];
                        
                        NSMutableArray *versionArray = [[NSMutableArray alloc] init];
                        for(int i=0;i<[datacontext allKeys].count;i++){
                            NSString *keyCode = [datacontext allKeys][i];
                            NSString *keyValue = [datacontext lzNSStringForKey:keyCode];
                            
                            SysApiVersionModel *sysApiVersionModel = [[SysApiVersionModel alloc] init];
                            sysApiVersionModel.code = [keyCode lowercaseString];
                            sysApiVersionModel.type = 0;
                            sysApiVersionModel.server_version = keyValue;
                            
                            [versionArray addObject:sysApiVersionModel];
                        }
                        
                        //插入数据库
                        [[SysApiVersionDAL shareInstance] addDataWithSysApiVersionArray:versionArray];
                    }

                    DDLogVerbose(@"获取到的个人级webapi版本数据：%@",errordata);
                    //请求基础数据
                    [self sendForLoginData];
                });
                
            } failureHandler:^(LZURLConnection *connection, NSData *responseData, NSURLResponse *response, NSError *error) {
                //记录错误日志
                NSString *errordata=[NSString stringWithFormat:
                                     @"post:\n%@\nstatuscode:%ld\nerror:\n%@",
                                     [postData dicSerial],
                                     (long)((NSHTTPURLResponse*)response).statusCode,
                                     error];
                [[ErrorDAL shareInstance] addDataWithTitle:@"获取WebApi版本" data:errordata errortype:1];
                
                DDLogVerbose(@"获取到的个人级webapi版本数据：%@",errordata);
                //请求基础数据
                [self sendForLoginData];
            }];
        });
    });
}

/**
 *  发送登录时需要获取的数据api
 */
-(void)sendForLoginData{
   
    /* 判读是否超过7天未登录 */
    BOOL isNeedRequestData = YES;
    NSString *lastestLoginDate = [LZUserDataManager getLastestLoginDate];
    if(![NSString isNullOrEmpty:lastestLoginDate]){
        NSInteger days = [AppDateUtil IntervalDays:[LZFormat String2Date:lastestLoginDate] endDate:[AppDateUtil GetCurrentDate]];
        if(days<=7){
            isNeedRequestData = NO;
        }
    }
    [LZUserDataManager saveLastestLoginDate:[AppDateUtil GetCurrentDateForString]];
    
    /* 获取不需要请求的webapi */
    NSMutableArray *notRequestWebApi = [[[SysApiVersionViewModel alloc] init] getNotNeedRequestWebApiArr];
    [[ErrorDAL shareInstance] addDataWithTitle:@"WebApi信息--登录时不需要请求的webapi" data:[notRequestWebApi componentsJoinedByString:@","] errortype:0];
    
    NSDictionary *commonOtherData = @{WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll};
    
//    /* 更改临时应用信息的状态值 */
//    [[AppTempDAL shareInstance] updateAppTempType];
    
    /* 请求阿里云服务器 */
   AliyunViewModel *ailiyunmodel = [[AliyunViewModel alloc] init];
   RemotelyServerModel * aliyunServerModel = [[AliyunRemotrlyServerDAL shareInstance] getServerModelWithRfsType:@"oss"];
    if(![notRequestWebApi containsObject:LogoinWebApi_api_filemanager_getremotelyservermodelall_S3]){
        GetRemotelyServerInfo getServer = ^(NSArray *serverinfo) {
            NSLog(@"成功获取远程服务器");
            for (RemotelyServerModel *serverModel  in serverinfo) {
                // 阿里云服务器 [[dic objectForKey:@"activationstatus"] integerValue] == 1 && 只要有阿里云服务器就让请求账号信息
                if ([serverModel.rfstype isEqualToString:@"oss"]) {
                
                    GetRemotelyAccountModel getAcount = ^(RemotelyAccountModel *acountModel) {
                        NSLog(@"成功获取账号信息");
                    };
                    [[[AliyunViewModel alloc] init] sendApiGetRemotelyAcountModel:serverModel.rfsid getAcountBlock:getAcount];
                }
            }
        };
        AliyunViewModel *aliyunModel =[[AliyunViewModel alloc] init];
        [aliyunModel sendApiGetRemotelyServerAll:getServer];
    }
    else if (aliyunServerModel == nil || [ailiyunmodel aliyunAccountIsOverTime] ) {
        if (aliyunServerModel == nil) {
            [AliyunViewModel getAliyunServerInfo:^(RemotelyServerModel *server, RemotelyAccountModel *acountModel) {
                DDLogVerbose(@"阿里云账号为空，重新请求成功");
                
            }];
        }
        else {
            GetRemotelyAccountModel getAcount = ^(RemotelyAccountModel *acountModel) {
                NSLog(@"原账号过期===》》成功获取新的账号信息");
                
            };
            [[[AliyunViewModel alloc] init] sendApiGetRemotelyAcountModel:aliyunServerModel.rfsid getAcountBlock:getAcount];
        }
    }
    
    /* 获取消息模板的集合 */
    BOOL isVersionTemplateEmpty = NO;
    if([notRequestWebApi containsObject:LogoinWebApi_api_msgtemplate_gettemplate_S2]){
        NSInteger templateCount = [[ImVersionTemplateDAL shareInstance] getImVersionTemplateCount];
        isVersionTemplateEmpty = templateCount==0;
        if(isVersionTemplateEmpty){
            [[ErrorDAL shareInstance] addDataWithTitle:@"服务器消息模板数据未改变，但客户端数据未空" data:@"" errortype:Error_Type_Eighteen];
        }
    }
    if(isVersionTemplateEmpty || ![notRequestWebApi containsObject:LogoinWebApi_api_msgtemplate_gettemplate_S2]){
        [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_MsgTemplate
                                                  routePath:WebApi_MsgTemplate_GetTemplate
                                               moduleServer:Modules_Message
                                                    getData:nil
                                                  otherData:commonOtherData];
    } else {
        /* 待处理20170928 */
        NSArray<ImMsgTemplateModel *> *modelDataArr = [[ImMsgTemplateDAL shareInstance] getAllImMsgTemplateModel];
        NSString *codeStr = @"";
        for (ImMsgTemplateModel *imMsgTemplate in modelDataArr) {
            
            if (![NSString isNullOrEmpty:imMsgTemplate.templates]) {
                CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
                [model serialization:imMsgTemplate.templates];
                NSInteger templatetype = model.templatetype;
                if (templatetype == -1) {
                    codeStr = [codeStr stringByAppendingString:[NSString stringWithFormat:@"'%@',",imMsgTemplate.code]];
                }
            }
        }
        if (![NSString isNullOrEmpty:codeStr]) {
            /* 将字符串首尾的单引号去掉 */
            NSRange rang = {1,[codeStr length]-3};
            codeStr = [codeStr substringWithRange:rang];
        }
        /* 将不需要展示的模板保存起来 */
        [LZUserDataManager saveCodeStr:codeStr];
        
        /* 将tvidStr保存起来 */
        NSString *tvidStr = @"";
        NSArray<ImVersionTemplateModel *> *versionModelArr = [[ImVersionTemplateDAL shareInstance] getAllImVersionTemplateModel];
        for (ImVersionTemplateModel *imVersionTemplate in versionModelArr) {
            CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
            [model serialization:imVersionTemplate.templates];
            NSInteger templatetype = model.templatetype;
            if (templatetype == -1) {
                /* 处理类型为-1的情况，不需要显示 */
                tvidStr = [tvidStr stringByAppendingString:[NSString stringWithFormat:@",%@.",imVersionTemplate.tvid]];
            }
        }
        [LZUserDataManager saveTvidStr:tvidStr];
    }

    
    /* 设置默认企业 */
    if(self.appDelegate.lzGlobalVariable.isNeedSelectedOrg){
        self.appDelegate.lzGlobalVariable.isNeedSelectedOrg=NO;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LZUserDataManager readCurrentUserInfo]];
        NSMutableDictionary *notificaton = [dic lzNSMutableDictionaryForKey:@"notificaton"];
        NSString *selectoid=[notificaton lzNSStringForKey:@"selectoid"];
        NSString *uid=[dic lzNSStringForKey:@"uid"];
        NSMutableDictionary *postData=[NSMutableDictionary dictionary];
        [postData setObject:uid forKey:@"uid"];
        [postData setObject:selectoid forKey:@"selectoid"];
//
        [[self appDelegate].lzservice sendToServerQueueForPost:WebApi_CloudUser routePath:WebApi_CloudUser_Update_Selected_Org moduleServer:Modules_Default getData:nil postData:postData otherData:commonOtherData];
    }

    /* 发送客户端信息至服务器 */
    [[ErrorDAL shareInstance] addDataWithTitle:@"发送--LZLoginData--DeviceToken" data:[NSString stringWithFormat:@"DeviceToken---%@",[LZUserDataManager readDeviceToken]] errortype:Error_Type_Fifth];
    NSMutableDictionary *loginInfoDic = [[NSMutableDictionary alloc] init];
    [loginInfoDic setValue:[LZUserDataManager readDeviceToken] forKey:@"deviceid"];
    [loginInfoDic setValue:[NSString stringWithFormat:@"{\"umeng\":\"%@\"}",[LZUserDataManager readDeviceToken]] forKey:@"devicejson"];
    [loginInfoDic setValue:[[NSBundle mainBundle] bundleIdentifier] forKey:@"bundleid"];
    [loginInfoDic setValue:@"ios" forKey:@"devicetype"];
    [self.appDelegate.lzservice sendToServerQueueForPost:WebApi_Connect_SaveLoginInfo
                                               routePath:WebApi_Connect_SaveLoginInfo
                                            moduleServer:Modules_Message
                                                 getData:nil
                                                postData:loginInfoDic
                                               otherData:commonOtherData];
    
    if(isNeedRequestData || [[ImRecentDAL shareInstance] getImRecentMsgCount]==0){
        /* 获取最近联系人 */
        [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_Recent
                                                  routePath:WebApi_Recent_GetRecentData
                                               moduleServer:Modules_Message
                                                    getData:nil
                                                  otherData:commonOtherData];
    }

    /* 获取基础服务器配置 */
    if(![notRequestWebApi containsObject:LogoinWebApi_api_apiserver_getbaseserver_S1]){
        [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_ApiServer
                                                  routePath:WebApi_ApiServer_GetBaseServer
                                               moduleServer:Modules_Default
                                                    getData:nil
                                                  otherData:commonOtherData];
    }
    
    
    /* 获取我的好友 */
    if(![notRequestWebApi containsObject:LogoinWebApi_api_colleaguelist_getcolleagues_S4]){
        [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_Colleaguelist
                                                  routePath:WebApi_Colleaguelist_GetColleagues
                                               moduleServer:Modules_Default
                                                    getData:nil
                                                  otherData:commonOtherData];
    }
        
    /* 获取我的好友标签列表*/
    if(![notRequestWebApi containsObject:LogoinWebApi_api_colleaguelist_getcontactgroup_S5]){
        [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_Colleaguelist
                                                  routePath:WebApi_Colleaguelist_GetContactGroup
                                               moduleServer:Modules_Default
                                                    getData:nil
                                                  otherData:commonOtherData];
    }
    
    /* 获取我的好友标签关系信息*/
    if(![notRequestWebApi containsObject:LogoinWebApi_api_colleaguelist_getcontractlistwithtag_S6]){
        [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_Colleaguelist
                                                  routePath:WebApi_Colleaguelist_GetContractListWithTag
                                               moduleServer:Modules_Default
                                                    getData:nil
                                                  otherData:commonOtherData];
    }
    
    /* 获取我【常用联系人】*/
    if(![notRequestWebApi containsObject:LogoinWebApi_api_colleaguelist_ofencooperation_S7]){
        [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_Colleaguelist
                                                  routePath:WebApi_Colleaguelist_OfenCooperation
                                               moduleServer:Modules_Default
                                                    getData:nil
                                                  otherData:commonOtherData];
    }

    /* 获取所属组织 */
    if(![notRequestWebApi containsObject:LogoinWebApi_api_organization_getuserorgbyuidcontroller_S8]){
        [self.appDelegate.lzservice sendToServerQueueForPost:WebApi_Organization
                                                   routePath:WebApi_Organization_GetUserOrgByUisController
                                                moduleServer:Modules_Default
                                                     getData:nil
                                                    postData:nil
                                                   otherData:commonOtherData];
    }
    
    /* 获取群组数据 */
    if(![notRequestWebApi containsObject:LogoinWebApi_api_imgroup_getgrouplistbypages_S9]){
        NSMutableDictionary *imgroupDic = [[NSMutableDictionary alloc] init];
        [imgroupDic setObject:[NSString stringWithFormat:@"%ld",(long)ImGroup_Default_DownUserCount] forKey:@"pagesize"];
        [self.appDelegate.lzservice sendToServerQueueForPost:WebApi_ImGroup
                                                   routePath:WebApi_ImGroup_GetGroupListByPages
                                                moduleServer:Modules_Message
                                                     getData:nil
                                                    postData:imgroupDic
                                                   otherData:commonOtherData];
    } else {
        [[ImGroupDAL shareInstance] deleteAllShowGroupUser];
        /* 将不显示的群组更新为临时状态 */
        [[ImGroupDAL shareInstance] updateOtherGroupWithTempStatus];
    }
    
    /* 文件件服务器限制文档类型 */
    if(![notRequestWebApi containsObject:LogoinWebApi_api_fileserver_uploadfileexp_S10]){
        [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_FileCommon
                                             routePath:WebApi_FileUploadExp_LimitUpload
                                          moduleServer:Modules_File
                                               getData:nil
                                             otherData:commonOtherData];
    }
    
    /* 发送API，通过字段去取模板 */
    if(![notRequestWebApi containsObject:LogoinWebApi_api_cooperation_extendtype_getallconfig_S11]){
        [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_ImGroup
                                             routePath:WebApi_CooperationExtendtype_GetAllConfig
                                          moduleServer:Modules_Default
                                               getData:nil
                                             otherData:commonOtherData];
    }
    
    /* 我的资料 */
    if(![notRequestWebApi containsObject:LogoinWebApi_api_user_getusercenter_S13]){
        [[self appDelegate].lzservice sendToServerQueueForPost:WebApi_CloudUser routePath:WebApi_CloudUser_List moduleServer:Modules_Default getData:nil postData:[AppUtils GetCurrentUserID] otherData:commonOtherData];
    }
    
    /* 协作模板数据 */
    if(![notRequestWebApi containsObject:LogoinWebApi_api_template_gettemplatelist_1_S14]){
        [[self appDelegate].lzservice sendToServerQueueForGet:WebApi_CloudPost routePath:WebApi_CloudPostTempleList moduleServer:Modules_Default getData:nil otherData:commonOtherData];
    }
    
    if(![notRequestWebApi containsObject:LogoinWebApi_api_api_postv_getposttypelist_S15]){
        [[self appDelegate].lzservice sendToServerQueueForGet:WebApi_CloudPost routePath:WebApi_CloudGetPosttypeList moduleServer:Modules_Default getData:nil otherData:commonOtherData];
    }

    //[[self appDelegate].lzservice sendToServerForGet:WebApi_CloudCooperationPending routePath:WebApi_CloudCooperationPendingModelType moduleServer:Modules_Default getData:nil otherData:commonOtherData];
    [[CoTransactionTypeDAL shareInstance] deleteAllModel];
    
	[[CommonTemplateTypeDAL shareInstance] deleteAllData];
	
    
    //应用数据
    NSString *orgid;//组织ID
    NSMutableDictionary *orgData=[NSMutableDictionary dictionary];
    orgid=[[[LZUserDataManager readCurrentUserInfo] objectForKey:@"notificaton"] objectForKey:@"selectoid"];
    if([NSString isNullOrEmpty:orgid]){
        orgid=[[LZUserDataManager readCurrentUserInfo]objectForKey:@"uid"];
    }
    [orgData setObject:orgid forKey:@"orgid"];
    /*                    获取当前用户企业下的配置 */
    [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_CloudApp
                                              routePath:WebApi_CloudApp_GetPhoneUserOrgModel
                                           moduleServer:Modules_Default
                                                getData:orgData
                                              otherData:commonOtherData];
	
	[[CooperationpendingModel shareInstance] getPendingCountOrgid:orgid];
    /* 请求服务器配置相关 */
    NSString *serverUrl=[ModuleServerUtil GetServerWithModule:Modules_Default];
    NSString *urlString=[NSString stringWithFormat:@"%@/%@",serverUrl,WebApi_ApiServer_Available];
    [XHHTTPClient  GETPath: urlString
        jsonSuccessHandler:^(LZURLConnection *connection, id json) {
            
            NSDictionary *datacontext=[json lzNSDictonaryForKey:@"DataContext"];
            [LZUserDataManager saveAvailableDataContext:[NSMutableDictionary dictionaryWithDictionary:datacontext]];
            DDLogVerbose(@"--------%@",json);
            
        } failureHandler:^(LZURLConnection *connection, NSData *responseData, NSURLResponse *response, NSError *error) {
            if(connection.iscancel == YES) return;
            //            [LZUserDataManager saveRegistrable:@"0"];
            
            NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            dataString = [NSString stringWithFormat:@"%@",dataString];
            
            DDLogError(@"lzlogin getModulesServer error responseData:%@, error:%@",dataString,error);
        }];
    
    /* 获取支持消息的应用 */
    [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_CloudApp routePath:WebApi_App_GetMagApp moduleServer:Modules_Default getData:nil otherData:nil];
    
    if(![[AppUtils GetCurrentOrgID]isEqualToString:[AppUtils GetCurrentUserID]]){
        /* 从服务器端请求模板   企业的过期时间判断，true:未到期，false:到期 */
        WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
            NSNumber *dataContext = [dataDic lzNSNumberForKey:WebApi_DataContext];
            NSString *dataString = [NSString stringWithFormat:@"%@",dataContext];
            if([dataString isEqualToString:@"0"]){//切换到个人
                [UIAlertView alertViewWithMessage:@"当前企业授权已过期，已切换至个人身份!"];
                [[self appDelegate].lzservice sendToServerForGet:WebApi_CloudUser routePath:WebApi_CloudUser_SwitchPersonidenType moduleServer:Modules_Default getData:nil otherData:nil];
            }
        };
        NSDictionary *otherData = @{WebApi_DataSend_Other_BackBlock:backBlock,
                                    WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll,
                                    };
        /* 企业的过期时间判断，true:未到期，false:到期 */
        [self.appDelegate.lzservice sendToServerForGet:WebApi_Organization routePath:WebApi_Organization_EnterLic_DeadLineAuthCheck moduleServer:Modules_Default getData:@{@"oeid" : [AppUtils GetCurrentOrgID]} otherData:otherData];
    }
}

- (NSString*)JSONUnicode2Utf8:(NSDictionary *) unicodeJSONDic{
    if(unicodeJSONDic)
    {
        NSString * desc = [NSString stringWithCString:[[NSString stringWithFormat:@"%@",unicodeJSONDic] cStringUsingEncoding:NSUTF8StringEncoding]
                                             encoding:NSNonLossyASCIIStringEncoding];
        return desc;
    }
    else
        return @"";
}

@end
