//
//  PostTagTempParse.m
//  LeadingCloud
//
//  Created by wang on 16/8/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "PostTagTempParse.h"
#import "CooperationDynamicModel.h"

@implementation PostTagTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostTagTempParse *)shareInstance{
    static PostTagTempParse *instance = nil;
    if (instance == nil) {
        instance = [[PostTagTempParse alloc] init];
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
//    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
//    BOOL isSendReport = NO;
    NSDictionary *body = [dataDic objectForKey:@"body"];
    //机构ID
    NSString *orgid = [body objectForKey:@"orgid"];
    //动态ID
    NSString *pid = [body objectForKey:@"pid"];
    
    //  NSString *praiseid = [body objectForKey:@"praiseid"];
    
        NSString *oid=[[[LZUserDataManager readCurrentUserInfo] objectForKey:@"notificaton"] objectForKey:@"selectoid"];
    //
        //如果是当前企业 处理
        if (orgid && [orgid isEqualToString:oid]) {
    
            [[CooperationDynamicModel shareInstance]GetReadSinglePost:pid];
    
        }else{
    
          //  [[PostDAL shareInstance]delePostReplyID:pid Rekatedpid:relatedpid];
        }
    
    return true;
}


@end
