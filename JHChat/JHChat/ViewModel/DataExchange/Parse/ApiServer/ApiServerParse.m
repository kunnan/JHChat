//
//  ApiServerParse.m
//  LeadingCloud
//
//  Created by dfl on 16/4/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-04-19
 Version: 1.0
 Description: 服务器配置
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ApiServerParse.h"
#import "AppBaseServerDAL.h"
#import "NSObject+JsonSerial.h"
#import "SysApiVersionDAL.h"

@implementation ApiServerParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ApiServerParse *)shareInstance{
    static ApiServerParse *instance = nil;
    if (instance == nil) {
        instance = [[ApiServerParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic
{
    NSString *route = [dataDic lzNSStringForKey:WebApi_Route];
    NSString *bundleid=[[NSBundle mainBundle] bundleIdentifier];
    NSString *apiServer=[NSString stringWithFormat:@"%@/%@",WebApi_ApiServer_Mobile_Version,bundleid];
    //根据路由进行数据解析分发
    if([route isEqualToString:apiServer]){
        [self parseApiServerMobileVersion:dataDic];
    }
    //获取基础服务器配置
    else if([route isEqualToString:WebApi_ApiServer_GetBaseServer]){
        [self parseApiServerGetBaseServer:dataDic];
    }
}

/**
 *  解析新版本信息
 */
-(void)parseApiServerMobileVersion:(NSMutableDictionary *)dataDic{
//    NSMutableArray *dataArray  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
}


/**
 *  获取基础服务器配置
 */
-(void)parseApiServerGetBaseServer:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *dataContext  = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    NSMutableArray *appBaseSerArr = [NSMutableArray array];
    
    for(NSString *key in dataContext.allKeys){
        AppBaseServerModel *appBaseSerModel = [[AppBaseServerModel alloc]init];
        
        NSDictionary *dic = [dataContext lzNSDictonaryForKey:key];
        [appBaseSerModel serializationWithDictionary:dic];
        [appBaseSerArr addObject:appBaseSerModel];
    }
    [[AppBaseServerDAL shareInstance]deleteAllData];
    [[AppBaseServerDAL shareInstance]addAppBaseServerWithArray:appBaseSerArr];
    
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_apiserver_getbaseserver_S1];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ApiServerParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
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
