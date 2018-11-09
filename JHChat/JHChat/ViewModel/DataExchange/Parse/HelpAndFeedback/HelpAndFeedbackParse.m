//
//  HelpAndFeedbackParse.m
//  LeadingCloud
//
//  Created by dfl on 16/7/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-07-04
 Version: 1.0
 Description: 帮助与反馈
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "HelpAndFeedbackParse.h"

@implementation HelpAndFeedbackParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(HelpAndFeedbackParse *)shareInstance{
    static HelpAndFeedbackParse *instance = nil;
    if (instance == nil) {
        instance = [[HelpAndFeedbackParse alloc] init];
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
    /* 吐槽 */
    if([route isEqualToString:WebApi_HelpAndFeedBack_FeedBack]){
        [self parseFeedBack:dataDic];
    }
    /* 帮助 */
    else if ([route isEqualToString:WebApi_HelpAndFeedBack_Help]){
        [self parseHelp:dataDic];
    }
}

/**
 *  吐槽
 *  @param dataDict
 */
-(void)parseFeedBack:(NSMutableDictionary *)dataDict{
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataS = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block HelpAndFeedbackParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_HelpAndFeedBack_FeedBack, dataS);
    });
}

/**
 *  帮助
 *  @param dataDict
 */
-(void)parseHelp:(NSMutableDictionary *)dataDict{
    NSArray *datacontext=[dataDict lzNSArrayForKey:WebApi_DataContext];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block HelpAndFeedbackParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_HelpAndFeedBack_Help, datacontext);
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
