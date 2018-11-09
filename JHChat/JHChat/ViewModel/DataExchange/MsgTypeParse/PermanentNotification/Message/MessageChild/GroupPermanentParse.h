//
//  GroupPermanentParse.h
//  LeadingCloud
//
//  Created by wchMac on 16/7/6.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-07-06
 Version: 1.0
 Description: 持久消息--群持久通知
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgBaseParse.h"

@interface GroupPermanentParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(GroupPermanentParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析持久通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
