//
//  RemotelyAccountModel.h
//  LeadingCloud
//
//  Created by SY on 2017/6/23.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemotelyAccountModel : NSObject

/**
 账号
 */
@property (nonatomic, strong) NSString *accesskey;

/**
 密码
 */
@property (nonatomic, strong) NSString *accesskeysecret;

/**
 token
 */
@property (nonatomic, strong) NSString *securitytoken;

/**
 有效时间
 */
@property (nonatomic, strong) NSDate *expiration;

/**
 文件ids
 */
@property (nonatomic, strong) NSArray *fileids;
@end
