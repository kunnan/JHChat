//
//  OrgAdminTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/6/7.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "OrgAdminTempParse.h"
#import "AppUtils.h"
#import "NSString+IsNullOrEmpty.h"
#import "OrgEnterPriseDAL.h"

@implementation OrgAdminTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgAdminTempParse *)shareInstance{
    static OrgAdminTempParse *instance = nil;
    if (instance == nil) {
        instance = [[OrgAdminTempParse alloc] init];
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
    
    /* 取消管理员 */
    if([handlertype isEqualToString:Handler_Organization_Org_CancelAdmin]){
        isSendReport = [self parseOrgCancelAdmin:dataDic];
    }
    /* 批量设置管理员 */
    else if( [handlertype isEqualToString:Handler_Organization_Org_BatchSetAdmin] ){
        isSendReport = [self parseOrgBatchSetAdmin:dataDic];
    }
    /* 设置管理员 */
    else if( [handlertype isEqualToString:Handler_Organization_Org_SetAdmin] ){
        isSendReport = [self parseOrgSetAdmin:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

/**
 *  收到取消管理员(只处理当然用户被取消管理员的情况)
 */
-(BOOL)parseOrgCancelAdmin:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    
    if([[body lzNSStringForKey:@"uid"] isEqualToString:[AppUtils GetCurrentUserID]]){
        
        NSString *oid=[body lzNSStringForKey:@"oid"];
        NSString *oeid=[body lzNSStringForKey:@"oeid"];
        /* 被取消企业管理员的身份 */
        if( ![NSString isNullOrEmpty:oid] && [oid isEqualToString:oeid]){
            [[OrgEnterPriseDAL shareInstance] updateEnterpriseWithOEId:oeid isenteradmin:0];
            
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block OrgAdminTempParse * service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_Admin_CancleEnterpriseAdmin, oeid);
            });
        }
        /* 被取消部门管理员 */
        else {
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block OrgAdminTempParse * service = self;
                NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                [dataDic setObject:oid forKey:@"oid"];
                [dataDic setObject:oeid forKey:@"eid"];
                EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_Admin_CancleOrgAdmin, dataDic);
            });
        }
        NSDictionary *postData=@{@"uid":[AppUtils GetCurrentUserID],
                                 @"oeid":oeid};
        [self.appDelegate.lzservice sendToServerQueueForPost:WebApi_Organization routePath:WebApi_Organization_GetOrgProrityByEUId moduleServer:Modules_Default getData:nil postData:postData otherData:@{WebApi_DataSend_Other_Operate:@"OrgCancelAdmin"}];
        
    }
    
    return YES;
}

/**
 *  批量设置管理员(只处理当前用户被设置为管理员的情况)
 */
-(BOOL)parseOrgBatchSetAdmin:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    
    if([[body lzNSMutableArrayForKey:@"adminuids"] containsObject:[AppUtils GetCurrentUserID]]){
        
        NSString *oid = [body lzNSStringForKey:@"oid"];
        NSString *oeid = [body lzNSStringForKey:@"oeid"];
        
        /* 被设置为企业管理员的身份 */
        if( ![NSString isNullOrEmpty:oid] && [oid isEqualToString:oeid]){
            [[OrgEnterPriseDAL shareInstance] updateEnterpriseWithOEId:oeid isenteradmin:1];
            
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block OrgAdminTempParse * service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_Admin_SetEnterpriseAdmin, oeid);
            });
        }
        /* 被设置为部门管理员 */
        else {
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block OrgAdminTempParse * service = self;
                NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                [dataDic setObject:oid forKey:@"oid"];
                [dataDic setObject:oeid forKey:@"eid"];
                EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_Admin_SetOrgAdmin, dataDic);
            });
        }
    }
    
    return YES;
}

/**
 *  设置管理员(只处理当然用户被设置为管理员的情况)
 */
-(BOOL)parseOrgSetAdmin:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    
    if([[body lzNSStringForKey:@"uid"] isEqualToString:[AppUtils GetCurrentUserID]]){
        
        NSString *oid = [body lzNSStringForKey:@"oid"];
        NSString *oeid = [body lzNSStringForKey:@"oeid"];
        
        /* 被设置为企业管理员的身份 */
        if( ![NSString isNullOrEmpty:oid] && [oid isEqualToString:oeid]){
            [[OrgEnterPriseDAL shareInstance] updateEnterpriseWithOEId:oeid isenteradmin:1];
            
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block OrgAdminTempParse * service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_Admin_SetEnterpriseAdmin, oeid);
            });
        }
        /* 被设置为部门管理员 */
        else {
            [[OrgEnterPriseDAL shareInstance] updateEnterpriseWithOEId:oeid isadmin:1];
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block OrgAdminTempParse * service = self;
                NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                [dataDic setObject:oid forKey:@"oid"];
                [dataDic setObject:oeid forKey:@"eid"];
                EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_Admin_SetOrgAdmin, dataDic);
            });
        }
    }
    
    return YES;
}

@end
