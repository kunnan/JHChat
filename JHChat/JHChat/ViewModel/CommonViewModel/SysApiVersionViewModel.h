//
//  SysApiVersionViewModel.h
//  LeadingCloud
//
//  Created by wchMac on 2017/9/26.
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

@interface SysApiVersionViewModel : NSObject

/**
 *  获取需要在登录时请求的webapi数组
 */
-(NSMutableArray *)getNotNeedRequestWebApiArr;

@end
