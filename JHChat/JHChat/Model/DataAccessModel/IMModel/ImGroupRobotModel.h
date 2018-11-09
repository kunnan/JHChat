//
//  ImGroupRobotModel.h
//  LeadingCloud
//
//  Created by gjh on 2018/9/4.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImGroupRobotModel : NSObject

/// *主键-更新时必填
@property(nonatomic,strong) NSString *igrid;
/// *必填机器人信息表主键
@property(nonatomic,strong) NSString *riid;
/// *必填聊天群组ID
@property(nonatomic,strong) NSString *igid;
/// *必填机器人实例表主键
@property(nonatomic,strong) NSString *bussinessid;
/// *必填机器人群内名字
@property(nonatomic,strong) NSString *name;
/// 图标
@property(nonatomic,strong) NSString *icon;
/// 创建人
@property(nonatomic,strong) NSString *createuser;
/// 创建时间
@property (nonatomic,strong) NSDate *createtime;

@property (nonatomic, strong) NSString *templatecode;

@property (nonatomic, strong) NSString *linkconfig;


@end
