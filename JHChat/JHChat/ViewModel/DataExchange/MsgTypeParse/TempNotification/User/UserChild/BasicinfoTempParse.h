//
//  BasicinfoTempParse.h
//  LeadingCloud
//
//  Created by dfl on 16/6/21.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-06-21
 Version: 1.0
 Description: 临时消息--个人基本信息--用户名称改变
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgBaseParse.h"

@interface BasicinfoTempParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(BasicinfoTempParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
