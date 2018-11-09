//
//  CooperationCouldRelationItem.h
//  LeadingCloud
//
//  Created by wang on 16/4/29.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-04-29
 Version: 1.0
 Description: 可关联的父任务模型
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface CooperationCouldRelationItem : NSObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *parentpath;
@property(nonatomic,strong)NSString *pinyin;
@property(nonatomic,strong)NSString *tid;


@end
