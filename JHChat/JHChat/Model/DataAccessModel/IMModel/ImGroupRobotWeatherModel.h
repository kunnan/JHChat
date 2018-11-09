//
//  ImGroupRobotWeather.h
//  LeadingCloud
//
//  Created by gjh on 2018/9/3.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImGroupRobotWeatherModel : NSObject

/// 主键
@property (nonatomic, copy) NSString *rwid;

/// 实例机器人 名称
@property (nonatomic, copy) NSString *name;

/// 实例机器人 头像
@property (nonatomic, copy) NSString *icon;

/// 实例机器人 推送时间是否开启 o:关闭 1:开启
@property (nonatomic, assign) NSInteger isopentime;

// 实例机器人 推送时间
@property (nonatomic, strong) NSDate *pushtime;

/// 实例机器人 推送省
@property (nonatomic, copy) NSString *province;

/// 实例机器人 推送城市
@property (nonatomic, copy) NSString *city;

/// 实例机器人 是否推送消息 0:关闭 1:开启
@property (nonatomic, assign) NSInteger ispushmessage;

/// 实例机器人添加时间
@property (nonatomic, strong) NSDate *addtime;

/// 群组id
@property (nonatomic, copy) NSString *igid;

/// *群组与机器人关系id      im_group_robot主键    更新机器人实例必填
//[LZDbField(Save = false)]
@property (nonatomic, copy) NSString *igrid;

/// *必填机器人信息表主键   robotinfo主键
//[LZDbField(Save = false)]
@property (nonatomic, copy) NSString *riid;

@end
