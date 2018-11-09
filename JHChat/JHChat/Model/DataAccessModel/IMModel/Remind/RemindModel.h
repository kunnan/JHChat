//
//  RemindModel.h
//  LeadingCloud
//
//  Created by gjh on 2017/7/11.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindModel : NSObject
/* 主键id */
@property (nonatomic, copy) NSString *rid;
/* 用户所属id */
@property (nonatomic, copy) NSString *uid;
/* 提醒类型名称 */
@property (nonatomic, copy) NSString *rtname;
/* 上次提醒内容 */
@property (nonatomic, copy) NSString *lastremindcontent;
/* 上次提醒接收时间 */
@property (nonatomic, strong) NSDate *lastreminddate;
/* 提醒类型code */
@property (nonatomic, copy) NSString *rtcode;
/* 提醒类型图标 */
@property (nonatomic, copy) NSString *rticon;
/* 待办数量 */
@property (nonatomic, assign) NSInteger count;
/* 是否已读 */
@property (nonatomic, assign) NSInteger isread;
/* 所属企业id */
@property (nonatomic, copy) NSString *oeid;

@end
