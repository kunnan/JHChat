//
//  CooperationAppTempParse.h
//  LeadingCloud
//
//  Created by SY on 16/6/13.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-06-13
 Version: 1.0
 Description: 临时消息--协作--工具app
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgBaseParse.h"

@interface CooperationAppTempParse : MsgBaseParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationAppTempParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
