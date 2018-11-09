//
//  LZChatMsgParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/4/26.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-04-26
 Version: 1.0
 Description: 消息--即时消息--对话
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZChatMsgParse.h"
#import "ChatMessageParse.h"
#import "GroupMessageParse.h"
#import "NSDictionary+DicSerial.h"
#import "ErrorDAL.h"
#import "NSDictionary+DicSerial.h"

@implementation LZChatMsgParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(LZChatMsgParse *)shareInstance{
    static LZChatMsgParse *instance = nil;
    if (instance == nil) {
        instance = [[LZChatMsgParse alloc] init];
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
    NSString *errorTitle = [NSString stringWithFormat:@"6：dialogId=%@",[dataDic lzNSStringForKey:@"container"]];
    [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[dataDic dicSerial] errortype:Error_Type_Four];
    
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    NSDictionary *result = [[NSDictionary alloc] init];
    
    /* 容错处理 */
    if([[dataDic allKeys] containsObject:@"readstatus"] ){
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

    /* 需要处理的消息 */
    if([handlertype isEqualToString:Handler_Message_LZChat_LZMsgNormal_Text]
       || [handlertype isEqualToString:Handler_Message_LZChat_Image_Download]
       || [handlertype isEqualToString:Handler_Message_LZChat_File_Download]
       || [handlertype isEqualToString:Handler_Message_LZChat_Micro_Video]
       || [handlertype isEqualToString:Handler_Message_LZChat_Card]
       || [handlertype isEqualToString:Handler_Message_LZChat_UrlLink]
       || [handlertype isEqualToString:Handler_Message_LZChat_LZTemplateMsg_CooperationShareFile]
       || [handlertype isEqualToString:Handler_Message_LZChat_Voice]
       || [handlertype isEqualToString:Handler_Message_LZChat_VoiceCall]
       || [handlertype isEqualToString:Handler_Message_LZChat_VideoCall]
       || [handlertype isEqualToString:Handler_Message_LZChat_Call_Finish]
       || [handlertype isEqualToString:Handler_Message_LZChat_Call_Unanswer]
       || [handlertype isEqualToString:Handler_Message_LZChat_Call_Main]
       || [handlertype isEqualToString:Handler_Message_LZChat_Geolocation]
       || [handlertype isEqualToString:Handler_Message_LZChat_ChatLog]
       || [handlertype hasPrefix:Handler_Message_LZChat_LZTemplateMsg_BSform]){
        result = [[ChatMessageParse shareInstance] parse:dataDic];
    }
    /* 群系统消息 */
    else if([handlertype hasPrefix:Handler_Message_LZChat_SR]){
        result = [[GroupMessageParse shareInstance] parse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---消息类型:%@",dataDic);
    }
    
    return result;
}

@end
