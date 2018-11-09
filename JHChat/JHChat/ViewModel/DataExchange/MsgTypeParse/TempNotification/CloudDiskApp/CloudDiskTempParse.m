//
//  CloudDiskDocumentTempParse.m
//  LeadingCloud
//
//  Created by SY on 16/5/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  SY
 Date：   2016-05-18
 Version: 1.0
 Description: 临时消息--云盘 二级
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "CloudDiskTempParse.h"
#import "CloudDiskDocumentTempParse.h"
#import "CloudDiskShareTempParse.h"
#import "CloudDiskRecycleTempParse.h"
@implementation CloudDiskTempParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CloudDiskTempParse *)shareInstance{
    static CloudDiskTempParse *instance = nil;
    if (instance == nil) {
        instance = [[CloudDiskTempParse alloc] init];
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
    /* 云盘文件  */
    if([secondModel isEqualToString:Handler_CloudDiskApp_Normal]){
        isSendReport = [[CloudDiskDocumentTempParse shareInstance] parse:dataDic];;
    }
    /* 分享 */
    else if ([secondModel isEqualToString:Handler_CloudDiskApp_Share]) {
        isSendReport = [[CloudDiskShareTempParse shareInstance] parse:dataDic];
    }
    /* 回收站 */
    else if ([secondModel isEqualToString:Handler_CloudDiskApp_Recycle]) {
        isSendReport = [[CloudDiskRecycleTempParse shareInstance] parse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
   
}

@end
