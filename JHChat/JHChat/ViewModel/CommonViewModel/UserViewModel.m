//
//  UserViewModel.m
//  LeadingCloud
//
//  Created by wchMac on 16/6/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "UserViewModel.h"
#import "UserModel.h"
#import "ModuleServerUtil.h"
#import "NSString+SerialToDic.h"
#import "UserDAL.h"
#import "ImGroupDAL.h"
#import "ImGroupModel.h"
#import "ImGroupUserDAL.h"
#import "ImGroupUserModel.h"
#import "NSString+IsNullOrEmpty.h"
#import "AppUtils.h"

@implementation UserViewModel

/**
 *  同步请求网络，获取用户信息
 */
-(UserModel *)getUserInfoAsynMode:(NSString *)uid{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/%@",[ModuleServerUtil GetServerWithModule:Modules_Default],[WebApi_CloudUser_LoadUser stringByReplacingOccurrencesOfString:@"{tokenid}" withString:self.appDelegate.lzservice.tokenId]];
    NSURL *url = [AppUtils urlToNsUrl:strUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"=%@",uid];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *strResult = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    DDLogVerbose(@"使用同步方式获取用户信息：%@",strResult);
    
    UserModel *userModel = nil;
    /* 处理数据 */
    NSDictionary *dataDic = [strResult seriaToDic];
    
    NSMutableDictionary *userDic  = [dataDic lzNSMutableDictionaryForKey:@"DataContext"];
    NSMutableDictionary *errorCode  = [dataDic lzNSMutableDictionaryForKey:@"ErrorCode"];
    
    
    if([[errorCode lzNSStringForKey:@"Code"] isEqualToString:@"0"]
       && ![NSString isNullOrEmpty:[userDic lzNSStringForKey:@"uid"]]){
        userModel = [[UserModel alloc] init];
        [userModel serializationWithDictionary:userDic];
        
        [[UserDAL shareInstance] addUserModel:userModel];
    }
        
    return userModel;
}

/**
 *  同步请求网络，获取群信息
 */
-(ImGroupModel *)getImGroupInfoAsynMode:(NSString *)groupid{
    
    NSString *webapi = [WebApi_ImGroup_GetGroupInfoByPages stringByReplacingOccurrencesOfString:@"{tokenid}" withString:self.appDelegate.lzservice.tokenId];
    NSString *strUrl = [NSString stringWithFormat:@"%@/%@",[ModuleServerUtil GetServerWithModule:Modules_Message],webapi];
    NSURL *url = [AppUtils urlToNsUrl:strUrl];
    /* 同步GET请求 */
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *strResult = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    /* 同步POST请求 */
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"groupid=%@&pagesize=%d",groupid, 200];//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *strResult = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    DDLogVerbose(@"使用同步方式获取群信息：%@",strResult);
    
    ImGroupModel *imGroupModel = nil;
    /* 处理数据 */
    NSDictionary *dataDic = [strResult seriaToDic];
    
    NSDictionary *groupInfoDic  = [dataDic lzNSDictonaryForKey:@"DataContext"];
    NSMutableDictionary *errorCode  = [dataDic lzNSMutableDictionaryForKey:@"ErrorCode"];
    
    if([[errorCode lzNSStringForKey:@"Code"] isEqualToString:@"0"]){

        NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
        
        imGroupModel = [[ImGroupModel alloc] init];
        [imGroupModel serializationWithDictionary:groupInfoDic];
        
        /* 解析群组人员信息 */
        NSArray *groupusers = [groupInfoDic lzNSArrayForKey:@"groupuser"];
        for(int j=0;j<groupusers.count;j++){
            NSDictionary *dataUserDic = [groupusers objectAtIndex:j];
            
            ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
            [imGroupUserName serializationWithDictionary:dataUserDic];
            
            [allImGroupUserArr addObject:imGroupUserName];
        }
        
        imGroupModel.isnottemp = 1;
        if(imGroupModel.imtype==Chat_ContactType_Main_ChatGroup){
            imGroupModel.isshowinlist = imGroupModel.isshow;
        } else {
            imGroupModel.isshowinlist = 0;
        }
        
        /* 删除此群组，避免人员出错 */
        [[ImGroupDAL shareInstance] deleteGroupWithIgid:imGroupModel.igid isDeleteImRecent:NO];
        
        [[ImGroupDAL shareInstance] addImGroupModel:imGroupModel];
        [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allImGroupUserArr];
    }
    
    return imGroupModel;
}


@end
