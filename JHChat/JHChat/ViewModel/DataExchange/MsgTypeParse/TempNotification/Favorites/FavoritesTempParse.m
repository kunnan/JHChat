//
//  FavoritesTempParse.m
//  LeadingCloud
//
//  Created by SY on 16/5/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "FavoritesTempParse.h"
#import "FavoritesAddTempParse.h"
#import "FavoritesRemoveTempParse.h"
@implementation FavoritesTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(FavoritesTempParse *)shareInstance{
    static FavoritesTempParse *instance = nil;
    if (instance == nil) {
        instance = [[FavoritesTempParse alloc] init];
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
    NSString *secondModel = [[HandlerTypeUtil shareInstance] getSecondModel:[dataDic objectForKey:@"handlertype"]];
    
    BOOL isSendReport = NO;
    /* 添加收藏 */
    if([secondModel isEqualToString:Handler_Favorites_Add]){
        isSendReport = [[FavoritesAddTempParse shareInstance] parse:dataDic];
    }
    /* 移除收藏 */
    else if ([secondModel isEqualToString:Handler_Favorites_Remove]){
        isSendReport = [[FavoritesRemoveTempParse shareInstance] parse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}
@end
