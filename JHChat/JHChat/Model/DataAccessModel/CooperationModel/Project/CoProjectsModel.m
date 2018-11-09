//
//  CoProjectsModel.m
//  LeadingCloud
//
//  Created by SY on 16/10/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoProjectsModel.h"

@implementation CoProjectsModel

-(void)setCreatedate:(NSDate *)createdate {
    if([createdate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)createdate;
        _createdate = [LZFormat String2Date:strDate];
    }
    else {
        _createdate = createdate;
    }
}

/* iOS配置信息 */
- (CommonTemplateModel *)controllerModel{
    CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
    [model serialization:self.customopenjsondata];
    return model;
}

@end
