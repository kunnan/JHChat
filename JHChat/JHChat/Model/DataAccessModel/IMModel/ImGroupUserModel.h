//
//  ImGroupUserModel.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 分组成员表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface ImGroupUserModel : NSObject

/* 主键 */
@property(nonatomic,strong) NSString *iguid;
/* 分组ID */
@property(nonatomic,strong) NSString *igid;
/* 用户ID */
@property(nonatomic,strong) NSString *uid;
/* 用户姓名 */
@property(nonatomic,strong) NSString *username;
/* 备注 */
@property(nonatomic,strong) NSString *igremark;
/* 全称 */
@property(nonatomic,strong) NSString *quancheng;
/* 简称 */
@property(nonatomic,strong) NSString *jiancheng;
/* 头像 */
@property(nonatomic,strong) NSString *face;
/* 消息免打扰 */
@property(nonatomic,assign) NSInteger disturb;
/* 加入时间 */
@property(nonatomic,strong) NSDate *jointime;

@end
