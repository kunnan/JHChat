//
//  ChatOneSettingController.h
//  LeadingCloud
//
//  Created by wchMac on 16/3/1.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-01
 Version: 1.0
 Description: 单人，聊天设置界面
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "XHBaseViewController.h"
#import "UserModel.h"
#import "MWPhotoBrowser.h"
#import "ChatSettingController.h"
#import "ChatSettingChangeBackGroundDelegate.h"

@interface ChatOneSettingController : ChatSettingController<UITableViewDelegate,UITableViewDataSource,EventSyncSubscriber,UIAlertViewDelegate>

@property (strong, nonatomic) UserModel *toUserModel;

@property (nonatomic, assign) id<ChatSettingChangeBackGroundDelegate> changeDelegate;

@end
