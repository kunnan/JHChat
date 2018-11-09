//
//  ImChatLogBodyModel.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/31.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-31
 Version: 1.0
 Description: 聊天日志表Body字段模型
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ImChatLogBodyModel.h"
#import "NSDictionary+DicSerial.h"

@implementation ImChatLogBodyModel

/* 文件信息Model */
- (ImChatLogBodyFileModel *)fileModel
{
    ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
    [fileModel serialization:self.fileinfo];
    return fileModel;
}


/* 语音信息Model */
- (ImChatLogBodyVoiceModel *)voiceModel{
    ImChatLogBodyVoiceModel *voiceModel = [[ImChatLogBodyVoiceModel alloc] init];
    [voiceModel serialization:self.voiceinfo];
    return voiceModel;
}

/* 位置信息Model */
- (ImChatLogBodyGeolocationModel *)geolocationModel{
    ImChatLogBodyGeolocationModel *geolocationModel = [[ImChatLogBodyGeolocationModel alloc] init];
    [geolocationModel serialization:self.geolocationinfo];
    return geolocationModel;
}

/* 已读信息Model */
- (ImChatLogBodyReadStatusModel *)readstatusModel{
    ImChatLogBodyReadStatusModel *readstatusModel = [[ImChatLogBodyReadStatusModel alloc] init];
    [readstatusModel serialization:self.readstatus];
    return readstatusModel;
}




- (ImChatLogBodyInnerModel *)bodyModel
{
    ImChatLogBodyInnerModel *bodyModel = [[ImChatLogBodyInnerModel alloc] init];
    [bodyModel serializationWithDictionary:self.body];
    return bodyModel;
}

@end
