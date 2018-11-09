//
//  CoTaskRelatedModel.h
//  LeadingCloud
//
//  Created by wang on 16/2/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-02-25
 Version: 1.0
 Description: 任务关联表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"


@interface CoTaskRelatedModel : NSObject


@property(nonatomic,copy)NSString *keyId;
/*任务id*/
@property(nonatomic,copy)NSString *tid;

@property(nonatomic,copy)NSString *relatedname;
@property(nonatomic,copy)NSString *relatedid;

/*
 * 工作组1 项目 2
 */
@property(nonatomic,assign)NSInteger coopType;

/*是否关联 */
@property(nonatomic,assign)BOOL isrelated;
@end
