//
//  CooLayoutModel.h
//  LeadingCloud
//
//  Created by SY on 16/5/6.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-05-06
 Version: 1.0
 Description: 协作-基本信息/动态显隐控制
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "CooLayoutInfoModel.h"
#import "CooGroupLayoutInfoModel.h"
@interface CooLayoutModel : NSObject
// 协作id
@property (nonatomic ,strong) NSString *cid;
// josn
@property (nonatomic, strong) NSMutableDictionary *layout;


// 任务控制显隐model
@property (nonatomic ,strong) CooLayoutInfoModel *layoutInfoModel;

// 工作组控制显隐model
@property (nonatomic, strong) CooGroupLayoutInfoModel *groupLayoutModel;

@end
