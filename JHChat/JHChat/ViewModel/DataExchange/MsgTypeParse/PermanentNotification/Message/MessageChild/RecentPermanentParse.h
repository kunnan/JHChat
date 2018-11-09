//
//  RecentPermanentParse.h
//  LeadingCloud
//
//  Created by wchMac on 2017/10/10.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-24
 Version: 1.0
 Description: 最近联系人临时通知
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgBaseParse.h"

@interface RecentPermanentParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(RecentPermanentParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
