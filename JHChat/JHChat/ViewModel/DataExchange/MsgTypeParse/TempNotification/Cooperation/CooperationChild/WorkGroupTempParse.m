//
//  WorkGroupTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-05-04
 Version: 1.0
 Description: 临时消息--协作--工作组
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "WorkGroupTempParse.h"
#import "CoGroupDAL.h"
#import "CoMemberDAL.h"
#import "SDWebImageManager.h"
#import "FilePathUtil.h"

@implementation WorkGroupTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(WorkGroupTempParse *)shareInstance{
    static WorkGroupTempParse *instance = nil;
    if (instance == nil) {
        instance = [[WorkGroupTempParse alloc] init];
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
    
    /*修改群组名字 */
    if([handlertype isEqualToString:Handler_Cooperation_Group_SetName]){
        
        NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
        
        NSString *cid = [body lzNSStringForKey:@"cid"];
        NSString *type = [body lzNSStringForKey:@"cooperationtype"];
        NSDictionary *data = [body lzNSDictonaryForKey:@"data"];
        NSString *name = [data lzNSStringForKey:@"name"];
        if (type &&[type isEqualToString:@"group"]) {
            [[CoGroupDAL shareInstance]updateGroupId:cid withzGroupName:name];
        }
        isSendReport = YES;
		NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",name,@"name", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block WorkGroupTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_WorkGroup_SetName, sendDic);
        });
    }
    /*修改群组状态 */
    else if ([handlertype isEqualToString:Handler_Cooperation_Group_SetState]){
        NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
        NSString *cid = [body lzNSStringForKey:@"cid"];
        NSString *type = [body lzNSStringForKey:@"cooperationtype"];
        NSDictionary *data = [body lzNSDictonaryForKey:@"data"];
        NSNumber *state =[data lzNSNumberForKey:@"state"];
        
        if (type &&[type isEqualToString:@"group"]) {
            [[CoGroupDAL shareInstance]updateGroupId:cid withGroupState:[state integerValue]];
        }
        isSendReport = YES;
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block WorkGroupTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_WorkGroup_SetState, cid);
        });
    }
    
    else if ([handlertype isEqualToString:Handler_Cooperation_Group_SetLogo]){
        NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
        
        NSString *cid = [body lzNSStringForKey:@"cid"];
        NSString *type = [body lzNSStringForKey:@"cooperationtype"];
        NSDictionary *data = [body lzNSDictonaryForKey:@"data"];
        NSString *logo = [data lzNSStringForKey:@"logo"];
        
        if (type &&[type isEqualToString:@"group"]) {
            [[CoGroupDAL shareInstance]updateGroupId:cid withzGrouplogo:logo];
        }
        isSendReport = YES;
        
        NSString *faceImgName = [NSString stringWithFormat:@"%@.jpg",logo];
        /* 删除内存缓存 */
        SDWebImageManager *sharedSmallManager = [SDWebImageManager sharedManager:[FilePathUtil getCooperationWorkGroupIconImageSmallDicAbsolutePath]];
        [sharedSmallManager.imageCache removeImageForKey:faceImgName];
        SDWebImageManager *sharedManager = [SDWebImageManager sharedManager:[FilePathUtil getCooperationWorkGroupIconImageDicAbsolutePath]];
        [sharedManager.imageCache removeImageForKey:faceImgName];

        NSDictionary *sendDict= [NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",logo, @"logo", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block WorkGroupTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_WorkGroup_SetLogo, sendDict);
        });

        
    }
    //设置工作组成员权限
    else if ([handlertype isEqualToString:Handler_Cooperation_Group_SetMemberState]){
        
        NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
        NSString *cid = [body lzNSStringForKey:@"cid"];
//        NSString *type = [body lzNSStringForKey:@"cooperationtype"];
        NSDictionary *data = [body lzNSDictonaryForKey:@"data"];
        NSString *uid = [data lzNSStringForKey:@"uid"];
        NSNumber *utype = [data objectForKey:@"utype"];
        
        [[CoMemberDAL shareInstance]upDataMemberUtypeCooperationId:cid Uid:uid Utype:[utype integerValue]];
        isSendReport = YES;
        __block WorkGroupTempParse * service = self;
        NSDictionary *sendDict =[NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",uid,@"uid", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_WorkGroup_SetMemberState, sendDict);
        });

    }
    
    //设置删除成员
    else if ([handlertype isEqualToString:Handler_Cooperation_Member_Del]){
        
        NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
        NSString *cid = [body lzNSStringForKey:@"cid"];
        NSString *type = [body lzNSStringForKey:@"cooperationtype"];
        NSDictionary *data = [body lzNSDictonaryForKey:@"data"];
        NSString *uid = [data lzNSStringForKey:@"uid"];
        isSendReport = YES;
        __block WorkGroupTempParse * service = self;
        NSDictionary *sendDict =[NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",uid,@"uid", nil];
        
        NSString *curUid = [[LZUserDataManager readCurrentUserInfo]lzNSStringForKey:@"uid"];
        if ([curUid isEqualToString:uid] && [type isEqualToString:@"group"]) {
            [[CoGroupDAL shareInstance]deleteGroupid:cid];
            
        }
        
        [[CoMemberDAL shareInstance]deleteMemberCooperationId:cid Uid:uid];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_WorkGroup_SetQuit, sendDict);
        });
    }
    // 新的成员 同意
    else if ([handlertype isEqualToString:Handler_Cooperation_Member_Add]) {
        NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
        __block WorkGroupTempParse * service = self;
        isSendReport = YES;
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_NewCooperation_NewHandle, body);
        });
    }

    // 新的协作邀请/新的成员申请加入工作组
    else if ([handlertype isEqualToString:Handler_Cooperation_newhandle]) {
        NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
        __block WorkGroupTempParse * service = self;
        isSendReport = YES;
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_NewCooperation_NewHandle, body);
        });
    }
    // 新的协作同意邀请
    else if ([handlertype isEqualToString:Handler_Cooperation_Agree]) {
        NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
        
        NSString *cid = [body lzNSStringForKey:@"cid"];
        NSString *cooperationtype = [body lzNSStringForKey:@"cooperationtype"];
        
        NSDictionary *data = [body lzNSDictonaryForKey:@"data"];
        NSString *uid = [data lzNSStringForKey:@"uid"];
        
        NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",cooperationtype,@"type",uid,@"uid", nil];
        [[CoMemberDAL shareInstance]upDataMemberValidCooperationId:cid Uid:uid Isvalid:YES];
        
        
        __block WorkGroupTempParse * service = self;
        isSendReport = YES;
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_NewCooperation_NewHandle, body);
            
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_WorkGroup_Invite_Agree, sendDic);

        });
    }
    // 新的协作不同意
    else if ([handlertype isEqualToString:Handler_Cooperation_Disagree]) {
        NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
        __block WorkGroupTempParse * service = self;
        isSendReport = YES;
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_NewCooperation_NewHandle, body);
        });
    }

    
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

@end
