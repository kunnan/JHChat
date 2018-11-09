//
//  RemotelyServerModel.h
//  LeadingCloud
//
//  Created by SY on 2017/6/23.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemotelyServerModel : NSObject

/**
 主键
 */
@property (nonatomic, strong) NSString *rfsid;

/**
 服务器名称
 */
@property (nonatomic, strong) NSString *rfsname;

/**
 服务器类型(oss:阿里云,lzy:理正云)
 */
@property (nonatomic, strong) NSString *rfstype;

/**
 服务器地址
 */
@property (nonatomic, strong) NSString *rfsurl;

/**
 下载和操作的文件存放位置
 */
@property (nonatomic, strong) NSString *bucket;

/**
 文件读写
 */
@property (nonatomic, strong) NSString *readbucket;

/**
 存储规则
 */
@property (nonatomic, strong) NSString *path;

/**
 logo存储规则
 */
@property (nonatomic, strong) NSString *logopath;

/**
 图标存储规则
 */
@property (nonatomic, strong) NSString *iconpath;

/**
 
 im存储规则
 */
@property (nonatomic, strong) NSString *impath;

/**
 二维码存储规则
 */
@property (nonatomic, strong) NSString *qcpath;

/**
 最小分区
 */
@property (nonatomic, strong) NSString *minpartition;

/**
 最大分区
 */
@property (nonatomic, strong) NSString *maxpartition;

/**
 激活状态(1激活,0未激活)
 */
@property (nonatomic, assign) NSInteger activationstatus;

/**
 允许上传扩展名
 */
@property (nonatomic, strong) NSString *filetype_allow;

/**
 不允许上传扩展名
 */
@property (nonatomic, strong) NSString *filetype_unallow;

/**
 回掉地址
 */
@property (nonatomic, strong) NSString *callbackurl;

/**
 重定向地址
 */
@property (nonatomic, assign) NSInteger cname;
/**
 重定向地址
 */
@property (nonatomic, assign) NSString *cnamereadrfsurl;

@property (nonatomic, assign) NSInteger synchronizetype;
@end
