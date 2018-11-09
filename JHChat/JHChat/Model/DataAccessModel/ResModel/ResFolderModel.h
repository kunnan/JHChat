//
//  ResFolderModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/13.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  dfl
 Date：   2016-01-13
 Version: 1.0
 Description: 资源文件夹
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface ResFolderModel : NSObject

/* 资源文件夹ID */
@property(nonatomic,strong) NSString *classid;
/* 路径 */
@property(nonatomic,strong) NSString *url;
/* 文件夹名称 */
@property(nonatomic,strong) NSString *name;
/* 创建日期 */
@property(nonatomic,strong) NSDate *createdate;
/* 创建人 */
@property(nonatomic,strong) NSString *createuser;
/* 创建人名称 */
@property(nonatomic,strong) NSString *createusername;
/* 更新日期 */
@property(nonatomic,strong) NSDate *updatedate;
/* 更新人 */
@property(nonatomic,strong) NSString *updateuser;
/* 更新人名称 */
@property(nonatomic,strong) NSString *updateusername;
/* 父文件夹id */
@property(nonatomic,strong) NSString *parentid;
/* 所有父路径 */
@property(nonatomic,strong) NSString *parentall;

@property(nonatomic,strong) NSString *parentidall;
/* 存储器类型 */
@property(nonatomic,assign) NSInteger partitiontype;
/* 描述 */
@property(nonatomic,strong) NSString *descript;
/* 是否缓存完子资源 */
@property(nonatomic,assign) NSInteger iscacheallres;
/* 所属资源池 */
@property (nonatomic,strong) NSString *rpid;
/* 缩略图 */
@property (nonatomic, strong) NSString *icon;
/* 用于排序 */
@property (nonatomic, strong) NSString *pinyin;

/* 文件操作权限 1:可操作 0：有权限*/
@property (nonatomic, assign) NSInteger operateauthority;
@property (nonatomic,assign) NSInteger isshare;
@end
