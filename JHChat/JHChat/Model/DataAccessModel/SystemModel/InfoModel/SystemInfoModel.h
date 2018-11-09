//
//  SystemInfoModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/4/29.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-04-29
 Version: 1.0
 Description: 记录软件Model
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface SystemInfoModel : NSObject

/* 主键ID */
@property (nonatomic, strong) NSString *si_key;

/* 对应的值 */
@property (nonatomic, strong) NSString *si_value;

@end
