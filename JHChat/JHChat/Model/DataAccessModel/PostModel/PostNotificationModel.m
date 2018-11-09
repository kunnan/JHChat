//
//  PostNotificationModel.m
//  LeadingCloud
//
//  Created by wang on 16/3/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-03-23
 Version: 1.0
 Description: 动态提醒模型
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/
#import "PostNotificationModel.h"

@implementation PostNotificationModel

-(id)init{
    
    if (self) {
        
        self.notificationparamsdic=[NSDictionary dictionary];
    }
    return self;
}

-(void)setSenddatetime:(NSDate *)senddatetime{
    if([senddatetime isKindOfClass:[NSString class]]){
        NSString *strUpdateDate = (NSString *)senddatetime;
        _senddatetime = [LZFormat String2Date:strUpdateDate];
    }
    else {
        _senddatetime = senddatetime;
    }
    
}




@end
