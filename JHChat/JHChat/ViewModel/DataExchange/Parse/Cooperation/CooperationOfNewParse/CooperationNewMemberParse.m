//
//  CooperationNewMemberParse.m
//  LeadingCloud
//
//  Created by SY on 16/6/8.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooperationNewMemberParse.h"
#import "CooNewMemberApplyModel.h"
#import "CooOfNewModel.h"
#import "NSObject+JsonSerial.h"
#import "CooOfNewMemberDAL.h"
#import "CooOfNewTaskDAL.h"
#import "InviteApprovalModel.h"
#import "LZUtils.h"

#import "CoTransactionTypeModel.h"
#import "UserModel.h"
@implementation CooperationNewMemberParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationNewMemberParse *)shareInstance{
    static CooperationNewMemberParse *instance = nil;
    if (instance == nil) {
        instance = [[CooperationNewMemberParse alloc] init];
    }
    return instance;
}
/**
 *  解析数据
 *
 *  @param dataDic
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    
    NSString *route = [dataDic objectForKey:WebApi_Route];
    /* 获取所有成员列表 */
    if ([route isEqualToString:WebApiCloudCooperationNewMember_GetList]) {
        [self parseGetMemberList:dataDic];
    }
    /* 获取新的成员日志列表 */
    else if ([route isEqualToString:WebApiCloudCooperationNewMember_GetLoglist]) {
        [self parseGetNewMemberLogList:dataDic];
    }
    /* 通过申请 */
    else if ([route isEqualToString:WebApiCloudCooperationNewMember_Pass]) {
        [self parsePassData:dataDic];
    }
    /* 不同意 现在是删除 */
    else if ([route isEqualToString:WebApiCloudCooperationNewMember_NotPass]) {
        [self parseNotPassData:dataDic];
    }
    /* 删除申请日志 */
    else if ([route isEqualToString:WebApiCloudCooperationNewMember_DeleteLoagApply]) {
        [self parseDeleteApply:dataDic];
    }
    
    /* 获取新的申请信息 (新)*/
    else if ([route isEqualToString:WebApiCloudCooperationNewMenber_GetNewApplyInfo]) {
        [self parseGetNewApplyInfo:dataDic];
    }
    
    
    // 新的协作 协作区内所有邀请我的成员列表
    else if ([route isEqualToString:WebApi_CloudCooperationNew_hasinvited]) {
        [self parseHasInvited:dataDic];
    }
    // 新的协作 得到邀请日志列表
    else if ([route isEqualToString:WebApi_CloudCooperationNew_GetLogList]) {
        [self parseLogList:dataDic];
    }
    // 新的协作 同意邀请
    else if ([route isEqualToString:WebApi_CloudCooperationNew_AgreeInvite]) {
        [self parseReciveInvite:dataDic];
    }
    // 新的协作拒绝邀请
    else if ([route isEqualToString:Webapi_CloudCooperationNew_DisagreeInvite]) {
        [self parseReciveInvite:dataDic];
    }
    // 新的协作 删除邀请
    else if ([route isEqualToString:WebApi_CloudCooperationNew_DeleteInvite]) {
        [self parseDeleteInvite:dataDic];
    }
    // 新的协作 删除邀请日志
    else if ([route isEqualToString:WebApi_CloudCooperationNew_DeleteLogInvite]) {
        [self parseDeleteInvite:dataDic];
    }
    
    
    /* 新的协作 （最新版本） */
    else if ([route isEqualToString:WebApi_CloudCooperationNew_GetModel]) {
        [self parseGetModel:dataDic];
    }
    /* 获取新的协作邀请信息（最新版本） */
    else if ([route isEqualToString:WebApi_CloudCooperationNew_GetNewCooInviteInfo]) {
        [self parseGetNewCooInfo:dataDic];
    }
    
    
    /* ****************** 普通成员邀请 ***************** */
    else if ([route isEqualToString:WebApiCloudCooperationApproval_GetApprovalInfo]) {
        [self parseApprovalInfo:dataDic];
    }
    else if ([route isEqualToString:WebApiCloudCooperationApproval_AgreeApproval])  {
        [self parseAgreeApproval:dataDic];
    }
    else if ([route isEqualToString:WebApiCloudCooperationApproval_IgnoreApproval]) {
        [self parseIgnoreApproval:dataDic];
    }
    
}
/* 获取所有成员列表 */
- (void)parseGetMemberList:(NSMutableDictionary*)dataDic {
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSArray *applyArray = [contextDic lzNSArrayForKey:@"applylist"];
    
    NSMutableArray *applyAllArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < applyArray.count; i++) {
        CooNewMemberApplyModel *applyModel = [[CooNewMemberApplyModel alloc] init];
        [applyModel serializationWithDictionary:[applyArray objectAtIndex:i]];
        applyModel.keyid = [LZUtils CreateGUID];
        applyModel.state = 2;
        [applyAllArr addObject:applyModel];
    }
    NSMutableArray *localArr = [[CooOfNewMemberDAL shareInstance] selectAllDataWithState:2];
    for (int i = 0; i < localArr.count; i++) {
        // 删除旧数据
        [[CooOfNewMemberDAL shareInstance] deleteAllDataWithState:@"2"];
    }
    
    [[CooOfNewMemberDAL shareInstance] addCooMember:applyAllArr];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewMember_GetAllApplyer, applyAllArr);
    });
    
}
//新的成员日志列表
-(void)parseGetNewMemberLogList:(NSMutableDictionary*)dataDic {
    
    NSArray *dataContext = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSDictionary *dataGet = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    
    NSMutableArray *applyLogArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<[dataContext count]; i++) {
        CooNewMemberApplyModel *applyM =[[CooNewMemberApplyModel alloc] init];
        NSDictionary *dic = [dataContext objectAtIndex:i];
        [applyM serializationWithDictionary:dic];
        applyM.keyid = [LZUtils CreateGUID];
        NSString * applytime = [dic lzNSStringForKey:@"operationtime"];
        applyM.applytime = [LZFormat String2Date:applytime];
        if (applyM.result == 1) {
            applyM.state = 1;
            
            [applyLogArr addObject:applyM];
        }
       
    }
    // 先删除本地数据 在从新插入最新的到数据库
    if (self.appDelegate.lzGlobalVariable.isDeleteNewCooLocalData) {
        // 删除旧数据
        [[CooOfNewMemberDAL shareInstance] deleteAllDataWithState:@"1"];
        self.appDelegate.lzGlobalVariable.isDeleteNewCooLocalData = NO;
    }

    
    [[CooOfNewMemberDAL shareInstance] addCooMember:applyLogArr];
    
    NSString *lastlogid = [dataGet lzNSStringForKey:@"lastlogid"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:lastlogid forKey:@"lastlogid"];
    [dic setObject:applyLogArr forKey:@"array"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, Eventbus_Coo_NewMember_GetApplyLogList, dic);
    });
    
}
/* 通过申请 */
- (void)parsePassData:(NSMutableDictionary*)dataDic {
    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *keyid = [dic lzNSStringForKey:@"keyid"];
    [[CooOfNewMemberDAL shareInstance] updataNewApplyActionResultWithKeyid:keyid actionresult:2];
    // 设置状态为同意
   // [[CooOfNewMemberDAL shareInstance] updataNewApplyWithUid:[dic lzNSStringForKey:@"uid"] cid:[dic lzNSStringForKey:@"cid"] state:1];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewMember_Agree, nil);
    });
    
}
 /* 不同意 */
- (void)parseNotPassData:(NSMutableDictionary*)dataDic {
    
    NSDictionary *dic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *keyid = [dic lzNSStringForKey:@"keyid"];
    [[CooOfNewMemberDAL shareInstance] updataNewApplyActionResultWithKeyid:keyid actionresult:3];
    //[[CooOfNewMemberDAL shareInstance] deleteApplySourceWithCid:[dic lzNSStringForKey:@"cid"]];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBud_Coo_NewMember_NotAgree, nil);
    });

}
// 删除申请日志
-(void)parseDeleteApply:(NSMutableDictionary*)dataDic {
    NSDictionary *dataGet = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    
    NSString *cmalid = [dataGet lzNSStringForKey:@"cmalid"];
    [[CooOfNewMemberDAL shareInstance] deleteApplyLogSourceWithCmalid:cmalid];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, Eventbus_Coo_NewMember_DeleteLog, nil);
    });
    
}

/**
 获取新的申请的信息
 */
-(void)parseGetNewApplyInfo:(NSMutableDictionary*)dataDic {
    
    NSDictionary *dataContext = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *getData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    
    NSString *keyid = [getData lzNSStringForKey:@"keyid"];
    
    NSArray *applyArr = [dataContext lzNSArrayForKey:@"applylist"];
    NSMutableArray *array = [NSMutableArray array];
    CooNewMemberApplyModel *applyModel = nil;
    for (int i = 0; i< applyArr.count; i++) {
        CooNewMemberApplyModel *applyM =[[CooNewMemberApplyModel alloc] init];
        [applyM serializationWithDictionary:[applyArr objectAtIndex:i]];
        applyM.keyid = keyid;
        [array addObject:applyM];
        applyModel = applyM;
    }
    [[CooOfNewMemberDAL shareInstance] deleteDidHandleSourceWithCid:applyModel.cid applyid:applyModel.applyid];
    [[CooOfNewMemberDAL shareInstance] addCooMember:array];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBud_Coo_NewMember_GetNewApplyInfo, applyModel);
    });
    
}
#pragma mark - 新的协作 解析
// 新的协作 协作区内所有邀请我的成员列表
-(void)parseHasInvited:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *newCooDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSArray *inviteListArr = [newCooDic lzNSArrayForKey:@"invitelist"];
    
    NSMutableArray *newCooModelArray = [[NSMutableArray alloc] init];
    // 邀请列表
    for (int i = 0; i < [inviteListArr count]; i++) {
        NSDictionary *newCooDic = [inviteListArr objectAtIndex:i];
        CooOfNewModel *newCooModel = [[CooOfNewModel alloc] init];
        [newCooModel serializationWithDictionary:newCooDic];
        newCooModel.state = 2;  //未处理状态
        [newCooModelArray addObject:newCooModel];
    }
    // 先删除本地数据 在从新插入最新的到数据库
//    [[CooOfNewTaskDAL shareInstance] deleteCooOfNewDataWithState:@"2"];
    // 存本地
    [[CooOfNewTaskDAL shareInstance] addNewCooDataWithArray:newCooModelArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewCooperation_newCooList, newCooModelArray);
    });
    
}
// 得到邀请日志列表
-(void)parseLogList:(NSMutableDictionary*)dataDic {
    
    NSArray *dataContext = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSDictionary *dataGet = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSMutableArray *newCooModelArray = [[NSMutableArray alloc] init];
    for ( int i = 0 ; i < dataContext.count; i++) {
        NSDictionary *newCooDic = [dataContext objectAtIndex:i];
        
        CooOfNewModel *newCooModel = [[CooOfNewModel alloc] init];
        [newCooModel serializationWithDictionary:newCooDic];
        NSString *date = [newCooDic lzNSStringForKey:@"invitedtime"];
        newCooModel.invitetime = [LZFormat String2Date:date];
        if (newCooModel.isagree == 1) {
            newCooModel.state = 1;  //已同意
        }
        [newCooModelArray addObject:newCooModel];
    }
    // 先删除本地数据 在从新插入最新的到数据库
    if (self.appDelegate.lzGlobalVariable.isDeleteNewCooLocalData) {
        [[CooOfNewTaskDAL shareInstance] deleteCooOfNewDataWithState:@"1"];
        self.appDelegate.lzGlobalVariable.isDeleteNewCooLocalData = NO;
    }

//
    
    // 存本地
    [[CooOfNewTaskDAL shareInstance] addNewCooDataWithArray:newCooModelArray];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *lastlogid = [dataGet lzNSStringForKey:@"lastlogid"];
    [dic setObject:lastlogid forKey:@"lastlogid"];
    [dic setObject:newCooModelArray forKey:@"array"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewCooperation_NewCooLogList, dic);
    });

}
// 新的协作 同意邀请
-(void)parseReciveInvite:(NSMutableDictionary*)dataDic {
    
    NSNumber *data = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *keyid = [dataOther lzNSStringForKey:@"keyid"];
    
    NSInteger isSuccess = [data integerValue];
    
    NSMutableDictionary *agreeDic = [[NSMutableDictionary alloc] init];
    /* 修改同意后的字段 */
    [[CooOfNewTaskDAL shareInstance] updataNewCooWithKeyId:keyid actionResult:2];
    if (isSuccess) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationNewMemberParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewCooperation_AgreeInvite, agreeDic);
        });
    }
}
// 新的协作删除
-(void)parseDeleteInvite:(NSMutableDictionary*)dataDic {
    NSNumber *data = [dataDic lzNSNumberForKey:WebApi_DataContext];
     NSInteger isSuccess = [data integerValue];
    
   // NSMutableDictionary *dataGet = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Get];
    NSString *isHaveKeyid = @"0";
    //NSString *cid = [dataGet lzNSStringForKey:@"cid"];
    
    NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *keyid = [dataOther lzNSStringForKey:@"keyid"];
    /* 修改忽略后的字段 */
    [[CooOfNewTaskDAL shareInstance] updataNewCooWithKeyId:keyid actionResult:3];
//    for (NSString *key in [dataGet allKeys]) {
//        if ([key isEqualToString:@"keyid"]) {
//            isHaveKeyid = @"1";
//          
//        }
//    }
//    if ([isHaveKeyid isEqualToString:@"1"]) {
//        [[CooOfNewTaskDAL shareInstance] deleteHandleCooOfNewDataWithKeyId:[dataGet lzNSStringForKey:@"keyid"]];
//    }
//    else {
//        [[CooOfNewTaskDAL shareInstance] deleteCooOfNewDataWithcid:cid];
//    }
    
    
    if (isSuccess ) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationNewMemberParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewCooperation_DeleteInvite, isHaveKeyid);
        });
    }
    
}
//CoTransactionTypeModel
-(void)parseGetModel:(NSMutableDictionary*)dataDic {
    NSDictionary *dataContext = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    CoTransactionTypeModel *ctModel = [[CoTransactionTypeModel alloc] init];
    
    [ctModel serializationWithDictionary:dataContext];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewCooperation_GetTransactionModel, ctModel);
    });
    
}
/* 获取信息新的协作信息 */
-(void)parseGetNewCooInfo:(NSMutableDictionary*)dataDic {
    
    NSDictionary *context = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *getData  = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    
    NSString *keyid = [getData lzNSStringForKey:@"keyid"];
    NSArray *inviteListArr = [context lzNSArrayForKey:@"invitelist"];
    
    NSMutableArray *newCooModelArray = [NSMutableArray array];
//    CooOfNewModel *cModel = nil;
    for (int i = 0; i< inviteListArr.count; i++) {
        NSDictionary *dic = [inviteListArr objectAtIndex:i];
        CooOfNewModel *cnModel = [[CooOfNewModel alloc] init];
        [cnModel serializationWithDictionary:dic];
//        cModel = cnModel;
        [newCooModelArray addObject:cnModel];
    }
    [[CooOfNewTaskDAL shareInstance] deleteHandleCooOfNewDataWithKeyId:keyid];
    [[CooOfNewTaskDAL shareInstance] addNewCooDataWithArray:newCooModelArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewCooperation_GetNewCooInfo, newCooModelArray);
    });

}
-(void)parseApprovalInfo:(NSMutableDictionary*)dataDic {
    
    NSDictionary *datacontext = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSMutableDictionary *inviteUserInfoDic = [datacontext lzNSMutableDictionaryForKey:@"inviteUserInfo"];
    NSMutableArray *inviteList = [datacontext lzNSMutableArrayForKey:@"invitedUserInfoList"];
    InviteApprovalModel *approvalModel = [[InviteApprovalModel alloc] init];
    [approvalModel serializationWithDictionary:datacontext];
    approvalModel.inviteUserInfoDic = inviteUserInfoDic;
    
    approvalModel.invitedUserInfoList = [NSMutableArray array];
    for (NSDictionary *userModelDic in inviteList) {
        UserModel *userModel = [[UserModel alloc] init];
        [userModel serializationWithDictionary:userModelDic];
        [approvalModel.invitedUserInfoList addObject:userModel];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewCooperationApproval_GetApprovalInfo, approvalModel);
    });
}
-(void)parseAgreeApproval:(NSMutableDictionary*)dataDic {
    
    
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewCooperationApproval_AgreeApproval, nil);
    });
}
-(void)parseIgnoreApproval:(NSMutableDictionary*)dataDic {
    
    
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationNewMemberParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewCooperationApproval_IgnoreApproval, nil);
    });
}
/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic{
    
}

@end
