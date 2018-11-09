//
//  ErrorModel.h
//  LeadingCloud
//
//  Created by dfl on 16/4/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-04-15
 Version: 1.0
 Description: 请求WebAPI错误日志表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface ErrorModel : NSObject

/* 错误id */
@property (nonatomic, strong) NSString *errorid;
/* 用户错误id (uid) */
@property (nonatomic, strong) NSString *erroruid;
/* 错误标题 */
@property (nonatomic, strong) NSString *errortitle;
/* 错误类名称 (暂时没有) */
@property (nonatomic, strong) NSString *errorclass;
/* 错误方法名 (具体的WebApi地址) */
@property (nonatomic, strong) NSString *errormethod;
/* 错误信息数据 (请求的数据和返回的错误数据) */
@property (nonatomic, strong) NSString *errordata;
/* 错误信息 出现时间 */
@property (nonatomic, strong) NSDate *errordate;
/* 日志类型 (0 跟踪日志  1 错误日志  2消息日志)  */
@property(nonatomic,assign) NSInteger errortype;


@end
