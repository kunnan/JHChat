//
//  RemotelyServerParse.h
//  LeadingCloud
//
//  Created by SY on 2017/6/22.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"

@interface RemotelyServerParse : LZBaseParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(RemotelyServerParse *)shareInstance;
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
