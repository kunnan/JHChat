//
//  GroupResourceModel.h
//  LeadingCloud
//
//  Created by gjh on 2018/7/25.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupResourceModel : NSObject
/*  */
@property(nonatomic,strong) NSString *igrid;
/* 外键 */
@property(nonatomic,strong) NSString *relateid;
/* 资源池 ID */
@property(nonatomic,strong) NSString *rpid;
/* 按钮标题 */
@property(nonatomic,strong) NSString *buttontitle;
@end
