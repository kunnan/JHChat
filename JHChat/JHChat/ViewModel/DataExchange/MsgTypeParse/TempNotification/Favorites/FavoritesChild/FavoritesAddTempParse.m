//
//  FavoritesAddTempParse.m
//  LeadingCloud
//
//  Created by SY on 16/5/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "FavoritesAddTempParse.h"
#import "NetDiskIndexViewModel.h"
#import "CoTaskDAL.h"

@interface FavoritesAddTempParse ()
{
     NetDiskIndexViewModel *netDiskIndexViewModel;
}
@end

@implementation FavoritesAddTempParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(FavoritesAddTempParse *)shareInstance{
    static FavoritesAddTempParse *instance = nil;
    if (instance == nil) {
        instance = [[FavoritesAddTempParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    netDiskIndexViewModel = [[NetDiskIndexViewModel alloc] init];
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    /* 添加 */
    if ([handlertype isEqualToString:Handler_Favorites_Add_Single]) {
        isSendReport = [self addFavorites:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    return isSendReport;
}
// 添加收藏（type:(post:动态 task:任务 resources:资源 3:项目 4:事务)）
-(BOOL)addFavorites:(NSMutableDictionary*)dataDic {
    
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    
    NSString *type = [body lzNSStringForKey:@"type"];
    NSString *appCode = [body lzNSStringForKey:@"appcode"];
    
    if (type && [type isEqualToString:FavourittesType_Post]&&appCode && [appCode isEqualToString:FavourittesType_Post]) {
        
        NSString *pid = [body objectForKey:@"objectid"];
        
        NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",@"1",@"isFaVorist", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __block FavoritesAddTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Post_Collection, sendDict);
        });
        
    }
    
    if(type && [type isEqualToString:FavourittesType_Task]&&appCode && [appCode isEqualToString:FavourittesType_Task]){
        
        NSString *taskid = [body objectForKey:@"objectid"];
        NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:taskid,@"tid",@"1",@"isFaVorist", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __block FavoritesAddTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Task_Collection, sendDict);

        });

    }
	
	
    // 获取收藏文件的信息 EventBus_App_Collection_NetDisk_CollectionInfo
//    [netDiskIndexViewModel getFavoriteInfoWithObjectid:[body objectForKey:@"objectid"] type:[body objectForKey:@"type"]];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
//        if (type && [type isEqualToString:FavoritesType_Resource]&&appCode && [appCode isEqualToString:@"clouddisk"]) {
            __block FavoritesAddTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Favorites_Notice_AddFavorite, body);
//        }
        self.appDelegate.lzGlobalVariable.isNeedRefreshMoreCollectionVC=YES;
		NSString *state = [body objectForKey:@"state"];
		if ([state intValue]==1) {
			EVENT_PUBLISH_WITHDATA(service, EventBus_PostRoot_Refresh_Not, nil);
			
		}

    });
    return YES;
}
@end
