//
//  UploadFileModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/4/7.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadFileModel : NSObject

/* 图片字节 */
@property(nonatomic, strong) NSData *data;

/* 文件在磁盘上的名称 */
@property(nonatomic, strong) NSString *filePhysicalName;

/* 文件显示名称 */
@property(nonatomic, strong) NSString *fileShowName;

/* 顺序号 */
@property(nonatomic, assign) NSInteger showIndex;

@end
