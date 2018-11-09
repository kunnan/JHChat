//
//  CloudDiskFavoritesParse.m
//  LeadingCloud
//
//  Created by SY on 16/3/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CloudDiskFavoritesParse.h"
#import "FavoritesModel.h"
#import "ResModel.h"
#import "FavoritesDAL.h"
#import "ResDAL.h"
@interface CloudDiskFavoritesParse()<EventSyncPublisher>

@end
@implementation CloudDiskFavoritesParse

+(CloudDiskFavoritesParse*)shareInstance {
    
    static CloudDiskFavoritesParse *instance = nil;
    if (instance == nil) {
        instance = [[CloudDiskFavoritesParse alloc] init];
    }
    return instance;
}
/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    /* 收藏文件 */
    if ([route isEqualToString:WebApi_CloudDiskFile_V2_AddFavoritesFile]) {
        [self parseFavoritesFile:dataDic];
    }
    else if ([route isEqualToString:WebApi_CloudDiskAppOrganization_FavorList]){
        [self parseCollectionList:dataDic];
    }
    /* 取消收藏 */
    else if ([route isEqualToString:WebApi_CloudDiskFile_V2_CancelCollection]) {
        [self parseCancelCollection:dataDic];
    }
    /* 获取收藏文件信息 */
    else if ([route isEqualToString:WebApi_CloudDiskFavorite_GetFavoriteInfo]) {
        [self parseFavoriteInfo:dataDic];
    }
    
}
/* 收藏文件 */
-(void)parseFavoritesFile:(NSMutableDictionary*)dataDic{
    
    NSString *collectionId = [dataDic lzNSStringForKey:WebApi_DataContext];
    
    NSDictionary *dic = [dataDic objectForKey:WebApi_DataSend_Post];
    
    FavoritesModel *collectionModel = [[FavoritesModel alloc] init];
    [collectionModel serializationWithDictionary:dic];
    collectionModel.favoriteid = collectionId;
    collectionModel.uid = [dic objectForKey:@"releaseuid"];
    
    // 把资源表里的ifavoriteDic更新掉
    [[ResDAL shareInstance] updateFavoriteFileWithIsfavorite:@"1" objectid:collectionModel.objectid];
    
    [[FavoritesDAL shareInstance] addDataWithFavoriteModel:collectionModel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskFavoritesParse * service = self;
        // 传过去已收藏的文件
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Collection_NetDiskIndex_AddCollection, collectionModel);
    });
}
/* 收藏列表 */
-(void)parseCollectionList:(NSMutableDictionary*)dataDic
{
    NSArray *contextData = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSMutableArray *allCollection = [[NSMutableArray alloc] init];
    NSMutableArray *allFileArr = [[NSMutableArray alloc] init];
    //NSArray *dataArray = [contextData objectForKey:@"List"];
    for (int i = 0 ; i < [contextData count]; i++) {
        NSDictionary *dic = [contextData objectAtIndex:i];
        NSMutableDictionary *favoriteDic = [dic lzNSMutableDictionaryForKey:@"resourcefavorite"];
        NSInteger isFavorite = [[favoriteDic objectForKey:@"isfavorite"] integerValue];
        // 得到文件 一定要把已收藏的文件model添加到文件数据库 才行
        ResModel *fileModel = [[ResModel alloc] init];
        [fileModel serializationWithDictionary:dic];
        fileModel.isfavorite = 1;
        fileModel.descript = [dic objectForKey:@"description"];
        fileModel.isfavorite = isFavorite;
        fileModel.favoritesDic = [NSMutableDictionary dictionaryWithDictionary:favoriteDic];
        
        /* 收藏的文件 */
        id  collectionFile = [dic objectForKey:@"resourcefavorite"];
        FavoritesModel *collectionModel = [[FavoritesModel alloc] init];
        // 有可能为空
        if ([collectionFile isKindOfClass:[NSDictionary class]]) {
            [collectionModel serializationWithDictionary:collectionFile];
            collectionModel.descript = [collectionFile objectForKey:@"description"];
            collectionModel.size = fileModel.size;
            collectionModel.exptype = fileModel.exptype;
            [allCollection addObject:collectionModel];
        }
        [allFileArr addObject:fileModel];
    }
    if (self.appDelegate.lzGlobalVariable.isDelNetFavoriteLocal) {
        [[FavoritesDAL shareInstance] deleteResCollectionFile:FavoritesType_Resource];
        self.appDelegate.lzGlobalVariable.isDelNetFavoriteLocal = NO;
    }
    
    // 添加到数据库
    [[FavoritesDAL shareInstance] addDataWithFavoriteArray:allCollection];
    // 文件也要加库
    [[ResDAL shareInstance] addDataWithArray:allFileArr];
    
    
    NSMutableDictionary *sendData = [dataDic objectForKey:WebApi_DataSend_Post];
    NSDictionary *sendDic  =[sendData lzNSDictonaryForKey:@"sbpmodel"];
    NSInteger perTableViewCount = ((NSNumber *)[sendDic objectForKey:@"currentnumber"]).integerValue;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:perTableViewCount] forKeyedSubscript:@"pre"];
    [dic setObject:[NSNumber numberWithInteger:allCollection.count] forKeyedSubscript:@"add"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskFavoritesParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Collection_NetDisk_CollectionList, dic);
    });
}
/* 取消收藏 */
-(void)parseCancelCollection:(NSMutableDictionary*)dataDic{
    
    NSMutableDictionary *dic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Get];
    
    NSString *collectionID = [dic objectForKey:@"objectid"];
    [[ResDAL shareInstance] updateFavoriteFileWithIsfavorite:@"0" objectid:collectionID];
    // 通过objectid删除库
    [[FavoritesDAL shareInstance] deleteDidCollectionFile:collectionID];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskFavoritesParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Collection_NetDisk_CancelCollection, collectionID);
    });
}
// 收藏信息
- (void)parseFavoriteInfo:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    FavoritesModel *collectionModel = [[FavoritesModel alloc] init];
    [collectionModel serializationWithDictionary:contextDic];
    collectionModel.uid = [contextDic objectForKey:@"releaseuid"];
    collectionModel.isfavorite = 1;
    [[FavoritesDAL shareInstance] addDataWithFavoriteModel:collectionModel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CloudDiskFavoritesParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Collection_NetDisk_CollectionInfo, nil);
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
