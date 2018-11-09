//
//  OrgPermanentParse.h
//  LeadingCloud
//
//  Created by dfl on 16/8/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-08-25
 Version: 1.0
 Description: 持久消息--组织机构--组织管理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/


#import "MsgBaseParse.h"

@interface OrgPermanentParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgPermanentParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析持久通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;


@end
