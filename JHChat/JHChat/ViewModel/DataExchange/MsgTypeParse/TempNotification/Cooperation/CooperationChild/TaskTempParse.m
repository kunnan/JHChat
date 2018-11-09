//
//  TaskTempParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-05-04
 Version: 1.0
 Description: 临时消息--协作--任务
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "TaskTempParse.h"
#import "CoTaskDAL.h"
#import "CoTaskPhaseDAL.h"

@implementation TaskTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(TaskTempParse *)shareInstance{
    static TaskTempParse *instance = nil;
    if (instance == nil) {
        instance = [[TaskTempParse alloc] init];
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
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    
    /* 添加任务 */
    if([handlertype isEqualToString:Handler_Cooperation_Task_CreateTask]){
        //
        isSendReport = [self addTaskParse:dataDic];
    }
    else if ([handlertype isEqualToString:Handler_Cooperation_Task_SetName]){
        
        isSendReport = [self setTaskNameParse:dataDic];
    }
    else if ([handlertype isEqualToString:Handler_Cooperation_Task_SetState]){
       
        isSendReport = [self setTaskStateParse:dataDic];
    }
    else if ([handlertype isEqualToString:Handler_Cooperation_Task_SetLock]){
        
        isSendReport = [self setTaskLockParse:dataDic];
    }
    else if ([handlertype isEqualToString:Handler_Cooperation_Task_SetParent]){
        
        isSendReport = [self setTaskParentParse:dataDic];
    }
    else if ([handlertype isEqualToString:Handler_Cooperation_Task_SetPhaseadmin]){
        
        isSendReport = [self setPhaseadminParse:dataDic];
    }
    else if ([handlertype isEqualToString:Handler_Cooperation_Task_SetPhaseState]){
        
        isSendReport = [self setPhaseStateParse:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

//添加任务
- (BOOL)addTaskParse:(NSMutableDictionary*)dataDic{
    
    
    return YES;
}
//设置任务名称
- (BOOL)setTaskNameParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    NSString *cid = [body lzNSStringForKey:@"cid"];
    NSString *type = [body lzNSStringForKey:@"cooperationtype"];
    NSDictionary *data = [body lzNSDictonaryForKey:@"data"];
    NSString *name = [data lzNSStringForKey:@"name"];
    if (type && [type isEqualToString:@"task"]) {
        
        [[CoTaskDAL shareInstance]updateTaskNameTid:cid withName:name];
        __block TaskTempParse * service = self;
        NSDictionary *sendDict =[NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",name,@"name", nil];

        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Task_SetName, sendDict);
        });

    }
    return YES;
}

//设置任务锁
- (BOOL)setTaskStateParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    NSString *cid = [body lzNSStringForKey:@"cid"];
    NSString *type = [body lzNSStringForKey:@"cooperationtype"];
    NSDictionary *data = [body lzNSDictonaryForKey:@"data"];
    NSNumber *state = [data lzNSNumberForKey:@"state"];
    if (type && [type isEqualToString:@"task"]) {
        
        [[CoTaskDAL shareInstance]updateTaskStateTid:cid withState:[state integerValue]];
        __block TaskTempParse * service = self;
        NSDictionary *sendDict =[NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",state,@"state", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Task_SetState, sendDict);
        });
        
    }
 
    return YES;
}

//设置任务锁定
- (BOOL)setTaskLockParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    NSString *cid = [body lzNSStringForKey:@"cid"];
    NSString *type = [body lzNSStringForKey:@"cooperationtype"];
    NSDictionary *data = [body lzNSDictonaryForKey:@"data"];
    NSString *lockuser = [data lzNSStringForKey:@"lockuser"];
    if (type && [type isEqualToString:@"task"]) {
        
        NSNumber *lock;
        if (lockuser && [lockuser length]!=0) {
            lock = [NSNumber numberWithBool:YES];
        }else{
            lock = [NSNumber numberWithBool:NO];
        }
        [[CoTaskDAL shareInstance]updataTaskLock:cid LockUser:lockuser];
        //[[CoTaskDAL shareInstance]updateTaskStateTid:cid withState:[lock integerValue]];
        __block TaskTempParse * service = self;
        NSDictionary *sendDict =[NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",lock,@"lock",lockuser,@"lockuser", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Task_SetLock, sendDict);
        });
        
    }
    
    
    return YES;
}

//设置父任务
- (BOOL)setTaskParentParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    NSString *cid = [body lzNSStringForKey:@"cid"];
    NSString *type = [body lzNSStringForKey:@"cooperationtype"];
    NSDictionary *data = [body lzNSDictonaryForKey:@"data"];
    NSString *pid = [data lzNSStringForKey:@"parentid"];
    if (type && [type isEqualToString:@"task"]) {
        
        [[CoTaskDAL shareInstance]updataTaskParentTid:cid Pid:pid];
        __block TaskTempParse * service = self;
        NSDictionary *sendDict =[NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",pid,@"pid", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Task_SetParent, sendDict);
        });
        
    }

    return YES;
}

//设置节点管理员
- (BOOL)setPhaseadminParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    NSString *cid = [body lzNSStringForKey:@"cid"];
    NSString *type = [body lzNSStringForKey:@"cooperationtype"];
    NSDictionary *data = [body lzNSDictonaryForKey:@"data"];
    NSString *chief = [data lzNSStringForKey:@"chief"];
    NSString *phid = [data lzNSStringForKey:@"phid"];
    if (type && [type isEqualToString:@"task"]) {
        
        NSDictionary *cheifmem = [data lzNSDictonaryForKey:@"cheifmem"];
        NSString *face = [cheifmem lzNSStringForKey:@"face"];
        [[CoTaskPhaseDAL shareInstance]upDataTaskPhaseChief:chief TaskID:cid Phid:phid];
        __block TaskTempParse * service = self;
        NSDictionary *sendDict =[NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",phid,@"phid",chief,@"chief",face,@"face",nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Task_SetPhaseAdmin, sendDict);
        });
        
    }
    
    return YES;
}

//设置节点管理员
- (BOOL)setPhaseStateParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *body = [dataDic lzNSDictonaryForKey:@"body"];
    NSString *cid = [body lzNSStringForKey:@"cid"];
    NSString *type = [body lzNSStringForKey:@"cooperationtype"];
    NSDictionary *data = [body lzNSDictonaryForKey:@"data"];
    NSNumber *state = [data lzNSNumberForKey:@"state"];
    NSString *phid = [data lzNSStringForKey:@"phid"];
    if (type && [type isEqualToString:@"task"]) {
        
        [[CoTaskPhaseDAL shareInstance]upDataTaskPhaseState:[state integerValue] Activecount:1 TaskID:cid Phid:phid];
        __block TaskTempParse * service = self;
        NSDictionary *sendDict =[NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",phid,@"phid",state,@"state", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Task_SetPhaseState, sendDict);
        });
        
    }
    
    return YES;
}

@end
