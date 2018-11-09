//
//  ResourceQuoteFolderModel.h
//  LeadingCloud
//
//  Created by SY on 2017/11/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceShareFolderModel.h"
@interface ResourceQuoteFolderModel : NSObject

/**
 被引用文件夹id
 */
@property (nonatomic ,strong) NSString *rqfid;



/**
 被引用文件夹名字
 */
@property (nonatomic ,strong) NSString *rqfname;

/**
 共享文件夹id
 */
@property (nonatomic ,strong) NSString *rsfid;
/**
 引用文件夹icon
 */
@property (nonatomic ,strong) NSString *icon;
/**
 共享文件夹model
 */
@property (nonatomic ,strong) ResourceShareFolderModel *rsfdata;

/**
 共享文档资源次id
 */
@property (nonatomic ,strong) NSString *rfrpid;

/**
 组织id
 */
@property (nonatomic ,strong) NSString *groupid;

/**
 组织名称
 */
@property (nonatomic ,strong) NSString *groupname;

/**
 被引用文件夹资源池id
 */
@property (nonatomic ,strong) NSString *rqrpid;

/**
 企业id
 */
@property (nonatomic ,strong) NSString *oid;

/**
 企业名称
 */
@property (nonatomic ,strong) NSString *orgname;

/**
 创建者
 */
@property (nonatomic ,strong) NSString *createuser;

/**
 被引用文件时间
 */
@property (nonatomic ,strong) NSDate *createdate;

@property (nonatomic, strong) NSDictionary *rsfDataDic;

@property (nonatomic, strong) NSString *rsid ;
@property (nonatomic, strong) NSString *appcode;
@property (nonatomic, strong) NSString *createusername ;
@property (nonatomic ,strong) NSString *rpid;
@property (nonatomic ,strong) NSString *rqid;
@property (nonatomic ,strong) NSString *rqname;
@property (nonatomic ,strong) NSString *rspaw;
@property (nonatomic, strong) NSString *rsstatus;
@property (nonatomic, strong) NSString *rsstatustype;
@property (nonatomic, strong) NSString *remarks;
@end
