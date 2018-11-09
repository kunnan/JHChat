//
//  CloudDiskAppFolderParse.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/13.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-13
 Version: 1.0
 Description: 云盘文件夹
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZBaseParse.h"
#import "EventBus.h"
#import "EventPublisher.h"

@interface CloudDiskAppFolderParse : LZBaseParse<EventSyncPublisher>

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CloudDiskAppFolderParse *)shareInstance;

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
