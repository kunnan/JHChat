//
//  FavoritesHT.h
//  LeadingCloud
//
//  Created by wchMac on 16/5/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef FavoritesHT_h
#define FavoritesHT_h

#endif /* FavoritesHT_h */

/* =================================收藏(favorites)================================= */
/* 收藏类型 */
// 资源
static NSString * const FavoritesType_Resource = @"resources";
// 动态
static NSString * const FavourittesType_Post = @"post";
// 任务
static NSString * const FavourittesType_Task = @"task";



static NSString * const Handler_favorites = @"favorites";

/* 添加(add) */
static NSString * const Handler_Favorites_Add = @"add";
static NSString * const Handler_Favorites_Add_Single  = @"favorites.add.single"; //添加收藏--临时通知(已处理)

/* 移除(remove) */
static NSString * const Handler_Favorites_Remove = @"remove";
static NSString * const Handler_Favorites_Remove_Single  = @"favorites.remove.single";  //移除收藏,单个--临时通知(已处理)
static NSString * const Handler_Favorites_Remove_Multiple  = @"favorites.remove.multiple";  //移除收藏,多个--临时通知(已处理)
static NSString * const Handler_Favorites_Remove_Type  = @"favorites.remove.type";  //移除收藏,一类--临时通知(已处理)
static NSString * const Handler_Favorites_Remove_All  = @"favorites.remove.all";  //移除收藏,全部--临时通知(已处理)
