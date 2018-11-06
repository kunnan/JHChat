//
//  ChatViewModel.m
//  LeadingCloud
//
//  Created by wchMac on 15/11/25.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "ChatViewModel.h"
#import "XHMessage.h"
#import "XHMessageVideoConverPhotoFactory.h"
#import "ImChatLogModel.h"
#import "ImChatLogBodyModel.h"
#import "ImChatLogDAL.h"
#import "ImRecentDAL.h"
#import "NSDictionary+DicSerial.h"
#import "AppDateUtil.h"
#import "ImMsgQueueDAL.h"
#import "ImMsgQueueModel.h"
#import "ModuleServerUtil.h"
#import "GalleryImageViewModel.h"
#import "NSString+IsNullOrEmpty.h"
#import "LCProgressHUD.h"
#import "VoiceConverter.h"
#import "ImGroupUserDAL.h"
#import "ImRecentDAL.h"
#import "ImRecentModel.h"
#import "NSString+IsNullOrEmpty.h"
#import "UserDAL.h"
#import "UserModel.h"
#import "UIImage+GIF.h"
#import "ImGroupDAL.h"
#import "ImGroupModel.h"
#import "ChatGroupUserListViewModel.h"
#import "EventPublisher.h"
#import "ImVersionTemplateDAL.h"
#import "NSObject+JsonSerial.h"
#import "ResFileiconDAL.h"
#import "ResFileiconModel.h"
#import "NSString+SerialToDic.h"
#import "ImGroupCallModel.h"
#import "ImGroupCallDAL.h"
#import "NSArray+ArraySerial.h"
#import "LZChatVideoModel.h"
#import "NSString+SerialToArray.h"


@interface ChatViewModel()<EventSyncPublisher>
{
    NSString *currentUserID;
    /* 文件上传队列 */
    NSMutableArray *fileSendArray;
    BOOL isUploadingFile;
    
    /* 最后一条消息的时间 */
    NSDate *latestShowDate;
    
//    /* 视频文件id */
//    NSString *videoFileID;
//    /* 封面图片id */
//    NSString *coverFileID;
}

@end

@implementation ChatViewModel

/**
 *  获取ViewModel数据源
 *
 *  @param dialogid 对话框ID
 *  @param start    起始记录
 *  @param count    获取记录数量
 */
-(NSMutableArray *)getViewDataSource:(NSString *)dialogid startCount:(NSInteger)start queryCount:(NSInteger)count
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    DDLogVerbose(@"加载");
    
    /* 当前用户ID */
    currentUserID = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"];
    
//    if(!_arrCellItem){
//        _arrCellItem = [[NSMutableArray alloc] init];
//    }
    if(!_uploadingDic){
        _uploadingDic = [[NSMutableDictionary alloc] init];
    }
    
    /* 从数据库中获取记录 */
    NSMutableArray *chatLogArray = [[[ImChatLogDAL alloc] init] getChatLogWithDialogid:dialogid startNum:start queryCount:count];

    // 业务会话咨询视图
    if (start == 0 && (_sendToType == Chat_ToType_Five || _sendToType == Chat_ToType_Six)) {
        ImChatLogModel *imChatLogModel = [[ImChatLogModel alloc] init];
        imChatLogModel.msgid = [LZUtils CreateGUID];
        imChatLogModel.dialogid = dialogid;
        imChatLogModel.fromtype = _contactType;
        imChatLogModel.heightforrow = @"90";
        imChatLogModel.handlertype = Handler_Message_LZChat_ConsultNotice;
        imChatLogModel.body = [_consultBody dicSerial];
        [chatLogArray addObject:imChatLogModel];
    }
    
    /* 转换为XHMessage */
    NSDate *preDisplayTimestamp = nil;
    for(int i=0;i<chatLogArray.count;i++){
        ImChatLogModel *imChatLogModel = [chatLogArray objectAtIndex:i];

        XHMessage *message = [self convertChatLogModelToXHMessage:imChatLogModel];
        if(message == nil){
            continue;
        }

        BOOL isDispalyTimestamp = NO;
        if(i==0){
            isDispalyTimestamp = YES;
        } else {
            
            NSInteger intervalSec = [AppDateUtil IntervalSeconds:preDisplayTimestamp endDate:imChatLogModel.showindexdate];
            /* 与上一次显示超过三分钟，则显示 */
            if(intervalSec>DEFAULT_TIMESTAMP_INTERVAL){
                isDispalyTimestamp = YES;
            }
        }
        if(isDispalyTimestamp){
            message.isDisplayTimestamp = YES;
            preDisplayTimestamp = imChatLogModel.showindexdate;
        }
        
//        if(i%2==0){
//            message.bubbleMessageType = XHBubbleMessageTypeSending;
//        } else {
//            message.bubbleMessageType = XHBubbleMessageTypeReceiving;
//        }
        
        [resultArray addObject:message];
    }
    
    return resultArray;
}


/**
 *  将聊天记录转换为XHMessage对象
 *
 *  @param chatLogModel 聊天记录
 *
 *  @return XHMessage对象
 */
- (XHMessage *)convertChatLogModelToXHMessage:(ImChatLogModel *)chatLogModel {
    
    XHMessage *message = nil;
    BOOL isMsgTemplate = NO;
    
    /* 文本 */
    if([chatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_LZMsgNormal_Text]){
        message = [[XHMessage alloc] initWithText:chatLogModel.imClmBodyModel.content
                                           sender:@""
                                        timestamp:chatLogModel.showindexdate];
    }
    /* 拍照、图片 */
    else if([chatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_Image_Download]){
        message = [self getImageMessage:chatLogModel];
    }
    /* 视频 */
    else if ([chatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_Micro_Video]) {
        message = [self getVideoCoverMessage:chatLogModel];
        
    }
    /* 语音通话 */
    else if ([chatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_VoiceCall]) {
        message = [[XHMessage alloc] initWithVoiceCall:chatLogModel.imClmBodyModel.bodyModel.callstatus
                                          callDuration:chatLogModel.imClmBodyModel.bodyModel.duration
                                              channelid:chatLogModel.imClmBodyModel.bodyModel.channelid
                                                sender:@""
                                             timestamp:chatLogModel.showindexdate];
    }
    /* 视频通话 */
    else if ([chatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_VideoCall]) {
        message = [[XHMessage alloc] initWithVideoCall:chatLogModel.imClmBodyModel.bodyModel.callstatus
                                          callDuration:chatLogModel.imClmBodyModel.bodyModel.duration
                                              channelid:chatLogModel.imClmBodyModel.bodyModel.channelid
                                                sender:@""
                                             timestamp:chatLogModel.showindexdate];
    }
    /* 文件 */
    else if([chatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_File_Download]){
        
//        [AppUtils GetImageWithID:chatLogModel.imClmBodyModel.bodyModel.icon exptype:chatLogModel.imClmBodyModel.bodyModel.name GetNewImage:^(UIImage *dataImage) {
//                     
//        }];
        message = [[XHMessage alloc] initWithFileShowName:chatLogModel.imClmBodyModel.bodyModel.name
                                                     icon:[AppUtils GetImageNameWithName:chatLogModel.imClmBodyModel.bodyModel.name]
                                                     size:chatLogModel.imClmBodyModel.bodyModel.size
                                                   sender:@""
                                                timestamp:chatLogModel.showindexdate];
        /* 添加上传进度 */
        if(chatLogModel.sendstatus==Chat_Msg_Sending){
            message.uploadProgress = @"0";
            if(![NSString isNullOrEmpty:chatLogModel.clienttempid]
               && [_uploadingDic lzNSStringForKey:chatLogModel.clienttempid]){
                message.uploadProgress = [_uploadingDic lzNSStringForKey:chatLogModel.clienttempid];
            }
        }
      
    }
    /* url链接 */
    else if ([chatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_UrlLink]) {
        message = [[XHMessage alloc] initWithUrlLinkTitleName:chatLogModel.imClmBodyModel.bodyModel.urltitle
                                                    iconImage:chatLogModel.imClmBodyModel.bodyModel.urlimage
                                                       urlStr:chatLogModel.imClmBodyModel.bodyModel.urlstr
                                                       sender:@""
                                                    timestamp:chatLogModel.showindexdate];
    }
    else if ([chatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_ChatLog]) {

        message = [[XHMessage alloc] initWithChatLogTitle:chatLogModel.imClmBodyModel.bodyModel.title
                                             contentArray:chatLogModel.imClmBodyModel.bodyModel.chatlogArr
                                                   sender:@""
                                                timestamp:chatLogModel.showindexdate];
    }
    /* 共享文件 */
//    else if ([chatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_LZTemplateMsg_CooperationShareFile]) {
//        message = [[XHMessage alloc] initWithShareMsgTitle:chatLogModel.imClmBodyModel.bodyModel.sharetitle
//                                                 shareCode:chatLogModel.imClmBodyModel.bodyModel.sharecode
//                                                    sender:@""
//                                                 timestamp:chatLogModel.showindexdate];
//    }
    /* 名片 */
    else if( [chatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_Card] ){
        message = [[XHMessage alloc] initWithCardShowName:chatLogModel.imClmBodyModel.bodyModel.username
                                                     icon:chatLogModel.imClmBodyModel.bodyModel.face
                                                   sender:@""
                                                timestamp:chatLogModel.showindexdate];
    }
    /* 语音 */
    else if( [chatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_Voice] ){
        NSString *path = @"";
        if([chatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
            path = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatSendImageDicAbsolutePath],chatLogModel.imClmBodyModel.voiceModel.wavname];
        }
        else {
            path = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatRecvImageDicAbsolutePath],chatLogModel.imClmBodyModel.voiceModel.wavname];
        }
        message = [[XHMessage alloc] initWithVoicePath:path
                                              voiceUrl:nil
                                         voiceDuration:chatLogModel.imClmBodyModel.bodyModel.duration
                                                sender:@""
                                             timestamp:chatLogModel.showindexdate
                                                isRead:chatLogModel.imClmBodyModel.bodyModel.status];
        
        if([chatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
            message.isRead = YES;
        }
        /* 下载语音文件 */
        if( [NSString isNullOrEmpty:chatLogModel.imClmBodyModel.voiceinfo] || chatLogModel.imClmBodyModel.voiceModel.voiceIsDown != YES ){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self operateVoice:chatLogModel xhMessage:message];
                });
            });
        }
    }
    /* 位置 */
    else if( [chatLogModel.imClmBodyModel.handlertype hasSuffix:Handler_Message_LZChat_Geolocation] ){

        message = [[XHMessage alloc] initWithLocalPositionPhoto:nil
                                                   geolocations:chatLogModel.imClmBodyModel.bodyModel.geoaddress
                                                       location:[[CLLocation alloc] initWithLatitude:chatLogModel.imClmBodyModel.bodyModel.geolatitude
                                                                                           longitude:chatLogModel.imClmBodyModel.bodyModel.geolongitude]
                                                         sender:@""
                                                      timestamp:chatLogModel.showindexdate];

        
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",chatLogModel.imClmBodyModel.geolocationModel.geoimagename];
        NSString *fileName = chatLogModel.imClmBodyModel.geolocationModel.geoimagename;
        
        NSString *savePath = @"";
        if([chatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
            savePath=[FilePathUtil getChatSendImageSmallDicAbsolutePath];
        } else {
            savePath=[FilePathUtil getChatRecvImageSmallDicAbsolutePath];
        }
        
        NSString *picImagePath = [NSString stringWithFormat:@"%@%@",savePath,fileName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        /* 本地图片地址 */
        if([fileManager fileExistsAtPath:picImagePath]){
            message.localPositionPhoto = [UIImage imageNamed:picImagePath];
        }
        /* 网络图片地址 */
        else {
//            NSString *url = [GalleryImageViewModel GetGalleryThumbnailImageUrlFileId:chatLogModel.imClmBodyModel.bodyModel.fileid size:@"200X200"];
            NSString *url = [GalleryImageViewModel GetGalleryOriImageUrlFileId:chatLogModel.imClmBodyModel.bodyModel.fileid];
            LZBubbleMessageMediaTypeSmallPhoto lzSmallPhoto = nil;
            lzSmallPhoto = ^(UIImage *image, NSData *data, NSError *error, BOOL finished){
                if (image && finished) {
                    DDLogVerbose(@"-----聊天界面位置缩略图下载完成");
                    message.photo = image;
                    message.localPositionPhoto = image;
                    [fileManager createFileAtPath:[savePath stringByAppendingFormat:@"%@",fileName] contents:data attributes:nil];
                }
            };

            message.thumbnailUrl = url;
            message.lzSmallPhoto = lzSmallPhoto;
        }
    }
    /* 系统消息 */
    else if( [chatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_SR]){
        NSString *systemMsg = chatLogModel.imClmBodyModel.systemmsg;
        if([NSString isNullOrEmpty:systemMsg]){
            systemMsg = chatLogModel.imClmBodyModel.content;
        }
        systemMsg = [systemMsg stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
        message = [[XHMessage alloc] initWithSystemMsg:systemMsg
                                                sender:@""
                                             timestamp:chatLogModel.showindexdate];
    }
    /* 多人视频通话 */
    else if ([chatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_Call_Main] ||
             [chatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_Call_Unanswer] ||
             [chatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_Call_Finish]) {
        NSString *videoMsg = chatLogModel.imClmBodyModel.content;
        message = [[XHMessage alloc] initWithSystemMsg:videoMsg
                                                sender:@""
                                             timestamp:chatLogModel.showindexdate];
    }
    /* 业务会话咨询 */
    else if ([chatLogModel.handlertype hasPrefix:Handler_Message_LZChat_ConsultNotice]) {
        NSString *consultNotice = [[chatLogModel.body seriaToDic] lzNSStringForKey:@"consultTitle"];
        NSString *noticetimeStr = [[chatLogModel.body seriaToDic] lzNSStringForKey:@"consultTime"];
        message = [[XHMessage alloc] initWithConsultNoticeMsg:consultNotice
                                                      timestr:noticetimeStr
                                                       sender:@""
                                                    timestamp:chatLogModel.showindexdate];
    }
    /* 模板 */
    else {
        isMsgTemplate = YES;

        /* 模板id */
        NSInteger templateid = chatLogModel.imClmBodyModel.bodyModel.templateid == 0 ? 35 : chatLogModel.imClmBodyModel.bodyModel.templateid;
        NSDictionary *customMsg = chatLogModel.imClmBodyModel.body;
        ImVersionTemplateModel *templateModel = [[ImVersionTemplateDAL shareInstance] getImVersionTemplateModelWithTemplate:templateid];
        /* 在这里处理一下，聊天页面接收不应该展示的模板消息，但是已经接收，兼容处理 */
        
        if (![NSString isNullOrEmpty:templateModel.templates]) {
            CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
            [model serialization:templateModel.templates];
            NSInteger templatetype = model.templatetype;
            if (templatetype != -1 && templateid != 0) {
                message = [[XHMessage alloc] initWithCustomMsg:customMsg customTemplateInfo:[templateModel convertModelToDictionary] sender:@"发送人" timestamp:chatLogModel.showindexdate];
            }
        }
    }

    message.imChatLogModel = chatLogModel;
    message.sendStatus = chatLogModel.sendstatus;
    
    if( ![chatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_SR] ){
        if([chatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
            message.bubbleMessageType = XHBubbleMessageTypeSending;
            message.faceid = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"face"];
            message.sender = [AppUtils GetCurrentUserName];
            [self addReadStatusToMessage:message chatLogModel:chatLogModel];
        } else {
            message.bubbleMessageType = XHBubbleMessageTypeReceiving;
            message.faceid = @"";
            
            UserModel *userModel = [[UserDAL shareInstance] getUserModelForNameAndFace:chatLogModel.from];
            if(userModel!=nil){
                message.sender = userModel.username;
                message.faceid = userModel.face;
            } else {
                [self.appDelegate.lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_LoadUser moduleServer:Modules_Default getData:nil postData:chatLogModel.from otherData:@{WebApi_DataSend_Other_Operate:@"reloadchatview"}];
            }
        }
    }
    // 如果走的模板消息(faceid 设置为空),但是 handlertype 是这个的不重置 faceID
    if(isMsgTemplate && ![chatLogModel.imClmBodyModel.handlertype hasPrefix:Handler_Message_LZChat_LZTemplateMsg_BSform]){
        message.faceid = @"";
    }
    if ([chatLogModel.handlertype hasPrefix:Handler_Message_LZChat_ConsultNotice]) {
        message.faceid = @"";
        message.bubbleMessageType = XHBubbleMessageTypeReceiving;
        message.messageMediaType = XHBubbleMessageMediaTypeConsultNotice;
    }
//    message.faceid = @"21882619876630560";

    return message;
}

-(XHMessage *)getVideoCoverMessage:(ImChatLogModel *)chatLogModel {
    XHMessage *message = nil;
    /* 封面的fileID加扩展名 */
    __block NSString *coverImageName = chatLogModel.imClmBodyModel.fileModel.smalliconclientname;
    /* 视频名称 */
    NSString *videoName = chatLogModel.imClmBodyModel.fileModel.smallvideoclientname;
    /* 封面id */
    NSString *coverID = [[coverImageName componentsSeparatedByString:@"."] objectAtIndex:0];
//    NSDictionary *dic = chatLogModel.imClmBodyModel.body;
    NSString *savePath = @"";
    if([chatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
        savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
    } else {
        savePath=[FilePathUtil getChatRecvImageDicAbsolutePath];
    }
    NSString *videoPath = [NSString stringWithFormat:@"%@%@",savePath, videoName];
    
    __block UIImage *picImage = nil; //封面图片
    NSString *url = nil;
    LZBubbleMessageMediaTypeSmallPhoto lzSmallPhoto = nil;
    
    NSString *picImagePath = [NSString stringWithFormat:@"%@%@",savePath,coverImageName];
    
    /* 加载本地图片 */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:picImagePath]){
        picImage = [UIImage imageWithContentsOfFile:picImagePath];
    }
    else {
        /* 异步下载图片，并进行加载 */
        url = [GalleryImageViewModel GetGalleryThumbnailImageUrlFileId:coverID size:@"200X200"];
        lzSmallPhoto = ^(UIImage *image, NSData *data, NSError *error, BOOL finished){
            if (image && finished) {
                DDLogVerbose(@"-----聊天界面缩略图下载完成");
                message.photo = image;
//                message.videoConverPhoto = image;
                
                [fileManager createFileAtPath:picImagePath contents:data attributes:nil];
            }
        };
        SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
        [downloader downloadImageWithURL:[AppUtils urlToNsUrl:url]
                                 options:0
                                progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                }
                               completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                   if (image && finished) {
                                       /* 将图片保存到本地 */
                                       message.photo = image;
                                       message.videoConverPhoto = image;
                                       [fileManager createFileAtPath:picImagePath contents:data attributes:nil];
                                   } else {
                                       DDLogVerbose(@"视频封面图下载失败");
                                   }
                               }];
    }
    message = [[XHMessage alloc] initWithVideoConverPhoto:picImage
                                                videoPath:videoPath
                                             thumbnailUrl:url
                                           thumbnailBlock:lzSmallPhoto
                                                 videoUrl:nil
                                                   sender:@""
                                                timestamp:chatLogModel.showindexdate];
    return message;
}
/**
 *  获取图片类型的XHMessage
 */
-(XHMessage *)getImageMessage:(ImChatLogModel *)chatLogModel{
    XHMessage *message = nil;
    
    __block NSString *fileName = chatLogModel.imClmBodyModel.fileModel.smalliconclientname;
    
    /* 非gif图片 */
    if(![[fileName lowercaseString] hasSuffix:@"gif"]){
        __block UIImage *picImage = nil;
        NSString *url = nil;
        LZBubbleMessageMediaTypeSmallPhoto lzSmallPhoto = nil;
        
        NSString *savePath = @"";
        if([chatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
            savePath=[FilePathUtil getChatSendImageSmallDicAbsolutePath];
        } else {
            savePath=[FilePathUtil getChatRecvImageSmallDicAbsolutePath];
        }
        
        NSString *picImagePath = [NSString stringWithFormat:@"%@%@",savePath,fileName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        /* 本地图片地址 */
        if([fileManager fileExistsAtPath:picImagePath]){
//            picImage = [UIImage imageNamed:picImagePath];
            picImage = [UIImage imageWithContentsOfFile:picImagePath];
            /* ios11高效live图 */
            if([[fileName lowercaseString] hasSuffix:@"heic"]){
                /* 微信目前的处理方式是转换成了 jpg 格式，因此直接使用 UIImageJPEGRepresentation(originalImage, 0.82); 转换为jpg即可
                 但是经多次测试后发现，必须设置压缩比为0.82，转换后的大小才尽可能的接近原图大小 */
                NSData *imageData = UIImageJPEGRepresentation(picImage, 0.82);
                picImage = [UIImage imageWithData:imageData];
            }
        }
        /* 网络图片地址 */
        else {
            url = [GalleryImageViewModel GetGalleryThumbnailImageUrlFileId:chatLogModel.imClmBodyModel.bodyModel.fileid size:@"200X200"];
            
            lzSmallPhoto = ^(UIImage *image, NSData *data, NSError *error, BOOL finished){
                if (image && finished) {
                    DDLogVerbose(@"-----聊天界面缩略图下载完成");
                    /* ios11高效live图 */
                    if([[fileName lowercaseString] hasSuffix:@"heic"]){
                        /* 微信目前的处理方式是转换成了 jpg 格式，因此直接使用 UIImageJPEGRepresentation(originalImage, 0.82); 转换为jpg即可
                         但是经多次测试后发现，必须设置压缩比为0.82，转换后的大小才尽可能的接近原图大小 */
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.82);
                        message.photo = [UIImage imageWithData:imageData];
                        if([fileName rangeOfString:@"."].location!=NSNotFound){
                            fileName = [fileName stringByReplacingOccurrencesOfString:@"HEIC" withString:@"JPG"];
                        }
                    }
                    else{
                       message.photo = image;
                    }
                    if ([NSString isNullOrEmpty:[[fileName componentsSeparatedByString:@"."] objectAtIndex:1]]) {
                        fileName = [fileName stringByAppendingString:@"JPG"];
                    }
                    [fileManager createFileAtPath:[savePath stringByAppendingFormat:@"%@",fileName] contents:data attributes:nil];
                }
            };
        }
        
        message = [[XHMessage alloc] initWithPhoto:picImage
                                      thumbnailUrl:url
                                    thumbnailBlock:lzSmallPhoto
                                    originPhotoUrl:nil
                                            sender:@""
                                         timestamp:chatLogModel.showindexdate];
        
        /* 添加上传进度 */
        if(chatLogModel.sendstatus==Chat_Msg_Sending){
            message.uploadProgress = @"0";
            if(![NSString isNullOrEmpty:chatLogModel.clienttempid]
               && [_uploadingDic lzNSStringForKey:chatLogModel.clienttempid]){
                message.uploadProgress = [_uploadingDic lzNSStringForKey:chatLogModel.clienttempid];
            }
        }
    }
    /* gif图片 */
    else {
        __block FLAnimatedImage *emotionImage = nil;
        __block UIImage *smallImage = nil;
        NSString *emotionPath = nil;
        LZBubbleMessageMediaTypeSmallPhoto emotionImageBlock = nil;

        NSString *emotionDicPath = @"";
        if([chatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
            emotionDicPath=[FilePathUtil getChatSendImageDicAbsolutePath];
        } else {
            emotionDicPath=[FilePathUtil getChatRecvImageDicAbsolutePath];
        }
        emotionDicPath = [NSString stringWithFormat:@"%@%@",emotionDicPath,fileName];
        NSString *emotionFileID = chatLogModel.imClmBodyModel.bodyModel.fileid;
        emotionPath = [GalleryImageViewModel GetGalleryOriImageUrlFileId:chatLogModel.imClmBodyModel.bodyModel.fileid];
            
        NSFileManager *fileManager = [NSFileManager defaultManager];
        /* 本地Gif图片存在 */
        if([fileManager fileExistsAtPath:emotionDicPath]){
            NSData *animatedData = [NSData dataWithContentsOfFile:emotionDicPath];
//            emotionImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedData];
            smallImage = [UIImage sd_animatedGIFWithData:animatedData];
        }
        /* Gif图片不存在 */
        if(smallImage==nil) {
            emotionImageBlock = ^(UIImage *image, NSData *data, NSError *error, BOOL finished){
                if (image && finished) {
//                    FLAnimatedImage *image = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data]; //废弃，滑动时图片静止
//                    message.emotionImage = image;
                    message.emotionSmallImage = [UIImage sd_animatedGIFWithData:data];
                    DDLogVerbose(@"------小图存在--保存小图");
                    [fileManager createFileAtPath:emotionDicPath contents:data attributes:nil];
                }
            };
        }

        message = [[XHMessage alloc] initWithEmotionPath:emotionPath
                                           emotionFileID:emotionFileID
                                                  sender:@""
                                               timestamp:chatLogModel.showindexdate];
        
        message.emotionImage = emotionImage;  //废弃，滑动时图片静止
        message.emotionPath = emotionPath;
        message.emotionImageBlock = emotionImageBlock;
        message.emotionSmallImage = smallImage;
    }

    return message;
}

/**
 *  添加发送状态
 */
-(void)addReadStatusToMessage:(XHMessage *)message chatLogModel:(ImChatLogModel *)chatLogModel{
    /* 处理发送状态文字 */
    if(message.sendStatus == Chat_Msg_SendSuccess){
        if(_contactType == Chat_ContactType_Main_One){
            if([chatLogModel.from isEqualToString:chatLogModel.to] ||
               [chatLogModel.handlertype isEqualToString:Handler_Message_LZChat_VoiceCall] ||
               [chatLogModel.handlertype isEqualToString:Handler_Message_LZChat_VideoCall] ||
               chatLogModel.isrecordstatus == 0){
                message.sendStatusTextIsClick = NO;
                message.sendStatusText = @"";
                message.sendStatusTextIsHL = NO;
            } else {
                message.sendStatusTextIsClick = NO;
                message.sendStatusText = chatLogModel.imClmBodyModel.readstatusModel.unreadcount==0 ? @"已读" : @"未读";
                message.sendStatusTextIsHL = chatLogModel.imClmBodyModel.readstatusModel.unreadcount!=0 ;
            }
        }
        else {
            if (chatLogModel.isrecordstatus == 0) {
                message.sendStatusTextIsClick = NO;
                message.sendStatusText = @"";
                message.sendStatusTextIsHL = NO;
            }
            else if(chatLogModel.imClmBodyModel.readstatusModel.unreadcount==0){
                message.sendStatusTextIsClick = NO;
                message.sendStatusText = @"全部已读";
                message.sendStatusTextIsHL = NO;
            }
            else {
                message.sendStatusTextIsClick = YES;
                message.sendStatusText = [NSString stringWithFormat:@"%ld人未读",(long)chatLogModel.imClmBodyModel.readstatusModel.unreadcount];
                message.sendStatusTextIsHL = YES;
            }
        }
    }
}

#pragma mark - 自动下载聊天记录

/**
 *  检测是否需要自动下载聊天记录
 */
-(void)checkIsNeedDownChatLog:(NSString *)dialogid{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* 根据对话框ID得到最近消息模型 */
        ImRecentModel *imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:dialogid];
        /* 聊天记录下载到的位置 */
        NSString *preSynck = imRecentModel.presynck;
        NSDate *preSynckDate = imRecentModel.presynckdate;
        

        NSMutableDictionary *syncDic = [LZUserDataManager readSynkInfo];
        NSString *synck = [syncDic lzNSStringForKey:[AppUtils GetCurrentUserID]];
        
        //消息、临时通知、持久通知
        NSString *msgSynk = @"";
        if(![NSString isNullOrEmpty:synck]){
            NSArray *array = [synck componentsSeparatedByString:@"_"];
            msgSynk = [array objectAtIndex:0];
        }
        
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setObject:[[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"] forKey:@"uid"];
        [postData setObject:dialogid forKey:@"container"];
        [postData setObject:[NSString stringWithFormat:@"%ld",(long)_contactType] forKey:@"fromtype"];
        [postData setObject:@"1" forKey:@"queryDirection"];
    //    /* 未下载过 */
    //    if([NSString isNullOrEmpty:preSynck] || [NSString isNullOrEmpty:msgSynk]){
    //        [postData setObject:@"" forKey:@"synckey"];
    //        /* 默认下载150条 */
    //        [postData setObject:@"150" forKey:@"datacount"];
    //    } else {
    //        [postData setObject:msgSynk forKey:@"synckeyend"];
    //        /* 根据presynck获取对应聊天记录的时间 */
    //        NSInteger days = [AppDateUtil IntervalDays:preSynckDate endDate:[AppDateUtil GetCurrentDate]];
    //        if(days<=7){
    //            [postData setObject:preSynck forKey:@"synckey"];
    //        } else {
    //            [postData setObject:@"150" forKey:@"datacount"];
    //        }
    //    }

        /* 未下载过 */
        if([NSString isNullOrEmpty:preSynck]){
            [postData setValue:imRecentModel.lastmsgid forKey:@"synckey"];
            /* 默认下载150条 */
            [postData setValue:@"150" forKey:@"datacount"];
            [postData setValue:[NSNumber numberWithBool:YES] forKey:@"isfirst"];
        } else {
            /* 根据presynck获取对应聊天记录的时间 */
            NSInteger days = [AppDateUtil IntervalDays:preSynckDate endDate:[AppDateUtil GetCurrentDate]];
            if(days<=7){
                [postData setValue:preSynck forKey:@"synckeyend"];
                [postData setValue:msgSynk forKey:@"synckey"];// 最近一条消息
                [postData setValue:@"500" forKey:@"datacount"];
            } else {
                [postData setValue:msgSynk forKey:@"synckey"];
                [postData setValue:@"150" forKey:@"datacount"];
            }
        }
        
        [self.appDelegate.lzservice sendToServerForPost:WebApi_ChatLog
                                              routePath:WebApi_ChatLog_GetChatLogList
                                           moduleServer:Modules_Message
                                                getData:nil
                                               postData:postData
                                              otherData:@{WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll}];
    });
}

/**
 到达顶端之后，下载150条聊天记录
 */
- (void)downloadMoreMessage:(NSString *)dialogid messageCount:(NSInteger)messageCount {

    /* 从数据库中获取记录 */
    NSMutableArray *chatLogArray = [[[ImChatLogDAL alloc] init] getChatLogWithDialogid:dialogid startNum:0 queryCount:messageCount];
    ImChatLogModel *chatLogModel = [chatLogArray firstObject];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setObject:[[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"] forKey:@"uid"];
    [postData setObject:dialogid forKey:@"container"];
    [postData setObject:[NSString stringWithFormat:@"%ld",(long)_contactType] forKey:@"fromtype"];
    [postData setObject:@"1" forKey:@"queryDirection"];
    
    [postData setObject:chatLogModel.msgid forKey:@"synckey"];
    [postData setObject:@"150" forKey:@"datacount"];
   
    [self.appDelegate.lzservice sendToServerForPost:WebApi_ChatLog
                                          routePath:WebApi_ChatLog_GetChatLogList
                                       moduleServer:Modules_Message
                                            getData:nil
                                           postData:postData
                                          otherData:@{WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll,
                                                      @"isDownloadMore":@"1"}];
}

/**
 *  请求群管理员，200条群成员数据
 */
-(void)loadGroupAdminAndUser:(NSString *)dialogid{
    if(_contactType != Chat_ContactType_Main_One){
        ImGroupModel *toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:dialogid];
        if(toGroupModel!=nil){
            /* 本地不含有管理员信息，需要获取，供群成员查看界面使用 */
            if([[UserDAL shareInstance] getUserModelForNameAndFace:toGroupModel.createuser]==nil){
                [self.appDelegate.lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_LoadUser moduleServer:Modules_Default getData:nil postData:toGroupModel.createuser otherData:@{WebApi_DataSend_Other_Operate:@"nooperate"}];
            }
            /* 请求群人员数据 */
            NSInteger userCount = [[ImGroupUserDAL shareInstance] getGroupUserCountWithIgid:toGroupModel.igid];
            /* 如果当前群内人员数量比实际数量少并且少于200 */
            if(toGroupModel.usercount > userCount && userCount < ChatGroupList_PageSize && toGroupModel.isnottemp == 1){
                
                NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
                [postData setObject:[NSNumber numberWithInteger:ChatGroupList_PageSize] forKey:@"pagesize"];
                [postData setObject:toGroupModel.igid forKey:@"groupid"];
                [postData setObject:[NSNumber numberWithInteger:userCount] forKey:@"searchindex"];
                
                [self.appDelegate.lzservice sendToServerForPost:WebApi_ImGroup
                                                      routePath:WebApi_ImGroup_GetGroupUsersByPages
                                                   moduleServer:Modules_Message
                                                        getData:nil
                                                       postData:postData
                                                      otherData:@{WebApi_DataSend_Other_Operate:@"nooperate"}];
            }
        }
    }
}


#pragma mark - 刷新未读数字、发送回执   （供所有显示在消息页签的VC调用）

/**
 *  刷新未读数字
 */
-(void)refreshMsgUnReadCount:(NSString *)dialogid{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 将一级消息未读数量更新未0
        if(_parsetype!=0){
            NSString *firstDialogID = [[dialogid componentsSeparatedByString:@"."] objectAtIndex:0];
            if( [[ImRecentDAL shareInstance] getImRecentNoReadMsgCountWithDialogID:firstDialogID]>0){
                [[ImRecentDAL shareInstance] updateBadgeCountTo0ByContactid:firstDialogID];
            }
        }
        
        if( [[ImRecentDAL shareInstance] getImRecentNoReadMsgCountWithDialogID:dialogid]>0){
            /* 更新未读数量为0 */
            [[ImRecentDAL shareInstance] updateBadgeCountTo0ByContactid:dialogid];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshMessageRootVC:dialogid];
                
                /* 立刻刷新消息列表界面 */
                EVENT_PUBLISH_WITHDATA(self, EventBus_Chat_RefreshMessageRootVC_Now, nil);
                self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForChatVC = NO;
            });
        }
    });
}

/**
 *  发送回执
 */
-(void)sendReportToServer:(NSString *)dialogid{
    NSInteger otherNoReadCount = [[ImRecentDAL shareInstance] getImRecentNoReadMsgCountWithExceptDialog:@[dialogid]];
    
    /* 发送消息回执 */
    NSMutableArray *msgids = [[ImChatLogDAL shareInstance] getRecvIsNoReadWithDialogId:dialogid];
    
    //业务会话时，需要把一级消息也发送出回执
    if(_sendToType == Chat_ToType_Five || _sendToType == Chat_ToType_Six ){
        NSMutableArray *msgidsForFirst = [[ImChatLogDAL shareInstance] getRecvIsNoReadWithDialogId:[NSString stringWithFormat:@"%ld",(long)_sendToType]];
        [msgids addObjectsFromArray:msgidsForFirst];
    }
    
    if(msgids.count>0){
        NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
        [getData setObject:@"1" forKey:@"msgqueue"];
        [getData setObject:@"2" forKey:@"type"];
        [getData setObject:[NSString stringWithFormat:@"%ld",(long)otherNoReadCount] forKey:@"badge"];
        for (int i=0; i<msgids.count; i++) {
            /* 记录到发送队列 */
            ImMsgQueueModel *imMsgQueueModel = [[ImMsgQueueModel alloc] init];
            imMsgQueueModel.mqid = [LZUtils CreateGUID];
            imMsgQueueModel.module = Modules_Message_Receipt;
            imMsgQueueModel.route = WebApi_Message_Send;
            imMsgQueueModel.data = [msgids objectAtIndex:i];
            imMsgQueueModel.createdatetime = [AppDateUtil GetCurrentDate];
            imMsgQueueModel.updatedatetime = [AppDateUtil GetCurrentDate];
            [[ImMsgQueueDAL shareInstance] addImMsgQueueModelModel:imMsgQueueModel];
        }
        /* 分组发送 */
        while (msgids.count>0) {
            NSInteger subCount = msgids.count>1000 ? 1000 : msgids.count;
            NSArray *sendMsgids = [msgids subarrayWithRange:NSMakeRange(0,subCount)];
            [msgids removeObjectsInRange:NSMakeRange(0,subCount)];
            [self.appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_Report moduleServer:Modules_Message getData:getData postData:sendMsgids otherData:@{WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll}];
        }
    }
}

#pragma mark - 消息删除添加队列

- (void)addDeleteMsgToMsgQueue:(NSMutableArray *)msgidArr dialogID:(NSString *)dialogID {
    for (int i=0; i<msgidArr.count; i++) {
        /* 记录到发送队列 */
        ImMsgQueueModel *imMsgQueueModel = [[ImMsgQueueModel alloc] init];
        imMsgQueueModel.mqid = [LZUtils CreateGUID];
        imMsgQueueModel.module = Modules_Message;
        imMsgQueueModel.route = WebApi_Message_DeleteMsg;
        imMsgQueueModel.data = [NSString stringWithFormat:@"%@,%@", [msgidArr objectAtIndex:i], dialogID];
        imMsgQueueModel.createdatetime = [AppDateUtil GetCurrentDate];
        imMsgQueueModel.updatedatetime = [AppDateUtil GetCurrentDate];
        imMsgQueueModel.status = Message_Queue_Sending;
        [[ImMsgQueueDAL shareInstance] addImMsgQueueModelModel:imMsgQueueModel];
    }
}
#pragma mark - 消息发送相关

/**
 *  组织发送的服务器的MsgInfo信息
 *
 *  @param toDialogID  发送至的用户ID
 *  @param handlerType 处理类型
 *
 *  @return 组织好的字典数据
 */
-(NSMutableDictionary *)getSendMsgInfo:(NSString *)toDialogID
                           handlerType:(NSString *)handlerType
{
    NSString *msgid = [LZUtils CreateGUID];
    NSString *clienttempid = [LZUtils CreateGUID];
    
    NSString *currentDate = [AppDateUtil GetCurrentDateForString];
	
    NSMutableDictionary *msgInfo = [[NSMutableDictionary alloc] init];
    [msgInfo setObject:msgid forKey:@"msgid"];
    [msgInfo setObject:clienttempid forKey:@"clienttempid"];
    [msgInfo setObject:@"1" forKey:@"clienttype"];
    if(![NSString isNullOrEmpty:_bkid]){
        [msgInfo setObject:_bkid forKey:@"bkid"];
    } else {
        [msgInfo setObject:@"" forKey:@"bkid"];
    }

    [msgInfo setObject:handlerType forKey:@"handlertype"];
    [msgInfo setObject:currentDate forKey:@"senddatetime"];
    [msgInfo setObject:[NSNumber numberWithInteger:Chat_FromType_Zero] forKey:@"fromtype"];
    [msgInfo setObject:[[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"] forKey:@"from"];
    
    if(_contactType == Chat_ContactType_Main_ChatGroup){
        [msgInfo setObject:[NSNumber numberWithInteger:Chat_ToType_One] forKey:@"totype"];
    }
    else if(_contactType == Chat_ContactType_Main_CoGroup){
        [msgInfo setObject:[NSNumber numberWithInteger:Chat_ToType_Two] forKey:@"totype"];
    }
    else {
        [msgInfo setObject:[NSNumber numberWithInteger:Chat_ToType_Zero] forKey:@"totype"];
    }
    [msgInfo setObject:toDialogID forKey:@"belongto"];
    [msgInfo setObject:toDialogID forKey:@"to"];
    
    if(![NSString isNullOrEmpty:_appCode]){
        [msgInfo setObject:_appCode forKey:@"app"];
    }
    if(_sendMode!=0){
        [msgInfo setObject:[NSNumber numberWithInteger:_sendMode] forKey:@"sendmode"];
    }
    if(_sendToType!=0){
        [msgInfo setObject:[NSNumber numberWithInteger:_sendToType] forKey:@"totype"];
    }
    if(_parsetype!=0){
        [msgInfo setObject:[NSNumber numberWithInteger:_parsetype] forKey:@"parsetype"];
    }

    //记录已读状态
    NSMutableDictionary *readStatusDic = [[NSMutableDictionary alloc] init];
    if(_contactType == Chat_ContactType_Main_ChatGroup ||
       _contactType == Chat_ContactType_Main_CoGroup ||
       _contactType == Chat_ContactType_Main_App_Seven ||
       _contactType == Chat_ContactType_Main_App_Eight ){
//        NSMutableArray *userIDArray = [[ImGroupUserDAL shareInstance] getGroupUserIDsWithIgid:toDialogID];
//        NSMutableDictionary *unreadDic = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary *readDic = [[NSMutableDictionary alloc] init];
//        for(NSString *uid in userIDArray){
//            if([uid isEqualToString:currentUserID]){
//                continue;
//            }
//            
//            [unreadDic setObject:toDialogID forKey:uid];
//        }
//        NSInteger otherCount = (userIDArray.count > 0) ? (userIDArray.count-1) : 0;
//        [readStatusDic setObject:[NSNumber numberWithInteger:otherCount] forKey:@"unreadcount"];
//        [readStatusDic setObject:[NSNumber numberWithInteger:otherCount] forKey:@"count"];
//        [readStatusDic setObject:unreadDic  forKey:@"unreaduserlist"];
//        [readStatusDic setObject:readDic  forKey:@"readuserlist"];
        ImGroupModel *imGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:toDialogID];
        NSInteger otherCount = (imGroupModel.usercount > 0) ? (imGroupModel.usercount-1) : 0;
        [readStatusDic setObject:[NSNumber numberWithInteger:otherCount] forKey:@"unreadcount"];
        [readStatusDic setObject:[NSNumber numberWithInteger:otherCount] forKey:@"count"];
        [readStatusDic setObject:[[NSMutableDictionary alloc] init]  forKey:@"unreaduserlist"];
        [readStatusDic setObject:[[NSMutableDictionary alloc] init]  forKey:@"readuserlist"];

    }
    else {
//        NSMutableDictionary *unreadDic = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary *readDic = [[NSMutableDictionary alloc] init];
//        [unreadDic setObject:toDialogID forKey:toDialogID];
        
        [readStatusDic setObject:[NSNumber numberWithInteger:1] forKey:@"unreadcount"];
        [readStatusDic setObject:[NSNumber numberWithInteger:1] forKey:@"count"];
        [readStatusDic setObject:[[NSMutableDictionary alloc] init]  forKey:@"unreaduserlist"];
        [readStatusDic setObject:[[NSMutableDictionary alloc] init]  forKey:@"readuserlist"];
//        [readStatusDic setObject:unreadDic forKey:@"unreaduserlist"];
//        [readStatusDic setObject:readDic  forKey:@"readuserlist"];
    }
    [msgInfo setObject:[readStatusDic dicSerial] forKey:@"readstatus"];
    
    
    return msgInfo;
}

/**
 *  将发送信息保存至数据库
 *
 *  @param msgInfo 发送至服务器的信息
 *
 *  @return 新添加的Model
 */
-(ImChatLogModel *)saveChatLogModelWithDic:(NSMutableDictionary *)msgInfo{
    
    NSString *dialogID = [msgInfo lzNSStringForKey:@"to"];
    
    ImChatLogModel *imChatLogModel = [[ImChatLogModel alloc] init];
    imChatLogModel.msgid = [msgInfo lzNSStringForKey:@"msgid"];
    imChatLogModel.clienttempid = [msgInfo lzNSStringForKey:@"clienttempid"];
    imChatLogModel.dialogid = dialogID;
    imChatLogModel.fromtype = ((NSNumber *)[msgInfo objectForKey:@"fromtype"]).integerValue;
    imChatLogModel.from = [msgInfo lzNSStringForKey:@"from"];
    imChatLogModel.totype = ((NSNumber *)[msgInfo objectForKey:@"totype"]).integerValue;
    imChatLogModel.to = [msgInfo lzNSStringForKey:@"to"];
    imChatLogModel.body = [msgInfo dicSerial];
    imChatLogModel.showindexdate = [LZFormat String2Date:[msgInfo lzNSStringForKey:@"senddatetime"]];
    imChatLogModel.handlertype = [msgInfo lzNSStringForKey:@"handlertype"];
    imChatLogModel.sendstatus = Chat_Msg_Sending;
    imChatLogModel.recvstatus = Chat_Msg_Downloadsuccess;
    imChatLogModel.recvisread = 1;
    imChatLogModel.isrecordstatus = [msgInfo lzNSNumberForKey:@"isrecordstatus"].integerValue;
    imChatLogModel.at = [[msgInfo lzNSMutableArrayForKey:@"at"] arraySerial];
    //为二级消息聊天框时，需要对二级消息列表刷新
    if(_parsetype!=0){
        imChatLogModel.dialogid = [NSString stringWithFormat:@"%ld.%@",imChatLogModel.totype,dialogID];
    }
    
    /* 当前人不在群组中时，发送消息 */
    if(imChatLogModel.totype == Chat_ToType_One
       ||imChatLogModel.totype == Chat_ToType_Two ){
        ImGroupModel *toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:imChatLogModel.to];
        if(toGroupModel == nil || toGroupModel.isclosed==1 || (_imRecentModel!=nil && _imRecentModel.isexistsgroup==0)){
            imChatLogModel.sendstatus = Chat_Msg_SendFail;
        }
    }
    
    NSString *handlertype = imChatLogModel.imClmBodyModel.handlertype;

    /* 文件类型 */
    if([handlertype hasSuffix:Handler_Message_LZChat_File_Download]){
        imChatLogModel.recvstatus = Chat_Msg_NoDownload;
    }
    /* 视频通话这种情况只发通知 */
    if (![handlertype hasSuffix:Handler_Message_LZChat_Call_Notice] && ![handlertype hasSuffix:Handler_Message_LZChat_Call_Receive] && ![handlertype hasSuffix:Handler_Message_LZChat_Call_Speech]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            [[ImChatLogDAL shareInstance] addChatLogModel:imChatLogModel];
            BOOL isGetedContactName = [[ImRecentDAL shareInstance] updateLastMsgWithDialogid:imChatLogModel.dialogid];
            /* 需要发送webapi获取当前人，或群的信息 */
            if(!isGetedContactName){
                if(imChatLogModel.totype != Chat_ToType_Zero ){
                    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
                    [postData setObject:dialogID forKey:@"groupid"];
                    [postData setObject:[NSNumber numberWithInteger:ChatGroupList_PageSize] forKey:@"pagesize"];
                    [self.appDelegate.lzservice sendToServerForPost:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfoByPages moduleServer:Modules_Message getData:nil postData:postData otherData:@{WebApi_DataSend_Other_Operate:@"update_imrecent"}];
                }
                else {
                    [self.appDelegate.lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_LoadUser moduleServer:Modules_Default getData:nil postData:imChatLogModel.dialogid otherData:@{WebApi_DataSend_Other_Operate:@"update_imrecent"}];
                }
            }
            
            //为二级消息聊天框时，需要对二级消息列表刷新
            if(_parsetype!=0){

                [msgInfo setObject:[NSNumber numberWithInteger:0] forKey:@"parsetype"];
                [msgInfo setObject:[NSString stringWithFormat:@"%@_First",imChatLogModel.msgid] forKey:@"msgid"];
                [msgInfo setObject:[NSString stringWithFormat:@"%@_First",imChatLogModel.clienttempid] forKey:@"clienttempid"];
                
                ImChatLogModel *firstImChatLogModel =  [[ImChatLogModel alloc] init];
                firstImChatLogModel.msgid = [msgInfo lzNSStringForKey:@"msgid"];
                firstImChatLogModel.clienttempid = [msgInfo lzNSStringForKey:@"clienttempid"];
                firstImChatLogModel.dialogid = [NSString stringWithFormat:@"%ld",imChatLogModel.totype];
                firstImChatLogModel.fromtype = ((NSNumber *)[msgInfo objectForKey:@"fromtype"]).integerValue;
                firstImChatLogModel.from = [msgInfo lzNSStringForKey:@"from"];
                firstImChatLogModel.totype = ((NSNumber *)[msgInfo objectForKey:@"totype"]).integerValue;
                firstImChatLogModel.to = [msgInfo lzNSStringForKey:@"to"];
                firstImChatLogModel.body = [msgInfo dicSerial];
                firstImChatLogModel.showindexdate = [LZFormat String2Date:[msgInfo lzNSStringForKey:@"senddatetime"]];
                firstImChatLogModel.handlertype = [msgInfo lzNSStringForKey:@"handlertype"];
                firstImChatLogModel.sendstatus = Chat_Msg_Sending;
                firstImChatLogModel.recvstatus = Chat_Msg_Downloadsuccess;
                firstImChatLogModel.recvisread = 1;
                firstImChatLogModel.isrecordstatus = [msgInfo lzNSNumberForKey:@"isrecordstatus"].integerValue;
                firstImChatLogModel.sendstatus = imChatLogModel.sendstatus;
                firstImChatLogModel.recvstatus = imChatLogModel.recvstatus;
                firstImChatLogModel.at = [[msgInfo lzNSMutableArrayForKey:@"at"] arraySerial];
                
                [[ImChatLogDAL shareInstance] addChatLogModel:firstImChatLogModel];
                BOOL isGetedContactName = [[ImRecentDAL shareInstance] updateLastMsgWithDialogid:firstImChatLogModel.dialogid];
                /* 需要发送webapi获取当前人，或群的信息 */
                if(!isGetedContactName){
                    if(firstImChatLogModel.totype != Chat_ToType_Zero ){
                        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
                        [postData setObject:dialogID forKey:@"groupid"];
                        [postData setObject:[NSNumber numberWithInteger:ChatGroupList_PageSize] forKey:@"pagesize"];
                        [self.appDelegate.lzservice sendToServerForPost:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfoByPages moduleServer:Modules_Message getData:nil postData:postData otherData:@{WebApi_DataSend_Other_Operate:@"update_imrecent"}];
                    }
                    else {
                        [self.appDelegate.lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_LoadUser moduleServer:Modules_Default getData:nil postData:firstImChatLogModel.dialogid otherData:@{WebApi_DataSend_Other_Operate:@"update_imrecent"}];
                    }
                }
            }
            
            
            [self refreshMessageRootVC:imChatLogModel.dialogid];
            
            
        });
    }
    
    return imChatLogModel;
}

#pragma mark - 消息发送、接收通用方法

/**
 *  添加新的聊天记录
 *
 *  @param chatLogModel 聊天信息
 *
 *  @return XHMessage对象
 */
-(XHMessage *)addNewXHMessageWithImChatLogModel:(ImChatLogModel *)chatLogModel messages:(NSMutableArray *)messages{

    XHMessage *message = [self convertChatLogModelToXHMessage:chatLogModel];
    
    if(latestShowDate==nil && messages.count>0){
        XHMessage *xhMessage = [messages objectAtIndex:messages.count-1];
        latestShowDate = xhMessage.imChatLogModel.showindexdate;
    }
    
    /* 时间是否显示的逻辑判断 */
    BOOL isDispalyTimestamp = NO;
    if(latestShowDate==nil){
        latestShowDate = chatLogModel.showindexdate;
        isDispalyTimestamp = YES;
    }
    else {
        
        NSInteger intervalSec = [AppDateUtil IntervalSeconds:latestShowDate endDate:chatLogModel.showindexdate];
        /* 与上一次显示超过三分钟，则显示 */
        if(intervalSec>DEFAULT_TIMESTAMP_INTERVAL){
            isDispalyTimestamp = YES;
        }
    }
    if(isDispalyTimestamp){
        message.isDisplayTimestamp = YES;
        /* 记录下最后一次的显示时间 */
        latestShowDate = chatLogModel.showindexdate;
    }
    
    if([chatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
        [self addReadStatusToMessage:message chatLogModel:chatLogModel];
    }

    return message;
}

#pragma mark - 加入到消息队列
/**
 *  将待发送消息添加至队列
 *
 *  @param data 消息数据
 */
-(void)addToMsgQueue:(NSMutableDictionary *)data{
   
   
//    dispatch_async(self.appDelegate.lzGlobalVariable.imSendMsgQueue, ^{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSMutableDictionary *msgInfo = [[NSMutableDictionary alloc] initWithDictionary:data];
        /* 转换to */
        NSString *to = (NSString *)[msgInfo objectForKey:@"to"];
        
        NSMutableArray *toArray = [[NSMutableArray alloc] init];
        [toArray addObject:to];
        [msgInfo setObject:toArray forKey:@"to"];

        [msgInfo removeObjectForKey:@"fileinfo"];
        [msgInfo removeObjectForKey:@"voiceinfo"];
        [msgInfo removeObjectForKey:@"geolocationinfo"];
        [msgInfo removeObjectForKey:@"readstatus"];
        
        /* 记录到发送队列 */
        ImMsgQueueModel *imMsgQueueModel = [[ImMsgQueueModel alloc] init];
        imMsgQueueModel.mqid = [msgInfo objectForKey:@"clienttempid"];
        imMsgQueueModel.module = Modules_Message;
        imMsgQueueModel.route = WebApi_Message_Send;
        imMsgQueueModel.data = [msgInfo dicSerial];
        imMsgQueueModel.createdatetime = [AppDateUtil GetCurrentDate];
        imMsgQueueModel.updatedatetime = [AppDateUtil GetCurrentDate];
        imMsgQueueModel.status = Message_Queue_Sending;
        [[ImMsgQueueDAL shareInstance] addImMsgQueueModelModel:imMsgQueueModel];
    });
}

#pragma mark - 文件上传

/**
 *  添加上传文件到队列
 *
 *  @param imChatLogModel 上传文件所需信息
 */
-(void)addToUploadFileQueue:(ImChatLogModel *)imChatLogModel{
    if(!fileSendArray){
        fileSendArray = [[NSMutableArray alloc] init];
    }
    
    [fileSendArray addObject:imChatLogModel];
}

/**
 *  添加上传文件信息
 *
 *  @param imChatLogModel 上传文件所需信息
 *  @param progressBlock  更新进度上传block方法
 */
-(void)addToUploadFileQueueAndBegin:(ImChatLogModel *)imChatLogModel
                      progressBlock:(ChatViewModelUpdateFileUploadProgress)fileUploadProgress{

    if(!fileSendArray){
        fileSendArray = [[NSMutableArray alloc] init];
    }
    
    [fileSendArray addObject:imChatLogModel];
    _updateFileUploadProgress = fileUploadProgress;
    
    /* 若队列中的WebApi未正在请求，则需要开始请求 */
    if(!isUploadingFile){
        isUploadingFile = YES;
        /* 开始上传 */
        [self uploadBegin];
    }
}

/**
 *  开始循环上传文件
 */
-(void)uploadBegin{
    
    if([fileSendArray count]<=0){
        isUploadingFile = NO;
        return;
    }
    
    ImChatLogModel *imChatLogModel = [fileSendArray objectAtIndex:0];

    LZFileProgressUpload lzFileProgressUpload = ^(float percent, NSString *tag, id otherInfo){
        NSLog(@"上传进度=======%@",[NSString stringWithFormat:@"%0.f%%",percent*100]);
        if([[NSString stringWithFormat:@"%0.f%%",percent*100] isEqualToString:@"100%"]){
            return;
        }
        if(_updateFileUploadProgress){
            _updateFileUploadProgress(percent,imChatLogModel);
        }
    };
    LZFileDidSuccessUpload lzFileDidSuccessUpload = ^(NSDictionary *result, NSString *tag, id otherInfo){
        NSLog(@"文件上传成功 - result（json）：%@ - tag:%@",result,tag);
        [self afterUploadFinish:otherInfo WithIsSuccess:YES WithResult:result];
    };
    LZFileDidErrorUpload lzFileDidErrorUpload = ^(NSString *title, NSString *message, NSString *tag, id otherInfo){
        NSLog(@"文件上传失败 - title:%@ - message:%@",title,message);
        [self afterUploadFinish:otherInfo WithIsSuccess:NO WithResult:nil];
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LZFileTransfer * lzFileTransfer = [LZCloudFileTransferMain getLZFileTransferForUploadWithFileType:File_Upload_FileType_IM Progress:lzFileProgressUpload success:lzFileDidSuccessUpload error:lzFileDidErrorUpload];

        dispatch_async(dispatch_get_main_queue(), ^{
            lzFileTransfer.showFileName = [[[imChatLogModel.body seriaToDic] lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"name"];
            
            /* 上传图片 */
            if([imChatLogModel.imClmBodyModel.handlertype isEqualToString:Handler_Message_LZChat_Image_Download] ){
                lzFileTransfer.localFileName = imChatLogModel.imClmBodyModel.fileModel.smalliconclientname;
                
            }
            /* 上传视频 */
            if ([imChatLogModel.imClmBodyModel.handlertype isEqualToString:Handler_Message_LZChat_Micro_Video]) {
                ImChatLogModel *newImChatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:imChatLogModel.msgid orClienttempid:imChatLogModel.clienttempid];
                NSString *videoFileID = [newImChatLogModel.imClmBodyModel.body lzNSStringForKey:@"videofileid"];
                NSString *coverFileID = [newImChatLogModel.imClmBodyModel.body lzNSStringForKey:@"imagefileid"];
                if([NSString isNullOrEmpty:videoFileID] && [NSString isNullOrEmpty:coverFileID]){
                    lzFileTransfer.localFileName = imChatLogModel.imClmBodyModel.fileModel.smalliconclientname;
                } else {
                    lzFileTransfer.localFileName = imChatLogModel.imClmBodyModel.fileModel.smallvideoclientname;
                }
            }
            /* 上传文件 */
            else if( [imChatLogModel.imClmBodyModel.handlertype isEqualToString:Handler_Message_LZChat_File_Download] ){
                lzFileTransfer.localFileName = imChatLogModel.imClmBodyModel.fileModel.smallfileclientname;
            }
            /* 上传语音文件 */
            else if( [imChatLogModel.imClmBodyModel.handlertype isEqualToString:Handler_Message_LZChat_Voice] ){
                lzFileTransfer.localFileName = imChatLogModel.imClmBodyModel.voiceModel.amrname;
            }
            /* 上传当前 */
            else if ( [imChatLogModel.imClmBodyModel.handlertype isEqualToString:Handler_Message_LZChat_Geolocation] ){
                lzFileTransfer.localFileName = imChatLogModel.imClmBodyModel.geolocationModel.geoimagename;
            }
            lzFileTransfer.localPath = [FilePathUtil getChatSendImageDicRelatePath];
            lzFileTransfer.otherInfo = imChatLogModel;
            
            [lzFileTransfer uploadFile];
        });
    });
}

//上传成功、或失败后调用
-(void)afterUploadFinish:(id)otherInfo WithIsSuccess:(BOOL)isSuccess WithResult:(NSDictionary *)result{
    
    ImChatLogModel *imChatLogModel = (ImChatLogModel *)otherInfo;
    
    //传递相关数据（失败）
    if (!isSuccess || ![result isKindOfClass:[NSDictionary class]]) {
        [self afterUploadFail:imChatLogModel];
    }
    /* 成功 */
    else {
        NSString *fileId = [result lzNSStringForKey:@"fileid"];
        
        if([NSString isNullOrEmpty:fileId]){
            [self afterUploadFail:imChatLogModel];
        } else {
            /* 小视频类型的需要特殊处理 */
            BOOL isUploadCoverFileID = NO; //是否为上传的视频封面
            if ([imChatLogModel.imClmBodyModel.handlertype isEqualToString:Handler_Message_LZChat_Micro_Video]) {
                ImChatLogBodyModel *bodyModel = imChatLogModel.imClmBodyModel;
                
                ImChatLogModel *newImChatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:imChatLogModel.msgid orClienttempid:imChatLogModel.clienttempid];
                NSString *videoFileID = [newImChatLogModel.imClmBodyModel.body lzNSStringForKey:@"videofileid"];
                NSString *coverFileID = [newImChatLogModel.imClmBodyModel.body lzNSStringForKey:@"imagefileid"];
                if([NSString isNullOrEmpty:videoFileID] && [NSString isNullOrEmpty:coverFileID]){
                    NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] initWithDictionary:bodyModel.body];
                    [sendInfoBody setValue:[result objectForKey:@"fileid"] forKey:@"imagefileid"];
                    bodyModel.body = sendInfoBody;
                    [[ImChatLogDAL shareInstance] updateBody:[[bodyModel convertModelToDictionary] dicSerial]
                                                   withMsgId:imChatLogModel.msgid];
                    isUploadCoverFileID = YES;
                }
            }
            
            /* 根据扩展名请求对应的icon */
            WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
                NSString *code = [[dataDic lzNSDictonaryForKey:WebApi_ErrorCode] objectForKey:@"Code"];
                if([code isEqualToString:@"0"]){
                    if(!isUploadCoverFileID){
                        NSString *rid = @"";
                        NSArray *dataDicArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
                        if(dataDicArr.count>0){
                            NSDictionary *dataDicForTemp = [dataDicArr objectAtIndex:0];
                            rid = [dataDicForTemp lzNSStringForKey:@"rid"];
                        }
                        [self afterAddResource:imChatLogModel rid:rid WithResult:result];
                    }
                }
                /* 上传失败 */
                else {
                    [self afterUploadFail:imChatLogModel];
                }
            };
            NSDictionary *otherData = @{WebApi_DataSend_Other_BackBlock:backBlock,
                                        WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll};
            NSDictionary *postData = @{@"rpid":Res_Rpid_IM,
                                       @"rtype":@"1",
                                       @"partitiontype":@"0",
                                       @"fileids":fileId};
            
            DDLogVerbose(@"调用生成资源的WebApi");
            [self.appDelegate.lzservice sendToServerForPost:@"IM_AddResourceList" routePath:WebApi_FileCommon_AddResourceList moduleServer:Modules_Default getData:nil postData:postData otherData:otherData];
        }
    }
    
    if([fileSendArray count] >0)
    {
        [fileSendArray removeObjectAtIndex:0]; //先移除，再进行下一次的上传
    }
    
    //继续下一个文件的上传
    [self uploadBegin];
}

//文件上传或添加资源失败
-(void)afterUploadFail:(ImChatLogModel *)imChatLogModel{
    NSString *mqid = imChatLogModel.clienttempid;
    //删除队列中的数据
    [[ImMsgQueueDAL shareInstance] deleteImMsgQueueWithMqid:mqid];
    
    //数据库中更改为失败状态
    [[ImChatLogDAL shareInstance] updateSendStatusWithClientTempId:mqid withSendstatus:Chat_Msg_SendFail];
    
    //更新一级消息
    if(_parsetype!=0){        
        [[ImChatLogDAL shareInstance] updateSendStatusWithClientTempId:[mqid stringByAppendingString:@"_First"] withSendstatus:Chat_Msg_SendFail];
    }
    
    //通知界面
    EVENT_PUBLISH_WITHDATA(self, EventBus_Chat_UpdateSendStatus, imChatLogModel);
    [self refreshMessageRootVC:imChatLogModel.dialogid];
}

//添加资源，发送message
-(void)afterAddResource:(ImChatLogModel *)imChatLogModel rid:(NSString *)rid WithResult:(NSDictionary *)result{
    ImChatLogBodyModel *bodyModel = nil;
    /* 上传视频、文件、图片 */
    if([imChatLogModel.imClmBodyModel.handlertype isEqualToString:Handler_Message_LZChat_Image_Download]
       || [imChatLogModel.imClmBodyModel.handlertype isEqualToString:Handler_Message_LZChat_File_Download]){
        bodyModel = imChatLogModel.imClmBodyModel;
        NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] initWithDictionary:bodyModel.body];
        [sendInfoBody setValue:[result objectForKey:@"fileid"] forKey:@"fileid"];
        //            [sendInfoBody setValue:imChatLogModel.imClmBodyModel.fileModel.smalliconclientname forKey:@"name"];
        [sendInfoBody setValue:[result objectForKey:@"filesize"] forKey:@"size"];
        //            [sendInfoBody setValue:[result objectForKey:@"icon"] forKey:@"icon"];
        [sendInfoBody setValue:rid forKey:@"rmid"];
        
        /* 根据扩展名请求对应的icon */
        WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
            NSString *code = [[dataDic lzNSDictonaryForKey:WebApi_ErrorCode] objectForKey:@"Code"];
            if([code isEqualToString:@"0"]){
                /* 插入数据库 */
                NSString *fileext = [[dataDic lzNSDictonaryForKey:WebApi_DataSend_Get] objectForKey:@"format"];
                NSString *iconID = [dataDic lzNSStringForKey:WebApi_DataContext];
                
                ResFileiconModel *resFileIconModel = [[ResFileiconModel alloc] init];
                resFileIconModel.iconext = [fileext lowercaseString];
                resFileIconModel.iconid = iconID;
                resFileIconModel.addtime = [AppDateUtil GetCurrentDate];
                /* 库中有这个扩展名的数据，更新 */
                ResFileiconModel *iconModel = [[ResFileiconDAL shareInstance] getFileiconIDByFileEXT:[fileext lowercaseString]];
                if (iconModel != nil) {
                    [[ResFileiconDAL shareInstance] updateDataWithResFileIconModel:resFileIconModel];
                } else {
                    [[ResFileiconDAL shareInstance] addDataWithResFileIconModel:resFileIconModel];
                }
                
                /* 组织到body中 */
                [sendInfoBody setValue:iconID forKey:@"icon"];
                bodyModel.body = sendInfoBody;
                [[ImChatLogDAL shareInstance] updateBody:[[bodyModel convertModelToDictionary] dicSerial]
                                               withMsgId:imChatLogModel.msgid];
            }
           
            /* 添加到消息队列 */
            [self addToMsgQueue:[bodyModel convertModelToDictionary]];
           
            //发送IQ通知上传成功
            [self.appDelegate.lzservice send:[bodyModel convertModelToDictionary]];
        };
        NSDictionary *otherData = @{WebApi_DataSend_Other_BackBlock:backBlock};
        NSString *fileext = [result lzNSStringForKey:@"fileext"];
        if([NSString isNullOrEmpty:fileext]){
            fileext = [imChatLogModel.imClmBodyModel.bodyModel.name substringFromIndex:[imChatLogModel.imClmBodyModel.bodyModel.name rangeOfString:@"." options:NSBackwardsSearch].location+1];
        }
        
        /* 从数据库查询 */
        ResFileiconModel *resFileIconModel = [[ResFileiconDAL shareInstance] getFileiconIDByFileEXT:[fileext lowercaseString]];
        /* 获取上次添加数据到当前时间间隔天数 */
        NSInteger intervalDays = [AppDateUtil IntervalDays:resFileIconModel.addtime endDate:[AppDateUtil GetCurrentDate]];
        
        if([NSString isNullOrEmpty:resFileIconModel.iconid] || intervalDays >= 7){
            [self.appDelegate.lzservice sendToServerForGet:@"forgeticon" routePath:WebApi_Format_GetFormatIcon moduleServer:Modules_Default getData:@{@"format":fileext,@"ishandlerjpg":@"true"} otherData:otherData];
        }
        else {
            [sendInfoBody setValue:resFileIconModel.iconid forKey:@"icon"];
            bodyModel.body = sendInfoBody;
            [[ImChatLogDAL shareInstance] updateBody:[[bodyModel convertModelToDictionary] dicSerial]
                                           withMsgId:imChatLogModel.msgid];
           
            /* 添加到消息队列 */
            [self addToMsgQueue:[bodyModel convertModelToDictionary]];
           
            //发送IQ通知上传成功
            [self.appDelegate.lzservice send:[bodyModel convertModelToDictionary]];
        }
        //            bodyModel.body = sendInfoBody;
        //            [[ImChatLogDAL shareInstance] updateBody:[[bodyModel convertModelToDictionary] dicSerial]
        //                                           withMsgId:imChatLogModel.msgid];
    }
    /* 上传小视频 */
    else if ([imChatLogModel.imClmBodyModel.handlertype isEqualToString:Handler_Message_LZChat_Micro_Video]) {
        
        bodyModel = imChatLogModel.imClmBodyModel;
        
        ImChatLogModel *newImChatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:imChatLogModel.msgid orClienttempid:imChatLogModel.clienttempid];
        NSString *videoFileID = [newImChatLogModel.imClmBodyModel.body lzNSStringForKey:@"videofileid"];
        NSString *coverFileID = [newImChatLogModel.imClmBodyModel.body lzNSStringForKey:@"imagefileid"];
        if([NSString isNullOrEmpty:videoFileID] && [NSString isNullOrEmpty:coverFileID]){
            NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] initWithDictionary:bodyModel.body];
            [sendInfoBody setValue:[result objectForKey:@"fileid"] forKey:@"imagefileid"];
            bodyModel.body = sendInfoBody;
            [[ImChatLogDAL shareInstance] updateBody:[[bodyModel convertModelToDictionary] dicSerial]
                                           withMsgId:imChatLogModel.msgid];
        } else {
            NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] initWithDictionary:newImChatLogModel.imClmBodyModel.body];
            [sendInfoBody setValue:[result objectForKey:@"fileid"] forKey:@"videofileid"];
            [sendInfoBody setValue:[result objectForKey:@"filesize"] forKey:@"size"];
            [sendInfoBody setValue:rid forKey:@"rmid"];
            bodyModel.body = sendInfoBody;
            [[ImChatLogDAL shareInstance] updateBody:[[bodyModel convertModelToDictionary] dicSerial]
                                           withMsgId:imChatLogModel.msgid];
           
            /* 添加到消息队列 */
            [self addToMsgQueue:[bodyModel convertModelToDictionary]];
           
            //发送IQ通知上传成功
            [self.appDelegate.lzservice send:[bodyModel convertModelToDictionary]];
        }
    }
    /* 上传语音文件 */
    else if( [imChatLogModel.imClmBodyModel.handlertype isEqualToString:Handler_Message_LZChat_Voice] ){
        bodyModel = imChatLogModel.imClmBodyModel;
        NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
        [sendInfoBody setValue:[result objectForKey:@"fileid"] forKey:@"fileid"];
        [sendInfoBody setValue:rid forKey:@"rmid"];
        //            [sendInfoBody setValue:[result objectForKey:@"filesize"] forKey:@"size"];
        [sendInfoBody setValue:imChatLogModel.imClmBodyModel.bodyModel.duration forKey:@"duration"];
        bodyModel.body = sendInfoBody;
        [[ImChatLogDAL shareInstance] updateBody:[[bodyModel convertModelToDictionary] dicSerial]
                                       withMsgId:imChatLogModel.msgid];
       
        /* 添加到消息队列 */
        [self addToMsgQueue:[bodyModel convertModelToDictionary]];
       
        //发送IQ通知上传成功
        [self.appDelegate.lzservice send:[bodyModel convertModelToDictionary]];
    }
    /* 上传位置 */
    else if( [imChatLogModel.imClmBodyModel.handlertype isEqualToString:Handler_Message_LZChat_Geolocation] ){
        bodyModel = imChatLogModel.imClmBodyModel;
        //            ImChatLogBodyModel *bodyModel = [[ImChatLogBodyModel alloc] init];
        //            [bodyModel serialization:imChatLogModel.body];
        NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
        [sendInfoBody setValue:[result objectForKey:@"fileid"] forKey:@"fileid"];
        [sendInfoBody setValue:rid forKey:@"rmid"];
        [sendInfoBody setValue:[NSNumber numberWithFloat:imChatLogModel.imClmBodyModel.bodyModel.geozoom] forKey:@"geozoom"];
        [sendInfoBody setValue:[NSNumber numberWithFloat:imChatLogModel.imClmBodyModel.bodyModel.geolongitude] forKey:@"geolongitude"];
        [sendInfoBody setValue:[NSNumber numberWithFloat:imChatLogModel.imClmBodyModel.bodyModel.geolatitude] forKey:@"geolatitude"];
        [sendInfoBody setValue:imChatLogModel.imClmBodyModel.bodyModel.geoaddress forKey:@"geoaddress"];
        [sendInfoBody setValue:imChatLogModel.imClmBodyModel.bodyModel.geodetailposition forKey:@"geodetailposition"];
        if([[imChatLogModel.imClmBodyModel.body allKeys] containsObject:@"width"]){
            [sendInfoBody setValue:[NSNumber numberWithFloat:imChatLogModel.imClmBodyModel.bodyModel.width] forKey:@"width"];
        }
        if([[imChatLogModel.imClmBodyModel.body allKeys] containsObject:@"height"]){
            [sendInfoBody setValue:[NSNumber numberWithFloat:imChatLogModel.imClmBodyModel.bodyModel.height] forKey:@"height"];
        }
        bodyModel.body = sendInfoBody;
        [[ImChatLogDAL shareInstance] updateBody:[[bodyModel convertModelToDictionary] dicSerial]
                                       withMsgId:imChatLogModel.msgid];
       
        /* 添加到消息队列 */
        [self addToMsgQueue:[bodyModel convertModelToDictionary]];
       
        //发送IQ通知上传成功
        [self.appDelegate.lzservice send:[bodyModel convertModelToDictionary]];
    }
}

//生成资源
-(void)createFileToRes:(NSString *)fileid reult:(CreateFileToRes)result{
    /* 根据扩展名请求对应的icon */
    WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
        NSString *code = [[dataDic lzNSDictonaryForKey:WebApi_ErrorCode] objectForKey:@"Code"];
        if([code isEqualToString:@"0"]){
            NSString *rid = @"";
            NSArray *dataDicArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
            if(dataDicArr.count>0){
                NSDictionary *dataDicForTemp = [dataDicArr objectAtIndex:0];
                rid = [dataDicForTemp lzNSStringForKey:@"rid"];
            }
            if([NSString isNullOrEmpty:rid]){
                result(NO,@"");
            } else {
                result(YES,rid);
            }
        }
        /* 上传失败 */
        else {
            result(NO,@"");
        }
    };
    NSDictionary *otherData = @{WebApi_DataSend_Other_BackBlock:backBlock,
                                WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll};
    NSDictionary *postData = @{@"rpid":Res_Rpid_IM,
                               @"rtype":@"1",
                               @"partitiontype":@"0",
                               @"fileids":fileid};
    
    DDLogVerbose(@"调用生成资源的WebApi");
    [self.appDelegate.lzservice sendToServerForPost:@"IM_AddResourceList" routePath:WebApi_FileCommon_AddResourceList moduleServer:Modules_Default getData:nil postData:postData otherData:otherData];
}

#pragma mark - 语音下载或转换

-(void)operateVoice:(ImChatLogModel *)imChatLogModel xhMessage:(XHMessage *)message{
    NSString *absoultePath = [FilePathUtil getChatRecvImageDicAbsolutePath];
    NSString *amrName = [NSString stringWithFormat:@"voice_amr_%@.amr",imChatLogModel.imClmBodyModel.bodyModel.fileid];
    NSString *wavName = [NSString stringWithFormat:@"voice_wav_%@.wav",imChatLogModel.imClmBodyModel.bodyModel.fileid];
    
    LZFileProgressDownload lzFileProgressDownload = ^(float percent, NSString *tag, id otherInfo){
        NSLog(@"下载进度Voice=======%@",[NSString stringWithFormat:@"%0.f%%",percent*100]);
    };
    LZFileDidSuccessDownload lzFileDidSuccessDownload = ^(NSDictionary *result, NSString *tag, id otherInfo){
        DDLogVerbose(@"语音下载完成--开始转换");
        
        ImChatLogBodyModel *bodyModel = imChatLogModel.imClmBodyModel;
        ImChatLogBodyVoiceModel *voiceModel = imChatLogModel.imClmBodyModel.voiceModel;
        voiceModel.voiceIsDown = YES;
        bodyModel.voiceinfo = [[voiceModel convertModelToDictionary] dicSerial];
        imChatLogModel.body = [[bodyModel convertModelToDictionary] dicSerial];
        message.imChatLogModel = imChatLogModel;
        [[ImChatLogDAL shareInstance] updateBody:[[bodyModel convertModelToDictionary] dicSerial]
                                       withMsgId:message.imChatLogModel.msgid];
        
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
            message.imChatLogModel = imChatLogModel;
            message.voicePath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatRecvImageDicAbsolutePath],wavName];
            [[ImChatLogDAL shareInstance] updateBody:[[message.imChatLogModel.imClmBodyModel convertModelToDictionary] dicSerial]
                                           withMsgId:message.imChatLogModel.msgid];
        }
        
        //通知界面
        EVENT_PUBLISH_WITHDATA(self, EventBus_Chat_UpdateVoiceDownloadStatus, imChatLogModel);
        DDLogVerbose(@"语音下载完成--转换完成");
    };
    LZFileDidErrorDownload lzFileDidErrorDownload = ^(NSString *title, NSString *messagefordown, NSString *tag, id otherInfo){
        DDLogVerbose(@"语音下载失败");
//        [self showErrorWithText:@"语音下载失败！"];
        
        ImChatLogBodyModel *bodyModel = imChatLogModel.imClmBodyModel;
        ImChatLogBodyVoiceModel *voiceModel = imChatLogModel.imClmBodyModel.voiceModel;
        voiceModel.voiceIsDownFail = YES;
        bodyModel.voiceinfo = [[voiceModel convertModelToDictionary] dicSerial];
        imChatLogModel.body = [[bodyModel convertModelToDictionary] dicSerial];
        message.imChatLogModel = imChatLogModel;
        
        //通知界面
        EVENT_PUBLISH_WITHDATA(self, EventBus_Chat_UpdateVoiceDownloadStatus, imChatLogModel);
        
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *server = [ModuleServerUtil GetServerWithModule:Modules_File];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *downloadUrl = [NSString stringWithFormat:@"%@/api/fileserver/download/%@/%@",server,imChatLogModel.imClmBodyModel.bodyModel.fileid,appDelegate.lzservice.tokenId];
        
        DDLogVerbose(@"-----开始下载---%@",downloadUrl);
        dispatch_async(dispatch_get_main_queue(), ^{
            LZFileTransfer *lzFileTransfer = [LZCloudFileTransferMain getLZFileTransferForDownloadWithUrl:downloadUrl Progress:lzFileProgressDownload success:lzFileDidSuccessDownload error:lzFileDidErrorDownload];
            
            lzFileTransfer.localFileName = amrName;
            lzFileTransfer.localPath = [FilePathUtil getChatRecvImageDicRelatePath];
            lzFileTransfer.downloadFileSize = imChatLogModel.imClmBodyModel.bodyModel.size;
            lzFileTransfer.maxErrorTimes = 1;
            lzFileTransfer.fileDownId = imChatLogModel.imClmBodyModel.bodyModel.fileid;
            [lzFileTransfer downloadFile];
        });
    });
}

#pragma mark - 图片浏览

/**
 *  获取图片类型的聊天记录
 *
 *  @param dialogid 对话框ID
 *
 *  @return 图片类型的消息数组
 */
-(NSMutableArray *)getImageViewDataSource:(NSString *)dialogid
{
    NSString *handlerType = [NSString stringWithFormat:@"'%@'",Handler_Message_LZChat_Image_Download];
    /* 从数据库中获取图片类型的聊天记录 */
    NSMutableArray *resultArray = [[[ImChatLogDAL alloc] init] getChatLogWithDialogid:dialogid handlerType:handlerType];
    return resultArray;
}

/**
 发送通知API

 @param chatLogModel
 */
- (void)sendNotificationWithChatLogModel:(ImChatLogModel *)imChatLogModel isDelay:(BOOL)isDelay {
    NSString *handlertype = isDelay ? Handler_Message_LZChat_Call_Notice : imChatLogModel.handlertype;
    NSString *status = [imChatLogModel.imClmBodyModel.body lzNSStringForKey:@"callstatus"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:@"" forKey:@"bkid"];
    /* 仅给自己发送，不给接受者发送 */
    if (isDelay && [status isEqualToString:Chat_Group_Call_State_Receive]) {
        handlertype = Handler_Message_LZChat_Call_Receive;
        [postDict setObject:@3 forKey:@"self"];
    } else {
        // 如果是禁言的通知
        if (isDelay && [status isEqualToString:Chat_Group_Call_State_Speech]) {
            handlertype = Handler_Message_LZChat_Call_Speech;
        }
        [postDict setObject:@0 forKey:@"self"];
    }
    [postDict setObject:handlertype forKey:@"handlertype"];
    [postDict setObject:[NSNumber numberWithInteger:imChatLogModel.fromtype] forKey:@"fromtype"];
    [postDict setObject:imChatLogModel.from forKey:@"from"];
    [postDict setObject:[NSNumber numberWithInteger:imChatLogModel.totype] forKey:@"totype"];
    [postDict setObject:@[imChatLogModel.to] forKey:@"to"];
    [postDict setObject:imChatLogModel.imClmBodyModel.body forKey:@"body"];
    
    [postDict setObject:[NSNumber numberWithBool:isDelay] forKey:@"isdeley"];
    [postDict setObject:@"" forKey:@"app"];    
    
    [self.appDelegate.lzservice sendToServerForPost:WebApi_Notification routePath:WebApi_Notification_Send moduleServer:Modules_Message getData:nil postData:postDict otherData:nil];
    if (isDelay) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        if ([status isEqualToString:Chat_Group_Call_State_End]) {
            /* 通话结束之后，清除该条记录 */
            [[ImGroupCallDAL shareInstance] deleteImGroupCallModelWithGroupId:imChatLogModel.dialogid];
            [userInfo setObject:@0 forKey:@"userscount"];
        } else if ([status isEqualToString:Chat_Group_Call_State_Request]) {
            ImGroupCallModel *groupCallModel = [[ImGroupCallModel alloc] init];
            groupCallModel.groupid = imChatLogModel.dialogid;
            groupCallModel.status = status;
            groupCallModel.chatusers = [imChatLogModel.imClmBodyModel.body lzNSStringForKey:@"chatusers"];
            groupCallModel.usercout = [[imChatLogModel.imClmBodyModel.body lzNSStringForKey:@"chatusers"] serialToArr].count;
            groupCallModel.starttime = imChatLogModel.showindexdate;
            groupCallModel.roomname = [imChatLogModel.imClmBodyModel.body lzNSStringForKey:@"channelid"];
            groupCallModel.iscallother = [imChatLogModel.imClmBodyModel.body lzNSStringForKey:@"iscallother"];
            groupCallModel.initiateuid = imChatLogModel.from;
            [[ImGroupCallDAL shareInstance] addImGroupCallModel:groupCallModel];
            [userInfo setObject:[NSNumber numberWithInteger:groupCallModel.usercout] forKey:@"userscount"];
        } else if ([status isEqualToString:Chat_Group_Call_State_Update]) {
            ImGroupCallModel *groupCallModel = [[ImGroupCallModel alloc] init];
            groupCallModel.groupid = imChatLogModel.dialogid;
            groupCallModel.realchatusers = [imChatLogModel.imClmBodyModel.body lzNSStringForKey:@"realchatusers"];
            groupCallModel.realusercount = [[imChatLogModel.imClmBodyModel.body lzNSStringForKey:@"realchatusers"] serialToArr].count;
            [[ImGroupCallDAL shareInstance] updateImGroupCallRealChatWithGroupId:groupCallModel];
        } else {
            if(![status isEqualToString:Chat_Group_Call_State_Receive]&& ![status isEqualToString:Chat_Group_Call_State_Speech]&& ![status isEqualToString:@""]) {
                ImGroupCallModel *groupCallModel = [[ImGroupCallModel alloc] init];
                groupCallModel.groupid = imChatLogModel.dialogid;
                groupCallModel.status = status;
                groupCallModel.chatusers = [imChatLogModel.imClmBodyModel.body lzNSStringForKey:@"chatusers"];
                groupCallModel.usercout = [[imChatLogModel.imClmBodyModel.body lzNSStringForKey:@"chatusers"] serialToArr].count;
                groupCallModel.updatetime = imChatLogModel.showindexdate;
                [[ImGroupCallDAL shareInstance] updateImGroupCallModelWithGroupId:groupCallModel];
                [userInfo setObject:[NSNumber numberWithInteger:groupCallModel.usercout] forKey:@"userscount"];
            }
        }
        [self refreshMessageRootVC:imChatLogModel.dialogid];
        
        if (userInfo.count != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeCallUserMember" object:nil userInfo:userInfo];
        }
    }
}

#pragma mark - 刷新消息列表
//刷新消息列表
-(void)refreshMessageRootVC:(NSString *)dialogid{
    self.appDelegate.lzGlobalVariable.chatDialogID = dialogid;
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForChatVC = YES;
    
    //为二级消息聊天框时，需要对二级消息列表刷新
    if(_parsetype!=0){
        NSString *firstDialogID = [[dialogid componentsSeparatedByString:@"."] objectAtIndex:0];
        EVENT_PUBLISH_WITHDATA(self, EventBus_Chat_RefreshSecondMsgVC, firstDialogID);
    }
}

@end
