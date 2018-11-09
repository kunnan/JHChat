//
//  CloudDiskFavoritesParse.h
//  LeadingCloud
//
//  Created by SY on 16/3/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"

@interface CloudDiskFavoritesParse : LZBaseParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CloudDiskFavoritesParse *)shareInstance;

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
