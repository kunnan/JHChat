//
//  CoProjectModsModel.m
//  LeadingCloud
//
//  Created by dfl on 16/10/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   16/10/28.
 Version: 1.0
 Description: 项目模块
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "CoProjectModsModel.h"

@implementation CoProjectModsModel

/* iOS配置信息 */
- (CommonTemplateModel *)controllerModel{
    CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
    [model serialization:self.controller];
    return model;
}

@end
