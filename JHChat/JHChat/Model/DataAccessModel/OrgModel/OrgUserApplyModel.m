//
//  OrgUserApplyModel.m
//  LeadingCloud
//
//  Created by dfl on 16/5/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-05-30
 Version: 1.0
 Description: 用户申请加入组织成员表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "OrgUserApplyModel.h"

@implementation OrgUserApplyModel

-(void)setApplytime:(NSDate *)applytime{
    if([applytime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)applytime;
        _applytime = [LZFormat String2Date:strDate];
    }
    else {
        _applytime = applytime;
    }
}

-(void)setActiontime:(NSDate *)actiontime{
    if([actiontime isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)actiontime;
        _actiontime = [LZFormat String2Date:strDate];
    }
    else {
        _actiontime = actiontime;
    }
}

@end
