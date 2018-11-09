//
//  LZFMDatabaseQueue.m
//  LeadingCloud
//
//  Created by wchMac on 15/11/30.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabaseQueue.h"
#import "FMDatabaseQueue.h"
#import "AppUtils.h"

@implementation LZFMDatabaseQueue

static LZFMDatabaseQueue *instance = nil;
static LZFMDatabaseQueue *instanceForError = nil;

+(void)setInstanceToNil
{
//    instance = nil;
    [LZUserDataManager saveDBGuidTag:[LZUtils CreateGUID]];
}

/**
 *  静态数据区 只有程序退出时 才会被系统回收
 *
 *  @return LZFMDatabaseQueue实例
 */
+(LZFMDatabaseQueue *)shareInstance:(NSString *)dbPath isEncryption:(BOOL)isEncryption type:(NSString *)type
{
//    if([type isEqualToString:LeadingCloudError_Type]){
//        if (instanceForError == nil || [AppUtils CheckIsRestInstance:instanceForError.instanceUserIDTag guidTag:instanceForError.instanceGUIDTag]) {
//            instanceForError = [[LZFMDatabaseQueue alloc] init:dbPath isEncryption:isEncryption];
//        }
//        return instanceForError;
//    } else {
    @synchronized(self) {
        if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
            instance = [[LZFMDatabaseQueue alloc] init:dbPath isEncryption:isEncryption];
        }
    }
        return instance;
//    }
}

- (instancetype)init:(NSString *)dbPath isEncryption:(BOOL)isEncryption
{
    _instanceUserIDTag = [AppUtils GetCurrentUserID];
    _instanceGUIDTag = [LZUserDataManager getDBGuidTag];
    
    self = [super init];
    if (self) {
        DDLogVerbose(@"创建了新的数据库查询队列");
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath isEncryption:isEncryption];
    }
    return self;
}

@end
