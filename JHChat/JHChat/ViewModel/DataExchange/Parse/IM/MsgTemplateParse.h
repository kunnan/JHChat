//
//  MsgTemplateParse.h
//  LeadingCloud
//
//  Created by dfl on 16/8/10.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-08-10
 Version: 1.0
 Description: 消息模板
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZBaseParse.h"

@interface MsgTemplateParse : LZBaseParse<EventSyncPublisher>


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MsgTemplateParse *)shareInstance;

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
