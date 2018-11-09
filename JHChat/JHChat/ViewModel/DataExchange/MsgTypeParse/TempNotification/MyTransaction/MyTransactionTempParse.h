//
//  MyTransactionTempParse.h
//  LeadingCloud
//
//  Created by wang on 16/11/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-11-18
 Version: 1.0
 Description: 临时消息--我的事务
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgBaseParse.h"

@interface MyTransactionTempParse : MsgBaseParse


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MyTransactionTempParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
