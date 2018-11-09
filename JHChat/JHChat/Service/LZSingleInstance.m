//
//  LZSingleInstance.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/26.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-26
 Version: 1.0
 Description: 存储实例
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZSingleInstance.h"
#import "CooperationTaskFileViewController.h"
#import "AppNetDiskMyFileViewController.h"
#import "ChatViewController.h"
#import "AliyunOSS.h"
@implementation LZSingleInstance

- (instancetype)init {
    self = [super init];
    if (self) {
        self.chatDialogDictionary = [[NSMutableDictionary alloc] init];
        self.netDiskDictionary = [[NSMutableDictionary alloc] init];
        self.fileDownloadDictionary = [[NSMutableDictionary alloc] init];
        self.CooFileDictionary = [[NSMutableDictionary alloc] init];
        self.viewControllerArr = [NSMutableArray array];
        self.processPoolDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

/**
 *  移除指定的云盘实例
 *
 *  @param key 主键
 */
-(void)removeNetDiskInstance:(NSString *)key{
    if ([NSString isNullOrEmpty:key]) {
        return;
    }
    [self.netDiskDictionary removeObjectForKey:key];
}
/**
 *  移除指定的协作文件实例
 *
 *  @param key 主键
 */
-(void)removeCooFileInstance:(NSString *)key{
    if ([NSString isNullOrEmpty:key]) {
        return;
    }
    [self.CooFileDictionary removeObjectForKey:key];
    
}

/**
 *  移除文件下载实例
 *
 *  @param key 主键
 */
-(void)removeFileDownloadInstance:(NSString *)key{
    if (key == nil) {
        return;
    }
    [self.fileDownloadDictionary removeObjectForKey:key];
}

/**
 *  清除所有的缓存实例
 */
-(void)clearAll{

    /* 移除添加在window上的LZShareMenuView */
    for(NSString *dialogID in [self.chatDialogDictionary allKeys]){
        ChatViewController *chatViewController = [self.chatDialogDictionary objectForKey:dialogID];
        [chatViewController.lzShareMenuView removeFromSuperview];
    }
    
    [AliyunOSS setInstanceToNil];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.lzGlobalVariable.aliyunServerModel = nil;
    appDelegate.lzGlobalVariable.aliyunAccountModel = nil;
    appDelegate.lzGlobalVariable.msgTemplateDic = nil;
    appDelegate.lzGlobalVariable.messageRootVC = nil;
    
    [self.chatDialogDictionary removeAllObjects];
    [self.netDiskDictionary removeAllObjects];
    [self.fileDownloadDictionary removeAllObjects];
    [self.CooFileDictionary removeAllObjects];
    [self.processPoolDictionary removeAllObjects];
    
}

@end
