//
//  BusinessPermanentParse.m
//  LeadingCloud
//
//  Created by wchMac on 2018/5/3.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "BusinessPermanentParse.h"
#import "PersonRemindViewController.h"
#import "NSString+SerialToDic.h"
#import "ImChatLogDAL.h"
#import "ImChatLogBodyModel.h"
#import "ImChatLogModel.h"
#import "NSDictionary+DicSerial.h"

@implementation BusinessPermanentParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+ (BusinessPermanentParse *)shareInstance {
    static BusinessPermanentParse *instance = nil;
    if (instance == nil) {
        instance = [[BusinessPermanentParse alloc] init];
    }
    return instance;
}

- (BOOL)parse:(NSMutableDictionary *)dataDic {
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    if ([handlertype isEqualToString:Handler_BusinessMessage_UpdateBusinessStatus]) {
        
        NSDictionary *bodyDic = [dataDic lzNSDictonaryForKey:@"body"];
        NSDictionary *statusDic = [[bodyDic lzNSStringForKey:@"status"] seriaToDic];
        NSString *msgid = [bodyDic lzNSStringForKey:@"msgid"];
        ImChatLogModel *dbModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:msgid];
        NSDictionary *body = [dbModel.body seriaToDic];
        NSMutableDictionary *tmpBody = [NSMutableDictionary dictionaryWithDictionary:body];
        [tmpBody setValue:statusDic forKey:@"businessstatus"];
        
        /* 更新数据库 */
        [[ImChatLogDAL shareInstance] updateBody:[tmpBody dicSerial] withMsgId:msgid];
        /* 更新消息高度 */
        [[ImChatLogDAL shareInstance] updateHeightForRow:@"" withMsgId:msgid];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            dbModel.body = [tmpBody dicSerial];
            /* 更新消息状态 */
            __block BusinessPermanentParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_UpdateMsgStatus, dbModel);
        });
        return YES;
    }
    return NO;
}

@end
