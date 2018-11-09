//
//  OrgPermanentParse.m
//  LeadingCloud
//
//  Created by dfl on 16/8/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-08-25
 Version: 1.0
 Description: 持久消息--组织机构--组织管理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "OrgPermanentParse.h"
#import "OrgEnterPriseDAL.h"
#import "SDWebImageManager.h"
#import "FilePathUtil.h"

@implementation OrgPermanentParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgPermanentParse *)shareInstance{
    static OrgPermanentParse *instance = nil;
    if (instance == nil) {
        instance = [[OrgPermanentParse alloc] init];
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
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    
    /* 组织logo修改 */
    if( [handlertype isEqualToString:Handler_Organization_Org_UpdateEnterLogo]){
        isSendReport = [self parseOrganizationOrgUpdateEnterLogo:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---持久消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

/**
 *  组织logo修改
 */
-(BOOL)parseOrganizationOrgUpdateEnterLogo:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body = [dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *logo=[body lzNSStringForKey:@"logo"];
    NSString *oeid=[body lzNSStringForKey:@"oeid"];
    OrgEnterPriseModel *model=[[OrgEnterPriseDAL shareInstance]getEnterpriseByEId:oeid];
    /* 删除内存缓存 */
    NSString *faceImgName = [NSString stringWithFormat:@"%@.jpg",model.logo];
    SDWebImageManager *sharedSmallManager = [SDWebImageManager sharedManager:[FilePathUtil getOrganizationIconImageSmallDicAbsolutePath]];
    [sharedSmallManager.imageCache removeImageForKey:faceImgName];
    
    /* 删除消息列表，组织头像缓存 */
    SDWebImageManager *sharedSmallManagerForMsg = [SDWebImageManager sharedManager:[FilePathUtil getFaceIconImageSmallDicAbsolutePath]];
    [sharedSmallManagerForMsg.imageCache removeImageForKey:faceImgName];
    
    [[OrgEnterPriseDAL shareInstance]updateEnterpriseWithOEIdByLogo:oeid Logo:logo];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactRootVC2=YES;
//        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForPermanentNotice = YES;
    });
    
    return YES;
}


@end
