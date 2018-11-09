//
//  RemindParse.m
//  LeadingCloud
//
//  Created by gjh on 2017/7/11.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "RemindParse.h"
#import "RemindModel.h"

@implementation RemindParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+ (RemindParse *)shareInstance {
    static RemindParse *instance = nil;
    if (instance == nil) {
        instance = [[RemindParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析webapi请求的数据
- (void)parse:(NSMutableDictionary *)dataDic {
    NSString *route = [dataDic lzNSStringForKey:WebApi_Route];
    
    if ([route isEqualToString:WebApi_Remind_GetRemindList]) {
        [self parseGetRemindList:dataDic];
    }
}

- (void)parseGetRemindList:(NSMutableDictionary *)dataDic {
    NSMutableArray *dataArray  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSDictionary *dataDict in dataArray) {
        RemindModel *model = [[RemindModel alloc] init];
        model.rid = [dataDict lzNSStringForKey:@"rid"];
        model.uid = [dataDict lzNSStringForKey:@"uid"];
        model.count = [LZFormat Safe2Int32:[dataDict objectForKey:@"count"]];
        model.rtname = [dataDict lzNSStringForKey:@"rtname"];
        model.lastremindcontent = [dataDict lzNSStringForKey:@"lastremindcontent"];
        model.lastreminddate = [LZFormat String2Date:[dataDict lzNSStringForKey:@"lastreminddate"]];
        model.rtcode = [dataDict lzNSStringForKey:@"rtcode"];
        model.rticon = [dataDict lzNSStringForKey:@"rticon"];
        model.isread = [LZFormat Safe2Int32:[dataDict objectForKey:@"isread"]];
        model.oeid = [dataDict lzNSStringForKey:@"oeid"];
        [modelArr addObject:model];
    }
    /* 保存到库中 */
}
#pragma mark - 解析数据(服务器返回的ErrorCode非0)

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
- (void)parseErrorDataContext:(NSMutableDictionary *)dataDic {
    
}

@end
