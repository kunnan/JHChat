//
//  OrgAdminModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 管理员表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface OrgAdminModel : NSObject

/* 主键 */
@property(nonatomic,strong) NSString *oaid;
/* 组织ID */
@property(nonatomic,strong) NSString *oid;
/* 用户ID */
@property(nonatomic,strong) NSString *uid;
/* 所属组织 */
@property(nonatomic,strong) NSString *oeid;
@end
