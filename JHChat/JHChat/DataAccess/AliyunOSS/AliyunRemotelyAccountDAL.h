//
//  AliyunRemotelyAccountDAL.h
//  LeadingCloud
//
//  Created by SY on 2017/6/29.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
@class RemotelyAccountModel;
@interface AliyunRemotelyAccountDAL : LZFMDatabase
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AliyunRemotelyAccountDAL *)shareInstance;
/**
 *  创建表
 */
-(void)createAliaccountTableIfNotExists;
#pragma mark - 添加数据

-(void)addAliAccountModel:(RemotelyAccountModel*)accountModel;
-(void)deleteAccount;
#pragma mark - 查询数据

/**
 查询相应服务器model
 
 @param rfstype oss：阿里云  lzy:理正云
 @return
 */
-(RemotelyAccountModel*)getAccountModel;
@end
