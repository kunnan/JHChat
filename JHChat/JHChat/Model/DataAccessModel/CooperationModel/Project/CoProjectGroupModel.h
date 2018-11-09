//
//  CoProjectGroupModel.h
//  LeadingCloud
//
//  Created by SY on 16/10/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  Sy
 Date：   16/10/17.
 Version: 1.0
 Description: 项目分组
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface CoProjectGroupModel : NSObject

/**
 分组id(主键)
 */
@property (nonatomic, strong) NSString *pgid;

/**
 用户id
 */
@property (nonatomic, strong) NSString *uid;

/**
 组织id
 */
@property (nonatomic, strong) NSString *orgid;

/**
 分组名称
 */
@property (nonatomic, strong) NSString *name;

/**
 分组排序
 */
@property (nonatomic, assign) NSInteger sort;

/**
 是否置顶
 */
@property (nonatomic, assign) BOOL istop;

/**
 能否调整顺序（【置顶项目、未分组项目
 */
@property (nonatomic, assign) BOOL sortable;

/**
 项目状态 1：进行中  9：已完成
 */
@property (nonatomic, assign) NSInteger state;

/**
 这个分组下的项目实例个数
 */
@property (nonatomic, assign) NSInteger prcount;

@end
