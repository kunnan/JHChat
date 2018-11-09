//
//  LZChatTempParse.h
//  LeadingCloud
//
//  Created by gjh on 2017/7/26.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  gjh
 Date：   2017-07-26
 Version: 1.0
 Description: 聊天消息临时通知
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "MsgBaseParse.h"

@interface LZChatTempParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(LZChatTempParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
