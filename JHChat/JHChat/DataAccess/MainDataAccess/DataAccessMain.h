//
//  DataAccessMain.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 基础表维护
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface DataAccessMain : NSObject

/**
 *  创建或升级数据库
 */
-(BOOL)createOrUpdateDataTable;

/**
 *  创建数据库表
 */
-(void)createDataTable:(NSString *)type;

/**
 *  判断是否创建了数据库
 */
-(BOOL)checkIsCreatedDB;

/**
 *  获取当前数据库版本
 */
-(int)getCurrentDBVersion;

@end
