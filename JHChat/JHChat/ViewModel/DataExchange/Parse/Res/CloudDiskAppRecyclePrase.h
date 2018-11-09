//
//  CloudDiskAppRecyclePrase.h
//  LeadingCloud
//
//  Created by SY on 16/1/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"

@interface CloudDiskAppRecyclePrase : LZBaseParse

/**
 *  获取单一实例
 */
+(CloudDiskAppRecyclePrase *)shareInstance;

/**
 *  解析服务器传过来的数据
 */
-(void)parse:(NSMutableDictionary *)dataDic;

/**
 *  删除回收站文件
 *
 *  @param dataDic 服务器返回的数据
 */
-(void)praseDelRecycle:(NSMutableDictionary*)dataDic;

/**
 *  还原回收站文件
 *
 *  @param dataDic 服务器返回的数据
 */
-(void)praseRedution:(NSMutableDictionary*) dataDic;


/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic;

@end
