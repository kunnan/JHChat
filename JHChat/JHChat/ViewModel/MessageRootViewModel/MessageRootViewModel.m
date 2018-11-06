//
//  MessageRootViewModel.m
//  LeadingCloud
//
//  Created by wchMac on 15/11/17.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-11-17
 Version: 1.0
 Description: 消息页签数据ViewModel
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MessageRootViewModel.h"
#import "MessageRootTableViewCellViewModel.h"
#import "ImRecentDAL.h"
#import "ImRecentModel.h"
#import "AppDateUtil.h"
#import "ImChatLogDAL.h"
#import "ImChatLogModel.h"
#import "NSString+IsNullOrEmpty.h"

@implementation MessageRootViewModel

/**
 *  获取ViewModel数据源
 */
-(void)getViewDataSource:(NSString *)selectGUID{

    if(!_arrCellItem){
        _arrCellItem = [[NSMutableArray alloc] init];
    }
    
    _arrCellItem = [[ImRecentDAL shareInstance] getImRecentList:selectGUID];
}

///**
// *  获取搜索后的数据源
// */
//-(NSMutableArray *)getViewSearchDataSource:(NSString *)sarchText{
//    return [[ImRecentDAL shareInstance] getMessageRootListForSearch:sarchText];
//}

/**
 *  获取ViewModel选择数据源
 */
-(void)getViewDataSourceForSelect{
    
    if(!_arrCellItem){
        _arrCellItem = [[NSMutableArray alloc] init];
    }
    
    _arrCellItem = [[ImRecentDAL shareInstance] getImRecentSelectList];
}

/**
 *  将行数据源转为cellViewModel
 *
 *  @param cellData 数据库对应Model
 *
 *  @return MessageRootTableViewCellViewModel
 */
-(MessageRootTableViewCellViewModel *)resetToCellViewModel:(id)cellData{
    NSString *currentUid = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    
    ImRecentModel *imRecentModel = (ImRecentModel *)cellData;
    MessageRootTableViewCellViewModel *cellViewModel = [[MessageRootTableViewCellViewModel alloc] init];
    cellViewModel.face = imRecentModel.face;
    cellViewModel.type = imRecentModel.contacttype;
    cellViewModel.title = imRecentModel.contactname;
    
    if(cellViewModel.type == Chat_ContactType_Main_ChatGroup
       || cellViewModel.type == Chat_ContactType_Main_CoGroup
       || imRecentModel.contacttype == Chat_ContactType_Main_App_Seven
       || imRecentModel.contacttype == Chat_ContactType_Main_App_Eight){
        /* 群消息提醒不显示发送人 */
        if([NSString isNullOrEmpty:imRecentModel.lastmsguser]
           || [NSString isNullOrEmpty:imRecentModel.lastmsgusername]
           || [imRecentModel.lastmsguser isEqualToString:currentUid]
           || [NSString isNullOrEmpty:imRecentModel.lastmsg]){
            cellViewModel.detailText = imRecentModel.lastmsg;
        } else {
            cellViewModel.detailText = [NSString stringWithFormat:@"%@: %@",imRecentModel.lastmsgusername,imRecentModel.lastmsg];
        }
    } else {
        cellViewModel.detailText = imRecentModel.lastmsg;
    }
    
    cellViewModel.dateTime = [AppDateUtil getSystemShowTime:imRecentModel.lastdate isShowMS:NO];
    cellViewModel.data = imRecentModel;
    cellViewModel.badge = imRecentModel.badge;
//    cellViewModel.sendstatus = Chat_Msg_SendSuccess;    
    cellViewModel.sendstatus = imRecentModel.sendstatus;
    cellViewModel.isRecordMessageNoRecallReceive = imRecentModel.isrecordmsgnorecallreceive == 1 ? YES : NO;
    
    /* 获取最后一条聊天记录的时间 */
//    ImChatLogModel *imChatLogModel = [[ImChatLogDAL shareInstance] getLastChatLogModelWithDialogId:imRecentModel.contactid];
//    if(imChatLogModel!=nil){
////        NSString *strSend = @"";
////        switch (imChatLogModel.sendstatus) {
////            case Chat_Msg_Sending:
////                strSend = @"[发送中]";
////                break;
////            case Chat_Msg_SendFail:
////                strSend = @"[发送失败]";
////                break;
////        }
////        if(![NSString isNullOrEmpty:strSend]){
////            cellViewModel.detailText = [NSString stringWithFormat:@"%@%@",strSend,imRecentModel.lastmsg];
////        }
//        cellViewModel.sendstatus = imChatLogModel.sendstatus;
//        if(imChatLogModel.sendstatus!=Chat_Msg_SendSuccess){
//            cellViewModel.detailText = imChatLogModel.imClmBodyModel.content;
//        }
//    }

    return cellViewModel;
}

@end
