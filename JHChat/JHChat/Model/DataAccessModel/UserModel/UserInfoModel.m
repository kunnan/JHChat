//
//  UserInfoModel.m
//  LeadingCloud
//
//  Created by dfl on 16/6/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-06-30
 Version: 1.0
 Description: 用户详细信息表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "UserInfoModel.h"

@implementation UserInfoModel

-(id)init{
    self=[super init];
    if (self) {
        
        self.cotainfojson=[NSDictionary dictionary];
    }
    return self;
}

@end
