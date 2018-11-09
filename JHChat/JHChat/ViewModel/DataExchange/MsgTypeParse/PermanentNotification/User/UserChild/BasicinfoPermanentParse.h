//
//  BasicinfoPermanentParse.h
//  LeadingCloud
//
//  Created by dfl on 16/5/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-05-16
 Version: 1.0
 Description: 持久消息--用户--用户头像
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgBaseParse.h"

@interface BasicinfoPermanentParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(BasicinfoPermanentParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析持久通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
