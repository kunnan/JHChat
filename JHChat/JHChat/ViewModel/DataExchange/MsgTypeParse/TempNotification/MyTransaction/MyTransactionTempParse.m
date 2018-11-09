//
//  MyTransactionTempParse.m
//  LeadingCloud
//
//  Created by wang on 16/11/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "MyTransactionTempParse.h"
#import "CooperationpendingModel.h"

@implementation MyTransactionTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MyTransactionTempParse *)shareInstance{
    static MyTransactionTempParse *instance = nil;
    if (instance == nil) {
        instance = [[MyTransactionTempParse alloc] init];
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
    /* 添加事务 */
    if([handlertype isEqualToString:Handler_MyTransaction_Add]){
        
        isSendReport = [self addMyTransaction:dataDic];
        
    }
    /* 更新事务 */
    else if ([handlertype isEqualToString:Handler_MyTransaction_Update]){
        
        isSendReport = [self updateMyTransaction:dataDic];

    }
    /* 删除事务 */
    else if ([handlertype isEqualToString:Handler_MyTransaction_Delete]){
        
        isSendReport = [self deleteMyTransaction:dataDic];

    }

    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}


/* 添加事务 */
- (BOOL)addMyTransaction:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:body,@"body", nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MyTransactionTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Not_TranSaction_Change, dict);
    });
    
    return YES;
}
/* 更新事务 */
- (BOOL)updateMyTransaction:(NSMutableDictionary*)dataDic{

    NSDictionary *body = [dataDic objectForKey:@"body"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:body,@"body", nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MyTransactionTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Not_TranSaction_Change, dict);
    });
    return YES;

}
/* 删除事务 */
- (BOOL)deleteMyTransaction:(NSMutableDictionary*)dataDic{
    
    
    NSDictionary *body = [dataDic objectForKey:@"body"];
    
//    NSString *businessid = [body objectForKey:@"businessid"];
//    
//    NSString *ttid = [body objectForKey:@"ttid"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MyTransactionTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Not_TranSaction_Delete, body);
    });

    
    return YES;
    
}
@end
