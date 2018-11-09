//
//  OrgUserTempParse.m
//  LeadingCloud
//
//  Created by dfl on 16/5/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-05-09
 Version: 1.0
 Description: 临时消息--新的组织--企业邀请人
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "OrgUserTempParse.h"
#import "AppUtils.h"
#import "OrgEnterPriseDAL.h"
#import "OrgUserIntervateDAL.h"

@implementation OrgUserTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgUserTempParse *)shareInstance{
    static OrgUserTempParse *instance = nil;
    if (instance == nil) {
        instance = [[OrgUserTempParse alloc] init];
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
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    
    /* 新的组织 */
    if([handlertype isEqualToString:Handler_Organization_Orguser_Intervateuser]){
        isSendReport = [self parseOrgUserIntervateUser:dataDic];
    }
    /* 新的员工 */
    else if([handlertype isEqualToString:Handler_Organization_Orguser_UserJoinApply]){
        isSendReport = [self parserOrgUserJoinApply:dataDic];
    }
    /* 新的员工-管理员同意用户申请 */
    else if([handlertype isEqualToString:Handler_Organization_Orguser_AgreeUserApply]){
        isSendReport = [self parserOrgUserAgreeUserApply:dataDic];
    }
    /* 新的员工-管理员拒绝用户的申请 */
    else if([handlertype isEqualToString:Handler_Organization_Orguser_RefuseApply]){
        isSendReport = [self parserOrgUserRefuseApply:dataDic];
    }
    /* 新的组织-用户同意组织的邀请 */
    else if([handlertype isEqualToString:Handler_Organization_Orguser_ApproveIntervate]){
        isSendReport = [self parserOrgUserApproveIntervate:dataDic];
    }
    /* 修改人员在企业下的名称 */
    else if( [handlertype isEqualToString:Handler_Organization_Orguser_UpdateEnterUserName] ){
        isSendReport = [self parserOrgUserUpdateEnterUserName:dataDic];
    }
    /* 移除部门下的人员 */
    else if( [handlertype isEqualToString:Handler_Organization_Orguser_RemoveUser] ){
        isSendReport = [self parserOrgUserRemoveUser:dataDic];
    }
    /* 组织撤销邀请用户 */
    else if( [handlertype isEqualToString:Handler_Organization_Orguser_RevokeInterUser] ){
        isSendReport = [self parserOrgUserRevokeInterUser:dataDic];
    }
    /* 新的组织-用户拒绝组织的邀请 */
    else if ( [handlertype isEqualToString:Handler_Organization_Orguser_RefuseInvite] ){
        isSendReport = [self parserOrgUserRefuseInvite:dataDic];
    }
    /* 组织批量导入员工通知 */
    else if ( [handlertype isEqualToString:Handler_Organization_Orguser_BatImportResult] ){
        isSendReport = [self parserOrgUserBatImportResult:dataDic];
    }
    /* 组织下批量删除人员通知 */
    else if ( [handlertype isEqualToString:Handler_Organization_Orguser_BatRemoveUser] ){
        isSendReport = [self parserOrgUserBatRemoveUser:dataDic];
    }
    /* 批量导入用户后，给导入的用户发送通知 */
    else if ( [handlertype isEqualToString:Handler_Organization_Orguser_BatImportIlegal] ){
        isSendReport = [self parserOrgUserBatImportIlegal:dataDic];
    }
    /* 用户自行退出组织通知 */
    else if ( [handlertype isEqualToString:Handler_Organization_Orguser_UserExit] ){
        isSendReport = [self parseOrguserUserExit:dataDic];
    }
    /* 设置用户在企业下的排序值通知 */
    else if ( [handlertype isEqualToString:Handler_Organization_Orguser_SetenterUserSort] ){
        isSendReport = [self parseOrguserSetenterUserSort:dataDic];
    }
    
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

/**
 *  收到新的组织邀请人数据
 */
-(BOOL)parseOrgUserIntervateUser:(NSMutableDictionary *)dataDic{
    //新的组织处理
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSMutableDictionary *OrgDic=[NSMutableDictionary dictionary];
//    NSString *oid=[body objectForKey:@"oid"];
    NSString *oeid=[body objectForKey:@"oeid"];
    NSString *uid=[AppUtils GetCurrentUserID];
    [OrgDic setObject:oeid forKey:@"objoeid"];
    [OrgDic setObject:uid forKey:@"uid"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgUserInterInfoByUidOeid, OrgDic);
    });
    
    return YES;
    
}

/**
 *  收到新的组织邀请人数据
 */
-(BOOL)parserOrgUserJoinApply:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *ouaid=[body objectForKey:@"ouaid"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgUserJoinApply, ouaid);
    });
    return YES;
}

/**
 *  新的员工-管理员同意用户申请
 */
-(BOOL)parserOrgUserAgreeUserApply:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    
    /* 获取某个用户在好友的位置，以及返回用户信息 */
    NSMutableDictionary *postData=[NSMutableDictionary dictionary];
    postData[@"uid"]=[body objectForKey:@"uid"];
    postData[@"oeid"]=[body objectForKey:@"oeid"];
    [self.appDelegate.lzservice sendToServerForPost:WebApi_Organization routePath:WebApi_Organization_GetOrgsByUserByUidOeid moduleServer:Modules_Default getData:nil postData:postData otherData:nil];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_OrgAgreeUserApply, body);
    });
    return YES;
}

/**
 *  新的员工-管理员拒绝用户的申请
 */
-(BOOL)parserOrgUserRefuseApply:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_OrgUserRefuseApply, body);
    });
    return YES;
}


/**
 *  新的组织-用户同意组织的邀请
 */
-(BOOL)parserOrgUserApproveIntervate:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    if([[AppUtils GetCurrentUserID]isEqualToString:[body objectForKey:@"uid"]]){
        /* 获取某个用户在好友的位置，以及返回用户信息 */
        NSMutableDictionary *postData=[NSMutableDictionary dictionary];
        postData[@"uid"]=[body objectForKey:@"uid"];
        postData[@"oeid"]=[body objectForKey:@"oeid"];
        [self.appDelegate.lzservice sendToServerForPost:WebApi_Organization routePath:WebApi_Organization_GetOrgsByUserByUidOeid moduleServer:Modules_Default getData:nil postData:postData otherData:nil];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_OrgUserApproveIntervate, body);
    });
    return YES;
}

/**
 *  修改人员在企业下的名称
 */
-(BOOL)parserOrgUserUpdateEnterUserName:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_OrgUserUpdateEnterUsername, body);
    });
    return YES;
}

/**
 *  移除部门下的人员
 */
-(BOOL)parserOrgUserRemoveUser:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *uid=[body objectForKey:@"uid"];
    NSString *oeid=[body objectForKey:@"oeid"];
    
    if([[AppUtils GetCurrentUserID]isEqualToString:uid]){
        //删除本地存储的已解散的组织信息
        [[OrgEnterPriseDAL shareInstance]deleteOrgUserEntetpriseByEId:oeid];
        if([[AppUtils GetCurrentOrgID] isEqualToString:oeid]){
            NSArray *orgEnterPrisesArr = [[OrgEnterPriseDAL shareInstance]getOrgEnterPrises];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LZUserDataManager readCurrentUserInfo]];
            NSMutableDictionary *notificaton = [dic lzNSMutableDictionaryForKey:@"notificaton"];
            NSString *mainoeid = [notificaton lzNSStringForKey:@"mainoeid"];
            if(orgEnterPrisesArr.count==0){
                /* 个人身份 */
                [[self appDelegate].lzservice sendToServerForGet:WebApi_CloudUser routePath:WebApi_CloudUser_SwitchPersonidenType moduleServer:Modules_Default getData:nil otherData:nil];
                [notificaton setObject:[NSNumber numberWithUnsignedInt:1] forKey:@"identitytype"];
                [notificaton setObject:[AppUtils GetCurrentUserID] forKey:@"selectoid"];
            }
            else{
                /* 组织身份 */
                OrgEnterPriseModel *orgEnterPriseModel = [orgEnterPrisesArr firstObject];
                NSMutableDictionary *postData = [NSMutableDictionary dictionary];
                
                [postData setObject:[AppUtils GetCurrentUserID] forKey:@"uid"];
                [postData setObject:orgEnterPriseModel.eid forKey:@"selectoid"];
                
                [[self appDelegate].lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_Update_Selected_Org moduleServer:Modules_Default getData:nil postData:postData otherData:nil];
                
                /* 当前ID是主企业身份 */
                if([mainoeid isEqualToString:oeid]){
                    NSMutableDictionary *getData = [NSMutableDictionary dictionary];
                    getData[@"oeid"] = orgEnterPriseModel.eid;
                    [self.appDelegate.lzservice sendToServerForGet:WebApi_CloudUser routePath:WebApi_CloudUser_SetMainOrg moduleServer:Modules_Default getData:getData otherData:nil];
                    [notificaton setObject:orgEnterPriseModel.eid forKey:@"mainoeid"];
                }
                
                [notificaton setObject:[NSNumber numberWithUnsignedInt:2] forKey:@"identitytype"];
                [notificaton setObject:orgEnterPriseModel.eid forKey:@"selectoid"];
            }
            [dic setObject:notificaton forKey:@"notificaton"];
            [LZUserDataManager saveCurrentUserInfo:dic];
        }
    }
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactRootVC2=YES;
        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_OrgUserRemoveUser, body);
//        if([[AppUtils GetCurrentOrgID] isEqualToString:oeid]){
//            EVENT_PUBLISH_WITHDATA(service, EventBus_User_SwitchIdentiType, body);
//        }
//        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgUserDisBandOrgByOeid, body);
    });
    return YES;
}

/**
 *  组织撤销邀请用户
 */
-(BOOL)parserOrgUserRevokeInterUser:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_RevokeInterUser, body);
    });
    
    return YES;
}

/**
 *  新的组织-用户拒绝组织的邀请
 */
-(BOOL)parserOrgUserRefuseInvite:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_RefuseInvite, body);
    });
    return YES;
}

/**
 *  组织批量导入员工通知
 */
-(BOOL)parserOrgUserBatImportResult:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_BatImportResult, body);
    });
    
    return YES;
}

/**
 *  组织下批量删除人员通知
 */
-(BOOL)parserOrgUserBatRemoveUser:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    
    NSArray *uids=[body lzNSArrayForKey:@"uids"];
    NSString *oeid=[body lzNSStringForKey:@"oeid"];
    for(int i=0;i<uids.count;i++){
        NSString *uid=[uids objectAtIndex:i];
        if([[AppUtils GetCurrentUserID]isEqualToString:uid]){
            //删除本地存储的已解散的组织信息
            [[OrgEnterPriseDAL shareInstance]deleteOrgUserEntetpriseByEId:oeid];
        }
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactRootVC2=YES;
        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_BatRemoveUser, body);
    });
    
    return YES;
}

/**
 *  批量导入用户后，给导入的用户发送通知
 */
-(BOOL)parserOrgUserBatImportIlegal:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *oeid = [body lzNSStringForKey:@"oeid"];
    OrgEnterPriseModel *model=[[OrgEnterPriseDAL shareInstance]getEnterpriseByEId:oeid];
    if(model==nil){
        /* 获取用户在某个组织下的主要信息 */
        NSMutableDictionary *postData=[NSMutableDictionary dictionary];
        postData[@"uid"]=[AppUtils GetCurrentUserID];
        postData[@"oeid"]=oeid;
        [self.appDelegate.lzservice sendToServerForPost:WebApi_Organization routePath:WebApi_Organization_GetOrgsByUserByUidOeid moduleServer:Modules_Default getData:nil postData:postData otherData:nil];
    }

    return YES;
}

/**
 *  用户自行退出组织通知
 */
-(BOOL)parseOrguserUserExit:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *uid=[body objectForKey:@"uid"];
    NSString *oeid=[body objectForKey:@"oeid"];
    
    if([[AppUtils GetCurrentUserID]isEqualToString:uid]){
        //删除本地存储的已解散的组织信息
        [[OrgEnterPriseDAL shareInstance]deleteOrgUserEntetpriseByEId:oeid];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactRootVC2=YES;
        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_UserExit, body);
    });
    return YES;
}

/**
 *  设置用户在企业下的排序值通知
 */
-(BOOL)parseOrguserSetenterUserSort:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{

        __block OrgUserTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_SetenterUserSort, body);
    });
    return YES;
}


@end
