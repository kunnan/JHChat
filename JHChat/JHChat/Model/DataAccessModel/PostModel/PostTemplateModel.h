//
//  PostTemplateModel.h
//  LeadingCloud
//
//  Created by wang on 16/7/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-07-28
 Version: 1.0
 Description: 动态模板模型
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/
#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface PostTemplateModel : NSObject

@property(nonatomic,strong)NSString *tmcode;

@property(nonatomic,strong)NSString *tvid;
//版本信息
@property(nonatomic,strong)NSString *version;
@property(nonatomic,strong)NSDictionary *templateDic;


@end
