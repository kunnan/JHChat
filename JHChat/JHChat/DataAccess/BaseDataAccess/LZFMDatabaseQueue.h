//
//  LZFMDatabaseQueue.h
//  LeadingCloud
//
//  Created by wchMac on 15/11/30.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;
@interface LZFMDatabaseQueue : NSObject

@property(nonatomic,strong) NSString *instanceUserIDTag;
@property(nonatomic,strong) NSString *instanceGUIDTag;

@property(nonatomic,strong) FMDatabaseQueue *dbQueue;

+(void)setInstanceToNil;

/**
 *  静态数据区 只有程序退出时 才会被系统回收
 *
 *  @return LZFMDatabaseQueue实例
 */
+(LZFMDatabaseQueue *)shareInstance:(NSString *)dbPath isEncryption:(BOOL)isEncryption type:(NSString *)type;

//- (instancetype)init:(NSString *)dbPath isEncryption:(BOOL)isEncryption;

@end
