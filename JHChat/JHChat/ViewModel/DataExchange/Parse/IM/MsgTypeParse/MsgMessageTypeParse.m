//
//  MsgMessageTypeParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/3/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-12
 Version: 1.0
 Description: 消息解析
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgMessageTypeParse.h"
#import "ImChatLogDAL.h"
#import "ImChatLogModel.h"
#import "NSDictionary+DicSerial.h"
#import "EventBus.h"
#import "EventPublisher.h"
#import "ImMsgQueueDAL.h"
#import "LZImageUtils.h"
#import "AppUtils.h"
#import "ChatViewController.h"
#import "ImRecentDAL.h"
#import "VoiceConverter.h"
#import "LZCloudFileTransferMain.h"
#import "ModuleServerUtil.h"
#import "NSDictionary+DicSerial.h"
#import "AppDateUtil.h"
#import "JSMessageSoundEffect.h"
#import "ImGroupModel.h"
#import "ImGroupDAL.h"
#import "ImGroupUserDAL.h"
#import "ImRecentDAL.h"
#import "ImRecentModel.h"
#import "UserDAL.h"
#import "UserModel.h"
#import "MsgMessageTypeParse.h"

@interface MsgMessageTypeParse()<EventSyncPublisher>

@end

@implementation MsgMessageTypeParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MsgMessageTypeParse *)shareInstance{
    static MsgMessageTypeParse *instance = nil;
    if (instance == nil) {
        instance = [[MsgMessageTypeParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];

    /* 需要处理的消息 */
    if([handlertype isEqualToString:Handler_Message_LZMsgNormal_Text]
           || [handlertype isEqualToString:Handler_Message_Image_Download]
           || [handlertype isEqualToString:Handler_Message_File_Download]
           || [handlertype isEqualToString:Handler_Message_Card]
           || [handlertype isEqualToString:Handler_Message_Voice]
           || [handlertype isEqualToString:Handler_Message_Geolocation]){
            
            /* 新消息数组 */
            NSMutableArray *allMsgArr = [[NSMutableArray alloc] init];
            [self parseImNewMessage:allMsgArr oriDic:dataDic];
            
            /* 保存聊天记录之后，保存最近联系人信息，消息声音 */
            [[ImChatLogDAL shareInstance] addDataWithArray:allMsgArr];
            [self afterSaveChatLog:allMsgArr];
    }
    /* 自己刚被加入新创建的群组 */
    else if( [handlertype isEqualToString:Handler_Message_CreateGroup] ){
        [self parseImCreateGroup:dataDic];
    }
    /* 添加群成员 */
    else if( [handlertype isEqualToString:Handler_Message_Group_AddUser] ){
        [self parseImGroupAddUser:dataDic];
    }
    /* 移除群成员 */
    else if( [handlertype isEqualToString:Handler_Message_RemoveUser] ){
        [self parseImGroupRemoveUser:dataDic];
    }
    /* 成员退出群组 */
    else if( [handlertype isEqualToString:Handler_Message_QuitGroup] ){
        [self parseImGroupUserQuitGroup:dataDic];
    }
    /* 转让管理员 */
    else if( [handlertype isEqualToString:Handler_Message_AssignAdmin] ){
        [self parseImGroupAssignAdmin:dataDic];
    }
    /* 修改群名称 */
    else if( [handlertype isEqualToString:Handler_Message_ModifyGroupName] ){
        [self parseImGroupModifyName:dataDic];
    }
}

#pragma mark - 解析消息

/**
 *  解析消息
 *
 *  @param allMsgArr 消息数组
 *  @param dataDic   数据源
 */
-(void)parseImNewMessage:(NSMutableArray *)allMsgArr oriDic:(NSMutableDictionary *)dataDic{
    NSString *currentUserID = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    ImChatLogModel *imChatLogModel = [[ImChatLogModel alloc] init];
    
    /* 拍照、图片 */
    if([handlertype hasSuffix:Handler_Message_Image_Download]){
        ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
        NSMutableDictionary *dataBodyDic = [dataDic objectForKey:@"body"];
        NSString *fileId = [dataBodyDic objectForKey:@"fileid"];
        NSString *fileName = [dataBodyDic objectForKey:@"name"];
        NSString *fileExt = [fileName substringFromIndex:[fileName rangeOfString:@"." options:NSBackwardsSearch].location+1];
        fileModel.smalliconclientname = [NSString stringWithFormat:@"%@.%@",fileId,fileExt];
        
        if([AppUtils CheckIsImageWithName:fileName]){
            float oriWidth = 100;
            float oriHeight = 100;
            if([dataBodyDic objectForKey:@"width"]!=nil){
                oriWidth = [[dataBodyDic objectForKey:@"width"] floatValue];
            }
            if([dataBodyDic objectForKey:@"height"]!=nil){
                oriHeight = [[dataBodyDic objectForKey:@"height"] floatValue];
            }
            CGSize smallSize = [LZImageUtils CalculateSmalSize:CGSizeMake(oriWidth, oriHeight) maxSize:CHATVIEW_IMAGE_Height_Width minSize:50];
            fileModel.smalliconwidth = smallSize.width;
            fileModel.smalliconheight = smallSize.height;
        }
        NSMutableDictionary *dic = [fileModel convertModelToDictionary];
        [dataDic setObject:[dic dicSerial] forKey:@"fileinfo"];
        
        imChatLogModel.recvstatus = Chat_Msg_NoDownload;
    }
    /* 文件 */
    else if([handlertype hasSuffix:Handler_Message_File_Download]){
        ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
        NSMutableDictionary *dataBodyDic = [dataDic objectForKey:@"body"];
        NSString *fileId = [dataBodyDic objectForKey:@"fileid"];
        NSString *fileName = [dataBodyDic objectForKey:@"name"];
        NSString *fileExt = [fileName substringFromIndex:[fileName rangeOfString:@"." options:NSBackwardsSearch].location+1];
        fileModel.smalliconclientname = [NSString stringWithFormat:@"%@.%@",fileId,fileExt];
        
        NSMutableDictionary *dic = [fileModel convertModelToDictionary];
        [dataDic setObject:[dic dicSerial] forKey:@"fileinfo"];
        
        imChatLogModel.recvstatus = Chat_Msg_NoDownload;
    }
    /* 位置 */
    else if([handlertype hasSuffix:Handler_Message_Geolocation]){
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",imChatLogModel.imClmBodyModel.bodyModel.fileid];
        
        ImChatLogBodyGeolocationModel *geolocationInfo = [[ImChatLogBodyGeolocationModel alloc] init];
        geolocationInfo.geoimagename = fileName;
        NSMutableDictionary *dic = [geolocationInfo convertModelToDictionary];
        [dataDic setObject:[dic dicSerial] forKey:@"geolocationinfo"];
    }
    else {
        imChatLogModel.recvstatus = Chat_Msg_Downloadsuccess;
    }
    
    /* 收到当前人在其它客户端发送的消息 */
    if([[dataDic objectForKey:@"from"] isEqualToString:currentUserID]){
        NSMutableDictionary *readstatusDic = [[NSMutableDictionary alloc] initWithDictionary:[dataDic objectForKey:@"readstatus"]];
        
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
    
    NSString *msgid = [dataDic objectForKey:@"msgid"];
    NSString *dialogid = [[dataDic objectForKey:@"to"] isEqualToString:currentUserID] ? [dataDic objectForKey:@"from"] : [dataDic objectForKey:@"to"];
    NSInteger fromtype = ((NSNumber *)[dataDic objectForKey:@"fromtype"]).integerValue;
    NSString *from = [dataDic objectForKey:@"from"];
    NSInteger totype = ((NSNumber *)[dataDic objectForKey:@"totype"]).integerValue;
    NSString *to = [dataDic objectForKey:@"to"];
    NSString *body = [dataDic dicSerial];
    NSDate *showindexdate = nil;
    if([dataDic objectForKey:@"senddatetime"] != [NSNull null]){
        showindexdate = [LZFormat String2Date:[dataDic objectForKey:@"senddatetime"]];
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
    imChatLogModel.sendstatus = Chat_Msg_SendSuccess;
    imChatLogModel.recvstatus = 0;
    
    [allMsgArr addObject:imChatLogModel];
}

-(void)afterSaveChatLog:(NSMutableArray *)allMsgArr{
    
    NSString *currentUserID = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    
    BOOL isUseTheSound = NO;
    
    /* 查询出数量 */
    NSMutableDictionary *dialogDic = [[NSMutableDictionary alloc] init];
    /* 提醒了我的消息 */
    NSMutableArray *remindDialogArr = [[NSMutableArray alloc] init];
    for (ImChatLogModel *imChatLogModel in allMsgArr) {
        NSString *dialogId = imChatLogModel.dialogid;
        
        /* 未在此聊天界面时，下载语音格式文件 */
        if(![self checkIsOpenTheChatViewController:dialogId]){
            /* 语音格式文件，需要下载 */
            if([imChatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_Voice]){
                [self operateVoice:imChatLogModel];
            }
        }
        
        /* 更新未查看数量 */
        if([[dialogDic allKeys] containsObject:dialogId]){
            NSNumber *msgNumber = [dialogDic objectForKey:dialogId];
            [dialogDic setObject:[NSNumber numberWithInteger:msgNumber.integerValue + 1]  forKey:dialogId];
        }
        else {
            [dialogDic setObject:[NSNumber numberWithInteger:1]  forKey:dialogId];
        }
        
        /* 未在此聊天界面，判断是否有人@自己 */
        if( [imChatLogModel.handlertype isEqualToString:Handler_Message_LZMsgNormal_Text]
           && ![remindDialogArr containsObject:dialogId] ){
            NSString *lzremindlist = [NSString stringWithFormat:@"%@,",imChatLogModel.imClmBodyModel.bodyModel.lzremindlist];
            if([lzremindlist rangeOfString:[NSString stringWithFormat:@"%@,",currentUserID]].location != NSNotFound){
                [remindDialogArr addObject:dialogId];
            }
        }
        
        /* 收到的是自己另一个客户端发出的数据 */
        if( [imChatLogModel.from isEqualToString:currentUserID] ){
            [dialogDic setObject:[NSNumber numberWithInteger:0]  forKey:dialogId];
        }
        else
        {
            if( isUseTheSound ){
                continue;
            }
            
            if( imChatLogModel.totype == Chat_ContactType_Main_ChatGroup || imChatLogModel.totype == Chat_ContactType_Main_CoGroup )
            {
                isUseTheSound = ![[ImGroupUserDAL shareInstance] checkCurrentUserIsDisturb:imChatLogModel.dialogid];
            }
            else {
                isUseTheSound = YES;
            }
        }
    }
    
    BOOL isNowRefreshMessageRootVC = NO;
    /* 根据DialogID更新最近联系人 */
    for (NSString *dialogId in [dialogDic allKeys]) {
        /* 更新最近联系人的lastdate和lastmsg字段 */        
        BOOL isGetedContactName = [[ImRecentDAL shareInstance] updateLastMsgWithDialogid:dialogId];
        
        /* 需要发送webapi获取当前人，或群的信息 */
        ImChatLogModel *imChatLogModel = nil;
        for (ImChatLogModel *imModel in allMsgArr) {
            if([imModel.dialogid isEqualToString:dialogId]){
                imChatLogModel = imModel;
            }
        }
        if(imChatLogModel!=nil && !isGetedContactName){
            if(imChatLogModel.totype == Chat_ContactType_Main_ChatGroup
               ||imChatLogModel.totype == Chat_ContactType_Main_CoGroup ){
                NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
                [getData setObject:imChatLogModel.dialogid forKey:@"groupid"];
                [self.appDelegate.lzservice sendToServerForGet:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfo moduleServer:Modules_Message getData:getData otherData:@"update_imrecent"];
            }
            else {
                [self.appDelegate.lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_LoadUser moduleServer:Modules_Default getData:nil postData:imChatLogModel.dialogid otherData:@"update_imrecent"];
            }
        }
        
        /* 未在此聊天界面，更新未查看数量 */
        if(![self checkIsOpenTheChatViewController:dialogId] ){
            isNowRefreshMessageRootVC = YES;
            NSNumber *msgNumber = [dialogDic objectForKey:dialogId];
            [[ImRecentDAL shareInstance] updateBadgeForAddCount:msgNumber.integerValue contactid:dialogId];
        }
    }
    /* 更新@信息 */
    for( NSString *dialogId in remindDialogArr ){
        /* 未在此聊天界面，更新@ */
        if(![self checkIsOpenTheChatViewController:dialogId] ){
            [[ImRecentDAL shareInstance] updateIsRemindMe:YES contactid:dialogId];
        }
    }
    
    __block MsgMessageTypeParse * service = self;
    
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    /* 刷新MessageRootViewController，及未查看数字 */
    if(isNowRefreshMessageRootVC){
        EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshMessageRootVC, nil);
        if(isUseTheSound){
            /* 播放消息声音提醒 */
            [self useTheSound];
        }
    }
    
    /* 通知聊天窗口 */
    EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RecvNewMsg, allMsgArr);
    
//    /* 刷新TabBar上的数字 */
//    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MainViewController_RefreshBadge object:nil];
    
    /* 若在后台，则需要发送本地通知 */
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive){ //判断是否处于前台页面
        [self startLocalNotification:allMsgArr];
    }
}

-(void)startLocalNotification:(NSMutableArray *)allMsgArr{
    int notificationType;
    if (!LZ_IS_IOS8) {
        notificationType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }else{
        notificationType = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    }
    if(notificationType==0 || allMsgArr.count==0){ //关闭了通知功能
        return;
    }
    
    ImChatLogModel *lastChatLogModel = [allMsgArr objectAtIndex:allMsgArr.count-1];
    
    NSString *message = @"";
    /* 拍照、图片 */
    if([lastChatLogModel.handlertype hasSuffix:Handler_Message_Image_Download]){
        message = @"[图片]";
    }
    /* 文件 */
    else if([lastChatLogModel.handlertype hasSuffix:Handler_Message_File_Download]){
        message = [NSString stringWithFormat:@"[文件]%@",lastChatLogModel.imClmBodyModel.bodyModel.name];
    }
    /* 语音 */
    else if([lastChatLogModel.handlertype hasSuffix:Handler_Message_Voice]){
        message = [NSString stringWithFormat:@"[语音]"];
    }
    /* 位置 */
    else if([lastChatLogModel.handlertype hasSuffix:Handler_Message_Geolocation]){
        message = [NSString stringWithFormat:@"[位置]"];
    }
    /* 文本 */
    else {
        message = lastChatLogModel.imClmBodyModel.content;
    }
    
    NSString *title = @"";
    NSString *fromUserName = [[UserDAL shareInstance] getUserDataWithUid:lastChatLogModel.from].username;
    /* 单人 */
    if(lastChatLogModel.totype == Chat_ContactType_Main_One){
        title = fromUserName;
    }
    else {
        ImGroupModel *groupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:lastChatLogModel.to];
        title = [NSString stringWithFormat:@"%@(%@)",fromUserName,groupModel.name];
    }
    
    BOOL isdisturb = YES;
    if( lastChatLogModel.totype == Chat_ContactType_Main_ChatGroup || lastChatLogModel.totype == Chat_ContactType_Main_CoGroup )
    {
        isdisturb = ![[ImGroupUserDAL shareInstance] checkCurrentUserIsDisturb:lastChatLogModel.dialogid];
    }
    if(!isdisturb){
        return;
    }
    
    UILocalNotification *localnotifi = [[UILocalNotification alloc] init];
    localnotifi.soundName = UILocalNotificationDefaultSoundName;
    localnotifi.applicationIconBadgeNumber = [[ImRecentDAL shareInstance] getImRecentNoReadMsgCount];
    localnotifi.alertBody = [NSString stringWithFormat:@"%@:%@",title,message];
    NSDictionary *infoDic = [NSDictionary dictionaryWithObject:lastChatLogModel.dialogid forKey:@"dialogid"];
    localnotifi.userInfo = infoDic;
    [[UIApplication sharedApplication] scheduleLocalNotification:localnotifi];
}

-(void)operateVoice:(ImChatLogModel *)imChatLogModel{
    NSString *absoultePath = [FilePathUtil getChatRecvImageDicAbsolutePath];
    NSString *amrName = [NSString stringWithFormat:@"voice_amr_%@.amr",imChatLogModel.imClmBodyModel.bodyModel.fileid];
    NSString *wavName = [NSString stringWithFormat:@"voice_wav_%@.wav",imChatLogModel.imClmBodyModel.bodyModel.fileid];
    
    LZFileProgressDownload lzFileProgressDownload = ^(float percent, NSString *tag, id otherInfo){
        DDLogVerbose(@"下载进度Voice=======%@",[NSString stringWithFormat:@"%0.f%%",percent*100]);
    };
    LZFileDidSuccessDownload lzFileDidSuccessDownload = ^(NSDictionary *result, NSString *tag, id otherInfo){
        ImChatLogBodyModel *bodyModel = imChatLogModel.imClmBodyModel;
        ImChatLogBodyVoiceModel *voiceModel = imChatLogModel.imClmBodyModel.voiceModel;
        voiceModel.voiceIsDown = YES;
        bodyModel.voiceinfo = [[voiceModel convertModelToDictionary] dicSerial];
        imChatLogModel.body = [[bodyModel convertModelToDictionary] dicSerial];
        [[ImChatLogDAL shareInstance] updateBody:[[bodyModel convertModelToDictionary] dicSerial]
                                       withMsgId:imChatLogModel.msgid];
        
        /* 转换为WAV格式 */
        NSString *wavVoicePath = [NSString stringWithFormat:@"%@%@",absoultePath,wavName];
        NSString *amrVoicePath = [NSString stringWithFormat:@"%@%@",absoultePath,amrName];
        int resultw = [VoiceConverter amrToWav:amrVoicePath wavSavePath:wavVoicePath];
        if(resultw == 1){
            ImChatLogBodyModel *bodyModel = imChatLogModel.imClmBodyModel;
            ImChatLogBodyVoiceModel *voiceModel = imChatLogModel.imClmBodyModel.voiceModel;
            voiceModel.voiceIsConvert = YES;
            voiceModel.wavname = wavName;
            voiceModel.amrname = amrName;
            bodyModel.voiceinfo = [[voiceModel convertModelToDictionary] dicSerial];
            imChatLogModel.body = [[bodyModel convertModelToDictionary] dicSerial];
            [[ImChatLogDAL shareInstance] updateBody:[[bodyModel convertModelToDictionary] dicSerial]
                                           withMsgId:imChatLogModel.msgid];
        }
    };
    LZFileDidErrorDownload lzFileDidErrorDownload = ^(NSString *title, NSString *message, NSString *tag, id otherInfo){
        DDLogVerbose(@"语音下载失败！");
    };
    
    NSString *server = [ModuleServerUtil GetServerWithModule:Modules_Default];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *downloadUrl = [NSString stringWithFormat:@"%@/api/fileserver/download/%@/%@",server,imChatLogModel.imClmBodyModel.bodyModel.fileid,appDelegate.lzservice.tokenId];
    
    DDLogVerbose(@"----收到语音文件-开始下载---%@",downloadUrl);
    
    LZFileTransfer *lzFileTransfer = [LZCloudFileTransferMain getLZFileTransferForDownloadWithUrl:downloadUrl Progress:lzFileProgressDownload success:lzFileDidSuccessDownload error:lzFileDidErrorDownload];
    
    lzFileTransfer.localFileName = amrName;
    lzFileTransfer.localPath = [FilePathUtil getChatRecvImageDicRelatePath];
    lzFileTransfer.downloadFileSize = imChatLogModel.imClmBodyModel.bodyModel.size;
    
    [lzFileTransfer downloadFile];
}

-(void)useTheSound
{
    /* 处于前台 */
    if( [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
        NSDate  *datenow = [AppDateUtil GetCurrentDate];
        NSString *strPreDate = [LZUserDataManager readTheDateForSound];
        long interval = 3;
        if(![strPreDate isEqualToString:@""]){
            NSDate *datePre = [LZFormat String2Date:strPreDate];
            interval = (long)[datenow timeIntervalSince1970] - (long)[datePre timeIntervalSince1970];
        }
        if(interval>=3){
            //判断播放的时间间隔
            [LZUserDataManager saveTheDateForSound:[LZFormat Date2String:datenow]];  //保存下此次收到消息的时间
            [JSMessageSoundEffect playMessageReceivedSound];
        }
    }
}

#pragma mark - 解析对方已读消息数据

/**
 *  创建群时，被加入群组(其它人创建了群，接收第一条消息时，会接收此通知)
 *
 *  @param dataDic 数据源
 */
-(void)parseImCreateGroup:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *groupInfoDic = [[dataDic objectForKey:@"body"] objectForKey:@"group"];
    NSString *createuser = [[dataDic objectForKey:@"body"] objectForKey:@"createuser"];
    
    NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
    
    ImGroupModel *imGroupModel = [[ImGroupModel alloc] init];
    [imGroupModel serializationWithDictionary:groupInfoDic];
    
    /* 解析群组人员信息 */
    NSArray *groupusers = [groupInfoDic objectForKey:@"groupuser"];
    for(int j=0;j<groupusers.count;j++){
        NSDictionary *dataUserDic = [groupusers objectAtIndex:j];
        
        ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
        [imGroupUserName serializationWithDictionary:dataUserDic];
        
        [allImGroupUserArr addObject:imGroupUserName];
    }
    
    [[ImGroupDAL shareInstance] addGroupModel:imGroupModel];
    [[ImGroupUserDAL shareInstance] addDataWithArray:allImGroupUserArr];
    
    
    /* 向最近联系人中添加 */
    ImRecentModel *imRecentModel = [[ImRecentModel alloc] init];
    imRecentModel.irid = [LZUtils CreateGUID];
    imRecentModel.contactid = imGroupModel.igid;
    imRecentModel.contacttype = Chat_ContactType_Main_ChatGroup;
    imRecentModel.contactname = imGroupModel.name;
    imRecentModel.face = @"";
    
    imRecentModel.lastdate = [AppDateUtil GetCurrentDate];
    imRecentModel.lastmsg = @"群组创建成功";
    imRecentModel.badge = 0;
    
    [[ImRecentDAL shareInstance] addImRecentWithModel:imRecentModel];
    
    /* 保存系统消息 */
    NSString *systemMsg = @"";
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
            systemMsg = [NSString stringWithFormat:@" %@ 加入群聊",addUserNames];
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
            systemMsg = [NSString stringWithFormat:@"%@ 邀请你 %@ 加入群聊",groupAdmin,addUserNames];
        }
    }
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    [self commonSaveSystemMsgInfo:dataDic];
    
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    /* 通知聊天窗口 */
    __block MsgMessageTypeParse * service = self;
    EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshMessageRootVC, nil);
}

/**
 *  添加人员
 *
 *  @param dataDic 数据源
 */
-(void)parseImGroupAddUser:(NSMutableDictionary *)dataDic{
    NSString *currentUserID = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    BOOL isMe = NO;
    BOOL isHaveMe = NO;
    
    NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
    
    NSString *groupid = [groupDic objectForKey:@"groupid"];
    NSString *groupName = [groupDic objectForKey:@"groupname"];
    NSString *uid = [groupDic objectForKey:@"uid"];
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
    
    /* 保存系统消息 */
    NSString *systemMsg = @"";
    isMe  = [uid isEqualToString:[AppUtils GetCurrentUserID]];
    if(isMe){
        if(addUserNames.length>0){
            systemMsg = [NSString stringWithFormat:@"你邀请 %@ 加入群聊",addUserNames];
        }
    }
    else {
        NSString *inviteUser = [[UserDAL shareInstance] getUserModelForNameAndFace:uid].username;
        if(isHaveMe){
            systemMsg = [NSString stringWithFormat:@"%@邀请你加入群聊",inviteUser];
        }
        else {
            systemMsg = [NSString stringWithFormat:@"%@邀请 %@ 加入群聊",inviteUser,addUserNames];
        }
    }
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    [self commonSaveSystemMsgInfo:dataDic];
    
    /* 当前人被加入群组 */
    if(isHaveMe){
        NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
        [getData setObject:groupid forKey:@"groupid"];
        [self.appDelegate.lzservice sendToServerForGet:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfo moduleServer:Modules_Message getData:getData otherData:nil];
    }
    /* 其它人被加入群组 */
    else {
        [[ImGroupUserDAL shareInstance] addDataWithArray:allImGroupUserArr];
        
        __block MsgMessageTypeParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_AddMember, groupid);
        
        if( ![NSString isNullOrEmpty:groupName] ){
            /* 更新群组名称 */
            [[ImGroupDAL shareInstance] updateGroupNameWithIgid:groupid groupName:groupName isRename:NO];
            
            self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshMessageRootVC, nil);
        }
    }
}

/**
 *  移除人员
 *
 *  @param dataDic 数据源
 */
-(void)parseImGroupRemoveUser:(NSMutableDictionary *)dataDic{
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
    
    /* 当前人被移除群组 */
    if(isRemoveMySelf){
        [[ImGroupDAL shareInstance] deleteGroupWithIgid:groupid];
    }
    /* 其它人被移除群组 */
    else {
        [[ImGroupUserDAL shareInstance] deleteGroupUserWithIgid:groupid uidArr:allImGroupUserArr];
        
        if( ![NSString isNullOrEmpty:groupName] ){
            /* 更新群组名称 */
            [[ImGroupDAL shareInstance] updateGroupNameWithIgid:groupid groupName:groupName isRename:NO];
        }
    }
    
    /* 保存系统消息 */
    NSString *changeInfo = @"你";
    NSString *uid = [groupDic objectForKey:@"uid"];
    if(![uid isEqualToString:[AppUtils GetCurrentUserID]]){
        changeInfo = [[UserDAL shareInstance] getUserModelForNameAndFace:uid].username;
    }
    NSString *systemMsg = [NSString stringWithFormat:@"%@将%@移出群聊",changeInfo,[groupDic objectForKey:@"unames"]];
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    [self commonSaveSystemMsgInfo:dataDic];
    
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    __block MsgMessageTypeParse * service = self;
    EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshMessageRootVC, nil);
}

/**
 *  用户退出群组
 *
 *  @param dataDic 数据源
 */
-(void)parseImGroupUserQuitGroup:(NSMutableDictionary *)dataDic{
    NSString *currentUserID = [AppUtils GetCurrentUserID];
    
    NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
    
    NSString *groupid = [groupDic objectForKey:@"groupid"];
    NSString *uid = [groupDic objectForKey:@"uid"];
    NSString *groupName = [groupDic objectForKey:@"groupname"];
    
    /* 保存系统消息 */
    NSString *changeInfo = [[UserDAL shareInstance] getUserModelForNameAndFace:uid].username;
    NSString *systemMsg = [NSString stringWithFormat:@"%@退出了群聊",changeInfo];
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    [self commonSaveSystemMsgInfo:dataDic];
    
    __block MsgMessageTypeParse * service = self;
    /* 当前人退出了群组 */
    if( [currentUserID isEqualToString:uid] ){
        [[ImGroupDAL shareInstance] deleteGroupWithIgid:groupid];        
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_DeleteGroup, groupid);
    }
    /* 其它人退出了群组 */
    else {
        [[ImGroupUserDAL shareInstance] deleteGroupUserWithIgid:groupid uid:uid];
        
        if( ![NSString isNullOrEmpty:groupName] ){
            /* 更新群组名称 */
            [[ImGroupDAL shareInstance] updateGroupNameWithIgid:groupid groupName:groupName isRename:NO];
        }
    }
    
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshMessageRootVC, nil);
}

/**
 *  转让群管理员
 *
 *  @param dataDic 数据源
 */
-(void)parseImGroupAssignAdmin:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
    
    NSString *groupid = [groupDic objectForKey:@"groupid"];
    NSString *createuser = [groupDic objectForKey:@"createuser"];
    
    [[ImGroupDAL shareInstance] updateGroupCreateUser:createuser groupid:groupid];

    /* 保存系统消息 */
    NSString *changeInfo = @"你";
    if(![createuser isEqualToString:[AppUtils GetCurrentUserID]]){
        changeInfo = [[UserDAL shareInstance] getUserModelForNameAndFace:createuser].username;
    }
    NSString *systemMsg = [NSString stringWithFormat:@"%@已成为新群主",changeInfo];
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    [self commonSaveSystemMsgInfo:dataDic];
    
    __block MsgMessageTypeParse * service = self;
    EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_AssignAdmin, nil);
    
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshMessageRootVC, nil);
}

/**
 *  修改群名称
 *
 *  @param dataDic 数据源
 */
-(void)parseImGroupModifyName:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *groupDic = [dataDic objectForKey:@"body"];
    
    NSString *groupid = [groupDic objectForKey:@"groupid"];
    NSString *groupname = [groupDic objectForKey:@"groupname"];
    
    [[ImGroupDAL shareInstance] updateGroupNameWithIgid:groupid groupName:groupname isRename:YES];
    
    /* 保存系统消息 */
    NSString *changeInfo = @"你";
    NSString *uid = [groupDic objectForKey:@"uid"];
    if(![uid isEqualToString:[AppUtils GetCurrentUserID]]){
        changeInfo = [[UserDAL shareInstance] getUserModelForNameAndFace:uid].username;
    }
    NSString *systemMsg = [NSString stringWithFormat:@"%@修改群名称为\"%@\"",changeInfo,groupname];
    [dataDic setObject:systemMsg forKey:@"systemmsg"];
    [self commonSaveSystemMsgInfo:dataDic];
    
    __block MsgMessageTypeParse * service = self;
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshMessageRootVC, nil);
}

/**
 *  通用保存系统消息的方法
 *
 *  @param dataDic 数据
 */
-(void)commonSaveSystemMsgInfo:(NSMutableDictionary *)dataDic{
    NSString *msgid = [dataDic objectForKey:@"msgid"];
    NSString *dialogid = [[dataDic objectForKey:@"to"] isEqualToString:[AppUtils GetCurrentUserID]] ? [dataDic objectForKey:@"from"] : [dataDic objectForKey:@"to"];
    NSInteger fromtype = ((NSNumber *)[dataDic objectForKey:@"fromtype"]).integerValue;
    NSString *from = [dataDic objectForKey:@"from"];
    NSInteger totype = ((NSNumber *)[dataDic objectForKey:@"totype"]).integerValue;
    NSString *to = [dataDic objectForKey:@"to"];
    NSString *body = [dataDic dicSerial];
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    NSDate *showindexdate = nil;
    if([dataDic objectForKey:@"senddatetime"] != [NSNull null]){
        showindexdate = [LZFormat String2Date:[dataDic objectForKey:@"senddatetime"]];
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
    imChatLogModel.recvisread = 1;
    imChatLogModel.sendstatus = Chat_Msg_SendSuccess;
    imChatLogModel.recvstatus = 0;
    
    [[ImChatLogDAL shareInstance] addChatLogModel:imChatLogModel];
}

@end
