//
//  PCLoginTempParse.m
//  LeadingCloud
//
//  Created by gjh on 2017/10/10.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "PCLoginTempParse.h"

@implementation PCLoginTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PCLoginTempParse *)shareInstance{
    static PCLoginTempParse *instance = nil;
    if (instance == nil) {
        instance = [[PCLoginTempParse alloc] init];
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
    
    /* PC端登录 */
    if([handlertype hasSuffix:Handler_Message_StatusMsg_PCLoginIn]){
        isSendReport = [self parsePCLoginIn:dataDic];
    }
    /* PC端退出 */
    else if ([handlertype hasSuffix:Handler_Message_StatusMsg_PCLoginOut]) {
        isSendReport = [self parsePCLoginOut:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时通知:%@",dataDic);
    }
    
    return isSendReport;
}


/**
 *  PC端登录
 */
-(BOOL)parsePCLoginIn:(NSMutableDictionary *)dataDic{
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    NSNumber *state = [body lzNSNumberForKey:@"state"];
    if (state.integerValue == 1) {
        self.appDelegate.lzGlobalVariable.pcLoginInStatus = PCLoginInStatusInLineNoNotice;
    } else if (state.integerValue == 2) {
        self.appDelegate.lzGlobalVariable.pcLoginInStatus = PCLoginInStatusInLineAndNotice;
    } else if (state.integerValue == 0) {
        self.appDelegate.lzGlobalVariable.pcLoginInStatus = PCLoginInStatusOutLine;
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootHeaderView = YES;
    });
    
    return YES;
}
/**
 *  PC端退出
 */
-(BOOL)parsePCLoginOut:(NSMutableDictionary *)dataDic{
    self.appDelegate.lzGlobalVariable.pcLoginInStatus = PCLoginInStatusOutLine;
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootHeaderView = YES;
    });
    
    return YES;
}

@end
