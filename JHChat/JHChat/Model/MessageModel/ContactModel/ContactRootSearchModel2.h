//
//  ContactRootSearchModel2.h
//  LeadingCloud
//
//  Created by gjh on 16/5/25.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactRootSearchModel2 : NSObject

/********************我的好友******************/
/* ID */
@property(nonatomic,copy) NSString *uid;
/* 名称 */
@property(nonatomic,copy) NSString *username;
/* 详细描述 */
@property(nonatomic,copy) NSString *des;
/* 头像 */
@property(nonatomic,copy) NSString *face;

/********************我的群组******************/
/* 群组ID */
@property(nonatomic,copy) NSString *gid;
@property(nonatomic,copy) NSString *igid;
/* 群名称 */
@property(nonatomic,copy) NSString *groupName;
@property(nonatomic,copy) NSString *name;
/* 群组类型 */
@property(nonatomic,assign) NSInteger imType;
@property(nonatomic,assign) NSInteger imtype;
/* 群组关联类型 */
@property(nonatomic,assign) NSInteger relateType;
@property(nonatomic,assign) NSInteger relatetype;

@end
