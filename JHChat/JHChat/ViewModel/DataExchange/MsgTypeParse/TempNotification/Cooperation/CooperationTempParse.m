//
//  CooperationTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/3.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-04-29
 Version: 1.0
 Description: 临时消息--协作
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "CooperationTempParse.h"
#import "PostTempParse.h"
#import "PostRemindTempParse.h"
#import "PostResourcesTempParse.h"
#import "TaskTempParse.h"
#import "WorkGroupTempParse.h"
#import "DocumentTempParse.h"
#import "PostCueTempParse.h"
#import "CooperationAppTempParse.h"
#import "PostReplyTempParse.h"
#import "PostPraiseTempParse.h"
#import "PostTagTempParse.h"

@implementation CooperationTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationTempParse *)shareInstance{
    static CooperationTempParse *instance = nil;
    if (instance == nil) {
        instance = [[CooperationTempParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    NSString *secondModel = [[HandlerTypeUtil shareInstance] getSecondModel:[dataDic objectForKey:@"handlertype"]];
    
    BOOL isSendReport = NO;
    
    
    BOOL isCooperation_load = [LZUserDataManager isCooperationLoading];


    /* 动态 */
    if([secondModel isEqualToString:Handler_Cooperation_Postmain]&& isCooperation_load){
        isSendReport = [[PostTempParse alloc] parse:dataDic];
    }
    /*回复*/
    else if ([secondModel isEqualToString:Handler_Cooperation_Post_Reply]&& isCooperation_load){
        
        isSendReport = [[PostReplyTempParse alloc]parse:dataDic];
    }
    
    /* 常用语 */
    else if ([secondModel isEqualToString:Handler_Cooperation_Postcue]&& isCooperation_load){
        isSendReport = [[PostCueTempParse alloc] parse:dataDic];
    }
    /* 我的提醒 */
    else if( [secondModel isEqualToString:Handler_Cooperation_PostRemind] ){
        isSendReport = [[PostRemindTempParse alloc] parse:dataDic];
    }
    /* 资源评论 */
    else if( [secondModel isEqualToString:Handler_Cooperation_PostResources] && isCooperation_load ){
        isSendReport = [[PostResourcesTempParse alloc] parse:dataDic];
    }
    /* 任务 */
    else if( [secondModel isEqualToString:Handler_Cooperation_Task] ){
        isSendReport = [[TaskTempParse alloc] parse:dataDic];
    }
    /* 工作组 */
    else if( [secondModel isEqualToString:Handler_Cooperation_Group] ){
        isSendReport = [[WorkGroupTempParse alloc] parse:dataDic];
    }
    /* 协作文件 */
    else if ( [secondModel isEqualToString:Handler_Cooperation_Document] ) {
        isSendReport = [[DocumentTempParse alloc] parse:dataDic];
    }
    /* 协作工具app */
    else if ([secondModel isEqualToString:Handler_Cooperation_App]) {
        isSendReport = [[CooperationAppTempParse alloc] parse:dataDic];
    }
    /*点赞*/
    else if ([secondModel isEqualToString:Handler_Cooperation_Post_Praise]){
        isSendReport = [[PostPraiseTempParse alloc]parse:dataDic];
    }
    /*标签*/
    else if ([secondModel isEqualToString:Handler_Cooperation_Post_Tag]){
        isSendReport = [[PostTagTempParse alloc]parse:dataDic];
    }
           
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

@end
