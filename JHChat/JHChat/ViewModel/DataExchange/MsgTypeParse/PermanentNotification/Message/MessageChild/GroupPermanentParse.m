//
//  GroupPermanentParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/7/6.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-07-06
 Version: 1.0
 Description: 持久消息--群持久通知
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "GroupPermanentParse.h"
#import "SDWebImageManager.h"
#import "FilePathUtil.h"
#import "ImGroupDAL.h"
#import "ImGroupModel.h"
#import "ImRecentDAL.h"
#import "ImRecentModel.h"
#import "ImGroupUserDAL.h"

@implementation GroupPermanentParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(GroupPermanentParse *)shareInstance{
    static GroupPermanentParse *instance = nil;
    if (instance == nil) {
        instance = [[GroupPermanentParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析持久通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    
    /* 更新群头像 */
    if( [handlertype isEqualToString:Handler_Message_Group_UpdateFace] ){
        isSendReport = [self parseImGroupUpdateFace:dataDic];
    }    
    /* 添加群成员 */
    else if( [handlertype hasSuffix:Handler_Message_Group_AddUser] ){
        isSendReport = [self parseImGroupAdduser:dataDic];
    }
    /* 移除群成员 */
    else if( [handlertype isEqualToString:Handler_Message_Group_RemoveUser] ){
        isSendReport = [self parseImGroupRemoveuser:dataDic];
    }
    /* 成员退出群组 */
    else if( [handlertype isEqualToString:Handler_Message_Group_QuitGroup] ){
        isSendReport = [self parseImGroupQuitGroup:dataDic];
    }
    /* 修改群名称 */
    else if( [handlertype isEqualToString:Handler_Message_Group_ModifyName] ){
        isSendReport = [self parseImGroupModifyName:dataDic];
    }
    /* 打开群组 */
    else if( [handlertype isEqualToString:Handler_Message_Group_Open] ){
        isSendReport = [self parseImGroupOpen:dataDic];
    }
    /* 关闭群组 */
    else if( [handlertype isEqualToString:Handler_Message_Group_Close] ){
        isSendReport = [self parseImGroupClose:dataDic];
    }
    /* 删除群组 */
    else if ([handlertype isEqualToString:Handler_Message_Group_DeleteGroup]) {
        isSendReport = [self parseImGroupDeleteGroup:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---群持久通知:%@",dataDic);
    }
    
    return isSendReport;
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
        __block GroupPermanentParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_Account_ChangeFace, groupid);
    });
    
    return YES;
}

/**
 *  添加群成员
 */
-(BOOL)parseImGroupAdduser:(NSMutableDictionary *)dataDic{
    NSString *currentUserID = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    BOOL isGetGroupInfo = NO;
    
    NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
    DDLogVerbose(@"------------------4444444");
    NSString *groupid = [groupDic objectForKey:@"groupid"];
    NSString *groupName = [groupDic objectForKey:@"groupname"];
    NSMutableArray *addUser = [groupDic objectForKey:@"adduser"];
    
    /* 添加群组人员 */
    NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
    for(int j=0;j<addUser.count;j++){
        NSDictionary *dataUserDic = [addUser objectAtIndex:j];
        
        ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
        [imGroupUserName serializationWithDictionary:dataUserDic];
        
        if( [currentUserID isEqualToString:imGroupUserName.uid] ){
            isGetGroupInfo = YES;
            break;
        }
        
        [allImGroupUserArr addObject:imGroupUserName];
    }
    
    /* 当前人被加入群组 */
    if(isGetGroupInfo){
        /* 更新ImRecent表 */
        [[ImRecentDAL shareInstance] updateIsExistsGroupWithIgid:groupid isexistsgroup:1];
        
        /* 获取群信息 */
        //        NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
        //        [getData setObject:groupid forKey:@"groupid"];
        //        [self.appDelegate.lzservice sendToServerForGet:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfo moduleServer:Modules_Message getData:getData otherData:@{WebApi_DataSend_Other_Operate:@"update_imrecent"}];
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setObject:groupid forKey:@"groupid"];
        [postData setObject:[NSNumber numberWithInteger:200] forKey:@"pagesize"];
        [self.appDelegate.lzservice sendToServerForPost:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfoByPages moduleServer:Modules_Message getData:nil postData:postData otherData:@{WebApi_DataSend_Other_Operate:@"update_imrecent"}];
        DDLogVerbose(@"------------------66666666");
    }
    /* 其它人被加入群组 */
    else {
        
        
        DDLogVerbose(@"------------------5555555");
        if([[ImGroupDAL shareInstance] checkIsLoadAllUser:groupid]){
            [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allImGroupUserArr];
        }
        else {
            DDLogVerbose(@"本地人员未加载完，不添加人员");
        }
        [[ImGroupDAL shareInstance] updateGroupUserForAddCount:allImGroupUserArr.count igid:groupid];
        
        if( ![NSString isNullOrEmpty:groupName] ){
            /* 更新群组名称 */
            [[ImGroupDAL shareInstance] updateGroupNameWithIgid:groupid groupName:groupName isRename:NO];
        }
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block GroupPermanentParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_AddMember, groupid);
        });
    }
    
    return YES;
}
/**
 *  移除群成员
 */
-(BOOL)parseImGroupRemoveuser:(NSMutableDictionary *)dataDic{
    NSString *currentUserID = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    BOOL isRemoveMySelf = NO;
    
    NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
    
    NSString *groupid = [groupDic objectForKey:@"groupid"];
    NSString *groupName = [groupDic objectForKey:@"groupname"];
    NSMutableArray *removeuserArr = [groupDic objectForKey:@"removeuser"];
    
    /* 移除的群组人员 */
    NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
    for(int j=0;j<removeuserArr.count;j++){
        NSString *uid = [removeuserArr objectAtIndex:j];
        
        if( [currentUserID isEqualToString:uid] ){
            isRemoveMySelf = YES;
            break;
        }
        
        [allImGroupUserArr addObject:uid];
    }
    
    if( ![NSString isNullOrEmpty:groupName] ){
        /* 更新群组名称 */
        [[ImGroupDAL shareInstance] updateGroupNameWithIgid:groupid groupName:groupName isRename:NO];
    }
    
    /* 当前人被移除群组 */
    if(isRemoveMySelf){
        /* 更新ImRecent表 */
        [[ImRecentDAL shareInstance] updateIsExistsGroupWithIgid:groupid isexistsgroup:0];
        //        [[ImGroupDAL shareInstance] deleteGroupWithIgid:groupid isDeleteImRecent:YES];
        /* 发送webapi--删除最近联系人 */
        NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
        [getData setObject:groupid forKey:@"recentid"];
        [self.appDelegate.lzservice sendToServerForGet:WebApi_Recent
                                             routePath:WebApi_Recent_DeleteRecent
                                          moduleServer:Modules_Message
                                               getData:getData
                                             otherData:nil];
    }
    /* 其它人被移除群组 */
    else {
        [[ImGroupUserDAL shareInstance] deleteGroupUserWithIgid:groupid uidArr:allImGroupUserArr];
        /* 减去群组中的人员数量 */
        ImGroupModel *imGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:groupid];
        if( imGroupModel.usercount<=allImGroupUserArr.count){
            [[ImGroupDAL shareInstance] updateGroupUserCount:0 igid:groupid];
        }
        else {
            [[ImGroupDAL shareInstance] updateGroupUserForReduceCount:allImGroupUserArr.count igid:groupid];
        }
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block GroupPermanentParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_RemoveMember, groupid);
        });
    }
    
    return YES;
}



/**
 *  成员退出群组
 */
-(BOOL)parseImGroupQuitGroup:(NSMutableDictionary *)dataDic{
    NSString *currentUserID = [AppUtils GetCurrentUserID];
    
    NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
    
    NSString *groupid = [groupDic objectForKey:@"groupid"];
    NSString *uid = [groupDic objectForKey:@"uid"];
    NSString *groupName = [groupDic objectForKey:@"groupname"];
    
    
    __block GroupPermanentParse * service = self;
    /* 当前人退出了群组 */
    if( [currentUserID isEqualToString:uid] ){
        //        /* 删除数据 */
        //        [[ImRecentDAL shareInstance] updateIsDelContactid:[[NSMutableArray alloc] initWithObjects:groupid, nil]];
        //        /* 发送webapi--删除最近联系人 */
        //        NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
        //        [getData setObject:groupid forKey:@"recentid"];
        //        [self.appDelegate.lzservice sendToServerForGet:WebApi_Recent
        //                                             routePath:WebApi_Recent_DeleteRecent
        //                                          moduleServer:Modules_Message
        //                                               getData:getData
        //                                             otherData:nil];
        
        [[ImGroupDAL shareInstance] deleteGroupWithIgid:groupid isDeleteImRecent:YES];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            self.appDelegate.lzGlobalVariable.chatDialogID = groupid;
            self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
            EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_DeleteGroup, groupid);
        });
    }
    /* 其它人退出了群组 */
    else {
        [[ImGroupUserDAL shareInstance] deleteGroupUserWithIgid:groupid uid:uid];
        /* 减去群组中的人员数量 */
        ImGroupModel *imGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:groupid];
        if( imGroupModel.usercount<=1){
            [[ImGroupDAL shareInstance] updateGroupUserCount:0 igid:groupid];
        }
        else {
            [[ImGroupDAL shareInstance] updateGroupUserForReduceCount:1 igid:groupid];
        }
        
        if( ![NSString isNullOrEmpty:groupName] ){
            /* 更新群组名称 */
            [[ImGroupDAL shareInstance] updateGroupNameWithIgid:groupid groupName:groupName isRename:NO];
        }
    }
    
    return YES;
}

/**
 *  修改群名称
 *
 *  @param dataDic 数据源
 */
-(BOOL)parseImGroupModifyName:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
    
    NSString *groupid = [groupDic objectForKey:@"groupid"];
    NSString *groupname = [groupDic objectForKey:@"groupname"];
    
    /* 被移除的群，不再处理 */
    ImRecentModel *imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:groupid];
    if(imRecentModel!=nil && imRecentModel.isexistsgroup==0){
        return YES;
    }
    
    if(![NSString isNullOrEmpty:groupname]){
        [[ImGroupDAL shareInstance] updateGroupNameWithIgid:groupid groupName:groupname isRename:YES];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block GroupPermanentParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_ModifyGroupName, groupid);
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
        __block GroupPermanentParse * service = self;
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
        __block GroupPermanentParse * service = self;
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
@end
