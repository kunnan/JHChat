//
//  CooperationNewMemberParse.h
//  LeadingCloud
//
//  Created by SY on 16/6/8.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  sy
 Date：   2016-06-08
 Version: 1.0
 Description: 新的协作- 新的成员
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZBaseParse.h"

@interface CooperationNewMemberParse : LZBaseParse<EventSyncPublisher>

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationNewMemberParse *)shareInstance;

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
