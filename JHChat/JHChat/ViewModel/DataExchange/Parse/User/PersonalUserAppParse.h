//
//  personalUserAppParse.h
//  LeadingCloud
//
//  Created by lz on 16/3/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-03-19
 Version: 1.0
 Description: 个人ios应用
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZBaseParse.h"
#import "EventBus.h"
#import "EventPublisher.h"


@interface PersonalUserAppParse : LZBaseParse<EventSyncPublisher>


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PersonalUserAppParse *)shareInstance;

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

