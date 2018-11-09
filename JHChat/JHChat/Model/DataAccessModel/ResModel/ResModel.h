//
//  ResModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 资源表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/
#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "ResFileModel.h"
#import "FavoritesModel.h"
@interface ResModel : NSObject

/* 资源ID */
@property(nonatomic,strong) NSString *rid;
/* 资源客户端临时ID */
@property(nonatomic,strong) NSString *clienttempid;
/* 分区 */
@property(nonatomic,assign) NSInteger partitiontype;
/* 文件名 */
@property(nonatomic,strong) NSString *name;
/* 所属资源池 */
@property(nonatomic,strong) NSString *rpid;
/* 所属静态分类 */
@property(nonatomic,strong) NSString *classid;
/* 创建人 */
@property(nonatomic,strong) NSString *createuser;
/* 创建人名称 */
@property(nonatomic,strong) NSString *createusername;
/* 创建日期 */
@property(nonatomic,strong) NSDate *createdate;
/* 修改人 */
@property(nonatomic,strong) NSString *updateuser;
/* 修改人名称 */
@property(nonatomic,strong) NSString *updateusername;
@property(nonatomic, strong) NSString *folderpath;
/* 修改日期 */
@property(nonatomic,strong) NSDate *updatedate;
/* 版本号 */
@property(nonatomic,assign) NSInteger version;
/* 版本ID */
@property(nonatomic,strong) NSString *versionid;
/* 资源类型 1:文件；2：数据; 3:资源包*/
@property(nonatomic,assign) NSInteger rtype;
/* 是否为主信息 */
@property(nonatomic,assign) NSInteger ismain;
/* 是否为当前版本 */
@property(nonatomic,assign) NSInteger iscurrentversion;

@property(nonatomic, strong) NSString *showversion;
/* 扩展类型 */
@property(nonatomic,strong) NSString *exptype;
/* 文件大小 */
@property(nonatomic,assign) long long size;
/* 扩展ID */
@property(nonatomic,strong) NSString *expid;
/* 描述 */
@property(nonatomic,strong) NSString *descript;
/* 子对象数量 */
@property(nonatomic,assign) NSInteger subcount;
/* 是否删除 */
@property(nonatomic,assign) NSInteger isdel;
/* 是否收藏 */
@property (nonatomic, assign) NSInteger isfavorite;
/* 扩展信息 */
@property (nonatomic, strong) NSString *expandinfo;
/* 头像 */
@property (nonatomic, strong) NSString *icon;
/* 图像类型 */
@property (nonatomic,assign) NSInteger icontype;

@property (nonatomic, strong) NSString *iconurl;
@property (nonatomic, assign) NSInteger sortindex;
@property (nonatomic, assign) NSInteger rdid;

/* 文件上传状态 */
@property(nonatomic,assign) NSInteger uploadstatus;
/* 文件下载状态 */
@property(nonatomic,assign) NSInteger downloadstatus;
/* 文件信息 */
@property(nonatomic,strong) NSString *fileinfo;


///* 文件在磁盘上的名称 */
@property(nonatomic, strong) NSString *filePhysicalName;

/* 文件显示名称 */
@property(nonatomic, strong) NSString *fileShowName;
/* 数据Model */
@property(nonatomic,strong,readonly) ResFileModel *resFileModel;
/* 文件收藏的model */
@property (nonatomic, strong) FavoritesModel *favoriteModel;
/* 文件收藏json */
@property (nonatomic, strong) NSMutableDictionary *favoritesDic;

/* 文件操作权限
1:可操作 0：有权限
 */
@property (nonatomic, assign) NSInteger operateauthority;

@end
