//
//  CommonTemplateModel.m
//  LeadingCloud
//
//  Created by wchMac on 16/9/14.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CommonTemplateModel.h"
#import "NSObject+JsonSerial.h"
#import "NSString+IsNullOrEmpty.h"

@implementation CommonTemplateModel

/* 本地Conroller配置信息 */
- (CommonTemplatePlatModel *)platModel{
    CommonTemplatePlatModel *model = [[CommonTemplatePlatModel alloc] init];
    if ([self.platinfo isKindOfClass:[NSDictionary class]]) {
        [model serializationWithDictionary:self.platinfo];
    } else {
        [model serialization:self.platinfo];
    }
    return model;
}

/* webview配置信息 */
- (CommonTemplateWebViewModel *)webviewModel{
    CommonTemplateWebViewModel *model = [[CommonTemplateWebViewModel alloc] init];
    if ([self.webviewinfo isKindOfClass:[NSDictionary class]]) {
        [model serializationWithDictionary:self.webviewinfo];
    } else {
        [model serialization:self.webviewinfo];
    }
    return model;
}

/* iOS配置信息 */
- (CommonTemplateFrameworkModel *)frameworkModel{
    CommonTemplateFrameworkModel *model = [[CommonTemplateFrameworkModel alloc] init];
    if ([self.frameworkinfo isKindOfClass:[NSDictionary class]]) {
        [model serializationWithDictionary:self.frameworkinfo];
    } else {
        [model serialization:self.frameworkinfo];
    }
    return model;
}

/* 独立app配置信息 */
- (CommonTemplateInstallAppModel *)installappModel{
    CommonTemplateInstallAppModel *model = [[CommonTemplateInstallAppModel alloc] init];
    if ([self.installappinfo isKindOfClass:[NSDictionary class]]) {
        [model serializationWithDictionary:self.installappinfo];
    } else {
        [model serialization:self.installappinfo];
    }
    return model;
}

/* VPN配置信息 */
- (CommonTemplateVpnWebModel *)vpnwebModel{
    CommonTemplateVpnWebModel *model = [[CommonTemplateVpnWebModel alloc] init];
    if ([self.vpnwebinfo isKindOfClass:[NSDictionary class]]) {
        [model serializationWithDictionary:self.vpnwebinfo];
    } else {
        [model serialization:self.installappinfo];
    }
    return model;
}

@end


/**
 *  平台原生ViewController
 */
@implementation CommonTemplatePlatModel

-(NSString *)formname{
    return [NSString isNullOrEmpty:_formname] ? _controllername : _formname;
}

@end


/**
 *  H5页面
 */
@implementation CommonTemplateWebViewModel
@end


/**
 *  动态链接库
 */
@implementation CommonTemplateFrameworkModel
@end


/**
 *  独立app
 */
@implementation CommonTemplateInstallAppModel
@end

/**
 *  打开VPN
 */
@implementation CommonTemplateVpnWebModel
@end

