//
//  CoExtendTypeModel.h
//  LeadingCloud
//
//  Created by gjh on 17/3/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "CommonTemplateModel.h"

@interface CoExtendTypeModel : NSObject

@property (nonatomic, copy) NSString *cetid;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *aliasname;

@property (nonatomic, copy) NSString *config;

@property (nonatomic, copy) NSString *des;

@property (nonatomic, copy) NSString *appcode;

/* iOS配置信息 */
@property(nonatomic,strong) CommonTemplateModel *controllerModel;

@end
