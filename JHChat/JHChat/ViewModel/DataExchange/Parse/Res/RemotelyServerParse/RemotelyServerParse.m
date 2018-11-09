//
//  RemotelyServerParse.m
//  LeadingCloud
//
//  Created by SY on 2017/6/22.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "RemotelyServerParse.h"
#import "AliyunViewModel.h"
#import "RemotelyAccountModel.h"
#import "RemotelyServerModel.h"
#import "NSObject+JsonSerial.h"
#import "AliyunRemotrlyServerDAL.h"
#import "AliyunRemotelyAccountDAL.h"
#import "AliyunFileidsDAL.h"
#import "AppDateUtil.h"
#import "SysApiVersionDAL.h"

@implementation RemotelyServerParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(RemotelyServerParse *)shareInstance{
    static RemotelyServerParse *instance = nil;
    if (instance == nil) {
        instance = [[RemotelyServerParse alloc] init];
    }
    return instance;
}
/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic{
   NSString *route = [dataDic objectForKey:WebApi_Route];
    if ([route isEqualToString:WebApi_GetRemotelyServerModelAll]) {
        [self parseRemotelyServeAll:dataDic];
    }
    else if ([route isEqualToString:WebApi_GetRemotelyAccountModel]) {
        [self parseAcountModel:dataDic];
    }
    else if ([route isEqualToString:WebApi_CreateFileid]) {
        [self parseGetFileids:dataDic];
    }
}
-(void)parseRemotelyServeAll:(NSMutableDictionary*)dataDic {
    NSArray *contextArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
    
    NSDictionary *blockDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
     NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in contextArr) {
        RemotelyServerModel *serverModel =[[RemotelyServerModel alloc] init];
        [serverModel serializationWithDictionary:dic];
        [array addObject:serverModel];
    }
    [[AliyunRemotrlyServerDAL shareInstance] deleteServer];
    [[AliyunRemotrlyServerDAL shareInstance] addDataWithArray:array];
   
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_filemanager_getremotelyservermodelall_S3];
    
    
    if( [[blockDic allKeys] containsObject:@"SuccessBlock"]){
        GetRemotelyServerInfo serverInfo = [blockDic objectForKey:@"SuccessBlock"];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (serverInfo) {
                serverInfo(array);
            }
           
        });
    }
}
-(void)parseAcountModel:(NSMutableDictionary*)dataDic {
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    
    NSDate *expiration =[AppDateUtil GetCurrentDate];

    RemotelyAccountModel *accountModel = [[RemotelyAccountModel alloc] init];
    [accountModel serializationWithDictionary:contextDic];
    accountModel.expiration = expiration;
    accountModel.fileids = [contextDic lzNSArrayForKey:@"fileids"];
    
    [[AliyunRemotelyAccountDAL shareInstance] deleteAccount];
    [[AliyunRemotelyAccountDAL shareInstance] addAliAccountModel:accountModel];
    
    // 设置全局变量
    self.appDelegate.lzGlobalVariable.aliyunAccountModel = (RemotelyAccountModel*)accountModel;
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"aliyun" object:accountModel];
    if ([[dataOther allKeys] containsObject:@"SuccessBlock"]) {
        GetRemotelyAccountModel account = [dataOther objectForKey:@"SuccessBlock"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (account) {
                account(accountModel);
            }
        });
    }

   
        /* 拿到所有的id 大于12小时的删除 */
    NSMutableArray *fileidarr = [[AliyunFileidsDAL shareInstance] getFileids];
    for (int i = 0; i < fileidarr.count; i++) {
        NSString *fileid = [fileidarr objectAtIndex:i];
        NSDate *fileData = [[AliyunFileidsDAL shareInstance] getFileidsCreatdateWithFileid:fileid];
        
        NSString *currentDate = [AppDateUtil GetCurrentDateForString];
        NSString *filedataStr = [LZFormat Date2String:fileData];
        NSInteger mint = [AppDateUtil IntervalMinutesForString:filedataStr endDate:currentDate];
        NSLog(@"Fileids时间差：%ld 时间：%@",mint,filedataStr);
        if (mint >(60 * 11)) {
            [[AliyunFileidsDAL shareInstance]deleteFileidWithFileid:fileid];
        }
        else {
            //是不是可以结束循环呢
            break;
        }
    }
    /* 添加最新的 */
    [[AliyunFileidsDAL shareInstance] addAliFileids:[NSMutableArray arrayWithArray:accountModel.fileids] withDate:expiration];
    
//    [[AliyunRemotelyAccountDAL shareInstance] deleteAccount];
//    [[AliyunRemotelyAccountDAL shareInstance] addAliAccountModel:accountModel];
//
//    // 设置全局变量
//    self.appDelegate.lzGlobalVariable.aliyunAccountModel = (RemotelyAccountModel*)accountModel;
    
//    // 处理以前的十个id
//    NSMutableArray *fileids = (NSMutableArray*)[LZUserDataManager readFileids];
//    if (fileids ==nil) {
//        fileids = [NSMutableArray array];
//    }
//    NSArray *newArr = [fileids arrayByAddingObjectsFromArray:accountModel.fileids];
//    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:newArr];
//    [LZUserDataManager saveFileidsWithArray:mutableArr];
    
    
}

-(void)parseGetFileids:(NSMutableDictionary*)dataDic {
    
    NSArray *fileids = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
   
    /* 添加最新的 */
    NSMutableArray *mutabelArr = [NSMutableArray arrayWithArray:fileids];
    [[AliyunFileidsDAL shareInstance] addAliFileids:mutabelArr withDate:[AppDateUtil GetCurrentDate]];
    
//    // 将请求的信息保存到沙盒
//    [LZUserDataManager saveFileidsWithArray:mutabelArr];
    
    if ([[dataOther allKeys] containsObject:@"SuccessBlock"]) {
        GetRemotelyFileids account = [dataOther objectForKey:@"SuccessBlock"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (account) {
                account(fileids);
            }
        });
    }

    
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
