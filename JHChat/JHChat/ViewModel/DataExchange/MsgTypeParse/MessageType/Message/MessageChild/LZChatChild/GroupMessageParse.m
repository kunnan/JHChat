//
//  GroupMessageParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/3/24.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-24
 Version: 1.0
 Description: 群系统消息
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "GroupMessageParse.h"
#import "imGroupModel.h"
#import "ImGroupUserModel.h"
#import "ImGroupDAL.h"
#import "ImGroupUserDAL.h"
#import "ImRecentModel.h"
#import "ImRecentDAL.h"
#import "AppDateUtil.h"
#import "UserDAL.h"
#import "ImChatLogModel.h"
#import "NSDictionary+DicSerial.h"
#import "ImChatLogDAL.h"
#import "UserViewModel.h"
#import "MsgTemplateViewModel.h"

static NSString * const Result_IsSaveSuccess = @"issavesuccess";
static NSString * const Result_IsSendReport = @"issendreport";

@implementation GroupMessageParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(GroupMessageParse *)shareInstance{
    static GroupMessageParse *instance = nil;
    if (instance == nil) {
        instance = [[GroupMessageParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析消息数据
 *
 *  @param dataDic 数据
 */
-(NSDictionary *)parse:(NSMutableDictionary *)dataDic{
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    NSDictionary *result = nil;//[[NSDictionary alloc] init];
    
    /* 自己刚被加入新创建的群组 */
    if( [handlertype isEqualToString:Handler_Message_LZChat_SR_CreateGroup] ){
        result = [self parseImCreateGroup:dataDic];
    }
    /* 添加群成员 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_Group_AddUser] ){
        result = [self parseImGroupAddUser:dataDic];
    }
    /* 移除群成员 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_RemoveUser] ){
        result = [self parseImGroupRemoveUser:dataDic];
    }
    /* 成员退出群组 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_QuitGroup] ){
        result = [self parseImGroupUserQuitGroup:dataDic];
    }
    /* 转让管理员 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_AssignAdmin] ){
        result = [self parseImGroupAssignAdmin:dataDic];
    }
    /* 修改群名称 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_ModifyGroupName] ){
        result = [self parseImGroupModifyName:dataDic];
    }
    /* 二维码扫描 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_JoinGroup] ){
        result = [self parseImGroupJoinGroup:dataDic];
    }
    /* 添加好友 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_AddFriend] ){
        result = [self parseImGroupAddFriend:dataDic];
    }
    else {
//        DDLogError(@"----------------收到未处理---群系统消息:%@",dataDic);
        /* 保存系统消息 */
        NSString *systemMsg = @"";
        systemMsg =  [dataDic lzNSStringForKey:@"content"];
        [dataDic setObject:systemMsg forKey:@"systemmsg"];
        return [self commonSaveSystemMsgInfo:dataDic isRefreshMessageRootVC:YES];
    }
    
    return result;
}

/**
 *  创建群时，被加入群组(其它人创建了群，接收第一条消息时，会接收此通知)
 *
 *  @param dataDic 数据源
 */
-(NSDictionary *)parseImCreateGroup:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *groupInfoDic = [[dataDic objectForKey:@"body"] objectForKey:@"group"];
    NSString *createuser = [groupInfoDic objectForKey:@"createuser"];
    
    NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
    
    ImGroupModel *imGroupModel = [[ImGroupModel alloc] init];
    [imGroupModel serializationWithDictionary:groupInfoDic];
    
    /* 解析群组人员信息 */
    NSArray *groupusers = [groupInfoDic lzNSArrayForKey:@"groupuser"];
    for(int j=0;j<groupusers.count;j++){
        NSDictionary *dataUserDic = [groupusers objectAtIndex:j];
        
        ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
        [imGroupUserName serializationWithDictionary:dataUserDic];
        
        [allImGroupUserArr addObject:imGroupUserName];
    }
    /* 删除此群组，避免人员出错 */
    BOOL isSaveSuccess = [[ImGroupDAL shareInstance] deleteGroupWithIgid:imGroupModel.igid isDeleteImRecent:NO];
    if(LeadingCloud_MsgParseSerial && !isSaveSuccess){
        DDLogVerbose(@"GroupMessageParse--parseImCreateGroup:删除此群组信息中失败。[消息解析失败]");
        return @{Result_IsSaveSuccess:@"0"};
    }
    
    imGroupModel.isnottemp = 1;
    if(imGroupModel.imtype==Chat_ContactType_Main_ChatGroup){
        imGroupModel.isshowinlist = imGroupModel.isshow;
    } else {
        imGroupModel.isshowinlist = 0;
    }
    isSaveSuccess = [[ImGroupDAL shareInstance] addImGroupModel:imGroupModel];
    if(LeadingCloud_MsgParseSerial && !isSaveSuccess){
        DDLogVerbose(@"GroupMessageParse--parseImCreateGroup:保存群信息中失败。[消息解析失败]");
        return @{Result_IsSaveSuccess:@"0"};
    }
    
    isSaveSuccess = [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allImGroupUserArr];
    if(LeadingCloud_MsgParseSerial && !isSaveSuccess){
        DDLogVerbose(@"GroupMessageParse--parseImCreateGroup:保存群人员信息中失败。[消息解析失败]");
        return @{Result_IsSaveSuccess:@"0"};
    }
    
    /* 向最近联系人中添加 */
    ImRecentModel *imRecentModel = [[ImRecentModel alloc] init];
    imRecentModel.irid = [LZUtils CreateGUID];
    imRecentModel.contactid = imGroupModel.igid;
    imRecentModel.contacttype = Chat_ContactType_Main_ChatGroup;
    imRecentModel.contactname = imGroupModel.name;
    imRecentModel.face = imGroupModel.face;
    
    imRecentModel.lastdate = [AppDateUtil GetCurrentDate];
    imRecentModel.lastmsg = @""; //@"群组创建成功";
    imRecentModel.lastmsguser = @"";
    imRecentModel.lastmsgusername = @"";
    imRecentModel.badge = 0;
    imRecentModel.isexistsgroup = 1;
    
    imRecentModel.showmode = [dataDic lzNSNumberForKey:@"sendmode"].integerValue;
    imRecentModel.lastmsgid = [dataDic lzNSStringForKey:@"msgid"];
    imRecentModel.parsetype = [dataDic lzNSNumberForKey:@"parsetype"].integerValue;
    imRecentModel.bkid = [dataDic lzNSStringForKey:@"bkid"];
    
    /* 处理业务会话（特殊处理） */
    NSInteger totype = [dataDic lzNSNumberForKey:@"totype"].integerValue;
    if(totype == Chat_ToType_Five
       || totype == Chat_ToType_Six){
        ImMsgTemplateModel *imMsgTemplateModel = nil;
        if(totype == Chat_ToType_Five){
            imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:Chat_ContactType_Second_OutWardlBusiness];
            if(imRecentModel.parsetype==0){
                imRecentModel.contactid = Chat_ContactID_Five;
            } else {
                imRecentModel.contactid = [NSString stringWithFormat:@"%ld.%@",Chat_ToType_Five,imGroupModel.igid];
            }
            imRecentModel.contacttype = Chat_ContactType_Main_App_Seven;
        }
        if(totype == Chat_ToType_Six){
            imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:Chat_ContactType_Second_InternalBusiness];
            if(imRecentModel.parsetype==0){
                imRecentModel.contactid = Chat_ContactID_Six;
            } else {
                imRecentModel.contactid = [NSString stringWithFormat:@"%ld.%@",Chat_ToType_Six,imGroupModel.igid];
            }
            imRecentModel.contacttype = Chat_ContactType_Main_App_Eight;
        }
        
        imRecentModel.contactname = imMsgTemplateModel.name;
        imRecentModel.face = imMsgTemplateModel.icon;
        imRecentModel.isexistsgroup = 1;
    }
    
    isSaveSuccess = [[ImRecentDAL shareInstance] addImRecentWithModel:imRecentModel isAddIfExists:NO];
    if(LeadingCloud_MsgParseSerial && !isSaveSuccess){
        DDLogVerbose(@"GroupMessageParse--parseImCreateGroup:保存最近联系人信息。[消息解析失败]");
        return @{Result_IsSaveSuccess:@"0"};
    }
    
    /* 保存系统消息 */
    NSString *systemMsg = @"";
    systemMsg =  [dataDic lzNSStringForKey:@"content"];
    if([NSString isNullOrEmpty:systemMsg]){
        if([createuser isEqualToString:[AppUtils GetCurrentUserID]]){
            NSString *addUserNames = @"";
            for(int i=0;i<allImGroupUserArr.count;i++){
                ImGroupUserModel *imGroupUserModel = [allImGroupUserArr objectAtIndex:i];
                
                if(![NSString isNullOrEmpty:addUserNames]){
                    addUserNames = [addUserNames stringByAppendingString:@","];
                }
                addUserNames = [addUserNames stringByAppendingString:imGroupUserModel.username];
            }
            if(addUserNames.length>0){
                systemMsg = [NSString stringWithFormat:@"-- %@ 加入群聊",addUserNames];
            }
        }
        else {
            NSString *groupAdmin = @"";
            NSString *addUserNames = @"你";
            for(int i=0;i<allImGroupUserArr.count;i++){
                ImGroupUserModel *imGroupUserModel = [allImGroupUserArr objectAtIndex:i];
                if([imGroupUserModel.uid isEqualToString:createuser]){
                    groupAdmin = imGroupUserModel.username;
                } else if( ![imGroupUserModel.uid isEqualToString:[AppUtils GetCurrentUserID]]){
                    addUserNames = [addUserNames stringByAppendingString:@","];
                    addUserNames = [addUserNames stringByAppendingString:imGroupUserModel.username];
                }
            }
            if(addUserNames.length>0){
                systemMsg = [NSString stringWithFormat:@"--%@ 邀请 %@ 加入群聊",groupAdmin,addUserNames];
            }
        }
    }
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    return [self commonSaveSystemMsgInfo:dataDic isRefreshMessageRootVC:YES];
}

/**
 *  添加人员
 *
 *  @param dataDic 数据源
 */
-(NSDictionary *)parseImGroupAddUser:(NSMutableDictionary *)dataDic{
    /* 保存系统消息 */
    NSString *systemMsg = @"";
    systemMsg =  [dataDic lzNSStringForKey:@"content"];
    if([NSString isNullOrEmpty:systemMsg]){
        NSString *currentUserID = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
        BOOL isMe = NO;
        BOOL isHaveMe = NO;
        
        NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
        
        NSString *groupid = [groupDic objectForKey:@"groupid"];
        NSString *uid = [groupDic objectForKey:@"uid"];
        NSString *uname = [groupDic lzNSStringForKey:@"uname"];
        NSMutableArray *addUser = [groupDic objectForKey:@"adduser"];
        
        /* 添加群组人员 */
        NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
        NSString *addUserNames = @"";
        for(int j=0;j<addUser.count;j++){
            NSDictionary *dataUserDic = [addUser objectAtIndex:j];
            
            ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
            [imGroupUserName serializationWithDictionary:dataUserDic];
            
            if( [currentUserID isEqualToString:imGroupUserName.uid] ){
                isHaveMe = YES;
                break;
            }
            
            if(![NSString isNullOrEmpty:addUserNames]){
                addUserNames = [addUserNames stringByAppendingString:@","];
            }
            addUserNames = [addUserNames stringByAppendingString:imGroupUserName.username];
            
            [allImGroupUserArr addObject:imGroupUserName];
        }
            
        
        if([NSString isNullOrEmpty:uid]){
            isMe = NO;
        }
        else {
            isMe  = [uid isEqualToString:[AppUtils GetCurrentUserID]];
        }
        
        ImGroupModel *imGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:groupid];
        /* 从网络同步请求群信息 */
        if(imGroupModel == nil){
            imGroupModel = [[[UserViewModel alloc] init]  getImGroupInfoAsynMode:groupid];
        }
        
        /* 任务、工作组、部门、企业等非聊天群的处理 */
        if(imGroupModel.imtype == Chat_ContactType_Main_CoGroup){
            NSString *groupName = @"";
            if(imGroupModel!=nil){
                groupName = imGroupModel.name;
            }
    //        NSString *addUserName = addUser.count>=1 ? [[addUser objectAtIndex:0] objectForKey:@"username"] : @"";
    //        systemMsg = [NSString stringWithFormat:@"欢迎%@加入%@",addUserName,groupName];
            
            NSString *addUserNames = @"";
            for(int i=0;i<addUser.count;i++){
                NSString *uName = [[addUser objectAtIndex:i] lzNSStringForKey:@"username"];
                if(![NSString isNullOrEmpty:uName]){
                    if(![NSString isNullOrEmpty:addUserNames]){
                        addUserNames = [addUserNames stringByAppendingString:@","];
                    }
                    addUserNames = [addUserNames stringByAppendingString:uName];
                }
            }
            systemMsg = [NSString stringWithFormat:@"--欢迎%@加入%@",addUserNames,groupName];
        }
        /* 当前人邀请其他人加入 */
        else if(isMe){
            if(addUserNames.length>0){
                systemMsg = [NSString stringWithFormat:@"--你邀请 %@ 加入群聊",addUserNames];
            }
        }
        /* 其它人邀请加入 */
        else {
            NSString *inviteUser = @"";
            if(![NSString isNullOrEmpty:uname]){
                inviteUser = uname;
            } else {
                UserModel *inviteUserModel = [[UserDAL shareInstance] getUserModelForNameAndFace:uid];
                /* 从网络同步请求此人信息 */
                if(inviteUserModel==nil){
                    inviteUserModel = [[[UserViewModel alloc] init] getUserInfoAsynMode:uid];
                }
                if(inviteUserModel!=nil){
                    inviteUser = inviteUserModel.username;
                }
            }
            if(isHaveMe){
                systemMsg = [NSString stringWithFormat:@"--%@邀请你加入群聊",inviteUser];
            }
            else {
                systemMsg = [NSString stringWithFormat:@"--%@邀请 %@ 加入群聊",inviteUser,addUserNames];
            }
        }
    }
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    return [self commonSaveSystemMsgInfo:dataDic isRefreshMessageRootVC:YES];

//    if(!isHaveMe){
//        __block GroupMessageParse * service = self;
//        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_AddMember, groupid);
//    }
}

/**
 *  移除人员
 *
 *  @param dataDic 数据源
 */
-(NSDictionary *)parseImGroupRemoveUser:(NSMutableDictionary *)dataDic{
    /* 保存系统消息 */
    NSString *systemMsg = @"";
    systemMsg =  [dataDic lzNSStringForKey:@"content"];
    if([NSString isNullOrEmpty:systemMsg]){
        NSString *currentUserID = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
        BOOL isRemoveMySelf = NO;
        
        NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
        
    //    NSString *groupid = [groupDic objectForKey:@"groupid"];
    //    NSString *groupName = [groupDic objectForKey:@"groupname"];
        NSMutableArray *removeuserArr = [groupDic objectForKey:@"removeuser"];
        
        /* 移除的群组人员 */
        NSString *removeUserNames = @"";
        for(int j=0;j<removeuserArr.count;j++){
            NSString *uid = [removeuserArr objectAtIndex:j];
            
            if( [currentUserID isEqualToString:uid] ){
                isRemoveMySelf = YES;
                break;
            }
            
            UserModel *removeUserModel = [[UserDAL shareInstance] getUserModelForNameAndFace:uid];
            /* 从网络同步请求此人信息 */
            if(removeUserModel==nil){
                removeUserModel = [[[UserViewModel alloc] init] getUserInfoAsynMode:uid];
            }
            if(removeUserModel!=nil){
                if(![NSString isNullOrEmpty:removeUserNames]){
                    removeUserNames = [removeUserNames stringByAppendingString:@","];
                }
                removeUserNames = [removeUserNames stringByAppendingString:removeUserModel.username];
            }
        }
        
        /* 保存系统消息 */
        NSString *changeInfo = @"";
        NSString *uid = [groupDic objectForKey:@"uid"];
        NSString *uname = [groupDic lzNSStringForKey:@"uname"];
        if(![uid isEqualToString:[AppUtils GetCurrentUserID]]){
            if(![NSString isNullOrEmpty:uname]){
                changeInfo = uname;
            } else {
                UserModel *theUserModel = [[UserDAL shareInstance] getUserModelForNameAndFace:uid];
                /* 从网络同步请求此人信息 */
                if(theUserModel==nil){
                    theUserModel = [[[UserViewModel alloc] init] getUserInfoAsynMode:uid];
                }
                if(theUserModel!=nil){
                    changeInfo = theUserModel.username;
                }
            }
        } else {
            changeInfo = @"你";
        }
        systemMsg = [NSString stringWithFormat:@"--%@将%@移出群聊",changeInfo,removeUserNames];
        if(isRemoveMySelf){
            systemMsg = [NSString stringWithFormat:@"--你被 %@ 移出群聊",changeInfo];
        }
    }
    
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    return [self commonSaveSystemMsgInfo:dataDic isRefreshMessageRootVC:YES];
    
//    __block GroupMessageParse * service = self;    
//    EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_RemoveMember, groupid);
}

/**
 *  用户退出群组
 *
 *  @param dataDic 数据源
 */
-(NSDictionary *)parseImGroupUserQuitGroup:(NSMutableDictionary *)dataDic{
    /* 保存系统消息 */
    NSString *systemMsg = @"";
    systemMsg =  [dataDic lzNSStringForKey:@"content"];
    if([NSString isNullOrEmpty:systemMsg]){
        NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];

        NSString *uid = [groupDic objectForKey:@"uid"];
        NSString *uname = [groupDic lzNSStringForKey:@"uname"];
        
        NSString *changeInfo = @"";
        if(![NSString isNullOrEmpty:uname]){
            changeInfo = uname;
        } else {
            /* 保存系统消息 */
            UserModel *theUserModel = [[UserDAL shareInstance] getUserModelForNameAndFace:uid];
            /* 从网络同步请求此人信息 */
            if(theUserModel==nil){
                theUserModel = [[[UserViewModel alloc] init] getUserInfoAsynMode:uid];
            }
            changeInfo = theUserModel.username;
        }
        systemMsg = [NSString stringWithFormat:@"--%@退出了群聊",changeInfo];
    }
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    return [self commonSaveSystemMsgInfo:dataDic isRefreshMessageRootVC:YES];
}

/**
 *  转让群管理员
 *
 *  @param dataDic 数据源
 */
-(NSDictionary *)parseImGroupAssignAdmin:(NSMutableDictionary *)dataDic{
    /* 保存系统消息 */
    NSString *systemMsg = @"";
    systemMsg =  [dataDic lzNSStringForKey:@"content"];
    if([NSString isNullOrEmpty:systemMsg]){
        NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
    //    NSString *groupid = [groupDic objectForKey:@"groupid"];

        NSString *createuser = [groupDic objectForKey:@"createuser"];

        /* 保存系统消息 */
        NSString *changeInfo = @"你";
        if(![createuser isEqualToString:[AppUtils GetCurrentUserID]]){
            UserModel *theUserModel = [[UserDAL shareInstance] getUserModelForNameAndFace:createuser];
            /* 从网络同步请求此人信息 */
            if(theUserModel==nil){
                theUserModel = [[[UserViewModel alloc] init] getUserInfoAsynMode:createuser];
            }
            changeInfo = theUserModel.username;
        }
        systemMsg = [NSString stringWithFormat:@"--%@已成为新群主",changeInfo];
    }
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    return [self commonSaveSystemMsgInfo:dataDic isRefreshMessageRootVC:YES];
    
//    __block GroupMessageParse * service = self;
//    EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_AssignAdmin, groupid);
}

/**
 *  修改群名称
 *
 *  @param dataDic 数据源
 */
-(NSDictionary *)parseImGroupModifyName:(NSMutableDictionary *)dataDic{
    /* 保存系统消息 */
    NSString *systemMsg = @"";
    systemMsg =  [dataDic lzNSStringForKey:@"content"];
    if([NSString isNullOrEmpty:systemMsg]){
        NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
        
    //    NSString *groupid = [groupDic objectForKey:@"groupid"];
        NSString *groupname = [groupDic objectForKey:@"groupname"];
        
        /* 保存系统消息 */
        NSString *changeInfo = @"你";
        NSString *uid = [groupDic objectForKey:@"uid"];
        NSString *uname = [groupDic lzNSStringForKey:@"uname"];
        if(![uid isEqualToString:[AppUtils GetCurrentUserID]]){
            if(![NSString isNullOrEmpty:uname]){
                changeInfo = uname;
            } else {
                UserModel *theUserModel = [[UserDAL shareInstance] getUserModelForNameAndFace:uid];
                /* 从网络同步请求此人信息 */
                if(theUserModel==nil){
                    theUserModel = [[[UserViewModel alloc] init] getUserInfoAsynMode:uid];
                }
                changeInfo = theUserModel.username;
            }
        }
        systemMsg = [NSString stringWithFormat:@"--%@修改群名为\"%@\"",changeInfo,groupname];
    }
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    return [self commonSaveSystemMsgInfo:dataDic isRefreshMessageRootVC:YES];
    
//    __block GroupMessageParse * service = self;
//    EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_ModifyGroupName, groupid);
    
//    /* 当前用户修改的，需要使用此通知 */
//    EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, groupid);
}

/**
 *  扫描二维码
 *
 *  @param dataDic 数据源
 */
-(NSDictionary *)parseImGroupJoinGroup:(NSMutableDictionary *)dataDic{
    /* 保存系统消息 */
    NSString *systemMsg = @"";
    systemMsg =  [dataDic lzNSStringForKey:@"content"];
    if([NSString isNullOrEmpty:systemMsg]){
        NSString *currentUserID = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
        BOOL isHaveMe = NO;
        
        NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
    //    NSString *groupid = [groupDic objectForKey:@"groupid"];
        NSDictionary *dataUserDic = [groupDic objectForKey:@"adduser"];
        
        /* 添加群组人员 */
        NSString *addUserNames = @"";
        ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
        [imGroupUserName serializationWithDictionary:dataUserDic];
        
        if( [currentUserID isEqualToString:imGroupUserName.uid] ){
            isHaveMe = YES;
        }
        addUserNames = [addUserNames stringByAppendingString:imGroupUserName.username];

        
        if(isHaveMe){
            systemMsg = [NSString stringWithFormat:@"--我已经通过二维码扫描加入群聊"];
        }
        else {
            systemMsg = [NSString stringWithFormat:@"--%@通过二维码扫描加入群聊",addUserNames];
        }
    }

    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    return [self commonSaveSystemMsgInfo:dataDic isRefreshMessageRootVC:YES];
    
//    if(!isHaveMe){
//        __block GroupMessageParse * service = self;
//        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_AddMember, groupid);
//    }
}


/**
 *  通过好友申请
 *
 *  @param dataDic 数据源
 */
-(NSDictionary *)parseImGroupAddFriend:(NSMutableDictionary *)dataDic{
    /* 保存系统消息 */
    NSString *systemMsg = @"";
    systemMsg =  [dataDic lzNSStringForKey:@"content"];
    if([NSString isNullOrEmpty:systemMsg]){
        systemMsg = @"--我们现在已经是好友了!";
    }
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    return [self commonSaveSystemMsgInfo:dataDic isRefreshMessageRootVC:YES];
}



/**
 *  通用保存系统消息的方法
 *
 *  @param dataDic 数据
 */
-(NSDictionary *)commonSaveSystemMsgInfo:(NSMutableDictionary *)dataDic isRefreshMessageRootVC:(BOOL)isRefreshMessageRootVC{
    /* 容错处理 */
    if([NSString isNullOrEmpty:[dataDic lzNSStringForKey:@"systemmsg"]]){
        return @{Result_IsSendReport:@"1"};
    }
    
    NSString *msgid = [dataDic objectForKey:@"msgid"];
//    NSString *dialogid = [[dataDic objectForKey:@"to"] isEqualToString:[AppUtils GetCurrentUserID]] ? [dataDic objectForKey:@"from"] : [dataDic objectForKey:@"to"];
    NSString *dialogid = [dataDic objectForKey:@"container"];
    NSInteger fromtype = ((NSNumber *)[dataDic objectForKey:@"fromtype"]).integerValue;
    NSString *from = [dataDic objectForKey:@"from"];
    NSInteger totype = ((NSNumber *)[dataDic objectForKey:@"totype"]).integerValue;
    NSString *to = [dataDic objectForKey:@"to"];
    NSString *body = [dataDic dicSerial];
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    NSDate *showindexdate = nil;
    if([dataDic objectForKey:@"senddatetime"] != [NSNull null]){
        showindexdate = [LZFormat String2StandardDate:[dataDic objectForKey:@"senddatetime"]];
        showindexdate = [self resetChatLogShowindexDate:showindexdate];
    }
    
    ImChatLogModel *imChatLogModel = [[ImChatLogModel alloc] init];
    imChatLogModel.msgid = msgid;
    imChatLogModel.dialogid = dialogid;
    imChatLogModel.fromtype = fromtype;
    imChatLogModel.from = from;
    imChatLogModel.totype = totype;
    imChatLogModel.to = to;
    imChatLogModel.body = body;
    imChatLogModel.showindexdate = showindexdate;
    imChatLogModel.handlertype = handlertype;
    if(imChatLogModel.imClmBodyModel.status==1){
        imChatLogModel.recvisread = 1;
    } else {
        imChatLogModel.recvisread = 0;
    }
    imChatLogModel.sendstatus = Chat_Msg_SendSuccess;
    imChatLogModel.recvstatus = 0;
    
    BOOL isSaveSuccess = [[ImChatLogDAL shareInstance] addChatLogModel:imChatLogModel];
    if(LeadingCloud_MsgParseSerial && !isSaveSuccess){
        DDLogVerbose(@"GroupMessageParse--parse:保存消息数据到ChatLog表中失败。[消息解析失败]");
        return @{Result_IsSaveSuccess:@"0"};
    }
    
    /* 先接收通知，后接收消息，需要更新最近联系人 */
    BOOL isGetedContactName = [[ImRecentDAL shareInstance] updateLastMsgWithDialogid:imChatLogModel.dialogid];
    
    /* 未更新成功 */
    if(!isGetedContactName){
        [[ImRecentDAL shareInstance] deleteImRecentModelWithContactid:imChatLogModel.dialogid];
        NSString *container = [dataDic lzNSStringForKey:@"container"];
        if(imChatLogModel.totype == Chat_ToType_One
           ||imChatLogModel.totype == Chat_ToType_Two ){
            [[[UserViewModel alloc] init] getImGroupInfoAsynMode:container];
        }
        else {
            [[[UserViewModel alloc] init] getUserInfoAsynMode:container];
        }
//        isGetedContactName = [[ImRecentDAL shareInstance] updateLastMsgWithDialogid:imChatLogModel.dialogid];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知聊天窗口 */
        __block GroupMessageParse * service = self;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:imChatLogModel];
        EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RecvSystemMsg, array);
        
        /* 刷新消息页 */
        if(isRefreshMessageRootVC){
//            self.appDelegate.lzGlobalVariable.chatDialogID = imChatLogModel.dialogid;
//            self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
            
            /* 处理业务会话（特殊处理） */
            if((imChatLogModel.totype == Chat_ToType_Five || imChatLogModel.totype == Chat_ToType_Six)
               && imChatLogModel.imClmBodyModel.parsetype==0){
                
            } else {
                if(imChatLogModel.totype == Chat_ToType_Five || imChatLogModel.totype == Chat_ToType_Six){
                    //刷新一级消息
                    self.appDelegate.lzGlobalVariable.chatDialogID = [NSString stringWithFormat:@"%@.%@",imChatLogModel.dialogid,imChatLogModel.to];
                    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
                    NSString *strToType = [NSString stringWithFormat:@"%ld",imChatLogModel.totype];
                    EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshSecondMsgVC, strToType );
                } else {
                    self.appDelegate.lzGlobalVariable.chatDialogID = imChatLogModel.dialogid;
                    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
                }
            }
        }
    });
    return @{Result_IsSendReport:@"1"};
}

@end
