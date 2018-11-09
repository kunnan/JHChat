//
//  ResFileModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface ResFileModel : NSObject

/* 服务器端路径 */
@property(nonatomic,strong) NSString *serverpath;
/* 客户端文件路径 */
@property(nonatomic,strong) NSString *clientpath;
/* 客户端文件名称 */
@property(nonatomic,strong) NSString *clientname;

@end
