//
//  UserContactOfenCooperationModel.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/3.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  wch dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 常用联系人表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/
#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "UserModel.h"

@interface UserContactOfenCooperationModel : NSObject

/* 主键ID(用户ID) */
@property(nonatomic,strong) NSString *ucoid;
/* 最后时间 */
@property(nonatomic,strong) NSDate *lastdate;
/* 联系人ID */
@property(nonatomic,strong) NSString *receiverid;
/* 联系人名称 */
@property(nonatomic,strong) NSString *receivername;
/* 联系次数 */
@property(nonatomic,assign) NSInteger contactnumber;
/* 序号 */
@property(nonatomic,assign) NSInteger showindex;

/* 用户数据 */
@property(nonatomic,strong) UserModel *userModel;

@end
