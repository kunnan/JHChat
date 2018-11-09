//
//  ResShareItemModel.h
//  LeadingCloud
//
//  Created by SY on 16/2/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  sy
 Date：   2016-02-23
 Version: 1.0
 Description: 【云盘】 分享文件模型
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
@interface ResShareItemModel : NSObject

/* id*/
@property (nonatomic, strong) NSString *shiid;
/* 分享id */
@property (nonatomic, strong) NSString *shareid;
/* 所属资源池 */
@property (nonatomic, strong) NSString *rpid;
/* 文件夹得folderid 文件的rid */
@property (nonatomic, strong) NSString *itemid;
/* 文件名 */
@property (nonatomic, strong) NSString *itemname;
/* 展示名 */
@property (nonatomic, strong) NSString *showname;
/* 扩展类型 */
@property (nonatomic, strong) NSString *itemexptype;
/* 文件类型 2： 文件夹*/
@property (nonatomic, assign) NSInteger itemtype;
/* 文件类型 */
@property (nonatomic, assign) long long itemsize;
/* 展示大小 */
@property (nonatomic ,strong) NSString *showsize;
/* 分享日期 */
@property (nonatomic, strong) NSDate *sharedate;
/* 文件划分类型 */
@property (nonatomic, assign) NSInteger itempartitiontype;

@property (nonatomic ,strong) NSString *icon;

@property (nonatomic, assign) NSInteger isvalid;


@end
