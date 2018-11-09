//
//  CoTransactionTypeModel.m
//  LeadingCloud
//
//  Created by wang on 16/10/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoTransactionTypeModel.h"

@implementation CoTransactionTypeModel
/* iOS配置信息 */
- (CommonTemplateModel *)templateModel{
    CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
    [model serialization:self.handler];
    return model;
}

@end
