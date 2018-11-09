//
//  MsgMessageTypeParse.h
//  LeadingCloud
//
//  Created by wchMac on 16/3/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-12
 Version: 1.0
 Description: 消息解析
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgBaseParse.h"

@interface MsgMessageTypeParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MsgMessageTypeParse *)shareInstance;

/**
 *  解析数据
 *
 *  @param dataDic
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end