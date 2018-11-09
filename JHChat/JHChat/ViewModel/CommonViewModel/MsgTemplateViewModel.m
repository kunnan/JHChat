//
//  MsgTemplateViewModel.m
//  LeadingCloud
//
//  Created by wchMac on 16/8/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "MsgTemplateViewModel.h"
#import "LZBaseAppDelegate.h"

@implementation MsgTemplateViewModel

/**
 *  根据Code获取对应的模板
 */
+(ImMsgTemplateModel *)getMsgTemplateModel:(NSString *)code{
    ImMsgTemplateModel *model = nil; //[[ImMsgTemplateDAL shareInstance] getImMsgTemplateModelWithCode:code];
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    NSMutableDictionary *msgTemplates = [appDelegate.lzGlobalVariable.msgTemplateDic mutableCopy];
    if(msgTemplates && [[msgTemplates allKeys] containsObject:code]){
        model = [msgTemplates objectForKey:code];
    } else {
        if(!msgTemplates){
            msgTemplates = [[NSMutableDictionary alloc] init];
        }
        model = [[ImMsgTemplateDAL shareInstance] getImMsgTemplateModelWithCode:code];
        if(model!=nil){
            [msgTemplates setObject:model forKey:code];
            appDelegate.lzGlobalVariable.msgTemplateDic = msgTemplates;
        }
    }
    
    return model;
}

@end
