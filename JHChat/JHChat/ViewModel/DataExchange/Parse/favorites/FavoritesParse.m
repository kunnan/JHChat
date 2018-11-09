//
//  FavoritesParse.m
//  LeadingCloud
//
//  Created by wang on 16/3/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "FavoritesParse.h"
#import "FavoritesDAL.h"
#import "AppDateUtil.h"
#import "FavoriteTypeDAL.h"
#import "NSDictionary+DicSerial.h"
#import "CoGroupDAL.h"

@implementation FavoritesParse

+(FavoritesParse *)shareInstance{
    static FavoritesParse *instance = nil;
    if (instance == nil) {
        instance = [[FavoritesParse alloc] init];
    }
    return instance;
}


-(void)parse:(NSMutableDictionary *)dataDic{
    
    NSString *route = [dataDic objectForKey:WebApi_Route];
    // 添加收藏
    if ([route isEqualToString:WebApi_CloudFavorites_Add]) {
        
        
    //    NSString *dataContext=[dataDic lzNSStringForKey:WebApi_DataContext];
        NSMutableDictionary *data=[NSMutableDictionary dictionaryWithDictionary:[dataDic objectForKey:WebApi_DataSend_Post]];
//        FavoritesModel *fModel=[[FavoritesModel alloc]init];
//        fModel.isfavorite=YES;
//        fModel.favoriteid=[LZUtils CreateGUID];
//        fModel.favoritedate=[AppDateUtil GetCurrentDate];
//        [fModel serializationWithDictionary:data];
        
        //[[FavoritesDAL shareInstance]addDataWithFavoriteModel:fModel];
     //   [data setObject:dataContext forKey:@"favoriteid"];
        [data setObject:@"1" forKey:@"isfavorite"];
        __block FavoritesParse * service = self;
        NSDictionary *getParam= [dataDic objectForKey:WebApi_DataSend_Get];
        NSString * type=[getParam objectForKey:@"type"];
		
        /* 在主线程中发送通知 */
		if (type &&[type isEqualToString:@"post"]) {
			
			[data setObject:[getParam lzNSStringForKey:@"pid"] forKey:@"pid"];
			
			
		}else if (type &&[type isEqualToString:@"task"]){
			
		}
		else if (type &&[type isEqualToString:@"group"]){
			
			NSDictionary *postParam= [dataDic objectForKey:WebApi_DataSend_Post];
			NSString *objectid = [postParam lzNSStringForKey:@"objectid"];
			[[CoGroupDAL shareInstance]updateGroupId:objectid withGroupState:true];
			
		}
        dispatch_async(dispatch_get_main_queue(), ^{
            if (type &&[type isEqualToString:@"post"]) {
				
                EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_Add, data);

            }else if (type &&[type isEqualToString:@"task"]){
				
				EVENT_PUBLISH_WITHDATA(service, EventBus_PostRoot_Refresh_Not, nil);

                EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_Add_Task, data);
            }
			else if (type &&[type isEqualToString:@"group"]){
				
				
				EVENT_PUBLISH_WITHDATA(service, EventBus_PostRoot_Refresh_Not, nil);
				
				EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_Add_Group, data);
			}

        });
		
    }
    //取消收藏
    else if ([route isEqualToString:WebApi_CloudFavorites_Cannel]){
        
//        NSString *dataContext=[NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *dataContext = [NSString stringWithFormat:@"%@",dataNumber];
        
        if (dataContext &&[dataContext isEqualToString:@"1"]) {
            
            NSMutableDictionary *data=[NSMutableDictionary dictionaryWithDictionary:[dataDic objectForKey:WebApi_DataSend_Get]];
            
            NSString *objectid=[data objectForKey:@"objectid"];
            
            [[FavoritesDAL shareInstance]deleteDidCollectionFile:objectid];
            
            self.appDelegate.lzGlobalVariable.isNeedRefreshMoreCollectionVC=YES;
            
            __block FavoritesParse * service = self;
            NSString * type=[data objectForKey:@"favoritetype"];
			
			if(type && [type isEqualToString:@"group"]){
				NSDictionary *postParam= [dataDic objectForKey:WebApi_DataSend_Post];
				NSString *objectid = [postParam lzNSStringForKey:@"objectid"];
				[[CoGroupDAL shareInstance]updateGroupId:objectid withGroupState:false];
			}
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                if (type &&[type isEqualToString:@"post"]) {
                    EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_Cannel, data);
                }else if (type &&[type isEqualToString:@"task"]){
//					EVENT_PUBLISH_WITHDATA(service, EventBus_PostRoot_Refresh_Not, nil);
                    EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_Cannel_Task, nil);
				}else if (type && [type isEqualToString:@"group"]){
					
					
//					EVENT_PUBLISH_WITHDATA(service, EventBus_PostRoot_Refresh_Not, nil);
					EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_Cannel_Group, nil);
				}
                EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_CannelAll, nil);
            });
        }
    }
    //获取下一页收藏记录
    else if ([route isEqualToString:WebApi_CloudFavorites_Section]){
        [self parseFavoritesSection:dataDic];
    }
    //获取下一页收藏记录（类型）
    else if([route isEqualToString:WebApi_CloudFavorites_Section_Type]){
        [self parseFavoritesSectionType:dataDic];
    }
    //获取搜索记录
    else if([route isEqualToString:WebApi_CloudFavorites_Search]){
        [self parseFavoritesSearch:dataDic];
    }
    //获取搜索记录(类型)
    else if([route isEqualToString:WebApi_CloudFavorites_Search_Type]){
        [self parseFavoritesSearchType:dataDic];
    }
    //获取搜索下一页记录
    else if([route isEqualToString:WebApi_CloudFavorites_Search_Next]){
        [self parseFavoritesSearchNext:dataDic];
    }
    //获取搜索类型
    else if ([route isEqualToString:WebApi_CloudFavorites_GetType]){
        [self parseFavoritesGetType:dataDic];
    }
    //获取收藏类型
    else if ([route isEqualToString:WebApi_CloudFavorites_V2GetType]){
        [self parseFavoritesGetType:dataDic];
    }
    //获取收藏记录
    else if ([route isEqualToString:WebApi_CloudFavorites_V2GetFavorites]){
        [self parseV2GetFavorites:dataDic];
    }

}

/**
 *  获取下一页收藏记录
 *  @param dataDict
 */
-(void)parseFavoritesSection:(NSMutableDictionary *)dataDict{
    NSMutableArray *favoritesInfo  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *allFavoritesArr=[NSMutableArray array];
    for(int i=0;i<favoritesInfo.count;i++){
        
        NSDictionary *favoritesDic=[favoritesInfo objectAtIndex:i];
        
        FavoritesModel *favoritesModel=[[FavoritesModel alloc]init];
        [favoritesModel serializationWithDictionary:favoritesDic];
        
        [allFavoritesArr addObject:favoritesModel];
    
    }
    NSDictionary *param=[dataDict objectForKey:WebApi_DataSend_Get];
    NSString *lastkey=[param objectForKey:@"lastkey"];
    if([lastkey isEqualToString:@"0"]){
        [[FavoritesDAL shareInstance]deleteAllDidCollectionFile];
    }
    
    [[FavoritesDAL shareInstance] addDataWithFavoriteArray:allFavoritesArr];
    
    
    NSMutableDictionary *favoritesDict=[NSMutableDictionary dictionary];
    [favoritesDict setObject:lastkey forKey:@"lastkey"];
    [favoritesDict setObject:allFavoritesArr forKey:@"allFavoritesAll"];
    [favoritesDict setObject:[[dataDict lzNSDictonaryForKey:WebApi_DataSend_Other] lzNSStringForKey:WebApi_DataSend_Other_Operate] forKey:@"dataSendOther"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FavoritesParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_Section, favoritesDict);
    });
}

/**
 *  获取下一页收藏记录(类型)
 *  @param dataDict
 */
-(void)parseFavoritesSectionType:(NSMutableDictionary *)dataDict{
    NSMutableArray *favoritesInfo  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *allFavoritesArr=[NSMutableArray array];
    for(int i=0;i<favoritesInfo.count;i++){
        
        NSDictionary *favoritesDic=[favoritesInfo objectAtIndex:i];
        
        FavoritesModel *favoritesModel=[[FavoritesModel alloc]init];
        [favoritesModel serializationWithDictionary:favoritesDic];
        
        [allFavoritesArr addObject:favoritesModel];
        
    }
    NSDictionary *param=[dataDict objectForKey:WebApi_DataSend_Get];
    NSString *lastkey=[param objectForKey:@"lastkey"];
    if([lastkey isEqualToString:@"0"]){
        [[FavoritesDAL shareInstance]deleteAllDidCollectionFile];
    }
    
    [[FavoritesDAL shareInstance] addDataWithFavoriteArray:allFavoritesArr];
//    NSString *type=[param objectForKey:@"type"];
    NSMutableDictionary *favoritesDict=[NSMutableDictionary dictionary];
    [favoritesDict setObject:lastkey forKey:@"lastkey"];
    [favoritesDict setObject:allFavoritesArr forKey:@"allFavoritesAll"];
    [favoritesDict setObject:[[dataDict lzNSDictonaryForKey:WebApi_DataSend_Other] lzNSStringForKey:WebApi_DataSend_Other_Operate] forKey:@"dataSendOther"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FavoritesParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_Section_Type, favoritesDict);
    });
}

/**
 *  获取搜索收藏记录
 *  @param dataDict
 */
-(void)parseFavoritesSearch:(NSMutableDictionary *)dataDict{
    NSMutableArray *favoritesInfo  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSDictionary *param=[dataDict objectForKey:WebApi_DataSend_Get];
    NSMutableArray *allFavoritesArr=[NSMutableArray array];
    for(int i=0;i<favoritesInfo.count;i++){
        
        NSDictionary *favoritesDic=[favoritesInfo objectAtIndex:i];
        
        FavoritesModel *favoritesModel=[[FavoritesModel alloc]init];
        [favoritesModel serializationWithDictionary:favoritesDic];
        [allFavoritesArr addObject:favoritesModel];
        
    }
    [[FavoritesDAL shareInstance] addDataWithFavoriteArray:allFavoritesArr];
    NSMutableDictionary *favoritesDict=[NSMutableDictionary dictionary];
    NSString *lastkey=[param objectForKey:@"lastkey"];
    [favoritesDict setObject:lastkey forKey:@"lastkey"];
    [favoritesDict setObject:allFavoritesArr forKey:@"allFavoritesAll"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FavoritesParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_Search, favoritesDict);
    });

}

/**
 *  获取搜索收藏记录(类型)
 *  @param dataDict
 */
-(void)parseFavoritesSearchType:(NSMutableDictionary *)dataDict{
    NSMutableArray *favoritesInfo  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *allFavoritesArr=[NSMutableArray array];
    NSDictionary *param=[dataDict objectForKey:WebApi_DataSend_Get];
    for(int i=0;i<favoritesInfo.count;i++){
        
        NSDictionary *favoritesDic=[favoritesInfo objectAtIndex:i];
        
        FavoritesModel *favoritesModel=[[FavoritesModel alloc]init];
        [favoritesModel serializationWithDictionary:favoritesDic];
        [allFavoritesArr addObject:favoritesModel];
        
    }
    [[FavoritesDAL shareInstance] addDataWithFavoriteArray:allFavoritesArr];
    NSMutableDictionary *favoritesDict=[NSMutableDictionary dictionary];
    NSString *lastkey=[param objectForKey:@"lastkey"];
    [favoritesDict setObject:lastkey forKey:@"lastkey"];
    [favoritesDict setObject:allFavoritesArr forKey:@"allFavoritesAll"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FavoritesParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_Search_Type, favoritesDict);
    });
}

/**
 *  获取下一页搜索收藏记录
 *  @param dataDict
 */
-(void)parseFavoritesSearchNext:(NSMutableDictionary *)dataDict{
    NSMutableArray *favoritesInfo  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *allFavoritesArr=[NSMutableArray array];
    for(int i=0;i<favoritesInfo.count;i++){
        
        NSDictionary *favoritesDic=[favoritesInfo objectAtIndex:i];
        
        FavoritesModel *favoritesModel=[[FavoritesModel alloc]init];
        [favoritesModel serializationWithDictionary:favoritesDic];
        [allFavoritesArr addObject:favoritesModel];
        
    }
    [[FavoritesDAL shareInstance] addDataWithFavoriteArray:allFavoritesArr];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FavoritesParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_Search_Next, allFavoritesArr);
    });
}

/**
 *  获取收藏类型
 *  @param dataDict
 */
-(void)parseFavoritesGetType:(NSMutableDictionary *)dataDict{
    FavoriteTypeModel *favoriteTypeModel;
    
    NSMutableDictionary *allFavoriteTypeDic;
    
    NSMutableArray *allFavoriteTypeArr=[[NSMutableArray alloc]init];
    NSMutableDictionary *favoriteTypeDic  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    for (NSString *favkey in favoriteTypeDic.allKeys) {
//        allFavoriteTypeDic=[[NSMutableDictionary alloc]init];
        favoriteTypeModel=[[FavoriteTypeModel alloc]init];
        allFavoriteTypeDic=[favoriteTypeDic objectForKey:favkey];
        [favoriteTypeModel serializationWithDictionary:allFavoriteTypeDic];
        
        [allFavoriteTypeArr addObject:favoriteTypeModel];
        
    }
    [[FavoriteTypeDAL shareInstance] deleteAllData];
    [[FavoriteTypeDAL shareInstance] addDataWithFavoriteTypeModel:allFavoriteTypeArr];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FavoritesParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_GetType, dataDict);
    });
}

/**
 *  获取收藏记录
 *  @param dataDict
 */
-(void)parseV2GetFavorites:(NSMutableDictionary *)dataDict{
    NSMutableArray *favoritesInfo  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *allFavoritesArr=[NSMutableArray array];
    for(int i=0;i<favoritesInfo.count;i++){
        
        NSDictionary *favoritesDic=[favoritesInfo objectAtIndex:i];
        
        FavoritesModel *favoritesModel=[[FavoritesModel alloc]init];
        [favoritesModel serializationWithDictionary:favoritesDic];
        
        [allFavoritesArr addObject:favoritesModel];
        
    }
    NSDictionary *param=[dataDict objectForKey:WebApi_DataSend_Post];
    NSString *lastkey=[param lzNSStringForKey:@"lastkey"];
    NSInteger state = [LZFormat Safe2Int32:[param objectForKey:@"state"]];
    NSString *type = [param lzNSStringForKey:@"type"];
    NSString *condition = [param lzNSStringForKey:@"condition"];
    if([NSString isNullOrEmpty:lastkey] && [NSString isNullOrEmpty:condition]){
        [[FavoritesDAL shareInstance]deleAllFavoritesWithByType:state];
    }
    
    [[FavoritesDAL shareInstance] addDataWithFavoriteArray:allFavoritesArr];
    
    
    NSMutableDictionary *favoritesDict=[NSMutableDictionary dictionary];
    [favoritesDict setObject:lastkey forKey:@"lastkey"];
    [favoritesDict setObject:[NSNumber numberWithInteger:state] forKey:@"state"];
    [favoritesDict setObject:type forKey:@"type"];
    if(![NSString isNullOrEmpty:condition])[favoritesDict setObject:condition forKey:@"condition"];
    [favoritesDict setObject:allFavoritesArr forKey:@"allFavoritesAll"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FavoritesParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_V2GetFavorites, favoritesDict);
    });
}




#pragma mark -
#pragma mark - 解析数据(服务器返回的ErrorCode非0)

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic{
    
}



@end
