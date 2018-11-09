//
//  ImGroupCallModel.h
//  LeadingCloud
//
//  Created by gjh on 2017/8/4.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImGroupCallModel : NSObject
/* 通话的群组id */
@property (nonatomic, copy) NSString *groupid;
/* 通话的群组状态 */
@property (nonatomic, copy) NSString *status;
/* 通话人员 */
@property (nonatomic, copy) NSString *chatusers;
/* 人员个数 */
@property (nonatomic, assign) NSInteger usercout;
/* 真正在房间里面通话的人 */
@property (nonatomic, copy) NSString *realchatusers;
/* 真正在聊天的人数 */
@property (nonatomic, assign) NSInteger realusercount;
/* 开始时间 */
@property (nonatomic, strong) NSDate *starttime;
/* 更新时间 */
@property (nonatomic, strong) NSDate *updatetime;
/* 房间id */
@property (nonatomic, copy) NSString *roomname;
/* 插件是否弹出等待接听界面 */
@property (nonatomic, copy) NSString *iscallother;

/* 视频发起者 */
@property (nonatomic, copy) NSString *initiateuid;

@end
