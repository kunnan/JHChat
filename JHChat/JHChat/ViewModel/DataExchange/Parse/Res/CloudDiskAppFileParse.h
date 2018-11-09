//
//  CloudDiskAppFileParse.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/14.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-14
 Version: 1.0
 Description: 云盘文件
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZBaseParse.h"

@interface CloudDiskAppFileParse : LZBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CloudDiskAppFileParse *)shareInstance;

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
