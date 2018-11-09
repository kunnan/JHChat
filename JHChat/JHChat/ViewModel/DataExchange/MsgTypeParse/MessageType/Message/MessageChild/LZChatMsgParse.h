//
//  LZChatMsgParse.h
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

#import "MsgBaseParse.h"

@interface LZChatMsgParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(LZChatMsgParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析持久通知数据
 *
 *  @param dataDic 数据
 */
-(NSDictionary *)parse:(NSMutableDictionary *)dataDic;

@end
