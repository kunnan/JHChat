//
//  FavoritesTempParse.h
//  LeadingCloud
//
//  Created by SY on 16/5/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-05-20
 Version: 1.0
 Description: 临时消息--收藏
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgBaseParse.h"

@interface FavoritesTempParse : MsgBaseParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(FavoritesTempParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;
@end
