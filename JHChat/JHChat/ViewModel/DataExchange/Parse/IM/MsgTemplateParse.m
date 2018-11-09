//
//  MsgTemplateParse.m
//  LeadingCloud
//
//  Created by dfl on 16/8/10.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-08-10
 Version: 1.0
 Description: 消息模板
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MsgTemplateParse.h"
#import "ImMsgTemplateDAL.h"
#import "ImVersionTemplateDAL.h"
#import "NSObject+JsonSerial.h"
#import "NSDictionary+DicSerial.h"
#import "NSString+SerialToDic.h"
#import "SysApiVersionDAL.h"
#import "ErrorDAL.h"

@implementation MsgTemplateParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(MsgTemplateParse *)shareInstance{
    static MsgTemplateParse *instance = nil;
    if (instance == nil) {
        instance = [[MsgTemplateParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic objectForKey:WebApi_Route];
    /* 获取消息模板的集合 */
    if([route isEqualToString:WebApi_MsgTemplate_GetTemplate]){
        [self parseMsgTemplateGetTemplate:dataDic];
    }
}

/**
 *  获取消息模板的集合
 */
-(void)parseMsgTemplateGetTemplate:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *dataDict  = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSString *codeStr = @"";
    /* 解析消息模板数据 */
    NSDictionary *msgtemplate = [dataDict lzNSDictonaryForKey:@"msgtemplate"];
    
    NSMutableArray *msgTemplateArr = [[NSMutableArray alloc] init];
    for (NSString *keys in [msgtemplate allKeys]) {
        NSDictionary *lzdataDic=[msgtemplate lzNSDictonaryForKey:keys];
        if([lzdataDic count]>0){
            ImMsgTemplateModel *imMsgTemplate=[[ImMsgTemplateModel alloc]init];
            [imMsgTemplate serializationWithDictionary:lzdataDic];
            imMsgTemplate.templates=[lzdataDic lzNSStringForKey:@"template"];
//            NSDictionary *dic = @{@"templatetype":[NSNumber numberWithInt:-1]};
//            imMsgTemplate.templates=[dic dicSerial];
            
            if (![NSString isNullOrEmpty:imMsgTemplate.templates]) {
                CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
                [model serialization:imMsgTemplate.templates];
                NSInteger templatetype = model.templatetype;
                if (templatetype == -1) {
                    codeStr = [codeStr stringByAppendingString:[NSString stringWithFormat:@"'%@',",imMsgTemplate.code]];
                }
            }
            [msgTemplateArr addObject:imMsgTemplate];
        }
    }
    if (![NSString isNullOrEmpty:codeStr]) {
        /* 将字符串首尾的单引号去掉 */
        NSRange rang = {1,[codeStr length]-3};
        codeStr = [codeStr substringWithRange:rang];
    }
    /* 将不需要展示的模板保存起来 */
    [LZUserDataManager saveCodeStr:codeStr];
    
    /* 插入数据 */
    [[ImMsgTemplateDAL shareInstance] deleteAllData];
    [[ImMsgTemplateDAL shareInstance] addDataWithImMsgTemplateArray:msgTemplateArr];
    
    NSString *tvidStr = @"";
    /* 解析消息模板版本数据 */
    NSDictionary *versiontemplate = [dataDict lzNSDictonaryForKey:@"verisiontemplate"];
    NSMutableArray *versionTemplateArr = [[NSMutableArray alloc] init];
    for (NSString *keys in [versiontemplate allKeys]) {
        NSDictionary *lzdataDic=[versiontemplate lzNSDictonaryForKey:keys];
        if([lzdataDic count]>0){
            ImVersionTemplateModel *imVersionTemplate=[[ImVersionTemplateModel alloc] init];
            [imVersionTemplate serializationWithDictionary:lzdataDic];
            imVersionTemplate.templates=[lzdataDic lzNSStringForKey:@"template"];
            imVersionTemplate.replaceparams = @"";
            imVersionTemplate.linktemplate = [lzdataDic lzNSStringForKey:@"linktemplate"];
            imVersionTemplate.linkreplaceparams = [[lzdataDic lzNSDictonaryForKey:@"linkreplaceparams"] dicSerial];
            /* 过滤不需要显示的模板 */
            if ([NSString isNullOrEmpty:imVersionTemplate.templates]) {
//                tvidStr = [tvidStr stringByAppendingString:[NSString stringWithFormat:@",%@.",imVersionTemplate.tvid]];
            } else {
                CommonTemplateModel *model = [[CommonTemplateModel alloc] init];
                [model serialization:imVersionTemplate.templates];
                NSInteger templatetype = model.templatetype;
                if (templatetype == -1) {
                    /* 处理类型为-1的情况，不需要显示 */
                    tvidStr = [tvidStr stringByAppendingString:[NSString stringWithFormat:@",%@.",imVersionTemplate.tvid]];
                }
            }
            [versionTemplateArr addObject:imVersionTemplate];
        }
    }
    /* 将tvidStr保存起来 */
    [LZUserDataManager saveTvidStr:tvidStr];
    
    /* 插入数据 */
    if(versionTemplateArr.count<=0){
        [[ErrorDAL shareInstance] addDataWithTitle:@"获取的VersionTemplate为空" data:[dataDic dicSerial] errortype:Error_Type_Eighteen];
    } else {
        [[ImVersionTemplateDAL shareInstance] deleteAllDataVersionTemplate];
        [[ImVersionTemplateDAL shareInstance] addDataWithImVersionTemplateArray:versionTemplateArr];
    }
    
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_msgtemplate_gettemplate_S2];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MsgTemplateParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
    });
}

#pragma mark -
#pragma mark - 解析数据(服务器返回的ErrorCode非0)

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic{
    
}

@end
