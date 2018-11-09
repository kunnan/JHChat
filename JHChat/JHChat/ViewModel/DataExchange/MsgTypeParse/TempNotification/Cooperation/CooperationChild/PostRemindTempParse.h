//
//  PostRemindTempParse.h
//  LeadingCloud
//
//  Created by wchMac on 16/5/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-05-04
 Version: 1.0
 Description: 临时消息--协作--我的提醒
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgBaseParse.h"

@interface PostRemindTempParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostRemindTempParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
