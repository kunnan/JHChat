//
//  UserInfoModel.h
//  LeadingCloud
//
//  Created by dfl on 16/6/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-06-30
 Version: 1.0
 Description: 用户详细信息表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

/* 用户ID */
@property(nonatomic,strong) NSString *uid;
/* 姓名 */
@property(nonatomic,strong) NSString *username;
/* 头像 */
@property(nonatomic,strong) NSString *face;
/* 用户信息JSON */
@property(nonatomic,strong) NSDictionary *cotainfojson;

@end
