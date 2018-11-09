//
//  ImGroupParse.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/26.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-26
 Version: 1.0
 Description: 解析群组数据
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZBaseParse.h"
#import "EventBus.h"
#import "EventPublisher.h"

@interface ImGroupParse : LZBaseParse<EventSyncPublisher>

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImGroupParse *)shareInstance;

#pragma mark - 解析webapi请求的数据

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic;

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic;

@end
