//
//  OrgTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/3.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-04-29
 Version: 1.0
 Description: 临时消息--组织机构--组织管理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "OrgTempParse.h"
#import "OrgEnterPriseDAL.h"
#import "UIAlertView+AlertWithMessage.h"
#import "SDWebImageManager.h"
#import "FilePathUtil.h"

@implementation OrgTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgTempParse *)shareInstance{
    static OrgTempParse *instance = nil;
    if (instance == nil) {
        instance = [[OrgTempParse alloc] init];
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
    
    /* 解散组织 */
    if([handlertype isEqualToString:Handler_Organization_Org_Disband]){
        isSendReport = [self parseOrganizationOrgDisband:dataDic];
    }
    /* 创建组织 */
    else if ([handlertype isEqualToString:Handler_Organization_Org_Createenter]){
        isSendReport = [self parseOrganizationOrgCreateenter:dataDic];
    }
    /* 修改组织信息 */
    else if ([handlertype isEqualToString:Handler_Organization_Org_UpdateEnterprise]){
        isSendReport = [self parseOrganizationOrgUpdateEnterprise:dataDic];
    }
    /* 组织下新增部门 */
    else if ([handlertype isEqualToString:Handler_Organization_Org_CreateDepart]){
        isSendReport = [self parseOrganizationOrgCreateDepart:dataDic];
    }
    /* 组织下修改部门信息 */
    else if ([handlertype isEqualToString:Handler_Organization_Org_UpdateDepart]){
        isSendReport = [self parseOrganizationOrgUpdateDepart:dataDic];
    }
    /* 组织下删除部门 */
    else if ([handlertype isEqualToString:Handler_Organization_Org_DeleteDepart]){
        isSendReport = [self parseOrganizationOrgDeleteDepart:dataDic];
    }
    /* 组织下人员调整部门 */
    else if ([handlertype isEqualToString:Handler_Organization_Org_AdjustUser]){
        isSendReport = [self parseOrganizationOrgAdjustUser:dataDic];
    }
    /* 组织下部门上移 */
    else if ([handlertype isEqualToString:Handler_Organization_Org_MoveUp]){
        isSendReport = [self parseOrganizationOrgMoveUp:dataDic];
    }
    /* 组织下部门下移 */
    else if ([handlertype isEqualToString:Handler_Organization_Org_MoveDown]){
        isSendReport = [self parseOrganizationOrgMoveDown:dataDic];
    }
    /* 组织下部门拖拽 */
    else if ([handlertype isEqualToString:Handler_Organization_Org_Drag]){
        isSendReport = [self parseOrganizationOrgDrag:dataDic];
    }
    /* 组织下部门重组(mis48覆盖组织) */
    else if ([handlertype isEqualToString:Handler_Organization_Org_ReconstOrg]){
        isSendReport = [self parseOrganizationOrgReconstOrg:dataDic];
    }
    /* 组织下用户批量调整部门 */
    else if ([handlertype isEqualToString:Handler_Organization_Org_BatadJustUser]){
        isSendReport = [self parseOrganizationOrgBatadJustUser:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

/**
 *  收到解散组织数据
 */
-(BOOL)parseOrganizationOrgDisband:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *oeid=[body lzNSStringForKey:@"oeid"];
    //得到当前解散的组织简称
    NSString *shortname=[[OrgEnterPriseDAL shareInstance]getEnterpriseShortNameByEId:oeid];
    
    //删除本地存储的已解散的组织信息
    [[OrgEnterPriseDAL shareInstance]deleteOrgUserEntetpriseByEId:oeid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![NSString isNullOrEmpty:shortname]){
            self.appDelegate.lzGlobalVariable.isNeedRefreshContactRootVC2=YES;
            
            [UIAlertView alertViewWithTitle:LZGDCommonLocailzableString(@"common_hint") Message:[NSString stringWithFormat:@"%@已被管理员解散",shortname] cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
            
            __block OrgTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgUserDisBandOrgByOeid, body);
        }
    });
        
    return YES;
}

/**
 *  创建组织
 */
-(BOOL)parseOrganizationOrgCreateenter:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    
    /* 获取某个用户在好友的位置，以及返回用户信息 */
    NSMutableDictionary *postData=[NSMutableDictionary dictionary];
    postData[@"uid"]=[body objectForKey:@"uid"];
    postData[@"oeid"]=[body objectForKey:@"oid"];
    [self.appDelegate.lzservice sendToServerForPost:WebApi_Organization routePath:WebApi_Organization_GetOrgsByUserByUidOeid moduleServer:Modules_Default getData:nil postData:postData otherData:nil];
    
    return YES;
}

/**
 *  修改组织信息
 */
-(BOOL)parseOrganizationOrgUpdateEnterprise:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    
    NSMutableDictionary *getData=[NSMutableDictionary dictionary];
    getData[@"oid"]=[body lzNSStringForKey:@"oeid"];
    [self.appDelegate.lzservice sendToServerForGet:WebApi_Organization routePath:WebApi_Organization_GetOrgByOid moduleServer:Modules_Default getData:getData otherData:nil];
    
    return YES;
}

/**
 *  组织下新增部门
 */
-(BOOL)parseOrganizationOrgCreateDepart:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSMutableDictionary *getData=[NSMutableDictionary dictionary];
    getData[@"oid"]=[body lzNSStringForKey:@"oid"];
    [self.appDelegate.lzservice sendToServerForGet:WebApi_Organization routePath:WebApi_Organization_GetOrgByOid moduleServer:Modules_Default getData:getData otherData:@{WebApi_DataSend_Other_Operate:@"newdepartment"}];
    
    return YES;
}

/**
 *  组织下修改部门信息
 */
-(BOOL)parseOrganizationOrgUpdateDepart:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSMutableDictionary *getData=[NSMutableDictionary dictionary];
    getData[@"oid"]=[body lzNSStringForKey:@"oid"];
    [self.appDelegate.lzservice sendToServerForGet:WebApi_Organization routePath:WebApi_Organization_GetOrgByOid moduleServer:Modules_Default getData:getData otherData:@{WebApi_DataSend_Other_Operate:@"updatedepartment"}];
    
    return YES;
}

/**
 *  组织下删除部门
 */
-(BOOL)parseOrganizationOrgDeleteDepart:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 发送EvenBus，通知页面更新 */
        __block OrgTempParse * service2 = self;
        EVENT_PUBLISH_WITHDATA(service2, EventBus_Organization_DeleteDepart, body);
    });
    return YES;
}

/**
 *  组织下人员调整部门
 */
-(BOOL)parseOrganizationOrgAdjustUser:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 发送EvenBus，通知页面更新 */
        __block OrgTempParse * service2 = self;
        EVENT_PUBLISH_WITHDATA(service2, EventBus_Organization_AdjustUser, body);
    });
    return YES;
}

/**
 *  组织下部门上移
 */
-(BOOL)parseOrganizationOrgMoveUp:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 发送EvenBus，通知页面更新 */
        __block OrgTempParse * service2 = self;
        EVENT_PUBLISH_WITHDATA(service2, EventBus_Organization_MoveUp, body);
    });
    return YES;
}

/**
 *  组织下部门下移
 */
-(BOOL)parseOrganizationOrgMoveDown:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 发送EvenBus，通知页面更新 */
        __block OrgTempParse * service2 = self;
        EVENT_PUBLISH_WITHDATA(service2, EventBus_Organization_MoveDown, body);
    });
    return YES;
}

/**
 *  组织下部门拖拽
 */
-(BOOL)parseOrganizationOrgDrag:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 发送EvenBus，通知页面更新 */
        __block OrgTempParse * service2 = self;
        EVENT_PUBLISH_WITHDATA(service2, EventBus_Organization_Drag, body);
    });
    return YES;
}

/**
 *  组织下部门重组(mis48覆盖组织)
 */
-(BOOL)parseOrganizationOrgReconstOrg:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 发送EvenBus，通知页面更新 */
        __block OrgTempParse * service2 = self;
        EVENT_PUBLISH_WITHDATA(service2, EventBus_Organization_ReconstOrg, body);
    });
    return YES;
}

/**
 *  组织下用户批量调整部门
 */
-(BOOL)parseOrganizationOrgBatadJustUser:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 发送EvenBus，通知页面更新 */
        __block OrgTempParse * service2 = self;
        EVENT_PUBLISH_WITHDATA(service2, EventBus_Organization_BatadJustUser, body);
    });
    return YES;
}



@end
