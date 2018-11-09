//
//  UserBasicModel.h
//  LeadingCloud
//
//  Created by dfl on 16/12/1.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  dfl
 Date：   2016-12-01
 Version: 1.0
 Description: 用户基本信息表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/
#import <Foundation/Foundation.h>

@interface UserBasicModel : NSObject

/* 用户id */
@property(nonatomic,strong) NSString *uid;
/* 用户名称 */
@property(nonatomic,strong) NSString *username;
/* 全称*/
@property(nonatomic,strong) NSString *quancheng;
/* 简称 */
@property(nonatomic,strong) NSString *jiancheng;
/* 头像 */
@property(nonatomic,strong) NSString *face;
/* 邮箱 */
@property(nonatomic,strong) NSString *email;
/* 固定电话 */
@property(nonatomic,strong) NSString *officecall;
/* 手机号码 */
@property(nonatomic,strong) NSString *mobile;

@end
