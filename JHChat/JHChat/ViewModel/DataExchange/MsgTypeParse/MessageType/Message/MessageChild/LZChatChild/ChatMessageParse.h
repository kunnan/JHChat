//
//  ChatMessageParse.h
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

#import "MsgBaseParse.h"

@interface ChatMessageParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ChatMessageParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析持久通知数据
 *
 *  @param dataDic 数据
 */
-(NSDictionary *)parse:(NSMutableDictionary *)dataDic;

@end
