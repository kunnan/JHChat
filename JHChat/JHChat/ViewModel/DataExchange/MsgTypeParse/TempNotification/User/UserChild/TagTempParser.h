//
//  TagTempParser.h
//  LeadingCloud
//
//  Created by dfl on 16/6/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-05-17
 Version: 1.0
 Description: 临时消息--用户--好友标签
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgBaseParse.h"

@interface TagTempParser : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(TagTempParser *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
