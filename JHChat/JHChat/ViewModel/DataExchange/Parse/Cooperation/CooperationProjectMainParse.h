//
//  CooperationProjectMainParse.h
//  LeadingCloud
//
//  Created by SY on 16/10/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   16/10/17
 Version: 1.0
 Description: 项目 解析
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZBaseParse.h"

@interface CooperationProjectMainParse : LZBaseParse<EventSyncPublisher>
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationProjectMainParse *)shareInstance;

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
