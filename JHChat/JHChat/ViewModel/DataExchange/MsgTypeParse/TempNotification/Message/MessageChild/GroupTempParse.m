//
//  ImGroupTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/3/24.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-24
 Version: 1.0
 Description: 群临时通知
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "GroupTempParse.h"
#import "ImGroupUserModel.h"
#import "ImGroupUserDAL.h"
#import "ImGroupDAL.h"
#import "ImGroupModel.H"
#import "ImRecentDAL.h"
#import "SDWebImageManager.h"
#import "FilePathUtil.h"
#import "ImRecentModel.h"

@implementation GroupTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(GroupTempParse *)shareInstance{
    static GroupTempParse *instance = nil;
    if (instance == nil) {
        instance = [[GroupTempParse alloc] init];
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
    
    /* 创建群 */
    if( [handlertype isEqualToString:Handler_Message_Group_Create] ){
        isSendReport = [self parseImGroupCreate:dataDic];
    }
    /* 转让管理员 */
    else if( [handlertype isEqualToString:Handler_Message_Group_AssignAdmin] ){
        isSendReport = [self parseImGroupAssignAdmin:dataDic];
    }
    /* 打开群组 */
    else if( [handlertype isEqualToString:Handler_Message_Group_Open] ){
        isSendReport = [self parseImGroupOpen:dataDic];
    }
    /* 关闭群组 */
    else if( [handlertype isEqualToString:Handler_Message_Group_Close] ){
        isSendReport = [self parseImGroupClose:dataDic];
    }
    /* 修改群免打扰设置 */
    else if( [handlertype isEqualToString:Handler_Message_Group_UpdateDisturb] ){
        isSendReport = [self parseImGroupUpdateDisturb:dataDic];
    }
    /* 修改群聊保存通讯录 */
    else if ([handlertype isEqualToString:Handler_Message_Group_UpdateIsShow]) {
        isSendReport = [self parseImGroupUpdateIsShow:dataDic];
    }
    /* 更新群头像 */
    else if( [handlertype isEqualToString:Handler_Message_Group_UpdateFace] ){
        isSendReport = [self parseImGroupUpdateFace:dataDic];
    }
    /* 删除群组 */
    else if ([handlertype isEqualToString:Handler_Message_Group_DeleteGroup]) {
        isSendReport = [self parseImGroupDeleteGroup:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---群临时通知:%@",dataDic);
    }
    
    return isSendReport;
}

/**
 *  创建群
 */
-(BOOL)parseImGroupCreate:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *groupInfoDic = [[dataDic objectForKey:@"body"] objectForKey:@"group"];

    NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
    
    ImGroupModel *imGroupModel = [[ImGroupModel alloc] init];
    [imGroupModel serializationWithDictionary:groupInfoDic];
    DDLogVerbose(@"------------------11111111");
    /* 解析群组人员信息 */
    NSArray *groupusers = [groupInfoDic lzNSArrayForKey:@"groupuser"];
    for(int j=0;j<groupusers.count;j++){
        NSDictionary *dataUserDic = [groupusers objectAtIndex:j];
        
        ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
        [imGroupUserName serializationWithDictionary:dataUserDic];
        
        [allImGroupUserArr addObject:imGroupUserName];
    }
    if (imGroupModel.imtype==Chat_ContactType_Main_CoGroup) {
        imGroupModel.isnottemp = 0;
    } else {
        imGroupModel.isnottemp = 1;
    }
    
    if(imGroupModel.imtype==Chat_ContactType_Main_ChatGroup){
        imGroupModel.isshowinlist = imGroupModel.isshow;
    } else {
        imGroupModel.isshowinlist = 0;
    }
    
    /* 删除此群组，避免人员出错 */
    [[ImGroupDAL shareInstance] deleteGroupWithIgid:imGroupModel.igid isDeleteImRecent:NO];
    
    [[ImGroupDAL shareInstance] addImGroupModel:imGroupModel];
    [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allImGroupUserArr];
    if (imGroupModel.imtype == Chat_ContactType_Main_CoGroup) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /* 获取群信息 */
            DDLogVerbose(@"------------------22222222222");
            NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
            [postData setObject:imGroupModel.igid forKey:@"groupid"];
            [postData setObject:[NSNumber numberWithInteger:200] forKey:@"pagesize"];
            [self.appDelegate.lzservice sendToServerForPost:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfoByPages moduleServer:Modules_Message getData:nil postData:postData otherData:@{WebApi_DataSend_Other_Operate:@"update_imrecent"}];
//        });
    }
        
    return YES;
}

/**
 *  转让群管理员
 *
 *  @param dataDic 数据源
 */
-(BOOL)parseImGroupAssignAdmin:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
    
    NSString *groupid = [groupDic objectForKey:@"groupid"];
    NSString *createuser = [groupDic objectForKey:@"createuser"];
    
    [[ImGroupDAL shareInstance] updateGroupCreateUser:createuser groupid:groupid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block GroupTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_AssignAdmin, groupid);
    });
        
    return YES;
}


/**
 *  打开群组
 *
 *  @param dataDic 数据源
 */
-(BOOL)parseImGroupOpen:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *groupDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *groupid = [groupDic lzNSStringForKey:@"groupid"];
    
    /* 更改数据库 */
    [[ImGroupDAL shareInstance] updateGroupIsClosed:0 igid:groupid];
    
    NSDictionary *data = @{@"groupid":groupid,
                           @"isclosed":@"0"};
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block GroupTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_OperOrCloseGroup, data);
    });
    
    return YES;
}

/**
 *  关闭群组
 *
 *  @param dataDic 数据源
 */
-(BOOL)parseImGroupClose:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *groupDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *groupid = [groupDic lzNSStringForKey:@"groupid"];
    
    /* 更改数据库 */
    [[ImGroupDAL shareInstance] updateGroupIsClosed:1 igid:groupid];
    
    NSDictionary *data = @{@"groupid":groupid,
                           @"isclosed":@"1"};
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block GroupTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_OperOrCloseGroup, data);
    });
    /* 清除最近联系人 */
    NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
    [getData setObject:groupid forKey:@"recentid"];
    
    /* 删除数据 */
    [[ImRecentDAL shareInstance] updateIsDelContactid:[[NSMutableArray alloc] initWithObjects:groupid, nil]];
    
    if([LZUserDataManager readIsConnectNetWork]){
        [self.appDelegate.lzservice sendToServerForGet:WebApi_Recent
                                             routePath:WebApi_Recent_DeleteRecent
                                          moduleServer:Modules_Message
                                               getData:getData
                                             otherData:nil];
    }
    return YES;
}
/**
 *  删除群组
 *
 *  @param dataDic 数据源
 */
-(BOOL)parseImGroupDeleteGroup:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *groupDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *groupid = [groupDic lzNSStringForKey:@"groupid"];
    
    NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
    [getData setObject:groupid forKey:@"recentid"];
    
    /* 删除数据 */
    [[ImRecentDAL shareInstance] updateIsDelContactid:[[NSMutableArray alloc] initWithObjects:groupid, nil]];
    
    if([LZUserDataManager readIsConnectNetWork]){
        [self.appDelegate.lzservice sendToServerForGet:WebApi_Recent
                                             routePath:WebApi_Recent_DeleteRecent
                                          moduleServer:Modules_Message
                                               getData:getData
                                             otherData:nil];
    }
    
    /* 更改数据库 */
//    [[ImGroupDAL shareInstance] updateGroupIsClosed:1 igid:groupid];
//
//    NSDictionary *data = @{@"groupid":groupid,
//                           @"isclosed":@"1"};
//    /* 在主线程中发送通知 */
//    dispatch_async(dispatch_get_main_queue(), ^{
//        __block GroupTempParse * service = self;
//        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_OperOrCloseGroup, data);
//    });
    
    return YES;
}

/**
 *  修改群免打扰设置
 *
 *  @param dataDic 数据源
 */
-(BOOL)parseImGroupUpdateDisturb:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *bodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *groupid = [bodyDic lzNSStringForKey:@"groupid"];
    if(![[bodyDic allKeys] containsObject:@"disturb"]){
        return YES;
    }
    NSNumber *disturbNum = [bodyDic lzNSNumberForKey:@"disturb"];

    
    [[ImGroupDAL shareInstance] updateDisturbRole:groupid role:disturbNum.integerValue];
    
    __block GroupTempParse * service = self;
    self.appDelegate.lzGlobalVariable.chatDialogID = groupid;
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_Disturb, nil);
    });
    return YES;
}

- (BOOL)parseImGroupUpdateIsShow:(NSMutableDictionary *)dataDic {
    NSMutableDictionary *bodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *groupid = [bodyDic lzNSStringForKey:@"groupid"];
    NSNumber *isshow = [bodyDic lzNSNumberForKey:@"isshow"];
    
    [[ImGroupDAL shareInstance] updateIsSaveToAddress:groupid show:isshow.integerValue];
    __block GroupTempParse * service = self;
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_SaveToAddress, nil);
    });
    return YES;
}

/**
 *  更改群组头像
 *
 *  @param dataDic 数据源
 */
-(BOOL)parseImGroupUpdateFace:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *groupDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *groupid = [groupDic lzNSStringForKey:@"groupid"];
    
    /* 被移除的群，不再处理 */
    ImRecentModel *imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:groupid];
    if(imRecentModel!=nil && imRecentModel.isexistsgroup==0){
        return YES;
    }
    
    ImGroupModel *imGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:groupid];
    if(imGroupModel==nil){
        return YES;
    }
    
    /* 删除内存缓存 */
    NSString *faceImgName = [NSString stringWithFormat:@"%@.jpg",imGroupModel.face];
    SDWebImageManager *sharedSmallManager = [SDWebImageManager sharedManager:[FilePathUtil getFaceIconImageSmallDicAbsolutePath]];
    [sharedSmallManager.imageCache removeImageForKey:faceImgName];
    SDWebImageManager *sharedManager = [SDWebImageManager sharedManager:[FilePathUtil getFaceIconImageDicAbsolutePath]];
    [sharedManager.imageCache removeImageForKey:faceImgName];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block GroupTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_Account_ChangeFace, groupid);
    });
    
    return YES;
}



@end
