//
//  FavoritesRemoveTempParse.m
//  LeadingCloud
//
//  Created by SY on 16/5/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "FavoritesRemoveTempParse.h"
#import "FavoritesDAL.h"
@implementation FavoritesRemoveTempParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(FavoritesRemoveTempParse *)shareInstance{
    static FavoritesRemoveTempParse *instance = nil;
    if (instance == nil) {
        instance = [[FavoritesRemoveTempParse alloc] init];
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
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    /* 移除收藏,单个 */
    if ([handlertype isEqualToString:Handler_Favorites_Remove_Single]) {
        isSendReport = [self parseRemoveSingle:dataDic];
        
    }
    /* 移除收藏,多个 */
    else if ([handlertype isEqualToString:Handler_Favorites_Remove_Multiple]) {
        isSendReport = [self parseRemoveMultiple:dataDic];
    }
    /* 移除收藏,一类 */
    else if ([handlertype isEqualToString:Handler_Favorites_Remove_Type]) {
        isSendReport = [self parseRemoveType:dataDic];
    }
    /* 移除收藏,全部 */
    else if ([handlertype isEqualToString:Handler_Favorites_Remove_All]) {
        isSendReport = [self parseRemoveAll:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

/**
 * 移除收藏,单个
 */
-(BOOL)parseRemoveSingle:(NSMutableDictionary*)dataDic {
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    // 通过objectid删除库
    [[FavoritesDAL shareInstance] deleteDidCollectionFile:[body objectForKey:@"objectid"]];
    
    NSString *type = [body lzNSStringForKey:@"type"];
    NSString *appcode = [body lzNSStringForKey:@"appcode"];

    if (type && [type isEqualToString:FavourittesType_Post] && appcode && [appcode isEqualToString:FavourittesType_Post]) {
        
        NSString *pid = [body objectForKey:@"objectid"];
        
        NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",@"0",@"isFaVorist", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __block FavoritesRemoveTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Post_Collection, sendDict);
        });

    }
    
    if (type && [type isEqualToString:FavourittesType_Task]&& appcode && [appcode isEqualToString:FavourittesType_Task]) {
        
        NSString *taskid = [body objectForKey:@"objectid"];
        NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:taskid,@"tid",@"0",@"isFaVorist", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __block FavoritesRemoveTempParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Task_Collection, sendDict);
 
        });
        
    }

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshMoreCollectionVC=YES;
//        if (type && [type isEqualToString:FavoritesType_Resource]&&appcode && [appcode isEqualToString:@"clouddisk"]) {

        __block FavoritesRemoveTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Favorites_Notice_RemoveSingle, body);
		NSString *state = [body objectForKey:@"state"];
		if ([state intValue]==1) {
			EVENT_PUBLISH_WITHDATA(service, EventBus_PostRoot_Refresh_Not, nil);
			
		}
//        }
    });
    return YES;
}

/**
 * 移除收藏,多个
 */
-(BOOL)parseRemoveMultiple:(NSMutableDictionary*)dataDic {
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    //     在主线程中发送通知
    dispatch_async(dispatch_get_main_queue(), ^{
        __block FavoritesRemoveTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Favorites_Notice_RemoveMultiple, body);
        self.appDelegate.lzGlobalVariable.isNeedRefreshMoreCollectionVC=YES;
    });
    return YES;
}

/**
 * 移除收藏,一类
 */
-(BOOL)parseRemoveType:(NSMutableDictionary*)dataDic {
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshMoreCollectionVC=YES;
        __block FavoritesRemoveTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Favorites_Notice_RemoveType, body);
    });
    return YES;
}

/**
 * 移除收藏,全部
 */
-(BOOL)parseRemoveAll:(NSMutableDictionary*)dataDic {
//    NSDictionary *body=[dataDic lzNSDictonaryForKey:@"body"];
//    [[FavoritesDAL shareInstance]deleteAllDidCollectionFile];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshMoreCollectionVC=YES;
        __block FavoritesRemoveTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Favorites_Notice_RemoveAll, nil);
    });
    return YES;
}

@end
