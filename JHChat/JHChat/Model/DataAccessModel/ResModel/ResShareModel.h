//
//  ResShareModel.h
//  LeadingCloud
//
//  Created by SY on 16/2/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
Author:  sy
Date：   2016-02-23
Version: 1.0
Description: 【云盘】 分享文件夹模型
History:
<author>  <time>   <version >   <desc>
***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "ResShareItemModel.h"
@interface ResShareModel : NSObject

/* 分享文件id*/
@property (nonatomic, strong) NSString *shareid;
/* copy link */
@property (nonatomic, strong) NSString *copylink;
/* 所属资源池 */
@property (nonatomic, strong) NSString *rpid;
/* 分享文件名*/
@property (nonatomic, strong) NSString *name;
/* 扩展类型 */
@property (nonatomic, strong) NSString *exptype;
/* 分享者 */
@property (nonatomic, strong) NSString *shareuser;
/* 分享者姓名 */
@property (nonatomic, strong) NSString *shareusername;
/* 时间标记 */
@property (nonatomic, strong) NSDate *sharedate;
/* 日期 */
@property (nonatomic, strong) NSDate *matuitydate;
/* 类型划分 */
@property (nonatomic, assign) NSInteger partitiontype;
/* 分享链接 */
@property (nonatomic, strong) NSString *sharelink;
/* 私密 or 公开 */
@property (nonatomic, strong) NSString *paw;
/* 类型 1有密码 2无密码 */
@property (nonatomic, assign) NSInteger type;
/* 分享类型 */
@property (nonatomic ,strong) NSString *showtype;
/* 缩略图 */
@property (nonatomic, strong) NSString *imageurl;
// url?
@property (nonatomic, assign) NSInteger issrc;
/* ？？*/
@property (nonatomic, strong) NSString *qrcode;
/* 全分享地址 */
@property (nonatomic ,strong) NSString *showlink;
@property (nonatomic ,strong) NSString *customname;

@property (nonatomic, strong) NSString *relationid;
@property (nonatomic, strong) NSString *appcode;

@property (nonatomic, strong) ResShareItemModel *itemModel;
@end
