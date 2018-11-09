//
//  CloudDiskAppShareParse.h
//  LeadingCloud
//
//  Created by SY on 16/2/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"



@interface CloudDiskAppShareParse : LZBaseParse


/**
 *  获取单一实例
 */
+(CloudDiskAppShareParse *)shareInstance;

/**
 *  解析服务器传过来的数据
 */
-(void)parse:(NSMutableDictionary *)dataDic;

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic;

@end
