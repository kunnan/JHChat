//
//  MessageRootSearchModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/4/5.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageRootSearchModel : NSObject

/* 联系人ID */
@property(nonatomic,strong) NSString *contactid;
/* 联系人名称 */
@property(nonatomic,strong) NSString *contactname;
/* 联系人类型(0:单人，1:群组 2:其它群组) */
@property(nonatomic,assign) NSInteger contacttype;
/* 群组关联类型(0:组 1:项 2:任 3:部 4:企) */
@property(nonatomic,assign) NSInteger relatetype;
/* 头像 */
@property(nonatomic,strong) NSString *face;

@end
