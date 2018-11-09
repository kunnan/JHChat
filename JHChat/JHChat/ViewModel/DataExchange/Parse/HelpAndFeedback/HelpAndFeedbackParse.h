//
//  HelpAndFeedbackParse.h
//  LeadingCloud
//
//  Created by dfl on 16/7/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-07-04
 Version: 1.0
 Description: 帮助与反馈
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZBaseParse.h"

@interface HelpAndFeedbackParse : LZBaseParse<EventSyncPublisher>

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(HelpAndFeedbackParse *)shareInstance;

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
