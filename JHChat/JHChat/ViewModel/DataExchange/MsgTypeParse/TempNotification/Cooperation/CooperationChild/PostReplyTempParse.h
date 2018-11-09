//
//  PostReplyTempParse.h
//  LeadingCloud
//
//  Created by wang on 16/6/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-06-23
 Version: 1.0
 Description: 临时消息--协作--动态--回复
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "MsgBaseParse.h"

@interface PostReplyTempParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostReplyTempParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;
@end
