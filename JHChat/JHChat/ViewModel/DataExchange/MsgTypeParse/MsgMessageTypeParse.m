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
#import "ChatMessageParse.h"
#import "GroupMessageParse.h"
#import "MessageMsgParse.h"
#import "MsgTemplateViewModel.h"
#import "ImRecentModel.h"
#import "OrgEnterPriseDAL.h"
#import "ImRecentDAL.h"
#import "UIAlertView+AlertWithMessage.h"
#import "ErrorDAL.h"
#import "NSDictionary+DicSerial.h"

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
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    BOOL parseResult = YES;
    
    @try {
        NSString *from = [dataDic lzNSStringForKey:@"from"];
        NSString *fromtype = [dataDic objectForKey:@"fromtype"];
//        NSInteger totype = [dataDic lzNSNumberForKey:@"totype"].integerValue;
        NSString *handlertype = [dataDic objectForKey:@"handlertype"];
        NSString *mainModel = [[HandlerTypeUtil shareInstance] getMainModel:[dataDic objectForKey:@"handlertype"]];

        BOOL isSendReport = NO;
        BOOL isChatLog = NO;
        BOOL isShowTvid = YES;
        /* 过滤掉不需要显示的个人提醒 */
        NSString *tvidStr = [LZUserDataManager getTvidStr];
        NSString *tvid = [[dataDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"templateid"];
        if (![NSString isNullOrEmpty:tvidStr]) {
            isShowTvid = [tvidStr rangeOfString:[NSString stringWithFormat:@",%@,",tvid]].location == NSNotFound;
        }
        
    //    /* 处理业务会话（特殊处理） */
    //    if(totype == Chat_ToType_Five){
    //        fromtype = [NSString stringWithFormat:@"%ld",Chat_FromType_Three];
    //        from = Chat_ContactType_Second_OutWardlBusiness;
    //    }
    //    if(totype == Chat_ToType_Six){
    //        fromtype = [NSString stringWithFormat:@"%ld",Chat_FromType_Three];
    //        from = Chat_ContactType_Second_InternalBusiness;
    //    }

        /* 应用 */
        if(fromtype.integerValue == Chat_FromType_Three ){

            /* 记录日志，跟踪20161213，收到已读，数量减一 */
            NSString *errorTitle = [NSString stringWithFormat:@"7-p-t：dialogId=%@",[dataDic lzNSStringForKey:@"container"]];
            [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[dataDic dicSerial] errortype:Error_Type_Four];
            
            ImMsgTemplateModel *imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:from];
            
            ImRecentModel *recentModel = [[ImRecentModel alloc] init];
            recentModel.contactname = @"应用";
            
            NSString *contactid = [dataDic objectForKey:@"container"];
            ImRecentModel *oldImRecentModel=[[ImRecentDAL shareInstance] getRecentModelWithContactid:contactid];
            /* 使用模板中的名称 */
            if( ![NSString isNullOrEmpty:imMsgTemplateModel.name] ){
                recentModel.contactname = imMsgTemplateModel.name;
            }
            /* ImRecent中有值时，使用那里面的 */
            else {
                
                if(![NSString isNullOrEmpty:oldImRecentModel.contactname]){
                    recentModel.contactname = oldImRecentModel.contactname;
                }
            }
            recentModel.stick = oldImRecentModel.stick;
            recentModel.isonedisturb = oldImRecentModel.isonedisturb;
            parseResult = [self commonSaveNewsInfo:dataDic recentModel:recentModel];
            if(LeadingCloud_MsgParseSerial && !parseResult){
                DDLogVerbose(@"MsgMessageTypeParse--parse:保存应用消息数据失败。[消息解析失败]");
                return NO;
            }
            
            isSendReport = NO;
            isChatLog = YES;
        }
        /* 组织发出的消息 */
        else if(fromtype.integerValue == Chat_FromType_Four){
            /* 记录日志，跟踪20161213，收到已读，数量减一 */
            NSString *errorTitle = [NSString stringWithFormat:@"7-p-f：dialogId=%@",[dataDic lzNSStringForKey:@"container"]];
            [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[dataDic dicSerial] errortype:Error_Type_Four];
            
            OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseDAL shareInstance] getEnterpriseByEId:from];
            
            ImRecentModel *oldImRecentModel=[[ImRecentDAL shareInstance] getRecentModelWithContactid:[dataDic lzNSStringForKey:@"container"]];
            ImRecentModel *recentModel = [[ImRecentModel alloc] init];
            recentModel.contactname = LZGDCommonLocailzableString(@"cooperation_enterprise");
            if( ![NSString isNullOrEmpty:orgEnterPriseModel.shortname] ){
                recentModel.contactname = orgEnterPriseModel.shortname;
            }
            recentModel.stick = oldImRecentModel.stick;
            recentModel.isonedisturb = oldImRecentModel.isonedisturb;
            parseResult = [self commonSaveNewsInfo:dataDic recentModel:recentModel];
            if(LeadingCloud_MsgParseSerial && !parseResult){
                DDLogVerbose(@"MsgMessageTypeParse--parse:保存应用消息数据失败。[消息解析失败]");
                return NO;
            }
            
            isSendReport = NO;
            isChatLog = YES;
        }
        /* 个人提醒 */
        else if(fromtype.integerValue == Chat_FromType_Five && isShowTvid) {
            /* 记录日志，跟踪20161213，收到已读，数量减一 */
            NSString *errorTitle = [NSString stringWithFormat:@"7-p-fi：dialogId=%@",[dataDic lzNSStringForKey:@"container"]];
            [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[dataDic dicSerial] errortype:Error_Type_Four];
            
            ImMsgTemplateModel *imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:from];
            ImRecentModel *recentModel = [[ImRecentModel alloc] init];
            recentModel.contactname = @"个人提醒";
            
            NSString *contactid = [dataDic objectForKey:@"container"];
            ImRecentModel *oldImRecentModel=[[ImRecentDAL shareInstance] getRecentModelWithContactid:contactid];
            /* 使用模板中的名称 */
            if(![NSString isNullOrEmpty:imMsgTemplateModel.name] ){
                recentModel.contactname = imMsgTemplateModel.name;
            }
            /* ImRecent中有值时，使用那里面的 */
            else {
                if(![NSString isNullOrEmpty:oldImRecentModel.contactname]){
                    recentModel.contactname = oldImRecentModel.contactname;
                }
            }
            recentModel.stick = oldImRecentModel.stick;
            recentModel.isonedisturb = oldImRecentModel.isonedisturb;
            parseResult = [self commonSaveNewsInfo:dataDic recentModel:recentModel];
            if(LeadingCloud_MsgParseSerial && !parseResult){
                DDLogVerbose(@"MsgMessageTypeParse--parse:保存应用消息数据失败。[消息解析失败]");
                return NO;
            }
            
            isSendReport = NO;
            isChatLog = YES;
        }
        else {
            if( [mainModel isEqualToString:Handler_Message] ){
                
                /* 记录日志，跟踪20161213，收到已读，数量减一 */
                NSString *errorTitle = [NSString stringWithFormat:@"5：dialogId=%@",[dataDic lzNSStringForKey:@"container"]];
                [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[dataDic dicSerial] errortype:Error_Type_Four];
                
                NSDictionary *resultDic = [[MessageMsgParse shareInstance] parse:dataDic];
                isSendReport = ![[resultDic lzNSStringForKey:@"issendreport"] isEqualToString:@"0"];
                parseResult = ![[resultDic lzNSStringForKey:@"issavesuccess"] isEqualToString:@"0"];
                if(LeadingCloud_MsgParseSerial && !parseResult){
                    isSendReport = NO;
                }
                
                /* 消息，不需要发回执 */
                if([handlertype isEqualToString:Handler_Message_LZChat_LZMsgNormal_Text]
                   || [handlertype isEqualToString:Handler_Message_LZChat_Image_Download]
                   || [handlertype isEqualToString:Handler_Message_LZChat_File_Download]
                   || [handlertype isEqualToString:Handler_Message_LZChat_Card]
                   || [handlertype isEqualToString:Handler_Message_LZChat_UrlLink]
                   || [handlertype isEqualToString:Handler_Message_LZChat_ChatLog]
                   || [handlertype isEqualToString:Handler_Message_LZChat_Voice]
                   || [handlertype isEqualToString:Handler_Message_LZChat_VoiceCall]
                   || [handlertype isEqualToString:Handler_Message_LZChat_VideoCall]
                   || [handlertype isEqualToString:Handler_Message_LZChat_Call_Finish]
                   || [handlertype isEqualToString:Handler_Message_LZChat_Call_Unanswer]
                   || [handlertype isEqualToString:Handler_Message_LZChat_Call_Main]
                   || [handlertype isEqualToString:Handler_Message_LZChat_Micro_Video]
                   || [handlertype isEqualToString:Handler_Message_LZChat_Geolocation]
                   || [handlertype hasPrefix:Handler_Message_LZChat_SR_FilePost]){
                    isChatLog = YES;
                }
                
               
            }
            else {
                DDLogError(@"----------------收到未处理---消息:%@",dataDic);
            }
        }
        
        /* 消息回执处理 */
        NSString *msgid = [dataDic objectForKey:@"msgid"];
        if(isSendReport){
            [self sendReportToServerMsgType:@"2" msgID:msgid];
        }
        else {
            if(!isChatLog){
                DDLogError(@"---------MsgMessageTypeParse未发送，消息回执-------------%@",msgid);
            }
        }
    }
    @catch (NSException *exception) {
        DDLogVerbose(@"MsgMessageTypeParse--parse解析消息出现异常。详细信息：%@。[消息解析失败]",exception.reason);
        parseResult = NO;
    }
    
    return parseResult;
}

@end
