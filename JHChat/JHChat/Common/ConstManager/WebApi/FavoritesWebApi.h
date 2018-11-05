//
//  FavoritesWebApi.h
//  LeadingCloud
//
//  Created by wchMac on 16/6/2.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef FavoritesWebApi_h
#define FavoritesWebApi_h


#endif /* FavoritesWebApi_h */

/*------------------收藏------------------------*/
static NSString * const WebApi_CloudFavorites = @"api/favorites";
/* 添加收藏 */
static NSString * const WebApi_CloudFavorites_Add = @"api/favorites/v2/add/{tokenid}";
/* 取消收藏 */
static NSString * const WebApi_CloudFavorites_Cannel = @"api/favorites/v2/remove/{type}/{objectid}/{appcode}/{state}/{tokenid}";
/* 获取下一页收藏记录 */
static NSString * const WebApi_CloudFavorites_Section = @"api/favorites/section/{lastkey}/{length}/{tokenid}";
/* 获取下一页收藏记录（一个类型）*/
static NSString * const WebApi_CloudFavorites_Section_Type = @"api/favorites/section/{lastkey}/{length}/{type}/{appcode}/{tokenid}";
/* 搜索收藏记录 */
static NSString * const WebApi_CloudFavorites_Search = @"api/favorites/search/{length}/{tokenid}";
/* 搜索收藏记录(一个类型) */
static NSString * const WebApi_CloudFavorites_Search_Type = @"api/favorites/search/{length}/{type}/{appcode}/{tokenid}";
/* 获取搜索结果下一页数据 */
static NSString * const WebApi_CloudFavorites_Search_Next = @"api/favorites/search/{lastkey}/{length}/{tokenid}";
/* 获取搜索类型 */
static NSString * const WebApi_CloudFavorites_GetType = @"api/favorites/gettype/{tokenid}";

/*------------------收藏 v2------------------------*/
/* 获取收藏记录 */
static NSString * const WebApi_CloudFavorites_V2GetFavorites = @"api/favorites/v2/getfavorites/{tokenid}";
/* 获取收藏类型 */
static NSString * const WebApi_CloudFavorites_V2GetType = @"api/favorites/v2/gettype/{tokenid}";


