//
//  AliyunViewModel.m
//  LeadingCloud
//
//  Created by SY on 2017/6/22.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "AliyunViewModel.h"
#import "RemotelyServerModel.h"
#import "RemotelyAccountModel.h"
#import "AliyunFileidsDAL.h"
#import "AliyunRemotrlyServerDAL.h"
#import "AliyunRemotelyAccountDAL.h"
#import "AppDateUtil.h"


@implementation AliyunViewModel

 RemotelyServerModel *aliyunServerModel;

+(void)getAliyunServerInfo:(GetRemotelyServerSuccess)successfulData{
    /* 请求阿里云服务器 */
    GetRemotelyServerInfo getServer = ^(NSArray *serverinfo) {
        NSLog(@"成功获取远程服务器");
        for (RemotelyServerModel *serverModel  in serverinfo) {
            // 阿里云服务器 [[dic objectForKey:@"activationstatus"] integerValue] == 1 &&
            if ([serverModel.rfstype isEqualToString:@"oss"]) {
                
                GetRemotelyAccountModel getAcount = ^(RemotelyAccountModel *acountModel) {
                    successfulData(serverModel,acountModel);
                    NSLog(@"成功获取账号信息");
                };
                [[[AliyunViewModel alloc] init] sendApiGetRemotelyAcountModel:serverModel.rfsid getAcountBlock:getAcount];
            }
        }
    };
    [[AliyunViewModel new] sendApiGetRemotelyServerAll:getServer];
}
+(RemotelyServerModel*)getAliyunServer {
    
   aliyunServerModel = [[AliyunRemotrlyServerDAL shareInstance] getServerModelWithRfsType:@"oss"];
//    if (aliyunServerModel == nil) {
//        [self getAliyunServerInfo:^(RemotelyServerModel *server2, RemotelyAccountModel *acountModel) {
//            aliyunServerModel = server2;
//            // server = server2;
//            // server = [[AliyunRemotrlyServerDAL shareInstance]getServerModelWithRfsType:@"oss"];
//            //待修改，@sy
//            NSLog(@"请求了阿里云服务器!!!!");
//        }];
//    }
    return aliyunServerModel ;

}

+(RemotelyAccountModel*)getAcountModelFormLocal {
    return [[AliyunRemotelyAccountDAL shareInstance] getAccountModel];
}
-(void)sendApiGetRemotelyServerAll:(GetRemotelyServerInfo )getServerBlock {
    NSMutableDictionary *otherDic = [[NSMutableDictionary alloc] init];
    if (getServerBlock) {
        [otherDic setValue:getServerBlock forKey:@"SuccessBlock"];
        
    }
    [otherDic setValue:WebApi_DataSend_Other_SE_NotShowAll forKey:WebApi_DataSend_Other_ShowError];
    [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_RemotelyServer
                                              routePath:WebApi_GetRemotelyServerModelAll
                                           moduleServer:Modules_FileManager
                                                getData:nil
                                              otherData:otherDic];
    
}
-(void)sendApiGetRemotelyAcountModel:(NSString *)rfsid getAcountBlock:(GetRemotelyAccountModel)getAcount {
    NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
    [getData setValue:rfsid forKey:@"rfsid"];
    
    NSMutableDictionary *otherDic = [[NSMutableDictionary alloc] init];
    if (getAcount) {
        [otherDic setValue:getAcount forKey:@"SuccessBlock"];
    }
    [otherDic setValue:WebApi_DataSend_Other_SE_NotShowAll forKey:WebApi_DataSend_Other_ShowError];
    [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_RemotelyServer
                                         routePath:WebApi_GetRemotelyAccountModel
                                      moduleServer:Modules_FileManager
                                           getData:getData
                                         otherData:otherDic];
}

/**
 获取fileids

 @param getfildis getfildis description
 */
-(void)sendApiGetFileidswithSuccessBlock:(GetRemotelyFileids)getfildis {
    
    NSMutableDictionary *otherDic = [[NSMutableDictionary alloc] init];
    if (getfildis) {
        [otherDic setValue:getfildis forKey:@"SuccessBlock"];
    }
    [self.appDelegate.lzservice sendToServerForGet:WebApi_RemotelyServer
                                         routePath:WebApi_CreateFileid
                                      moduleServer:Modules_FileManager
                                           getData:nil
                                         otherData:otherDic];
    
    
}

/**
 上传时处理即将过期的fileids

 @return 没过期的fileids
 */
-(NSMutableArray*)aliyunFileidsDelOverTimerfileids {
    NSMutableArray *fileids = [[AliyunFileidsDAL shareInstance] getFileids];
    for (int i = 0; i < fileids.count; i++) {
        NSDate *fileidDate = [[AliyunFileidsDAL shareInstance] getFileidsCreatdateWithFileid:[fileids objectAtIndex:i]];
       NSInteger minte = [AppDateUtil IntervalMinutes:fileidDate endDate:[AppDateUtil GetCurrentDate]];
        if (minte >(60 * 11)) {
            [[AliyunFileidsDAL shareInstance]deleteFileidWithFileid:[fileids objectAtIndex:i]];
        }
        else {
            //是不是可以结束循环呢
            break;
        }

    }
    return fileids;
}
/**
 获取阿里云账号时间间隔

 @return 分钟
 */
-(NSInteger)getAliyunAccountDateInterval {
    RemotelyAccountModel *accountModel = [AliyunViewModel getAcountModelFormLocal];
    NSLog(@"阿里云账号时间间隔：%ld",[AppDateUtil IntervalMinutes:accountModel.expiration endDate:[AppDateUtil GetCurrentDate]]);
    return  [AppDateUtil IntervalMinutes:accountModel.expiration endDate:[AppDateUtil GetCurrentDate]];
}
-(BOOL)aliyunAccountIsOverTime {  // 50
    if ([self getAliyunAccountDateInterval] >50) {
        return YES;
    }
    return NO;
}
@end
