//
//  AppModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

/* iOS配置信息 */
- (CommonTemplateModel *)controllerModel{
    CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
    [model serialization:self.controller];
    return model;
}

@end
