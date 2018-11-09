//
//  PostPraiseTempParse.h
//  LeadingCloud
//
//  Created by wang on 16/8/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-08-04
 Version: 1.0
 Description: 临时消息--协作--动态--点赞
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "MsgBaseParse.h"

@interface PostPraiseTempParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostPraiseTempParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
