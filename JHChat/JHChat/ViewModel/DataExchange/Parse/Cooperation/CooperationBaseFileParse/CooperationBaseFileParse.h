//
//  CooperationBaseFileParse.h
//  LeadingCloud
//
//  Created by SY on 16/12/27.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"

@interface CooperationBaseFileParse : LZBaseParse<EventSyncPublisher>
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationBaseFileParse *)shareInstance;
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
