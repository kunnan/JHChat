//
//  CooperationPedningParse.h
//  LeadingCloud
//
//  Created by wang on 16/10/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-10-18
 Version: 1.0
 Description: 待处理（事务）解析
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "LZBaseParse.h"
#import "EventBus.h"
#import "EventPublisher.h"
@interface CooperationPedningParse : LZBaseParse<EventSyncPublisher>

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationPedningParse *)shareInstance;

/**
 *  解析数据
 *
 *  @param dataDic
 */
-(void)parse:(NSMutableDictionary *)dataDic;

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic;
@end
