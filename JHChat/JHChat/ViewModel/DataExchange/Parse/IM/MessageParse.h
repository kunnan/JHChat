//
//  MessageParse.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/30.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-30
 Version: 1.0
 Description: 接收、发送消息
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZBaseParse.h"

@interface MessageParse : LZBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MessageParse *)shareInstance;

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic;


-(BOOL)parseGet:(NSMutableDictionary *)dataDic;

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic;

@end
