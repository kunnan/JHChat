//
//  NetDiskOrgModel.h
//  LeadingCloud
//
//  Created by SY on 2017/7/18.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  sy
 Date：   2017/7/18
 Version: 1.0
 Description: 组织云盘企业区model
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
@interface NetDiskOrgModel : NSObject

/**
组织企业区
*/
@property (nonatomic, strong) NSString *groupid;
/**
 组织个人区
 */
@property (nonatomic, strong) NSString *rpid;
/**
 组织id
 */
@property (nonatomic, strong) NSString *orgid;
/**
 企业名称
 */
@property (nonatomic, strong) NSString *name;
/**
 企业图标
 */
@property (nonatomic, strong) NSString *logo;

/**
 组织云盘类型 1：企业 2：个人 3：部门
 */
@property (nonatomic, assign) NSInteger type;
/**
 排序
 */
@property (nonatomic, assign) NSInteger showindex;

@end
