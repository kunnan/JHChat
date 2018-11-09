//
//  ErrorModel.m
//  LeadingCloud
//
//  Created by dfl on 16/4/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-04-15
 Version: 1.0
 Description: 请求WebAPI错误日志表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "ErrorModel.h"

@implementation ErrorModel

-(void)setErrordate:(NSDate *)errordate{
    if([_errordate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)_errordate;
        _errordate = [LZFormat String2Date:strDate];
    }
    else {
        _errordate = errordate;
    }
}

@end
