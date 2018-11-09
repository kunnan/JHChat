//
//  CooperationProjectParse.h
//  LeadingCloud
//
//  Created by wang on 16/5/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wzb
 Date：   2015-05-23
 Version: 1.0
 Description: 项目解析
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZBaseParse.h"

@interface CooperationProjectParse : LZBaseParse<EventSyncPublisher>


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationProjectParse *)shareInstance;
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
