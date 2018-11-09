//
//  ResourceQuoteFolderOrgModel.h
//  LeadingCloud
//
//  Created by SY on 2017/11/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceQuoteFolderModel.h"
#import "ResourceShareFolderModel.h"
@interface ResourceQuoteFolderOrgModel : NSObject

/**
 企业id
 */
@property (nonatomic, strong) NSString *oid;
/**
 企业名称
 */
@property (nonatomic, strong) NSString *orgname;

/**
 被引用的文件夹信息
 */
@property (nonatomic, strong) NSMutableArray *quoteFolderArray;

///**
// 被引用的文件夹model
// */
//@property (nonatomic, strong) ResourceQuoteFolderModel *quoteFolderModel;

//@property (nonatomic, strong) NSDictionary *quoteFolderDic;
@end
