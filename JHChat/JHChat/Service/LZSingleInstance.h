//
//  LZSingleInstance.h
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

#import <Foundation/Foundation.h>

@interface LZSingleInstance : NSObject

- (instancetype)init;

/**
 *  聊天界面
 */
@property (strong, nonatomic) NSMutableDictionary *chatDialogDictionary;

/**
 *  云盘
 */
@property (strong, nonatomic) NSMutableDictionary *netDiskDictionary;
/**
 *  协作文件
 */
@property (strong, nonatomic) NSMutableDictionary *CooFileDictionary;

/**
 *  文件下载
 */
@property (strong, nonatomic) NSMutableDictionary *fileDownloadDictionary;

/* 用来添加控制器名称的数组 */
@property (strong, nonatomic) NSMutableArray *viewControllerArr;

/**
 *  WKProcessPool 实例
 */
@property (strong, nonatomic) NSMutableDictionary *processPoolDictionary;

/**
 *  移除指定的云盘实例
 *
 *  @param key 主键
 */
-(void)removeNetDiskInstance:(NSString *)key;
/**
 *  移除指定的协作文件实例
 *
 *  @param key 主键
 */
-(void)removeCooFileInstance:(NSString *)key;

/**
 *  移除文件下载实例
 *
 *  @param key 主键
 */
-(void)removeFileDownloadInstance:(NSString *)key;

/**
 *  清除所有的缓存实例
 */
-(void)clearAll;

@end
