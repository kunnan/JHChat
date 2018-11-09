//
//  CommonTemplateTypeModel.h
//  LeadingCloud
//
//  Created by wang on 2017/7/31.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface CommonTemplateTypeModel : NSObject

//基础链接配置主键
@property (nonatomic, strong) NSString *blcid;
//应用编码
@property (nonatomic, strong) NSString *appcode;
//aliasname
@property (nonatomic, strong) NSString *aliasname;
//编码
@property (nonatomic, strong) NSString *code;
//配置数据
@property (nonatomic, strong) NSString *config;
//name
@property (nonatomic, strong) NSString *name;


@end
