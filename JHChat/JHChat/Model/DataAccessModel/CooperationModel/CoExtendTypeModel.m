//
//  CoExtendTypeModel.m
//  LeadingCloud
//
//  Created by gjh on 17/3/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "CoExtendTypeModel.h"

@implementation CoExtendTypeModel

/* iOS配置信息 */
- (CommonTemplateModel *)controllerModel{
    CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
    [model serialization:self.config];
    return model;
}

@end
