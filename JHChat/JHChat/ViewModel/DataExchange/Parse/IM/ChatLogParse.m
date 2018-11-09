//
//  ChatLogParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/3/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-15
 Version: 1.0
 Description: 解析聊天记录
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ChatLogParse.h"
#import "ImChatLogDAL.h"
#import "ImChatLogModel.h"
#import "LZImageUtils.h"
#import "NSDictionary+DicSerial.h"
#import "ImRecentDAL.h"
#import "AppDateUtil.h"
#import "NSString+IsNullOrEmpty.h"
#import "UserDAL.h"
#import "ImGroupUserModel.h"
#import "ModuleServerUtil.h"
#import "UserViewModel.h"
#import "ImGroupDAL.h"
#import "ImGroupModel.h"
#import "NSString+SerialToArray.h"
#import "NSArray+ArraySerial.h"

@implementation ChatLogParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ChatLogParse *)shareInstance{
    static ChatLogParse *instance = nil;
    if (instance == nil) {
        instance = [[ChatLogParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic lzNSStringForKey:WebApi_Route];
    
    /* 自动下载聊天记录 */
    if([route isEqualToString:WebApi_ChatLog_GetChatLogList]){
        /* 在子线程中解析 */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self parseGetChatLogList:dataDic];
        });
    }
    /* 获取消息的读取状态 */
    else if( [route isEqualToString:WebApi_ChatLog_GetMessageReadStatus] ){
        [self parseGetMessageReadStatus:dataDic];
    }
}

#pragma mark - 聊天记录处理

/**
 *  解析下载的聊天记录
 */
-(void)parseGetChatLogList:(NSMutableDictionary *)dataDic{
    NSMutableArray *dataArray  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableDictionary *otherData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
    
    NSMutableDictionary *postData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Post];
    NSString *dialogid = [postData lzNSStringForKey:@"container"];
//    NSString *synckey = [postData lzNSStringForKey:@"synckey"];
    

    /* 新消息数组 */
    NSMutableArray *allMsgArr = [[NSMutableArray alloc] init];
    NSString *lastSynckey = @"";
    NSDate *lastDate = nil;
    for(int i=0;i<dataArray.count;i++){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[dataArray objectAtIndex:i]];
        NSString *msgid = [dic lzNSStringForKey:@"msgid"];
//        NSString *handlertype = [dic objectForKey:@"handlertype"];
        /* 过滤掉不需要显示的个人提醒 */
        NSString *tvidStr = [LZUserDataManager getTvidStr];
        NSString *tvid = [[dic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"templateid"];
        if (![NSString isNullOrEmpty:tvidStr]) {
            BOOL isShowTvid = [tvidStr rangeOfString:[NSString stringWithFormat:@",%@.",tvid]].location == NSNotFound;
            if (!isShowTvid) {
                continue;
            }
        }
//        /* 只处理聊天记录类型 */
//        if(![handlertype isEqualToString:Handler_Message_LZChat_LZMsgNormal_Text]
//           && ![handlertype isEqualToString:Handler_Message_LZChat_Image_Download]
//           && ![handlertype isEqualToString:Handler_Message_LZChat_File_Download]
//           && ![handlertype isEqualToString:Handler_Message_LZChat_Video]
//           && ![handlertype isEqualToString:Handler_Message_LZChat_Card]
//           && ![handlertype isEqualToString:Handler_Message_LZChat_Voice]
//           && ![handlertype isEqualToString:Handler_Message_LZChat_Geolocation]
//           && ![handlertype hasPrefix:Handler_Message_LZChat_SR] ){
//            continue;
//        }
        
        /* 获取最后的synck */
//        if( [NSString isNullOrEmpty:synckey] ){
            NSDate *senddatetime = [LZFormat String2Date:[dic objectForKey:@"senddatetime"]];
            if(lastDate==nil){
                lastSynckey = msgid;
                lastDate = senddatetime;
            }
            else {
                if([lastDate compare:senddatetime]==NSOrderedAscending){
                    lastSynckey = msgid;
                    lastDate = senddatetime;
                }
            }
//        }
        
        /* 解析数据 */
        if([[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:@""]!=nil){
            continue;
        }
        [self analyseNewMessage:allMsgArr oriDic:dic];
    }
    /* 保存聊天记录 */
    [[ImChatLogDAL shareInstance] addDataWithChatLogArray:allMsgArr];
    
    
    /* 将第一条聊天记录的msgid放在otherData中 */
    ImChatLogModel *model = [[ImChatLogDAL shareInstance] getFirstChatLogModelWithDialogId:dialogid];
    if(model!=nil){
        [otherData setValue:model.msgid forKey:@"msgid"];
    }
    [otherData setValue:[NSNumber numberWithInteger:dataArray.count]  forKey:@"downloadcount"];
    
    
    if (![[otherData lzNSStringForKey:@"isDownloadMore"] isEqualToString:@"1"]) {
        /* 更新最近联系人 */
        [[ImRecentDAL shareInstance] updateLastMsgWithDialogid:dialogid];
        
//        /* 记录下synckey和时间 */
//        if( [NSString isNullOrEmpty:synckey] ){
//            synckey = lastSynckey;
//        }
        if( ![NSString isNullOrEmpty:lastSynckey] ){
            [[ImRecentDAL shareInstance] updateSynck:dialogid syncKey:lastSynckey syncKeyDate:[AppDateUtil GetCurrentDate]];
        }
    }  
    
    /* 刷新最近联系人 */
    self.appDelegate.lzGlobalVariable.chatDialogID = dialogid;
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知聊天窗口 */
        __block ChatLogParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_DownloadChatlog, otherData);
    });
    
}

/**
 *  解析消息
 *
 *  @param allMsgArr 消息数组
 *  @param dataDic   数据源
 */
-(void)analyseNewMessage:(NSMutableArray *)allMsgArr oriDic:(NSMutableDictionary *)dataDic{
    NSString *currentUserID = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"];
    NSString *handlertype = [dataDic lzNSStringForKey:@"handlertype"];
    
    ImChatLogModel *imChatLogModel = [[ImChatLogModel alloc] init];
    
    /* 当前人发出的消息 */
    if([[dataDic lzNSStringForKey:@"from"] isEqualToString:currentUserID]
       || [[dataDic allKeys] containsObject:@"readstatus"] ){
        NSMutableDictionary *readstatusDic = [[NSMutableDictionary alloc] initWithDictionary:[dataDic lzNSMutableDictionaryForKey:@"readstatus"]];
        
        if( [readstatusDic objectForKey:@"readuserlist"] == [NSNull null]){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [readstatusDic setObject:dic forKey:@"readuserlist"];
        }
        if( [readstatusDic objectForKey:@"unreaduserlist"] == [NSNull null]){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [readstatusDic setObject:dic forKey:@"unreaduserlist"];
        }
        [dataDic setObject:[readstatusDic dicSerial] forKey:@"readstatus"];
    }
    
    /* 拍照、图片 */
    if([handlertype hasSuffix:Handler_Message_LZChat_Image_Download]){
        ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
        NSMutableDictionary *dataBodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
        NSString *fileId = [dataBodyDic lzNSStringForKey:@"fileid"];
        NSString *fileName = [NSString isNullOrEmpty:[dataBodyDic lzNSStringForKey:@"name"]] ? [NSString stringWithFormat:@"%@.JPG",fileId] : [dataBodyDic lzNSStringForKey:@"name"];
        NSString *fileExt = @"";
        if([fileName rangeOfString:@"."].location!=NSNotFound){
            fileExt = [fileName substringFromIndex:[fileName rangeOfString:@"." options:NSBackwardsSearch].location+1];
        }
        fileModel.smalliconclientname = [NSString stringWithFormat:@"%@.%@",fileId,fileExt];
        
        if([AppUtils CheckIsImageWithName:fileName]){
            float oriWidth = [[dataBodyDic objectForKey:@"width"] floatValue];
            float oriHeight = [[dataBodyDic objectForKey:@"height"] floatValue];
            CGSize smallSize = [LZImageUtils CalculateSmalSize:CGSizeMake(oriWidth, oriHeight) maxSize:CHATVIEW_IMAGE_Height_Width_Max minSize:CHATVIEW_IMAGE_Height_Width_Min];
            fileModel.smalliconwidth = smallSize.width;
            fileModel.smalliconheight = smallSize.height;
        }
        NSMutableDictionary *dic = [fileModel convertModelToDictionary];
        [dataDic setObject:[dic dicSerial] forKey:@"fileinfo"];
        
        imChatLogModel.recvstatus = Chat_Msg_NoDownload;
    }
    /* 小视频 */
    else if([handlertype hasSuffix:Handler_Message_LZChat_Micro_Video]) {
        ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
        NSMutableDictionary *dataBodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
        NSString *imagefileid = [dataBodyDic lzNSStringForKey:@"imagefileid"];
        NSString *videofileid = [dataBodyDic lzNSStringForKey:@"videofileid"];
        fileModel.smalliconclientname = [NSString stringWithFormat:@"%@.JPG",imagefileid];
        fileModel.smallvideoclientname = [NSString stringWithFormat:@"%@.mp4",videofileid];
        
        float oriWidth = [[dataBodyDic objectForKey:@"width"] floatValue];
        float oriHeight = [[dataBodyDic objectForKey:@"height"] floatValue];
        CGSize smallSize = [LZImageUtils CalculateSmalSize:CGSizeMake(oriWidth, oriHeight) maxSize:CHATVIEW_IMAGE_Height_Width_Max minSize:CHATVIEW_IMAGE_Height_Width_Min];
        fileModel.smalliconwidth = smallSize.width;
        fileModel.smalliconheight = smallSize.height;
        
        NSMutableDictionary *dic = [fileModel convertModelToDictionary];
        [dataDic setObject:[dic dicSerial] forKey:@"fileinfo"];
        imChatLogModel.recvstatus = Chat_Msg_NoDownload;
    }
    /* 点进对话框后，语音,视频通话 */
    else if ([handlertype hasSuffix:Handler_Message_LZChat_VoiceCall] ||
             [handlertype hasSuffix:Handler_Message_LZChat_VideoCall]) {
        ImChatLogBodyInnerModel *innerModel = [[ImChatLogBodyInnerModel alloc] init];
        NSMutableDictionary *dataBodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
        NSString *callstatus = [dataBodyDic lzNSStringForKey:@"callstatus"];
        NSString *duration = [dataBodyDic lzNSStringForKey:@"duration"];
        NSString *channelid = [dataBodyDic lzNSStringForKey:@"channelid"];
        
        innerModel.callstatus = callstatus;
        innerModel.duration = duration;
        innerModel.channelid = channelid;
        
        NSMutableDictionary *dic = [innerModel convertModelToDictionary];
        [dataDic setObject:[dic dicSerial] forKey:@"fileinfo"];
        imChatLogModel.recvstatus = Chat_Msg_NoDownload;
    }
    else if ([handlertype hasSuffix:Handler_Message_LZChat_UrlLink]) {
        ImChatLogBodyInnerModel *urlModel = [[ImChatLogBodyInnerModel alloc] init];
        NSMutableDictionary *dataBodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
        NSString *urltitle = [dataBodyDic lzNSStringForKey:@"urltitle"];
        NSString *urlstr = [dataBodyDic lzNSStringForKey:@"urlstr"];
        NSString *urlimage = [dataBodyDic lzNSStringForKey:@"urlimage"];
        
        urlModel.urltitle = urltitle;
        urlModel.urlstr = urlstr;
        urlModel.urlimage = urlimage;
        
        NSMutableDictionary *dic = [urlModel convertModelToDictionary];
        [dataDic setObject:[dic dicSerial] forKey:@"fileinfo"];
        imChatLogModel.recvstatus = Chat_Msg_NoDownload;
        
    }
    else if ([handlertype hasSuffix:Handler_Message_LZChat_ChatLog]) {
//        ImChatLogBodyInnerModel *chatLogModel = [[ImChatLogBodyInnerModel alloc] init];
//        NSMutableDictionary *dataBodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
//        NSString *chatlogTitle = [dataBodyDic lzNSStringForKey:@"title"];
//        NSMutableArray *contentArr = [[dataBodyDic lzNSStringForKey:@"chatlog"] serialToArr];
        
//        chatLogModel.title = chatlogTitle;
//        chatLogModel.chatlog = contentArr;
//        NSMutableDictionary *dic = [chatLogModel convertModelToDictionary];
//        [dataDic setObject:[dic dicSerial] forKey:@"fileinfo"];
        imChatLogModel.recvstatus = Chat_Msg_NoDownload;
    }
    /* 文件 */
    else if([handlertype hasSuffix:Handler_Message_LZChat_File_Download]){
        ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
        NSMutableDictionary *dataBodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
        NSString *fileId = [dataBodyDic lzNSStringForKey:@"fileid"];
        NSString *fileName = [dataBodyDic lzNSStringForKey:@"name"];
        
        NSString *fileExt = @"";
        if([fileName rangeOfString:@"."].location!=NSNotFound){
            fileExt = [fileName substringFromIndex:[fileName rangeOfString:@"." options:NSBackwardsSearch].location+1];;
        }
        
        fileModel.smalliconclientname = [NSString stringWithFormat:@"%@.%@",fileId,fileExt];
        
        NSMutableDictionary *dic = [fileModel convertModelToDictionary];
        [dataDic setObject:[dic dicSerial] forKey:@"fileinfo"];
        
        imChatLogModel.recvstatus = Chat_Msg_NoDownload;
    }
    /* 位置 */
    else if([handlertype hasSuffix:Handler_Message_LZChat_Geolocation]){
        NSMutableDictionary *dataBodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
        NSString *fileId = [dataBodyDic lzNSStringForKey:@"fileid"];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",fileId];
        
        ImChatLogBodyGeolocationModel *geolocationInfo = [[ImChatLogBodyGeolocationModel alloc] init];
        geolocationInfo.geoimagename = fileName;
        NSMutableDictionary *dic = [geolocationInfo convertModelToDictionary];
        [dataDic setObject:[dic dicSerial] forKey:@"geolocationinfo"];
    }
    /* 系统消息 */
    else if([handlertype hasPrefix:Handler_Message_LZChat_SR]){
        [self setSystemMsgInfoHandler:handlertype dataDic:dataDic];
        /* 容错处理 */
        if([NSString isNullOrEmpty:[dataDic lzNSStringForKey:@"systemmsg"]]){
            return;
        }
    }
    else {
        imChatLogModel.recvstatus = Chat_Msg_Downloadsuccess;
    }
    

    NSString *msgid = [dataDic lzNSStringForKey:@"msgid"];
//    NSString *dialogid = [[dataDic objectForKey:@"to"] isEqualToString:currentUserID] ? [dataDic objectForKey:@"from"] : [dataDic objectForKey:@"to"];
    NSString *dialogid = [dataDic lzNSStringForKey:@"container"];
    NSInteger fromtype = ((NSNumber *)[dataDic objectForKey:@"fromtype"]).integerValue;
    NSString *from = [dataDic lzNSStringForKey:@"from"];
    NSInteger totype = ((NSNumber *)[dataDic objectForKey:@"totype"]).integerValue;
    NSString *to = [dataDic lzNSStringForKey:@"to"];
    NSString *body = [dataDic dicSerial];
    NSInteger isrecall = [dataDic lzNSNumberForKey:@"isrecall"].integerValue;
    NSInteger isdel = [dataDic lzNSNumberForKey:@"isdel"].integerValue;
    NSInteger isrecordstatus = [dataDic lzNSNumberForKey:@"isrecordstatus"].integerValue;
    
    NSDate *showindexdate = nil;
    if([dataDic objectForKey:@"senddatetime"] != [NSNull null]){
        showindexdate = [LZFormat String2Date:[dataDic lzNSStringForKey:@"senddatetime"]];
    }
    
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
    imChatLogModel.isrecall = isrecall;
    imChatLogModel.isdel = isdel;
    imChatLogModel.isrecordstatus = isrecordstatus;
    imChatLogModel.at = [[dataDic lzNSArrayForKey:@"at"] arraySerial];
    [allMsgArr addObject:imChatLogModel];
}

/**
 *  添加系统消息
 */
-(void)setSystemMsgInfoHandler:(NSString *)handlertype dataDic:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *bodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
    
    /* 保存系统消息 */
    NSString *defaultSystemMsg = @"";
    defaultSystemMsg =  [dataDic lzNSStringForKey:@"content"];
    if(![NSString isNullOrEmpty:defaultSystemMsg]){
        [dataDic setObject:defaultSystemMsg forKey:@"systemmsg"];
        return;
    }
    
    if( [handlertype isEqualToString:Handler_Message_LZChat_SR_CreateGroup] ){
        NSString *createuser = @"";
        NSString *systemMsg = @"";
        
        NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
        /* 解析群组人员信息 */
        NSMutableDictionary *groupInfoDic = [bodyDic lzNSMutableDictionaryForKey:@"group"];
        createuser = [groupInfoDic lzNSStringForKey:@"createuser"];
        NSArray *groupusers = [groupInfoDic lzNSArrayForKey:@"groupuser"];
        for(int j=0;j<groupusers.count;j++){
            NSDictionary *dataUserDic = [groupusers objectAtIndex:j];
            
            ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
            [imGroupUserName serializationWithDictionary:dataUserDic];
            
            [allImGroupUserArr addObject:imGroupUserName];
        }
        
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
                systemMsg = [NSString stringWithFormat:@"%@-- 邀请 %@ 加入群聊",groupAdmin,addUserNames];
            }
        }
        [dataDic setObject:systemMsg forKey:@"systemmsg"];
    }
    /* 添加群成员 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_Group_AddUser] ){
        BOOL isHaveMe = NO;
        NSString *groupid = [bodyDic lzNSStringForKey:@"groupid"];
        NSString *uid = [bodyDic lzNSStringForKey:@"uid"];
        NSString *uname = [bodyDic lzNSStringForKey:@"uname"];
        NSMutableArray *addUser = [bodyDic lzNSMutableArrayForKey:@"adduser"];
        
        /* 添加群组人员 */
        NSString *addUserNames = @"";
        for(int j=0;j<addUser.count;j++){
            NSDictionary *dataUserDic = [addUser objectAtIndex:j];
            
            ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
            [imGroupUserName serializationWithDictionary:dataUserDic];
            
            if( [[AppUtils GetCurrentUserID] isEqualToString:imGroupUserName.uid] ){
                isHaveMe = YES;
                break;
            }
            
            if(![NSString isNullOrEmpty:addUserNames]){
                addUserNames = [addUserNames stringByAppendingString:@","];
            }
            addUserNames = [addUserNames stringByAppendingString:imGroupUserName.username];
        }
        
        NSString *systemMsg = @"";
        
        BOOL isMe = ![NSString isNullOrEmpty:uid] && [uid isEqualToString:[AppUtils GetCurrentUserID]];
        
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
//            NSString *addUserName = addUser.count>=1 ? [[addUser objectAtIndex:0] objectForKey:@"username"] : @"";
//            systemMsg = [NSString stringWithFormat:@"欢迎%@加入%@",addUserName,imGroupModel.name];
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
        [dataDic setObject:systemMsg forKey:@"systemmsg"];
    }
    /* 移除群成员 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_RemoveUser] ){
        NSString *currentUserID = [AppUtils GetCurrentUserID];
        BOOL isRemoveMySelf = NO;
        NSMutableArray *removeuserArr = [bodyDic lzNSMutableArrayForKey:@"removeuser"];
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
        
        NSString *changeInfo = @"";
        NSString *uid = [bodyDic lzNSStringForKey:@"uid"];
        NSString *uname = [bodyDic lzNSStringForKey:@"uname"];
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
        NSString *systemMsg = [NSString stringWithFormat:@"--%@将%@移出群聊",changeInfo,removeUserNames];
        if(isRemoveMySelf){
            systemMsg = [NSString stringWithFormat:@"--你被 %@ 移出群聊",changeInfo];
        }
        [dataDic setObject:systemMsg forKey:@"systemmsg"];
    }
    /* 成员退出群组 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_QuitGroup] ){
        NSString *uid = [bodyDic lzNSStringForKey:@"uid"];
        NSString *uname = [bodyDic lzNSStringForKey:@"uname"];
        NSString *changeInfo = @"";
        if([NSString isNullOrEmpty:uname]){
            changeInfo = uname;
        } else {
            UserModel *theUserModel = [[UserDAL shareInstance] getUserModelForNameAndFace:uid];
            /* 从网络同步请求此人信息 */
            if(theUserModel==nil){
                theUserModel = [[[UserViewModel alloc] init] getUserInfoAsynMode:uid];
            }
            changeInfo = theUserModel.username;
        }
        NSString *systemMsg = [NSString stringWithFormat:@"--%@退出了群聊",changeInfo];
        [dataDic setObject:systemMsg forKey:@"systemmsg"];
    }
    /* 转让管理员 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_AssignAdmin] ){
        NSString *createuser = [bodyDic lzNSStringForKey:@"createuser"];
        NSString *changeInfo = @"你";
        if(![createuser isEqualToString:[AppUtils GetCurrentUserID]]){
            UserModel *theUserModel = [[UserDAL shareInstance] getUserModelForNameAndFace:createuser];
            /* 从网络同步请求此人信息 */
            if(theUserModel==nil){
                theUserModel = [[[UserViewModel alloc] init] getUserInfoAsynMode:createuser];
            }
            changeInfo = theUserModel.username;
        }
        NSString *systemMsg = [NSString stringWithFormat:@"--%@已成为新群主",changeInfo];
        [dataDic setObject:systemMsg forKey:@"systemmsg"];
    }
    /* 修改群名称 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_ModifyGroupName] ){
        NSString *groupname = [bodyDic objectForKey:@"groupname"];
        NSString *changeInfo = @"你";
        NSString *uid = [bodyDic lzNSStringForKey:@"uid"];
        NSString *uname = [bodyDic lzNSStringForKey:@"uname"];
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
        NSString *systemMsg = [NSString stringWithFormat:@"--%@修改群名为\"%@\"",changeInfo,groupname];
        [dataDic setObject:systemMsg forKey:@"systemmsg"];
    }
    /* 扫描二维码加入群聊 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_JoinGroup] ){
        NSString *currentUserID = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"];
        BOOL isHaveMe = NO;
        
        NSMutableDictionary *groupDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
        NSDictionary *dataUserDic = [groupDic lzNSDictonaryForKey:@"adduser"];
        
        /* 添加群组人员 */
        NSString *addUserNames = @"";
        ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
        [imGroupUserName serializationWithDictionary:dataUserDic];
        
        if( [currentUserID isEqualToString:imGroupUserName.uid] ){
            isHaveMe = YES;
        }
        addUserNames = [addUserNames stringByAppendingString:imGroupUserName.username];
        
        /* 保存系统消息 */
        NSString *systemMsg = @"";
        if(isHaveMe){
            systemMsg = [NSString stringWithFormat:@"--我已经通过二维码扫描加入群聊"];
        }
        else {
            systemMsg = [NSString stringWithFormat:@"--%@通过二维码扫描加入群聊",addUserNames];
        }
        
        [dataDic setObject:systemMsg forKey:@"systemmsg"];
    }
    /* 通过好友申请 */
    else if( [handlertype isEqualToString:Handler_Message_LZChat_SR_AddFriend] ){
        [dataDic setObject:@"--我们现在已经是好友了!" forKey:@"systemmsg"];
    }
}

#pragma mark - 消息的读取状态

/**
 *  获取消息的读取状态
 */
-(void)parseGetMessageReadStatus:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *readDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    NSMutableDictionary *getData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Get];
    NSString *msgid = [getData lzNSStringForKey:@"msgid"];
    
    ImChatLogModel *dbModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:msgid];
    ImChatLogBodyModel *bodyModel = dbModel.imClmBodyModel;
    bodyModel.readstatus = [readDic dicSerial];
    
    /* 更新数据库 */
    [[ImChatLogDAL shareInstance] updateBody:[[bodyModel convertModelToDictionary] dicSerial] withMsgId:msgid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知列表 */
        __block ChatLogParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_GetMessageReadStatus, msgid);
    });
}









#pragma mark - 
#pragma mark - 解析数据(服务器返回的ErrorCode非0)

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic{
    
}

@end
