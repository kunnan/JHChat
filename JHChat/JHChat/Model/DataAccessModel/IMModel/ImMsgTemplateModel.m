//
//  ImMsgTemplateModel.m
//  LeadingCloud
//
//  Created by wchMac on 16/8/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  dfl
 Date：   2016-08-10
 Version: 1.0
 Description: 消息模板集合表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "ImMsgTemplateModel.h"

@implementation ImMsgTemplateModel

/* iOS配置信息 */
- (CommonTemplateModel *)templateModel{
    CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
    [model serialization:self.templates];
    return model;
}

@end
