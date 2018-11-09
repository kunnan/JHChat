//
//  SysApiVersionModel.h
//  LeadingCloud
//
//  Created by wchMac on 2017/9/25.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2017-09-25
 Version: 1.0
 Description: 服务器WebApi数据版本
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface SysApiVersionModel : NSObject

/* 编号 */
@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *code22;

/* 类型 (0 平台  1 个人  2 企业)  */
@property(nonatomic,assign) NSInteger type;

/* 客户端版本号 */
@property (nonatomic, strong) NSString *client_version;

/* 服务器端版本号 */
@property (nonatomic, strong) NSString *server_version;

/* 最后一次请求webapi时间 */
@property(nonatomic,strong) NSDate *updatetime;

@end
