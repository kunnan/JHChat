//
//  DataExchangeParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/27.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "DataExchangeParse.h"
#import "RecentParse.h"
#import "ColleaguelistParse.h"
#import "OrganizationParse.h"
#import "OrgUserParse.h"
#import "ImGroupParse.h"
#import "MessageParse.h"
#import "CloudDiskAppFileParse.h"
#import "CloudDiskAppFolderParse.h"
#import "CloudDiskAppRecyclePrase.h"
#import "CloudDiskAppShareParse.h"
#import "CloudDiskFavoritesParse.h"
#import "ChatLogParse.h"
#import "CooperationTaskParse.h"
#import "TagParse.h"
#import "MoreUserParse.h"
#import "PersonalUserAppParse.h"
#import "CooperationProjectParse.h"
#import "CooperationWorkGroupParse.h"
#import "CooperationTaskParse.h"
#import "CooperationParse.h"
#import "RegisterByMobileParse.h"
#import "FavoritesParse.h"
#import "PostParse.h"
#import "CooperationDocumentParse.h"
#import "CooperationToolAppParse.h"
#import "CooperationNewMemberParse.h"
#import "CooperationToolAppParse.h"
#import "HelpAndFeedbackParse.h"
#import "MsgTemplateParse.h"
#import "FileCommonParse.h"
#import "CooperationBaseFileParse.h"
#import "BusinessSessionParse.h"
#import "RemindParse.h"
#import "ErrorDAL.h"
#import "ErrorModel.h"
#import "NSDictionary+DicSerial.h"
#import "AppDateUtil.h"

#import "CooperationProjectMainParse.h"
#import "CooperationPedningParse.h"

#import "OrgPostParse.h"

#import "ApiServerParse.h"

#import "SecurityParse.h"
#import "ServiceCirclesParse.h"
#import "SystemParse.h"
#import "RemotelyServerParse.h"
#import "NotificationParse.h"

@implementation DataExchangeParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(DataExchangeParse *)shareInstance{
    static DataExchangeParse *instance = nil;
    if (instance == nil) {
        instance = [[DataExchangeParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析webapi请求的数据

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    
    NSLog(@"LZService get data from eventBus -------获取数据：%@",dataDic);
    /* 记录跟踪日志 */
    NSString *controller = [dataDic objectForKey:WebApi_Controller];
    if(![controller isEqualToString:WebApi_Message]){
        
//        NSString *route = [dataDic objectForKey:WebApi_Route];
//        if(![route isEqualToString:WebApi_CloudUser_RegisterByMobile]){
            @try
            {
                ErrorModel *errorModel=[[ErrorModel alloc]init];
                errorModel.errorid=[LZUtils CreateGUID];
                errorModel.errortitle=[NSString stringWithFormat:@"WebApi信息--%@",controller];
                errorModel.erroruid=[AppUtils GetCurrentUserID];
                errorModel.errorclass=@"";
                errorModel.errormethod=@"";
                NSMutableDictionary *dict = [dataDic mutableCopy];
                [dict setObject:[NSDictionary dictionary] forKey:@"datasend_other"];
                errorModel.errordata=[dict dicSerial];
                errorModel.errordate=[AppDateUtil GetCurrentDate];
                errorModel.errortype= [controller isEqualToString:WebApi_CloudCooperation_Devrun_Project] ? 175 : 0;
                [[ErrorDAL shareInstance]addDataWithErrorModel:errorModel];
            }@catch (NSException * e) {
                ErrorModel *errorModel=[[ErrorModel alloc]init];
                errorModel.errorid=[LZUtils CreateGUID];
                errorModel.errortitle=[NSString stringWithFormat:@"记录跟踪日志出错----%@",[dataDic lzNSStringForKey:WebApi_Controller]];
                errorModel.erroruid=[AppUtils GetCurrentUserID];
                errorModel.errorclass=@"";
                errorModel.errormethod=@"";
                errorModel.errordata=[NSString stringWithFormat:@"Exception: %@",e];
                errorModel.errordate=[AppDateUtil GetCurrentDate];
                errorModel.errortype=1;
                [[ErrorDAL shareInstance]addDataWithErrorModel:errorModel];
            }
//        }
    }
    
    /* 直接使用block进行回调 */
    NSDictionary *otherData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    if( [[otherData allKeys] containsObject:WebApi_DataSend_Other_BackBlock] ){
        WebApiSendBackBlock backBlock = [otherData objectForKey:WebApi_DataSend_Other_BackBlock];
        backBlock(dataDic);
        return;
    }
    
    /* 使用Parse相关类处理 */
    __block DataExchangeParse * changeParse = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([[[dataDic objectForKey:WebApi_ErrorCode] objectForKey:@"Code"] isEqualToString:@"0"]){
            [changeParse parseRightRequestData:dataDic];
            
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block DataExchangeParse * service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendSuccess, dataDic);
            });
        }
        else {
            [changeParse parseErrorRequestData:dataDic];
        }
    });
}

-(void)parseRightRequestData:(NSMutableDictionary *)dataDic{
    NSString *controller = [dataDic objectForKey:WebApi_Controller];
    
    /* 接收到的ErrorCode非0 */
    BOOL isRightErrorCode = YES;
    if(![[[dataDic objectForKey:WebApi_ErrorCode] objectForKey:@"Code"] isEqualToString:@"0"]){
        isRightErrorCode = NO;
    }
    
    /* 消息 */
    if([controller isEqualToString:WebApi_Message]){
        if(isRightErrorCode){
            [[MessageParse shareInstance] parse:dataDic];
        }
        else {
            [[MessageParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 通知 */
    if ([controller isEqualToString:WebApi_Notification]) {
        if (isRightErrorCode) {
            [[NotificationParse shareInstance] parse:dataDic];
        } else {
            [[NotificationParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 最近联系人(消息页签) */
    if([controller isEqualToString:WebApi_Recent]){
        if(isRightErrorCode){
            [[RecentParse shareInstance] parse:dataDic];
        }
        else{
            [[RecentParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 业务会话 */
    if ([controller isEqualToString:WebApi_BusinessSession]) {
        if (isRightErrorCode) {
            [[BusinessSessionParse shareInstance] parse:dataDic];
        } else {
            [[BusinessSessionParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 聊天记录 */
    if([controller isEqualToString:WebApi_ChatLog]){
        if(isRightErrorCode){
            [[ChatLogParse shareInstance] parse:dataDic];
        }
        else {
            [[ChatLogParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 提醒相关 */
    if ([controller isEqualToString:WebApi_Remind]) {
        if (isRightErrorCode) {
            [[RemindParse shareInstance] parse:dataDic];
        } else {
            [[RemindParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 联系人 */
    else if([controller isEqualToString:WebApi_Colleaguelist]){
        if(isRightErrorCode){
            [[ColleaguelistParse shareInstance] parse:dataDic];
        }
        else {
            [[ColleaguelistParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 组织机构 */
    else if([controller isEqualToString:WebApi_Organization]){
        if(isRightErrorCode){
            [[OrganizationParse shareInstance] parse:dataDic];
        }
        else {
            [[OrganizationParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 组织机构人员 */
    else if([controller isEqualToString:WebApi_OrgUser]){
        if(isRightErrorCode){
            [[OrgUserParse shareInstance] parse:dataDic];
        }
        else {
            [[OrgUserParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 群组 */
    else if([controller isEqualToString:WebApi_ImGroup]){
        if(isRightErrorCode){
            [[ImGroupParse shareInstance] parse:dataDic];
        }
        else {
            [[ImGroupParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 云盘文件夹 */
    else if([controller isEqualToString:WebApi_CloudDiskFolder]){
        if(isRightErrorCode){
            [[CloudDiskAppFolderParse shareInstance] parse:dataDic];
        }
        else {
            [[CloudDiskAppFolderParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 云盘文件 */
    else if([controller isEqualToString:WebApi_CloudDiskFile]){
        if(isRightErrorCode){
            [[CloudDiskAppFileParse shareInstance] parse:dataDic];
        }
        else {
            [[CloudDiskAppFileParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 收藏文件 */
    else if ([controller isEqualToString:WebApi_CloudDiskFavorites]){
        if(isRightErrorCode){
            [[CloudDiskFavoritesParse shareInstance] parse:dataDic];
        }
        else {
            [[CloudDiskFavoritesParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 回收站 接收到服务器数据 */
    else if ([controller isEqualToString:WebApi_CloudDiskRecycle]){
        if(isRightErrorCode){
            [[CloudDiskAppRecyclePrase shareInstance] parse:dataDic];
        }
        else {
            [[CloudDiskAppRecyclePrase shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 分享文件 */
    else if ([controller isEqualToString:WebApi_CloudDiskShare]) {
        if(isRightErrorCode){
            [[CloudDiskAppShareParse shareInstance] parse:dataDic];
        }
        else {
            [[CloudDiskAppShareParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 协作群组 接收到服务器数据 */
    else if ([controller isEqualToString:WebApi_CloudCooperationWorkGroup]){
        if(isRightErrorCode){
            [[CooperationWorkGroupParse shareInstance] parse:dataDic];
        }
        else {
            [[CooperationWorkGroupParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 标签 */
    else if ([controller isEqualToString:WebApi_CloudTag]){
        if(isRightErrorCode){
            [[TagParse shareInstance] parse:dataDic];
        }
        else {
            [[TagParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 我的资料 */
    else if ([controller isEqualToString:WebApi_CloudUser]){
        if(isRightErrorCode){
            [[MoreUserParse shareInstance] parse:dataDic];
            [[RegisterByMobileParse shareInstance] parse:dataDic];
        }
        else {
            [[MoreUserParse shareInstance] parseErrorDataContext:dataDic];
            [[RegisterByMobileParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 协作任务 接收到服务器数据 */
    else if ([controller isEqualToString:WebApi_CloudCooperationTask]){
        if(isRightErrorCode){
            [[CooperationTaskParse shareInstance] parse:dataDic];
        }
        else {
            [[CooperationTaskParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 协作任务 接收到服务器数据 */
    else if ([controller isEqualToString:WebApi_CloudCooperationProject]){
        if(isRightErrorCode){
            [[CooperationProjectParse shareInstance] parse:dataDic];
        }
        else {
            [[CooperationProjectParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 协作通用 接收到服务器数据 */
    else if ([controller isEqualToString:WebApi_CloudCooperation]){
        if(isRightErrorCode){
            [[CooperationParse shareInstance] parse:dataDic];
        }
        else {
            [[CooperationParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 动态 */
    else if ([controller isEqualToString:WebApi_CloudPost]){
        if(isRightErrorCode){
            [[PostParse shareInstance] parse:dataDic];
        }
        else {
            [[PostParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /*收藏*/
    else if ([controller isEqualToString:WebApi_CloudFavorites]){
        if(isRightErrorCode){
            [[FavoritesParse shareInstance] parse:dataDic];
        }
        else {
            [[FavoritesParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 应用 */
    else if ([controller isEqualToString:WebApi_CloudApp]){
        if(isRightErrorCode){
            [[PersonalUserAppParse shareInstance] parse:dataDic];
        }
        else {
            [[PersonalUserAppParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 服务圈 */
    else if ([controller isEqualToString:WebApi_CloudsServiceCircles]){
        
        if(isRightErrorCode){
            [[ServiceCirclesParse shareInstance] parse:dataDic];
        }
        else {
            [[ServiceCirclesParse shareInstance] parseErrorDataContext:dataDic];
        }

    }
    /* 协作文件 */
    else if ([controller isEqualToString:WebApi_CloudCooperationDocument]) {
        if (isRightErrorCode) {
            [[CooperationDocumentParse shareInstance] parse:dataDic];
        }
        else {
            [[CooperationDocumentParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 新的协作成员 */
    else if ([controller isEqualToString:WebApi_CloudCooperationNew]) {
        if (isRightErrorCode) {
            [[CooperationNewMemberParse shareInstance] parse:dataDic];
        }
        else {
            [[CooperationNewMemberParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 协作工具app*/
    else if ([controller isEqualToString:WebApi_CloudCooperationToolApp]) {
        if (isRightErrorCode) {
            [[CooperationToolAppParse shareInstance] parse:dataDic];
        }
        else {
            [[CooperationToolAppParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 帮助与反馈 */
    else if ([controller isEqualToString:WebApi_HelpAndFeedBack]) {
        if (isRightErrorCode) {
            [[HelpAndFeedbackParse shareInstance]parse:dataDic];
        }
        else {
            [[HelpAndFeedbackParse shareInstance]parseErrorDataContext:dataDic];
        }
    }
    /* 消息模板 */
    else if ([controller isEqualToString:WebApi_MsgTemplate]) {
        if (isRightErrorCode) {
            [[MsgTemplateParse shareInstance]parse:dataDic];
        }
        else {
            [[MsgTemplateParse shareInstance]parseErrorDataContext:dataDic];
        }
    }
    /* 通用文件 */
    else if ([controller isEqualToString:WebApi_FileCommon]) {
        if (isRightErrorCode) {
            [[FileCommonParse shareInstance]parse:dataDic];
        }
        else {
            [[FileCommonParse shareInstance]parseErrorDataContext:dataDic];
        }
    }
    /* 基础协作文件 */
    else if ([controller isEqualToString:WebApi_CooperationBaseFile]) {
        if (isRightErrorCode) {
            [[CooperationBaseFileParse shareInstance] parse:dataDic];
        }
        else {
            [[CooperationBaseFileParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    /* 项目 */
    else if ([controller isEqualToString:WebApi_CloudCooperation_Project] || [controller isEqualToString:WebApi_CloudCooperation_Devrun_Project]) {
        if (isRightErrorCode) {
            [[CooperationProjectMainParse shareInstance]parse:dataDic];
        }
        else {
            [[CooperationProjectMainParse shareInstance] parseErrorDataContext:dataDic];
        }
    }
    else if ([controller isEqualToString:WebApi_CloudCooperationPending]){
        
        if (isRightErrorCode){
            [[CooperationPedningParse shareInstance]parse:dataDic];
        }
        else{
            [[CooperationPedningParse shareInstance]parseErrorDataContext:dataDic];
        }
        
    }
    /* 服务器配置 */
    else if ([controller isEqualToString:WebApi_ApiServer]){
        if(isRightErrorCode){
            [[ApiServerParse shareInstance]parse:dataDic];
        }
        else{
            [[ApiServerParse shareInstance]parseErrorDataContext:dataDic];
        }
    }
    /* 组织机构岗位相关 */
    else if ([controller isEqualToString:WebApi_OrgPost]){
        if(isRightErrorCode){
            [[OrgPostParse shareInstance]parse:dataDic];
        }
        else{
            [[OrgPostParse shareInstance]parseErrorDataContext:dataDic];
        }
    }
    /* 账号安全 */
    else if ([controller isEqualToString:WebApi_Security]){
        if(isRightErrorCode){
            [[SecurityParse shareInstance]parse:dataDic];
        }
        else{
            [[SecurityParse shareInstance]parseErrorDataContext:dataDic];
        }
    }
    /* 移动端短地址配置 */
    else if ([controller isEqualToString:WebApi_System]){
        if(isRightErrorCode){
            [[SystemParse shareInstance]parse:dataDic];
        }
        else{
            [[SystemParse shareInstance]parseErrorDataContext:dataDic];
        }
    }
    /* 获取远程文件服务 */
    else if ([controller isEqualToString:WebApi_RemotelyServer]) {
        if (isRightErrorCode) {
            [[RemotelyServerParse shareInstance] parse:dataDic];
        }
        else {
            [[RemotelyServerParse shareInstance]parseErrorDataContext:dataDic];
        }
    }

}

-(void)parseErrorRequestData:(NSMutableDictionary *)dataDic{
    DDLogError(@"WebApi请求异常");
    
    __block DataExchangeParse * service = self;
    
    NSString *codeStr = [[dataDic objectForKey:WebApi_ErrorCode] objectForKey:@"Code"];
    int code = codeStr.intValue;
    /* tokenid不存在，tokenid过期 */
    if(code==41001 || code==41002){
        /* 记录日志，跟踪20161213，收到已读，数量减一 */
        NSString *errorTitle = [NSString stringWithFormat:@"11"];
        [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:@"tokenid不存在，tokenid过期" errortype:Error_Type_Five];
        
        /* 先断开 */
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate gotoLoginPageIsSendWebApi:YES isGotoLoginVC:NO];
        /* 再重连 */
        [appDelegate.lzservice loginRestartForUserHandle];
        //            [service loginRestartForUserHandle];
        
        return;
    }
    
    /* 若最后一个api获取数据失败，仍进入主页面 */
    NSMutableDictionary *dic = [dataDic objectForKey:WebApi_DataSend_Get];
    if(dic!=nil){
        if([[dic allKeys] containsObject:@"lastwebapi"] && [[dic objectForKey:@"lastwebapi"] isEqualToString:@"1"]){
            
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            [data setObject:LZConnection_Login_NetWorkStatus forKey:@"type"];
            [data setObject:LZConnection_Login_NetWorkStatus_RecvFinish forKey:@"status"];
            
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.lzGlobalVariable.isShowLoadingWhenLoginWebFromLoginVC = NO;
                EVENT_PUBLISH_WITHDATA(service, EventBus_ConnectHandle, data);
            });
        }
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, dataDic);
        [self parseRightRequestData:dataDic];
    });
}

/*
 同步解析长连接返回的消息数据
 */
-(void)parseGetMessgae:(NSMutableDictionary *)dataDic parseResult:(LZParseMsgResult)parseResult{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_async(appDelegate.lzGlobalVariable.msgQueue, ^{
        BOOL result = [[MessageParse shareInstance] parseGet:dataDic];
        parseResult(result);
    });
}

@end
