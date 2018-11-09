//
//  ServiceCirclesListItem.h
//  LeadingCloud
//
//  Created by wang on 17/3/28.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface ServiceCirclesListItem : NSObject

/* 主键 */
@property (nonatomic, strong) NSString *scid;
/* 服务圈名称 */
@property (nonatomic, strong) NSString *name;
/* 服务圈描述 */
@property (nonatomic, strong) NSString *des;
/* 服务圈组织ID */
@property (nonatomic, strong) NSString *oid;
/* 资源池ID */
@property (nonatomic, strong) NSString *resourcepoolid;
/* 状态 0：申请中,1：已开通,2：关闭 */
@property (nonatomic, assign) NSInteger status;
/* 主办方名称 */
@property (nonatomic, strong) NSString *orgname;
/* 成员数量 */
@property (nonatomic, assign) NSInteger membercount;
/* 服务圈配置信息 */
@property (nonatomic, strong) NSDictionary *config;
/* 服务圈类型*/
@property (nonatomic, strong) NSString *sctid;
/* 背景图*/
@property (nonatomic, strong) NSString *logo;
/* 头像*/
@property (nonatomic, strong) NSString *face;

/* 扩展id*/
@property (nonatomic, strong) NSString *extid;

/* 是否加入*/
@property (nonatomic, assign) BOOL isjoin;

@property (nonatomic, strong) NSArray *appcodelist;
@property (nonatomic, strong) NSString *appcode;

@property (nonatomic, strong) NSString *logofile;

@property (nonatomic, strong) NSString *firstlogo;

@property (nonatomic, assign) BOOL isfirstpage;



@end
