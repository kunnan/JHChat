//
//  AliyunViewModel.h
//  LeadingCloud
//
//  Created by SY on 2017/6/22.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "BaseViewModel.h"
@class RemotelyServerModel;
@class RemotelyAccountModel;
typedef void(^GetRemotelyServerInfo)(NSArray *serverInfo);
typedef void(^GetRemotelyAccountModel)(RemotelyAccountModel *accountModel); //获取远程文件服务器账号
typedef void(^GetRemotelyFileids)(NSArray *fileids);
typedef void(^GetRemotelyServerSuccess)(RemotelyServerModel *server,RemotelyAccountModel *acountModel);

@interface AliyunViewModel : BaseViewModel



+(void)getAliyunServerInfo:(GetRemotelyServerSuccess)successfulData;
+(RemotelyServerModel*)getAliyunServer;
+(RemotelyAccountModel*)getAcountModelFormLocal;
-(void)sendApiGetRemotelyServerAll:(GetRemotelyServerInfo)getServerBlock;

-(void)sendApiGetRemotelyAcountModel:(NSString*)rfsid getAcountBlock:(GetRemotelyAccountModel)getAcount;

-(void)sendApiGetFileidswithSuccessBlock:(GetRemotelyFileids)getfildis;
/**
 获取阿里云账号时间间隔
 
 @return 分钟
 */
-(NSInteger)getAliyunAccountDateInterval;
-(BOOL)aliyunAccountIsOverTime;
/**
 上传时处理即将过期的fileids
 
 @return 没过期的fileids
 */
-(NSMutableArray*)aliyunFileidsDelOverTimerfileids;


@end
