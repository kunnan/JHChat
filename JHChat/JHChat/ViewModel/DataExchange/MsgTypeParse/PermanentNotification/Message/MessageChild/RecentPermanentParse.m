//
//  RecentPermanentParse.m
//  LeadingCloud
//
//  Created by wchMac on 2017/10/10.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-24
 Version: 1.0
 Description: 最近联系人临时通知
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "RecentPermanentParse.h"
#import "ImRecentDAL.h"

@implementation RecentPermanentParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(RecentPermanentParse *)shareInstance{
    static RecentPermanentParse *instance = nil;
    if (instance == nil) {
        instance = [[RecentPermanentParse alloc] init];
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
    
    /* 另一个客户端删除了最近联系人 */
    if( [handlertype hasSuffix:Handler_Message_Recent_Remove]){
        isSendReport = [self parseImRecentRemove:dataDic];
    }    
    else if ([handlertype hasSuffix:Handler_Message_Recent_SetStick]) {
        isSendReport = [self parseSetStick:dataDic];
    }
    else if ([handlertype hasSuffix:Handler_Message_Recent_SetDisturb]) {
        isSendReport = [self parseSetDisturb:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---最近联系人临时通知:%@",dataDic);
    }
    
    return isSendReport;
}


/**
 *  另一个客户端删除了最近联系人
 */
-(BOOL)parseImRecentRemove:(NSMutableDictionary *)dataDic{
    NSString *contactid = [[dataDic objectForKey:@"body"] objectForKey:@"recentid"];
    [[ImRecentDAL shareInstance] updateIsDelContactid:[[NSMutableArray alloc] initWithObjects:contactid, nil]];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
//        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForPermanentNotice = YES;
    });
    
    return YES;
}

/**
 解析聊天会话置顶的通知
 */
- (BOOL)parseSetStick:(NSMutableDictionary *)dataDic {
    NSString *recentid = [[dataDic objectForKey:@"body"] objectForKey:@"recentid"];
    NSString *state = [[[dataDic objectForKey:@"body"] objectForKey:@"state"] stringValue];
    [[ImRecentDAL shareInstance] updateSetStick:recentid state:state];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
//        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForPermanentNotice = YES;
    });
    
    return YES;
}

/**
 解析聊天会话置顶的通知
 */
- (BOOL)parseSetDisturb:(NSMutableDictionary *)dataDic {
    NSString *recentid = [[dataDic objectForKey:@"body"] objectForKey:@"recentid"];
    NSString *state = [[[dataDic objectForKey:@"body"] objectForKey:@"state"] stringValue];
    [[ImRecentDAL shareInstance] updateSetIsOneDisturb:recentid state:state];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
//        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForPermanentNotice = YES;
    });
    
    return YES;
}
@end
