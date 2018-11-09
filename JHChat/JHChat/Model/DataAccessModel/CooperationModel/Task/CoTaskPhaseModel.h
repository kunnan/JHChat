//
//  CoTaskPhaseModel.h
//  LeadingCloud
//
//  Created by wang on 16/2/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2015-12-21
 Version: 1.0
 Description: 任务环节表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface CoTaskPhaseModel : NSObject

// 节点id
@property(nonatomic,strong) NSString *phid;

@property(nonatomic,strong) NSString *tip;

@property(nonatomic,strong) NSDate *datelimit;

@property(nonatomic,strong) NSString *chief;

@property(nonatomic,strong) NSString *des;

@property(nonatomic,strong) NSString *modelid;

@property(nonatomic,strong) NSString *ruid;

@property(nonatomic,strong) NSString *tid;

@property(nonatomic,assign) NSInteger state;

@property(nonatomic,assign) NSInteger sort;

@property(nonatomic,assign) NSInteger activecount;

@property(nonatomic,assign) NSInteger type;

//头像
@property(nonatomic,copy)NSString *face;
@end
