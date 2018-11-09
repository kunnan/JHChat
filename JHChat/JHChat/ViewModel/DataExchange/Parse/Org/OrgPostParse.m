//
//  OrgPostParse.m
//  LeadingCloud
//
//  Created by dfl on 16/11/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "OrgPostParse.h"
#import "OrgPostModel.h"
#import "NSObject+JsonSerial.h"
#import "OrgBasePostModel.h"

@implementation OrgPostParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgPostParse *)shareInstance{
    static OrgPostParse *instance = nil;
    if (instance == nil) {
        instance = [[OrgPostParse alloc] init];
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
    NSString *route = [dataDic objectForKey:WebApi_Route];
    /* 获取岗位列表 */
    if([route isEqualToString:Contact_WebAPI_GetOrgPostList]){
        [self parseGetOrgPostList:dataDic];
    }
    /* 获取企业下基准岗位（职务）列表 */
    else if ([route isEqualToString:Contact_WebAPI_GetOrgBaseList]){
        [self parseGetOrgBaseList:dataDic];
    }
    
}

#pragma mark - 解析数据

/**
 *  获取岗位列表
 */
-(void)parseGetOrgPostList:(NSMutableDictionary *)dataDict{
    
    NSArray *orgPostArr = [dataDict lzNSArrayForKey:WebApi_DataContext];
    NSDictionary *getDict=[dataDict objectForKey:WebApi_DataSend_Get];
    NSString *oid = [getDict lzNSStringForKey:@"oid"];
    
    NSMutableArray *newOrgPostArr = [NSMutableArray array];
    
    for(int i=0;i<orgPostArr.count;i++){
        NSDictionary *orgPostDic = [orgPostArr objectAtIndex:i];
        OrgPostModel *orgPostModel = [[OrgPostModel alloc]init];
        [orgPostModel serializationWithDictionary:orgPostDic];
        [newOrgPostArr addObject:orgPostModel];
    }
    
    NSMutableDictionary *orgpostDict=[NSMutableDictionary dictionary];
    [orgpostDict setObject:oid forKey:@"oid"];
    [orgpostDict setObject:newOrgPostArr forKey:@"orgpost"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgPostParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgPostList, orgpostDict);
    });
}

/**
 *  获取企业下基准岗位（职务）列表
 */
-(void)parseGetOrgBaseList:(NSMutableDictionary *)dataDict{
    NSArray *orgBasePostArr = [dataDict lzNSArrayForKey:WebApi_DataContext];
    NSMutableArray *newOrgBasePostArr = [NSMutableArray array];
    
    for(int i=0;i<orgBasePostArr.count;i++){
        NSDictionary *orgBasePostDic = [orgBasePostArr objectAtIndex:i];
        OrgBasePostModel *orgBasePostModel = [[OrgBasePostModel alloc]init];
        [orgBasePostModel serializationWithDictionary:orgBasePostDic];
        orgBasePostModel.obpid = [orgBasePostDic lzNSStringForKey:@"bpid"];
        [newOrgBasePostArr addObject:orgBasePostModel];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgPostParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgBaseList, newOrgBasePostArr);
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
