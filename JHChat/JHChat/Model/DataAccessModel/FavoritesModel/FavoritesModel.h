//
//  FavoritesModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 收藏管理表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "FavoriteTypeModel.h"

@interface FavoritesModel : NSObject

/* 主键 */
@property(nonatomic,strong) NSString *favoriteid;
/* 用户ID */
@property(nonatomic,strong) NSString *uid;
/* 类型 */
@property(nonatomic,strong) NSString *favoritetype;
/* 路径 */
@property(nonatomic,strong) NSString *imageurl;
/* 收藏时间 */
@property(nonatomic,strong) NSDate *favoritedate;
/* 标题 */
@property(nonatomic,strong) NSString *title;
/* 描述 */
@property(nonatomic,strong) NSString *descript;
/* 对象ID */
@property(nonatomic,strong) NSString *objectid;
/* 企业id */
@property(nonatomic,strong)NSString *oid;
/* 发布用户id */
@property(nonatomic,strong)NSString *releaseuid;
/* 发布用户头像 */
@property(nonatomic,strong)NSString *releaseuface;
/* 发布用户名称 */
@property(nonatomic,strong)NSString *releaseuname;
/* 内容图标是否为Web站点下的文件 */
@property(nonatomic,assign)NSInteger issrc;
/*  */
@property(nonatomic,assign) NSInteger isfavorite;
/*  */
@property (nonatomic,assign) long long size;
/*  */
@property (nonatomic,strong) NSString * exptype;
/* 应用码 */
@property (nonatomic,strong) NSString * appcode;

@property (nonatomic,strong) FavoritesModel *resourcefavorite;

@property (nonatomic,strong) FavoriteTypeModel *favoriteTypeModel;

/* 收藏0 关注1 */
@property (nonatomic,assign) NSInteger type;

@end
