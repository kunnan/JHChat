//
//  ErrorCodeUtil.h
//  LeadingCloud
//
//  Created by gjh on 16/5/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorCodeUtil : NSObject

@property(nonatomic,strong) NSMutableDictionary *errorCodeDic;

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ErrorCodeUtil *)shareInstance;

/**
 *  初始化ErrorCode数据
 */
-(void)initErrorCodeData;

/**
 *  从ErrorCode得到Message内容
 *
 *  @param errorCode 字典
 *
 *  @return 消息内容
 */
-(NSString *) getMessageFromErrorCode:(NSDictionary *) errorCode;
@end
