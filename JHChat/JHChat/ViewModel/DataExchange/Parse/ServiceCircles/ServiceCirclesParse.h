//
//  ServiceCirclesParse.h
//  LeadingCloud
//
//  Created by wang on 17/3/28.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"

@interface ServiceCirclesParse : LZBaseParse<EventSyncPublisher>

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ServiceCirclesParse *)shareInstance;

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
