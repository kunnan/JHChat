//
//  FileCommonParse.h
//  LeadingCloud
//
//  Created by SY on 16/8/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"
#import "EventBus.h"
#import "EventPublisher.h"
@interface FileCommonParse : LZBaseParse<EventSyncPublisher>
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(FileCommonParse *)shareInstance;

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
