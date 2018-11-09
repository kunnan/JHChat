//
//  ImVersionTemplateModel.m
//  LeadingCloud
//
//  Created by wchMac on 16/8/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-08-16
 Version: 1.0
 Description: 消息模板版本表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "ImVersionTemplateModel.h"
#import "NSString+SerialToDic.h"

@implementation ImVersionTemplateModel
/* iOS配置信息 */
- (CommonTemplateModel *)templateModel{
    CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
    [model serialization:self.templates];
    return model;
}

/* iOS点击模板 */
- (CommonTemplateModel *)linkModel{
    CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
    [model serialization:self.linktemplate];
    return model;
}

@end



