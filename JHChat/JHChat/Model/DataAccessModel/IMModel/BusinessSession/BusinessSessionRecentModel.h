//
//  BusinessSessionRecentModel.h
//  LeadingCloud
//
//  Created by gjh on 17/4/5.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessSessionRecentModel : NSObject

/* 主键ID */
@property (nonatomic, strong) NSString *bsguid;
/* 业务会话实例Id */
@property (nonatomic, copy) NSString *bsiid;
/*  */
@property (nonatomic, copy) NSString *bid;
/* 业务会话类型ID */
@property (nonatomic, copy) NSString *bsid;
/* 标题 */
@property (nonatomic, copy) NSString *title;
/* 办理类型（0咨询，1办理） */
@property (nonatomic, assign) NSInteger stype;
/* 专业类型（0对内，1对外） */
@property (nonatomic, assign) NSInteger bstype;
/* 业务名称 */
@property (nonatomic, copy) NSString *bname;
/* 消息群组ID */
@property (nonatomic, copy) NSString *targetid;
/* 是否为主会话 */
@property (nonatomic, assign) BOOL ismain;
/*  */
@property (nonatomic, copy) NSString *face;
/* 参与会话的成员数量 */
@property (nonatomic, assign) NSInteger memberCount;
/* 群组建立者 */
@property (nonatomic, copy) NSString *creator;
/* 实例名 */
@property (nonatomic, copy) NSString *instancename;
/* 会话创建人 */
@property (nonatomic, copy) NSString *creteusername;
/* 会话对象公司名 */
@property (nonatomic, copy) NSString *targetorgname;
/* 是否可用（PC端） */
@property (nonatomic, assign) BOOL useabled;
/* 相关人员实例 */
@property(nonatomic,strong) NSDictionary *instance;



@end
