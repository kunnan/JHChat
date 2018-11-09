//
//  ResourceShareFolderModel.h
//  LeadingCloud
//
//  Created by SY on 2017/11/25.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  sy
 Date：   2017-11-25
 Version: 1.0
 Description: 协作共享文件夹
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface ResourceShareFolderModel : NSObject

/**
 创建者id
 */
@property (nonatomic, strong) NSString *createuser;
/**
 icon
 */
@property (nonatomic, strong) NSString *icon;
/**
 创建日期
 */
@property (nonatomic, strong) NSDate *createdate;
/**
 共享文件夹id
 */
@property (nonatomic, strong) NSString *folderid;
/**
 文件夹名
 */
@property (nonatomic, strong) NSString *foldername;
/**
 密码
 */
@property (nonatomic, strong) NSString *password;
/**
 资源次id
 */
@property (nonatomic, strong) NSString *rpid;
/**
 共享id
 */
@property (nonatomic, strong) NSString *rsfid;
/**
 共享名
 */
@property (nonatomic, strong) NSString *rsfname;
/**
 共享类型 1：私密 2：公开
 */
@property (nonatomic, strong) NSString *rsftype;
@end
