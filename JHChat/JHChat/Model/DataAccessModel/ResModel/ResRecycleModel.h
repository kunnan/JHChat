//
//  ResRecycleModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 资源回收站表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface ResRecycleModel : NSObject

/* 资源删除ID */
@property(nonatomic,strong) NSString *recyid;
/* 资源池ID */
@property(nonatomic,strong) NSString *rpid;
/* 删除文件的classid */
@property(nonatomic,strong) NSString *classid;
/* 资源名称 */
@property(nonatomic,strong) NSString *name;
/* 扩展名 */
@property(nonatomic,strong) NSString *exptype;
/* 图片URL */
@property(nonatomic, strong) NSString *imageurl;
/* 类型 */
@property(nonatomic,assign) NSInteger type;
/* 操作人 */
@property(nonatomic,strong) NSString *createuser;
/* 操作人名称 */
@property(nonatomic,strong) NSString *createusername;
/* 文件路径 */
@property(nonatomic,strong) NSString *folderpath;
/* 删除日期 */
@property(nonatomic,strong) NSDate *deletedate;
/* 数据 */
@property(nonatomic,strong) NSString *json;
/* 分区类型 */
@property(nonatomic,assign) NSInteger partitiontype;
/* 是否缓存完资源 */
@property(nonatomic,assign) NSInteger iscacheallres;

/* 有效期 */
@property (nonatomic,assign) NSInteger availabledays;

@end
