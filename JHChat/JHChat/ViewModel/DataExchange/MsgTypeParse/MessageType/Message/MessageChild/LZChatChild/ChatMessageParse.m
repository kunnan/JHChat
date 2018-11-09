//
//  ChatMessageParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/3/24.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-24
 Version: 1.0
 Description: 聊天消息
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ChatMessageParse.h"
#import "ImChatLogDAL.h"
#import "ImChatLogModel.h"
#import "LZImageUtils.h"
#import "NSDictionary+DicSerial.h"
#import "ImGroupUserDAL.h"
#import "ImRecentDAL.h"
#import "UserDAL.h"
#import "ImGroupDAL.h"
#import "FilePathUtil.h"
#import "LZCloudFileTransferMain.h"
#import "VoiceConverter.h"
#import "AppDateUtil.h"
#import "ModuleServerUtil.h"
#import "JSMessageSoundEffect.h"
#import "ImGroupModel.h"
#import "ErrorDAL.h"
#import "NSString+SerialToArray.h"
#import "NSArray+ArraySerial.h"

@implementation ChatMessageParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ChatMessageParse *)shareInstance{
    static ChatMessageParse *instance = nil;
    if (instance == nil) {
        instance = [[ChatMessageParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析持久通知数据
 *
 *  @param dataDic 数据
 */
-(NSDictionary *)parse:(NSMutableDictionary *)dataDic{
    /* 记录日志，跟踪20161213，收到已读，数量减一 */
    NSString *errorTitle = [NSString stringWithFormat:@"8：dialogId=%@",[dataDic lzNSStringForKey:@"container"]];
    [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[dataDic dicSerial] errortype:Error_Type_Four];
    
    /* 新消息数组 */
    ImChatLogModel *imChatLogModel = [[ImChatLogModel alloc] init];
    [self parseImNewMessage:imChatLogModel oriDic:dataDic];
    
    /* 保存聊天记录之后，保存最近联系人信息，消息声音 */
    BOOL isSaveSuccess = [[ImChatLogDAL shareInstance] addChatLogModel:imChatLogModel];
    if(LeadingCloud_MsgParseSerial && !isSaveSuccess){
        DDLogVerbose(@"ChatMessageParse--parse:保存消息数据到ChatLog表中失败。[消息解析失败]");
        return @{@"issavesuccess":@"0"};
    }
    [self afterSaveChatLog:imChatLogModel imRecetnModel:nil isChatMessage:YES];

    /* 收到当前人在其它客户端发送的消息 */
    if([[dataDic objectForKey:@"from"] isEqualToString:[AppUtils GetCurrentUserID]]){
        return @{@"issendreport":@"1"};
    }
    return @{@"issendreport":@"0"};
}


/**
 *  解析消息
 *
 *  @param allMsgArr 消息数组
 *  @param dataDic   数据源
 */
-(void)parseImNewMessage:(ImChatLogModel *)imChatLogModel oriDic:(NSMutableDictionary *)dataDic{
//    NSString *currentUserID = [AppUtils GetCurrentUserID];
    NSString *handlertype = [dataDic lzNSStringForKey:@"handlertype"];
    
    /* 拍照、图片 */
    if([handlertype hasSuffix:Handler_Message_LZChat_Image_Download]){
        ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
        NSMutableDictionary *dataBodyDic = [dataDic lzNSMutableDictionaryForKey:@"body"];
        NSString *fileId = [dataBodyDic lzNSStringForKey:@"fileid"];
        NSString *fileName = [NSString isNullOrEmpty:[dataBodyDic objectForKey:@"name"]] ? [NSString stringWithFormat:@"%@.JPG",fileId] : [dataBodyDic objectForKey:@"name"];
        NSString *fileExt = @"";
		if([fileName rangeOfString:@"."].location!=NSNotFound){
			fileExt = [fileName substringFromIndex:[fileName rangeOfString:@"." options:NSBackwardsSearch].location+1];
		}
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
            CGSize smallSize = [LZImageUtils CalculateSmalSize:CGSizeMake(oriWidth, oriHeight)
                                                       maxSize:CHATVIEW_IMAGE_Height_Width_Max
                                                       minSize:CHATVIEW_IMAGE_Height_Width_Min];
            fileModel.smalliconwidth = smallSize.width;
            fileModel.smalliconheight = smallSize.height;
        }
        NSMutableDictionary *dic = [fileModel convertModelToDictionary];
        [dataDic setObject:[dic dicSerial] forKey:@"fileinfo"];
        
        imChatLogModel.recvstatus = Chat_Msg_NoDownload;
    }
    /* 小视频 */
    else if ([handlertype hasSuffix:Handler_Message_LZChat_Micro_Video]) {
        ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
        NSMutableDictionary *dataBodyDic = [dataDic objectForKey:@"body"];
        NSString *imagefileid = [dataBodyDic objectForKey:@"imagefileid"];
        NSString *videofileid = [dataBodyDic objectForKey:@"videofileid"];
        
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
    /* 语音,视频通话 */
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
			fileExt = [fileName substringFromIndex:[fileName rangeOfString:@"." options:NSBackwardsSearch].location+1];
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
    else {
        imChatLogModel.recvstatus = Chat_Msg_Downloadsuccess;
    }
    
    NSString *msgid = [dataDic objectForKey:@"msgid"];
//    NSString *dialogid = [[dataDic objectForKey:@"to"] isEqualToString:currentUserID] ? [dataDic objectForKey:@"from"] : [dataDic objectForKey:@"to"];
    NSString *dialogid = [dataDic lzNSStringForKey:@"container"];
    NSInteger fromtype = ((NSNumber *)[dataDic objectForKey:@"fromtype"]).integerValue;
    NSString *from = [dataDic lzNSStringForKey:@"from"];
    NSInteger totype = ((NSNumber *)[dataDic objectForKey:@"totype"]).integerValue;
    NSString *to = [dataDic lzNSStringForKey:@"to"];
    NSString *body = [dataDic dicSerial];
    NSDate *showindexdate = nil;
    if([dataDic objectForKey:@"senddatetime"] != [NSNull null]){
        showindexdate = [LZFormat String2Date:[dataDic lzNSStringForKey:@"senddatetime"]];
        showindexdate = [super resetChatLogShowindexDate:showindexdate];
    }
    
//    /* 若本地有这条消息，则不再处理 */
//    if([[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:msgid]!=nil){
//        DDLogError(@"----本地已含有此条消息，不再进行处理");
//        return;
//    }
    
    
    imChatLogModel.msgid = msgid;
    imChatLogModel.dialogid = dialogid;
    imChatLogModel.fromtype = fromtype;
    imChatLogModel.from = from;
    imChatLogModel.totype = totype;
    imChatLogModel.to = to;
    imChatLogModel.body = body;
    imChatLogModel.showindexdate = showindexdate;
    imChatLogModel.handlertype = handlertype;
    imChatLogModel.islastmsg = [dataDic lzNSStringForKey:@"islastmsg"];
    imChatLogModel.islastmsgornotice = [dataDic lzNSStringForKey:@"islastmsgornotice"];
    imChatLogModel.sendstatus = Chat_Msg_SendSuccess;
    imChatLogModel.recvstatus = 0;
    if(imChatLogModel.imClmBodyModel.status==1){
        imChatLogModel.recvisread = 1;
    } else {
        imChatLogModel.recvisread = 0;
    }
    imChatLogModel.isrecall = [dataDic lzNSNumberForKey:@"isrecall"].integerValue;
    imChatLogModel.isrecordstatus = [dataDic lzNSNumberForKey:@"isrecordstatus"].integerValue;
    imChatLogModel.at = [[dataDic lzNSArrayForKey:@"at"] arraySerial];
    /* 语音 */
    if([handlertype hasSuffix:Handler_Message_LZChat_Voice]){
        /* 未在此聊天界面时，下载语音格式文件 */
        if(![self checkIsOpenTheChatViewController:imChatLogModel]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self operateVoice:imChatLogModel];
            });
        }
    }
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
        int resultw = [VoiceConverter ConvertAmrToWav:amrVoicePath wavSavePath:wavVoicePath];
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
    
    NSString *server = [ModuleServerUtil GetServerWithModule:Modules_File];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *downloadUrl = [NSString stringWithFormat:@"%@/api/fileserver/download/%@/%@",server,imChatLogModel.imClmBodyModel.bodyModel.fileid,appDelegate.lzservice.tokenId];
    
    DDLogVerbose(@"----收到语音文件-开始下载---%@",downloadUrl);
    
    LZFileTransfer *lzFileTransfer = [LZCloudFileTransferMain getLZFileTransferForDownloadWithUrl:downloadUrl Progress:lzFileProgressDownload success:lzFileDidSuccessDownload error:lzFileDidErrorDownload];
    
    lzFileTransfer.localFileName = amrName;
    lzFileTransfer.localPath = [FilePathUtil getChatRecvImageDicRelatePath];
    lzFileTransfer.downloadFileSize = imChatLogModel.imClmBodyModel.bodyModel.size;
    lzFileTransfer.maxErrorTimes = 1;
    lzFileTransfer.fileDownId = imChatLogModel.imClmBodyModel.bodyModel.fileid;
    [lzFileTransfer downloadFile];
}

@end
