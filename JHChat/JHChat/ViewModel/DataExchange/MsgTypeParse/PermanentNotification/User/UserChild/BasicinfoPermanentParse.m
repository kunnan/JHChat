//
//  BasicinfoPermanentParse.m
//  LeadingCloud
//
//  Created by dfl on 16/5/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-05-16
 Version: 1.0
 Description: 持久消息--用户--用户头像
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "BasicinfoPermanentParse.h"
#import "SDWebImageManager.h"
#import "FilePathUtil.h"

@implementation BasicinfoPermanentParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(BasicinfoPermanentParse *)shareInstance{
    static BasicinfoPermanentParse *instance = nil;
    if (instance == nil) {
        instance = [[BasicinfoPermanentParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析持久通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    NSString *handlertype = [dataDic lzNSStringForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    
    /* 其它设备已读状态消息 */
    if( [handlertype isEqualToString:Handler_User_Basicinfo_ChangeFace]){
        isSendReport = [self parseUserAccountChangeFace:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---持久消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

/**
 *  收到头像更改后通知数据
 */
-(BOOL)parseUserAccountChangeFace:(NSMutableDictionary *)dataDic{
    //头像更改后通知处理
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *face=[body lzNSStringForKey:@"face"];
    NSString *uid=[body lzNSStringForKey:@"uid"];
    
    /* 删除内存缓存 */
    NSString *faceImgName = [NSString stringWithFormat:@"%@.jpg",face];
    SDWebImageManager *sharedSmallManager = [SDWebImageManager sharedManager:[FilePathUtil getFaceIconImageSmallDicAbsolutePath]];
    [sharedSmallManager.imageCache removeImageForKey:faceImgName];
    SDWebImageManager *sharedManager = [SDWebImageManager sharedManager:[FilePathUtil getFaceIconImageDicAbsolutePath]];
    [sharedManager.imageCache removeImageForKey:faceImgName];
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSDictionary *dic = uid;
        
        __block BasicinfoPermanentParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_Account_ChangeFace, uid);
    });
    
    
    return YES;
}

@end
