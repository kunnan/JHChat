//
//  BusinessSessionParse.h
//  LeadingCloud
//
//  Created by gjh on 17/4/5.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"
#import "EventBus.h"
#import "EventPublisher.h"

@interface BusinessSessionParse : LZBaseParse<EventSyncPublisher>

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(BusinessSessionParse *)shareInstance;

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
