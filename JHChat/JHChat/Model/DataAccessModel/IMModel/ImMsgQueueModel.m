//
//  ImMsgQueueModel.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-11
 Version: 1.0
 Description: 消息发送队列表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "ImMsgQueueModel.h"

@implementation ImMsgQueueModel

-(void)setCreatedatetime:(NSDate *)createdatetime{
    if([createdatetime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)createdatetime;
        _createdatetime = [LZFormat String2Date:strDate];
    }
    else {
        _createdatetime = createdatetime;
    }
}

-(void)setUpdatedatetime:(NSDate *)updatedatetime{
    if([updatedatetime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)updatedatetime;
        _updatedatetime = [LZFormat String2Date:strDate];
    }
    else {
        _updatedatetime = updatedatetime;
    }
}

@end
