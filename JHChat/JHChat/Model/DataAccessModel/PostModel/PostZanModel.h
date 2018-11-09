//
//  PostZanModel.h
//  LeadingCloud
//
//  Created by wang on 16/3/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-03-15
 Version: 1.0
 Description: 动态点赞模型
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface PostZanModel : NSObject

/*动态ID */
@property(nonatomic,copy)NSString *pid;
/*主键*/
@property(nonatomic,strong)NSString *ppid;
/*点赞时间*/
@property(nonatomic,strong)NSDate *praisedate;
/*用户ID*/
@property(nonatomic,strong)NSString *uid;
/*用户名称*/
@property(nonatomic,strong)NSString *username;

@end
