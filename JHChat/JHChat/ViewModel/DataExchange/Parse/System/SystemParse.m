//
//  SystemParse.m
//  LeadingCloud
//
//  Created by dfl on 17/4/21.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "SystemParse.h"

@implementation SystemParse


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(SystemParse *)shareInstance{
    static SystemParse *instance = nil;
    if (instance == nil) {
        instance = [[SystemParse alloc] init];
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
    //获取移动端短地址配置信息
    if([route isEqualToString:WebApi_System_GetMobiletrPath]){
        [self parseSystemGetMobiletrPath:dataDic];
    }

}

/**
 *  获取移动端短地址配置信息
 */
-(void)parseSystemGetMobiletrPath:(NSMutableDictionary *)dataDic{
    NSDictionary *dic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block SystemParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_System_GetMobiletrPath, dic);
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
