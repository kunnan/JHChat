//
//  FriendTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/4/29.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-04-29
 Version: 1.0
 Description: 临时消息--用户--好友
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "FriendTempParse.h"
#import "AppUtils.h"
#import "UserContactDAL.h"
#import "NSString+IsNullOrEmpty.h"
#import "TagDataDAL.h"
#import "UserContactGroupDAL.h"
#import "UserContactDAL.h"

@implementation FriendTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(FriendTempParse *)shareInstance{
    static FriendTempParse *instance = nil;
    if (instance == nil) {
        instance = [[FriendTempParse alloc] init];
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
    
    /* 新的好友 */
    if([handlertype isEqualToString:Handler_User_Friend_NewFriend]){
        isSendReport = [self parseUserNewFriend:dataDic];
    }
    /* 新的好友同意 */
    else if ([handlertype isEqualToString:Handler_User_Friend_AgreeFriend]){
        isSendReport = [self parseUserAgreeFriend:dataDic];
    }
    /* 新的好友拒绝 */
    else if ([handlertype isEqualToString:Handler_User_Friend_RefuseFriend]){
        isSendReport = [self parseUserRefuseFriend:dataDic];
    }
    /* 添加星标好友 */
    else if ([handlertype isEqualToString:Handler_User_Friend_SetEspecial]){
        isSendReport = [self parseUserSetEspecial:dataDic];
    }
    /* 移除星标好友 */
    else if ([handlertype isEqualToString:Handler_User_Friend_RemoveEspecial]){
        isSendReport = [self parseUserRemoveEspecial:dataDic];
    }
    /* 标签好友调整 */
    else if ([handlertype isEqualToString:Handler_User_Friend_AdjustTag]){
        isSendReport = [self parseUserAdjustTag:dataDic];
    }
    /* 移除好友 */
    else if ([handlertype isEqualToString:Handler_User_Friend_removeFriend]){
        isSendReport = [self parseUserRemoveFriend:dataDic];
    }
    /* 新的好友删除 */
    else if ([handlertype isEqualToString:Handler_User_Friend_DeleteInvite]){
        isSendReport = [self parseUserDeleteInvite:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

/**
 * 新的好友数据通知
 */
-(BOOL)parseUserNewFriend:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *senduid=[body objectForKey:@"senduid"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FriendTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_NewFriend_Notice, senduid);
    });
    return YES;
}

/**
 * 新的好友同意通知
 */
-(BOOL)parseUserAgreeFriend:(NSMutableDictionary *)dataDic{
    
    NSLog(@"%@",[AppUtils GetCurrentUserID]);
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *uid=[body objectForKey:@"uid"];//被同意者ID
    NSString *friendid=[body objectForKey:@"friendid"];//同意者ID
    /* 获取某个用户在好友的位置，以及返回用户信息 */
    NSMutableDictionary *getdata=[NSMutableDictionary dictionary];
    /* 判断当前人ID是否与同意者ID相同，相同get数据传被同意者ID（uid） */
    if([[AppUtils GetCurrentUserID]isEqualToString:friendid]){
        getdata[@"friendid"]=uid;
    }else{
        /* 判断当前人ID是否与同意者ID相同，部相同get数据传同意者ID（friendid） */
        getdata[@"friendid"]=friendid;
    }
    [self.appDelegate.lzservice sendToServerForGet:WebApi_Colleaguelist routePath:WebApi_Colleaguelist_GetAppendUserContact moduleServer:Modules_Default getData:getdata otherData:nil];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactFriendInfoViewController = YES;
        __block FriendTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_AgreeFriend, body);
    });
    return YES;
}

/**
 * 新的好友拒绝通知
 */
-(BOOL)parseUserRefuseFriend:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *friendid=[body lzNSStringForKey:@"friendid"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FriendTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_RefuseFriend, friendid);
    });
    return YES;
}

/**
 * 添加星标好友通知
 */
-(BOOL)parseUserSetEspecial:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *friendid=[body lzNSStringForKey:@"friendid"];
    [[UserContactDAL shareInstance] setContactEspeciallyValueByCtId:true ctId:friendid];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 刷新我的好友页面 */
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactFriendListVC2 = YES;
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactFriendInfoViewController = YES;
        __block FriendTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_SetEspecial, friendid);
    });
    return YES;
}

/**
 * 移除星标好友通知
 */
-(BOOL)parseUserRemoveEspecial:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *friendid=[body lzNSStringForKey:@"friendid"];
    [[UserContactDAL shareInstance] setContactEspeciallyValueByCtId:false ctId:friendid];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 刷新我的好友页面 */
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactFriendListVC2 = YES;
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactFriendInfoViewController = YES;
        __block FriendTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_RemoveEspecial, friendid);
    });
    return YES;
}

/**
 * 标签好友调整通知
 */
-(BOOL)parseUserAdjustTag:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *tagid=[body lzNSStringForKey:@"tagid"];
    NSArray *addfriendlist=[body lzNSArrayForKey:@"addfriendlist"];
    NSArray *removefriendlist=[body lzNSArrayForKey:@"removefriendlist"];
    NSMutableArray<TagDataModel *> *tmpModels=[[NSMutableArray alloc]init];
    if([addfriendlist isKindOfClass:[NSArray class]]){
        for(int i=0;i<addfriendlist.count;i++){
            NSString *frienduid=[addfriendlist objectAtIndex:i];
            NSString *ucid = [[UserContactDAL shareInstance] getUserContactByUId:frienduid].ucid;
            TagDataModel *tmpModel=[[TagDataModel alloc]init];
            tmpModel.tdid=[LZUtils CreateGUID];
            tmpModel.taid=nil;
            tmpModel.name=nil;
            tmpModel.ttid=@"contactgroup";
            tmpModel.dataid=nil;
            tmpModel.oid=nil;
            tmpModel.uid=nil;//按照正常逻辑，这里应当将用户Id存到这里来，但是服务器返回的是 ctid，所有先不存
            tmpModel.dataextend1=tagid;//将标签id存到这里
            tmpModel.dataextend2=ucid;//将ctid存到这里
            [tmpModels addObject:tmpModel];
        }
        [[TagDataDAL shareInstance ]addDataWithTagDataArray:tmpModels];
    }
    if([removefriendlist isKindOfClass:[NSArray class]]){
        for(int i=0;i<removefriendlist.count;i++){
            NSString *frienduid=[removefriendlist objectAtIndex:i];
            NSString *ucid = [[UserContactDAL shareInstance] getUserContactByUId:frienduid].ucid;
            [[TagDataDAL shareInstance]deleteByDataExtend2Value:ucid DataExterend1Value:tagid];
        }
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactFriendLabelListViewController2 = YES;
    });
    
    return YES;
}

/**
 * 移除好友通知
 */
-(BOOL)parseUserRemoveFriend:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *receiveduid=[body lzNSStringForKey:@"receiveduid"];//被删除人ID
    NSString *senduid=[body lzNSStringForKey:@"senduid"];//本人ID
    /* 判断当前人ID是否相同 */
    if([[AppUtils GetCurrentUserID]isEqualToString:senduid]){
        [[UserContactDAL shareInstance] deleteUserContactByCTId:receiveduid];
    }else{
        [[UserContactDAL shareInstance] deleteUserContactByCTId:senduid];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactFriendListVC2 = YES;
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactFriendInfoViewController = YES;
    });
    
    return YES;
}

/**
 * 新的好友删除通知
 */
-(BOOL)parseUserDeleteInvite:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
//    NSString *friendid=[body lzNSStringForKey:@"friendid"];
    
    NSString *uiid = [body lzNSStringForKey:@"uiid"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FriendTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_DeleteInvite, uiid);
    });
    return YES;
}


@end
